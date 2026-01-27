# Sitemap Conventions

## Route Patterns

### REST-like
- Lista: `/resources`
- Dettaglio: `/resources/:id`
- Creazione: `/resources/new`
- Modifica: `/resources/:id/edit`

### Gerarchia
- Max 3 livelli di profondità
- Evita route troppo nested (usa flat dove possibile)

## Categorizzazione

### 🌐 Pubbliche
Pagine accessibili senza autenticazione:
- Landing page
- Login/Register
- Marketing pages
- About, Privacy, Terms

### 🔒 Autenticate
Pagine che richiedono login:
- Dashboard
- User profile
- Settings
- Resource management

### 👑 Admin (se applicabile)
Pagine con permessi admin:
- `/admin/*` prefix
- User management
- System settings

## Naming

- Route lowercase con hyphens: `/user-profile`
- Pagine con PascalCase: "User Profile"
- Descrizioni chiare e concise

## Mobile App Specific

### Tab Navigation
```
Tab 1 (Home) → Screen 1.1, Screen 1.2
Tab 2 (Search) → Screen 2.1
Tab 3 (Profile) → Screen 3.1, Screen 3.2
```

### Modal Flows
- Onboarding: Screen 1 → Screen 2 → Screen 3
- Checkout: Cart → Shipping → Payment → Confirmation

## Error Pages

Sempre includere:
- 404 Not Found
- 500 Server Error
- (Opzionale) 403 Forbidden, 401 Unauthorized
