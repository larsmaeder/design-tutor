---
name: review
description: Review a file or the current exercise for accessibility and quality issues, explained by their impact on people, with fixes applied only on request.
argument-hint: "[file or folder]"
disable-model-invocation: true
allowed-tools: Bash(bash *scripts/context.sh*)
model: sonnet
effort: medium
---

# Review

Review **$ARGUMENTS** for accessibility and quality, following the tutor rules below. If nothing was given, review the files of the current topic.

**Don't change anything yet.** List the findings; fixes come only when the student asks.

## What to look for

- **Accessibility:**
  - missing or unhelpful alt text;
  - colour contrast;
  - focus visibility and keyboard access;
  - semantic structure (headings, landmarks, lists, buttons vs. links);
  - reading order versus visual order;
  - motion without a reduced-motion fallback;
  - dynamic changes that aren't announced;
  - the wrong document language.
- **Quality:**
  - invalid or silently ignored values;
  - styles or classes defined but never used (and vice versa);
  - design tokens defined but not actually used;
  - hard-coded values that should be tokens;
  - fragile or unclosed comments;
  - placeholder titles.
- **Stack-specific**, only if relevant: e.g. click handlers on non-interactive elements, missing keys or labels in components.

## Output

- Up to **7 findings**, most impactful first. For each, one line covering:
  - `file:line`;
  - what's wrong, in plain words;
  - **who is affected** or what the user experiences;
  - the fix in one phrase.
- **Show code** for one or two findings at most, as short snippets.
- **End** with one AskUserQuestion call:
  - **Question:** "Which findings should I fix?" Header "Fix", `multiSelect: true`.
  - **Options:** the top 3 findings (short labels like "1 · Alt text") plus "None for now". The student can type other numbers via "Other".
  - **Answer:** apply the selected fixes using the change loop from the rules.
  - **"None for now" or dismissed:** reply with one line, e.g. "Okay — say *fix 2* any time."

Pitch explanations at the student's level for each area.

!`bash "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" "${CLAUDE_PROJECT_DIR}"`
