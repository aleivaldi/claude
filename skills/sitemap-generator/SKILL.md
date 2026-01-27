---
name: sitemap-generator
description: Genera sitemap sintetica del progetto (struttura pagine/sezioni) partendo dal brief o user stories. Processo interattivo in 4 fasi con file intermedio e checkpoint per approvazione. Output sitemap.md stand-alone per fase Architecture successiva.
---

# Sitemap Generator

## Il Tuo Compito

Trasformare il brief strutturato (o user stories) in una **sitemap sintetica** che mappa tutte le pagine/schermi dell'applicazione con gerarchia e relazioni.

**Focus**: Struttura navigazione (QUALI pagine esistono, COME sono organizzate), NON dettagli UI o implementazione.

**Output**: `docs/frontend-specs/sitemap.md` - documento checkpoint per approvazione prima di procedere con Architecture.

---

## Workflow: 4 Fasi Interattive

```
Fase 1: Analisi Input       → Legge brief, identifica aree
Fase 2: Generazione Draft   → Crea sitemap-draft.md
Fase 3: Checkpoint          → Presenta per approvazione
Fase 4: Finalizzazione      → Salva sitemap.md definitivo
```

---

## Fase 1: Analisi Input

### Obiettivo
Estrarre da brief/stories: utenti, aree funzionali, flussi principali.

### Azioni

1. **Cerca file input** (in ordine):
   ```
   docs/user-stories.md
   docs/brief-structured.md
   brief-structured.md
   brief.md
   ```

2. **Se non trovato**: Chiedi path con AskUserQuestion

3. **Leggi file** con Read tool

4. **Estrai informazioni**:
   - Ruoli utente (admin, user, guest, etc.)
   - Aree funzionali menzionate
   - Flussi utente descritti
   - Applicazioni/frontend (web, mobile, admin panel)

5. **Comunica sintesi** all'utente:
   ```
   Ho analizzato il brief. Identificato:
   - [N] ruoli: [lista ruoli]
   - [N] aree funzionali: [lista aree]
   - [N] app: [lista app/frontend]

   Procedo con generazione sitemap.
   ```

### Output
Sintesi analisi completata. Procede automaticamente a Fase 2.

---

## Fase 2: Generazione Draft

### Obiettivo
Creare `sitemap-draft.md` con struttura completa.

### Azioni

1. **Genera struttura** basata su analisi Fase 1

2. **Applica convenzioni**:
   - Pagine pubbliche vs autenticate
   - Gerarchia max 3 livelli
   - Route pattern consistenti

3. **Crea file** `docs/frontend-specs/sitemap-draft.md` con Write tool

4. **Comunica path** e attendi conferma

### Formato Draft

**Consulta `templates/sitemap-template.md` per template completo.**

Sezioni:
- **Panoramica**: Statistiche (pagine totali/pubbliche/autenticate)
- **Struttura Pagine**: Tabelle route per categoria (🌐 Pubbliche, 🔒 Autenticate, 👑 Admin)
- **Gerarchia Navigazione**: Diagramma ASCII
- **Flussi Principali**: Diagrammi flussi critici

**Convenzioni**: Vedi `reference/sitemap-conventions.md` per route patterns, categorizzazione, naming

### [Altri flussi...]

## Note

- [Note specifiche del progetto]
```

---

## Fase 3: Checkpoint

### Obiettivo
Presentare sitemap per approvazione BLOCCANTE.

### Azioni

1. **Leggi** `sitemap-draft.md` con Read tool (utente potrebbe aver modificato)

2. **Presenta checkpoint**:

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: SITEMAP <<<
═══════════════════════════════════════════════════════════════

## Sitemap Generata

File: docs/frontend-specs/sitemap-draft.md

### Statistiche
- Pagine totali: X
- Pubbliche: Y
- Autenticate: Z
- Livelli profondità: N

### Struttura Principale
[Mostra gerarchia sintetica]

### Prossimi Passi (dopo approvazione)
1. Architecture Design (tech stack, protocolli)
2. API Signature (basata su questa sitemap)

═══════════════════════════════════════════════════════════════

Approvi questa sitemap?
```

