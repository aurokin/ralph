#!/bin/bash
# Ralph gemini - simplified gemini loop
# Usage: ./ralph_gemini.sh [max_iterations]

set -e

MODEL="gemini-3-pro"
MAX_ITERATIONS=${1:-10}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROGRESS_FILE="$SCRIPT_DIR/progress.txt"

if [ ! -f "$PROGRESS_FILE" ]; then
  echo "# Ralph Progress Log" > "$PROGRESS_FILE"
  echo "Started: $(date)" >> "$PROGRESS_FILE"
  echo "---" >> "$PROGRESS_FILE"
fi

echo "Starting Ralph gemini - Max iterations: $MAX_ITERATIONS"
echo "Model: $MODEL"

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  Ralph Iteration $i of $MAX_ITERATIONS"
  echo "═══════════════════════════════════════════════════════"

  gemini --prompt "$(cat "$SCRIPT_DIR/prompt.md")" --model "$MODEL" --yolo 2>&1

  echo "Iteration $i complete. Continuing..."
  sleep 2
done

echo ""
echo "Ralph reached max iterations ($MAX_ITERATIONS)."
echo "Check $PROGRESS_FILE for status."
exit 0
