# Pause Development Session

Gracefully pause development and save current state for later resumption.

**Use this when**: Taking a break, switching projects, ending work session, or need to step away.

---

## Workflow

### Step 1: Assess Current State

Run git status to determine current work state:

```bash
git status --short
```

Determine:
- Are there uncommitted changes?
- Is current task nearly complete (1-2 steps away)?
- Is current task mid-operation?

### Step 2: Complete or Rollback

**If task is 1-2 steps from completion:**
- Finish the current atomic operation
- Run tests to verify
- Commit the completed work
- Update progress.md

**If task is mid-operation:**
- Assess if changes should be committed as WIP
- If yes: commit with `[WIP]` marker
- If no: stash or discard uncommitted changes
- Goal: reach clean working directory

**If no work in progress:**
- Skip to Step 3

### Step 3: Commit Completed Work (if any)

Stage and commit any finished work:

```bash
git add file1.ts file2.ts test.test.ts
git commit -m "feat: implement feature X

[Description of changes]

- Key change 1
- Key change 2
"
```

**For WIP commits:**
```bash
git commit -m "wip: partial implementation of feature X [WIP]

[What's done, what remains]
"
```

### Step 4: Verify Clean State

```bash
git status
```

Working directory should be:
- Clean (no uncommitted changes), OR
- Changes documented and intentionally left unstaged

### Step 5: Update Memory Bank

Update memory bank files to reflect current state:

**Update activeContext.md:**
- Current focus and context
- Recent decisions or discoveries
- Any important patterns or considerations

**Update progress.md:**
- Mark completed tasks
- Update task progress percentages
- Note any blockers or open questions

### Step 6: Create Pause Checkpoint

Create `memory-bank/pauseCheckpoint.md` with structured state:

```markdown
# Pause Checkpoint - [YYYY-MM-DD HH:MM]

## Session Summary
[Brief description of what was worked on this session]

## Completed This Session
- ✅ Task [ID]: [Name]
- ✅ Task [ID]: [Name]
- ✅ [Other accomplishments]

## In Progress
[If applicable]
- 🔄 Task [ID]: [Name] ([X]% complete)
  - Completed: [What's done]
  - Remaining: [What's left]

## Next Steps (When Resuming)
1. [Specific next step]
2. [Specific next step]
3. [Specific next step]

[Be as specific as possible - "Write integration tests for UserService.createUser()"]

## Current State
- **Branch**: [branch-name]
- **Last commit**: [hash] [commit message]
- **Working directory**: [CLEAN / WIP committed / Unstaged changes]
- **All tests**: [PASSING / X failing]
- **Memory bank**: [UP TO DATE / needs update]

## Open Questions / Blockers
[If none, write "None"]
- [Question or blocker 1]
- [Question or blocker 2]

## Files Modified (if uncommitted)
[If none, write "None - clean working directory"]
- [file1.ts] - [brief description]
- [file2.ts] - [brief description]

## Context for Resumption
[2-3 sentences describing where we are in the project, what we're building,
and what the immediate focus should be when resuming]

## Notes
[Any additional context, warnings, or considerations for next session]
```

### Step 7: Commit Memory Bank Updates

Commit the memory bank changes (including pause checkpoint):

```bash
git add memory-bank/activeContext.md memory-bank/progress.md memory-bank/pauseCheckpoint.md
git commit -n -m "docs: pause checkpoint - [brief session description] [skip-review]

Updated memory bank with current development state and created pause
checkpoint for session resumption.

Session summary:
- [Completed work]
- [Current state]
- [Next steps documented]

Bypassed code review: non-code files (memory bank update)"
```

Use `-n` flag and `[skip-review]` marker (authorized bypass).

### Step 8: Final Verification

```bash
git status
git log --oneline -1
```

Verify:
- ✅ Working directory is clean
- ✅ Memory bank is committed
- ✅ pauseCheckpoint.md exists and is committed
- ✅ Last commit includes checkpoint

### Step 9: Report to User

