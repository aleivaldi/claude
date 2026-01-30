# Expert Review Policy

Policy per Expert Review PRE-checkpoint nel framework.

---

## Definizione

**Expert Review** = Validazione tecnica automatica PRIMA di presentare checkpoint all'utente.

**Principio**: Reviewer DIVERSO da chi ha generato (separation of concerns).

---

## Quando Applicare

### Architecture Designer

Expert Review si applica a **tutti i 4 checkpoint architettura**:

| Checkpoint | Reviewers | Focus |
|-----------|-----------|-------|
| ARCHITECTURE_OVERVIEW | solution-architect | Component boundaries, over-engineering, complexity |
| TECH_STACK_CHOICE | security-auditor + solution-architect | Security vulnerabilities, architectural fit |
| DATA_MODEL | database-architect + security-auditor | Normalization, indexes, PII protection |
| USER_FLOWS | solution-architect | Flow complexity, error handling, bottlenecks |

**Trigger**: Dopo draft generation, PRIMA di AskUserQuestion checkpoint.

---

## Review Verdicts

### APPROVED ✅

**Definition**: Architecture sound, no issues.

**Action**: Procedi automaticamente a checkpoint user (riduce intervento umano).

**Example**:
```
VERDICT: APPROVED

Component boundaries clear, no over-engineering detected.
Recommend proceeding to user approval.
```

### CONCERNS ⚠️

**Definition**: Minor issues, user should be aware but CAN proceed.

**Action**: AskUserQuestion - user decide se accettare rischio o modificare.

**Example**:
```
VERDICT: CONCERNS

JWT secret hardcoded - should use env var.
Risk LOW for dev, HIGH for prod.

User can proceed if aware, MUST fix before production.
```

### REJECTED ❌

**Definition**: Critical issues, MUST fix.

**Action**: Applica auto-fix (max 2 cicli), poi escalate a user se ancora rejected.

**Example**:
```
VERDICT: REJECTED

Missing indexes for common queries.
Performance degradation guaranteed under load.

Auto-fixing...
```

---

## Configuration

```yaml
# project-config.yaml
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
```

---

## Overhead

**Tempo per review phase**: ~2-3 minuti (automatico, parallel se multipli reviewers)

**Breakdown**:
- Agent invocation: ~30s
- Review analysis: ~60-90s
- Parse verdict: <1s
- Auto-fix (se REJECTED): ~60s
- Re-review: ~60-90s (solo se REJECTED)

**Totale architettura completa**: ~8-12 minuti extra (4 review phases)

**Value**: Catch issues PRIMA di implementazione (risparmio ore di rework).

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

- **Chi genera** (architecture-designer): Focus su requisiti e specs
- **Chi valida** (solution-architect, security-auditor, database-architect): Focus su qualità tecnica

→ Catch over-engineering, security holes, performance issues PRIMA di approvazione user.

### Expert Knowledge Leveraged

Review agents hanno expertise specializzata:
- security-auditor: OWASP Top 10, CVE, best practices security
- database-architect: Normalization, indexes, query optimization
- solution-architect: Patterns, complexity management, scalability

→ Knowledge automaticamente applicata a ogni progetto.

---

## Disable Expert Review

Per disabilitare (backward compatibility):

```yaml
architecture:
  expert_review:
    enabled: false  # Skippa tutte le review, vai diretto a checkpoint user
```

Progetti esistenti continuano a funzionare senza modifiche.

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
