# /e2e - End-to-End Testing

## Overview

Genera e esegue test E2E con Playwright. Focus su critical user journeys, Page Object Model, e reporting dettagliato.

## Syntax

```bash
/e2e                      # Esegue tutti i test E2E
/e2e [test-file]          # Esegue test specifico
/e2e --generate [flow]    # Genera test per user flow
/e2e --report             # Apre ultimo report HTML
/e2e --debug              # Esegue con UI mode
/e2e --headed             # Esegue con browser visibile
```

## Architecture

### Page Object Model

```
e2e/
├── pages/                # Page Objects
│   ├── BasePage.ts       # Metodi comuni
│   ├── LoginPage.ts
│   ├── DashboardPage.ts
│   └── ProfilePage.ts
├── fixtures/             # Custom fixtures
│   ├── auth.fixture.ts
│   └── data.fixture.ts
├── tests/                # Test specs
│   ├── auth.spec.ts
│   ├── dashboard.spec.ts
│   └── profile.spec.ts
├── helpers/              # Utility functions
│   └── test-data.ts
└── playwright.config.ts
```

### Page Object Example

```typescript
// pages/LoginPage.ts
import { Page, Locator, expect } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.submitButton = page.getByRole('button', { name: 'Login' });
    this.errorMessage = page.getByRole('alert');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }

  async expectLoginSuccess() {
    await expect(this.page).toHaveURL('/dashboard');
  }
}
```

### Test Example

```typescript
// tests/auth.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';

test.describe('Authentication', () => {
  test('user can login with valid credentials', async ({ page }) => {
    const loginPage = new LoginPage(page);

    await loginPage.goto();
    await loginPage.login('user@example.com', 'password123');
    await loginPage.expectLoginSuccess();
  });

  test('shows error for invalid credentials', async ({ page }) => {
    const loginPage = new LoginPage(page);

    await loginPage.goto();
    await loginPage.login('user@example.com', 'wrong');
    await loginPage.expectError('Invalid credentials');
  });
});
```

## Configuration

### playwright.config.ts

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e/tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['junit', { outputFile: 'results/e2e-results.xml' }],
  ],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'on-first-retry',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'mobile', use: { ...devices['iPhone 13'] } },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

## Critical Paths to Test

### Must-Have E2E Tests

| Flow | Priority | Description |
|------|----------|-------------|
| Authentication | P0 | Login, logout, session |
| Registration | P0 | Sign up, email verify |
| Core Journey | P0 | Main user workflow |
| Payment | P0 | Checkout (if applicable) |
| Error Handling | P1 | 404, 500, form errors |
| Responsive | P1 | Mobile breakpoints |

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                     E2E TEST RESULTS                          ║
╠══════════════════════════════════════════════════════════════╣
║ Browser: Chromium                                             ║
║ Tests: 24 total, 23 passed, 1 failed                          ║
║ Duration: 2m 34s                                              ║
╠══════════════════════════════════════════════════════════════╣
║ ✅ auth.spec.ts                                 (4 tests)     ║
║ ✅ dashboard.spec.ts                            (6 tests)     ║
║ ❌ checkout.spec.ts                             (5 tests)     ║
║    └─ payment validation timeout                              ║
║ ✅ profile.spec.ts                              (9 tests)     ║
╠══════════════════════════════════════════════════════════════╣
║ Report: playwright-report/index.html                          ║
║ Traces: test-results/                                         ║
╚══════════════════════════════════════════════════════════════╝
```

## Debugging

### On Failure

```bash
# Apri trace viewer
npx playwright show-trace test-results/[test]/trace.zip

# Debug mode interattivo
npx playwright test --debug

# UI mode
npx playwright test --ui
```

### Visual Debugging

```typescript
test('debug example', async ({ page }) => {
  await page.goto('/');

  // Pause per debug manuale
  await page.pause();

  // Screenshot punto specifico
  await page.screenshot({ path: 'debug.png' });
});
```

## Flakiness Handling

### Strategies

1. **Retry on fail**: `retries: 2` in config
2. **Wait for network idle**: `await page.waitForLoadState('networkidle')`
3. **Explicit waits**: `await expect(locator).toBeVisible()`
4. **Test isolation**: No shared state tra test

### Quarantine Flaky Tests

```typescript
test.skip('flaky test', async ({ page }) => {
  // TODO: Fix flakiness - tracked in JIRA-123
});
```

## Integration

Combina con:
- `/verify pre-pr` - Include E2E prima di PR
- `/checkpoint` - Dopo E2E passano tutti
- `/build-fix` - Se E2E rilevano bug
