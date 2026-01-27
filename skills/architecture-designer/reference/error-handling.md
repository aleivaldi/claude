# Error Handling - Architecture Designer

## Overview

Gestione errori actionable per progettazione architetturale. Processo in 6 fasi con 4 checkpoint richiede recovery specifici per ogni scenario.

---

## Fase 1: Analisi Requisiti

### Prerequisito mancante: Sitemap non trovata

**Errore**: Sitemap non esiste in `docs/frontend-specs/sitemap.md`.

**Recovery**:
1. Cerca varianti path:
   ```
   docs/frontend-specs/sitemap-draft.md
   docs/sitemap.md
   sitemap.md
   ```

2. Se nessuna trovata:
   ```
   ❌ Prerequisito mancante: Sitemap

   La sitemap è necessaria per identificare componenti frontend
   e definire API necessarie.

   Esegui prima: /sitemap-generator

   Vuoi:
   A) Eseguire /sitemap-generator ora
   B) Specificare path alternativo sitemap
   C) Procedere senza (solo backend architecture)
   ```

3. Se C (procedere senza):
   - Salta analisi frontend
   - Focus solo su backend components
   - Documenta assunzione
   - Warning che API signature sarà incompleta

**Prevenzione**: Verificare checkpoint completati prima di invocare skill.

---

### Brief non trovato o incompleto

**Errore**: Brief manca o non ha requisiti non-funzionali.

**Recovery**:
1. Se brief non trovato:
   ```
   Brief non trovato.

   Posso procedere con requisiti minimi (MVP defaults):
   - Scala: < 1000 utenti
   - Database: PostgreSQL
   - No real-time requirements

   Oppure esegui prima: /generating-structured-brief

   Scelta: [Procedi con defaults / Genera brief]
   ```

2. Se brief incompleto (manca requisiti non-funzionali):
   ```
   Brief trovato ma manca requisiti non-funzionali.

   Domande per decisioni architetturali:

   1. Scala attesa (utenti/giorno):
      A) MVP (< 1000)
      B) Media (1000-10000)
      C) Alta (> 10000)

   2. Real-time requirements:
      A) No
      B) Parziale (notifiche push)
      C) Sì (chat, live updates)

   3. Offline support:
      A) No
      B) Read-only cache
      C) Full offline-first
   ```

**Prevenzione**: Brief strutturato dovrebbe includere sezione "Requisiti Non-Funzionali".

---

## Fase 2: Overview Componenti

### Draft genera architettura troppo complessa

**Errore**: Overview propone microservizi per MVP semplice.

**Recovery**:
1. Analizza complessità vs requisiti:
   ```
   ⚠️ Architettura proposta potrebbe essere over-engineered:

   Proposto:
   - 5 microservizi
   - Message queue (RabbitMQ)
   - Service mesh

   Brief indica: MVP con < 1000 utenti

   Suggerisco semplificare:
   - 1 backend monolitico
   - Database singolo
   - API REST semplice

   Vuoi:
   A) Semplificare (consigliato per MVP)
   B) Mantenere complessa (preparazione scaling)
   C) Livello intermedio (2-3 servizi)
   ```

**Prevenzione**: Scalare architettura a requisiti (YAGNI principle).

---

### Utente chiede tecnologia non standard

**Scenario**: Utente modifica draft chiedendo tech stack inusuale.

**Recovery**:
1. Se tecnologia sconosciuta/deprecated:
   ```
   ⚠️ Rilevata tecnologia: [Nome Tech]

   Questa tecnologia è:
   - Deprecata / Non più supportata
   - Comunità piccola
   - Scarsa documentazione

   Alternative consigliate:
   - [Alternativa 1]: [Motivo]
   - [Alternativa 2]: [Motivo]

   Vuoi:
   A) Procedere comunque (a tuo rischio)
   B) Usare alternativa consigliata
   C) Ricerca dettagliata su [Nome Tech]
   ```

**Prevenzione**: Proporre tech stack standard e battle-tested in Fase 3.

---

## Fase 3: Tech Stack

### Conflitti tecnologie proposte

**Errore**: Tech stack ha incompatibilità (es: Flutter + React Native).

**Recovery**:
1. Identifica conflitti:
   ```
   ❌ Conflitto rilevato nel tech stack:

   Frontend mobile:
   - Flutter specificato per iOS/Android
   - React Native specificato per cross-platform

   Questi sono alternativi, non complementari.

   Quale preferisci:
   A) Flutter (Dart, performance nativa, material design)
   B) React Native (JavaScript, ecosystem React, hot reload)
   C) Native (Swift + Kotlin, max performance)
   ```

**Prevenzione**: Validare compatibilità tech stack prima di presentare checkpoint.

---

### Database choice ambigua

**Errore**: Brief non specifica tipo dati, quindi database sconosciuto.

**Recovery**:
1. Analizza requisiti e proponi:
   ```
   Database non specificato. Analizzo requisiti:

   Requisiti identificati:
   - Relazioni complesse: ✅
   - Transazioni ACID: ✅
   - Dati destrutturati: ❌
   - Scale orizzontale: ❌

   Consiglio: PostgreSQL

   Alternative:
   A) PostgreSQL (ACID, relazioni, JSON support)
   B) MongoDB (NoSQL, flessibilità schema)
   C) MySQL (ACID, standard, ampio supporto)
   D) Specificare requisiti per scelta migliore
   ```

**Prevenzione**: Chiedere requisiti dati in Fase 1 se non chiari.

---

