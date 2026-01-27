# ⚡ Dynamic Parallelism Upgrade

## Cosa è Cambiato

### Prima (Parallelismo Statico)
```
/develop → Decisione fissa:
  - Backend Agent + Frontend Agent (2 agenti max)
  - Oppure sequenziale

❌ Limitazione: Solo 2 agenti, nessuna decomposizione task
```

### Ora (Parallelismo Dinamico)
```
/develop → Decomposizione intelligente:
  - Milestone → Task atomici indipendenti
  - Dependency graph → Waves di esecuzione
  - N agenti in parallelo per wave (4, 6, 8+ agenti)

✅ Scalabile: Multipli dev lavorano su task diversi contemporaneamente
✅ Test in parallelo: Test-writer scrive test mentre implementer scrive codice
✅ Esecuzione test dopo: Run tutti i test quando tutto il codice è pronto
```

---

## Architettura Nuova

### Workflow Completo

```
┌─────────────────────────────────────────────────────────┐
│ MILESTONE: User Management + Payment System             │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│ TASK DECOMPOSITION                                      │
│ - Analizza API signature                                │
│ - Identifica 6 task indipendenti:                       │
│   1. auth-service (backend)                             │
│   2. payment-service (backend)                          │
│   3. notification-service (backend)                     │
│   4. user-profile (backend - dipende da auth)           │
│   5. login-ui (frontend)                                │
│   6. payment-ui (frontend)                              │
│                                                          │
│ - Dependency graph:                                     │
│   Wave 1: [1, 2, 3, 5, 6] (nessuna dipendenza)         │
│   Wave 2: [4] (dipende da auth)                         │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│ WAVE 1 EXECUTION (10 agenti in parallelo)               │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ Task 1: auth-service                                    │
│   Agent 1: backend-implementer (src/services/auth.ts)   │
│   Agent 2: test-writer (tests/auth.test.ts)            │
│             ⏱️ Lavorano insieme                          │
│                                                          │
│ Task 2: payment-service                                 │
│   Agent 3: backend-implementer (src/services/payment.ts)│
│   Agent 4: test-writer (tests/payment.test.ts)         │
│             ⏱️ Lavorano insieme                          │
│                                                          │
│ Task 3: notification-service                            │
│   Agent 5: backend-implementer (src/services/notif.ts)  │
│   Agent 6: test-writer (tests/notif.test.ts)           │
│             ⏱️ Lavorano insieme                          │
│                                                          │
│ Task 5: login-ui                                        │
│   Agent 7: frontend-implementer (Login.tsx)             │
│   Agent 8: test-writer (Login.test.tsx)                │
│             ⏱️ Lavorano insieme                          │
│                                                          │
│ Task 6: payment-ui                                      │
│   Agent 9: frontend-implementer (PaymentForm.tsx)       │
│   Agent 10: test-writer (PaymentForm.test.tsx)         │
│             ⏱️ Lavorano insieme                          │
│                                                          │
│ ⏳ Attendi completamento tutti gli agenti...            │
│ ✅ Wave 1 completata in 2 ore                            │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│ WAVE 2 EXECUTION (2 agenti in parallelo)                │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ Task 4: user-profile (dipendeva da auth, ora pronto)    │
│   Agent 11: backend-implementer (src/services/user.ts)  │
│   Agent 12: test-writer (tests/user.test.ts)           │
│             ⏱️ Lavorano insieme                          │
│                                                          │
│ ✅ Wave 2 completata in 30 min                           │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│ TEST EXECUTION (DOPO tutto il codice)                   │
├─────────────────────────────────────────────────────────┤
│ npm run test                                            │
│   ✅ tests/auth.test.ts (15 tests)                       │
│   ✅ tests/payment.test.ts (12 tests)                    │
│   ✅ tests/notif.test.ts (8 tests)                       │
│   ✅ tests/user.test.ts (10 tests)                       │
│   ✅ Login.test.tsx (7 tests)                            │
│   ✅ PaymentForm.test.tsx (5 tests)                      │
│                                                          │
│ Coverage: 89%                                           │
│ ✅ All tests passed                                      │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│ CODE REVIEW + FIX                                       │
├─────────────────────────────────────────────────────────┤
│ code-reviewer: Analizza 6 moduli                        │
│   ⚠️ Trovati 3 problemi (2 medium, 1 low)               │
│                                                          │
│ fixer: Auto-correzione...                               │
│   ✅ Corretti 3/3 problemi                               │
│                                                          │
│ ✅ Milestone completa in 2.5 ore!                        │
│    (Invece di 12 ore sequenziali)                       │
└─────────────────────────────────────────────────────────┘
```

