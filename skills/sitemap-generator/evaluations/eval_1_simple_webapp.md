# Evaluation 1: Simple Web App Sitemap

## Input

**docs/brief-structured.md**:
```markdown
# Brief

## Utenti
- Users: possono creare e visualizzare contenuti
- Admin: gestiscono utenti

## Funzionalità
- Autenticazione (login/register)
- Dashboard utente
- Gestione profilo
- Admin panel
```

### Invocazione
```
/sitemap-generator
```

## Expected Behavior

### Fase 1: Analisi Input
- ✅ Legge brief
- ✅ Identifica:
  - 2 ruoli: User, Admin
  - 4 aree: Auth, Dashboard, Profile, Admin
- ✅ Comunica sintesi e chiede conferma

### Fase 2: Generazione Draft
- ✅ Genera struttura:
  ```
  Pubbliche:
  - / (landing)
  - /login
  - /register
  - /forgot-password

  Autenticate (User):
  - /dashboard
  - /profile
  - /profile/edit

  Admin:
  - /admin
  - /admin/users
  ```
- ✅ Crea `docs/frontend-specs/sitemap-draft.md`
- ✅ Statistiche: 9 pagine (4 pubbliche, 3 user, 2 admin)

### Fase 3: Checkpoint
- ✅ Presenta checkpoint SITEMAP con statistiche
- ✅ Usa AskUserQuestion

### Fase 4: Finalizzazione
- ✅ Rinomina draft → finale
- ✅ Suggerisce: `/architecture-designer`

## Expected Output

**sitemap.md**:
```markdown
# Sitemap

| Route | Pagina | Auth | Descrizione |
|-------|--------|------|-------------|
| / | Landing | No | Homepage pubblica |
| /login | Login | No | Autenticazione |
| /register | Register | No | Registrazione |
| /dashboard | Dashboard | User | Home utente |
| /profile | Profile | User | Visualizza profilo |
| /admin | Admin Panel | Admin | Pannello admin |
| /admin/users | Users Management | Admin | Gestione utenti |
```

## Success Criteria
- ✅ Pagine pubbliche vs autenticate separate
- ✅ Route pattern consistenti
- ✅ Checkpoint presentato
- ✅ Statistiche accurate

## Pass/Fail
**PASS**: Struttura chiara, checkpoint, suggerimento step successivo
**FAIL**: Nessun checkpoint, route inconsistenti, no auth specificato
