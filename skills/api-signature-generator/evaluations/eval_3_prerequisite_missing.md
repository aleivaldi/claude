# Evaluation 3: Missing Architecture Prerequisite

## Input

**docs/frontend-specs/sitemap.md**: Esiste

**docs/architecture/**: ❌ NON ESISTE

## Expected Behavior

### Fase 1: Analisi Prerequisiti
- ✅ Cerca docs/architecture/tech-stack.md
- ❌ Non trovato
- ✅ STOP immediato
- ✅ Messaggio:
  ```
  Architettura non trovata. È un prerequisito.
  L'architettura definisce i protocolli (REST/WebSocket/GraphQL).

  Esegui prima: /architecture-designer
  ```

### Fasi 2-5
- ❌ NON ESEGUITE

## Success Criteria
- ✅ STOP in Fase 1
- ✅ Messaggio chiaro su prerequisito
- ✅ Suggerisce /architecture-designer
- ✅ Nessun file creato

## Pass/Fail
**PASS**: STOP immediato, messaggio chiaro, skill suggerita
**FAIL**: Procede senza architettura, crea file draft, genera API senza conoscere protocolli
