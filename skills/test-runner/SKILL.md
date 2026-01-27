---
name: test-runner
description: Esegue test suite, genera report, identifica test falliti, e può invocare test-writer per test mancanti.
---

# Test Runner Skill

## Obiettivo

Eseguire la suite di test del progetto, generare report, e identificare aree non coperte.

## Invocazione

```
/test-runner [scope] [options]

Esempi:
/test-runner                    # Tutti i test
/test-runner unit               # Solo unit test
/test-runner integration        # Solo integration
/test-runner e2e                # Solo E2E
/test-runner auth               # Test per modulo auth
/test-runner --coverage         # Con coverage report
/test-runner --watch            # Watch mode
```

## Workflow

```
┌────────────────────────────────────────────────────────────┐
│                   /test-runner [scope]                      │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 1. DETECT TEST FRAMEWORK                                   │
│    - package.json → jest/vitest/mocha                      │
│    - pubspec.yaml → flutter_test                           │
│    - Identify test directories                             │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 2. RUN TESTS                                               │
│    - Execute test command                                  │
│    - Capture output                                        │
│    - Track timing                                          │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 3. PARSE RESULTS                                           │
│    - Count passed/failed/skipped                           │
│    - Extract failure details                               │
│    - Parse coverage if available                           │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 4. GENERATE REPORT                                         │
│    - Summary table                                         │
│    - Failed test details                                   │
│    - Coverage summary                                      │
│    - Recommendations                                       │
└────────────────────────────────────────────────────────────┘
```

## Fasi

### Fase 1: Detect Framework

```javascript
// Auto-detect test framework
if (exists('package.json')) {
  const pkg = read('package.json');
  if (pkg.devDependencies.vitest) return 'vitest';
  if (pkg.devDependencies.jest) return 'jest';
  if (pkg.devDependencies.mocha) return 'mocha';
}
if (exists('pubspec.yaml')) {
  return 'flutter_test';
}
```

### Fase 2: Run Tests

**Node.js (Vitest/Jest):**
```bash
# Unit tests
npm run test:unit -- --reporter=json --outputFile=test-results.json

# With coverage
npm run test -- --coverage --coverageReporters=json-summary

# Specific file/pattern
npm run test -- auth
```

**Flutter:**
```bash
# All tests
flutter test --machine > test-results.json

# With coverage
flutter test --coverage

# Specific test
flutter test test/unit/auth_test.dart
```

### Fase 3: Parse Results

```javascript
// Parse Vitest/Jest JSON output
const results = {
  total: output.numTotalTests,
  passed: output.numPassedTests,
  failed: output.numFailedTests,
  skipped: output.numPendingTests,
  duration: output.testResults.reduce((acc, r) => acc + r.duration, 0),
  failures: output.testResults
    .filter(r => r.status === 'failed')
    .map(r => ({
      name: r.name,
      file: r.file,
      message: r.failureMessages[0],
    })),
};
```

### Fase 4: Generate Report

## Output

### Console Output

```
═══════════════════════════════════════════════════════════════
                      TEST RESULTS
═══════════════════════════════════════════════════════════════

  ✓ 45 tests passed
  ✗ 2 tests failed
  ○ 1 test skipped

  Duration: 12.3s

═══════════════════════════════════════════════════════════════
                      FAILURES
═══════════════════════════════════════════════════════════════

❌ UserService > createUser > should hash password
   File: tests/unit/services/user.service.test.ts:34

   Expected: password to be hashed
   Received: plain text password

   expect(user.password).not.toBe(plainPassword)

---

❌ AuthRoutes > POST /login > should return 401 for invalid
   File: tests/integration/auth.test.ts:78

   Expected: 401
   Received: 500

   AssertionError: expected 500 to equal 401

═══════════════════════════════════════════════════════════════
                      COVERAGE
═══════════════════════════════════════════════════════════════

  Statements   : 82.5% (target: 80%) ✓
  Branches     : 75.3% (target: 80%) ✗
  Functions    : 88.2% (target: 80%) ✓
  Lines        : 83.1% (target: 80%) ✓

  Uncovered files:
  - src/services/external.service.ts (45%)
  - src/utils/crypto.ts (60%)

═══════════════════════════════════════════════════════════════
                    RECOMMENDATIONS
═══════════════════════════════════════════════════════════════

  1. Fix 2 failing tests before merge
  2. Add tests for external.service.ts to improve coverage
  3. Add branch coverage for conditional logic

═══════════════════════════════════════════════════════════════
```

### test-report.md

```markdown
# Test Report

**Date**: [date]
**Project**: [Project Name]
**Commit**: [hash]

## Summary

| Metric | Value | Status |
|--------|-------|--------|
| Total Tests | 48 | - |
| Passed | 45 | ✅ |
| Failed | 2 | ❌ |
| Skipped | 1 | ⏭️ |
| Duration | 12.3s | - |

## Coverage

| Type | Coverage | Target | Status |
|------|----------|--------|--------|
| Statements | 82.5% | 80% | ✅ |
| Branches | 75.3% | 80% | ❌ |
| Functions | 88.2% | 80% | ✅ |
| Lines | 83.1% | 80% | ✅ |

## Failed Tests

### 1. UserService > createUser > should hash password

**File**: `tests/unit/services/user.service.test.ts:34`
**Type**: Unit

```
Expected: password to be hashed
Received: plain text password
```

**Probable Cause**: Password hashing not called in createUser

### 2. AuthRoutes > POST /login > should return 401

**File**: `tests/integration/auth.test.ts:78`
**Type**: Integration

```
Expected: 401 Unauthorized
Received: 500 Internal Server Error
```

**Probable Cause**: Unhandled exception in auth route

## Uncovered Code

| File | Coverage | Recommendation |
|------|----------|----------------|
| external.service.ts | 45% | Add connection/error handling tests |
| crypto.ts | 60% | Add edge case tests |
```

## Integration con Workflow

Quando invocata da `/develop`:
1. Esegue dopo implementazione
2. Se test falliscono → Fixer tenta correzione
3. Se coverage sotto target → Segnala warning
4. Report incluso nel checkpoint

## Principi

- **Fast feedback**: Esecuzione veloce
- **Clear output**: Report leggibili
- **Actionable**: Suggerimenti concreti
- **CI-compatible**: Output machine-readable disponibile
