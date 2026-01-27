# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs opencode (default) or gemini repeatedly until all PRD items are complete. Each iteration is a fresh CLI session with clean context.

## Commands

```bash
# Run Ralph (from your project that has prd.json)
./ralph_opencode.sh [max_iterations]

# Gemini variant
./ralph_gemini.sh [max_iterations]
```

## Key Files

- `ralph_opencode.sh` - Simplified loop that spawns fresh opencode sessions
- `ralph_gemini.sh` - Simplified loop that spawns fresh gemini sessions
- `prompt.md` - Instructions given to each session
- `prd.json.example` - Example PRD format
## Patterns

- Each iteration spawns a fresh CLI session with clean context
- `ralph_opencode.sh` sets `MODEL` and `VARIANT` for opencode runs
- `ralph_gemini.sh` uses `MODEL` and `--yolo` for gemini runs
- Avoid `tee /dev/stderr` with `opencode run` to prevent duplicate output
- Keep `ralph_opencode.sh` and `ralph_gemini.sh` in sync; update the README "Known Differences" list when they diverge
- Memory persists via git history, `progress.txt`, and `prd.json`
- Stories should be small enough to complete in one context window
- Use CLI terminology consistent with the variant being described
- `<promise>COMPLETE</promise>` output is removed and should not be referenced
- Always update AGENTS.md with discovered patterns for future iterations
