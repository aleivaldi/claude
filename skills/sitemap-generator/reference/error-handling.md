# Error Handling - Sitemap Generator

## Overview

Gestione errori actionable per ogni fase del processo. Ogni errore ha procedure di recovery specifiche.

---

## Fase 1: Analisi Input

### Brief non trovato

**Errore**: Nessun file brief trovato in path standard.

**Recovery**:
1. Chiedi path esplicito con AskUserQuestion:
   ```
   Brief non trovato in:
   - docs/user-stories.md
   - docs/brief-structured.md
   - brief.md

   Specifica path del brief: [input utente]
   ```

2. Se path fornito, leggi con Read e procedi

3. Se ancora non trovato:
   ```
   Brief non trovato in [path].

   Opzioni:
   A) Esegui /generating-structured-brief prima
   B) Crea manualmente brief.md e riprova
   C) Procedi con informazioni minimali (chiedo interattivamente)

   Scelta: [A/B/C]
   ```

**Prevenzione**: Sempre cercare in path multipli prima di chiedere.

---

### Brief incompleto o malformato

**Errore**: Brief esiste ma manca sezioni critiche.

**Sintomi**:
- Nessun ruolo utente identificabile
- Nessuna area funzionale chiara
- Nessuna menzione di applicazioni/frontend

**Recovery**:
1. Identifica sezioni presenti:
   ```
   Brief trovato ma incompleto:
   ✅ Problema definito
   ✅ Obiettivi chiari
   ❌ Ruoli utente non specificati
   ❌ Funzionalità mancanti
   ```

2. Chiedi informazioni mancanti con AskUserQuestion:
   ```
   Per generare sitemap servono:

   1. Quali ruoli/utenti? (es: Admin, User, Guest)
   2. Quali aree funzionali? (es: Auth, Dashboard, Settings)
   3. Che tipo di applicazione? (Web, Mobile, Admin Panel)
   ```

3. Integra risposte e procedi

**Prevenzione**: Validare brief prima di Fase 2.

---

## Fase 2: Generazione Draft

### Write fallisce (directory non esiste)

**Errore**: `docs/frontend-specs/` non esiste.

**Recovery**:
1. Crea directory automaticamente:
   ```bash
   mkdir -p docs/frontend-specs
   ```

2. Retry Write

3. Se fallisce ancora, path alternativo:
   ```
   Impossibile creare docs/frontend-specs/.

   Posso salvare in:
   A) Directory corrente (sitemap-draft.md)
   B) Path custom specificato da te

   Scelta: [A/B]
   ```

**Prevenzione**: Sempre verificare/creare directory prima di Write.

---

### Draft generato troppo piccolo

**Errore**: Draft ha < 5 pagine (probabile brief insufficiente).

**Recovery**:
1. Mostra warning:
   ```
   ⚠️ Sitemap generata ha solo [N] pagine.
   Progetti tipici hanno 10-30 pagine.

   Possibili cause:
   - Brief troppo vago
   - Aree funzionali non esplorate
   - Dimenticato app secondarie (admin, mobile)
   ```

2. Chiedi conferma con AskUserQuestion:
   ```
   Vuoi:
   A) Procedere comunque (MVP minimo)
   B) Ampliare brief e rigenerare
   C) Aggiungere pagine manualmente al draft
   ```

**Prevenzione**: Analizzare complessità brief in Fase 1.

---

## Fase 3: Checkpoint

### Utente richiede modifiche dopo aver visto draft

**Scenario**: Utente vuole cambiare struttura dopo generazione.

**Recovery**:
1. Chiedi tipo modifica:
   ```
   Che tipo di modifica?
   A) Aggiungere pagine/sezioni
   B) Rimuovere pagine
   C) Cambiare gerarchia
   D) Cambiare route naming
   E) Rigenerare completamente
   ```

2. Per A-D: Guida modifica diretta file:
   ```
   Modifica direttamente docs/frontend-specs/sitemap-draft.md

   Puoi:
   - Aggiungere righe nelle tabelle
   - Cambiare nomi route
   - Modificare gerarchia ASCII

   Quando finito, scrivi "fatto" e rileggo.
   ```

3. Per E: Torna a Fase 2 con nuovo input

