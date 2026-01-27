---
name: frontend-architecture-designer
description: Progetta architettura implementativa frontend. Definisce component patterns, state management, styling, routing. Prerequisito tech-stack approvato. Output frontend-architecture.md per guidare implementazione.
---

# Frontend Architecture Designer

## Il Tuo Compito

Progettare l'architettura **implementativa** del frontend dopo che le scelte tecnologiche sono state approvate. Focus su:
1. Component architecture e patterns
2. State management strategy
3. Styling approach
4. Routing configuration
5. Testing strategy

**Prerequisito**: Checkpoint `tech_stack_choice` completato.

**Output**: `docs/architecture/frontend-architecture.md`

---

## Materiali di Riferimento

**Templates**:
- `templates/frontend-architecture-template.md` - Template output principale
- `templates/react-structure.md` - Struttura React/Next.js
- `templates/flutter-structure.md` - Struttura Flutter

**Reference**:
- `reference/error-handling.md` - Gestione errori skill
- `reference/state-management-comparison.md` - Zustand vs Redux vs Riverpod
- `reference/testing-patterns.md` - Pattern test per tech

---

## Workflow: 5 Fasi

```
Fase 1: Analyze Context       → Legge tech-stack, sitemap
Fase 2: Component Architecture → Pattern componenti, struttura directory
Fase 3: State Management      → Strategy stato, data flow
Fase 4: Draft + Testing       → Crea frontend-architecture-draft.md
        >>> CHECKPOINT: FRONTEND_ARCHITECTURE <<<
Fase 5: Finalization          → Approva e finalizza
```

---

## Fase 1: Analyze Context

### Obiettivo
Raccogliere input architetturali per decisioni implementative.

### Azioni

1. **Verifica prerequisito**: Tech stack approvato
   ```
   Cerca: docs/architecture/tech-stack.md
   Se non esiste: "Esegui prima /architecture-designer"
   ```

2. **Leggi documenti**:
   - `docs/architecture/tech-stack.md` - Stack scelto
   - `docs/frontend-specs/sitemap.md` - Struttura pagine
   - `docs/architecture/overview.md` - Componenti sistema
   - `project-config.yaml` - Configurazione progetto

3. **Identifica tech stack frontend**:
   - Platform: Web / Mobile / Both
   - Framework: React / Vue / Next.js / Nuxt.js / Flutter / React Native
   - State: Zustand / Redux / Riverpod / BLoC / Pinia
   - Styling: Tailwind / CSS Modules / Styled-components / Flutter Themes

4. **Comunica sintesi**:
   ```
   Analisi completata:

   Stack Frontend:
   - Platform: Web
   - Framework: Next.js 14 (App Router)
   - State: Zustand
   - Styling: Tailwind CSS

   Procedo con design architettura frontend.
   ```

---

## Fase 2: Component Architecture

### Obiettivo
Definire component patterns, directory structure e component boundaries.

### Decisioni da Catturare

| Categoria | Opzioni | Quando Usare |
|-----------|---------|--------------|
| **Component Pattern** | Atomic Design / Feature-based / Flat | Feature-based per progetti medi |
| **File Colocation** | Components + styles + tests together | Sempre preferito |
| **Naming Convention** | PascalCase components, kebab-case files | Standard React/Vue |
| **Export Style** | Named exports / Default exports | Named per consistency |

### Directory Structure (React/Next.js)

```
src/
├── app/                    # Next.js App Router pages
│   ├── (auth)/            # Route groups
│   │   ├── login/
│   │   └── register/
│   ├── dashboard/
│   └── layout.tsx
├── components/
│   ├── ui/                # Base UI components (Button, Input, Card)
│   │   ├── Button/
│   │   │   ├── Button.tsx
│   │   │   ├── Button.test.tsx
│   │   │   └── index.ts
│   │   └── ...
│   ├── features/          # Feature-specific components
│   │   ├── auth/
│   │   │   ├── LoginForm.tsx
│   │   │   └── RegisterForm.tsx
│   │   └── dashboard/
│   └── layout/            # Layout components
│       ├── Header.tsx
│       ├── Sidebar.tsx
│       └── Footer.tsx
├── hooks/                 # Custom React hooks
│   ├── useAuth.ts
│   └── useApi.ts
├── lib/                   # Utilities and configurations
│   ├── api/              # API client
│   ├── utils/            # Helper functions
│   └── validations/      # Zod schemas
├── stores/               # Zustand stores
│   ├── authStore.ts
│   └── uiStore.ts
├── types/                # TypeScript types
│   ├── api.ts
│   └── models.ts
└── styles/               # Global styles
    └── globals.css
```

