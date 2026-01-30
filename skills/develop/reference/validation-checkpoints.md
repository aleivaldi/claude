# Validation Checkpoints - Develop Skill

Documentazione completa dei 4 checkpoint di validazione nel workflow `/develop`.

## Overview

| Checkpoint | Fase | Tipo | Quando | Scopo |
|------------|------|------|--------|-------|
| Specs Completeness | 3.5 | BLOCKING | Dopo Block Decomposition Approval | Specs complete prima impl |
| Implementation Completeness | 4e.5 | BLOCKING | Dopo test pass, prima blocco completo | Zero stub/mock, piena aderenza spec |
| Frontend Layout Check | 4f.2 | REVIEW | Ogni N schermate implementate | Layout progressivo vs mockup |
| E2E Framework Validation | 4.5 | BLOCKING | Prima di E2E suite | Framework funziona |

---

## 1. Specs Completeness Validation (Fase 3.5)

### Obiettivo
Verificare che specs siano **complete** prima di implementare. Previene implementazioni incomplete per mancanza di dettagli nelle specs.

### Quando Eseguire
- **Trigger**: Dopo Block Decomposition Approval (Fase 3c)
- **Scope**: Tutti i blocchi approvati per implementazione
- **Timing**: Prima di Fase 4 (Execute Blocks)

### Cosa Verifica

#### API Specs Completeness
- ✅ Request/Response schemas definiti completamente (no TBD, no optional senza default)
- ✅ HTTP methods specificati
- ✅ Error responses documentati (400, 401, 403, 404, 500)
- ✅ Validation rules esplicite (regex, min/max, required fields)
- ✅ Authentication requirements specificati
- ❌ Schemas incompleti o vaghi
- ❌ Error cases non documentati
- ❌ Validation rules mancanti

#### Data Model Completeness
- ✅ Entity fields e types completi (no missing fields)
- ✅ Relations tra entità definite (1:1, 1:N, N:M)
- ✅ Constraints documentati (unique, not null, foreign keys)
- ✅ Indexes suggeriti per query performance
- ❌ Fields mancanti
- ❌ Relations non specificate
- ❌ Constraints vaghi

#### Frontend Specs Completeness
- ✅ Data sources specificati per ogni screen (quali API chiamare)
- ✅ User actions documentate (buttons, forms, navigation)
- ✅ Input validation rules (frontend-side)
- ✅ Error handling UI (come mostrare errori API)
- ✅ Loading states definiti
- ❌ Data sources mancanti
- ❌ User actions non documentate
- ❌ Error handling non specificato

### Implementation

```bash
# Cross-reference specs vs blocchi
specs_files=(
  "docs/api-specs/api-signature.md"
  "docs/architecture/data-model.md"
  "docs/frontend-specs/sitemap.md"
  "docs/architecture/frontend-architecture.md"
  "docs/architecture/backend-architecture.md"
)

# Per ogni blocco approvato
for block in approved_blocks; do
  # Check API specs
  check_api_schemas_complete "$block"
  check_error_responses_defined "$block"
  check_validation_rules "$block"

  # Check data model
  check_entity_fields_complete "$block"
  check_relations_defined "$block"

  # Check frontend specs
  check_data_sources_specified "$block"
  check_user_actions_documented "$block"
  check_error_handling_ui "$block"
done
```

### Output Format

```
SPECS COMPLETENESS GAPS FOUND

API Signature gaps (docs/api-specs/api-signature.md):
- POST /api/users (line 123)
  Missing: response schema (solo status code definito)
  Impact: Implementer non sa quali campi restituire

- PUT /api/entities/:id (line 456)
  Missing: validation rules (quali campi required?)
  Impact: Validation non implementabile

Data Model gaps (docs/architecture/data-model.md):
- Entity "Order" (line 89)
  Missing: field "createdBy" (chi ha creato?)
  Impact: Audit trail incompleto

- Relation User->Orders (line 112)
  Missing: cardinality (1:N o N:M?)
  Impact: Schema DB non implementabile

Frontend Specs gaps (docs/frontend-specs/sitemap.md):
- Screen "Dashboard" (line 234)
  Missing: data source (quale API chiamare?)
  Impact: Implementer non sa da dove prendere dati

Action required:
1. Update specs con dettagli mancanti
2. Re-run /develop (ripartirà da questa fase)

Oppure:
- [F] Fix specs ora (RECOMMENDED) → STOP, user aggiorna
- [I] Ignora gaps (NOT RECOMMENDED) → Continua con warning
- [C] Claude colma gaps con ipotesi → Draft specs, approva
```

