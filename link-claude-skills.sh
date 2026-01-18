#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_dir="$script_dir/skills"
claude_skills_dir="$HOME/.claude/skills"

mkdir -p "$claude_skills_dir"

for skill_path in "$skills_dir"/*; do
  if [ -d "$skill_path" ]; then
    skill_name="$(basename "$skill_path")"
    ln -sfn "$skill_path" "$claude_skills_dir/$skill_name"
  fi
done

echo "Linked skills from $skills_dir to $claude_skills_dir"