### Directory Structure (Flutter)

```
lib/
├── main.dart
├── app/
│   ├── app.dart           # MaterialApp configuration
│   └── router.dart        # GoRouter configuration
├── features/              # Feature-based modules
│   ├── auth/
│   │   ├── data/         # Repositories, data sources
│   │   ├── domain/       # Entities, use cases
│   │   └── presentation/ # Screens, widgets, controllers
│   └── dashboard/
├── shared/
│   ├── widgets/          # Shared widgets
│   ├── utils/            # Utilities
│   └── constants/        # App constants
├── core/
│   ├── network/          # Dio client, interceptors
│   ├── storage/          # Local storage
│   └── error/            # Error handling
└── l10n/                 # Localization
```

### Component Guidelines

| Type | Responsibilità | State | Examples |
|------|----------------|-------|----------|
| **UI Components** | Presentation only | Props only | Button, Card, Input |
| **Feature Components** | Business logic | Local + store | LoginForm, UserProfile |
| **Page Components** | Route handling | Route params | DashboardPage |
| **Layout Components** | Page structure | Minimal | Header, Sidebar |

---

## Fase 3: State Management

### Obiettivo
Definire state strategy, data flow e caching.

### State Categories

| Category | Scope | Where | Examples |
|----------|-------|-------|----------|
| **Server State** | Remote data | React Query / SWR | User data, posts |
| **Client State** | UI state | Zustand / Context | Theme, sidebar open |
| **Form State** | Form inputs | React Hook Form | Login form, filters |
| **URL State** | Route params | Next.js router | Page, filters |

### State Management Options

**React/Next.js**:
```typescript
// Zustand store example
import { create } from 'zustand';

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

**Flutter (Riverpod)**:
```dart
// Riverpod provider example
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await _repository.login(email, password);
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }
}
```

### Data Flow Pattern

```
User Action → Component → Store/Provider → API Call → Update State → Re-render
                ↓
            Optimistic Update (optional)
```

### Caching Strategy

| Data Type | Cache Duration | Invalidation |
|-----------|----------------|--------------|
| User profile | Session | On logout |
| List data | 5 minutes | On mutation |
| Static data | 1 hour | Manual |
| Form data | None | On submit |

---

## Fase 4: Draft + Testing Strategy

### Obiettivo
Creare documento architettura con testing strategy definita.

### Testing Strategy Frontend

```
Unit Tests (80% coverage target):
├── Components: Render + interaction
│   - React Testing Library
│   - Flutter Widget Tests
├── Hooks: Custom hook behavior
│   - renderHook from RTL
├── Stores: State transitions
│   - Direct store testing
└── Utils: Pure function tests

Component Tests:
├── User interactions
│   - Click, type, submit
├── Async operations
│   - Loading states, errors
└── Accessibility
    - ARIA, keyboard nav

E2E Tests (Critical Paths):
├── Authentication flow
├── Main user journey
└── Error scenarios
```

### Comandi Automatici

```bash
# Development
npm run dev              # Development server
npm run build            # Production build
npm run start            # Start production

# Quality
npm run lint             # ESLint check
npm run lint:fix         # ESLint auto-fix
npm run typecheck        # TypeScript check

# Testing
npm run test             # Run all tests
npm run test:unit        # Unit tests (Vitest/Jest)
npm run test:e2e         # E2E tests (Playwright)
npm run test:coverage    # Coverage report
npm run test:watch       # Watch mode

# Storybook (if used)
npm run storybook        # Start Storybook
npm run build-storybook  # Build Storybook
```

### Flutter Commands

```bash
# Development
flutter run              # Run app
flutter build apk        # Build Android
flutter build ios        # Build iOS

