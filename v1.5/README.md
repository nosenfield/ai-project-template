# AI Project Template (V1.5)

Standardized project scaffolding for AI-assisted software development with **subagent delegation for improved context management**.

## What's New in V1.5

V1.5 introduces **subagent delegation** to address context ballooning during multi-task autonomous execution:

| Enhancement | Benefit |
|-------------|---------|
| **Explorer subagent** | Codebase exploration in isolated context (40:1 compression) |
| **Implementer subagent** | Implementation in isolated context (20:1 compression) |
| **Orchestrator purity** | Main agent stays as pure coordinator |
| **Context budgets** | Target <50% context after 5 tasks |

### V1 Features Preserved

- Autonomous code review workflow with Claude
- Intelligent review caching (40-60% token savings)
- AUTO_ACCEPT validation and commit audit trail
- Memory Bank structure for context preservation
- Test-first development patterns

---

## Quick Start

### 1. Create Project from Template

```bash
# Clone this template
git clone <repository-url> ai-project-template
cd ai-project-template/v1.5

# Create new project with boilerplate structure
./scripts/setup-project.sh my-new-project

# Navigate to new project
cd ../../my-new-project
```

### 2. Initialize with Claude

1. Create your PRD at `_docs/prd.md`
2. Open project in Cursor
3. Use prompt: `@_docs/_boilerplate/project-prompt-template.md`

### 3. Begin Development

```bash
# Use /begin-development command in Cursor
```

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
    │
    ├─► Are affected files known?
    │       │
    │       NO ──► Delegate to EXPLORER
    │       │
    │       YES
    │           │
    │           ├─► Is change >50 lines OR >3 files?
    │           │       │
    │           │       YES ──► Delegate to IMPLEMENTER
    │           │       │
    │           │       NO ──► Execute DIRECTLY
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
├── explorer.md       # Codebase exploration subagent
└── implementer.md    # Implementation subagent

.cursor/rules/
└── subagent-delegation.mdc  # Delegation rules and criteria
```

### Modified Commands

| Command | V1.5 Enhancement |
|---------|-----------------|
| `/plan` | Optional exploration delegation before planning |
| `/implement` | Scope-based delegation for large changes |
| `/one-shot` | Delegation checkpoints in task loop |
| `/batch` | Delegation checkpoints in task loop |

---

## Directory Structure

```
v1.5/
├── .cursor/
│   ├── rules/
│   │   ├── base.mdc                    # Core principles + orchestrator purity
│   │   ├── autonomous-execution.mdc    # Updated with delegation checkpoints
│   │   ├── subagent-delegation.mdc     # NEW: Delegation rules
│   │   └── ...
│   └── commands/
│       ├── plan.md                     # Updated with exploration delegation
│       ├── implement.md                # Updated with scope-based delegation
│       ├── one-shot.md                 # Updated with subagent integration
│       ├── batch.md                    # Updated with subagent integration
│       └── ...
├── .claude/
│   └── agents/
│       ├── explorer.md                 # NEW: Explorer subagent
│       └── implementer.md              # NEW: Implementer subagent
├── memory-bank/                        # Unchanged from V1
├── _docs/                              # Unchanged from V1
├── scripts/                            # Unchanged from V1
└── tests/                              # Unchanged from V1
```

---

## Cursor Slash Commands

### Session Management
- `/begin-development` - Start or resume session
- `/pause` - Gracefully pause and save state

### Planning & Implementation (V1.5 Enhanced)
- `/plan` - Create implementation plan (with optional exploration delegation)
- `/implement` - Execute plan (with scope-based delegation)
- `/task` - Execute single task autonomously

### Batch Execution (V1.5 Enhanced)
- `/one-shot` - Execute phase with subagent delegation
- `/batch` - Execute multiple tasks with subagent delegation

### Testing & Debugging
- `/fix-tests` - Self-correcting loop to fix failing tests

### Git Operations
- `/commit-with-approval` - Stage and commit with Claude review
- `/commit-without-review` - Bypass review for non-code files

### Documentation & Tracking
- `/update-memory-bank` - Review and update Memory Bank
- `/update-tracker` - Update task tracker
- `/summarize` - Create context summary

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

## Best Practices

### For Subagent Delegation

1. **Trust the summaries** - Do not re-read files that subagents explored
2. **Respect thresholds** - Delegate when thresholds are met
3. **Check status** - Verify implementer returns COMPLETE before committing
4. **Preserve context** - Use summaries, not raw output

### For Orchestrator

1. **Stay pure** - Coordinate, don't implement when delegation threshold met
2. **Handle commits** - Subagents never commit; orchestrator always does
3. **Report progress** - Include delegation status in progress reports

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

**Version**: 1.5
**Last Updated**: December 2025
**Base**: V1 (November 2025)
**Enhancement**: Subagent delegation for context management

Use freely, adapt as needed, and improve based on your learnings.
