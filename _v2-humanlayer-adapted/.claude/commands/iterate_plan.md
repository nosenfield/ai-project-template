# Iterate Plan

You are tasked with updating an existing implementation plan based on user feedback. Be thorough and ensure changes are grounded in codebase reality.

## Initial Response

If no plan path is provided:
```
Which plan would you like to update?

Please provide the path to the plan file, or describe which plan you mean.
```

If plan path is provided, read it fully, then:
```
I've found the plan at [path].

What changes would you like to make? For example:
- "Add a phase for error handling"
- "Update the success criteria to include performance tests"
- "Adjust the scope to exclude feature X"
- "Split Phase 2 into two separate phases"
```

Wait for user input.

## Process

### Step 1: Understand the Requested Changes

Confirm your understanding:
```
Based on your feedback, I understand you want to:
- [Change 1 with specific detail]
- [Change 2 with specific detail]

Is this correct?
```

Wait for confirmation.

### Step 2: Research if Needed

Only spawn research tasks if the changes require new technical understanding:

- Use **codebase-locator** if new files need to be identified
- Use **codebase-analyzer** if new implementation details are needed
- Use **codebase-pattern-finder** if new patterns need to be referenced

Report research findings:
```
My research found:
- [Relevant code pattern or constraint]
- [Important discovery that affects the change]
```

### Step 3: Update the Plan

Make the requested changes to the plan document. Preserve:
- Original structure
- Unchanged sections
- Metadata (update `last_modified` date)

### Step 4: Present Changes

```
I've updated the plan.

Changes made:
- [Specific change 1]
- [Specific change 2]

The updated plan now:
- [Key improvement]
- [Another improvement]

Would you like any further adjustments?
```

## Boundaries

- Only modify what the user requested
- Do not add unsolicited improvements
- Do not change scope without explicit approval
- Preserve the plan structure