4. Ri-presenta checkpoint dopo modifiche

**Prevenzione**: Draft chiaro e ben commentato facilita modifiche.

---

### Utente modifica draft in modo che rompe formato

**Errore**: Draft modificato ha formato malformato (tabelle rotte, sintassi errata).

**Recovery**:
1. Leggi draft e valida formato

2. Se errori trovati, mostra:
   ```
   ⚠️ Problemi rilevati nel draft modificato:
   - Riga [N]: Tabella manca colonna [X]
   - Riga [M]: Route non valida (spazi, caratteri speciali)

   Posso:
   A) Correggere automaticamente
   B) Mostrarti cosa correggere
   C) Rigenerare da zero
   ```

3. Applica correzione e ri-presenta

**Prevenzione**: Aggiungere commenti nel draft su formato atteso.

---

## Fase 4: Finalizzazione

### File finale già esiste

**Errore**: `docs/frontend-specs/sitemap.md` esiste già.

**Recovery**:
1. Chiedi con AskUserQuestion:
   ```
   sitemap.md esiste già (versione precedente).

   Vuoi:
   A) Sovrascrivere (perdi vecchia versione)
   B) Backup vecchia in _archive/ e crea nuova
   C) Versioning (sitemap-v2.md)

   Scelta: [A/B/C]
   ```

2. Esegui azione scelta:
   - A: Write sovrascrive
   - B: `mv sitemap.md _archive/sitemap-[timestamp].md` poi Write
   - C: Write in sitemap-v2.md

**Prevenzione**: Sempre backup prima di sovrascrivere deliverable critici.

---

### progress.yaml non esiste

**Errore**: Tentativo aggiornamento progress.yaml ma file non esiste.

**Recovery**:
1. Crea progress.yaml con template minimo:
   ```yaml
   project_name: [da brief]
   checkpoints_completed:
     - name: sitemap
       completed_at: "[timestamp]"
       approved_by: user
   ```

2. Notifica creazione:
   ```
   progress.yaml non esisteva, creato automaticamente.
   Checkpoint sitemap registrato.
   ```

**Prevenzione**: Verificare esistenza prima di Edit, usare Write se non esiste.

---

## Errori Generici

### Read fallisce su file appena creato

**Errore**: Write sembra successo ma Read successivo fallisce.

**Cause possibili**:
- Permessi filesystem
- Disk full
- Path relativo vs assoluto

**Recovery**:
1. Verifica file esiste con bash:
   ```bash
   ls -lh docs/frontend-specs/sitemap-draft.md
   ```

2. Se esiste ma Read fallisce, usa bash cat come fallback:
   ```bash
   cat docs/frontend-specs/sitemap-draft.md
   ```

3. Se non esiste, notifica:
   ```
   ❌ Write riportava successo ma file non creato.
   Possibile problema filesystem.

   Provo path alternativo: ./sitemap-draft.md
   ```

---

### AskUserQuestion non riceve risposta

**Scenario**: Timeout o utente ignora domanda.

**Recovery**:
1. Dopo 2 minuti, remind:
   ```
   In attesa di risposta per checkpoint SITEMAP.

   Puoi:
   - Approvare: scrivi "S" o "approva"
   - Modificare: scrivi "M" o path file modificato
   - Rigenerare: scrivi "R"
   ```

2. Se ancora no risposta, assumere default conservativo:
   ```
   Nessuna risposta ricevuta.
   Assumo: Modifica richiesta (conservativo).

   Attendo modifica di sitemap-draft.md.
   Scrivi "fatto" quando pronto.
   ```

**Prevenzione**: Domande chiare con opzioni evidenti.

---

## Best Practices Error Handling

1. **Always fallback path**: Mai bloccarsi completamente, sempre proporre alternativa

2. **Specific error messages**: Non "errore generico", ma "Brief manca sezione Ruoli Utente"

3. **Actionable recovery**: Ogni errore ha 2+ opzioni recovery chiare

4. **Preserve work**: Mai perdere lavoro fatto (backup, draft files)

5. **User agency**: Lasciare sempre scelta all'utente, non imporre recovery automatico

6. **Graceful degradation**: Se qualcosa manca, procedere con subset funzionalità quando possibile
