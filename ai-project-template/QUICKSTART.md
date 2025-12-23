# Quick Start Guide

Get from zero to development-ready in 10 minutes.

---

## Prerequisites

- Git installed
- Cursor IDE installed
- Claude Code CLI or Claude Cursor Extension available
- A PRD (Product Requirements Document) for your project

---

## Step 1: Create Your Project

```bash
git clone https://github.com/nosenfield/ai-project-template.git
cd ai-project-template
./scripts/setup-project.sh <your-project-name>
```

**What happens:** Creates project structure, installs git hooks, initializes git repo with first commit.

---

## Step 2: Navigate to Your Project

```bash
cd ../<your-project-name>
```

---

## Step 3: Add Your PRD

Place your Product Requirements Document at `_docs/prd.md`.

**Tip:** Remove unnecessary content like timelines, scoring criteria, or other non-functional details to keep context clean.

**Tip:** Validate your project structure before proceeding:
```bash
./scripts/validate-project.sh
```

---

## Step 4: Initialize Project with Claude

Open Cursor or Claude Code and start a chat with:

```
@_docs/_boilerplate/project-prompt-template.md
```

Fill in the "Overview" section with your project description and augment the "Role" expertise list as needed.

**Claude will:**
- Review best practices for your tech stack
- Create `_docs/architecture.md` with system design
- Create `_docs/task-list.md` and chunk it into `_docs/task-list/*.md`
- Create `_docs/task-tracker.md` for progress tracking
- Create `_docs/best-practices.md` with stack-specific patterns
- Create `_docs/required-reading.md` for reference materials

**Tip:** If `_docs/best-practices.md` is overly long, chunk it into `_docs/best-practices/*.md`

---

## Step 5: Initialize Memory Bank

After documentation is complete, update the Memory Bank.

**If initialized with Claude Code:**
```
Update the memory bank based on @.cursor/commands/update-memory-bank.md
```

**If initialized with Cursor:**
```
/update-memory-bank
```

---

## Step 6: Begin Development

Use the `/begin-development` command in Cursor.

```
/begin-development
```

This automatically loads Memory Bank context at the start of each chat. Use this command to ensure Cursor agents have necessary context before starting work.

**To execute tasks:**
- Single task: `/one-shot <task-id>` (e.g., `/one-shot 0.1`)
- Entire phase: `/one-shot Phase 0`
- Multiple tasks: `/batch 0.1 0.2 0.3`

---

## Commit Workflow

All commits trigger automatic Claude code review via git hooks.

**With review (default):**
```
/commit-with-approval
```

**Without review (docs/config only):**
```
/commit-without-review
```

---

## Key Commands Reference

| Command | Purpose |
|---------|---------|
| `/begin-development` | Start session with context |
| `/pause` | Gracefully pause and save state |
| `/one-shot` | Execute task(s) autonomously |
| `/batch` | Execute multiple tasks sequentially |
| `/plan` | Create implementation plan |
| `/implement` | Execute approved plan |
| `/update-memory-bank` | Sync Memory Bank with current state |
| `/update-tracker` | Update task tracker with completion status |
| `/commit-with-approval` | Commit with code review |
| `/commit-without-review` | Commit without review |

---

## Project Structure

```
_docs/                  # Project documentation
  _boilerplate/         # Templates for initialization
  task-list/            # Chunked task files
memory-bank/            # AI context (read every session)
.cursor/
  commands/             # Slash commands
  rules/                # IDE rules and workflows
scripts/                # Automation utilities
_logs/                  # Commit audit trail
```

---

## Next Steps

- Read [README.md](README.md) for detailed documentation
- Review [memory-bank/README.md](memory-bank/README.md) for context management
- Check `.cursor/rules/` for workflow customization

---

**Questions?** See the full [README.md](README.md) or open an issue.