### Configuration

```yaml
# project-config.yaml
develop:
  validations:
    specs_completeness:
      enabled: true           # Default: true
      blocking: true          # Default: true (STOP se gaps)
      check_api_schemas: true
      check_data_entities: true
      check_screen_data_sources: true
      check_validation_rules: true
      check_error_handling: true
      allow_ignore: true      # Permetti ignorare gaps (con warning)
      allow_auto_fill: true   # Permetti Claude colmare gaps
```

### Gestione Gaps

1. **Zero gaps**: Procedi automaticamente a Fase 4
2. **Gaps trovati**: AskUserQuestion con 3 opzioni
3. **User sceglie [F]**: STOP completo, user aggiorna specs
4. **User sceglie [I]**: Log warning, procedi (implementazione sarà incompleta)
5. **User sceglie [C]**: Claude genera draft specs, presenta per approvazione

---

## 2. Implementation Completeness Check (Fase 4e.5) ⭐ PRIORITÀ MASSIMA

### Obiettivo
Verificare che implementazione sia **COMPLETA** - zero stub/mock/placeholder, piena aderenza alle specs.

**Questo è il checkpoint PIÙ IMPORTANTE** - previene implementazioni incomplete che arrivano a "milestone complete" con funzionalità non implementate.

### Quando Eseguire
- **Trigger**: Dopo test pass (Fase 4e), prima di Blocco Completo (4f)
- **Scope**: Ogni singolo blocco
- **Timing**: ~1-2 min per blocco (scan + check automatici)

### Cosa Verifica

#### Pattern Anti-completeness (Grep Multi-pattern)

```bash
# Pattern 1: Commenti da risolvere
grep -rn "TODO|FIXME|HACK|XXX" [block-files]

# Pattern 2: Dati fittizi
grep -rni "mock|stub|placeholder|dummy|fake" [block-files]

# Pattern 3: Implementazione vuota
grep -rn "return \{\}|return \[\]|return null|return undefined" [block-files]

# Pattern 4: Dati hardcoded
grep -rni "hardcoded|hardcode" [block-files]

# Pattern 5: Debug statements
grep -rn "console\.log|console\.warn|print\(|dump\(" [block-files]
```

**Eccezioni legittime** (non considerare issue):
- `return null` in getter per optional values
- `return {}` in reducer default case
- `console.error` in error handlers (se wrappa logger)
- `// TODO` in commenti di documentazione (non codice)

#### Aderenza Spec (Cross-reference)

**API Implementation vs API Signature**:
- ✅ TUTTI i campi response implementati
- ✅ TUTTE le validation rules applicate
- ✅ TUTTI gli error cases gestiti
- ❌ Campi response mancanti
- ❌ Validation rules ignorate
- ❌ Error cases non gestiti

**Frontend Implementation vs Sitemap**:
- ✅ TUTTI i dati previsti mostrati
- ✅ TUTTE le user actions implementate
- ✅ TUTTI i navigation flows seguiti
- ❌ Dati previsti non mostrati
- ❌ Azioni utente mancanti
- ❌ Navigation non implementata

**Data Access vs Data Model**:
- ✅ Query usano indexes suggeriti
- ✅ Relations implementate correttamente
- ✅ Constraints rispettati
- ❌ Missing fields in entity
- ❌ Relations ignorate

### Implementation

