#!/usr/bin/env bash
# Prints the tutor context that every design-tutor skill injects:
# shared rules, knowledge levels, the project's TUTOR.md and learning memory.
#
# Usage: context.sh <project-dir> [--with-templates]
#
# Always exits 0: a failing injection command would abort the whole skill,
# and a missing file must never block the student.

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_DIR="${1:-$PWD}"
WITH_TEMPLATES="${2:-}"

section() {
  printf '\n<%s>\n' "$1"
  if [ -f "$2" ]; then
    cat "$2"
  else
    printf '%s\n' "$3"
  fi
  printf '</%s>\n' "$1"
}

printf 'Today: %s\n' "$(date +%Y-%m-%d)"
printf 'Project folder: %s\n' "$PROJECT_DIR"

section tutor-rules "$PLUGIN_ROOT/tutor/RULES.md" "(rules file missing from the plugin)"
section knowledge-levels "$PLUGIN_ROOT/tutor/LEVELS.md" "(levels file missing from the plugin)"
section project-config "$PROJECT_DIR/TUTOR.md" \
  "No TUTOR.md in this project. Use the defaults: Beginner in every area, infer the tech stack and learning goals from the files. Suggest /design-tutor:setup once, in one line."
section learning-memory "$PROJECT_DIR/.tutor/memory.md" \
  "No learning memory yet. Create .tutor/memory.md from the memory format in the rules on the first write."

cat <<EOF

<memory-helper>
Update the learning memory with ONE call per exchange (several operations can share the call):
bash "$PLUGIN_ROOT/scripts/memory.sh" "$PROJECT_DIR" <op> "<key>" "<value>" [<op> "<key>" "<value>"]...
  seen          "[Area] concept"  "note"               add/replace in Seen (no-op if already Learned)
  learned       "[Area] concept"  "evidence"           move to Learned (clears Seen and Misconceptions)
  misconception "[Area] concept"  "the mix-up"         move to Misconceptions (clears Learned and Seen)
  question      "[Area] question" correct|incorrect|skipped
Use the exact same key for the same concept or question. The date is added automatically.
</memory-helper>
EOF

if [ "$WITH_TEMPLATES" = "--with-templates" ]; then
  section tutor-config-template "$PLUGIN_ROOT/tutor/TUTOR.template.md" "(template missing)"
  section memory-template "$PLUGIN_ROOT/tutor/memory.template.md" "(template missing)"
fi

exit 0
