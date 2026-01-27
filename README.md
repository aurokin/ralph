# Ralph

Ralph is an autonomous AI agent loop that runs opencode (default) or gemini repeatedly until all PRD items are complete. Each iteration is a fresh CLI session with clean context. Memory persists via git history, `progress.txt`, and `prd.json`.

Based on [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/).

[Read my in-depth article on how I use Ralph](https://x.com/ryancarson/status/2008548371712135632)

## Prerequisites

- opencode CLI installed and authenticated (default runner)
- gemini CLI installed and authenticated (for `ralph_gemini.sh`)
- `jq` installed (`brew install jq` on macOS)
- A git repository for your project

## Setup

### Option 1: Copy to your project

Copy the ralph files into your project:

```bash
# From your project root
mkdir -p scripts/ralph
cp /path/to/ralph/ralph_opencode.sh scripts/ralph/
cp /path/to/ralph/ralph_gemini.sh scripts/ralph/
cp /path/to/ralph/prompt.md scripts/ralph/
chmod +x scripts/ralph/ralph_opencode.sh scripts/ralph/ralph_gemini.sh
```

### Option 1a: Deploy script

Use the deploy script to copy `ralph_opencode.sh`, `ralph_gemini.sh`, and `prompt.md` into a target folder:

```bash
./deploy.zsh ~/path/to/your/project/scripts/ralph
```

### Option 2: Install skills globally

Copy the skills to your opencode config for use across all projects:

```bash
cp -r skills/prd ~/.config/opencode/skills/
cp -r skills/ralph ~/.config/opencode/skills/
```

### Configure opencode auto-handoff (recommended)

Add to `~/.config/opencode/settings.json`:

```json
{
  "opencode.experimental.autoHandoff": { "context": 90 }
}
```

This enables automatic handoff when context fills up, allowing Ralph to handle large stories that exceed a single context window.

## Workflow

### 1. Create a PRD

Use the PRD skill to generate a detailed requirements document:

```
Load the prd skill and create a PRD for [your feature description]
```

Answer the clarifying questions. The skill saves output to `tasks/prd-[feature-name].md`.

### 2. Convert PRD to Ralph format

Use the Ralph skill to convert the markdown PRD to JSON:

```
Load the ralph skill and convert tasks/prd-[feature-name].md to prd.json
```

This creates `prd.json` with user stories structured for autonomous execution.

### 3. Run Ralph

```bash
# Default (opencode)
./scripts/ralph/ralph_opencode.sh [max_iterations]

# Gemini variant
./scripts/ralph/ralph_gemini.sh [max_iterations]
```

Default is 10 iterations. opencode is the default runner.

Ralph will:
1. Pick the highest priority story where `passes: false`
2. Implement that single story
3. Run quality checks (typecheck, tests)
4. Commit if checks pass
5. Update `prd.json` to mark story as `passes: true`
6. Append learnings to `progress.txt`
7. Repeat until all stories pass or max iterations reached

## Key Files

| File | Purpose |
|------|---------|
| `ralph_opencode.sh` | The bash loop that spawns fresh opencode sessions |
| `ralph_gemini.sh` | The bash loop that spawns fresh gemini sessions |
| `prompt.md` | Instructions given to each session |
| `prd.json` | User stories with `passes` status (the task list) |
| `prd.json.example` | Example PRD format for reference |
| `progress.txt` | Append-only learnings for future iterations |
| `skills/prd/` | Skill for generating PRDs |
| `skills/ralph/` | Skill for converting PRDs to JSON |

## Variants

### Known Differences

- `ralph_opencode.sh` uses `opencode run --share` and can output a share URL; `ralph_gemini.sh` runs in plain text and does not capture session IDs by default.
- `ralph_opencode.sh` uses `VARIANT` via `--variant`; `ralph_gemini.sh` does not support variants.

### Keeping Variants in Sync

- Update both `ralph_opencode.sh` and `ralph_gemini.sh` when changing loop behavior or prompt handling.
- Update the "Known Differences" list whenever the variants diverge.
- Ensure `deploy.sh` continues to ship both scripts.

## Critical Concepts

### Each Iteration = Fresh Context

Each iteration spawns a **new CLI session** (opencode or gemini) with clean context. The only memory between iterations is:
- Git history (commits from previous iterations)
- `progress.txt` (learnings and context)
- `prd.json` (which stories are done)

### Small Tasks

Each PRD item should be small enough to complete in one context window. If a task is too big, the LLM runs out of context before finishing and produces poor code.

Right-sized stories:
- Add a database column and migration
- Add a UI component to an existing page
- Update a server action with new logic
- Add a filter dropdown to a list

Too big (split these):
- "Build the entire dashboard"
- "Add authentication"
- "Refactor the API"

### AGENTS.md Updates Are Critical

After each iteration, Ralph updates the relevant `AGENTS.md` files with learnings. This is key because the agent reads these files, so future iterations (and future human developers) benefit from discovered patterns, gotchas, and conventions.

Examples of what to add to AGENTS.md:
- Patterns discovered ("this codebase uses X for Y")
- Gotchas ("do not forget to update Z when changing W")
- Useful context ("the settings panel is in component X")

### Feedback Loops

Ralph only works if there are feedback loops:
- Typecheck catches type errors
- Tests verify behavior
- CI must stay green (broken code compounds across iterations)

### Stop Condition

When all stories have `passes: true`, Ralph exits the loop.

## Debugging

Check current state:

```bash
# See which stories are done
cat prd.json | jq '.userStories[] | {id, title, passes}'

# See learnings from previous iterations
cat progress.txt

# Check git history
git log --oneline -10
```

## Customizing prompt.md

Edit `prompt.md` to customize Ralph's behavior for your project:
- Add project-specific quality check commands
- Include codebase conventions
- Add common gotchas for your stack

## References

- [Geoffrey Huntley's Ralph article](https://ghuntley.com/ralph/)
