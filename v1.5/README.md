# AI Project Template (V1.5)

Standardized project scaffolding for AI-assisted software development with **subagent delegation for improved context management**.

## What is This?

A reusable template that includes:
- Autonomous code review workflow with Claude
- Intelligent review caching (40-60% token savings)
- Cursor IDE rules for consistent AI behavior
- Memory Bank structure for context preservation
- Test-first development patterns
- Multi-agent workflow definitions
- Commit audit trail and bypass detection
- Automation scripts for setup and maintenance
- **V1.5: Subagent delegation for context management**

---

## What's New in V1.5

V1.5 introduces **subagent delegation** to address context ballooning during multi-task autonomous execution:

| Enhancement | Benefit |
|-------------|---------|
| **Explorer subagent** | Codebase exploration in isolated context (40:1 compression) |
| **Implementer subagent** | Implementation in isolated context (20:1 compression) |
| **Orchestrator purity** | Main agent stays as pure coordinator |
| **Context budgets** | Target <50% context after 5 tasks |

---

## Part 1: Template to Boilerplate Project

This section covers creating a new project with boilerplate structure ready for your project specifics.

### 1.1 Create Boilerplate Project

```bash
# Clone this template
git clone <repository-url> ai-project-template
cd ai-project-template/v1.5

# Create new project with boilerplate structure
./scripts/setup-project.sh my-new-project

# Navigate to new project (path shown in setup output)
cd /path/to/my-new-project
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
- `.claude/agents/` - V1.5 subagent definitions (explorer, implementer)
- `.git/hooks/` - Git hooks (installed automatically during setup)
  - `pre-commit` - Autonomous code review with Claude
  - `post-commit` - Commit logging and bypass detection
- `scripts/` - Automation and utility scripts
  - `validate-project.sh` - Validates project readiness before initialization
  - `audit-commits.sh` - Analyzes commit history for unauthorized bypasses
  - `verify-context.sh` - Checks Memory Bank and documentation health
- `tests/patterns/` - Test templates
- `_docs/_boilerplate/` - Template files for initialization
- `_docs/guides/` - Workflow documentation
- `_logs/` - Commit logs and audit trail
- `CLAUDE.md` - Claude Code instructions

**Empty Directories (populated in Part 2):**
- `_docs/best-practices/` - Will contain stack-specific patterns
- `_docs/task-list/` - Will contain chunked task files
- `_docs/_backups/` - Will contain backups before chunking

Your project now has the boilerplate structure but contains no project-specific details yet.

---

## Part 2: Boilerplate to Initialized Project

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
# Or in Claude Code: @.cursor/commands/begin-development.md
```

**Note:** Git hooks for autonomous code review were installed automatically during project setup. Every commit will trigger Claude to review your code.

---

## Subagent Delegation (V1.5)

### When Subagents Are Used

**Explorer Subagent:**
- Triggered when affected files are unknown
- Triggered when task spans multiple modules
- Triggered when exploration would require >5 file reads
- Returns: File paths, patterns, dependencies (1-2K tokens)

**Implementer Subagent:**
- Triggered when changes exceed 50 lines
- Triggered when changes span 3+ files
- Returns: Status, files changed, test results (2-3K tokens)

### Delegation Decision Tree

```
Task received
    |
    +-- Are affected files known?
    |       |
    |       NO --> Delegate to EXPLORER
    |       |
    |       YES
    |           |
    |           +-- Is change >50 lines OR >3 files?
    |           |       |
    |           |       YES --> Delegate to IMPLEMENTER
    |           |       |
    |           |       NO --> Execute DIRECTLY
```

### Context Benefits

| Scenario | V1 Context | V1.5 Context |
|----------|------------|--------------|
| Single task exploration | 10-20K tokens | 1-2K summary |
| Single task implementation | 15-30K tokens | 2-3K summary |
| 5-task batch | 90%+ context | <50% context |

### Files Added in V1.5

```
.claude/agents/
  explorer.md       # Codebase exploration subagent
  implementer.md    # Implementation subagent

.cursor/rules/
  subagent-delegation.mdc  # Delegation rules and criteria
```

### Modified Commands

| Command | V1.5 Enhancement |
|---------|-----------------|
| `/plan` | Optional exploration delegation before planning |
| `/implement` | Scope-based delegation for large changes |
| `/one-shot` | Delegation checkpoints in task loop |
| `/batch` | Delegation checkpoints in task loop |

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
# Commit changes with automatic Claude review
git add <files>
git commit -m "feat: your changes"
```

---

## Code Review Workflow

### How It Works

1. **Make Changes**: Write code using Cursor with AI assistance (or via implementer subagent)
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

Use `/commit-without-review` in Cursor to bypass code review.

Or manually:
```bash
# Commit changes and bypass Claude review
git commit -n -m "docs: update README [skip-review]"
```

**Note**: All bypasses are logged. Unauthorized bypasses (without `[skip-review]`) are flagged as violations.

---

## Directory Structure

### Target Project Structure (After Setup)

```
my-project/
  .cursor/
    commands/           # Cursor slash commands
    rules/              # Cursor IDE rules
      base.mdc
      autonomous-execution.mdc
      subagent-delegation.mdc   # V1.5
      ...
    mcp.json
  .claude/
    agents/             # V1.5: Subagent definitions
      explorer.md
      implementer.md
  memory-bank/          # Project context (filled per-project)
    activeContext.md
    productContext.md
    progress.md
    projectBrief.md
    systemPatterns.md
    techContext.md
  _docs/                # Project documentation
    _boilerplate/       # Initialization templates
    _backups/           # Pre-chunking backups
    best-practices/     # Stack-specific patterns
    guides/             # Workflow documentation
    task-list/          # Chunked task files
  _logs/                # Commit logs and audit trail
  tests/patterns/       # Reusable test templates
  scripts/              # Automation scripts
  CLAUDE.md             # Claude Code instructions
