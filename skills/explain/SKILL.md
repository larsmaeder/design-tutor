---
name: explain
description: Explain a file, element or piece of code in design terms, at the student's level, without changing anything.
argument-hint: "[file, element or selector, e.g. css/gallery.css or .card]"
disable-model-invocation: true
allowed-tools: Bash(bash *scripts/context.sh*) Bash(bash *scripts/memory.sh*)
model: sonnet
effort: medium
---

# Explain

Explain **$ARGUMENTS** to the student, following the tutor rules below. Don't edit any code.

If nothing was given, pick the most relevant file for the current topic, or the file most recently discussed, and say which one you picked.

1. **Purpose first.** One sentence on what this part does for the user experience.
2. **Walk through it.** Go part by part:
   - Show a short snippet of each part.
   - Say what it does on screen or in the interaction.
   - Name the design concept it expresses (hierarchy, spacing, state, feedback, …).
   - Split it into structure (HTML/markup), presentation (CSS) and behaviour (JS/framework) wherever they appear.
3. **Pitch it per area.** Use the student's level for each concept's knowledge area. **Learned** concepts get a few words only.
4. **Flag** one accessibility or quality observation, if there is a notable one.
5. **Close** with one check question asked via AskUserQuestion, following "How to ask questions" in the rules and the `Questions` setting.
6. **Update memory** with one memory-helper call after the answer, skip or dismissal (or at the end if no question was asked): `seen` for newly explained concepts (`learned` if answered correctly), plus the `question` result.

!`bash "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" "${CLAUDE_PROJECT_DIR}"`
