---
name: code-review
description: Esegue code review su file o commit. Invoca code-reviewer agent, genera report, e può invocare fixer per auto-fix.
---

# Code Review Skill

## Obiettivo

Eseguire review del codice per qualità, sicurezza, e best practices. Può auto-fixare problemi con il Fixer agent.

## Invocazione

```
/code-review [scope] [options]

Esempi:
/code-review                    # Review staged changes
/code-review last-commit        # Review ultimo commit
/code-review src/routes/        # Review directory specifica
/code-review --fix              # Review + auto-fix
/code-review --security         # Focus su sicurezza
/code-review PR#123             # Review PR specifica
```

## Workflow

```
┌────────────────────────────────────────────────────────────┐
│                   /code-review [scope]                      │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 1. DETERMINE SCOPE                                         │
│    - Staged changes (default)                              │
│    - Last commit                                           │
│    - Specific files/directories                            │
│    - PR diff                                               │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 2. INVOKE CODE-REVIEWER AGENT                              │
│    - Read all files in scope                               │
│    - Analyze for issues                                    │
│    - Classify by severity                                  │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 3. GENERATE FINDINGS                                       │
│    - Critical: Security, data loss                         │
│    - High: Likely bugs, perf issues                        │
│    - Medium: Code smells, maintainability                  │
│    - Low: Style, minor improvements                        │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 4. AUTO-FIX (if --fix)                                     │
│    - Invoke Fixer agent                                    │
│    - Apply fixes                                           │
│    - Re-review                                             │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 5. OUTPUT REPORT                                           │
│    - Summary                                               │
│    - Detailed findings                                     │
│    - Recommendations                                       │
└────────────────────────────────────────────────────────────┘
```

## Fasi

### Fase 1: Determine Scope

```bash
# Staged changes
git diff --cached --name-only

# Last commit
git diff HEAD~1 --name-only

# PR diff
gh pr diff 123 --name-only
```

### Fase 2: Invoke Reviewer

Delega al Code Reviewer agent con contesto:

```
Task: code-reviewer
Prompt: |
  Review the following files for quality, security, and best practices.

  Files to review:
  - src/routes/auth.routes.ts
  - src/services/auth.service.ts

  Focus areas:
  - Security vulnerabilities (OWASP Top 10)
  - Performance issues
  - Error handling
  - Type safety
  - Code standards compliance

  Output findings with severity levels.
```

### Fase 3: Classify Findings

```yaml
findings:
  - id: REV-001
    severity: critical
    type: security
    file: src/routes/auth.routes.ts
    line: 45
    title: SQL Injection vulnerability
    description: User input directly concatenated in query
    suggestion: Use parameterized queries
    auto_fixable: true

  - id: REV-002
    severity: high
    type: error_handling
    file: src/services/auth.service.ts
    line: 23
    title: Unhandled promise rejection
    description: Async operation without try/catch
    suggestion: Add error handling
    auto_fixable: true

  - id: REV-003
    severity: medium
    type: performance
    file: src/routes/users.routes.ts
    line: 67
    title: N+1 query pattern
    description: Querying in loop instead of batch
    suggestion: Use include/join
    auto_fixable: true

  - id: REV-004
    severity: low
    type: style
    file: src/utils/helpers.ts
    line: 12
    title: Inconsistent naming
    description: getUserData vs fetchUserInfo
    suggestion: Standardize verb usage
    auto_fixable: false
```

### Fase 4: Auto-Fix

Se `--fix` e `auto_fixable: true`:

```
Task: fixer
Prompt: |
  Fix the following issues:

  1. REV-001: SQL Injection in auth.routes.ts:45
     Current: const query = `SELECT * FROM users WHERE id = '${userId}'`;
     Fix: Use Prisma ORM or parameterized query

  2. REV-002: Unhandled promise in auth.service.ts:23
     Current: const result = await externalApi.call();
     Fix: Wrap in try/catch with proper error handling
```

### Fase 5: Output

## Output

### Console (Interactive)

```
═══════════════════════════════════════════════════════════════
                      CODE REVIEW
═══════════════════════════════════════════════════════════════

  Scope: staged changes (5 files)

  Summary:
  ┌──────────┬───────┬────────────┐
  │ Severity │ Count │ Auto-fixed │
  ├──────────┼───────┼────────────┤
  │ Critical │   1   │     1      │
  │ High     │   2   │     2      │
  │ Medium   │   3   │     2      │
  │ Low      │   4   │     0      │
  └──────────┴───────┴────────────┘

═══════════════════════════════════════════════════════════════
                    CRITICAL ISSUES
═══════════════════════════════════════════════════════════════

❌ [REV-001] SQL Injection vulnerability
   src/routes/auth.routes.ts:45

   User input directly concatenated in query string.
   This allows attackers to execute arbitrary SQL.

   Current:
   │ const query = `SELECT * FROM users WHERE id = '${userId}'`;

   Fixed:
   │ const user = await prisma.user.findUnique({
   │   where: { id: userId }
   │ });

   ✅ AUTO-FIXED

═══════════════════════════════════════════════════════════════
                      HIGH ISSUES
═══════════════════════════════════════════════════════════════

⚠️ [REV-002] Unhandled promise rejection
   src/services/auth.service.ts:23

   ✅ AUTO-FIXED

⚠️ [REV-003] Missing input validation
   src/routes/register.routes.ts:12

   ✅ AUTO-FIXED

═══════════════════════════════════════════════════════════════
                    REMAINING ISSUES
═══════════════════════════════════════════════════════════════

  3 medium issues (review recommended)
  4 low issues (optional)

  Run `/code-review --details` for full list.

═══════════════════════════════════════════════════════════════
                      VERDICT
═══════════════════════════════════════════════════════════════

  ✅ All critical/high issues resolved

  Ready to commit? [Y/n]

═══════════════════════════════════════════════════════════════
```

### review-report.md

```markdown
# Code Review Report

**Date**: 2025-01-22 16:00
**Scope**: Staged changes
**Reviewer**: Code Reviewer Agent

## Summary

| Severity | Found | Fixed | Remaining |
|----------|-------|-------|-----------|
| Critical | 1 | 1 | 0 |
| High | 2 | 2 | 0 |
| Medium | 3 | 2 | 1 |
| Low | 4 | 0 | 4 |

**Verdict**: ✅ PASS (no blocking issues)

## Fixed Issues

### [CRITICAL] REV-001: SQL Injection
- **File**: src/routes/auth.routes.ts:45
- **Fix**: Replaced string concatenation with Prisma query

### [HIGH] REV-002: Unhandled promise
- **File**: src/services/auth.service.ts:23
- **Fix**: Added try/catch block

## Remaining Issues

### [MEDIUM] REV-005: Missing pagination
- **File**: src/routes/users.routes.ts:30
- **Impact**: Performance on large datasets
- **Recommendation**: Add limit/offset parameters

### [LOW] REV-006: Console.log in production code
- **File**: src/utils/debug.ts:5
- **Recommendation**: Use logger or remove

## Positive Notes

- Good separation of concerns in services
- Consistent error response format
- TypeScript strict mode enabled
```

## Principi

- **Constructive**: Migliora codice, non critica
- **Prioritized**: Critical/High prima
- **Actionable**: Sempre con suggerimento
- **Auto-fix**: Risolvi automaticamente dove possibile
- **Educational**: Spiega perché è un problema
