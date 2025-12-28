# Review Command

Proactive code review for early feedback during development. This is OPTIONAL review for development iteration. Pre-commit hook provides MANDATORY final review.

## Usage

```
/review [--staged|--all|--files <paths>]
```

## Arguments

- `--staged`: Review only staged changes (default)
- `--all`: Review all uncommitted changes
- `--files <paths>`: Review specific files

## When to Use

- After implementation, before commit attempt
- To validate approach before investing more effort
- To check specific files mid-implementation

## Process

1. **Gather Changes**
   - Run `git diff --staged` (or appropriate variant)
   - Identify all modified files
   - Read original and modified versions

2. **Context Collection**
   - Read _docs/best-practices.md for standards
   - Read _docs/architecture.md for patterns
   - If feature-id available: Read feature requirements from _docs/specs/

3. **Review Categories**
   - **CRITICAL**: Must fix before commit
     - Bugs and logic errors
     - Security vulnerabilities
     - Breaking changes to interfaces
     - Missing error handling for critical paths
   - **WARNING**: Should fix
     - Code smells
     - Missing tests for new functionality
     - Unclear logic or naming
     - Performance concerns
   - **SUGGESTION**: Consider improving
     - Style improvements
     - Documentation opportunities
     - Optimization possibilities

4. **Verification Checks**
   - Tests exist for new functionality
   - No obvious regressions
   - Error handling present
   - Logging appropriate
   - Follows existing patterns

## Constraints

- NEVER modify files (read-only operation)
- Be objective and specific
- Reference specific line numbers
- Provide actionable feedback

## Output Format

```
## Code Review Report

### Summary
**Status**: [APPROVED / CHANGES REQUESTED]
**Files Reviewed**: [count]
**Issues Found**: [critical count] critical, [warning count] warnings, [suggestion count] suggestions

### Critical Issues
[If none: "None"]

#### Issue 1: [Title]
- **File**: [path]:[line]
- **Problem**: [description]
- **Fix**: [specific recommendation]

### Warnings
[If none: "None"]

#### Warning 1: [Title]
- **File**: [path]:[line]
- **Concern**: [description]
- **Recommendation**: [suggestion]

### Suggestions
[If none: "None"]

- [path]:[line] - [suggestion]

### Test Coverage
- New code has tests: [YES / NO / PARTIAL]
- Missing coverage: [list areas]

### Decision
[APPROVED] - Ready to commit
[APPROVED WITH NOTES] - Ready to commit, consider addressing suggestions
[CHANGES REQUESTED] - Must address critical issues before commit
```

## Error Handling

If no changes found:
1. Report "No changes to review"
2. Suggest checking git status

If files cannot be read:
1. Report which files failed
2. Continue review of accessible files
3. Note incomplete review in summary