```bash
# Step 1: Pattern scan
issues_found=0

echo "Scanning for anti-completeness patterns..."
grep -rn "TODO|FIXME|HACK|XXX" src/ && issues_found=$((issues_found+1))
grep -rni "mock|stub|placeholder|dummy|fake" src/ && issues_found=$((issues_found+1))
grep -rn "return {}|return \[\]|return null" src/ && issues_found=$((issues_found+1))
grep -rni "hardcoded|hardcode" src/ && issues_found=$((issues_found+1))
grep -rn "console\.log|console\.warn|print\(" src/ && issues_found=$((issues_found+1))

# Step 2: Spec adherence check
echo "Checking spec adherence..."
check_api_response_fields_complete
check_validation_rules_applied
check_error_cases_handled
check_frontend_data_displayed
check_user_actions_implemented

# Step 3: Report
if [ $issues_found -gt 0 ]; then
  generate_completeness_report
  invoke_fixer_for_auto_fix
fi
```

### Output Format

```
═══════════════════════════════════════════════════════════════
BLOCK IMPLEMENTATION INCOMPLETE: [block-name]
═══════════════════════════════════════════════════════════════

Stub/Mock/Placeholder Found (Pattern Scan):
- src/api/users.ts:42
  Code: return mockUsers // TODO: implement real API call
  Issue: Mock data instead of real DB query

- src/components/List.tsx:18
  Code: const data = [] // placeholder
  Issue: Empty placeholder instead of API call

- src/services/service.ts:67
  Code: console.log('Entity created:', entity)
  Issue: Debug statement not removed

Spec Deviation Found (Adherence Check):
- src/api/users.ts missing response field "lastLogin"
  Spec: api-signature.md line 123 requires "lastLogin: ISO8601"
  Impact: Frontend expects field, will break

- src/components/Form.tsx no email validation
  Spec: frontend-architecture.md requires regex /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  Impact: Invalid emails accepted

- src/api/entities.ts missing error handling for 404
  Spec: api-signature.md defines 404 response {error: "Entity not found"}
  Impact: Generic 500 returned instead

═══════════════════════════════════════════════════════════════
TOTAL ISSUES: 6 (3 stub/mock, 3 spec deviations)

Action: Fix issues automatically via fixer, re-test, re-check
═══════════════════════════════════════════════════════════════
```

### Auto-Fix Loop

1. **Se 0 issues**: Blocco COMPLETATO → Procedi a 4f
2. **Se issues trovati**:
   - Invoca fixer agent (riceve: report + specs + file paths)
   - Fixer sostituisce mock con real implementation
   - Fixer aggiunge campi mancanti
   - Fixer implementa validation rules
   - Fixer rimuove debug statements
   - Commit fix: `git commit -m "fix([scope]): complete implementation [block-name]"`
   - Re-run tests (unit + contract)
   - Re-check completeness (re-scan + re-check)
   - Loop max 2 volte
3. **Se issues dopo 2 fix**: STOP, AskUserQuestion [F]ix manuale / [C]ontinua con issues / [R]e-attempt

### Configuration

```yaml
# project-config.yaml
develop:
  validations:
    implementation_completeness:
      enabled: true               # MANDATORY
      blocking: true              # CANNOT skip
      scan_patterns:
        - "TODO|FIXME|HACK|XXX"
        - "mock|stub|placeholder|dummy|fake"
        - "return \\{\\}|return \\[\\]|return null|return undefined"
        - "hardcoded|hardcode"
        - "console\\.log|console\\.warn|print\\(|dump\\("
      check_spec_adherence: true
      max_fix_attempts: 2
      allow_continue_with_issues: false # Default: false
      exceptions:
        - "return null  # optional value"
        - "return {}    # reducer default"
        - "console.error # wrapped logger"
```

### Validation Completeness Checklist

```
✅ Zero stub/mock/placeholder in production code
✅ Zero TODO/FIXME in implementation (docs OK)
✅ Zero hardcoded data (config/constants OK)
✅ Zero debug statements (error logging OK)
✅ All response fields from spec implemented
✅ All validation rules from spec applied
✅ All error cases from spec handled
✅ All user actions from spec implemented
✅ All data sources from spec connected
```

**Solo se TUTTE le checklist ✅**: Blocco può procedere.

---

## 3. Frontend Layout Checkpoint (Fase 4f.2)