# Quality
dart format .            # Format code
flutter analyze          # Static analysis

# Testing
flutter test             # Unit + Widget tests
flutter test --coverage  # Coverage report
flutter drive            # Integration tests
```

### Azioni

1. **Crea draft** usando `templates/frontend-architecture-template.md`
2. **Popola sezioni**:
   - Directory structure per framework
   - Component patterns e guidelines
   - State management configuration
   - Styling approach
   - Testing strategy con comandi

3. **Scrivi** `docs/architecture/frontend-architecture-draft.md`

4. **Presenta CHECKPOINT**:

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: FRONTEND_ARCHITECTURE <<<
═══════════════════════════════════════════════════════════════

## Stato: BLOCKING

## Architettura Frontend Definita

### Directory Structure
[Mostra directory tree]

### Component Patterns
- UI Components: Presentational only
- Feature Components: With business logic
- Colocation: Components + tests together

### State Management
- Server State: React Query
- Client State: Zustand
- Form State: React Hook Form

### Testing Strategy
- Unit: 80% coverage target
- E2E: Playwright for critical paths
- Comandi: npm run test:*

## Artefatto
- `docs/architecture/frontend-architecture-draft.md`

═══════════════════════════════════════════════════════════════
Approvi? [S]ì / [N]o / [M]odifica
═══════════════════════════════════════════════════════════════
```

5. **Usa AskUserQuestion** per raccogliere risposta

---

## Fase 5: Finalization

### Obiettivo
Finalizzare documento approvato.

### Azioni

1. **Rinomina** draft rimuovendo "-draft":
   ```
   frontend-architecture-draft.md → frontend-architecture.md
   ```

2. **Aggiorna stato** nel documento da DRAFT a APPROVATO

3. **Aggiorna README** architettura:
   ```markdown
   | [frontend-architecture.md](frontend-architecture.md) | Architettura frontend | ✅ Approvato |
   ```

4. **Comunica completamento**:
   ```
   ✅ Frontend Architecture completata.

   Output: docs/architecture/frontend-architecture.md

   Contenuto:
   - Directory structure definita
   - Component patterns stabiliti
   - State management configurato
   - Testing strategy definita

   Prossimo step: /backend-architecture-designer (se non fatto)
                  oppure /api-signature-generator
   ```

---

## Tecnologie Supportate

### Web

| Framework | State | Styling | Use Case |
|-----------|-------|---------|----------|
| Next.js | Zustand / Redux | Tailwind | Full-stack React |
| React | Zustand / Redux | Tailwind / Styled | SPA |
| Vue 3 | Pinia | Tailwind | Vue ecosystem |
| Nuxt 3 | Pinia | Tailwind | Full-stack Vue |

### Mobile

| Framework | State | Styling | Use Case |
|-----------|-------|---------|----------|
| Flutter | Riverpod / BLoC | Themes | Cross-platform |
| React Native | Zustand / Redux | StyleSheet | React developers |

---

## Regole Tool

- ✅ **SEMPRE** Read tech-stack.md e sitemap.md prima di procedere
- ✅ Write per creare draft
- ✅ AskUserQuestion per checkpoint
- ❌ **MAI** saltare checkpoint
- ❌ **MAI** assumere stack non verificato

---

## Gestione Errori

**Consulta `reference/error-handling.md` per procedure complete.**

| Errore | Causa | Recovery |
|--------|-------|----------|
| Tech stack mancante | Prerequisito non completato | Suggerisci /architecture-designer |
| Sitemap mancante | Frontend specs non fatte | Suggerisci /sitemap-generator |
| Stack non supportato | Framework sconosciuto | Chiedi chiarimenti, proponi alternativa |

---

## Avvio Workflow

1. Verifica prerequisito (tech_stack_choice)
2. Fase 1: Analyze context
3. Fase 2: Component architecture
4. Fase 3: State management
5. Fase 4: Draft + CHECKPOINT
6. Fase 5: Finalization

**Principio**: L'architettura frontend definisce come i componenti saranno organizzati. Ogni decisione impatta developer experience e manutenibilità.