---

## Esempio Concreto: Il Tuo Caso

Hai **mockup + sitemap + specifiche**. Partiamo da architettura:

### Step 1: Setup (come prima)
```bash
cd ~/development/MioProgetto
/project-setup
/architecture-designer
/api-signature-generator
```

### Step 2: Implementazione (NUOVO - parallelo dinamico)

```bash
/develop all
```

**Output Claude**:
```
📋 Analyzing milestone...

✅ Decomposed milestone into 8 tasks:

Wave 1 (6 tasks - can run in parallel):
  Backend:
    • auth-service: POST /auth/login, POST /auth/register
    • user-service: GET/PUT /users/:id
    • order-service: POST /orders, GET /orders

  Frontend:
    • login-page: LoginPage.tsx + LoginForm.tsx
    • dashboard-page: Dashboard.tsx
    • orders-page: OrderList.tsx + OrderDetail.tsx

Wave 2 (2 tasks - depend on auth):
  Backend:
    • admin-service: Admin endpoints (requires auth middleware)

  Frontend:
    • admin-panel: AdminPanel.tsx (requires auth context)

Total: 8 tasks → 16 agents (8 implementers + 8 test-writers)

Starting parallel execution...

🌊 Wave 1: Spawning 12 agents for 6 tasks...
   ⏱️ All agents working in parallel...

   [Progress updates every 10 min]

   10 min: auth-service 40% done, test-writer at 30%
   20 min: login-page 60% done, test-writer at 50%
   30 min: order-service completed ✅
   ...

   ✅ Wave 1 completed in 2 hours
      - 6 modules implemented
      - 6 test suites written
      - 0 compilation errors

🌊 Wave 2: Spawning 4 agents for 2 tasks...
   ⏱️ Working on admin features...

   ✅ Wave 2 completed in 45 min

🧪 Running all test suites...
   npm run test

   ✅ 73 tests passed
   ❌ 2 tests failed (order-service integration)
   📊 Coverage: 87%

🔧 Auto-fixing test failures...
   fixer: Analyzing failures...
   fixer: Issue: Missing mock for payment gateway
   fixer: Applied fix

   Re-running tests...
   ✅ 75/75 tests passed

👀 Code review...
   reviewer: Analyzing 8 modules...
   ⚠️ Found 4 issues:
      - [MEDIUM] auth-service: Add rate limiting
      - [MEDIUM] user-service: Validate email format
      - [LOW] dashboard: Extract repeated logic
      - [LOW] orders: Improve error messages

   fixer: Applying fixes...
   ✅ Fixed 4/4 issues

✅ Milestone completed in 3 hours!

   Summary:
   - 8 modules implemented
   - 75 tests written and passing
   - 87% coverage
   - All issues resolved

   Would have taken 16 hours sequentially
   Saved: 13 hours (81% faster)

Next: /deploy-helper staging
```

---

## Benefici

### 1. **Velocità: 4-10x più veloce**
```
Progetto piccolo (10 moduli):
  - Sequenziale: 20 ore
  - Dinamico:     4 ore
  - Saving:       16 ore (80%)

Progetto medio (30 moduli):
  - Sequenziale: 60 ore
  - Dinamico:    10 ore
  - Saving:      50 ore (83%)
```

### 2. **Scalabilità: N agenti contemporanei**
- Non più limitato a 2 agenti (backend+frontend)
- Limiti solo hardware (configurabile: 4, 8, 16 agenti)
- Wave execution: gestione automatica dipendenze

### 3. **Test in Parallelo Durante Sviluppo**
- Test-writer scrive test mentre implementer scrive codice
- Test pronti quando codice è pronto
- No attesa sequenziale