```markdown
# Development Session Paused

## Session Summary
**Duration**: [X hours]
**Work completed**: [Brief summary]

## Completed This Session
- ✅ Task [ID]: [Name]
- ✅ [Other work]

## Current State
- **Branch**: [branch-name]
- **Last commit**: [hash]
- **Working directory**: CLEAN ✅
- **Tests**: All passing ✅
- **Checkpoint**: Saved to memory-bank/pauseCheckpoint.md

## Next Steps (When Resuming)
1. [Next step 1]
2. [Next step 2]
3. [Next step 3]

## To Resume
Run `/begin-development` in your next session. The checkpoint will be
automatically detected and you'll be presented with resumption context.

---

✅ Session paused successfully. Safe to close.
```

---

## Rules & Constraints

### MUST DO

1. ✅ Assess current state before making changes
2. ✅ Complete or rollback current operation (reach clean state)
3. ✅ Commit any completed work
4. ✅ Update memory bank (activeContext, progress)
5. ✅ Create detailed pause checkpoint
6. ✅ Commit memory bank with [skip-review] marker
7. ✅ Verify clean working directory
8. ✅ Provide clear resumption instructions

### MUST NOT DO

1. ❌ Leave uncommitted code changes without documentation
2. ❌ Create checkpoint without updating memory bank
3. ❌ Use `git add .` or `git add -A`
4. ❌ Commit checkpoint through normal review workflow (use -n + [skip-review])
5. ❌ Leave failing tests
6. ❌ Skip verification steps
7. ❌ Create vague "next steps" (be specific!)

### WIP Commits

If committing work-in-progress:
- Use `[WIP]` marker in subject line
- Clearly document what's done vs what remains
- Explain why stopping mid-task
- Include in pause checkpoint

---

## Example Scenarios

### Scenario 1: Task Nearly Complete

```
User: /pause

Agent:
Checking current state...

Current task (0.5: Error handling) is 90% complete.
Only integration tests remain (estimated 10-15 min).

Completing current task before pausing...

[Writes integration tests]
[Runs tests - all pass]
[Commits completed task]
[Updates progress.md]
[Creates pause checkpoint]
[Commits memory bank]

Development Session Paused

Session Summary:
- ✅ Completed Task 0.5: Error handling patterns
- All tests passing
- Ready to start Task 0.6 on resume

Next steps: Begin Task 0.6 (Input validation)
```

### Scenario 2: Task Mid-Operation

```
User: /pause

Agent:
Checking current state...

Current task (1.3: User service) is 40% complete.
Mid-operation: implementing createUser method.

Current changes:
- UserService class structure complete
- createUser method partial implementation
- Tests not yet written

Committing as WIP...

[Commits with [WIP] marker]
[Creates pause checkpoint with detailed state]
[Updates memory bank]
[Commits memory bank]

Development Session Paused

Session Summary:
- 🔄 Task 1.3 (40% complete) - WIP committed
- createUser() partial implementation
- Tests needed next

Next steps:
1. Write tests for createUser()
2. Complete createUser() implementation
3. Write integration tests
```

### Scenario 3: No Work in Progress

```
User: /pause

Agent:
Checking current state...

Working directory is clean.
Last commit: feat: implement logging utilities

No active work in progress.

[Updates memory bank with current context]
[Creates pause checkpoint]
[Commits memory bank]

Development Session Paused

Session Summary:
- No work in progress
- Last completed: Task 0.4 (Logging utilities)
- Ready to start Task 0.5 on resume

Next steps: Begin Task 0.5 (Error handling patterns)
```

---

## Resumption Flow

When user runs `/begin-development` in next session:

1. **Agent detects** `memory-bank/pauseCheckpoint.md`
2. **Agent reads** checkpoint + memory bank
3. **Agent presents** resume summary (see begin-development.md)
4. **User confirms** continuation
5. **Agent deletes** pauseCheckpoint.md
6. **Agent proceeds** with documented next steps

---

## When to Use

### Use `/pause` when:
- ✅ Taking a break (lunch, end of day)
- ✅ Switching to different project
- ✅ Need to context switch
- ✅ Want clean handoff for later
- ✅ Session ending naturally

### Don't use `/pause` when:
- ❌ In middle of reviewing agent's work
- ❌ Agent is actively executing tasks
- ❌ Emergency stop needed (just stop)
- ❌ About to provide feedback (finish the interaction first)

---

**Remember**: The goal is to reach a clean, documented state that makes resumption seamless. Future you will thank present you for detailed next steps!
