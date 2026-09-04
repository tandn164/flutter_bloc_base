#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT/tool/scaffold/common.sh"
NAME="${NAME:-}"
TYPE="${TYPE:-dart}"
require_name NAME "$NAME"
python3 "$ROOT/tool/scaffold/shared_package.py" create "$ROOT" "$NAME" "$TYPE"
ensure_workspace_line "$ROOT/pubspec.yaml" "  - shared/$NAME"
echo "==> Resolve workspace dependencies"
(cd "$ROOT" && fvm dart pub get) || {
  echo "Package created, but dependency resolution failed. Fix the reported error and run make get." >&2
  exit 1
}
echo "Created shared/$NAME ($TYPE). No app dependency or DI registration was added."
echo "Read shared/$NAME/README.md for usage and testing."
