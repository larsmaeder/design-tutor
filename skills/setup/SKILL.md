---
name: setup
description: Set up the design tutor for this repo. A short interview about level, prior knowledge and learning goals that writes TUTOR.md and creates the learning memory.
disable-model-invocation: true
allowed-tools: Bash(bash *scripts/context.sh*)
model: sonnet
effort: medium
---

# Tutor setup

Set up `TUTOR.md` and `.tutor/memory.md` for this project.

Every question has a pre-selected default. If the student skips or dismisses a question, keep the default. Setup **always** finishes with a working configuration.

## 1. Read the repo first (don't ask yet)

Scan the project quickly. Don't read every file.

- **File types:** `.html`, `.css`, `.scss`, `.js`, `.ts`, `.jsx`, `.tsx`, `.vue`, `.svelte`.
- **`package.json` dependencies:** e.g. react, next, vue, svelte, astro, tailwindcss, vite, typescript.
- **Course hints:** page titles, headings, comments, folder names (`Day1`, `Week2`, numbered folders in any language), exercise instructions and README files.

From that, draft:

- **Tech stack:** e.g. "HTML, CSS" or "React, TypeScript, Tailwind".
- **Course name:** from the README, folder or page titles.
- **Current topic:** usually the most recently changed or highest-numbered exercise folder.
- **Learning goals:** 3–6 goals, each tagged with a knowledge area, based on the concepts the current exercises practise.
- **Locked files:** files whose comments say not to edit them (in any language), or files named like `base` or `basis`. Use "none" if there aren't any.

If `TUTOR.md` already exists (for example pre-filled by a teacher), its values are the defaults. Keep teacher-set learning goals and ask the student to confirm them; don't replace them.

## 2. Ask: one AskUserQuestion call, four questions

1. **Overall level** (single choice), header "Level". Options:
   - "Beginner": I haven't read code before.
   - "Intermediate": I recognise code structure and common building blocks.
   - "Advanced": I read code comfortably.

   Pre-select the existing value, or Beginner.
2. **Visual areas** (multi-select), header "Visual". Question: "Visual side: which of these can you already read?" Options: Structure & semantics (HTML) · Styling & tokens (CSS) · Layout & responsive · Motion & states.
3. **Behaviour & delivery areas** (multi-select), header "Behaviour". Question: "Behaviour and delivery: which of these can you already read?" Options: Behaviour & data (JavaScript) · Components & frameworks (e.g. React) · Accessibility · Tooling & delivery (git, builds).

All four question texts must be different from each other, and option labels must be unique within each question. Otherwise the tool rejects the call.
4. **Learning goals** (multi-select), header "Goals". Use up to 4 of the drafted goals as options. The student can add more via "Other". If a teacher set the goals, phrase it as "Confirm your learning goals".

If the AskUserQuestion tool isn't available, skip this step and use the defaults.

**Turning answers into area levels:**

| Answer | Area level |
|---|---|
| Ticked area | Intermediate, or Advanced if the overall level is Advanced |
| Unticked area | Beginner |
| Question skipped | Keep the existing value, or Beginner |

## 3. Write

- **`TUTOR.md`** in the project root: fill in the config template below, with the drafted current topic, tech stack, locked files, `Questions: new concepts`, `Response language: English` and `Auto-commit: false` (keep existing values if re-running).
- **`.tutor/memory.md`:** create it from the memory template if it doesn't exist. **Never overwrite an existing memory file.**

## 4. Memory permission: one extra AskUserQuestion call

Skip this step if `.claude/settings.local.json` already contains the rule.

- Ask "Let the tutor update your learning memory without asking each time?" (header "Memory") with two options:
  - "Yes": no permission prompt each time the memory is saved.
  - "No": you'll be asked each time.
- On **"Yes":** add `"Bash(bash *scripts/memory.sh*)"` to `permissions.allow` in the project's `.claude/settings.local.json`.
  - Create the file (and `.claude/`) if it's missing.
  - Keep every existing setting and entry, and don't add a duplicate.
  - The rule only lets the tutor run its own memory helper.
- On **"No"** or dismissed: change nothing.

## 5. Summary

Finish with at most 6 lines:
- the levels;
- the goals;
- the inferred topic and locked files;
- the question setting ("I'll ask about new concepts — say *turn questions off* or *ask me every time* to change that");
- how to change anything later: re-run `/design-tutor:setup`, or just say e.g. "set my Layout level to Intermediate";
- how to start: `/design-tutor:tutor`.

!`bash "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" "${CLAUDE_PROJECT_DIR}" --with-templates`