```

---

## Template vs Generated Files

### Files Included in Template
```
.cursor/rules/              (Complete - all rules included)
.cursor/commands/           (Complete - all commands included)
.claude/agents/             (Complete - V1.5 subagents)
memory-bank/                (Templates only - .template suffix)
  *.md.template            (Renamed during setup)
  README.md                (Reference documentation)
_docs/
  README.md                (Structure guide)
  _boilerplate/            (Initialization templates)
  guides/                  (Workflow documentation)
  best-practices/          (Empty - populated by Claude)
  task-list/               (Empty - populated by Claude)
scripts/                   (Complete - all scripts included)
tests/patterns/            (Complete - test templates included)
CLAUDE.md                  (Claude Code instructions)
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

---

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

---

## Cursor Slash Commands

### Session Management
- `/begin-development` - Start or resume session: reads Memory Bank, confirms current state (use FIRST every session)
- `/pause` - Gracefully pause development and save state for resumption

### Planning and Implementation (V1.5 Enhanced)
- `/plan` - Create implementation plan for a task (with optional exploration delegation)
- `/implement` - Execute approved plan with test-first workflow (with scope-based delegation)
- `/task` - Execute single task autonomously (planning to implementation to commit)

### Batch Execution (V1.5 Enhanced)
- `/one-shot` - Execute single task or entire phase autonomously with subagent delegation
- `/batch` - Execute multiple tasks sequentially with subagent delegation (e.g., `/batch 0.3-0.4` or `/batch 1.1 1.2 1.3`)

### Testing and Debugging
- `/fix-tests` - Self-correcting loop to fix failing tests

### Git Operations
- `/commit-with-approval` - Stage files and commit with Claude code review workflow
- `/commit-without-review` - Bypass code review for non-code files (docs, memory bank, logs)

### Documentation and Tracking
- `/update-memory-bank` - Review and update all Memory Bank files
- `/update-tracker` - Update task tracker with completion status
- `/summarize` - Create context summary for complex work (saved to _context-summaries/)

---

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

### For Subagent Delegation (V1.5)
1. **Trust the summaries** - Do not re-read files that subagents explored
2. **Respect thresholds** - Delegate when thresholds are met
3. **Check status** - Verify implementer returns COMPLETE before committing
4. **Preserve context** - Use summaries, not raw output

### For Orchestrator (V1.5)
1. **Stay pure** - Coordinate, don't implement when delegation threshold met
2. **Handle commits** - Subagents never commit; orchestrator always does
3. **Report progress** - Include delegation status in progress reports

---

## Commit Workflow

The commit workflow is **unchanged from V1**:

1. Make changes (directly or via implementer subagent)
2. Stage files explicitly (`git add <files>`)
3. Commit triggers Claude review
4. Handle review iterations
5. Use `AUTO_ACCEPT=true` after approval

**Subagent delegation does NOT change:**
- AUTO_ACCEPT rules
- Pre-commit hook behavior
- Review caching
- Violation detection

---

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

---

## Troubleshooting

### "Context at 90% during batch"
- Subagent delegation should prevent this
- Check if thresholds are being respected
- Verify summaries are being used (not re-reading files)

### "Implementer returned FAILED"
- Review failure details in summary
- Check what was tried
- Report to user for manual intervention

### "Explorer found no relevant files"
- Check exploration target was specific enough
- Verify task description is clear
- Consider manual file identification

---

## When to Use V1.5 vs V1

### Use V1.5 When:
- Tasks frequently require codebase exploration
- Autonomous execution regularly hits context limits
- Multi-task batches are common
- Post-MVP development with growing codebase

### Use V1 When:
- Simple projects with clear file locations
- Tasks are always confined to known files
- Context usage is not a concern

---

## Migration from V1

V1.5 is **backward compatible** with V1 projects:

1. Copy `.claude/agents/` directory to your project
2. Copy `.cursor/rules/subagent-delegation.mdc`
3. Update `.cursor/rules/base.mdc` with orchestrator purity principle
4. Update commands as needed (or keep using V1 commands)

Delegation is triggered automatically based on thresholds. Existing V1 workflows continue to work.

---

## Support

For questions or improvements, see:
- [Memory Bank README](memory-bank/README.md)

---

**Version**: 1.5
**Last Updated**: December 2025
**Base**: V1 (November 2025)
**Enhancement**: Subagent delegation for context management

Use freely, adapt as needed, and improve based on your learnings.
