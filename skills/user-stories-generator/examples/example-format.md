# User Stories - Task Manager SaaS

## Informazioni Progetto

- **Versione:** 1.0
- **Data:** 2024-01-15
- **Livello dettaglio:** Feature
- **Applicazioni:** Web App

---

## Ruoli Utente

### User
Utente registrato che può creare e gestire le proprie task, collaborare con altri utenti.

### Admin
Amministratore con accesso completo al sistema, gestione utenti e workspace.

---

## User Stories

### Autenticazione (AUTH) - 4 stories

#### Must Have

**US-AUTH-001:** Come User, voglio registrarmi con email e password per creare un account e accedere alla piattaforma

**Acceptance Criteria:**
- Quando inserisco email valida, password (min 8 caratteri) e accetto termini, allora ricevo email di conferma
- Quando confermo email tramite link, allora il mio account viene attivato
- Quando la email è già registrata, allora vedo messaggio "Email già in uso"
- E la password deve contenere almeno 1 maiuscola, 1 numero, 1 carattere speciale

**Priorità:** Must Have

---

**US-AUTH-002:** Come User/Admin, voglio fare login con credenziali per accedere alle funzionalità protette

**Acceptance Criteria:**
- Quando inserisco email e password corrette, allora vengo reindirizzato alla dashboard
- Quando inserisco credenziali errate, allora vedo messaggio "Credenziali non valide" (generico)
- Quando supero 5 tentativi falliti in 10 minuti, allora il mio account viene bloccato per 15 minuti
- E la sessione rimane attiva per 7 giorni se seleziono "Ricordami"

**Priorità:** Must Have

**Relazioni:** [REQUIRES: US-AUTH-001]

---

**US-AUTH-003:** Come User/Admin, voglio recuperare la password dimenticata per riottenere accesso senza contattare supporto

**Acceptance Criteria:**
- Quando richiedo reset inserendo email, allora ricevo link temporaneo via email (valido 1 ora)
- Quando clicco il link e imposto nuova password, allora posso fare login con nuove credenziali
- Quando il link è scaduto o già usato, allora vedo messaggio "Link non valido o scaduto"
- E ricevo notifica email quando password viene cambiata (sicurezza)

**Priorità:** Must Have

**Relazioni:** [EXTENDS: US-AUTH-002]

#### Should Have

**US-AUTH-004:** Come User/Admin, voglio fare logout per terminare la sessione in modo sicuro

**Acceptance Criteria:**
- Quando clicco logout, allora vengo reindirizzato a pagina login
- Quando provo ad accedere a pagina protetta dopo logout, allora vengo reindirizzato a login
- E tutte le sessioni attive su altri dispositivi rimangono valide (logout solo corrente device)

**Priorità:** Should Have

**Relazioni:** [REQUIRES: US-AUTH-002]

---

### Gestione Task (TASK) - 5 stories

#### Must Have

**US-TASK-001:** Come User, voglio creare una nuova task per tracciare attività da completare

**Acceptance Criteria:**
- Quando inserisco titolo (obbligatorio), descrizione (opzionale), data scadenza (opzionale), allora la task viene creata
- Quando la task è creata, allora appare nella mia lista task con stato "To Do"
- E posso assegnare priorità (Alta, Media, Bassa) e tag personalizzati

**Priorità:** Must Have

**Relazioni:** [REQUIRES: US-AUTH-002]

---

**US-TASK-002:** Come User, voglio modificare una mia task esistente per aggiornare informazioni o correggere errori

**Acceptance Criteria:**
- Quando modifico titolo, descrizione, scadenza o priorità, allora le modifiche vengono salvate immediatamente
- Quando cambio stato (To Do → In Progress → Done), allora la task si sposta nella sezione corrispondente
- E vedo timestamp "Ultima modifica: [data]" sotto la task

**Priorità:** Must Have

**Relazioni:** [REQUIRES: US-TASK-001]

---

**US-TASK-003:** Come User, voglio eliminare una mia task per rimuovere attività non più rilevanti

**Acceptance Criteria:**
- Quando clicco elimina, allora vedo conferma "Sei sicuro? Questa azione è irreversibile"
- Quando confermo, allora la task viene rimossa permanentemente dalla lista
- E le task eliminate non sono recuperabili (no soft-delete in MVP)

