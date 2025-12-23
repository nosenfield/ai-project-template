# Resume Handoff

You are tasked with resuming work from a handoff document created in a previous session.

## Initial Response

If no handoff path is provided:
```
Which handoff would you like to resume?

Please provide the path to the handoff file.
```

If handoff path is provided, read it fully.

## Process

### Step 1: Load and Validate Context

1. Read the handoff document completely
2. Verify the git branch matches (checkout if needed)
3. Check if the commit matches or if there have been changes
4. Review the list of modified files

### Step 2: Report Current State

```
Resuming: [Task Name]

From handoff: [Date of handoff]
Branch: [Branch name]
Status: [Status from handoff]

Progress at handoff:
- [x] [Completed items]
- [ ] [Remaining items] <- RESUMING HERE

Since handoff:
- [Any new commits or changes detected]

Key context:
- [Important decision or note from handoff]

Ready to continue with: [Immediate next step from handoff]

Should I proceed?
```

Wait for confirmation.

### Step 3: Continue Work

If there's an associated plan:
```
This task has an associated plan: [path]
Currently in Phase [N].

Loading plan context...
```

Read the plan and continue with `/implement_plan` workflow from the current phase.

If no plan:
Follow the "Immediate Next Steps" from the handoff document.

### Step 4: Address Blockers

If the handoff documented blockers:
```
The previous session noted these blockers:
- [Blocker]: [Details]

Has this been resolved? If not, how would you like to proceed?
```

Wait for guidance before continuing.

## Validation Checklist

Before proceeding with work:
- [ ] Correct branch checked out
- [ ] Understand the task context
- [ ] Know the current progress state
- [ ] Aware of any blockers or open questions
- [ ] Clear on immediate next steps

## Recovery

If the handoff is stale or context has changed significantly:
```
Note: The codebase has changed since this handoff.

Changes detected:
- [New commits / modified files]

Options:
1. Continue anyway (changes may not affect this task)
2. Re-research the affected areas before continuing
3. Create a new plan incorporating the changes

How would you like to proceed?
```