### Obiettivo
Verifica progressiva layout frontend vs mockup/design durante implementazione. Previene scoprire layout issues solo a milestone completo.

### Quando Eseguire
- **Trigger**: Ogni N schermate implementate (config: `frequency`, default 3)
- **Scope**: Solo blocchi frontend (skip se backend-only)
- **Timing**: Dopo build verification (4f.1), prima di squash merge (4f.3)

### Cosa Verifica

#### Screenshot Automatici
- Genera PNG per ogni screen implementata (Playwright)
- Full page screenshot (responsive)
- Network idle (dati caricati)

#### Checklist Manuale (User Review)
- Layout matches mockup/design system
- Responsive (mobile, tablet, desktop)
- Accessibility (keyboard nav, ARIA labels)
- Branding (colors, fonts, logo)
- Loading states visible
- Error states visible

### Implementation

```bash
# Step 1: Generate screenshots
npx playwright test --grep="@screenshot" --project=chromium

# Step 2: Present visual checkpoint
present_visual_checkpoint_to_user

# Step 3: User response
case "$user_action" in
  P|proceed)
    continue_to_squash_merge
    ;;
  R|review)
    stop_for_inspection
    save_block_state
    ;;
esac
```

### Output Format

```
═══════════════════════════════════════════════════════════════
>>> FRONTEND LAYOUT CHECKPOINT: Milestone [N] - Block [X/Y] <<<
═══════════════════════════════════════════════════════════════

Schermate implementate (ultime N):
1. [Screen Name A] (/path)
   Screenshot: screenshots/screen-a.png
   Data: [Live API | Mock | Static]
   Status: Build OK, tests passing

2. [Screen Name B] (/path)
   Screenshot: screenshots/screen-b.png
   Data: [Live API | Mock | Static]
   Status: Build OK, tests passing

Checklist Review (manual):
- [ ] Layout matches mockup/design system
- [ ] Responsive (mobile, tablet, desktop)
- [ ] Accessibility (keyboard nav, ARIA labels)
- [ ] Branding (colors, fonts, logo)
- [ ] Loading states visible
- [ ] Error states visible

═══════════════════════════════════════════════════════════════
Action: [P]rocedi / [R]eview (STOP per ispezione)
═══════════════════════════════════════════════════════════════
```

### Configuration

```yaml
# project-config.yaml
develop:
  validations:
    frontend_layout_check:
      enabled: true
      blocking: false            # REVIEW (non-blocking)
      frequency: 3               # Ogni 3 schermate
      screenshot_tool: "playwright"
      screenshot_format: "png"
      full_page: true
      checks:
        - responsive
        - accessibility
        - branding
        - loading_states
        - error_states
      on_review_stop:
        save_state: true
        notify_user: true
```

### Screenshot Test Template

```typescript
// e2e/screenshots.spec.ts
import { test } from '@playwright/test';

test.describe('Screenshots @screenshot', () => {
  test('Screen A', async ({ page }) => {
    await page.goto('/screen-a');
    await page.waitForLoadState('networkidle');
    await page.screenshot({
      path: 'screenshots/screen-a.png',
      fullPage: true
    });
  });
});
```

---

## 4. E2E Framework Validation (Fase 4.5 Pre-flight)

### Obiettivo
Verificare che Playwright/E2E framework funzioni PRIMA di eseguire full suite. Previene investire tempo su suite completa se framework broken.

### Quando Eseguire
- **Trigger**: Prima di E2E suite (Fase 4.5)
- **Scope**: Sample test (2 test veloci)
- **Timing**: ~5-10s

### Cosa Verifica

#### Sample Tests
1. **Navigation works**: App risponde, title presente
2. **Basic interaction works**: Click button/link, action eseguita

#### Framework Setup
- Browsers installati
- Config corretto (baseURL)
- App running
- Test runner funzionante

### Implementation

```bash
# Step 1: Check sample test exists
if [ ! -f e2e/sample.spec.ts ]; then
  generate_sample_test
fi

# Step 2: Run sample test
npx playwright test --grep="@framework-check" --timeout=30000

# Step 3: Analyze result
if [ $? -eq 0 ]; then
  echo "✅ E2E Framework Validation: PASSED"
  proceed_to_full_suite
else
  echo "❌ E2E Framework Validation: FAILED"
  present_troubleshooting_steps
  stop_execution
fi
```

