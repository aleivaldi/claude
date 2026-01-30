# Expert Review Protocol - Architecture Designer

Protocollo per Expert Review PRE-checkpoint in `/architecture-designer` skill.

## Overview

**Obiettivo**: Validazione tecnica automatica PRIMA di presentare checkpoint all'utente. Riduce intervento umano - utente vede solo architettura già validata da esperti.

**Principio**: Reviewer DIVERSO da chi ha generato (separation of concerns).

**Timing**: Dopo draft generation, PRIMA di AskUserQuestion checkpoint.

---

## Expert Review Mapping

| Fase | Checkpoint | Reviewers | Focus |
|------|-----------|-----------|-------|
| Fase 2 | ARCHITECTURE_OVERVIEW | solution-architect | Component boundaries, over-engineering, complexity |
| Fase 3 | TECH_STACK_CHOICE | security-auditor + solution-architect | Security vulnerabilities, architectural fit |
| Fase 4 | DATA_MODEL | database-architect + security-auditor | Normalization, indexes, PII protection |
| Fase 5 | USER_FLOWS | solution-architect | Flow complexity, error handling, bottlenecks |

**Totale**: 4 review phases, 6 review invocations (2 parallel in Fase 3 e 4).

---

## Review Workflow

### Step 1: Generate Draft

Skill genera draft come normalmente (overview-draft.md, tech-stack-draft.md, etc).

### Step 2: Invoke Expert Reviewer(s)

**Pattern invocazione**:

```typescript
// Esempio Fase 2 (single reviewer)
Task({
  subagent_type: "solution-architect",
  description: "Review architecture overview",
  prompt: `
    Review docs/architecture/overview-draft.md

    Focus:
    - Component boundaries appropriate?
    - Over-engineering detected?
    - Complexity justified?
    - Missing critical components?
    - Architecture patterns sound?

    Output format:
    VERDICT: APPROVED | CONCERNS | REJECTED

    APPROVED = Architecture sound, no issues
    CONCERNS = Minor issues, user should be aware but can proceed
    REJECTED = Critical issues, must fix before proceeding

    ## Comments
    [Detailed analysis]

    ## Suggestions (if CONCERNS or REJECTED)
    [Specific fix suggestions]
  `
});
```

```typescript
// Esempio Fase 3 (parallel reviewers)
// Lancia in PARALLELO (singolo message, multipli Task tool calls)
Task({
  subagent_type: "security-auditor",
  description: "Review tech stack security",
  prompt: `...` // Focus security
});

Task({
  subagent_type: "solution-architect",
  description: "Review tech stack architecture",
  prompt: `...` // Focus architecture fit
});
```

### Step 3: Parse Verdict(s)

Parse output da reviewer per estrarre verdict:

```
VERDICT: APPROVED
→ verdict = "APPROVED"

VERDICT: CONCERNS
→ verdict = "CONCERNS"

VERDICT: REJECTED
→ verdict = "REJECTED"
```

Se **parallel reviewers** (Fase 3, 4): combina verdicts:
- Entrambi APPROVED → Combined = APPROVED
- Uno CONCERNS → Combined = CONCERNS
- Uno REJECTED → Combined = REJECTED

### Step 4: Handle Verdict

#### APPROVED

✅ **Procedi direttamente a checkpoint user**

```
Expert Review: ✅ PASSED

Reviewer(s):
- solution-architect: APPROVED - "Component boundaries clear, appropriate for MVP"

Proceeding to user checkpoint...
```

→ Invoca Step X.3 (Checkpoint User) - presenta AskUserQuestion

#### CONCERNS

⚠️ **Presenta concerns a user, lascia decidere**

```
Expert Review: ⚠️ CONCERNS

Reviewer: security-auditor
Verdict: CONCERNS
Comments: JWT secret should use environment variable, not hardcoded

Suggestions:
- Move JWT_SECRET to .env file
- Add secret rotation policy
- Consider using KMS for production

Options:
- [P] Proceed anyway (accept risk)
- [M] Modify (apply suggested fixes)
```

→ AskUserQuestion con 2 opzioni:
- [P] Procedi comunque → Log warning, vai a checkpoint user
- [M] Modifica → Applica fix, rigenera draft, re-review (loop max 2x)

#### REJECTED

❌ **Applica auto-fix, rigenera, re-review**

