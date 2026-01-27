---
name: user-stories-generator
description: Genera user stories complete e tracciabili partendo da un project brief strutturato. Processo interattivo in 7 fasi che guida l'utente dall'analisi iniziale alla validazione finale, con conferme a ogni step. Produce documentazione in formato Markdown organizzata per area funzionale, ruoli e priorità. Supporta sia output singolo che multi-file per progetti complessi. Adatta automaticamente la lingua all'input ricevuto (italiano/inglese).
---

# User Stories Generator

## Il Tuo Compito

Trasformare project brief strutturati in user stories complete, tracciabili e condivisibili con clienti e partner per validazione. Guidare l'utente attraverso un processo interattivo a 7 fasi, chiedendo conferma a ogni step critico prima di procedere.

**Focus**: User stories dal punto di vista dell'utente finale (COSA vuole fare, PERCHÉ), NON specifiche tecniche o implementazione.

**Lingua**: Adatta automaticamente alla lingua del project brief - se italiano, tutto output in italiano; se inglese, tutto in inglese.

---

## Workflow: 7 Fasi Interattive con File Intermedi

Il processo è **sequenziale**, **interattivo** e **file-based**. A ogni fase critica genera file intermedi che l'utente può modificare direttamente prima di procedere.

### Overview Fasi e File Generati

1. **Analisi Iniziale** → Genera `user-stories-structure.md` (ruoli, aree, apps)
2. **Definizione Granularità** → Legge structure, chiede livello dettaglio
3. **Generazione Lista Stories** → Genera `user-stories-list.md` (SOLO titoli)
4. **Gestione Edge Cases** → Legge list, aggiorna con edge cases
5. **Espansione Stories Complete** → Genera `user-stories-draft.md` (complete)
6. **Validazione Finale** → Legge draft, mostra summary
7. **Generazione Output** → Genera file finale/i da draft confermato

**File intermedi permettono**:
- Modificare struttura prima di generare stories
- Aggiungere/rimuovere stories nella lista
- Commentare nel file per guidare espansione
- Iterare su draft prima di finalizzare

**Consulta `process-phases.md` per dettaglio completo di ogni fase.**

---

## Input Atteso

**File richiesto**: Project brief strutturato (generato da skill `generating-structured-brief`)

**Sezioni utili nel brief**:
- Problema e obiettivi
- Utenti target / Ruoli
- Funzionalità primarie e secondarie
- Workflow utente
- Applicazioni/frontend menzionati
- Scope MVP vs Nice-to-have

**Come ottenere il brief**:
1. Chiedi all'utente path del file brief
2. Se non specificato, cerca in directory corrente: `brief-structured.md` o `brief.md`
3. Se non trovato, chiedi conferma location

---

## Dettaglio Fasi

**Consulta `process-phases.md` per dettagli completi di tutte le 7 fasi.**

**Summary rapido**:

- **Fase 1**: Analisi Iniziale → `user-stories-structure.md` (ruoli, aree, apps)
- **Fase 2**: Definizione Granularità → Scelta livello dettaglio (Epic/Feature/Task)
- **Fase 3**: Lista Titoli → `user-stories-list.md` (IDs formato US-[AREA]-[NUM])
- **Fase 4**: Edge Cases → Aggiorna list.md con edge cases
- **Fase 5**: Espansione → `user-stories-draft.md` (stories complete)
- **Fase 6**: Validazione → Summary statistiche, feedback finale
- **Fase 7**: Output Finale → File Markdown finali da draft confermato

---

## Best Practices Stories

Stories SMART: Specific, Measurable, Achievable, Relevant, Time-bound.

**Focus**: Valore utente (non tecnologia), AC verificabili, stories indipendenti.

**Consulta `defaults.md` per regole complete.**

---

## Uso Tool

**Consulta `reference/tool-usage-patterns.md` per sequenze dettagliate.**

**Pattern**: File-based workflow (Read → Write/Edit → ATTENDI conferma).

---

## Gestione Errori

**Consulta `reference/error-handling.md` per procedure complete.**

**Scenari**: Brief non trovato, brief incompleto, modifiche durante processo, file malformati.

---

## Output Finale

**Deliverable Principali**:
- 1+ file Markdown finali con user stories strutturate
- Organizzazione per area funzionale
- IDs tracciabili e univoci
- Priorità chiare
- Acceptance criteria verificabili
- Summary con statistiche

**Naming convention output finale**:
- `user-stories-[nome-progetto].md` (single file)
- `user-stories-[nome-progetto]-overview.md` + `user-stories-[app/area].md` (multi-file)

**File Intermedi Generati** (durante processo):
- `user-stories-structure.md` (Fase 1)
- `user-stories-list.md` (Fase 3-4)
- `user-stories-draft.md` (Fase 5-6)

**Gestione File Intermedi**:
- Mantieni in directory corrente durante processo
- Opzionalmente archivia in `_intermediate/` dopo completamento
- Utili per iterazioni future o modifiche incrementali

**Location**: Directory corrente, a meno che utente specifichi diversamente.

---

## Materiali di Riferimento

**Processo**:
- `process-phases.md` - Dettaglio completo 7 fasi con esempi ed edge cases

**Reference**:
- `reference/tool-usage-patterns.md` - Sequenze tool file-based workflow
- `reference/error-handling.md` - Gestione errori per scenario
- `defaults.md` - Valori default e assunzioni pragmatiche

**Template**:
- `templates/user-stories-single.md` - Template output single-file
- `templates/user-stories-overview.md` - Template overview multi-file
- `templates/user-stories-section.md` - Template sezioni multi-file

**Esempi**:
- `examples/example-format.md` - Esempio concreto formato stories

---

## Avvio Workflow

Quando l'utente invoca questa skill:

1. **Saluta** e spiega processo a 7 fasi
2. **Chiedi path** del project brief (o cerca automaticamente)
3. **Leggi brief** con Read
4. **Inizia Fase 1**: Analisi iniziale
5. **Procedi sequenzialmente** attraverso fasi 2-7
6. **Chiedi conferma** a ogni transizione di fase
7. **Genera output** finale

**Principio chiave**: INTERATTIVITÀ. L'utente deve guidare le scelte, tu faciliti il processo.
