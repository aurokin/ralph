#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR=${0:a:h}
TARGET_PATH=${1:-}

if [[ -z "$TARGET_PATH" ]]; then
  echo "Usage: $0 <target-directory>"
  exit 1
fi

TARGET_PATH=${~TARGET_PATH}

if [[ ! -d "$TARGET_PATH" ]]; then
  echo "Error: '$TARGET_PATH' is not a directory."
  exit 1
fi

if [[ ! -w "$TARGET_PATH" ]]; then
  echo "Error: '$TARGET_PATH' is not writable."
  exit 1
fi

WRITE_TEST="$TARGET_PATH/.ralph_write_test.$$"
if ! touch "$WRITE_TEST" 2>/dev/null; then
  echo "Error: Cannot write to '$TARGET_PATH'."
  exit 1
fi
rm -f "$WRITE_TEST"

rm -f "$TARGET_PATH/ralph_opencode.sh" "$TARGET_PATH/ralph_gemini.sh" "$TARGET_PATH/prompt.md"

if [[ ! -f "$SCRIPT_DIR/ralph_opencode.sh" || ! -f "$SCRIPT_DIR/ralph_gemini.sh" || ! -f "$SCRIPT_DIR/prompt.md" ]]; then
  echo "Error: ralph_opencode.sh, ralph_gemini.sh, or prompt.md not found in $SCRIPT_DIR"
  exit 1
fi

cp "$SCRIPT_DIR/ralph_opencode.sh" "$SCRIPT_DIR/ralph_gemini.sh" "$SCRIPT_DIR/prompt.md" "$TARGET_PATH/"

echo "Deployed ralph_opencode.sh, ralph_gemini.sh, and prompt.md to $TARGET_PATH"