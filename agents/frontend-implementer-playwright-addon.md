# Playwright Test Generation (Frontend Implementer Add-on)

## When to Generate

Dopo aver implementato una **screen navigabile** (pagina completa con route), genera automaticamente il test Playwright corrispondente.

**Trigger**:
- Screen con route (es: LoginScreen → /login)
- Screen con form interaction (es: login form, create device form)
- Screen con navigation (es: DeviceList → DeviceDetail)

**Skip**:
- Componenti isolati senza route (Button, Card, etc.)
- Widgets senza screen container
- Screens senza interaction significativa

## File Location

```
e2e-tests/
├── [screen-name].spec.js    # Per ogni screen implementata
└── package.json              # Se non esiste, verrà creato da /develop
```

## Template Base

```javascript
// e2e-tests/[screen-name].spec.js
import { test, expect } from '@playwright/test';

test.describe('[Screen Name] @quick', () => {
  test('should load [screen] with expected elements', async ({ page }) => {
    await page.goto('http://localhost:8080/#/[route]');

    // Aspetta Flutter app load
    await page.waitForTimeout(5000);

    // Verifica elementi visibili
    await expect(page.locator('text=[MainTitle]')).toBeVisible();
    await expect(page.locator('text=[SubTitle]')).toBeVisible();
    // ... altri elementi chiave
  });

  test('should [main-action]', async ({ page }) => {
    await page.goto('http://localhost:8080/#/[route]');
    await page.waitForTimeout(5000);

    // Interaction logic (fill form, click button, etc.)
    // ...

    // Verify outcome
    expect(page.url()).toContain('[expected-route]');
  });
});
```

## Examples

### LoginScreen Test

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

    // Click coordinate email field (Flutter web - coordinate più affidabili di selettori)
    await page.mouse.click(640, 307);
    await page.keyboard.type('demo@qrpay.io', { delay: 100 });

    // Click coordinate password field
    await page.mouse.click(640, 370);
    await page.keyboard.type('password123', { delay: 100 });

    // Submit
    await page.keyboard.press('Enter');

    // Wait for API response
    await page.waitForTimeout(3000);

    // Verify redirect
    expect(page.url()).toContain('/devices');
    await expect(page.locator('text=Devices Screen')).toBeVisible();
  });
});
```

### DeviceListScreen Test

```javascript
// e2e-tests/devices.spec.js
import { test, expect } from '@playwright/test';

test.describe('Devices List @quick', () => {
  test('should load devices screen with header', async ({ page }) => {
    // Login first (prerequisite)
    await page.goto('http://localhost:8080');
    await page.waitForTimeout(5000);
    await page.mouse.click(640, 307);
    await page.keyboard.type('demo@qrpay.io', { delay: 100 });
    await page.mouse.click(640, 370);
    await page.keyboard.type('password123', { delay: 100 });
    await page.keyboard.press('Enter');
    await page.waitForTimeout(3000);

    // Now on devices screen
    await expect(page.locator('text=Dispositivi')).toBeVisible();
    await expect(page.locator('text=Aggiungi Dispositivo')).toBeVisible();
  });

  test('should display device list loaded from API', async ({ page }) => {
    // Login
    await page.goto('http://localhost:8080');
    await page.waitForTimeout(5000);
    await page.mouse.click(640, 307);
    await page.keyboard.type('demo@qrpay.io', { delay: 100 });
    await page.mouse.click(640, 370);
    await page.keyboard.type('password123', { delay: 100 });
    await page.keyboard.press('Enter');
    await page.waitForTimeout(3000);

    // Verify device list loaded (from seed data)
    await expect(page.locator('text=QRPAY-001')).toBeVisible();
    await expect(page.locator('text=Tavolo 1')).toBeVisible();
  });
});
```

## Flutter Web Specifics

### Use Coordinate Clicks (NOT CSS Selectors)

Flutter web usa canvas rendering, quindi selettori CSS spesso falliscono. Usa coordinate click basate su layout:

```javascript
// ❌ NON funziona bene con Flutter
await page.click('input[type="email"]');

// ✅ Funziona affidabilmente
await page.mouse.click(640, 307);  // Email field coordinate
```

### Common Coordinate Patterns

Basato su mockup standard:

```javascript
// Email field: ~y=307
await page.mouse.click(640, 307);

// Password field: ~y=370
await page.mouse.click(640, 370);

// Primary button: ~y=450
await page.mouse.click(640, 450);

// Top-right button (Add): ~x=1100, y=100
await page.mouse.click(1100, 100);
```

**NOTA**: Adatta coordinate basandoti sul mockup specifico della screen implementata.

### Text Locators Work

Text locators funzionano perché Flutter usa semantics per accessibilità:

```javascript
// ✅ Funziona
await expect(page.locator('text=QRPay')).toBeVisible();
await expect(page.locator('text=Email')).toBeVisible();
```

### Timeouts Generosi

Flutter rendering è lento, usa timeouts generosi:

```javascript
// Aspetta 5-8 secondi per load completo
await page.waitForTimeout(5000);

// Aspetta 3 secondi per API response
await page.waitForTimeout(3000);
```

## Test Generation Checklist

Quando generi test per una screen:

- [ ] Tag `@quick` per esecuzione rapida
- [ ] Test load screen (verifica elementi visibili)
- [ ] Test happy path (login success, create success, etc.)
- [ ] Max 2-3 test per screen (non comprehensive, solo smoke)
- [ ] Coordinate click per form fields (Flutter web)
- [ ] Text locators per verifica elementi
- [ ] Timeout generosi (5s load, 3s API)
- [ ] Screenshot on failure automatici (Playwright default)
- [ ] Clear test names (describe what they verify)

## Integration with /develop Workflow

La generazione test Playwright è **automatica** e avviene in questa sequenza:

1. **frontend-implementer** completa screen (es: LoginScreen)
2. **frontend-implementer** genera test Playwright (es: e2e-tests/login.spec.js)
3. Commit include sia codice screen che test Playwright
4. `/develop` esegue Playwright quick test in fase 4f.3 (automatico, no permessi)
5. Test passa → procedi, Test fail → notifica ma continua

**NO manual steps** - tutto automatico.

## Error Detection

I test Playwright rilevano automaticamente:

- **API mismatch**: Backend response format diverso da atteso (200 OK ma parsing fail)
- **Navigation issues**: Redirect non funzionante
- **Form validation**: Validation rules non applicate
- **Missing elements**: Elementi UI non visibili
- **Timing issues**: API call too slow, timeout

Quando test fallisce, `/develop` invoca `fixer` agent per correggere automaticamente (max 2 tentativi).

## Summary

**Per ogni screen implementata**:
1. Genera `e2e-tests/[screen-name].spec.js`
2. Include test load + happy path
3. Usa coordinate click per Flutter web
4. Tag `@quick` per execution rapida
5. Max 2-3 test (smoke, non comprehensive)

**Output esempio**:
```
qrpay-app/
├── lib/
│   └── features/
│       └── auth/
│           └── screens/
│               └── login_screen.dart   # Implementato
└── e2e-tests/
    └── login.spec.js                    # Auto-generated ✓
```
