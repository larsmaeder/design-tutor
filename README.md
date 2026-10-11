# design-tutor

A Claude Code plugin for **UX/UI design students learning web technology**. The student never has to write code. They describe what they want in design terms; Claude makes the change and explains it, so they learn to read and steer code.

- **Off by default.** Work with Claude as usual, and switch the tutor on only when you want it.
- **Never blocks.** Questions come at the end, as clickable choices with a **Skip** option, and you can always type your own answer via "Other".
- **Adapts to you.** A level per knowledge area, from HTML and CSS to JavaScript, React and tooling.
- **Remembers.** A learning memory in the repo means concepts you've already learned aren't re-explained or re-asked.
- **Design language, tool-agnostic.** Hierarchy, spacing, states, feedback… never tied to one design app.

## Install (once per computer)

```bash
claude plugin marketplace add larsmaeder/design-tutor
```

```bash
claude plugin install design-tutor@design-tutor
```

This installs it for your user, so it's available in every repo on that computer. To install from a local folder instead, pass the folder path to `marketplace add`.

## Use

| Command | What it does |
|---|---|
| `/design-tutor:setup` | A short interview (level, what you already know, learning goals) that writes `TUTOR.md` and creates your learning memory. Run it once per repo. Every question has a default, so you can skip any of them. |
| `/design-tutor:tutor [request]` | Turns tutor mode on for this session. Every change gets explained at your level. Say **"tutor off"** to leave. |
| `/design-tutor:explain [file or element]` | Explains code in design terms without changing anything. |
| `/design-tutor:compare <a> <b>` | Explains which design decisions make two variants different. |
| `/design-tutor:review [file]` | Lists accessibility and quality findings and who they affect. Say "fix 1, 3" to apply fixes. |
| `/design-tutor:quiz [topic]` | Three multiple-choice questions about your real code. Answers are shown afterwards, even if you skip. |
| `/design-tutor:progress` | What you've learned so far, per area, and what to look at next. |

Tutor mode lasts for the current session. If Claude ever stops sounding like the tutor, for example after a very long session, run `/design-tutor:tutor` again.

## Files the tutor keeps in your repo

### `TUTOR.md`: configuration

Written by `/design-tutor:setup`. You can also edit it by hand, or a teacher can pre-fill it for a class: setup keeps teacher-set learning goals and asks students to confirm them.

| Field | Meaning |
|---|---|
| `Course`, `Current topic` | Context for explanations |
| `Tech stack` | The tutor stays within it and won't introduce new frameworks or tools unless you ask |
| `Overall level`, `Knowledge` | Beginner, Intermediate or Advanced per area (see below) |
| `Learning goals` | What the tutor steers towards; each goal is tagged with an area |
| `Locked files` | Glob patterns the tutor never edits, e.g. `**/basis.css` |
| `Questions` | `new concepts` (default): ask only about things you haven't learned yet · `every change`: ask after every change, as light review · `off`: no check questions. Quizzes still work. Or just say "turn questions off". |
| `Response language` | The language the tutor replies in (default English) |
| `Auto-commit` | `true` commits each step, so you can step back with git (default `false`) |

**Knowledge areas:**
- Structure & semantics
- Styling & tokens
- Layout & responsive
- Motion & states
- Behaviour & data
- Components & frameworks
- Accessibility
- Tooling & delivery

To change a level, re-run setup or just say "set my Layout level to Intermediate".

### `.tutor/memory.md`: learning memory

Lists what you've **learned**, what you've **seen**, any **misconceptions**, and which **questions** you've been asked. The tutor reads it so it doesn't repeat itself, and updates it once after each exchange. Setup offers to let it do that without asking you each time. You and your teacher can read it at any time.

It's meant to be committed, so your progress follows you to other computers. To keep it private, add `.tutor/` to `.gitignore`.

## How it works (for maintainers)

```
.claude-plugin/   plugin.json, marketplace.json (this repo is its own marketplace)
tutor/            RULES.md (behaviour), LEVELS.md (areas and levels), templates
scripts/          context.sh – prints rules, levels, TUTOR.md, memory and the memory-helper command
                  memory.sh  – updates .tutor/memory.md (seen / learned / misconception / question)
skills/           one folder per command
```

- **Context injection.** Every skill injects context with `` !`bash ".../scripts/context.sh" "<project>"` ``, so the rules live in one place (`tutor/RULES.md`).
- **The script always exits 0.** A failing injection command would abort the skill, and missing files must never block a student.
- **Manual-only skills.** Every skill sets `disable-model-invocation: true`, so Claude never starts the tutor by itself.
- **No hooks.** The plugin does nothing until a skill is invoked.
- **Memory helper.**
  - Claude saves memory with one `scripts/memory.sh` call per exchange instead of reading and editing the file. That's fewer tool calls, fewer output tokens and a guaranteed format.
  - The helper is bash and awk only, matches keys literally, adds dates and keeps the latest 20 questions.
  - `setup` can add `Bash(bash *scripts/memory.sh*)` to the project's `.claude/settings.local.json`, so students aren't prompted every time.
- **Models.**
  - `progress` runs on Haiku at low effort.
  - `explain`, `compare`, `quiz`, `review` and `setup` run on Sonnet at medium effort.
  - These settings are in each skill's frontmatter. `tutor` has none, so it uses the session's model and effort.

### Develop and test locally

```bash
claude plugin validate .
```

```bash
claude --plugin-dir .
```

If a skill aborts as soon as you invoke it, the context command was probably denied by permissions. Check the `allowed-tools` rule in that skill's `SKILL.md`, which should match `bash …/scripts/context.sh …`.

On Windows, the context command needs Git Bash, which Claude Code on Windows already uses.
