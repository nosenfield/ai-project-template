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