### 4. **Esecuzione Test Dopo (Come richiesto)**
- Tutti i test eseguiti DOPO che tutto il codice è scritto
- Run completo con coverage
- Integration tests con tutti i moduli presenti

### 5. **Microservizi-Ready**
```
Milestone: Payment System con 3 microservizi

Wave 1 (tutti indipendenti):
  • payment-gateway-service
  • billing-service
  • invoice-service
  • payment-ui

= 8 agenti in parallelo
```

---

## Configurazione

### Limite Hardware (opzionale)

```yaml
# project-config.yaml
execution:
  max_concurrent_agents: 8  # Default: 8
  # Aumenta se hai CPU/RAM potenti
  # Diminuisci se sistema lento
```

### Task Granularity

Sistema decompone automaticamente milestone in task ottimali:
- **1 task = 1 servizio/modulo completo**
- Non troppo fine (overhead coordinamento)
- Non troppo grosso (perde parallelismo)

---

## File Aggiornati

### Nuovi File Creati
```
.claude/skills/develop/
├── dynamic-parallelization.md       ← Architettura nuova
├── task-decomposition-logic.md      ← Algoritmo decomposizione
└── parallelization-logic.md         ← OLD (ora deprecated)
```

### File Aggiornati
```
.claude/skills/develop/SKILL.md      ← Aggiornato con riferimenti nuovi
```

---

## Come Usare

### Opzione 1: Automatico (consigliato)
```bash
/develop all
# Claude decompone automaticamente in task e esegue in parallelo
```

### Opzione 2: Scope Specifico
```bash
/develop backend        # Solo backend (comunque decomposto in task)
/develop feature:auth   # Solo feature auth (decomposto in task)
```

### Opzione 3: Con Limite Agenti
```bash
# Modifica project-config.yaml prima
execution:
  max_concurrent_agents: 4  # Più conservativo

/develop all
```

---

## Metriche Attese

### Progetto Piccolo (10-15 task)
- **Waves**: 2-3
- **Agenti picco**: 8-12
- **Tempo**: 3-5 ore
- **Saving vs sequenziale**: 75-80%

### Progetto Medio (30-40 task)
- **Waves**: 3-5
- **Agenti picco**: 12-16
- **Tempo**: 8-12 ore
- **Saving vs sequenziale**: 80-85%

### Progetto Grande (100+ task)
- **Waves**: 5-10
- **Agenti picco**: 16+
- **Tempo**: 20-30 ore
- **Saving vs sequenziale**: 85-90%

---

## Monitoring

Durante esecuzione vedrai:

```
🌊 Wave 2/4: 6 tasks in parallel (12 agents)

Progress:
  [████████░░] auth-service-impl      80%
  [██████████] auth-test-writer       100% ✅
  [█████░░░░░] payment-impl           50%
  [████░░░░░░] payment-test-writer    40%
  [███████░░░] notification-impl      70%
  [██████░░░░] notification-test      60%
  ...

Estimated time remaining: 25 minutes
```

---

## Prossimi Passi

1. **Testa il sistema**:
   ```bash
   /develop milestone:1
   ```

2. **Monitora performance**: Vedi quanti agenti lavorano in parallelo

3. **Ottimizza se necessario**: Modifica `max_concurrent_agents` in base al tuo hardware

4. **Scala up**: Per progetti grandi, aumenta limite agenti

---

## Domande Frequenti

**Q: Posso ancora usare backend+frontend sequenziale?**
A: Sì, il sistema rileva automaticamente se ci sono dipendenze strette e adatta l'esecuzione.

**Q: Come gestisce conflitti su stesso file?**
A: Conflict detection automatico. Task che scrivono stesso file vanno in wave diverse.

**Q: Posso limitare agenti per non sovraccaricare sistema?**
A: Sì, `max_concurrent_agents` in project-config.yaml.

**Q: Test vengono eseguiti dopo tutto il codice?**
A: Sì! Test-writer scrive test in parallelo, ma `npm run test` esegue DOPO tutte le wave.

**Q: Funziona con microservizi?**
A: Perfetto per microservizi! Ogni microservizio = task indipendente.

---

## Pronto per Iniziare?

```bash
cd ~/development/MioProgetto
/develop all
```

Il framework farà il resto! 🚀