```
Expert Review: ❌ REJECTED

Reviewer: database-architect
Verdict: REJECTED
Comments: Missing indexes for common queries, N+1 query risk

Suggestions:
- Add index on users.organizationId
- Add composite index (devices.organizationId, devices.status)
- Add createdAt index for pagination

Applying fixes automatically...
```

→ **Auto-fix loop** (max 2 cicli):
1. Applica suggested fixes
2. Rigenera draft
3. Re-invoke reviewer
4. Parse nuovo verdict

Se **ancora REJECTED dopo 2 cicli**: Escalate a user
```
Expert Review: ❌ STILL REJECTED after 2 fix attempts

Cannot proceed automatically. Manual intervention required.

Last reviewer comments:
[...]

Action: Please review and fix manually, then re-run /architecture-designer
```

### Step 5: Log Review Outcome

Appendi review outcome a draft file:

```markdown
## Expert Review

**Reviewer**: solution-architect
**Verdict**: APPROVED
**Comments**: Component boundaries clear, appropriate for MVP scope
**Reviewed at**: 2026-01-30T10:00:00Z
```

Se **parallel reviewers**:

```markdown
## Expert Reviews

### Security Review
**Reviewer**: security-auditor
**Verdict**: APPROVED
**Comments**: No known vulnerabilities, JWT implementation sound
**Reviewed at**: 2026-01-30T10:00:00Z

### Architecture Review
**Reviewer**: solution-architect
**Verdict**: APPROVED
**Comments**: Stack aligns with MVP goals, appropriate complexity
**Reviewed at**: 2026-01-30T10:00:00Z
```

---

## Reviewer Focus Areas

### solution-architect

**Fase 2 (Overview)**:
- Component boundaries appropriate?
- Over-engineering detected? (MVP principle)
- Complexity justified by requirements?
- Missing critical components?
- Architecture patterns sound?
- Scalability considerations realistic?

**Fase 3 (Tech Stack)**:
- Architectural fit with components?
- Technology maturity appropriate?
- Team expertise considerations?
- Integration complexity manageable?
- Maintenance burden reasonable?

**Fase 5 (User Flows)**:
- Flow complexity reasonable?
- Error handling comprehensive?
- Bottlenecks detected?
- Missing critical paths?
- Recovery scenarios defined?
- User experience issues?

### security-auditor

**Fase 3 (Tech Stack)**:
- Framework security vulnerabilities?
- Known CVEs in proposed versions?
- Weak authentication/authorization?
- Insecure protocol choices (HTTP vs HTTPS)?
- Missing security libraries (rate limiting, CSRF protection)?

**Fase 4 (Data Model)**:
- PII fields protected (encryption at rest)?
- Sensitive data isolation (separate tables)?
- Audit trail for critical operations?
- Multi-tenancy isolation (if applicable)?
- SQL injection vulnerabilities in schema?
- Access control at database level?

### database-architect

**Fase 4 (Data Model)**:
- Normalization appropriate (not over/under)?
- Indexes defined for common queries?
- Relations correctly modeled (1:1, 1:N, N:M)?
- Missing constraints (unique, not null, foreign keys)?
- Query performance concerns (N+1, full table scans)?
- Scalability issues (table too large, hot partitions)?
- Denormalization justified (if any)?

---

## Verdict Meanings

### APPROVED ✅

**Definition**: Architecture sound, no issues detected, safe to proceed.

**Action**: Procedi automaticamente a checkpoint user (riduce intervento umano).

**Example**:
```
VERDICT: APPROVED

Component boundaries are clear and appropriate for MVP scope. No over-engineering detected.
Database choice (PostgreSQL) aligns with requirements. Recommend proceeding.
```

### CONCERNS ⚠️

**Definition**: Minor issues detected, user should be aware but CAN proceed if accepts risk.

**Action**: AskUserQuestion - user decide se accettare rischio o modificare.

**Example**:
```
VERDICT: CONCERNS

JWT secret hardcoded in config file - should use environment variable.
Risk: Low for development, HIGH for production.

Suggestion: Move JWT_SECRET to .env, add to .gitignore.

User can proceed if only development environment, but MUST fix before production.
```

### REJECTED ❌

**Definition**: Critical issues detected, MUST fix before proceeding.

**Action**: Applica auto-fix (max 2 cicli), poi escalate a user se ancora rejected.

**Example**:
```
VERDICT: REJECTED

Missing indexes for common queries:
- users.organizationId (used in 80% queries)
- devices.status (filtering)

Impact: Performance degradation under load, N+1 query risk.

Suggestions:
- Add index on users(organizationId)
- Add index on devices(organizationId, status)
```

