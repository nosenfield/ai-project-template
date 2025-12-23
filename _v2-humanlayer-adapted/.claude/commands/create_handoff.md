# Create Handoff

You are tasked with creating a handoff document that captures the current state of work so it can be resumed in a new session. This ensures continuity across session boundaries.

## When to Use

- Before ending a session with work in progress
- When switching context to a different task
- When another agent or session will continue the work
- At natural breakpoints in complex implementations

## Process

### Step 1: Gather Current State

Collect the following information:
- Current git branch and commit
- Files modified but not committed
- Current phase of any active plan
- Recent decisions made
- Blockers or open questions

### Step 2: Create Handoff Document

Generate a handoff document with the following structure:

```markdown
---
date: [Current date and time in ISO format]
task: "[Task identifier or description]"
branch: [Current git branch]
commit: [Current commit hash]
status: [in-progress/blocked/ready-for-review]
---

# Handoff: [Task Name]

## Context
[Brief description of what this task is about]

## Current State

### Progress
- [x] [Completed item]
- [x] [Completed item]
- [ ] [In progress item] <- CURRENT
- [ ] [Remaining item]

### Active Plan
[Path to plan file if applicable]
Currently in: Phase [N]

### Modified Files (uncommitted)
- `path/to/file.ext` - [What was changed]

### Recent Decisions
- [Decision]: [Rationale]

## To Resume

### Immediate Next Steps
1. [First thing to do when resuming]
2. [Second thing to do]

### Commands to Run
```bash
git checkout [branch]
# [Any setup commands]
```

### Key Files to Review
- `path/to/file.ext` - [Why this is important]

## Open Questions
- [Question that needs resolution]

## Blockers (if any)
- [Blocker]: [Details and potential resolution]

## Notes for Next Session
[Any additional context that would be helpful]
```

### Step 3: Save and Report

Save the handoff document to a known location (e.g., `handoffs/` directory or project-specific location).

```
Handoff created: [path/to/handoff.md]

To resume this work in a new session:
/resume_handoff [path/to/handoff.md]

Summary:
- Task: [Task name]
- Status: [Status]
- Next step: [Immediate next action]
```

## Principles

- More information is better than less
- Include everything needed to resume without context loss
- Be specific about what was done and what remains
- Document decisions and their rationale
- Include exact commands and file paths
