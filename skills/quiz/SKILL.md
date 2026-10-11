---
name: quiz
description: Three quick questions based on this project's real code, with the answers included, focused on what the student hasn't firmly learned yet.
argument-hint: "[topic or knowledge area]"
disable-model-invocation: true
allowed-tools: Bash(bash *scripts/context.sh*) Bash(bash *scripts/memory.sh*)
model: sonnet
effort: medium
---

# Quiz

Create a short quiz, following the tutor rules below. Focus: **$ARGUMENTS** (if empty, choose the focus yourself).

## Choosing questions

Write **3 questions**, using this priority:

1. **Misconceptions** from memory: check the specific mix-up.
2. **Seen** concepts that aren't **Learned** yet.
3. Learning goals that aren't covered yet.

- **Never** ask about **Learned** concepts.
- **Never** repeat a question already answered `correct`.
- A question logged as `skipped` may come back once, rephrased.

## Format

1. **Show the code.** In your reply, show the short snippet each question refers to (with `file:line`), numbered 1–3. Every question must be about real code in this project.
2. **Ask.** Ask all 3 questions in **one AskUserQuestion call** (headers "Quiz 1" to "Quiz 3"), following "How to ask questions" in the rules: 2–3 plausible answers plus "Skip", and the correct answer in a varying position.
3. **Mix the question types:**
   - "What will you see if …?" (prediction)
   - "Why does …?" (reasoning)
   - "Which would you choose for …?" (choice, mostly for Intermediate and Advanced; the option `preview` can show code)
4. **Pitch each question** at the student's level for that area. Beginner questions are about the visible result.
5. **Feedback.** When the answers come back, give one short block per question: ✓ or ✗, the correct answer, and a one-to-two-line explanation. Show the answers **even for skipped or dismissed questions**, so the student always gets them.

## Memory

After the feedback, make **one** memory-helper call for the whole quiz:
- one `question` operation per question, with the result `correct`, `incorrect` or `skipped`;
- `learned` or `misconception` operations for the concepts involved, following the rules.

!`bash "${CLAUDE_SKILL_DIR}/../../scripts/context.sh" "${CLAUDE_PROJECT_DIR}"`
