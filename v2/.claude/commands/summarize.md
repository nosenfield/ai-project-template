# Summarize Command

Generate a summary of current context for compaction or handoff.

## Usage

```
/summarize [--compact]
```

## Arguments

- `--compact`: Generate minimal summary for context compaction

## Process

1. **Gather Context**
   - Current feature and status
   - Recent work (from activeContext.md)
   - Key decisions made
   - Open issues

2. **Generate Summary**
   - If --compact: Minimal format for context preservation
   - Otherwise: Readable format for humans

## Output Format

### Standard Format
```
## Session Summary

### Current Focus
Feature [id]: [description]
Status: [X of Y steps complete]

### Completed This Session
- [Item 1]
- [Item 2]

### Key Decisions
- [Decision 1]: [rationale]
- [Decision 2]: [rationale]

### Open Questions
- [Question 1]

### Next Steps
1. [Step 1]
2. [Step 2]
```

### Compact Format (--compact)
```
## Context Compacted

Session: [timestamp]
Feature: [id] - [status]
Branch: [branch]

Progress:
- [Task]: [status] (commit: [hash])

Decisions:
- [Key decision 1]

Resume: [specific next action]
```
