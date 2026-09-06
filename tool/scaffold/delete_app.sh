#!/usr/bin/env bash
# Remove apps/<name> and unregister it from the Dart workspace + IDE configs.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/tool/scaffold/common.sh"

NAME="${NAME:-}"
CONFIRM="${CONFIRM:-0}"
PROTECTED="${PROTECTED:-sample_app}"
ALLOW_DELETE_SAMPLE="${ALLOW_DELETE_SAMPLE:-0}"

require_name "NAME" "$NAME"

APP_DIR="$ROOT/apps/$NAME"
if [[ ! -d "$APP_DIR" ]]; then
  echo "error: apps/$NAME not found" >&2
  exit 1
fi

FALLBACK_APP=""
for manifest in "$ROOT"/apps/*/pubspec.yaml; do
  [[ -e "$manifest" ]] || continue
  candidate="$(basename "$(dirname "$manifest")")"
  if [[ "$candidate" != "$NAME" ]]; then
    FALLBACK_APP="$candidate"
    break
  fi
done

if [[ "$NAME" == "$PROTECTED" && "$ALLOW_DELETE_SAMPLE" != "1" ]]; then
  cat >&2 <<EOF
error: apps/$PROTECTED is the protected reference app.

Create or keep another app, then explicitly allow deleting the sample:
  CONFIRM=1 ALLOW_DELETE_SAMPLE=1 make delete-app NAME=$PROTECTED
EOF
  exit 1
fi

if [[ -z "$FALLBACK_APP" ]]; then
  echo "error: refusing to delete apps/$NAME because it is the workspace's last app" >&2
  echo "Create another app first: make new-app NAME=my_app SOURCE=$NAME" >&2
  exit 1
fi

if [[ "$CONFIRM" != "1" ]]; then
  cat <<EOF
This will permanently delete apps/${NAME} and remove its workspace / IDE entries.

Run with confirmation:
  CONFIRM=1 make delete-app NAME=${NAME}

EOF
  exit 1
fi

info() { echo "==> $*"; }

info "remove apps/$NAME"
rm -rf "$APP_DIR"

info "unregister workspace app"
remove_workspace_line "$ROOT/pubspec.yaml" "  - apps/$NAME"

if grep -qE "^(APP|SOURCE)[[:space:]]*\\?=[[:space:]]*$NAME$" "$ROOT/Makefile"; then
  info "use $FALLBACK_APP as the default app"
  python3 - <<'PY' "$ROOT/Makefile" "$NAME" "$FALLBACK_APP"
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
deleted = re.escape(sys.argv[2])
fallback = sys.argv[3]
text = path.read_text()
text = re.sub(
    rf'^(APP|SOURCE)(\s*\?=\s*){deleted}$',
    lambda match: f'{match.group(1)}{match.group(2)}{fallback}',
    text,
    flags=re.MULTILINE,
)
path.write_text(text)
PY
fi

IDEA="$ROOT/.idea"
RUN_CONFIG="$IDEA/runConfigurations/${NAME}.xml"
if [[ -f "$RUN_CONFIG" ]]; then
  info "remove run configuration $NAME"
  rm -f "$RUN_CONFIG"
fi

if [[ -f "$IDEA/modules.xml" ]]; then
  info "update .idea/modules.xml"
  python3 - <<'PY' "$IDEA/modules.xml" "$NAME"
import pathlib
import sys
import xml.etree.ElementTree as ET

path = pathlib.Path(sys.argv[1])
app = sys.argv[2]
module_path = f"$PROJECT_DIR$/apps/{app}/{app}.iml"

tree = ET.parse(path)
root = tree.getroot()
modules = root.find(".//modules")
if modules is not None:
    for module in list(modules.findall("module")):
        if module.get("filepath") == module_path:
            modules.remove(module)
            break
    tree.write(str(path), encoding="UTF-8", xml_declaration=True)
PY
fi

if [[ -f "$IDEA/dart.xml" ]]; then
  info "disable Dart module $NAME"
  python3 - <<'PY' "$IDEA/dart.xml" "$NAME"
import pathlib
import sys
import xml.etree.ElementTree as ET

path = pathlib.Path(sys.argv[1])
app = sys.argv[2]

tree = ET.parse(path)
root = tree.getroot()
list_el = root.find(".//option[@name='modules']/list")
if list_el is not None:
    for option in list(list_el.findall("option")):
        if option.get("value") == app:
            list_el.remove(option)
            break
    tree.write(str(path), encoding="UTF-8", xml_declaration=True)
PY
fi

VSCODE="$ROOT/.vscode/settings.json"
if [[ -f "$VSCODE" ]]; then
  info "remove apps/$NAME from .vscode projectRoots"
  python3 - <<'PY' "$VSCODE" "$NAME"
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
app = f"apps/{sys.argv[2]}"
data = json.loads(path.read_text())
roots = data.get("dart.projectRoots", [])
if app in roots:
    data["dart.projectRoots"] = [root for root in roots if root != app]
    path.write_text(json.dumps(data, indent=2) + "\n")
PY
fi

info "dart pub get"
(cd "$ROOT" && fvm dart pub get >/dev/null)

cat <<EOF

Removed apps/${NAME}.

Restart Android Studio if the run configuration still appears in the dropdown.

EOF