3. **Usa AskUserQuestion** con opzioni:
   - **Approva**: Procedi a Fase 4
   - **Modifica**: Chiedi di modificare file e ri-confermare
   - **Rigenera**: Torna a Fase 2 con nuovo input

### Gestione Risposte

**Se Approva**: Procedi a Fase 4

**Se Modifica**:
```
Modifica direttamente docs/frontend-specs/sitemap-draft.md
Quando hai finito, dimmi "fatto" e rileggo il file.
```
Poi ri-presenta checkpoint.

**Se Rigenera**: Chiedi cosa cambiare e torna a Fase 2.

---

## Fase 4: Finalizzazione

### Obiettivo
Salvare sitemap definitiva e aggiornare stato progetto.

### Azioni

1. **Leggi** `sitemap-draft.md` (versione approvata)

2. **Crea file definitivo** `docs/frontend-specs/sitemap.md`:
   - Rimuovi "DRAFT" dallo stato
   - Aggiungi "APPROVATO" con data

3. **Opzionalmente** rimuovi draft o sposta in `_archive/`

4. **Aggiorna** `progress.yaml` se esiste:
   ```yaml
   checkpoints_completed:
     - sitemap
   ```

5. **Comunica completamento**:
   ```
   ✅ Sitemap approvata e salvata in docs/frontend-specs/sitemap.md

   Prossimo step suggerito:
   - /architecture-designer per definire tech stack e architettura
   ```

---

## Regole Tool

### Sequenza Critica
- ✅ **SEMPRE** Read prima di processare file
- ✅ Write per file nuovi (draft, finale)
- ✅ Edit per modifiche a file esistenti
- ✅ AskUserQuestion per decisioni
- ❌ **MAI** procedere senza conferma checkpoint

### Path Standard
```
docs/
└── frontend-specs/
    ├── sitemap-draft.md    (intermedio)
    ├── sitemap.md          (finale)
    └── _archive/           (opzionale)
```

---

## Gestione Errori

**Consulta `reference/error-handling.md` per procedure recovery complete.**

Errori gestiti:
- **Brief non trovato**: Cerca varianti, chiedi path, fallback a input manuale
- **Brief incompleto**: Chiedi informazioni mancanti, procedi con subset
- **Write fallisce**: Crea directory, path alternativi
- **Draft troppo piccolo**: Warning, opzioni ampliamento
- **Modifiche formato**: Validazione, auto-correzione, guida utente
- **File esistenti**: Backup, versioning, sovrascrittura controllata

---

## Materiali di Riferimento

**Template**:
- `templates/sitemap-template.md` - Template completo sitemap con tutte le sezioni

**Reference**:
- `reference/sitemap-conventions.md` - Route patterns, categorizzazione, naming, mobile-specific
- `reference/error-handling.md` - Gestione errori actionable per ogni fase
- `defaults.md` - Convenzioni default e assunzioni pragmatiche

**Evaluations**:
- `evaluations/eval_1_simple_webapp.md` - Web app con public/authenticated split
- `evaluations/eval_2_mobile_app.md` - Mobile app con tab navigation
- `evaluations/eval_3_multi_role.md` - Multi-role (Customer/Vendor/Admin)

---

## Avvio Workflow

Quando l'utente invoca questa skill:

1. **Saluta** e spiega processo a 4 fasi
2. **Cerca** brief automaticamente
3. **Inizia Fase 1** se trovato
4. **Procedi sequenzialmente** con conferme
5. **Checkpoint BLOCCANTE** prima di finalizzare

**Principio**: Sitemap è FONDAMENTALE - determina tutte le pagine da sviluppare. Non procedere senza approvazione esplicita.
