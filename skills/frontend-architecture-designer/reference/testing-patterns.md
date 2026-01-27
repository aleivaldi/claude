# Testing Patterns - Frontend

## Testing Pyramid

```
        ╱╲
       ╱E2E╲         Few, slow, expensive
      ╱──────╲
     ╱Integration╲   Some, medium
    ╱──────────────╲
   ╱   Unit Tests   ╲ Many, fast, cheap
  ╱──────────────────╲
```

---

## React Testing Patterns

### Unit Tests (Vitest/Jest + RTL)

#### Component Rendering

```typescript
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('renders as disabled', () => {
    render(<Button disabled>Click</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

#### User Interactions

```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('LoginForm', () => {
  it('submits form with valid data', async () => {
    const onSubmit = vi.fn();
    const user = userEvent.setup();

    render(<LoginForm onSubmit={onSubmit} />);

    await user.type(screen.getByLabelText(/email/i), 'test@example.com');
    await user.type(screen.getByLabelText(/password/i), 'password123');
    await user.click(screen.getByRole('button', { name: /login/i }));

    expect(onSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123',
    });
  });

  it('shows validation error for invalid email', async () => {
    const user = userEvent.setup();

    render(<LoginForm onSubmit={vi.fn()} />);

    await user.type(screen.getByLabelText(/email/i), 'invalid');
    await user.click(screen.getByRole('button', { name: /login/i }));

    expect(screen.getByText(/invalid email/i)).toBeInTheDocument();
  });
});
```

#### Testing Hooks

```typescript
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('increments counter', () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});
```

#### Testing with Providers

```typescript
import { render } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

function createTestQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  });
}

function renderWithProviders(ui: React.ReactElement) {
  const queryClient = createTestQueryClient();

  return render(
    <QueryClientProvider client={queryClient}>
      {ui}
    </QueryClientProvider>
  );
}
```

#### Mocking API Calls

```typescript
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  rest.get('/api/users', (req, res, ctx) => {
    return res(ctx.json([
      { id: 1, name: 'John' },
      { id: 2, name: 'Jane' },
    ]));
  }),
  rest.post('/api/login', async (req, res, ctx) => {
    const { email, password } = await req.json();
    if (email === 'test@example.com' && password === 'password') {
      return res(ctx.json({ token: 'fake-token' }));
    }
    return res(ctx.status(401));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

### E2E Tests (Playwright)

#### Page Object Model

```typescript
// pages/LoginPage.ts
export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.page.fill('[name="email"]', email);
    await this.page.fill('[name="password"]', password);
    await this.page.click('[type="submit"]');
  }

  async expectError(message: string) {
    await expect(this.page.getByText(message)).toBeVisible();
  }
}

// tests/auth.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from './pages/LoginPage';

test('user can login', async ({ page }) => {
  const loginPage = new LoginPage(page);

  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');

  await expect(page).toHaveURL('/dashboard');
});
```

#### Fixtures

```typescript
// fixtures/auth.fixture.ts
import { test as base } from '@playwright/test';

type AuthFixtures = {
  authenticatedPage: Page;
};

export const test = base.extend<AuthFixtures>({
  authenticatedPage: async ({ page }, use) => {
    await page.goto('/login');
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'password123');
    await page.click('[type="submit"]');
    await page.waitForURL('/dashboard');
    await use(page);
  },
});

// Usage
test('authenticated user can access profile', async ({ authenticatedPage }) => {
  await authenticatedPage.goto('/profile');
  await expect(authenticatedPage.getByText('Profile')).toBeVisible();
});
```

---

## Flutter Testing Patterns

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthNotifier authNotifier;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    authNotifier = AuthNotifier(mockRepository);
  });

  group('AuthNotifier', () {
    test('initial state is unauthenticated', () {
      expect(authNotifier.state.isAuthenticated, false);
    });

    test('login success updates state', () async {
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const User(id: '1', email: 'test@test.com'));

      await authNotifier.login('test@test.com', 'password');

      expect(authNotifier.state.isAuthenticated, true);
      expect(authNotifier.state.user?.email, 'test@test.com');
    });

    test('login failure sets error', () async {
      when(() => mockRepository.login(any(), any()))
          .thenThrow(AuthException('Invalid credentials'));

      await authNotifier.login('test@test.com', 'wrong');

      expect(authNotifier.state.isAuthenticated, false);
      expect(authNotifier.state.error, 'Invalid credentials');
    });
  });
}
```

### Widget Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginForm', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoginForm()),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('shows error for empty email', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoginForm()),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('calls onSubmit with form data', (tester) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onSubmit: (email, password) {
                submittedEmail = email;
                submittedPassword = password;
              },
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(submittedEmail, 'test@test.com');
      expect(submittedPassword, 'password123');
    });
  });
}
```

### Integration Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('user can login and see dashboard', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Fill login form
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
```

---

## Best Practices

### AAA Pattern

```typescript
it('should calculate total correctly', () => {
  // Arrange
  const items = [{ price: 10 }, { price: 20 }];

  // Act
  const total = calculateTotal(items);

  // Assert
  expect(total).toBe(30);
});
```

### Test Naming

```typescript
// Good
it('should show error message when email is invalid')
it('should redirect to dashboard after successful login')
it('should disable submit button while loading')

// Bad
it('test 1')
it('works correctly')
it('email validation')
```

### Coverage Targets

| Type | Target | Focus |
|------|--------|-------|
| Unit | 80% | Business logic, utils |
| Component | 60% | UI components |
| E2E | Critical paths | Auth, checkout, core flows |
