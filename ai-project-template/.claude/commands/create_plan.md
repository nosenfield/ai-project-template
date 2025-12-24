# Create Plan

You are tasked with creating a detailed implementation plan for a feature or task. You will research the codebase first, then create a comprehensive plan for human approval.

## Initial Response

```
I'll help you create a detailed implementation plan.

Please provide:
1. The task or feature description
2. Any relevant context, constraints, or requirements
3. References to related files or documentation (if known)

Tip: For deeper analysis, include "think deeply" in your request.
```

Then wait for the user's input.

## Process

### Step 1: Gather Context

Before asking any questions, spawn parallel research tasks:

- Use **codebase-locator** to find all files related to the task
- Use **codebase-analyzer** to understand how the current implementation works
- Use **codebase-pattern-finder** to find similar implementations to use as reference

Identify specific directories to focus on based on the task description.

### Step 2: Read Critical Files

Read any files identified by research FULLY into context. Cross-reference with task requirements.

### Step 3: Ask Clarifying Questions

Based on your research, ask specific clarifying questions:

```
Based on my research, I have some questions before creating the plan:

1. [Specific question about scope or requirements]
2. [Question about technical approach based on findings]
3. [Question about constraints or dependencies]

My research found:
- [Relevant existing pattern or constraint]
- [Important discovery that affects the approach]
```

Wait for user responses.

### Step 4: Create the Plan

Generate a plan document with the following structure:

```markdown
---
date: [Current date in ISO format]
task: "[Task description]"
status: draft
---

# Implementation Plan: [Task Name]

## Overview
[Brief description of what will be implemented]

## Research Summary
[Key findings from codebase research that inform the approach]

## Scope

### In Scope
- [Specific item]

### Out of Scope
- [Specific item]

## Technical Approach
[High-level approach based on existing patterns]

## Implementation Phases

### Phase 1: [Name]
**Goal**: [What this phase accomplishes]

**Files to modify**:
- `path/to/file.ext` - [What changes]

**Files to create**:
- `path/to/new.ext` - [Purpose]

**Steps**:
1. [Specific step]
2. [Specific step]

**Verification**:
- [ ] [How to verify this phase is complete]

### Phase 2: [Name]
[Continue for each phase]

## Testing Strategy
- Unit tests: [What to test]
- Integration tests: [What to test]

## Success Criteria
- [ ] [Specific, measurable criterion]
- [ ] [Specific, measurable criterion]

## Risks and Mitigations
| Risk | Mitigation |
|------|------------|
| [Risk] | [Mitigation] |

## Dependencies
- [External dependency or prerequisite]
```

### Step 5: Present for Review

```
I've created the implementation plan.

Please review and let me know:
- Are the phases properly scoped?
- Are the success criteria specific enough?
- Any technical details that need adjustment?
- Missing edge cases or considerations?

Use `/iterate_plan` to make changes, or approve to proceed with `/implement_plan`.
```
