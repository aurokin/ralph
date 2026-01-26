# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs opencode repeatedly until all PRD items are complete. Each iteration is a fresh opencode session with clean context.

## Commands

```bash
# Run Ralph (from your project that has prd.json)
./ralph.sh [max_iterations]
# Run Ralph v2 (simplified loop)
./ralph_v2.sh [max_iterations]
```

## Key Files

- `ralph.sh` - The bash loop that spawns fresh opencode sessions
- `ralph_v2.sh` - Simplified loop with configurable model/variant
- `prompt.md` - Instructions given to each opencode session
- `prd.json.example` - Example PRD format
## Patterns

- Each iteration spawns a fresh opencode session with clean context
- `ralph_v2.sh` sets `MODEL` and `VARIANT` for opencode runs
- Avoid `tee /dev/stderr` with `opencode run` to prevent duplicate output
- Memory persists via git history, `progress.txt`, and `prd.json`
- Stories should be small enough to complete in one context window
- Always update AGENTS.md with discovered patterns for future iterations
