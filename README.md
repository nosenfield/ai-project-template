# AI Project Template

Standardized project scaffolding for AI-assisted software development.

## What is This?

A reusable template that includes:
- ✅ Autonomous code review workflow with Claude
- ✅ Intelligent review caching (40-60% token savings)
- ✅ Cursor IDE rules for consistent AI behavior
- ✅ Memory Bank structure for context preservation
- ✅ Test-first development patterns
- ✅ Multi-agent workflow definitions
- ✅ Commit audit trail and bypass detection
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
# 1. memory-bank/projectBrief.md (describe your project)
# 2. _docs/architecture.md (your system design)
# 3. _docs/task-list.md (your tasks)
# 4. _docs/best-practices/[stack].md (stack-specific patterns)

# Install git hooks for autonomous code review
cp scripts/pre-commit .git/hooks/pre-commit
cp scripts/post-commit .git/hooks/post-commit
chmod +x .git/hooks/pre-commit .git/hooks/post-commit
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
# Commit changes (triggers automatic Claude review)
git add <files>
git commit -m "feat: your changes"
# → Pre-commit hook runs Claude review
# → Review results shown with approve/reject decision
# → Commit proceeds only if approved

# Update documentation
./scripts/update-docs.sh

# Verify context health
./scripts/verify-context.sh

# Audit commit history (optional)
./scripts/audit-commits.sh
```

## Code Review Workflow

### How It Works

1. **Make Changes**: Write code using Cursor with AI assistance
2. **Stage Files**: `git add <files>` as usual
3. **Attempt Commit**: `git commit -m "message"`
4. **Automatic Review**: Pre-commit hook triggers Claude to review staged files
5. **Cache Check**: Previously approved unchanged files skip review (40-60% faster)
6. **Review Analysis**: Claude analyzes code for:
   - Code quality and best practices
   - Potential bugs or security issues
   - Performance concerns
   - Alignment with project architecture
7. **Decision**: Commit proceeds if APPROVED, blocked if ISSUES FOUND
8. **Logging**: All commits logged; bypasses tracked and auditable

### Review Caching

Files are cached after approval. Cache invalidated when:
- File content changes (SHA-256 hash mismatch)
- Dependencies change (imports/requires modified)
- Dependency content changes (local file hashes)
- Cache expires (30 days)

### Bypassing Review

For documentation or non-code files:
```bash
# Use the slash command (recommended)
/commit-without-review

# Or manual with -n flag + [skip-review] marker
git commit -n -m "docs: update README [skip-review]"
```

**Note**: All bypasses are logged. Unauthorized bypasses (without `[skip-review]`) are flagged as violations.

## Directory Structure

```
.cursor/rules/           ← Cursor IDE rules (process, standards)
memory-bank/            ← Project context (filled per-project)
_docs/                  ← Project documentation
_logs/                  ← Commit logs and audit trail
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

### Session Management
- `/begin-development` - Start session: read Memory Bank, confirm current state (use this FIRST every session)
- `/pause` - Gracefully pause development and save state for resumption
- `/summarize` - Create context summary for session

### Development Workflow
- `/start-task [id]` - Read context, produce implementation plan
- `/implement [id]` - Execute approved plan with test-first workflow
- `/fix-tests` - Self-correcting loop to fix failing tests

### Memory & Documentation
- `/update-memory-bank` - Review and update all memory bank files

### Git Operations
- `/commit-without-review` - Bypass code review with authorization (for docs/non-code files)

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

### Autonomous Code Review
- **Pre-commit hook** triggers Claude review on every commit
- **Intelligent caching** with dependency tracking (40-60% token savings)
- **Structured review format** with severity levels (CRITICAL/HIGH/MEDIUM)
- **AUTO_ACCEPT validation** prevents bypassing without approval
- **Commit audit trail** logs all bypasses with authorization tracking
- Platform-compatible (macOS & Linux)

### Review Caching System
- Hash-based validation of file content
- Dependency fingerprinting (TypeScript/JS/Python/Go)
- 30-day cache expiry
- Automatic invalidation on dependency changes
- Separate tracking of external vs local dependencies

### Commit Audit & Compliance
- All commits logged to `_logs/all-commits.log`
- Bypass detection with `[skip-review]` marker validation
- Audit script (`scripts/audit-commits.sh`) for violation reporting
- Authorized bypass support via `/commit-without-review` command

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
- `audit-commits.sh` - Analyze commit history for bypass violations
- `pre-commit` - Autonomous code review hook
- `post-commit` - Commit logging and bypass detection

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
