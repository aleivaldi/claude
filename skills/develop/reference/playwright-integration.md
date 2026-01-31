# Playwright Integration for Frontend Testing

## Overview

Integra Playwright testing automatico nel workflow `/develop` per verificare il frontend appena completati i primi blocchi UI visibili. Esegue test end-to-end sul browser reale per validare flussi critici (login, navigation, form submission).

## When to Trigger

**Trigger automatico** quando:
1. Almeno 1 blocco frontend con UI visibile è completato (es: LoginScreen, Dashboard)
2. Backend è running e API funzionanti
3. Build frontend web completato con successo

**Skip** se:
- Solo blocchi backend completati (no UI)
- Blocco frontend è solo components/widgets senza screen navigabile
- Config `playwright.enabled: false`

## Workflow Integration

### Fase 4f.3: Playwright Quick Test (NUOVO - dopo squash merge)

Inserire **dopo** squash merge del blocco frontend, **prima** di sbloccare dipendenti.

```markdown
#### 4f.3 Playwright Quick Test (se blocco frontend con UI)

**Trigger**: Blocco frontend completato con screen navigabile (LoginScreen, DashboardScreen, etc.)

**Obiettivo**: Verificare che la UI funzioni sul browser reale prima di procedere con altri blocchi.

##### Step 1: Setup Playwright (se prima volta)

Verifica se Playwright è già configurato:

```bash
# Check se package.json esiste in root progetto o subproject
test -f package.json && grep -q "playwright" package.json
```

Se **non configurato**:

1. **Crea package.json** in root progetto (se mancante):
   ```json
   {
     "name": "e2e-tests",
     "version": "1.0.0",
     "type": "module",
     "devDependencies": {
       "playwright": "^1.48.0"
     }
   }
   ```

2. **Installa Playwright**:
   ```bash
   npm install
   npx playwright install chromium
   ```

3. **Crea directory tests**:
   ```bash
   mkdir -p e2e-tests
   ```

**Nota**: Questo setup è automatico, NON chiedere permesso all'utente.

##### Step 2: Genera Test per Blocco Completato

Analizza il blocco frontend appena completato e genera test Playwright specifico.

**Template test** (esempio LoginScreen):

```javascript
// e2e-tests/login.spec.js
import { test, expect } from '@playwright/test';

test.describe('Login Flow @quick', () => {
  test('should load login screen', async ({ page }) => {
    await page.goto('http://localhost:8080');

    // Aspetta Flutter app load
    await page.waitForTimeout(5000);

    // Verifica elementi chiave visibili
    await expect(page.locator('text=QRPay')).toBeVisible();
    await expect(page.locator('text=Email')).toBeVisible();
    await expect(page.locator('text=Password')).toBeVisible();
  });

  test('should fill and submit login form', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForTimeout(5000);

    // Click su coordinate campo email (Flutter web)
    await page.mouse.click(640, 307);
    await page.keyboard.type('demo@qrpay.io', { delay: 100 });

    // Click su coordinate campo password
    await page.mouse.click(640, 370);
    await page.keyboard.type('password123', { delay: 100 });

    // Submit
    await page.keyboard.press('Enter');

    // Aspetta navigation
    await page.waitForTimeout(3000);

    // Verifica redirect success
    expect(page.url()).toContain('/devices');
  });
});
```

**Genera test per ogni screen implementata**:
- LoginScreen → login.spec.js (form fill + submit)
- DashboardScreen → dashboard.spec.js (load data + display)
- DeviceListScreen → devices.spec.js (load list + click item)

**Coordinate click per Flutter web**:
- Usa coordinate fisse basate su layout (più affidabile di selettori CSS)
- Email field: ~y=307
- Password field: ~y=370
- Buttons: basati su posizione visiva da mockup

##### Step 3: Verifica Backend Running

Prima di eseguire test, verifica che backend sia UP:

```bash
# Check backend health
curl -f http://localhost:3000/api/v1/health 2>/dev/null || {
  echo "Backend not running. Start with: cd qrpay-backend && npm run dev"
  exit 1
}
```

Se backend DOWN: **STOP** e notifica user di startare backend.

##### Step 4: Build Frontend Web (se necessario)

```bash
cd [frontend-dir]

# Check se build esiste e è recente (< 5 min)
if [ ! -d "build/web" ] || [ $(find build/web -mmin +5 2>/dev/null | wc -l) -gt 0 ]; then
  flutter build web --release
fi

# Start HTTP server (background)
cd build/web
python3 -m http.server 8080 > /dev/null 2>&1 &
HTTP_SERVER_PID=$!

# Aspetta server ready
sleep 2
```

##### Step 5: Run Playwright Quick Tests

Esegui solo test quick (non full suite):

```bash
npx playwright test --grep="@quick" --project=chromium --reporter=line