## Fase 4: Data Model

### Circular dependency entità

**Errore**: ERD generato ha dipendenze circolari.

**Recovery**:
1. Identifica ciclo:
   ```
   ⚠️ Dipendenza circolare rilevata:

   User → Order → Payment → Invoice → User

   Possibili soluzioni:
   A) Rimuovi relazione debole (Invoice -/-> User)
   B) Junction table (break cycle)
   C) Rifattorizza (User ha Invoices via Orders)
   ```

2. Proponi refactoring e rigenera ERD

**Prevenzione**: Validare DAG (directed acyclic graph) prima di finalizzare.

---

### Campo sensibile senza encryption spec

**Errore**: Data model ha campi sensibili (password, SSN) senza spec encryption.

**Recovery**:
1. Identifica campi sensibili:
   ```
   ⚠️ Campi sensibili rilevati senza encryption:

   User table:
   - password → Deve essere hashed (bcrypt)
   - ssn → Deve essere encrypted (AES-256)
   - credit_card → NON storable (usa tokenization)

   Aggiungo note encryption al data model.
   ```

2. Aggiorna data model con spec sicurezza

**Prevenzione**: Security audit automatico in Fase 4.

---

## Fase 5: User Flows

### Flow troppo complessi (> 10 step)

**Errore**: User flow ha 15+ step, indica probabile problema UX.

**Recovery**:
1. Analizza flow:
   ```
   ⚠️ Flow "[Nome]" ha 15 step.

   Best practice: Max 7 step per flow critico.

   Suggerisco:
   A) Split in sub-flows (es: Registration + Onboarding)
   B) Semplificare (rimuovere step opzionali)
   C) Mantenere (workflow complesso necessario)
   ```

**Prevenzione**: Contestare flow > 10 step prima di documentare.

---

### Flow manca error handling

**Errore**: Flow documenta happy path ma non error cases.

**Recovery**:
1. Aggiunge error cases:
   ```
   Flow "[Nome]" documenta solo happy path.

   Aggiungo error cases critici:
   - Network failure → Retry logic
   - Validation error → Show error, block proceed
   - Timeout → Fallback / Cancel option
   ```

**Prevenzione**: Template user-flows deve includere sezione Error Cases.

---

## Fase 6: Finalizzazione

### File architecture/ già popolato

**Errore**: `docs/architecture/` ha file da run precedente.

**Recovery**:
1. Chiedi strategia:
   ```
   docs/architecture/ contiene file esistenti:
   - overview.md (modificato 2 giorni fa)
   - tech-stack.md (modificato 2 giorni fa)

   Vuoi:
   A) Sovrascrivere (perdi versione precedente)
   B) Backup in architecture/_archive/[timestamp]/
   C) Versioning (overview-v2.md)
   D) Merge cambiamenti (manuale)
   ```

**Prevenzione**: Sempre backup prima di finalizzare su directory esistente.

---

### Progress.yaml update fallisce

**Errore**: Non riesco ad aggiornare progress.yaml (locked, permessi).

**Recovery**:
1. Retry con backoff

2. Se fallisce 3x:
   ```
   ❌ Impossibile aggiornare progress.yaml

   Checkpoint completati manualmente:
   - architecture_overview
   - tech_stack_choice
   - data_model
   - user_flows

   Aggiungi manualmente a progress.yaml:

   ```yaml
   checkpoints_completed:
     - name: architecture_overview
       completed_at: "[timestamp]"
   ```
   ```

**Prevenzione**: Verificare write permissions prima di tentare update.

---

## Errori Cross-Phase

### Utente cambia idea su decisione checkpoint precedente

**Scenario**: Fase 4, utente vuole cambiare database (Fase 3).

**Recovery**:
1. Valuta impatto:
   ```
   Vuoi cambiare database da PostgreSQL a MongoDB.

   Impatto:
   - Data model deve essere ridisegnato (no relations)
   - Tech stack checkpoint da riaprire
   - Possibile impatto su user flows (query patterns)

   Opzioni:
   A) Torna a Fase 3 e riprendi da lì
   B) Procedi per ora, annota come TODO
   C) Crea architettura alternativa (multi-DB)
   ```

**Prevenzione**: Checkpoint chiari che modifiche richiedono re-approval precedenti.

---

### Timeout attesa checkpoint approval

**Scenario**: Checkpoint presentato ma nessuna risposta utente dopo 5 minuti.

**Recovery**:
1. Reminder:
   ```
   In attesa approvazione checkpoint: [NOME]

   Puoi:
   - Approvare: "approva" / "S"
   - Modificare: Edita il file draft e scrivi "fatto"
   - Rigenerare: "rigenera"

   File draft: docs/architecture/[nome]-draft.md
   ```

2. Se nessuna risposta dopo 15 min:
   ```
   Nessuna risposta.

   Salvo stato corrente e fermo processo.
   Riprendi con: /architecture-designer resume
   ```

**Prevenzione**: Domande chiare, file path evidenti, opzioni esplicite.

---

## Best Practices Error Handling

1. **Validate prerequisites**: Mai assumere, sempre verificare checkpoint precedenti

2. **Provide alternatives**: Ogni errore ha 2-3 recovery options

3. **Preserve decisions**: Backup checkpoint approvati prima di modificare

4. **Graceful degradation**: Se componente manca, procedi con subset (documenta gap)

5. **Security defaults**: Per decisioni sicurezza, default conservativo (strict)

6. **Document assumptions**: Quando procedi senza info, documenta chiaramente assunzioni
