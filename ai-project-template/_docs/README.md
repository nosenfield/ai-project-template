# Project Documentation

This directory contains all documentation for your project.

## For New Developers

Read in this order:
1. [projectBrief.md](../memory-bank/projectBrief.md) - Project overview
2. [architecture.md](./architecture.md) - System design and tech stack
3. [task-list.md](./task-list.md) - Implementation roadmap

## For AI Sessions

**Start every session by reading:**
1. [activeContext.md](../memory-bank/activeContext.md) - Current work focus
2. [progress.md](../memory-bank/progress.md) - Task status

**When implementing features:**
- [architecture.md](./architecture.md) - System design reference
- [best-practices.md](./best-practices.md) - Stack-specific patterns

**After completing work:**
- Update Memory Bank files
- Update [progress.md](../memory-bank/progress.md) with completion status
- Document decisions in [activeContext.md](../memory-bank/activeContext.md)

## Documentation Structure

### Memory Bank (../memory-bank/)
Project context that AI reads every session.

### Boilerplate (_boilerplate/)
Template files used during project initialization. Not project-specific content.

### Best Practices (./best-practices/)
Stack-specific coding standards. Populated by Claude during project initialization based on chosen tech stack.

### Task List (./task-list/)
Chunked implementation tasks with cross-references. Created during initialization.

### Backups (_backups/)
Automated backups of documentation files before major restructuring operations. Created automatically when task-list.md is chunked into multiple files.

## Maintenance

Update documentation when:
- Completing features
- Making architectural decisions
- Discovering new patterns
- Every Friday (weekly review)
