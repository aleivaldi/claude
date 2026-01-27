# Evaluation 1: Authentication Feature Stories

## Input

**brief-structured.md**:
```markdown
## Funzionalità Primarie
1. Autenticazione utente
   - Login con email/password
   - Registrazione
   - Password reset

## Utenti
- User: può accedere alla piattaforma
```

### Invocazione
```
/user-stories-generator
```

## Expected Behavior

### Fase 1: Analisi Iniziale
- ✅ Legge brief
- ✅ Identifica: 1 ruolo (User), 1 area (AUTH)
- ✅ Genera `user-stories-structure.md`
- ✅ Chiede conferma

### Fase 2: Granularità
- ✅ Propone Feature level (3-5 stories)
- ✅ Utente conferma

### Fase 3: Lista Titoli
- ✅ Genera IDs:
  ```
  US-AUTH-001: User login con email/password
  US-AUTH-002: User registrazione nuovo account
  US-AUTH-003: User password reset
  US-AUTH-004: User logout
  US-AUTH-005: User remember me
  ```
- ✅ Crea `user-stories-list.md`
- ✅ Chiede conferma

### Fase 4: Edge Cases
- ✅ Aggiunge:
  ```
  US-AUTH-006: Gestione login con credenziali errate
  US-AUTH-007: Account già esistente durante registrazione
  US-AUTH-008: Email non trovata durante reset
  ```

### Fase 5: Espansione
- ✅ Espande ogni story:
  ```markdown
  ## US-AUTH-001: User login con email/password

  Come User, voglio fare login con email e password per accedere alla piattaforma.

  ### Acceptance Criteria
  - Quando inserisco email valida e password corretta, allora vengo autenticato
  - Quando inserisco credenziali errate, allora vedo messaggio errore
  - Quando sono autenticato, allora sono rediretto a dashboard

  ### Priorità
  Must Have (P0)

  ### Relazioni
  REQUIRES: US-AUTH-006 (error handling)
  ```
- ✅ Crea `user-stories-draft.md`

### Fase 6: Validazione
- ✅ Mostra statistiche: 8 stories (5 Must, 3 Should)
- ✅ Chiede conferma

### Fase 7: Output
- ✅ Genera `user-stories-authentication.md` (single file < 50 stories)
- ✅ Include summary + tutte stories espanse

## Expected Output

**user-stories-authentication.md** structure:
```markdown
# User Stories - Authentication

## Summary
- Total: 8 stories
- Must Have: 5
- Should Have: 3

## Area: Authentication

### US-AUTH-001: User login
[Full story espansa]

### US-AUTH-002: User registrazione
[Full story espansa]

[etc...]
```

## Success Criteria
- ✅ ID format corretto (US-AREA-NUM)
- ✅ Acceptance criteria "Quando..., allora..."
- ✅ Priorità classificata
- ✅ Relazioni tra stories
- ✅ Edge cases inclusi

## Pass/Fail
**PASS**: Format consistente, AC verificabili, priorità chiare
**FAIL**: ID errati, AC vaghi, no priorità, edge cases mancanti