**Priorità:** Must Have

**Relazioni:** [REQUIRES: US-TASK-001]

---

**US-TASK-004:** Come User, voglio visualizzare lista delle mie task per avere overview delle attività

**Acceptance Criteria:**
- Quando accedo alla dashboard, allora vedo task organizzate in colonne (To Do, In Progress, Done)
- Quando una task ha scadenza oggi o passata, allora è evidenziata in rosso
- E posso filtrare per priorità, tag, data creazione o scadenza

**Priorità:** Must Have

**Relazioni:** [REQUIRES: US-AUTH-002]

#### Should Have

**US-TASK-005:** Come User, voglio cercare tra le mie task per trovare rapidamente attività specifiche

**Acceptance Criteria:**
- Quando digito nel campo ricerca, allora vedo risultati filtrati in real-time (titolo e descrizione)
- Quando nessuna task corrisponde, allora vedo messaggio "Nessuna task trovata"
- E i risultati evidenziano i termini cercati (highlight)

**Priorità:** Should Have

**Relazioni:** [REQUIRES: US-TASK-004]

---

### Gestione Utenti (ADMIN) - 2 stories

#### Must Have

**US-ADMIN-001:** Come Admin, voglio visualizzare lista di tutti gli utenti registrati per monitorare la piattaforma

**Acceptance Criteria:**
- Quando accedo a pannello admin, allora vedo tabella con email, data registrazione, stato account (attivo/bloccato)
- Quando clicco su un utente, allora vedo dettagli completi (task create, ultimo login, ecc.)
- E posso ordinare per data registrazione, ultimo accesso, numero task

**Priorità:** Must Have

**Relazioni:** [REQUIRES: US-AUTH-002]

#### Should Have

**US-ADMIN-002:** Come Admin, voglio bloccare/sbloccare account utente per gestire violazioni o problemi

**Acceptance Criteria:**
- Quando blocco un account, allora l'utente non può più fare login (vede "Account sospeso")
- Quando sblocco un account, allora l'utente può tornare a fare login normalmente
- E ricevo log di tutte le azioni di blocco/sblocco con timestamp e motivazione

**Priorità:** Should Have

**Relazioni:** [REQUIRES: US-ADMIN-001]

---

## Summary

### Totale Stories: 11

**Per Priorità:**
- Must Have: 8 (73% del totale)
- Should Have: 3 (27% del totale)
- Nice to Have: 0 (0% del totale)

**Per Area Funzionale:**
- Autenticazione (AUTH): 4 stories
- Gestione Task (TASK): 5 stories
- Gestione Utenti Admin (ADMIN): 2 stories

**Stories Multi-Ruolo:** 3 stories (US-AUTH-002, US-AUTH-003, US-AUTH-004 condivise tra User e Admin)

**Dipendenze Critiche:**
- US-TASK-001/002/003/004 tutte dipendono da US-AUTH-002 (login necessario)
- US-ADMIN-002 dipende da US-ADMIN-001 che dipende da US-AUTH-002
- Catena critica: US-AUTH-001 → US-AUTH-002 → [maggior parte funzionalità]

---

## Note Formato

**Questo esempio illustra**:
1. Nomenclatura IDs: US-[AREA]-[NUM] con zero-padding
2. Formato descrizione: "Come [ruolo], voglio [azione] per [beneficio]"
3. Acceptance Criteria: "Quando [condizione], allora [risultato]"
4. Stories multi-ruolo indicate esplicitamente (User/Admin)
5. Relazioni documentate con [REQUIRES/EXTENDS]
6. Organizzazione per area e priorità
7. Summary con statistiche chiare

**Differenze per livello dettaglio**:
- **Epic**: US-AUTH-001 sarebbe "Come User/Admin, gestire autenticazione" (1 story per tutta l'area)
- **Feature**: Come mostrato sopra (3-5 stories per area)
- **Task**: US-AUTH-001 si dividerebbe in US-AUTH-001.1 (validazione email), US-AUTH-001.2 (hashing password), US-AUTH-001.3 (invio email conferma), ecc.

---

*Documento generato da User Stories Generator*
