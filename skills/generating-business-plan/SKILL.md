---
name: generating-business-plan
description: Genera Business Plan finanziario completo in Excel (P&L, Balance Sheet, Cash Flow) + Markdown esplicativo. Workflow interattivo con validazione dati. Supporta input flessibili e genera ipotesi giustificate per dati mancanti. Usa quando l'utente chiede "business plan", "financial model", "proiezioni finanziarie" o ha brief/quotazioni da trasformare in modello finanziario.
---

# Generating Business Plan

## Il Tuo Compito

Genera Business Plan finanziario **Excel** completo (3-5 anni) + **Markdown** esplicativo con assunzioni e analisi.

**Output**:
1. `business-plan.xlsx` - Modello finanziario completo con 4 fogli:
   - **Input**: Tutti gli input e assunzioni
   - **Output**: P&L, Balance Sheet, Cash Flow (vista mensile/annuale)
   - **Financial Statements**: Prospetti consolidati annuali
2. `business-plan.md` - Documentazione dettagliata che spiega assunzioni, ipotesi e analisi

---

## Workflow (7 Step)

**Consulta `workflows/business-plan-workflow.md` per procedura completa dettagliata.**

**Summary**:
- **A-B**: Analizza input, identifica gap, genera ipotesi con confidence
- **C**: Chiedi conferma interattiva con validazione intelligente
- **D-E**: Genera JSON → Popola Excel con Python → Ricalcola formule
- **F**: Verifica Excel (loop se modifiche)
- **G-H**: Genera Markdown esplicativo → Verifica (loop se modifiche)

---

## Uso Tool (⚠️ SEQUENZA CRITICA)

### Step D: JSON Generation
1. ✅ **Write** per creare `/tmp/bp_data.json` (file temporaneo)

### Step E: Excel Generation
1. ✅ **Bash** per copiare template (operazione sistema)
2. ✅ **Bash** per eseguire populate_excel.py
3. ✅ **Bash** per eseguire recalc.py (MANDATORY)
4. ✅ **Bash** per cleanup JSON

### Step G: Markdown Creation
1. ✅ **Write** per creare `business-plan.md` (file nuovo)

### Step H: Markdown Iteration
1. ✅ **SEMPRE Read** prima di Edit (CRITICO)
2. ✅ **Edit** per modificare Markdown esistente (MAI Write su file esistente)

### Best Practices Tool
- ❌ **MAI** Edit senza Read prima (dati obsoleti)
- ❌ **MAI** Write su file esistenti (corrompe contenuto)
- ✅ Bash SOLO per script system (Python, git, rm)
- ✅ AskUserQuestion per conferme validazioni

---

## Input Richiesti

**Consulta `reference/input-requirements.md` per lista completa dettagliata.**

**Guide interattive**: `questions/` directory per raccolta dati strutturata.

**Categorie principali**: Periodo/Macro, Revenue Model, COGS, Marketing, Personnel, G&A, Taxes, Financing, Capex.

---

## JSON Format

**Riferimento completo**: Vedi `json-format-reference.md` per struttura dettagliata.

**Regole chiave**:
- Importi in unità base (EUR, USD)
- Percentuali decimali (15% = 0.15)
- Arrays temporali: Se più corto, ultimo valore ripetuto
- Validare con: `python3 -m json.tool /tmp/bp_data.json`

---

## Script Python

### `scripts/populate_excel.py`
Popola template Excel con dati da JSON.

**Usage**:
```bash
python3 populate_excel.py <excel_file> <data_json>
```

### `scripts/recalc.py`
Ricalcola formule Excel usando LibreOffice (MANDATORY dopo populate).

**Usage**:
```bash
python3 recalc.py <excel_file>
```

**Output**:
```json
{
  "status": "success",
  "total_errors": 0,
  "total_formulas": 523,
  "error_summary": {}
}
```

Se errori trovati, fixare e ricorrere fino a `total_errors: 0`.

---

## File di Riferimento

**Workflow**:
- `workflows/business-plan-workflow.md` - Procedura 7-step completa dettagliata

**Reference**:
- `reference/input-requirements.md` - Input richiesti dettagliati (9 categorie)
- `reference/error-handling.md` - Gestione errori per fase
- `reference/final-checklist.md` - Checklist validazione finale
- `json-format-reference.md` - Struttura JSON completa con esempi
- `validation-rules.md` - Regole validazione (3 livelli: CRITICAL, WARNING, INFO)

**Template e Script**:
- `template/business-plan-template.xlsx` - Template Excel base
- `scripts/populate_excel.py` - Script popolamento
- `scripts/recalc.py` - Ricalcolo formule LibreOffice

**Guide ed Esempi**:
- `questions/` - Guide interattive raccolta dati
- `examples/validation-examples.md` - Esempi validazioni e warning

---

## Regole Chiave

### Esecuzione
- ❌ **MAI** chiedere permesso per creare/modificare file
- ✅ Usa script Python pre-installati (no codice inline)
- ✅ Un solo JSON temporaneo in `/tmp/`
- ✅ SEMPRE ricalcolare formule con `recalc.py` dopo populate
- ✅ Verificare zero errori formule prima di procedere

### Validazione Dati
- ✅ **Validazione proattiva**: Se dato utente sembra scorretto, evidenzialo immediatamente
- ✅ **Suggerimenti concreti**: Proponi valori alternativi sensati
- ✅ **Conferma esplicita**: Per valori incongrui, richiedi conferma prima di procedere
- ✅ **Educazione utente**: Spiega perché un valore potrebbe essere problematico

Esempi validazioni critiche:
- COGS > Prezzo vendita → margine negativo
- LTV/CAC < 1 → insostenibile economicamente
- Burn rate > runway → fallimento pre-break-even
- Salari troppo bassi/alti per ruolo e paese
- Growth rate irrealistico (>20% mensile senza giustificazione)

### Ipotesi e Trasparenza
- ✅ Ogni ipotesi deve avere fonte/giustificazione chiara
- ✅ Distinguere dati certi vs ipotizzati nel Markdown
- ✅ Confidence level per ipotesi (Alta/Media/Bassa)
- ✅ Documentare assunzioni chiave che impattano risultati

### Lingua
- ✅ Segui lingua del brief/documenti utente
- ✅ Coerenza tra Excel labels e Markdown

---

## Gestione Errori

**Consulta `reference/error-handling.md` per procedure complete.**

**Fasi critiche**: Input Phase, Excel Generation, Validation Phase.

---

## Esempi e Checklist

**Esempi validazioni**: `examples/validation-examples.md` (margine negativo, LTV/CAC, growth rate, runway).

**Checklist finale**: `reference/final-checklist.md` (validazione completa prima consegna).
