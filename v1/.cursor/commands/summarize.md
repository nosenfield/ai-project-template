# Summarize Command

Create context summary in _context-summaries/ directory.

## When to Use

**Create detailed summary for**:
- ✅ Complex tasks with non-obvious solutions
- ✅ Important architectural decisions
- ✅ Difficult bug fixes
- ✅ Tricky integrations or configurations

**Skip summary for**:
- ❌ Straightforward implementations
- ❌ Simple CRUD operations
- ❌ Trivial bug fixes

## Summary Template

```markdown
# Session Summary: [DATE]

**Task(s)**: [task-id(s)]
**Duration**: [X hours]
**Status**: [Complete / In Progress / Blocked]

## What Was Accomplished

[Brief summary of work done]

### Files Changed
- [list key files modified]

### Key Decisions

1. **Decision**: [what was decided]
   **Rationale**: [why]
   **Impact**: [what this affects]

2. **Decision**: [what was decided]
   **Rationale**: [why]
   **Impact**: [what this affects]

## Non-Obvious Solutions

[Only include if task was complex/critical]

**Problem**: [what was tricky]
**Solution**: [how we solved it]
**Why this approach**: [reasoning]
**Watch out for**: [future considerations]

## Testing Approach

[Brief description of tests added/updated]
- Unit: [coverage]
- Integration: [what was tested]
- E2E: [if applicable]

## Blockers / Open Questions

[List any issues that need resolution]

## Next Steps

- [ ] Next task or follow-up work
- [ ] Technical debt to address
- [ ] Documentation to update

## Memory Bank Updates

- [x] activeContext.md updated
- [x] progress.md updated
- [ ] systemPatterns.md (if needed)
```

## Naming Convention

Save to: `_context-summaries/[YYYY-MM-DD]-[description].md`

Example: `_context-summaries/2025-11-03-auth-implementation.md`

## Note

_context-summaries/ is gitignored - these are ephemeral session notes.
Memory Bank files are the source of truth.
