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

---

## Part 1: Template → Boilerplate Project

This section covers creating a new project with boilerplate structure ready for your project specifics.

### 1.1 Create Boilerplate Project

```bash
# Clone this template
git clone <repository-url> ai-project-template
cd ai-project-template

# Create new project with boilerplate structure
./scripts/setup-project.sh my-new-project

# Navigate to new project
cd ../my-new-project
```

### 1.2 What You Get

The setup script creates a boilerplate project with:

**Renamed Memory Bank Files:**
- `memory-bank/projectBrief.md` (from .template)
- `memory-bank/productContext.md` (from .template)
- `memory-bank/activeContext.md` (from .template)
- `memory-bank/systemPatterns.md` (from .template)
- `memory-bank/techContext.md` (from .template)
- `memory-bank/progress.md` (from .template)

**Complete Infrastructure:**
- `.cursor/rules/` - Cursor IDE rules and workflows
- `.cursor/commands/` - Cursor IDE development commands
- `.git/hooks/` - Git hooks (installed automatically during setup)
  - `pre-commit` - Autonomous code review with Claude
  - `post-commit` - Commit logging and bypass detection
- `scripts/` - Automation and utility scripts
  - `validate-project.sh` - Validates project readiness before initialization
  - `audit-commits.sh` - Analyzes commit history for unauthorized bypasses
  - `verify-context.sh` - Checks Memory Bank and documentation health
- `tests/patterns/` - Test templates
- `_docs/_boilerplate/` - Template files for initialization

**Empty Directories (populated in Part 2):**
- `_docs/best-practices/` - Will contain stack-specific patterns
- `_docs/task-list/` - Will contain chunked task files
- `_docs/_backups/` - Will contain backups of task-list.md and best-practices.md before chunking

Your project now has the boilerplate structure but contains no project-specific details yet.

---

## Part 2: Boilerplate → Project with Initial Docs

This section covers overlaying your project specifics onto the boilerplate to generate initial development documentation and context.

### 2.1 Prerequisites

**Create your PRD** at `_docs/prd.md` with:
- Product vision and goals
- User stories and features
- Technical requirements
- Platform and performance requirements
- Security and scalability considerations

**Optional:** Validate your setup
```bash
./scripts/validate-project.sh
```

### 2.2 Initialize with Claude

1. Open your project in Cursor or Claude Code
2. Use this prompt: `@_docs/_boilerplate/project-prompt-template.md`
3. Augment the "Role" section expertise list with additional disciplines or technologies as needed
4. Fill in the "Overview" section with your project description

### 2.3 What Claude Creates

**Project Documentation:**
- `_docs/architecture.md` - Tech stack and system design
- `_docs/task-list.md` - Implementation roadmap (single file)
- `_docs/task-list/*.md` - Chunked task files with cross-references
- `_docs/task-tracker.md` - Progress tracking
- `_docs/best-practices.md` - Stack-specific coding patterns
- `_docs/_backups/task-list.md` - Backup before chunking

**Updated Memory Bank (project-specific):**
- `memory-bank/projectBrief.md` - Concise project summary
- `memory-bank/productContext.md` - Product vision and features
- `memory-bank/techContext.md` - Tech stack details
- `memory-bank/systemPatterns.md` - Architecture patterns
- `memory-bank/activeContext.md` - Current phase (initialization complete)
- `memory-bank/progress.md` - Initial task status

### 2.4 Begin Development

Your project now has complete documentation and context. You're ready to start development.

**Start your first session:**
```bash
# Use the /begin-development command in Cursor
```

**Note:** Git hooks for autonomous code review were installed automatically during project setup. Every commit will trigger Claude to review your code.

---

## Working in Your Project

### Starting Each Session

Use `/begin-development` in Cursor to automatically:
1. Read memory-bank/activeContext.md
2. Read memory-bank/progress.md
3. Confirm current phase and next tasks

Or manually:
```
Read @memory-bank/activeContext.md and @memory-bank/progress.md.
Confirm current phase and next task.
```

### Commit With Review

Use `/commit-with-approval` in Cursor to automatically:
1. Stage working files from the most recent task
2. Start the automated code review loop and commit the files

Or manually:
```bash
# Commit changes with automatic Claude review)
git add <files>
git commit -m "feat: your changes"
```

## Code Review Workflow

### How It Works

1. **Make Changes**: Write code using Cursor with AI assistance
2. **Stage Files**: `git add <files>` as usual
3. **Attempt Commit**: `git commit -m "message"`
4. **Automatic Review**: Pre-commit hook triggers Claude to review staged files
5. **Cache Check**: Previously approved unchanged files skip review
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

Use `/commit-without-review` in Cursor to bypass code review

Or manually:
```bash
# Commit changes and bypass Claude review
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

## Template vs Generated Files

### Files Included in Template
```
.cursor/rules/              (Complete - all rules included)
memory-bank/                (Templates only - .template suffix)
  ├── *.md.template        (Renamed during setup)
  └── README.md            (Reference documentation)
_docs/
  ├── README.md            (Structure guide)
  ├── _boilerplate/        (Initialization templates)
  ├── best-practices/      (Empty - populated by Claude)
  └── task-list/           (Empty - populated by Claude)
scripts/                   (Complete - all scripts included)
tests/patterns/            (Complete - test templates included)
```

### Files Generated During Initialization
```
After setup-project.sh:
  memory-bank/*.md         (Active files without .template suffix)

After using project-prompt-template.md with Claude:
  _docs/prd.md             (User creates this manually)
  _docs/architecture.md
  _docs/task-list.md
  _docs/task-tracker.md
  _docs/best-practices.md
  _docs/task-list/*.md     (Chunked task files)
  _docs/_backups/task-list.md (Backup of original)
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

## Cursor Slash Commands

Available commands (use with `/` in Cursor):

### Session Management
- `/begin-development` - Start or resume session: reads Memory Bank, confirms current state (use FIRST every session)
- `/pause` - Gracefully pause development and save state for resumption

### Planning & Implementation
- `/plan` - Create implementation plan for a task (with approval gate)
- `/implement` - Execute approved plan with test-first workflow
- `/task` - Execute single task autonomously (planning → implementation → commit)

### Batch Execution
- `/one-shot` - Execute single task or entire phase autonomously without pauses
- `/batch` - Execute multiple tasks sequentially (e.g., `/batch 0.3-0.4` or `/batch 1.1 1.2 1.3`)

### Testing & Debugging
- `/fix-tests` - Self-correcting loop to fix failing tests

### Git Operations
- `/commit-with-approval` - Stage files and commit with Claude code review workflow
- `/commit-without-review` - Bypass code review for non-code files (docs, memory bank, logs)

### Documentation & Tracking
- `/update-memory-bank` - Review and update all Memory Bank files
- `/update-tracker` - Update task tracker with completion status
- `/summarize` - Create context summary for complex work (saved to _context-summaries/)

## Best Practices

### For Developers
1. **Start every session with `/begin-development`** to load context automatically
2. Use `/plan` and `/implement` commands for each task
3. Use `commit-with-approval` to perform automated code review
4. Verify Cursor automatically updated memory bank after completing features. Use `/update-memory-bank` to request manual update as needed.
5. Keep documentation in sync with code

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
- `validate-project.sh` - Validate proper pre-code project state
- `verify-context.sh` - Context health check
- `audit-commits.sh` - Analyze commit history for bypass violations

## Support

For questions or improvements, see:
- [Memory Bank README](memory-bank/README.md)

---

**Version**: 1.0
**Last Updated**: November 2025
**Created by**: AI-First Development Team

Use freely, adapt as needed, and improve based on your learnings.
