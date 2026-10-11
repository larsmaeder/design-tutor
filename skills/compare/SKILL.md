---
name: compare
description: Compare two variants (files, stylesheets, components or versions) and explain which design decisions make them look or behave differently.
argument-hint: "<first> <second>"
disable-model-invocation: true
allowed-tools: Bash(bash *scripts/context.sh*) Bash(bash *scripts/memory.sh*)
model: sonnet
effort: medium
---

# Compare

Compare **$0** with **$1**, following the tutor rules below. Don't edit any code.

If one or both weren't given, pick the most obvious pair of variants in the project, for example two stylesheets for the same page or two versions of a component. Say which ones you picked.

1. **What's shared.** One or two lines, for example the same HTML structure or the same component API.
2. **What differs.** Group the differences by design decision, not by line. Examples: typographic voice, colour and contrast, spacing and rhythm, layout strategy, motion, interaction feedback. For each, show the key line or two from both sides and the effect it has.
3. **Takeaway.** One sentence on the principle it shows, e.g. "Same structure, different presentation", or "same look, different behaviour".
4. **Pitch it per area.** Use the student's level for each concept's area. **Learned** concepts get a few words only.
5. **Close** with one check question asked via AskUserQuestion, following "How to ask questions" in the rules and the `Questions` setting. A "which variant would you choose for …" question with code previews works well here.
6. **Update memory** with one memory-helper call after the answer, skip or dismissal (or at the end if no question was asked): `seen` for newly explained concepts (`learned` if answered correctly), plus the `question` result.

!`bash "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" "${CLAUDE_PROJECT_DIR}"`
