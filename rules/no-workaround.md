# No Workaround Policy

## Principio

Ogni soluzione deve essere production-ready. Zero hack, zero "poi lo sistemo".

## Cosa è un workaround

- Codice che aggira un problema invece di risolverlo
- TODO/FIXME/HACK lasciati nel codice
- Hardcoded values che dovrebbero essere configurabili
- Try/catch vuoti che silenziano errori
- Mock/stub lasciati in codice di produzione
- `any` in TypeScript per evitare di tipizzare
- Timeout arbitrari per "aspettare che funzioni"
- Retry infiniti senza backoff

## Cosa fare quando sei bloccato

1. **3 tentativi max** sullo stesso problema
2. **Documenta** cosa hai provato e perché non funziona
3. **Fermati** e segnala:
   ```
   openclaw system event --text "Bloccato: {problema}. Provato: {tentativi}. Serve: {cosa}" --mode now
   ```
4. **Non inventare** soluzioni creative che non reggeranno in produzione

## Eccezioni documentate

Se un compromesso tecnico è necessario (es. limitazione libreria):
1. Crea un ADR (Architecture Decision Record)
2. Documenta: problema, soluzione scelta, perché, piano per risolvere
3. Crea issue GitHub per tracking

## Test di verifica

Prima di committare, grep per:
```bash
grep -rn "TODO\|FIXME\|HACK\|WORKAROUND\|TEMPORARY\|XXX" src/
```
Se trova qualcosa → non committare finché non risolto o documentato come ADR.
