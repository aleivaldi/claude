# Evaluation 2: Missing Prerequisites

## Scenario
Utente invoca `/develop` ma manca API signature (prerequisito bloccante).

## Setup

### Input Files Simulati

**docs/architecture/tech-stack.md**: Esiste

**docs/frontend-specs/sitemap.md**: Esiste

**docs/api-specs/api-signature.md**: ❌ NON ESISTE

**progress.yaml**:
```yaml
milestones:
  - id: M1
    name: "User Authentication"
    status: pending
```

### Invocazione
```
/develop milestone:M1
```

## Expected Behavior

### Fase 1: Load Context
- ✅ Legge config e progress.yaml
- ✅ Identifica milestone M1
- ✅ Chiede conferma

### Fase 2: Verify Prerequisites
- ✅ Verifica checkpoint bloccanti
- ✅ Identifica: `api_signature` mancante
- ❌ **STOP IMMEDIATO**
- ✅ Comunica:
  ```
  Prerequisiti mancanti:

  - [ ] api_signature - docs/api-specs/api-signature.md non trovato

  Esegui prima:
  /api-signature-generator

  Poi ri-esegui: /develop
  ```

### Fasi 3-6
- ❌ NON ESEGUITE (STOP in Fase 2)

## Expected Output

### Messaggio Utente
```
⚠️ Prerequisiti mancanti

Checkpoint richiesti:
- [x] brief
- [x] sitemap
- [x] architecture_overview
- [x] tech_stack_choice
- [x] data_model
- [ ] api_signature ← MANCANTE

File non trovato: docs/api-specs/api-signature.md

Per procedere:
1. Esegui /api-signature-generator
2. Approva API signature checkpoint
3. Ri-esegui /develop

STOP - Non posso procedere senza prerequisiti.
```

### Files Created/Modified
- Nessuno (STOP prima di implementazione)

### progress.yaml
- Non modificato

### Git Commits
- Nessuno

## Success Criteria

- ✅ STOP in Fase 2 (non procede a Fase 3)
- ✅ Messaggio chiaro su COSA manca
- ✅ Suggerimento skill da eseguire (/api-signature-generator)
- ✅ Nessun file modificato
- ✅ Nessun commit creato

## Edge Cases Gestiti

1. **Multipli prerequisiti mancanti**: Lista tutti, suggerisce ordine esecuzione
2. **Prerequisito parziale** (file esiste ma incompleto): Segnala e sugge cleanup
3. **User insiste di procedere**: Chiede conferma esplicita con warning conseguenze

## Pass/Fail Criteria

**PASS se**:
- STOP immediato in Fase 2
- Messaggio prerequisiti mancanti chiaro
- Skill suggerita corretta
- Nessuna modifica a file o progress.yaml

**FAIL se**:
- Procede oltre Fase 2 senza prerequisiti
- Messaggio vago o incompleto
- Crea file/commit senza prerequisiti
- Non suggerisce skill necessaria
