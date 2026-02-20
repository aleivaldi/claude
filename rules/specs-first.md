# Specs-First Policy

## Principio

Le specifiche sono la **fonte di verità assoluta**. Il codice segue le specs, mai il contrario.

## Regole

### Prima di implementare

1. **Leggi** la spec rilevante (api-signature.md, architecture/*.md, frontend-specs/*.md)
2. **Verifica** che il task richiesto sia coerente con le specs
3. **Se contraddice**: FERMATI, segnala la contraddizione, non implementare

### Durante l'implementazione

1. **Segui la spec** alla lettera — nomi endpoint, request/response schema, flussi
2. **Se scopri che la spec è incompleta**: aggiorna la spec PRIMA, poi implementa
3. **Se ricevi istruzioni in chat** che contraddicono la spec: aggiorna la spec PRIMA

### Dopo l'implementazione

1. **Verifica** che codice e spec siano allineati
2. **Se hai modificato comportamento**: la spec DEVE essere aggiornata nello stesso commit o PR

## Anti-pattern

❌ "Lo faccio così perché funziona meglio" (senza aggiornare spec)
❌ "La spec dice X ma in chat mi hanno detto Y" (senza aggiornare spec)
❌ "Aggiungo questo endpoint non previsto" (senza aggiornare api-signature)
❌ Documentazione che descrive comportamento diverso dal codice

## Eccezioni

Nessuna. Se serve deviare dalla spec, la spec si aggiorna prima.
