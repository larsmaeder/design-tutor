---
name: progress
description: Show a short, encouraging summary of what the student has learned so far, per knowledge area, and what to look at next.
disable-model-invocation: true
allowed-tools: Bash(bash *scripts/context.sh*)
model: haiku
effort: low
---

# Progress

Give the student a short, encouraging overview of their learning so far, based on the learning memory and `TUTOR.md` below. This is read-only: don't edit any files, except the optional level update in step 4.

Structure:

1. **One line overall:** e.g. "You've learned 6 concepts across 3 areas."
2. **Per area** (only areas that have entries or learning goals), one short line each with:
   - the area name and its current level;
   - what's **Learned**;
   - what's in progress (**Seen**, **Misconceptions**), framed as "next to firm up", never as failure.
3. **Next steps:** one or two suggestions, taken from learning goals that aren't **Learned** yet.
4. **Level suggestion** (only if it applies): if most goals in an area are **Learned**, end with one AskUserQuestion call: "Raise <area> to <level>?", with the options "Yes" and "Not yet".
   - **"Yes":** update that line in `TUTOR.md`. This is the only file edit allowed in this skill.
   - **"Not yet" or dismissed:** leave everything as it is.

If there's no memory yet, say so in one friendly line and suggest trying `/design-tutor:tutor` or `/design-tutor:quiz`.

!`bash "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" "${CLAUDE_PROJECT_DIR}"`
