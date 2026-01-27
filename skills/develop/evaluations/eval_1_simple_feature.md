# Evaluation 1: Simple Feature Implementation

## Scenario
Implementazione feature semplice "User Profile Update" con backend + frontend.

## Setup

### Input Files Simulati

**docs/architecture/tech-stack.md**:
```markdown
- Backend: Node.js + Express
- Frontend: React
- Database: PostgreSQL
```

**docs/api-specs/api-signature.md**:
```markdown
PUT /users/me
Request: { name: string, bio: string }
Response: { id: uuid, name: string, bio: string, updated_at: timestamp }
```

**docs/frontend-specs/sitemap.md**:
```markdown
- /profile - User profile page with edit form
```

**progress.yaml**:
```yaml
milestones:
  - id: M1
    name: "User Profile Update"
    status: pending
```

### Invocazione
```
/develop milestone:M1
```

## Expected Behavior

### Fase 1: Load Context
- ✅ Legge tech-stack.md, api-signature.md, sitemap.md, progress.yaml
- ✅ Identifica milestone M1
- ✅ Comunica: "1 milestone target: User Profile Update"
- ✅ Chiede conferma per procedere

### Fase 2: Verify Prerequisites
- ✅ Verifica checkpoint: architecture, api_signature esistono
- ✅ Nessun prerequisito mancante
- ✅ Procede automaticamente

### Fase 3: Plan Milestones
- ✅ Milestone M1 già esiste in progress.yaml
- ✅ Identifica tasks:
  - Backend: PUT /users/me endpoint
  - Frontend: Profile edit form
  - Tests: Unit + Integration
- ✅ Identifica parallelizzazione: PARALLELO (API signature esiste)

### Fase 4: Execute
- ✅ Determina modalità: PARALLELO
- ✅ Invoca simultaneamente:
  - Task(backend-implementer) per PUT /users/me
  - Task(frontend-implementer) per profile form
- ✅ Sync point: attende entrambi
- ✅ Invoca Task(test-writer) per tests
- ✅ Invoca Task(code-reviewer) per review
- ✅ Se review OK: procede a commit

### Fase 5: Checkpoint
- ✅ Verifica project-config.yaml per milestone_complete
- ✅ Se blocking: presenta checkpoint con metriche
- ✅ Usa AskUserQuestion per approvazione

### Fase 6: Finalize
- ✅ Commit con conventional commit message
- ✅ Aggiorna progress.yaml: M1 status = completed
- ✅ Report finale con file modificati

## Expected Output

### Files Created/Modified
- `src/routes/users.routes.ts` (backend)
- `src/services/user.service.ts` (backend)
- `src/components/ProfileForm.tsx` (frontend)
- `tests/unit/user.service.spec.ts`
- `tests/integration/users.api.spec.ts`

### progress.yaml Updated
```yaml
milestones:
  - id: M1
    name: "User Profile Update"
    status: completed
    completed_at: "2026-01-22T15:00:00"
    metrics:
      files_backend: 2
      files_frontend: 1
      files_tests: 2
      tests_passed: 8
      coverage: 85
    commits:
      - "abc123def"
```

### Git Commit
```
feat(profile): add user profile update

- Backend: PUT /users/me endpoint
- Frontend: profile edit form
- Tests: 8 unit/integration tests

Co-Authored-By: Claude Sonnet <noreply@anthropic.com>
```

## Success Criteria

- ✅ Modalità PARALLELO correttamente identificata
- ✅ Backend e Frontend invocati simultaneamente
- ✅ Tests e Review eseguiti sequenzialmente dopo codice
- ✅ Checkpoint presentato se blocking in config
- ✅ Commit creato con conventional format
- ✅ progress.yaml aggiornato correttamente
- ✅ Report finale con metriche chiare

## Edge Cases Gestiti

1. **Se backend fallisce durante parallelo**: Cancella frontend, fixa backend, riavvia entrambi
2. **Se tests falliscono**: Invoca fixer, loop max 3x
3. **Se review trova issues**: Invoca fixer, loop max 3x, re-review
4. **Se checkpoint rejected**: Salva stato, STOP, attendi intervento

## Pass/Fail Criteria

**PASS se**:
- Tutte 6 fasi completate in ordine
- Parallelizzazione usata correttamente
- Commit creato con formato corretto
- progress.yaml aggiornato

**FAIL se**:
- Fasi eseguite out-of-order
- Backend e Frontend eseguiti sequenzialmente quando potevano essere paralleli
- Commit saltato o formato errato
- progress.yaml non aggiornato