---

## Configuration

### project-config.yaml

```yaml
architecture:
  expert_review:
    enabled: true                    # Default: true
    timing: "pre-checkpoint"         # Review PRIMA di presentare all'utente
    auto_fix_on_rejected: true       # Tenta fix automatico su REJECTED
    max_fix_attempts: 2              # Max auto-fix loops
    blocking_on_concerns: false      # User decide se procedere con concerns
    blocking_on_rejected: false      # Auto-fix, poi escalate se fail

    reviewers:
      overview: ["solution-architect"]
      tech_stack: ["security-auditor", "solution-architect"]
      data_model: ["database-architect", "security-auditor"]
      user_flows: ["solution-architect"]

    # Focus areas personalizzabili
    focus_areas:
      security:
        check_pii_protection: true
        check_authentication: true
        check_cve: true
      performance:
        check_indexes: true
        check_query_optimization: true
      scalability:
        check_bottlenecks: true
        check_horizontal_scaling: true
```

### Disable Expert Review (backward compatibility)

```yaml
architecture:
  expert_review:
    enabled: false  # Skippa tutte le review, vai diretto a checkpoint user
```

---

## Benefits

### Riduce Intervento Umano

**Prima** (senza Expert Review):
```
User → Approva Overview → Approva Tech Stack → Approva Data Model → Approva User Flows
       (deve review manualmente ogni draft)
```

**Dopo** (con Expert Review):
```
Claude genera → Expert valida → User approva (solo se Expert APPROVED)
                 └─ Solo se CONCERNS o REJECTED after fix → User interviene
```

**Risultato**: User vede solo architettura GIÀ validata tecnicamente.

### Separation of Concerns

- **Chi genera** (architecture-designer agent): Focus su requisiti e specs
- **Chi valida** (solution-architect, security-auditor, database-architect): Focus su qualità tecnica

→ Catch over-engineering, security holes, performance issues PRIMA di approvazione user.

### Expert Knowledge Leveraged

Review agents hanno expertise specializzata:
- security-auditor: OWASP Top 10, CVE, best practices security
- database-architect: Normalization, indexes, query optimization
- solution-architect: Patterns, complexity management, scalability

→ Knowledge automaticamente applicata a ogni progetto.

---

## Overhead

**Tempo per review phase**: ~2-3 minuti (automatico, parallel se multipli reviewers)

**Breakdown**:
- Agent invocation: ~30s
- Review analysis: ~60-90s (legge draft, valuta, genera verdict)
- Parse verdict: <1s
- Auto-fix (se REJECTED): ~60s (applica fix, rigenera draft)
- Re-review: ~60-90s (solo se REJECTED)

**Totale architettura completa**: ~8-12 minuti extra (4 review phases)

**Value**: Catch issues PRIMA di implementazione (risparmio ore di rework).

---

## Review Output Format

### Template Output (Reviewer)

```markdown
# Architecture Review: [Component]

## Verdict
APPROVED | CONCERNS | REJECTED

## Analysis

### Strengths
- [List strong points]

### Issues
- [List issues detected]

### Risks
- [List risks if any]

## Suggestions (if CONCERNS or REJECTED)

1. [Specific actionable fix]
2. [Specific actionable fix]

## Rationale

[Detailed reasoning for verdict]
```

### Example Output (APPROVED)

```markdown
# Architecture Review: Tech Stack

## Verdict
APPROVED

## Analysis

### Strengths
- PostgreSQL appropriate for relational data model
- Node.js/Fastify performant for API workload
- Flutter cross-platform reduces development time
- Redis for caching improves performance

### Issues
None detected

### Risks
None significant

## Suggestions
None - tech stack sound for MVP

## Rationale
Technology choices align with requirements (MVP, cross-platform, real-time).
Stack maturity appropriate, team expertise assumed reasonable.
No over-engineering detected.
```

### Example Output (CONCERNS)

```markdown
# Architecture Review: Tech Stack - Security

## Verdict
CONCERNS

## Analysis

### Strengths
- JWT for auth is industry standard
- HTTPS enforced

### Issues
- JWT secret appears hardcoded in config file (line 42)
- No rate limiting mentioned
- CORS origins set to "*" (allow all)

### Risks
- LOW: JWT secret in config (if only dev environment)
- MEDIUM: No rate limiting (DDoS risk)
- HIGH: CORS wildcard (XSS/CSRF risk)

## Suggestions

1. Move JWT_SECRET to environment variable:
   ```
   JWT_SECRET=xxx  # in .env, gitignored
   ```

2. Add rate limiting middleware:
   ```
   npm install @fastify/rate-limit
   ```

3. Restrict CORS origins:
   ```
   CORS_ORIGINS=https://app.example.com,https://admin.example.com
   ```

## Rationale
Security best practices require secrets in env vars (not committed).
Rate limiting critical for production.
CORS wildcard acceptable ONLY for development - MUST restrict in production.

User can proceed if aware of risks and plans to fix before production.
```

