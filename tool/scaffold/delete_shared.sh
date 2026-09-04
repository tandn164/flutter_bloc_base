#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT/tool/scaffold/common.sh"
NAME="${NAME:-}"
require_name NAME "$NAME"
python3 "$ROOT/tool/scaffold/shared_package.py" check-delete "$ROOT" "$NAME"
if [[ "${CONFIRM:-0}" != "1" ]]; then
  echo "This will unregister shared/$NAME and move it into .scaffold-trash/ (recoverable)."
  echo "Run: make delete-shared NAME=$NAME CONFIRM=1"
  exit 1
fi
backup="$(python3 "$ROOT/tool/scaffold/shared_package.py" delete "$ROOT" "$NAME")"
remove_workspace_line "$ROOT/pubspec.yaml" "  - shared/$NAME"
echo "Removed shared/$NAME from the workspace. Recoverable backup: $backup"
echo "To restore: move the backup to shared/$NAME, restore its workspace entry, then run make get."
(cd "$ROOT" && fvm dart pub get) || {
  echo "Removal completed, but dependency resolution failed. The backup remains at $backup. Run make get after resolving the error." >&2
  exit 1
}
