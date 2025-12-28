# Map Command

Explore and map the codebase to identify files related to a specific system, feature, or mechanic.

## Usage

```
/map <target> [--depth quick|medium|thorough]
```

## Arguments

- `target`: The system, feature, pattern, or mechanic to explore
- `--depth`: Exploration depth (default: medium)
  - `quick`: 2-3 searches, fastest results
  - `medium`: 5-10 searches, follow references one level
  - `thorough`: Comprehensive multi-strategy search, full dependency mapping

## Process

1. Parse target and depth from arguments
2. Identify search strategies based on target type:
   - Feature: Search for feature flags, routes, components
   - System: Search for module boundaries, entry points
   - Pattern: Search for implementations, usages
   - Mechanic: Search for business logic, state management
3. Execute searches using appropriate tools:
   - `glob` for file patterns
   - `grep` for code patterns
   - `read` for file inspection
   - `bash` for git history, find commands
4. Map dependencies between discovered files
5. Synthesize findings into structured output
6. Save output to `_docs/exploration/{target-slug}.md`
7. Print summary and file path to console

## Constraints

- NEVER modify files (read-only operation)
- Bash commands limited to: ls, find, cat, head, tail, git status, git log, git diff
- Return concise summaries with absolute file paths
- Do NOT include file contents unless specifically relevant

## Output Format

Output is saved to `_docs/exploration/{target-slug}.md` where target-slug is the target converted to lowercase with spaces replaced by hyphens.

### File Content

```markdown
# Exploration: {target}

Generated: {ISO timestamp}
Depth: {quick|medium|thorough}

## Summary
[2-3 sentence overview of what was found]

## Files Found
- `/absolute/path/to/file.ts` - [brief description of relevance]
- `/absolute/path/to/other.ts` - [brief description]

## Architecture Observations
- [Key pattern or structure observed]
- [Dependency relationship noted]

## Entry Points
- [Primary file(s) to start with for this target]

## Related Systems
- [Other systems that interact with this target]
```

### Console Output

After saving, print:

```
Exploration saved to: _docs/exploration/{target-slug}.md

Summary: [2-3 sentence overview]

Entry points:
- [file1]
- [file2]
```

## Error Handling

If target cannot be found:
1. Report what was searched
2. Suggest alternative search terms
3. Ask for clarification if target is ambiguous
