# /code-review - Automated Code Review

## Overview

Esegue code review automatica analizzando qualità, sicurezza, e best practices. Genera report con severity levels.

## Syntax

```bash
/code-review                  # Review file modificati (git diff)
/code-review [file/dir]       # Review file/directory specifica
/code-review --staged         # Review solo staged files
/code-review --pr [number]    # Review PR specifica
/code-review --fix            # Applica auto-fix dove possibile
```

## Severity Levels

| Level | Meaning | Action Required |
|-------|---------|-----------------|
| **CRITICAL** | Security, data loss | Must fix before merge |
| **HIGH** | Bugs, performance | Should fix |
| **MEDIUM** | Code quality | Consider fixing |
| **LOW** | Style, suggestions | Nice to have |

## Review Categories

### 1. Security

```
[CRITICAL] Hardcoded credentials
  File: src/config.ts:15
  Issue: API key exposed in code
  Fix: Move to environment variable

[CRITICAL] SQL Injection
  File: src/db/queries.ts:42
  Issue: String concatenation in query
  Fix: Use parameterized queries

[HIGH] Missing input validation
  File: src/api/users.ts:28
  Issue: User input not validated
  Fix: Add Zod/Joi validation
```

### 2. Quality

```
[HIGH] Function too long
  File: src/services/order.ts:45
  Issue: Function has 85 lines (max 50)
  Fix: Extract into smaller functions

[MEDIUM] Missing error handling
  File: src/api/products.ts:67
  Issue: Promise without catch
  Fix: Add try/catch or .catch()

[LOW] Inconsistent naming
  File: src/utils/helpers.ts:12
  Issue: camelCase vs snake_case mixed
  Fix: Use consistent camelCase
```

### 3. Performance

```
[HIGH] N+1 Query
  File: src/services/users.ts:34
  Issue: Query inside loop
  Fix: Use batch query or include

[MEDIUM] Unnecessary re-render
  File: src/components/List.tsx:45
  Issue: Missing useMemo for expensive calc
  Fix: Wrap in useMemo
```

### 4. Testing

```
[MEDIUM] Untested code
  File: src/services/payment.ts
  Issue: No test file found
  Fix: Add unit tests

[LOW] Test coverage below threshold
  File: src/utils/validators.ts
  Issue: Coverage 65% (target 80%)
  Fix: Add edge case tests
```

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                     CODE REVIEW REPORT                        ║
╠══════════════════════════════════════════════════════════════╣
║ Files reviewed: 12                                            ║
║ Issues found: 8                                               ║
╠══════════════════════════════════════════════════════════════╣
║ CRITICAL: 1                                                   ║
║ HIGH: 3                                                       ║
║ MEDIUM: 2                                                     ║
║ LOW: 2                                                        ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ [CRITICAL] src/config.ts:15                                   ║
║   Hardcoded API key                                           ║
║   → Move to .env: API_KEY=...                                 ║
║                                                               ║
║ [HIGH] src/services/order.ts:45                               ║
║   Function processOrder() is 85 lines (max 50)                ║
║   → Extract validation, calculation, persistence              ║
║                                                               ║
║ ... (more issues)                                             ║
╠══════════════════════════════════════════════════════════════╣
║ Recommendation: Fix CRITICAL and HIGH before merge            ║
╚══════════════════════════════════════════════════════════════╝
```

## Auto-fix

Con `--fix`, applica correzioni automatiche per:

- Formatting issues (prettier)
- Simple lint errors (eslint --fix)
- Import ordering
- Unused imports removal
- Trailing whitespace

```bash
/code-review --fix
```

Output:
```
Auto-fixed:
  ✅ src/utils/helpers.ts - Removed unused imports
  ✅ src/components/Button.tsx - Fixed formatting
  ⚠️  src/services/order.ts - Manual fix required (function too long)
```

## Checklist per Review

### Security
- [ ] No hardcoded secrets
- [ ] Input validation presente
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Auth checks on protected routes

### Quality
- [ ] Functions < 50 lines
- [ ] Files < 300 lines
- [ ] Single responsibility
- [ ] Proper error handling
- [ ] No code duplication (DRY)

### Performance
- [ ] No N+1 queries
- [ ] Proper caching
- [ ] Lazy loading where needed
- [ ] No memory leaks

### Testing
- [ ] Unit tests for business logic
- [ ] Integration tests for API
- [ ] E2E for critical paths
- [ ] Coverage >= 80%

## Integration

Combina con:
- `/verify` - Run dopo code-review
- `/build-fix` - Fix automatici
- `/tdd` - Scrivi test per code non testato
