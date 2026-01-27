# Evaluation 3: Test Failure with Auto-Recovery

## Scenario
Implementazione completa ma tests falliscono. Fixer deve correggere automaticamente.

## Setup

### Input Files
- Architecture, API signature, sitemap: tutti presenti
- Milestone M1: "Add password validation"

### Invocazione
```
/develop milestone:M1
```

## Expected Behavior

### Fasi 1-3
- ✅ Load context, verify, plan normalmente

### Fase 4: Execute

#### 4.1 Implementation
- ✅ backend-implementer crea `src/services/auth.service.ts` con password validation
- ✅ Codice compila

#### 4.2 Tests
- ✅ test-writer crea tests:
  ```typescript
  it('should reject password < 8 chars')
  it('should reject password without uppercase')
  it('should accept valid password')
  ```

#### 4.3 Test Execution
- ❌ Tests FAIL:
  ```
  FAIL: should reject password < 8 chars
  Expected: ValidationError
  Received: undefined
  ```

#### 4.4 Auto-Recovery (Attempt 1)
- ✅ Analizza failure: validation non implementata correttamente
- ✅ Invoca Task(fixer):
  ```
  Prompt: |
    Test fallito: should reject password < 8 chars

    File: src/services/auth.service.ts:15
    Errore: Password validation not throwing error

    Fixa minimalmente. Tentativo 1/3.
  ```
- ✅ Fixer corregge: aggiunge throw ValidationError
- ✅ Re-run tests: ✅ PASS

#### 4.5 Review
- ✅ code-reviewer: nessun issue critico
- ✅ Procede a commit

### Fase 5-6
- ✅ Checkpoint, finalize normalmente

## Expected Output

### Chat Log (Simplified)
```
Implementazione completata.
Running tests...

❌ Tests falliti: 1/3
- should reject password < 8 chars: FAIL

Auto-recovery tentativo 1/3...
Fixing: src/services/auth.service.ts

Re-running tests...
✅ Tests passed: 3/3

Review codice...
✅ No issues found

Procedo con commit.
```

### Files Modified
- `src/services/auth.service.ts` (fix applicato)
- `tests/unit/auth.service.spec.ts` (test creato)

### Git Commit
```
feat(auth): add password validation

- Min 8 chars requirement
- Uppercase requirement
- Tests: 3/3 passed
- Auto-fixed validation error handling

Co-Authored-By: Claude Sonnet <noreply@anthropic.com>
```

## Success Criteria

- ✅ Test failure rilevato
- ✅ Fixer invocato automaticamente
- ✅ Fix applicato (tentativo 1)
- ✅ Tests re-run automaticamente
- ✅ Tests passed dopo fix
- ✅ Review eseguita dopo tests OK
- ✅ Commit creato con menzione auto-fix

## Edge Cases Gestiti

### Scenario 2: Max Retry Exceeded

**Setup**: Fixer fallisce 3 volte

**Expected**:
```
Attempt 1/3: FAIL (tests still failing)
Attempt 2/3: FAIL (tests still failing)
Attempt 3/3: FAIL (tests still failing)

⚠️ Max retry exceeded (3 attempts)

Issue: should reject password < 8 chars
File: src/services/auth.service.ts:15
Last error: [dettaglio]

Intervento manuale richiesto.
Stato salvato in progress.yaml:
  status: blocked
  blocker: test_failure_max_retry

Riavvia con: /develop resume
```

**Progress.yaml**:
```yaml
milestones:
  - id: M1
    status: blocked
    blocker:
      type: test_failure
      attempts: 3
      test: "should reject password < 8 chars"
      file: "src/services/auth.service.ts:15"
```

### Scenario 3: Flaky Test

**Setup**: Test passa 2/3 volte

**Expected**:
```
Test "should handle concurrent requests" flaky detected (passed 2/3 runs).

Aggiunto a watchlist ma procedo (non blocca deploy).

Raccomandazione: Investiga timing/race condition.
```

## Pass/Fail Criteria

**PASS se**:
- Auto-recovery invocato max 3x
- Re-run tests dopo ogni fix
- STOP se 3 attempt falliscono
- Stato salvato in progress.yaml se blocked
- Commit include menzione fix applicati

**FAIL se**:
- Loop infinito fix
- Tests non re-run dopo fix
- Procede con commit anche se tests fail
- Non salva stato se blocked
