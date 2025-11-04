# AI Project Template

Standardized project scaffolding for AI-assisted software development.

## What is This?

A reusable template that includes:
- ✅ Cursor IDE rules for consistent AI behavior
- ✅ Memory Bank structure for context preservation
- ✅ Test-first development patterns
- ✅ Multi-agent workflow definitions
- ✅ Automation scripts for setup and maintenance

## Quick Start

### Creating a New Project

```bash
# Clone this template
git clone <this-repo> ai-project-template
cd ai-project-template

# Create new project
./scripts/setup-project.sh my-new-project

# Navigate to new project
cd ../my-new-project

# Fill in project-specific details
# 1. memory-bank/projectbrief.md (describe your project)
# 2. _docs/architecture.md (your system design)
# 3. _docs/task-list.md (your tasks)
# 4. _docs/best-practices/[stack].md (stack-specific patterns)
```

### Starting Development Session

**Use the `/begin-development` command in Cursor** to automatically:
```
1. Read memory-bank/activeContext.md
2. Read memory-bank/progress.md
3. Confirm current phase and next tasks
4. Display recent changes and active decisions
```

Or manually prompt AI assistant:
```
Read @memory-bank/activeContext.md and @memory-bank/progress.md.
Confirm current phase and next task.
```

### After Development Session

```bash
# Update documentation
./scripts/update-docs.sh

# Verify context health
./scripts/verify-context.sh
```

## Directory Structure

```
.cursor/rules/           ← Cursor IDE rules (process, standards)
memory-bank/            ← Project context (filled per-project)
_docs/                  ← Project documentation
tests/patterns/         ← Reusable test templates
scripts/                ← Automation scripts
```

## Key Files

### Always Read (Every Session)
- `memory-bank/activeContext.md` - Current focus
- `memory-bank/progress.md` - Status and next steps

### Memory Bank Management
- **`.cursor/rules/memory-bank-management.mdc`** - Complete Memory Bank procedures
- **`memory-bank/README.md`** - Structure overview and quick reference
- **`memory-bank/activeContext.md`** - Current work focus (read every session)
- **`memory-bank/progress.md`** - Task status (read every session)

**Critical**: Memory Bank is the MOST IMPORTANT component. AI reads this every session to understand project context. Without current Memory Bank files, AI effectiveness drops dramatically.

### Reference When Needed
- `_docs/architecture.md` - System design
- `_docs/guides/multi-agent-workflow.md` - Multi-agent workflows
- `_docs/guides/test-first-workflow.md` - Test-first development

## Cursor Slash Commands

Available commands (use with `/` in Cursor):
- `/begin-development` - Start session: read Memory Bank, confirm current state (use this FIRST every session)
- `/start-task [id]` - Read context, produce implementation plan
- `/implement [id]` - Execute approved plan with test-first workflow
- `/fix-tests` - Self-correcting loop to fix failing tests
- `/update-memory-bank` - Review and update all memory bank files
- `/summarize` - Create context summary for session

## Best Practices

### For Developers
1. **Start every session with `/begin-development`** to load context automatically
2. Update memory bank after completing features
3. Run verify-context.sh weekly
4. Keep documentation in sync with code

### For AI Assistants
1. Read Memory Bank FIRST every session (see `.cursor/rules/memory-bank-management.mdc` for procedures)
2. Ask clarifying questions when uncertain
3. Check in after completing tasks
4. Never auto-commit without approval
5. Suggest context summary after complex work

## Maintenance

### Daily
- Update activeContext.md with work focus
- Update progress.md after completing tasks

### Weekly
- Run `./scripts/verify-context.sh`
- Review and update memory bank
- Archive old context if needed

### Monthly
- Review .cursor/rules/ for improvements
- Update test patterns
- Refine automation scripts

## Features

### Test-First Development
- Write tests before implementation
- Self-correcting AI loop
- 70%+ reduction in regressions
- Automated verification

### Multi-Agent Workflows
- Role-based agents (PLANNER, BACKEND, FRONTEND, TESTING)
- Structured handoff protocol
- 3-5x faster parallel development
- Clear accountability

### Modular Cursor Rules
- Domain-specific rules
- Lazy-loading for efficiency
- 60% better context usage
- Easy to customize

### Automation Scripts
- `setup-project.sh` - Initialize new project from template
- `update-docs.sh` - Documentation sync reminders
- `verify-context.sh` - Context health check

## Support

For questions or improvements, see:
- [Multi-Agent Workflow Guide](_docs/guides/multi-agent-workflow.md)
- [Test-First Workflow Guide](_docs/guides/test-first-workflow.md)
- [Memory Bank README](memory-bank/README.md)

---

**Version**: 1.0
**Last Updated**: November 2025
**Created by**: AI-First Development Team

Use freely, adapt as needed, and improve based on your learnings.
