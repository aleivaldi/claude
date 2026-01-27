# Processo 6-Step - Dettaglio

## Step A: Analizza Input

**Obiettivo**: Raccogliere brief + competitor analysis (opzionale)

**Azioni**:
1. Chiedi come utente vuole fornire brief (file/chat/allegati)
2. Leggi file o raccogli info in chat
3. Raccogli competitor analysis se disponibile (opzionale)

**Tool Usage**: Read, AskUserQuestion

---

## Step B: Chiedi Integrazioni (loop)

**Obiettivo**: Valutare sufficienza informazioni

**Azioni**:
1. Analizza info raccolte per ogni canvas
2. **Se SUFFICIENTI**: Comunica "Bene, quanto mi hai dato è più che sufficiente, procedo"
3. **Se INSUFFICIENTI**:
   - Chiedi se preferisce chat o file
   - Poni domande mirate (usa `questions/` come guida)
   - Loop fino a info complete

**Tool Usage**: AskUserQuestion, Write (se modalità file)

---

## Step C: Genera Excel

**Obiettivo**: Creare `business-model-canvas.xlsx` con 4 canvas

**Azioni**:
1. **Bash**: Copia template
   ```bash
   cp ~/.claude/skills/generating-business-model-canvas/templates/business-model-canvas-template.xlsx ./business-model-canvas.xlsx
   ```

2. **Genera JSON** con dati strutturati (vedi formato in `SKILL.md` o `scripts/README.md`)

3. **Write**: Salva JSON in `/tmp/bmc_data.json`

4. **Bash**: Esegui script
   ```bash
   python3 ~/.claude/skills/generating-business-model-canvas/scripts/populate_excel.py business-model-canvas.xlsx /tmp/bmc_data.json
   ```

5. **Bash**: Rimuovi JSON temporaneo
   ```bash
   rm /tmp/bmc_data.json
   ```

**Tool Usage**: Bash (cp, python3, rm), Write

**Note**:
- Vedi `scripts/sheet_populators.py` per firme funzioni e campi richiesti
- Priorità: 🔴 (alta), 🟡 (media), 🟢 (bassa)
- Contenuti: sintetici, bullet-like con `\n`

---

## Step D: Verifica Excel (loop)

**Obiettivo**: Iterare modifiche Excel fino ad approvazione

**Azioni**:
1. Annuncia: "✅ Ho generato business-model-canvas.xlsx con i 4 canvas"
2. Chiedi review: "Apri il file e verificalo. Va bene o vuoi modifiche?"
3. **Loop**:
   - Se OK → Step E
   - Se modifiche → rigenera JSON → riesegui script → annuncia → chiedi

**Tool Usage**: Write, Bash

---

## Step E: Genera Markdown

**Obiettivo**: Creare `business-model-canvas.md` dettagliato

**Azioni**:
1. **Write**: Crea markdown basato su Excel approvato
2. Sezioni:
   - Executive Summary
   - Canvas 1-4 (dettagliati con rationale)
   - Appendix (note/considerazioni)
3. Formato: 300-500 righe, spiega PERCHÉ le scelte

**Tool Usage**: Write

---

## Step F: Verifica Markdown (loop)

**Obiettivo**: Iterare modifiche Markdown fino ad approvazione

**Azioni**:
1. Annuncia: "✅ Ho generato business-model-canvas.md"
2. Chiedi review
3. **Loop**:
   - Se OK → Completamento
   - Se modifiche → Read + Edit → annuncia → chiedi
4. Conferma finale: 2 file completati

**Tool Usage**: Read, Edit

---

## Flusso Completo

```
A: Analizza Input
  ↓
B: Chiedi Integrazioni (loop)
  ↓
C: Genera Excel (JSON → script)
  ↓
D: Verifica Excel (loop)
  ↓
E: Genera Markdown
  ↓
F: Verifica Markdown (loop)
  ↓
Completamento!
```

---

## Note Importanti

- **NO permessi**: Mai chiedere permesso per creare/modificare file
- **Script Python**: Usa sempre script pre-installati (no generazione codice)
- **JSON temporaneo**: Unico file in `/tmp/`, rimosso dopo uso
- **Feedback loop**: Excel e Markdown hanno loop indipendenti
- **Skill xlsx**: NON usare (deprecata), usa script Python
