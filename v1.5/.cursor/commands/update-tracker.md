# Update Task Tracker Command

Update the task tracker (_docs/task-tracker.md) with completed task information.

**Use this when**: You've completed one or more tasks and need to update the progress tracking document.

**Note**: The `/one-shot` and `/batch` commands should automatically call this at the end of each task completion.

---

## Workflow Overview

This command updates _docs/task-tracker.md with:
1. Task status changes ([ ] → [>] → [x])
2. Progress percentages
3. Completion log entries

---

## Step 1: Read Current State

### Files to Read

**Task Tracker**:
- _docs/task-tracker.md (current progress state)

**Memory Bank** (for cross-reference):
- memory-bank/progress.md (verified completions)
- memory-bank/activeContext.md (recent changes)

---

## Step 2: Identify Task to Update

For each completed task, identify:

### Required Information
- **Task ID** (e.g., 0.3, 1.1, 2.2)
- **Task Name** (from task-list.md)
- **Status** ([ ] Not Started, [>] In Progress, [x] Completed, [~] Skipped)
- **Completion Date** (today's date or specified)

---

## Step 3: Update Task Status

### Change Task Checkbox

For each task, update the checkbox:

**Before:**
```markdown
- [ ] 1.1 - DynamoDB Client & Base Repository
```

**After:**
```markdown
- [x] 1.1 - DynamoDB Client & Base Repository
```

### Status Symbols

- `[ ]` Not Started
- `[>]` In Progress
- `[x]` Completed
- `[~]` Skipped

---

## Step 4: Update Phase Progress

Recalculate the progress for the phase:

**Before:**
```markdown
## Phase 1: Data Layer & Storage

**Progress:** 0/5 (0%)
```

**After:**
```markdown
## Phase 1: Data Layer & Storage

**Progress:** 1/5 (20%)
```

---

## Step 5: Update Progress Summary

Recalculate all statistics in the Progress Summary section:

### Overall Progress

**Before:**
```markdown
**Overall:** 4/71 tasks complete (5.6%)
```

**After:**
```markdown
**Overall:** 5/71 tasks complete (7.0%)
```

### By Phase

**Before:**
```markdown
**By Phase:**
- Phase 0: 4/4 (100%)
- Phase 1: 0/5 (0%)
```

**After:**
```markdown
**By Phase:**
- Phase 0: 4/4 (100%)
- Phase 1: 1/5 (20%)
```

---

## Step 6: Update Completion Log

Add entry to the Completion Log at the bottom:

**If date already exists**, append to that date:
```markdown
### 2025-11-10
- Completed: 0.1, 0.2, 0.3, 0.4, 1.1
- Phase 0 complete (100%)
- Phase 1 started (20%)
```

**If new date**, create new entry:
```markdown
### 2025-11-11
- Completed: 1.2, 1.3
- Phase 1 progress (60%)
```

---

## Step 7: Update Last Updated Date

Update the date at the top of the file:

```markdown
**Last Updated:** 2025-11-11
```

---

## Complete Example

### Before Update

```markdown
# Vocabulator MVP Task Tracker

**Last Updated:** 2025-11-10

---

## Progress Summary

**Overall:** 4/71 tasks complete (5.6%)

**By Phase:**
- Phase 0: 4/4 (100%)
- Phase 1: 0/5 (0%)

---

## Phase 1: Data Layer & Storage

**Progress:** 0/5 (0%)

- [ ] 1.1 - DynamoDB Client & Base Repository
- [ ] 1.2 - Student Profile Data Model & Repository
- [ ] 1.3 - Vocabulary Recommendation Data Model & Repository
- [ ] 1.4 - S3 Client & File Operations
- [ ] 1.5 - Common Core Vocabulary Database

---

## Completion Log

### 2025-11-10
- Completed: 0.1, 0.2, 0.3, 0.4
- Phase 0 complete (100%)
```

### After Completing Task 1.1

```markdown
# Vocabulator MVP Task Tracker

**Last Updated:** 2025-11-10

---

## Progress Summary

**Overall:** 5/71 tasks complete (7.0%)

**By Phase:**
- Phase 0: 4/4 (100%)
- Phase 1: 1/5 (20%)

---

## Phase 1: Data Layer & Storage

**Progress:** 1/5 (20%)

- [x] 1.1 - DynamoDB Client & Base Repository
- [ ] 1.2 - Student Profile Data Model & Repository
- [ ] 1.3 - Vocabulary Recommendation Data Model & Repository
- [ ] 1.4 - S3 Client & File Operations
- [ ] 1.5 - Common Core Vocabulary Database

---

## Completion Log

### 2025-11-10
- Completed: 0.1, 0.2, 0.3, 0.4, 1.1
- Phase 0 complete (100%)
- Phase 1 started (20%)
```

---

## Status Change Examples

### Marking Task as In Progress

**Before:**
```markdown
- [ ] 1.2 - Student Profile Data Model & Repository
```

**After:**
```markdown
- [>] 1.2 - Student Profile Data Model & Repository
```

### Marking Task as Completed

**Before:**
```markdown
- [>] 1.2 - Student Profile Data Model & Repository
```

**After:**
```markdown
- [x] 1.2 - Student Profile Data Model & Repository
```

### Marking Task as Skipped

**Before:**
```markdown
- [ ] 6.4 - Monitoring & Alerting Setup (P1)
```

**After:**
```markdown
- [~] 6.4 - Monitoring & Alerting Setup (P1)
```

Add to Completion Log:
```markdown
### 2025-11-15
- Skipped: 6.4 (P1 priority, deferred post-MVP)
```

---

## Batch Update Support

When multiple tasks completed in a batch:

### Update All Tasks at Once

**Before:**
```markdown
- [ ] 0.3 - Configuration Management System
- [ ] 0.4 - Logging Utility Setup
```

**After:**
```markdown
- [x] 0.3 - Configuration Management System
- [x] 0.4 - Logging Utility Setup
```

### Update Completion Log Once

```markdown
### 2025-11-10
- Completed: 0.3, 0.4
- Phase 0 progress (100%)
```

---

## Automatic Update Flow

**When called by `/one-shot` or `/batch`:**

1. Read _docs/task-tracker.md
2. Read memory-bank/progress.md to verify completion
3. Find task by ID in tracker
4. Change checkbox: [ ] → [x]
5. Recalculate phase progress (e.g., 0/5 → 1/5, 0% → 20%)
6. Recalculate overall progress (e.g., 4/71 → 5/71, 5.6% → 7.0%)
7. Update "By Phase" summary
8. Add/update completion log entry
9. Update "Last Updated" date
10. Save _docs/task-tracker.md

---

## Manual Usage Example

**User**: `/update-tracker 1.1`

**AI executes**:

1. Reads _docs/task-tracker.md
2. Reads memory-bank/progress.md for verification
3. Finds task 1.1 in Phase 1 section
4. Updates checkbox: `- [ ] 1.1` → `- [x] 1.1`
5. Updates Phase 1 progress: `0/5 (0%)` → `1/5 (20%)`
6. Updates overall progress: `4/71 (5.6%)` → `5/71 (7.0%)`
7. Updates "By Phase" summary: `Phase 1: 0/5 (0%)` → `Phase 1: 1/5 (20%)`
8. Adds to completion log: `- Completed: 1.1` under today's date
9. Updates "Last Updated" date to today
10. Saves file

**Output**:
```
Task Tracker Updated

Updated: Task 1.1 - DynamoDB Client & Base Repository
Status: [x] Complete

Overall Progress: 5/71 tasks (7.0%)
Phase 1 Progress: 1/5 tasks (20%)

Next Task: 1.2 - Student Profile Data Model & Repository

File: _docs/task-tracker.md
```

---

## Integration with Other Commands

### Called Automatically By

**`/one-shot`** - After task completion:
```
1. Plan task
2. Implement task
3. Test task
4. Update memory bank
5. Commit changes
6. → Update task tracker ← (automatic)
7. Report completion
```

**`/batch`** - After each task in batch:
```
For each task:
  1. Execute one-shot workflow
  2. → Update task tracker ← (automatic)
  3. Continue to next task
```

### Manual Invocation

Update single task:
```
/update-tracker 1.1
```

Update multiple tasks:
```
/update-tracker 1.1 1.2 1.3
```

---

## Validation Rules

### Before Updating

1. Task ID exists in task-list.md
2. Task marked complete in memory-bank/progress.md
3. Current status is [ ] or [>] (not already [x])

### After Updating

1. All percentages calculated correctly
2. Task counts consistent (completed + remaining = total)
3. Completion log entry added
4. "Last Updated" date is current

---

## Percentage Calculation

### Phase Progress

```
Progress = (Completed Tasks / Total Tasks in Phase) × 100
```

Example:
- Phase 1 has 5 tasks
- 1 task completed
- Progress: (1/5) × 100 = 20%

### Overall Progress

```
Progress = (Total Completed Tasks / Total Tasks) × 100
```

Example:
- Total tasks: 71
- Completed: 5
- Progress: (5/71) × 100 = 7.0%

---

## Output Format

After updating tracker:

```
Task Tracker Updated

Tasks Updated: [count]
- [task-id-1]: [x]
- [task-id-2]: [x]

Overall Progress: [N]/71 ([X]%)
Current Phase: Phase [N] ([X]% complete)
Next Task: [task-id] - [task-name]

File: _docs/task-tracker.md
```

---

## Rules & Constraints

### MUST DO

1. Read current tracker state before updating
2. Verify task completion in memory bank
3. Recalculate all percentages accurately
4. Update completion log with date
5. Update "Last Updated" date
6. Maintain simple checkbox format

### MUST NOT DO

1. Update tracker for incomplete tasks (unless marking as [>])
2. Skip recalculating percentages
3. Use emojis (tracker is emoji-free)
4. Add time estimates, commits, or notes (keep it simple)
5. Update task-list.md (reference document, stays unchanged)

---

## Troubleshooting

### "Task not found in task-list.md"
- Verify task ID is correct
- Check task-list.md or phase detail files
- Ensure task exists in master task list

### "Percentages don't add up"
- Recount completed tasks in phase
- Verify math: (completed / total) × 100
- Round to one decimal place

### "Task already marked complete"
- Check current status in tracker
- Verify if update is needed
- Don't duplicate [x] status

---

**Remember:** The task tracker is intentionally simple - just checkboxes and percentages. Keep updates minimal and focused on completion status only.