### Sample Test Template (Playwright)

```typescript
// e2e/sample.spec.ts
import { test, expect } from '@playwright/test';

test.describe('E2E Framework Check @framework-check', () => {
  test('navigation works', async ({ page }) => {
    await page.goto('/');
    expect(page.url()).toContain('/');
    const title = await page.title();
    expect(title).toBeTruthy();
  });

  test('basic interaction works', async ({ page }) => {
    await page.goto('/');
    const button = page.locator('button, a').first();
    if (await button.count() > 0) {
      await button.click();
      await page.waitForTimeout(500);
    }
    expect(true).toBe(true); // Framework can execute
  });
});
```

### Sample Test Template (Patrol/Flutter)

```dart
// integration_test/sample_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('E2E Framework Check', ($) async {
    await $.pumpWidgetAndSettle(MyApp());

    // Navigation works
    expect(find.byType(MaterialApp), findsOneWidget);

    // Basic interaction works
    final firstButton = find.byType(ElevatedButton).first;
    if (firstButton.evaluate().isNotEmpty) {
      await $.tap(firstButton);
    }

    expect(true, true);
  });
}
```

### Output Format

**PASS**:
```
✅ E2E Framework Validation: PASSED

Sample tests:
- navigation works: ✅ PASS (234ms)
- basic interaction works: ✅ PASS (187ms)

E2E framework OK. Proceeding with full suite.
```

**FAIL**:
```
❌ E2E Framework Validation: FAILED

Sample test failures:
- navigation works: FAIL - Error: page.goto: net::ERR_CONNECTION_REFUSED

Possible causes:
1. App not running (start: npm run dev)
2. Wrong baseURL in playwright.config.ts
3. Missing browsers (run: npx playwright install)
4. Port conflict

Troubleshooting:
1. Verify app: curl http://localhost:[PORT]
2. Check playwright.config.ts baseURL
3. Install browsers: npx playwright install chromium

Action required: Fix framework, re-run /develop
```

### Configuration

```yaml
# project-config.yaml
develop:
  validations:
    e2e_framework_validation:
      enabled: true
      blocking: true
      sample_test_path: "e2e/sample.spec.ts"
      auto_generate_sample: true
      sample_test_timeout: 30000
      framework: "playwright"  # playwright | patrol | cypress
```

---

## Summary Comparison

| Validation | Fase | Tipo | Effort | Impact | Priorità |
|------------|------|------|--------|--------|----------|
| Specs Completeness | 3.5 | BLOCKING | ~2-3 min | Alto | Media |
| Implementation Completeness | 4e.5 | BLOCKING | ~1-2 min/block | **ALTISSIMO** | **MASSIMA** ⭐ |
| Frontend Layout | 4f.2 | REVIEW | ~30s | Medio | Bassa |
| E2E Framework | 4.5 | BLOCKING | ~5-10s | Alto | Alta |

**Implementation Completeness è il checkpoint più importante** - previene il 90% dei problemi di deliverable incomplete.

---

## Best Practices

### Specs Completeness
- Esegui PRIMA di implementare (non dopo)
- Permetti a Claude colmare gaps con ipotesi (opzione [C])
- Log gaps anche se user ignora (per post-mortem)

### Implementation Completeness
- NON skippare mai (MANDATORY)
- Usa auto-fix aggressivo (max 2 tentativi)
- Re-check DOPO ogni fix (pattern possono tornare)
- Exceptions pattern specifiche per progetto

### Frontend Layout
- Frequency = 3 schermate (default ragionevole)
- Screenshot full-page per responsive check
- Non-blocking (user può skipare se fiducia alta)

### E2E Framework
- Genera sample test automaticamente se mancante
- Timeout basso (30s max - deve essere veloce)
- Troubleshooting steps chiari (fix comuni)
- Blocca se fail (non ha senso eseguire suite se framework broken)

