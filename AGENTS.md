# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs opencode repeatedly until all PRD items are complete. Each iteration is a fresh opencode session with clean context.

## Commands

```bash
# Run Ralph (from your project that has prd.json)
./ralph_opencode.sh [max_iterations]
```

## Key Files

- `ralph_opencode.sh` - Simplified loop that spawns fresh opencode sessions
- `prompt.md` - Instructions given to each opencode session
- `prd.json.example` - Example PRD format
## Patterns

- Each iteration spawns a fresh opencode session with clean context
- `ralph_opencode.sh` sets `MODEL` and `VARIANT` for opencode runs
- Avoid `tee /dev/stderr` with `opencode run` to prevent duplicate output
- Memory persists via git history, `progress.txt`, and `prd.json`
- Stories should be small enough to complete in one context window
- Use opencode terminology consistently in documentation
- Always update AGENTS.md with discovered patterns for future iterations
