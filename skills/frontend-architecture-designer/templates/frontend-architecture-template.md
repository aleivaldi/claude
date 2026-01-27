# Frontend Architecture - [Nome Progetto]

> Stato: DRAFT | Versione: 1.0 | Data: [Data]

## Overview

[Breve descrizione architettura frontend e decisioni chiave]

---

## Tech Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Framework | [Next.js / React / Vue / Flutter] | [Version] |
| Language | [TypeScript / Dart] | [Version] |
| State | [Zustand / Redux / Riverpod] | [Version] |
| Styling | [Tailwind / CSS Modules / Themes] | [Version] |
| Testing | [Jest / Vitest / Flutter Test] | [Version] |
| E2E | [Playwright / Cypress] | [Version] |

---

## Directory Structure

```
src/
├── app/                    # Pages / Routes
│   ├── (auth)/            # Route groups
│   │   ├── login/
│   │   └── register/
│   ├── dashboard/
│   └── layout.tsx
├── components/
│   ├── ui/                # Base UI components
│   │   ├── Button/
│   │   │   ├── Button.tsx
│   │   │   ├── Button.test.tsx
│   │   │   └── index.ts
│   │   └── ...
│   ├── features/          # Feature-specific
│   │   ├── auth/
│   │   └── dashboard/
│   └── layout/            # Layout components
│       ├── Header.tsx
│       └── Sidebar.tsx
├── hooks/                 # Custom hooks
│   ├── useAuth.ts
│   └── useApi.ts
├── lib/                   # Utilities
│   ├── api/              # API client
│   ├── utils/            # Helpers
│   └── validations/      # Schemas
├── stores/               # State management
│   ├── authStore.ts
│   └── uiStore.ts
├── types/                # TypeScript types
│   ├── api.ts
│   └── models.ts
└── styles/               # Global styles
    └── globals.css
```

---

## Component Patterns

### Component Types

| Type | Responsabilità | State | Examples |
|------|----------------|-------|----------|
| **UI Components** | Presentation only | Props only | Button, Card, Input |
| **Feature Components** | Business logic | Local + store | LoginForm, UserProfile |
| **Page Components** | Route handling | Route params | DashboardPage |
| **Layout Components** | Page structure | Minimal | Header, Sidebar |

### Component Structure

```
components/ui/Button/
├── Button.tsx           # Component implementation
├── Button.test.tsx      # Unit tests
├── Button.stories.tsx   # Storybook (optional)
└── index.ts             # Public exports
```

### Naming Conventions

- Components: `PascalCase` (Button, UserProfile)
- Files: `PascalCase.tsx` or `kebab-case.tsx`
- Hooks: `use` prefix (useAuth, useApi)
- Utils: `camelCase` (formatDate, parseError)

---

## State Management

### State Categories

| Category | Scope | Solution | Examples |
|----------|-------|----------|----------|
| **Server State** | Remote data | React Query / SWR | User data, lists |
| **Client State** | UI state | Zustand | Theme, modals |
| **Form State** | Form inputs | React Hook Form | Login, filters |
| **URL State** | Route params | Router | Page, search |

### Store Structure

```typescript
// stores/authStore.ts
interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  login: (user: User) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  isAuthenticated: false,
  login: (user) => set({ user, isAuthenticated: true }),
  logout: () => set({ user: null, isAuthenticated: false }),
}));
```

### Data Flow

```
User Action → Component → Store/Hook → API Call → Update State → Re-render
```

---

## API Integration

### Client Configuration

```typescript
// lib/api/client.ts
const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 10000,
});

// Interceptors
apiClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout();
    }
    return Promise.reject(error);
  }
);
```

### Error Handling

```typescript
// lib/utils/errors.ts
export function parseApiError(error: unknown): string {
  if (axios.isAxiosError(error)) {
    return error.response?.data?.error?.message || 'Request failed';
  }
  return 'An unexpected error occurred';
}
```

---

## Styling

### Approach
[Tailwind CSS / CSS Modules / Styled Components]

### Design Tokens

```css
/* styles/globals.css */
:root {
  --color-primary: #3b82f6;
  --color-secondary: #6366f1;
  --spacing-unit: 4px;
  --border-radius: 8px;
}
```

### Responsive Breakpoints

| Breakpoint | Width | Use Case |
|------------|-------|----------|
| sm | 640px | Mobile landscape |
| md | 768px | Tablet |
| lg | 1024px | Desktop |
| xl | 1280px | Large desktop |

---

## Routing

### Strategy
[File-based (Next.js) / Centralized (React Router)]

### Protected Routes

```typescript
// middleware.ts (Next.js)
export function middleware(request: NextRequest) {
  const token = request.cookies.get('token');

  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
}
```

### Route Groups

```
app/
├── (public)/           # No auth required
│   ├── login/
│   └── register/
├── (protected)/        # Auth required
│   ├── dashboard/
│   └── profile/
└── (admin)/            # Admin only
    └── admin/
```

---

## Testing Strategy

### Unit Tests
- Location: `**/*.test.tsx`
- Coverage target: 80%
- Tools: Vitest / Jest + React Testing Library

### Component Tests

```typescript
// Button.test.tsx
describe('Button', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('calls onClick when clicked', async () => {
    const onClick = vi.fn();
    render(<Button onClick={onClick}>Click</Button>);
    await userEvent.click(screen.getByRole('button'));
    expect(onClick).toHaveBeenCalled();
  });
});
```

### E2E Tests
- Location: `e2e/`
- Tools: Playwright
- Focus: Critical user journeys

```typescript
// e2e/auth.spec.ts
test('user can login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name="email"]', 'user@example.com');
  await page.fill('[name="password"]', 'password123');
  await page.click('[type="submit"]');
  await expect(page).toHaveURL('/dashboard');
});
```

---

## Performance

### Optimization Strategies

- [ ] Code splitting (dynamic imports)
- [ ] Image optimization (next/image)
- [ ] Lazy loading components
- [ ] Memoization (useMemo, useCallback)
- [ ] Virtual lists for large data

### Core Web Vitals Targets

| Metric | Target |
|--------|--------|
| LCP | < 2.5s |
| FID | < 100ms |
| CLS | < 0.1 |

---

## Accessibility

- [ ] Semantic HTML
- [ ] ARIA labels where needed
- [ ] Keyboard navigation
- [ ] Color contrast (WCAG AA)
- [ ] Focus indicators

---

## Commands Reference

```bash
# Development
npm run dev              # Start dev server

# Build
npm run build            # Production build
npm run start            # Start production

# Quality
npm run lint             # ESLint check
npm run typecheck        # TypeScript check

# Testing
npm run test             # Unit tests
npm run test:e2e         # E2E tests
npm run test:coverage    # Coverage report
```

---

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| NEXT_PUBLIC_API_URL | Backend API URL | Yes |
| NEXT_PUBLIC_APP_URL | Frontend URL | Yes |
| [Others] | [Description] | [Yes/No] |

---

## Prossimi Step

1. `/backend-architecture-designer` - Architettura backend
2. `/api-signature-generator` - Definire contratti API
3. `/develop` - Implementazione