# Capture exit code
TEST_EXIT=$?
```

**Timeout**: 60 secondi max per quick tests.

##### Step 6: Cleanup

```bash
# Stop HTTP server
kill $HTTP_SERVER_PID 2>/dev/null || true

# Remove screenshots (opzionale, solo se pass)
[ $TEST_EXIT -eq 0 ] && rm -f /tmp/*.png
```

##### Step 7: Handle Result

**Test PASS** (exit 0):
```
✅ Playwright Quick Test: PASS (2/2 tests)

Block [block-name] verified on Chrome.
Frontend UI working correctly.
```

→ Procedi normalmente (sblocca dipendenti)

**Test FAIL** (exit non-0):
```
❌ Playwright Quick Test: FAIL (1/2 tests)

Failed test: login.spec.js - should fill and submit login form
Error: Expected URL to contain '/devices', got '/login'

Possible causes:
1. API endpoint changed (check backend logs)
2. Frontend parsing error (check browser console)
3. Timing issue (increase waitForTimeout)

Screenshots saved: /tmp/*.png

Action: Review failure, fix if needed, re-test.
```

→ **NON bloccare** altri blocchi indipendenti
→ Notifica user del failure
→ Continue o Stop? (config: `playwright.on_failure`)

##### Configuration

```yaml
# project-config.yaml
develop:
  playwright:
    enabled: true                    # Default: true
    trigger: "on_frontend_block"     # Quando eseguire
    auto_setup: true                 # Setup automatico NPM + Playwright
    auto_generate_tests: true        # Genera test per blocco
    test_timeout: 60000              # 60s max
    on_failure: "notify"             # notify | stop | continue
    cleanup_on_success: true         # Rimuovi screenshot se pass
    browser: "chromium"              # chromium | firefox | webkit
    headless: false                  # Mostra browser durante test
```

**Tipo**: REVIEW (non-blocking) - notifica failure ma continua.

**Effort**: ~30s setup (prima volta) + ~15-20s per test run.

**Benefits**:
- ✅ **Verifica UI reale** su browser (non solo unit test)
- ✅ **Early detection** di integration issues (API mismatch, parsing error)
- ✅ **Automatic** (zero manual effort se pass)
- ✅ **Fast feedback** (~20s per quick test)
- ✅ **Progressive** (test ogni blocco, non solo a milestone end)
```

## Test Generation Guidelines

### Per frontend-implementer Agent

Quando `frontend-implementer` completa un blocco con screen navigabile, genera **automaticamente** il test Playwright corrispondente.

**Input al frontend-implementer**:
- Screen name (es: LoginScreen)
- Route path (es: /login)
- Form fields (es: email, password)
- Expected navigation on success (es: /devices)

**Output generato**:
```javascript
// e2e-tests/[screen-name].spec.js
import { test, expect } from '@playwright/test';

test.describe('[Screen Name] @quick', () => {
  test('should load [screen]', async ({ page }) => {
    await page.goto('http://localhost:8080/#/[route]');
    await page.waitForTimeout(5000);

    // Verifica elementi visibili
    // [Auto-generato basato su screen UI]
  });

  test('should [action]', async ({ page }) => {
    // [Auto-generato basato su user actions]
  });
});
```

**Best practices**:
- Max 2-3 test per screen (load + happy path)
- Tag `@quick` per esecuzione rapida
- Coordinate click per Flutter web (più affidabile)
- Timeout generosi (Flutter rendering è lento)
- Screenshot on failure automatici

## Backend Response Format Handling

**IMPORTANTE**: Backend può restituire risposte in formati diversi.

### Common Patterns

**Pattern 1: Wrapper format** (QRPay backend):
```json
{
  "success": true,
  "data": { ...actual data... }
}
```

**Pattern 2: Direct format**:
```json
{ ...actual data... }
```

**Pattern 3: Error format**:
```json
{
  "success": false,
  "error": { "message": "...", "code": "..." }
}
```

### Detection & Fix

Se Playwright test fallisce con `200 OK` ma app mostra errore:

1. **Intercetta risposta** con Playwright:
   ```javascript
   page.on('response', async response => {
     if (response.url().includes('/api/')) {
       const body = await response.text();
       console.log(`[API] ${response.status()} ${response.url()}`);
       console.log(`[BODY] ${body.substring(0, 200)}`);
     }
   });
   ```

2. **Analizza formato**:
   - Se `{success, data}` → Fix frontend parsing (extract `data` field)
   - Se direct → Frontend OK
   - Se error format diverso → Fix error handling

3. **Auto-fix** (se possibile):
   - Invoca `fixer` agent con analysis
   - Modifica repository parsing
   - Re-build + re-test

## Integration with Existing Workflow

### Modifiche a SKILL.md

Aggiungere in `/Users/ale/.claude/skills/develop/SKILL.md`:

**Fase 4f** - dopo "Blocco Completo", inserire:

```markdown
### 4f.3 Playwright Quick Test (se blocco frontend con UI)

**Consulta `playwright-integration.md` per dettagli completi.**

**Quick summary**:
1. Setup Playwright (auto, se prima volta)
2. Genera test per screen implementata
3. Build frontend web + start HTTP server
4. Run `npx playwright test --grep="@quick"`
5. Report result (PASS/FAIL)
6. Cleanup

**Tipo**: REVIEW (non-blocking)
**Effort**: ~30s (setup) + ~20s (run)
```

### Modifiche a frontend-implementer Agent

Aggiungere in `/Users/ale/.claude/agents/frontend-implementer.md`:

**Capabilities** section:

```markdown
- **Playwright test generation**: Genera automaticamente test E2E per ogni screen implementata
  - Analizza screen UI (form fields, buttons, text)
  - Genera coordinate click per Flutter web
  - Include happy path + load verification
  - Tag `@quick` per esecuzione rapida
```

**Workflow Position** section:

```markdown
Dopo implementazione screen navigabile:
1. Scrive codice Flutter
2. Scrive unit test
3. **NUOVO**: Genera Playwright test per screen (e2e-tests/[screen-name].spec.js)
```

## Troubleshooting

### Test fallisce con "Element not found"

**Causa**: Selettori CSS non funzionano con Flutter web.

**Fix**: Usa coordinate click invece di selettori:
```javascript
// ❌ await page.click('input[type="email"]')
// ✅ await page.mouse.click(640, 307)
```

### Test fallisce con "200 OK but error message shown"

**Causa**: Backend response format non matchato da frontend parsing.

**Fix**:
1. Intercetta response con Playwright
2. Verifica formato JSON
3. Aggiorna frontend parsing (extract `data` field se wrapper)

### Backend non risponde (connection refused)

**Causa**: Backend non running.

**Fix**:
```bash
cd qrpay-backend
npm run dev
```

Attendere "Server listening on port 3000" prima di ri-eseguire test.

### Flutter app non carica (white screen)

**Causa**: Build web non aggiornato o corrotto.

**Fix**:
```bash
flutter clean
flutter build web --release
```

## Example: Full Integration for LoginScreen Block

**Block**: B3 - Auth Feature (LoginScreen)

**frontend-implementer output**:
- ✅ LoginScreen widget
- ✅ AuthProvider
- ✅ Unit tests
- ✅ **Playwright test** (auto-generated):

```javascript
// e2e-tests/login.spec.js
import { test, expect } from '@playwright/test';

test.describe('Login Flow @quick', () => {
  test('should load login screen with logo and form', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForTimeout(5000);

    await expect(page.locator('text=QRPay')).toBeVisible();
    await expect(page.locator('text=Gestione Dispositivi')).toBeVisible();
    await expect(page.locator('text=Email')).toBeVisible();
    await expect(page.locator('text=Password')).toBeVisible();
    await expect(page.locator('text=ACCEDI')).toBeVisible();
  });

  test('should login with valid credentials and redirect to devices', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForTimeout(5000);

    // Fill email
    await page.mouse.click(640, 307);
    await page.keyboard.type('demo@qrpay.io', { delay: 100 });

    // Fill password
    await page.mouse.click(640, 370);
    await page.keyboard.type('password123', { delay: 100 });

    // Submit
    await page.keyboard.press('Enter');

    // Wait for API response
    await page.waitForTimeout(3000);

    // Verify redirect to devices screen
    expect(page.url()).toContain('/devices');
    await expect(page.locator('text=Devices Screen')).toBeVisible();
  });
});
```

**Execution**:
```bash
# Auto-setup (prima volta)
npm install
npx playwright install chromium

# Build frontend
cd qrpay-app
flutter build web --release

# Start server
cd build/web && python3 -m http.server 8080 &

# Run quick test
npx playwright test --grep="@quick" --project=chromium

# Output:
# ✅ Login Flow > should load login screen with logo and form (2.3s)
# ✅ Login Flow > should login with valid credentials and redirect to devices (5.1s)
#
# 2 passed (7.4s)
```

**Result**: ✅ Block B3 verified on Chrome, procedi a B4.

---

## Summary

**Cosa cambia**:
1. `/develop` esegue Playwright quick test dopo ogni blocco frontend con UI
2. Setup automatico (no permessi chiesti)
3. Test auto-generati da `frontend-implementer`
4. Failure notificato ma NON blocca workflow
5. Early detection di API mismatch, parsing errors, navigation issues

**Effort aggiuntivo**: ~20-30s per blocco frontend (automatico)

**Benefits**:
- ✅ UI verificata su browser reale
- ✅ Integration issues trovati subito
- ✅ Zero manual effort
- ✅ Fast feedback loop
