# Update Memory Bank Command

Review and update Memory Bank (comprehensive).

## Process

### 1. Read ALL Files

**Memory Bank files to review**:
- [ ] projectbrief.md
- [ ] productContext.md
- [ ] activeContext.md
- [ ] systemPatterns.md
- [ ] techContext.md
- [ ] progress.md

### 2. Identify Outdated Information

**Check for**:
- Stale dates
- Completed tasks still marked as pending
- Decisions that changed
- Blockers that were resolved
- Old focus areas

### 3. Update activeContext.md

**Update**:
- Current focus (what we're working on NOW)
- Recent decisions (last 3 significant choices)
- Recent changes (last 3 modifications)
- Next steps (this session, this week)
- Blockers and open questions

### 4. Update progress.md

**Update**:
- Completed tasks (mark with [x])
- What's working (verified features)
- What's next (priority-ordered)
- Known issues (critical vs. non-blocking)
- Technical debt

### 5. Update Other Files (if changed)

**If applicable, update**:
- systemPatterns.md (if architecture changed)
- techContext.md (if dependencies/stack changed)
- productContext.md (if product direction shifted)

### 6. Update Cursor Rules (if new patterns)

**If discovered new patterns**:
- Add to appropriate .cursor/rules/*.mdc file
- Document the pattern
- Provide examples

### 7. Show Summary

**Report what was updated**:
```
📚 Memory Bank Updated

Files Modified:
- activeContext.md: [what changed]
- progress.md: [what changed]
- [other files]: [what changed]

Key Changes:
1. [Change 1]
2. [Change 2]
3. [Change 3]

Next Steps:
- [Immediate action 1]
- [Immediate action 2]
```

## When to Run This

- **Weekly**: General review and update
- **After major work**: Architecture changes, big features
- **When requested**: User asks to "update memory bank"
- **When context feels stale**: Information seems outdated
