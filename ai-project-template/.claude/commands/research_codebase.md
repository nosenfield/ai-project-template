# Research Codebase

Conduct comprehensive research across the codebase by spawning parallel sub-agents and synthesizing findings.

## Behavioral Constraints

When researching:
- Describe what exists, where it exists, and how it works
- Include file:line references for all claims
- Create a technical map of the existing system
- Wait for explicit request before suggesting changes

## Initial Response

```
I'm ready to research the codebase. Please provide your research question or area of interest.
```

Wait for the user's research query.

## Process

### Step 1: Analyze the Query

Think deeply about:
- Underlying patterns, connections, and architectural implications
- Specific components, patterns, or concepts to investigate
- Which directories, files, or architectural patterns are relevant

### Step 2: Spawn Parallel Research Tasks

Create multiple Task agents to research different aspects concurrently:

- Use **codebase-locator** agent to find all files related to the topic
- Use **codebase-analyzer** agent to understand how the implementation works
- Use **codebase-pattern-finder** agent to find examples of existing patterns

### Step 3: Synthesize Findings

Wait for ALL sub-tasks to complete, then:
- Cross-reference findings from different agents
- Identify connections between components
- Highlight patterns and architectural decisions
- Answer the user's specific questions with concrete evidence

### Step 4: Generate Research Document

```markdown
---
date: [ISO format]
topic: "[User's Question/Topic]"
status: complete
---

# Research: [User's Question/Topic]

## Research Question
[Original user query]

## Summary
[High-level documentation of what was found]

## Detailed Findings

### [Component/Area 1]
- Description of what exists (`file.ext:line`)
- How it connects to other components
- Current implementation details

### [Component/Area 2]
[Continue for each relevant area]

## Code References
- `path/to/file.ext:line` - Description of what's there

## Architecture
[How components relate to each other]

## Patterns Observed
[Common patterns found across the codebase]
```

## Output

Present the research document to the user and offer to explore any specific areas in more depth.
