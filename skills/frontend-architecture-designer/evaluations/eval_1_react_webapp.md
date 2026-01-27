# Evaluation: React Web Application

## Scenario

Dashboard application con:
- Next.js 14 (App Router)
- Zustand + React Query
- Tailwind CSS
- Playwright E2E

## Input

### tech-stack.md (excerpt)
```markdown
## Frontend
- Framework: Next.js 14
- Language: TypeScript
- State: Zustand (client) + React Query (server)
- Styling: Tailwind CSS
- Testing: Vitest + Playwright
```

### sitemap.md (excerpt)
```markdown
## Pages
- / (public)
- /login (public)
- /register (public)
- /dashboard (protected)
- /projects (protected)
- /projects/[id] (protected)
- /settings (protected)
- /admin (admin only)
```

## Expected Output

### frontend-architecture.md (key sections)

```markdown
## Directory Structure

src/
├── app/
│   ├── (public)/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── register/
│   │       └── page.tsx
│   ├── (protected)/
│   │   ├── layout.tsx
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── projects/
│   │   │   ├── page.tsx
│   │   │   └── [id]/
│   │   │       └── page.tsx
│   │   └── settings/
│   │       └── page.tsx
│   ├── (admin)/
│   │   ├── layout.tsx
│   │   └── admin/
│   │       └── page.tsx
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── ui/
│   │   ├── Button/
│   │   ├── Input/
│   │   ├── Card/
│   │   └── Modal/
│   ├── features/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   └── projects/
│   └── layout/
│       ├── Header.tsx
│       └── Sidebar.tsx
├── hooks/
│   ├── useAuth.ts
│   └── useProjects.ts
├── lib/
│   ├── api/
│   ├── utils/
│   └── validations/
├── stores/
│   ├── authStore.ts
│   └── uiStore.ts
└── types/

## Component Patterns

| Type | State | Example |
|------|-------|---------|
| UI | Props only | Button, Card |
| Feature | Zustand/Query | ProjectList |
| Page | Route params | ProjectPage |

## State Management

- Server State: React Query (users, projects)
- Client State: Zustand (auth, theme)
- Form State: React Hook Form
- URL State: Next.js router

## Testing

npm run test           # Vitest
npm run test:e2e       # Playwright
npm run test:coverage  # 80% target
```

## Evaluation Criteria

| Criterio | Peso | Pass |
|----------|------|------|
| Route groups corretti | 25% | ✓ (public), (protected), (admin) |
| Component organization | 25% | ✓ ui/features/layout separation |
| State management split | 20% | ✓ Server vs Client vs Form |
| Testing strategy | 15% | ✓ Unit + E2E |
| Type safety | 15% | ✓ TypeScript strict |

## Common Mistakes to Avoid

1. **Flat component structure**: No organization
2. **Single global store**: Server state in Zustand
3. **No route protection**: Missing middleware
4. **Props drilling**: Instead of store
5. **Missing E2E for auth**: Critical path not tested
