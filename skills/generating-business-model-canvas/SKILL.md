---
name: generating-business-model-canvas
description: Genera Business Model Canvas in Excel (4 canvas) + Markdown esplicativo. Usa script Python per popolare Excel (no permessi). Workflow 6-step con JSON data.
---

# Generating Business Model Canvas

## Compito

Genera Business Model Canvas in **Excel** (4 canvas) + **Markdown** esplicativo.

**Output**:
1. `business-model-canvas.xlsx` - 4 canvas compilati (Business Model, Lean, Personas, Value Proposition)
2. `business-model-canvas.md` - Documentazione dettagliata che spiega le scelte

---

## Workflow (6 Step)

### A. Analizza Input
Raccogli brief (file/chat/allegati) + competitor analysis (opzionale).

### B. Chiedi Integrazioni (loop)
Valuta sufficienza info. Se OK → procedi. Se mancano dati → chiedi clarification.

### C. Genera Excel
1. **Bash**: Copia template
2. **Genera JSON** con dati strutturati (vedi `scripts/populate_excel.py` per formato)
3. **Write**: Crea `/tmp/bmc_data.json`
4. **Bash**: Esegui `python3 ~/.claude/skills/generating-business-model-canvas/scripts/populate_excel.py business-model-canvas.xlsx /tmp/bmc_data.json`
5. **Bash**: Rimuovi `/tmp/bmc_data.json`

### D. Verifica Excel (loop)
Annuncia completamento → chiedi review → applica modifiche → loop

### E. Genera Markdown
**Write**: Crea `business-model-canvas.md` con dettagli estesi basati su Excel approvato.

### F. Verifica Markdown (loop)
Annuncia completamento → chiedi review → applica modifiche → loop

---

## Script Python (pre-installati)

### `scripts/populate_excel.py`
Script principale che popola Excel da JSON.

**Usage**:
```bash
python3 populate_excel.py <excel_file> <data_json>
```

**JSON format dettagliato**:

```json
{
  "metadata": {
    "project": "Nome Progetto",
    "author": "Team/Designer",
    "date": "2025-01-04",
    "version": "v1.0"
  },

  "sheet1": {
    "key_partners": "🔴 Partner critico 1 - descrizione\n🔴 Partner critico 2\n🟡 Partner importante",
    "key_activities": "🔴 Attività critica 1\n🟡 Attività importante 2",
    "key_resources": "🔴 Risorsa critica 1\n🟡 Risorsa importante 2",
    "value_propositions": "🔴 Value prop principale 1\n🔴 Value prop principale 2",
    "customer_relationships": "🔴 Self-service\n🟡 Email support",
    "customer_segments": "🔴 Segmento 1\n🟡 Segmento 2",
    "channels": "🔴 Direct sales\n🟡 Partner network",
    "cost_structure": "🔴 Costo fisso (€500/mese)\n🟡 Costo variabile",
    "revenue_streams": "🔴 Subscription (€49-199/mese)\n🟡 Setup fee"
  },

  "sheet2": {
    "problem": "🔴 Problem 1 - descrizione\n🔴 Problem 2\n🟡 Problem 3",
    "existing_alternatives": "🟡 Alternative 1\n🟡 Alternative 2",
    "solution": "🔴 Solution 1 - come risolve\n🔴 Solution 2",
    "key_metrics": "🔴 Metric 1 - Target: 50-100\n🔴 Metric 2 - €100k MRR",
    "unique_value_proposition": "🔴 Clear one-liner value prop",
    "high_level_concept": "🟡 Like X but for Y",
    "unfair_advantage": "🔴 Advantage 1 non copiabile\n🟡 Advantage 2",
    "channels": "🔴 Direct sales\n🟡 Partners",
    "customer_segments": "🔴 Target Customers\n🟡 Target Users",
    "early_adopters": "🔴 Early adopter 1\n🔴 Early adopter 2",
    "cost_structure": "🔴 CAC: €50\n🔴 Hosting: €500/mese",
    "revenue_streams": "🔴 Model: Subscription\n🔴 LTV: €2400"
  },

  "sheet3": {
    "personas": [
      {
        "name": "Persona 1 Name",
        "description": "One-liner descrizione persona",
        "attributes": [
          "Demographics: età, location",
          "Comportamento: tech-savvy, cerca automazione",
          "Goal: obiettivo principale",
          "Pain: problema 1",
          "Pain: problema 2",
          "Budget: range spesa"
        ]
      },
      {
        "name": "Persona 2 Name",
        "description": "One-liner",
        "attributes": ["Demo: ...", "Goal: ..."]
      }
    ]
  },

  "sheet4": {
    "benefits": "🔴 Benefit 1 - outcome emotivo\n🔴 Benefit 2",
    "features": "🔴 Feature 1 - fattuale\n🟡 Feature 2",
    "value_proposition": "Statement sintetico value prop",
    "experience": "Esperienza prodotto - come si sente cliente",
    "wants": "🔴 Want 1 - desiderio emotivo\n🔴 Want 2",
    "fears": "🔴 Fear 1 - paura/preoccupazione\n🟡 Fear 2",
    "rational_needs": "🔴 Need 1 - bisogno razionale\n🟡 Need 2",
    "substitutes": "Alternativa 1\nAlternativa 2 non ovvia"
  }
}
```

**Note**:
- Tutti i campi **opzionali** (default `''`)
- `\n` per a capo in celle merged
- Priorità: 🔴 (critica), 🟡 (importante), 🟢 (nice-to-have)
- Sheet3: max 3 personas
- Contenuti: sintetici con numeri/metriche

---

## File di Riferimento

- `scripts/populate_excel.py` - Script principale
- `scripts/sheet_populators.py` - Funzioni per ogni sheet (firme dettagliate)
- `scripts/README.md` - Documentazione script + JSON format
- `template-structure.md` - Mappatura celle Excel (reference)
- `process-6-steps.md` - Dettagli processo 6-step
- `questions/` - Domande guida per ogni canvas (1-4)

---

## Regole Chiave

- ❌ **MAI** chiedere permesso per creare/modificare file
- ✅ Usa script Python (no generazione codice inline)
- ✅ Un solo JSON temporaneo in `/tmp/`
- ✅ Feedback loop per Excel e Markdown
- ✅ Priorità colorate: 🔴 (alta), 🟡 (media), 🟢 (bassa)
- ✅ Lingua: segui lingua del brief

---

## Gestione Errori

- Brief mancante → chiedi come fornire
- File non trovato → verifica path
- Script error → mostra errore, proponi fix
- Info insufficienti → Step B loop

