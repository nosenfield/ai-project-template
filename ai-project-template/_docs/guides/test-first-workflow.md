# Test-First Development Workflow

## Overview

Write tests BEFORE implementation to:
- Define "correct" behavior
- Catch regressions automatically
- Enable self-correcting AI loop
- Reduce manual QA

## Process

### Step 1: Write Failing Tests (RED)

**Prompt for TESTING Agent**:
```
You are the TESTING agent.

Feature: [Description]

Create comprehensive tests (DO NOT implement):
1. Happy path test cases
2. Edge cases
3. Error handling scenarios
4. Integration tests

Tests will FAIL initially (no implementation exists).
Use descriptive test names with AAA pattern.
```

**Output**: Test suite that fails (red phase)

### Step 2: Implement Feature (GREEN)

**Prompt for Implementation Agent**:
```
You are the [BACKEND/FRONTEND] agent.

Tests defined here: [link to test file]
Currently all tests are FAILING.

Implement feature to make ALL tests pass.

Requirements:
- Follow architecture patterns
- Match test expectations exactly
- Add appropriate logging
- Handle all edge cases

DO NOT modify tests unless they have errors.
```

**Output**: Implementation that passes tests (green phase)

### Step 3: Auto-Verification Loop

```bash
# Run tests
npm test

# If tests fail:
# 1. AI analyzes failure output
# 2. AI proposes fix
# 3. Apply fix
# 4. Run tests again
# 5. Repeat until all green
```

### Step 4: Refactor (REFACTOR)

**Only after tests are green**:
```
Tests passing. Review for:
- Code duplication
- Performance improvements
- Clarity enhancements

Refactor ONLY while maintaining green tests.
```

### Step 5: Commit (Only When Green)

```bash
# Pre-commit hook verifies tests pass
git commit -m "feat: [feature]"
# → Tests run automatically
# → Commit blocked if any failures
```

## Benefits

- ✅ Regressions caught immediately
- ✅ "Done" clearly defined (tests pass)
- ✅ AI self-corrects mistakes
- ✅ Less manual QA needed
- ✅ High confidence in changes

---

## Memory Bank Integration

Test-first workflow integrates with Memory Bank at key points:

### After Writing Tests (RED Phase)

Update `memory-bank/activeContext.md`:
```markdown
### Current Focus
Writing tests for [feature]
Tests defined but failing (RED phase)

### Next Steps
- Implement feature to pass tests
- Verify self-correction loop
```

### After Implementation (GREEN Phase)

Update `memory-bank/progress.md`:
```markdown
### What's Working
- [x] [Feature name] - Tests passing
  - Test coverage: [percentage]
  - All acceptance criteria met
```

Update `memory-bank/activeContext.md`:
```markdown
### Recent Changes
- [Feature] implemented (Nov 3)
  - Tests written first (TDD approach)
  - Self-correction loop validated
  - [Specific implementation notes]
```

### After Refactoring (REFACTOR Phase)

Update `memory-bank/activeContext.md` if patterns changed:
```markdown
### Recent Changes
- Refactored [component] for performance
  - Tests remained green throughout
  - [Performance improvement details]
```

If pattern is reusable, also update `memory-bank/systemPatterns.md`:
```markdown
## [Pattern Name]

Context: Discovered during [feature] refactoring
Pattern: [Description]
When to use: [Guidelines]
```

### Complete Procedures

For full Memory Bank update workflows, see:
`.cursor/rules/memory-bank-management.mdc`

**Key rule**: Update Memory Bank AFTER each phase (RED, GREEN, REFACTOR), not just at final completion.

## Test Templates

Use from `tests/patterns/`:
- `crud.test.ts` - CRUD operations
- `async.test.ts` - Async workflows
- `error.test.ts` - Error handling
- `performance.test.ts` - Benchmarks

## Common Mistakes

❌ **Writing tests after implementation**
→ Loses TDD benefits

❌ **Modifying tests to pass**
→ Tests should define requirements

❌ **Skipping edge cases**
→ Creates blind spots

❌ **No test for bug fixes**
→ Bugs can reappear

## Red-Green-Refactor Cycle

```
RED: Write failing test
  ↓
GREEN: Make it pass (simplest way)
  ↓
REFACTOR: Improve code quality
  ↓
Commit (tests still green)
  ↓
[Repeat for next feature]
```
