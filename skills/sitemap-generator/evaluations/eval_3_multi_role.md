# Evaluation 3: Multi-Role Application

## Input

**brief-structured.md**:
```markdown
## Utenti
- Customer: acquista prodotti
- Vendor: vende prodotti
- Admin: gestisce piattaforma

## Funzionalità
- Marketplace
- Vendor dashboard
- Admin panel
```

## Expected Behavior

### Fase 2: Generazione Draft

Separa sezioni per ruolo:

```markdown
## Pubbliche
- / (landing)
- /login
- /products (catalog pubblico)

## Customer (autenticato)
- /dashboard
- /orders
- /orders/:id

## Vendor (autenticato)
- /vendor/dashboard
- /vendor/products
- /vendor/products/new
- /vendor/orders

## Admin (autenticato)
- /admin
- /admin/users
- /admin/vendors
- /admin/products (moderation)
```

## Expected Output

**sitemap.md** con sezioni ruolo:

```markdown
# Sitemap - Marketplace

## Access Levels

| Level | Pages | Description |
|-------|-------|-------------|
| Public | 3 | Landing, Login, Catalog |
| Customer | 5 | Orders, Profile |
| Vendor | 8 | Product management |
| Admin | 6 | Platform management |

## Pages by Role

### Public (3 pages)
...

### Customer Role (5 pages)
...

### Vendor Role (8 pages)
...

### Admin Role (6 pages)
...
```

## Success Criteria
- ✅ Sezioni separate per ruolo
- ✅ Route prefix per ruoli (/vendor/, /admin/)
- ✅ Access level chiaro
- ✅ Count pagine per ruolo

## Pass/Fail
**PASS**: Separazione ruoli, prefix, access levels
**FAIL**: Tutte pagine mischiate, no separazione ruoli, no prefix