---

## Configuration Template

```yaml
# project-config.yaml - Sezione completa validations
develop:
  validations:
    # Specs Completeness (Fase 3.5)
    specs_completeness:
      enabled: true
      blocking: true
      check_api_schemas: true
      check_data_entities: true
      check_screen_data_sources: true
      check_validation_rules: true
      check_error_handling: true
      allow_ignore: true
      allow_auto_fill: true

    # Implementation Completeness (Fase 4e.5) - PRIORITÀ MASSIMA
    implementation_completeness:
      enabled: true
      blocking: true
      scan_patterns:
        - "TODO|FIXME|HACK|XXX"
        - "mock|stub|placeholder|dummy|fake"
        - "return \\{\\}|return \\[\\]|return null|return undefined"
        - "hardcoded|hardcode"
        - "console\\.log|console\\.warn|print\\(|dump\\("
      check_spec_adherence: true
      max_fix_attempts: 2
      allow_continue_with_issues: false
      exceptions:
        - "return null  # optional value"
        - "return {}    # reducer default"

    # Frontend Layout Check (Fase 4f.2)
    frontend_layout_check:
      enabled: true
      blocking: false
      frequency: 3
      screenshot_tool: "playwright"
      screenshot_format: "png"
      full_page: true
      checks:
        - responsive
        - accessibility
        - branding
        - loading_states
        - error_states

    # E2E Framework Validation (Fase 4.5)
    e2e_framework_validation:
      enabled: true
      blocking: true
      sample_test_path: "e2e/sample.spec.ts"
      auto_generate_sample: true
      sample_test_timeout: 30000
      framework: "playwright"
```

---

## Error Handling

### Specs Completeness Gaps
- **Zero gaps**: Procedi automaticamente
- **Gaps trovati**: AskUserQuestion [F]ix / [I]gnora / [C]laude colma
- **User ignora**: Log warning, procedi (deliverable sarà incompleto)

### Implementation Issues
- **Zero issues**: Procedi automaticamente
- **Issues trovati**: Auto-fix (max 2 cicli)
- **Still issues dopo fix**: AskUserQuestion [F]ix manuale / [C]ontinua (sconsigliato) / [R]e-attempt

### Frontend Layout Concerns
- **User [P]rocedi**: Continua automaticamente
- **User [R]eview**: STOP, save state, user ispeziona, riprendi

### E2E Framework Failure
- **Sample PASS**: Procedi automaticamente
- **Sample FAIL**: STOP, present troubleshooting, user fix, re-run

---

## Metrics & Logging

Log outcome in progress.yaml:

```yaml
milestones:
  - id: M1
    validations:
      specs_completeness:
        gaps_found: 0
        action: "proceed"

      implementation_completeness:
        blocks_checked: 4
        issues_found: 6
        auto_fixed: 6
        fix_attempts: 1

      frontend_layout_checks:
        checkpoints: 2
        screens_reviewed: 6
        user_stops: 0

      e2e_framework:
        sample_tests_passed: 2
        validation_time: "8s"
```

---

## Benefits Summary

### Specs Completeness
- ✅ Previene implementazioni incomplete (specs incomplete)
- ✅ Early detection (PRIMA di implementare)
- ✅ Auto-fill con ipotesi (riduce intervento umano)

### Implementation Completeness ⭐
- ✅ **Elimina stub/mock/placeholder** (problema principale)
- ✅ **Garantisce aderenza specs** (codice fa esattamente cosa specs dicono)
- ✅ **Auto-fix 90% casi** (zero intervento umano)
- ✅ **Deliverable vero complete** (non "sembra complete")

### Frontend Layout
- ✅ Early visual feedback (ogni N schermate)
- ✅ Automatic screenshots (zero effort)
- ✅ Progressive validation (non solo fine milestone)

### E2E Framework
- ✅ Verifica framework OK (PRIMA di full suite)
- ✅ Fast feedback (~5-10s vs 1-2 min)
- ✅ Clear troubleshooting (fix steps comuni)

**Tutti i validation checkpoints sono OPT-IN via config** - backward compatibility garantita.
