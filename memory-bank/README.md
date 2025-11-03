# Memory Bank

The Memory Bank maintains project context across AI sessions.

## Files

### Required (Create at Project Start)
- `projectbrief.md` - Foundation, created first
- `productContext.md` - Why project exists
- `systemPatterns.md` - Architecture patterns
- `techContext.md` - Tech stack, setup
- `progress.md` - What's done, what's next

### Always Updated
- `activeContext.md` - Current work focus

## File Hierarchy

```
projectbrief.md → productContext.md → activeContext.md
                → systemPatterns.md   ↗
                → techContext.md      ↗

activeContext.md → progress.md
```

## When to Update

- **activeContext.md**: After every significant change
- **progress.md**: After completing tasks
- **systemPatterns.md**: When new patterns emerge
- Others: When information changes

## Session Start

AI MUST read:
1. activeContext.md (current focus)
2. progress.md (status)

---

## Detailed Update Procedures

For comprehensive Memory Bank management guidelines, see:
**`.cursor/rules/memory-bank-management.mdc`**

This rule file contains:
- Complete update workflows for each file
- File hierarchy and dependency relationships
- Session start procedures
- Update triggers (when to update what)
- Quality checks before committing
- Troubleshooting common issues
- Anti-patterns to avoid

**When to reference this rule:**
- Starting a new project (initialization procedure)
- Completing a task (what to update)
- User says "update memory bank" (full review process)
- Weekly maintenance (keeping context current)

**Key principle**: Memory Bank is a LIVING system that evolves with your project. The more current it is, the better AI assistance you'll receive.
