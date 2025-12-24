# TDD - Test-Driven Development

Execute a task using strict test-driven development workflow: RED (failing test) → GREEN (pass) → REFACTOR.

## Initial Response

```
I'll help you implement this using TDD.

Please provide:
1. What you want to implement
2. Expected behavior (inputs → outputs)
3. Any edge cases to consider
```

Wait for user input.

## Process

### Step 1: Understand Requirements

Confirm understanding:
```
I understand you want to implement:
- [Feature/function description]

Expected behavior:
- Given [input], expect [output]
- Given [edge case], expect [behavior]

Is this correct?
```

Wait for confirmation.

### Step 2: RED - Write Failing Test

```
Writing failing test first...
```

Create a test that:
- Describes the expected behavior
- Will fail because implementation doesn't exist yet
- Covers the primary use case

Run the test to confirm it fails:
```
Test written: [test file:line]

Running test...
Result: FAIL (expected - implementation doesn't exist yet)

Error: [Expected error message]

Proceeding to implementation...
```

### Step 3: GREEN - Minimal Implementation

```
Implementing minimal code to pass the test...
```

Write the simplest code that makes the test pass:
- No extra features
- No optimization
- Just enough to pass

Run the test:
```
Implementation complete: [file:line]

Running test...
Result: PASS

Test is green. Checking for refactoring opportunities...
```

### Step 4: REFACTOR - Improve Code

If refactoring needed:
```
Refactoring opportunities identified:
- [What could be improved]

Refactoring...
[Changes made]

Running tests to confirm they still pass...
Result: PASS

Refactoring complete.
```

If no refactoring needed:
```
Code is clean. No refactoring needed.
```

### Step 5: Expand Coverage

```
Core behavior implemented. Consider additional tests:

1. [ ] Edge case: [description]
2. [ ] Edge case: [description]
3. [ ] Error handling: [description]

Would you like me to add tests for any of these?
```

Wait for user direction.

### Step 6: Report Completion

```
TDD cycle complete.

Summary:
- Tests written: [N]
- Tests passing: [N]
- Files created/modified:
  - `path/to/test.ext` - Test file
  - `path/to/impl.ext` - Implementation

All tests green. Ready for code review.
```

## TDD Principles

1. **Never write implementation before test** - The test defines correct behavior
2. **One test at a time** - Focus on single behavior
3. **Minimal implementation** - Just enough to pass
4. **Refactor only when green** - Never refactor failing tests
5. **Tests are documentation** - They describe expected behavior

## Example Cycle

```
User: Implement a function to validate email addresses

Step 1: Write test
  test("validates correct email format", () => {
    expect(isValidEmail("user@example.com")).toBe(true);
  });

Step 2: Run test → FAIL (isValidEmail undefined)

Step 3: Implement
  function isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

Step 4: Run test → PASS

Step 5: Refactor if needed (extract regex to constant)

Step 6: Add edge case tests (empty string, missing @, etc.)
```
