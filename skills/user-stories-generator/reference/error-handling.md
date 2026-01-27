# Gestione Errori

## Brief non trovato
1. Cerca varianti nome (brief-structured.md, brief.md)
2. Se fallisce: Chiedi path con AskUserQuestion
3. Se path errato: Segnala e richiedi

## Brief ambiguo o incompleto
1. Identifica sezioni mancanti (ruoli, funzionalità)
2. Segnala lacune all'utente
3. Chiedi input aggiuntivo con AskUserQuestion
4. Procedi solo con informazioni sufficienti

## Modifiche richieste durante processo
**Con workflow file-based**:
1. Chiedi all'utente di modificare direttamente il file intermedio (structure, list, draft)
2. Aspetta conferma che ha finito modifiche
3. Leggi file aggiornato con Read
4. Procedi alla fase successiva

**Vantaggi**: Editing diretto più efficiente che patch incrementali via chat con 100+ stories.

## Write fallisce
1. Verifica directory esiste e permessi
2. Se directory non esiste: offri di crearla o proponi path alternativo
3. Se permessi insufficienti: suggerisci directory con write access
4. Riprova con path confermato

## Read di file intermedio fallisce
1. File potrebbe essere stato spostato o cancellato dall'utente
2. Chiedi path aggiornato
3. Se intenzionale (es: ripartire da Fase 1), conferma e ricomincia
4. Altrimenti segnala errore e suggerisci recovery

## File intermedio malformato dopo modifica utente
1. Segnala problema specifico (es: "ID duplicato US-AUTH-001")
2. Chiedi all'utente di fixare
3. Rileggi dopo fix
4. Se persistente, offri di rigenerare quella fase