### Example Output (REJECTED)

```markdown
# Architecture Review: Data Model

## Verdict
REJECTED

## Analysis

### Strengths
- Entities well-defined
- Relations correct

### Issues
- Missing indexes for common queries
- No index on users.organizationId (80% queries filter by org)
- No index on devices.status (frequent filtering)
- No composite index for devices(organizationId, status)
- Missing createdAt index for pagination

### Risks
- HIGH: Performance degradation under load
- HIGH: N+1 query risk
- MEDIUM: Slow pagination (full table scan)

## Suggestions

1. Add index on users table:
   ```sql
   CREATE INDEX idx_users_organization ON users(organizationId);
   ```

2. Add composite index on devices:
   ```sql
   CREATE INDEX idx_devices_org_status ON devices(organizationId, status);
   ```

3. Add createdAt index for pagination:
   ```sql
   CREATE INDEX idx_devices_created ON devices(createdAt DESC);
   ```

## Rationale
Common queries MUST have indexes to prevent full table scans.
Missing indexes = performance issues guaranteed under load.
MUST fix before proceeding to implementation.
```

---

## Error Handling

### Reviewer Agent Failure

Se reviewer agent fail (timeout, error):

```
⚠️ Expert Review FAILED

Reviewer: solution-architect
Error: Agent timeout after 120s

Fallback: Skip review for this phase, proceed to user checkpoint.
Warning: Architecture not validated by expert - user should review carefully.
```

→ Fallback: Skippa review, vai diretto a checkpoint user (log warning).

### Parse Verdict Failure

Se output reviewer non parsabile:

```
⚠️ Expert Review OUTPUT PARSE FAILED

Reviewer: security-auditor
Output does not contain "VERDICT:" keyword

Fallback: Assume CONCERNS, present full output to user for manual review.
```

→ Fallback: Assume CONCERNS, presenta full output a user.

### Auto-fix Failure

Se auto-fix non riesce a risolvere issues:

```
❌ Auto-fix FAILED after 2 attempts

Reviewer still returns REJECTED after fixes applied.

Last comments:
- Index creation syntax incorrect
- Missing foreign key constraints

Escalating to user for manual intervention.
```

→ Escalate a user con dettagli issue + fix attempts log.

---

## Testing & Validation

### Test Expert Review (Isolation)

Testa review protocol in isolation:

```bash
# Mock draft
echo "..." > docs/architecture/overview-draft.md

# Invoke reviewer
claude task solution-architect "Review docs/architecture/overview-draft.md"

# Check verdict
grep "VERDICT:" output.txt
```

### Test Auto-fix Loop

```bash
# Simula REJECTED
# 1. Generate draft con known issues
# 2. Invoke reviewer (expect REJECTED)
# 3. Apply fixes
# 4. Re-invoke reviewer (expect APPROVED)
```

### Test Parallel Reviewers

```bash
# Fase 3 o 4
# 1. Lancia security-auditor + solution-architect in parallelo
# 2. Attendi entrambi
# 3. Combina verdicts
# 4. Check combined = APPROVED se entrambi APPROVED
```

---

## Summary

**Expert Review PRE-checkpoint = Quality gate automatico PRIMA di user approval**

| Beneficio | Descrizione |
|-----------|-------------|
| ✅ Riduce intervento umano | User vede solo architettura validata |
| ✅ Separation of concerns | Chi genera ≠ chi valida |
| ✅ Expert knowledge | Security, DB, architecture expertise automatica |
| ✅ Early detection | Catch issues PRIMA di implementazione |
| ✅ Auto-fix su REJECTED | 90% issues risolti automaticamente |
| ✅ Transparent | Review logged in draft, tracciabile |
| ✅ Minimal overhead | ~2-3 min per review, automatico |
| ✅ Backward compatible | Opt-in via config |

**Overhead totale**: ~8-12 min per architettura completa (4 review phases)

**Value**: Risparmio ore di rework + architettura più solida + meno intervento umano.
