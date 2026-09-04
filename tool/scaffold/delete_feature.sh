#!/usr/bin/env bash
# Remove feature packages and optionally unwire app DI and router.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/tool/scaffold/common.sh"

NAME="${NAME:-}"
APP="${APP:-sample_app}"
WIRE="${WIRE:-1}"
CONFIRM="${CONFIRM:-0}"
PROTECTED="${PROTECTED:-auth,sample,profile,onboarding}"

require_name "NAME" "$NAME"

IFS=',' read -r -a protected_features <<<"$PROTECTED"
for protected in "${protected_features[@]}"; do
  if [[ "$NAME" == "$protected" ]]; then
    echo "error: refusing to delete protected feature '$NAME'" >&2
    exit 1
  fi
done

FEATURE_DIR="$ROOT/features/$NAME"
if [[ ! -d "$FEATURE_DIR" ]]; then
  echo "error: features/$NAME not found" >&2
  exit 1
fi

APP_DIR="$ROOT/apps/$APP"
if [[ "$WIRE" == "1" && ! -f "$APP_DIR/pubspec.yaml" ]]; then
  echo "error: apps/$APP not found" >&2
  exit 1
fi

if [[ "$WIRE" == "1" ]]; then
  while IFS= read -r -d '' pubspec; do
    app_name="$(basename "$(dirname "$pubspec")")"
    [[ "$app_name" == "$APP" ]] && continue
    if grep -Fq "${NAME}_domain:" "$pubspec"; then
      echo "error: apps/$app_name still depends on ${NAME}; remove wiring there first or use WIRE=0" >&2
      exit 1
    fi
  done < <(find "$ROOT/apps" -name pubspec.yaml -print0)
fi

if [[ "$CONFIRM" != "1" ]]; then
  cat <<EOF
This will permanently delete features/${NAME} and remove workspace entries.
$( [[ "$WIRE" == "1" ]] && echo "It will also unwire apps/${APP} (adapter, pubspec, di.dart, app_router.dart, boundary test)." )

Run with confirmation:
  CONFIRM=1 make delete-feature NAME=${NAME} APP=${APP}

Packages only (keep app wiring to remove manually):
  CONFIRM=1 WIRE=0 make delete-feature NAME=${NAME}

EOF
  exit 1
fi

PASCAL="$(to_pascal "$NAME")"

info() { echo "==> $*"; }

if [[ "$WIRE" == "1" ]]; then
  info "unwire apps/$APP"
  python3 "$ROOT/tool/scaffold/wire_feature.py" unwire "$APP_DIR" "$NAME" "$PASCAL" public
  remove_pubspec_dependency "$APP_DIR/pubspec.yaml" "${NAME}_domain"
  remove_pubspec_dependency "$APP_DIR/pubspec.yaml" "${NAME}_data"
  remove_pubspec_dependency "$APP_DIR/pubspec.yaml" "${NAME}_presentation"

  ADAPTER="$APP_DIR/lib/app/features/${NAME}_feature.dart"
  if [[ -f "$ADAPTER" ]]; then
    info "remove adapter ${NAME}_feature.dart"
    rm -f "$ADAPTER"
  fi
  # Generated companion files belong to this explicitly selected feature only.
  rm -f "$APP_DIR/lib/app/features/${NAME}_feature.g.dart"
  rm -f "$APP_DIR/lib/app/features/$NAME/${NAME}_routes.dart" \
    "$APP_DIR/lib/app/features/$NAME/${NAME}_routes.g.dart"
  rm -f "$APP_DIR/lib/app/features/$NAME/${NAME}_di.dart" \
    "$APP_DIR/lib/app/features/$NAME/${NAME}_di.config.dart"
  if [[ -d "$APP_DIR/lib/app/features/$NAME" ]]; then
    rmdir "$APP_DIR/lib/app/features/$NAME" 2>/dev/null || true
  fi

  BOUNDARY_TEST="$APP_DIR/test/app/package_boundary_test.dart"
  if [[ -f "$BOUNDARY_TEST" ]]; then
    info "update package boundary test"
    python3 - <<'PY' "$BOUNDARY_TEST" "$NAME"
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
name = sys.argv[2]
text = path.read_text()
pattern = r"for \(final feature in \[([^\]]*)\]\)"
match = re.search(pattern, text)
if not match:
    raise SystemExit(0)
items = [item.strip().strip("'") for item in match.group(1).split(",") if item.strip()]
if name not in items:
    raise SystemExit(0)
items = [item for item in items if item != name]
replacement = "for (final feature in [" + ", ".join(f"'{item}'" for item in items) + "])"
text = re.sub(pattern, replacement, text, count=1)
path.write_text(text)
PY
  fi
fi

info "unregister workspace packages"
remove_workspace_line "$ROOT/pubspec.yaml" "  - features/${NAME}/${NAME}_domain"
remove_workspace_line "$ROOT/pubspec.yaml" "  - features/${NAME}/${NAME}_data"
remove_workspace_line "$ROOT/pubspec.yaml" "  - features/${NAME}/${NAME}_presentation"

info "remove features/$NAME"
rm -rf "$FEATURE_DIR"

info "dart pub get"
(cd "$ROOT" && fvm dart pub get >/dev/null)

cat <<EOF

Removed features/${NAME}.
$( [[ "$WIRE" == "1" ]] && echo "Unwired from apps/${APP}." )

Next:
  make lint APP=${APP}
  make test APP=${APP}

EOF
