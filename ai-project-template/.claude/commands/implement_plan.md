# Implement Plan

Implement an approved plan using test-driven development. Focus on execution, not re-planning. Maintain forward momentum while ensuring quality.

## Initial Response

If no plan path is provided:
```
Which plan would you like to implement?

Please provide the path to the plan file.
```

If plan path is provided, read it fully, then:
```
I've loaded the plan: [Plan Name]

This plan has [N] phases:
1. [Phase 1 name] - [Brief description]
2. [Phase 2 name] - [Brief description]
...

Ready to begin implementation. Should I start with Phase 1?
```

Wait for approval to proceed.

## Process

### For Each Phase

#### Step 1: Announce Phase Start

```
Starting Phase [N]: [Phase Name]

Goal: [Phase goal from plan]

Files to modify:
- [List from plan]

I'll implement this phase using TDD and report back when complete.
```

#### Step 2: Research Existing Patterns

Use **codebase-pattern-finder** to find similar implementations. Follow existing conventions.

#### Step 3: Implement with TDD

For each change:
1. Write failing test first (RED)
2. Implement minimal code to pass (GREEN)
3. Refactor if needed (tests stay green)
4. Verify before proceeding

#### Step 4: Verify Phase Completion

Run through the phase's verification checklist from the plan.

#### Step 5: Report Phase Completion

```
Phase [N] complete.

Changes made:
- `file.ext` - [What was changed]

Tests run:
- [Test]: [pass/fail]

Verification:
- [x] [Checklist item from plan]

Ready to proceed to Phase [N+1]?
```

Wait for approval before proceeding to next phase.

### After All Phases

```
Implementation complete.

Summary:
- Phases completed: [N]
- Files modified: [List]
- Files created: [List]
- Tests: [All passing / X failing]

Recommend running `/code_review` before committing.
```

## Boundaries

- Follow the plan precisely
- Use TDD for all implementation
- Stop and report blockers immediately
- Request approval between phases

## Recovery

If something goes wrong:
```
Blocker encountered in Phase [N]:

Issue: [Description]
Location: `file.ext:line`
Impact: [What this blocks]

Options:
1. [Possible resolution]
2. [Alternative approach]
3. Pause and revise the plan

How would you like to proceed?
```
