---
name: [Skill Name Here - Max 50 chars, NO "Claude" or "Skill"]
description: [Brief description: what it does, inputs, outputs, when to use - 100-200 chars ideal, max 280]
---

# [Skill Name - Same as frontmatter]

## Il Tuo Compito / Your Task

[1-2 paragrafi introduttivi che spiegano:
- Cosa fa la skill e perché esiste
- Overview del processo se multi-step
- Valore che porta all'utente]

[Se multi-workflow]: Questa skill supporta **N workflow**:

1. **[Workflow 1 Name]**: [Breve descrizione]
2. **[Workflow 2 Name]**: [Breve descrizione]
3. **[Workflow N Name]**: [Breve descrizione]

---

## Regola Linguistica

[INCLUDI SEMPRE se la skill può operare in multiple lingue]

**Adatta la lingua al contesto**:
- Se [condizione specifica] → rispondi in [lingua]
- Se [condizione specifica] → rispondi in [lingua]
- Cambia lingua solo se utente lo richiede esplicitamente

---

## [Workflow/Fase 1 Name]

### Quando Usarlo/Usarla

[Lista specifica di situazioni in cui questo workflow si applica]

- L'utente chiede [azione specifica]
- L'utente fornisce [input specifico]
- [Condizione specifica] è soddisfatta

### Processo [Rapido/Dettagliato]

[Passi numerati, chiari, actionable, specifici]

1. **[Step Name]**: [Azione specifica] con [Tool specifico]
   - [Sub-azione se necessaria]
   - [Dettagli implementativi]

2. **[Step Name]**: [Azione condizionale]
   - Se [condizione]: [azione specifica]
   - Altrimenti: [azione alternativa]

3. **[Step Name]**: [Azione finale]
   - Output atteso: [Descrizione esatta]

### Regole Critiche

[Lista con ✅ DO e ❌ DON'T chiari]

- ✅ **SEMPRE** [best practice specifica]
- ✅ Usa [Tool] per [scopo specifico]
- ❌ **MAI** [anti-pattern comune]
- ❌ **NON** [errore da evitare]

---

## [Workflow/Fase 2 Name]

[Ripeti struttura sopra per ogni workflow aggiuntivo]

---

## Materiali di Riferimento

[INCLUDI SOLO se hai file ausiliari]

**Processi Dettagliati**:
- `phase_N.md` - [Descrizione contenuto]

**Template**:
- `templates/nome-template.md` - [Descrizione template e quando usarlo]

**Supporto**:
- `defaults.md` - [Descrizione defaults e assumptions]

**Skill Correlate**:
- `skill-name` - [Quando usarla invece/insieme a questa]

---

## Uso Tool (⚠️ CRITICO)

[Linee guida specifiche per tool usage della skill]

### Best Practices Tool

- ✅ **SEMPRE** Read prima di Edit (prevenire dati obsoleti)
- ✅ **SEMPRE** [altra best practice specifica]
- ✅ Usa Write per file nuovi, Edit per esistenti
- ✅ Usa AskUserQuestion per [tipo di decisioni]
- ❌ **MAI** Write su file esistenti (usa Edit)
- ❌ **MAI** Edit senza Read prima
- ❌ **MAI** Bash per leggere/scrivere file (usa tool dedicati)

### Tool Sequencing

**Operazioni Indipendenti** → Esegui in parallelo:
- [Esempio operazioni parallele]

**Operazioni Dipendenti** → Esegui sequenzialmente:
1. [Step che deve essere completato prima]
2. [Step che dipende dal precedente]

---

## Gestione Errori

[Come gestire fallimenti comuni]

### Se Read fallisce
- Verifica che file path sia corretto
- Controlla se file esiste con Bash: `ls [path]`
- Chiedi all'utente: "Non trovo [file]. Esiste? Dovrei cercare in altra location?"

### Se Write fallisce
- Verifica che directory padre esista
- Controlla permessi scrittura
- Proponi location alternativa all'utente

### Se Edit fallisce (old_string not found)
- Re-read il file (potrebbe essere cambiato)
- Verifica che old_string sia esatto (whitespace, newlines)
- Se ancora fallisce: spiega all'utente cosa stai cercando di sostituire e chiedi guidance

### Se [Altro Tool] fallisce
- [Azioni specifiche per recovery]
- [Fallback path chiaro]

### Se [Condizione di errore specifica]
- [Gestione specifica]

---

## Avvio Workflow

[Come inizia l'esecuzione della skill]

Quando l'utente invoca questa skill:

1. **Identifica intent**:
   - [Condizione 1] → Workflow A
   - [Condizione 2] → Workflow B
   - Se ambiguo → AskUserQuestion per chiarire

2. **Conferma comprensione**:
   - "[Messaggio conferma azione da intraprendere]"
   - Presenta piano se multi-step

3. **[Check pre-condizioni se necessario]**:
   - [Verifica 1]
   - [Verifica 2]

4. **Procedi** con workflow appropriato

---

## Output Finale

[Descrizione chiara e specifica del deliverable]

Il deliverable di questa skill è **[nome file/artifact]** con le seguenti caratteristiche:

- **Formato**: [Markdown/JSON/altro]
- **Struttura**: [Sezioni principali]
- **Contenuto**: [Cosa include]
- **Location**: [Dove viene salvato]
- **Dimensione**: [Approssimativa se rilevante]

[Se multi-workflow, specifica output per ciascuno]

---

## Esempi

[OPZIONALE ma raccomandato - Esempi concreti di uso]

<example>
Context: [Situazione specifica]
User: "[Richiesta utente]"
Assistant: "[Risposta attesa con step chiari]"
</example>

---

## Principi Guida

[OPZIONALE - Principi che guidano la skill]

1. **[Principio 1]**: [Spiegazione]
2. **[Principio 2]**: [Spiegazione]
3. **[Principio 3]**: [Spiegazione]
