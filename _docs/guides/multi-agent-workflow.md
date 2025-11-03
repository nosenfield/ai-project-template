# Multi-Agent Workflow Guide

## Agent Role Definitions

### 1. PLANNER Agent

**Role**: Break down features into implementable tasks

**Prompt Template**:
```
You are the PLANNER agent.

Analyze [feature] and create:
1. Task breakdown (each <4 hours)
2. Dependency graph
3. Implementation sequence
4. Acceptance criteria
5. Risk factors

Output structured plan.
```

**Deliverables**:
- Task list with dependencies
- Implementation order
- Success criteria
- Risk assessment

---

### 2. BACKEND Agent

**Role**: API endpoints, business logic, database

**Requirements Before Starting**:
- Architecture from PLANNER
- API contracts defined
- Database schema

**Quality Gates**:
- [ ] Tests pass
- [ ] API matches contract
- [ ] Error handling complete
- [ ] Logging implemented

---

### 3. FRONTEND Agent

**Role**: UI components, state, interactions

**Requirements Before Starting**:
- UI specifications
- API contracts from BACKEND
- Component architecture

**Quality Gates**:
- [ ] Component tests pass
- [ ] Accessibility met
- [ ] Mobile responsive
- [ ] Performance targets hit

---

### 4. TESTING Agent

**Role**: Test generation and execution

**Deliverables**:
- Comprehensive test suite
- Coverage report
- Failed test analysis
- Fix suggestions

**Quality Gates**:
- [ ] >80% coverage
- [ ] Critical paths tested
- [ ] Edge cases covered
- [ ] Performance tests included

---

## Handoff Protocol

### Template

```markdown
## Handoff to [NEXT AGENT]

### Goal
[What needs to be accomplished]

### Context
[Current state, completed work]

### Deliverables
- [Files created/modified]
- [Key decisions made]

### Open Issues
- [Unresolved problems]

### Next Steps
[Expected actions]

### Success Criteria
[How to verify completion]
```

### Example Handoff

```markdown
## Handoff to BACKEND Agent

### Goal
Implement user authentication API

### Context
PLANNER has defined the authentication flow.
Database schema for users table is ready.

### Deliverables
- API contract: /api/auth/*.ts
- Database migrations: migrations/001_users.sql

### Open Issues
- Should we use JWT or sessions?

### Next Steps
1. Implement POST /api/auth/register
2. Implement POST /api/auth/login
3. Add JWT generation
4. Write integration tests

### Success Criteria
- [ ] All auth endpoints working
- [ ] Tests passing
- [ ] Password hashing secure
- [ ] Token expiration configured
```

## Multi-Agent Workflows

### Workflow 1: Sequential Development

```
PLANNER → BACKEND → FRONTEND → TESTING → Review
```

Use when: Features have clear dependencies

### Workflow 2: Parallel Development

```
        ┌→ BACKEND (API) ──┐
PLANNER ┤                  ├→ INTEGRATION → TESTING
        └→ FRONTEND (UI) ──┘
```

Use when: Backend and frontend can work independently

### Workflow 3: Competitive Evaluation

```
        ┌→ Agent 1 (GPT-5) ──┐
PLANNER ┤─→ Agent 2 (Composer)├→ Compare → Select Best
        └→ Agent 3 (Sonnet) ──┘
```

Use when: Critical code that needs highest quality
