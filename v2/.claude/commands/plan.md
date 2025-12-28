# Plan Command

Create an implementation plan for a system, feature, or mechanic adhering to best practices, design patterns, and existing structures.

## Usage

```
/plan <feature-id|description> [--pipeline]
```

## Arguments

- `feature-id|description`: Feature ID from feature-list.json OR natural language description
- `--pipeline`: Enable full pipeline mode (spec → arch → build → review)

## Process

1. **Understand Requirements**
   - If feature-id: Read feature from feature-list.json
   - If description: Parse requirements from input
   - Identify acceptance criteria

2. **Check for Existing Exploration**
   - Look for `_docs/exploration/{relevant-target}.md`
   - If found: Read and use as context
   - If not found: Run exploration internally or delegate to explorer

3. **Research Codebase** (if no existing exploration)
   - Find existing patterns for similar features
   - Identify affected modules
   - Map dependencies
   - Locate test patterns

4. **Assess Complexity**
   - Count estimated files to modify
   - Identify cross-module boundaries
   - Evaluate risk factors
   - Determine if pipeline is recommended

5. **Create Implementation Plan**
   - Define implementation sequence
   - Specify files to create/modify
   - Outline test strategy
   - Note potential blockers

6. Save output to `_docs/specs/{feature-id}.md`
7. Print summary and file path to console

## Constraints

- NEVER modify files during planning (read-only)
- Plans must be actionable by /implement command
- Each step must have clear success criteria
- Identify risks and mitigations

## Output Format

Output is saved to `_docs/specs/{feature-id}.md`. If input was a description rather than feature-id, generate a slug from the description.

### File Content

```markdown
# Plan: {Feature ID or Title}

Generated: {ISO timestamp}
Feature: {feature-id or "ad-hoc"}
Status: READY_FOR_IMPLEMENTATION

## Requirements Analysis
[Summary of what needs to be built]

## Affected Modules
| Module | Impact | Risk |
|--------|--------|------|
| [module] | [how affected] | [low/medium/high] |

## Implementation Sequence

### Step 1: [Title]
- Files: [list of files]
- Action: [what to do]
- Success Criteria: [how to verify]

### Step 2: [Title]
...

## Test Strategy
- Unit tests: [approach]
- Integration tests: [approach]
- E2E verification: [approach]

## Risks and Mitigations
| Risk | Likelihood | Mitigation |
|------|------------|------------|
| [risk] | [low/med/high] | [mitigation] |

## Checklist
- [ ] Requirements clear
- [ ] Dependencies identified
- [ ] No blocking questions
```

### Console Output

After saving, print:

```
Plan saved to: _docs/specs/{feature-id}.md

Affected modules: [count]
Implementation steps: [count]
Risk level: [overall assessment]

Ready for: /implement {feature-id}
```

## Error Handling

If requirements are unclear:
1. List specific questions that need answers
2. Provide options where applicable
3. Do NOT proceed with assumptions on critical requirements
