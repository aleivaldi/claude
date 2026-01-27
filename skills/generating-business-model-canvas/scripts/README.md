# Scripts Python per Business Model Canvas

Script pre-installati per popolare Excel da JSON strutturato.

## Usage

```bash
python3 populate_excel.py <excel_file> <data_json>
```

**Esempio**:
```bash
python3 populate_excel.py business-model-canvas.xlsx /tmp/bmc_data.json
```

## File

### `populate_excel.py` (130 righe)
Script principale. Carica JSON, invoca funzioni per ogni sheet, salva Excel.

### `sheet_populators.py` (202 righe)
Funzioni per popolare ogni sheet. Vedi docstring per firme dettagliate.

**Funzioni**:
- `populate_sheet1_business_model(ws, data)` - Business Model Canvas (9 blocchi)
- `populate_sheet2_lean_canvas(ws, data)` - Lean Canvas
- `populate_sheet3_customer_personas(ws, data)` - Customer Personas (max 3)
- `populate_sheet4_value_proposition(ws, data)` - Value Proposition Canvas

## JSON Format

```json
{
  "metadata": {
    "project": "Nome Progetto",
    "author": "Team",
    "date": "2025-01-04",
    "version": "v1.0"
  },
  "sheet1": {
    "key_partners": "🔴 Partner 1\n🔴 Partner 2\n...",
    "key_activities": "🔴 Activity 1\n...",
    "key_resources": "...",
    "value_propositions": "...",
    "customer_relationships": "...",
    "customer_segments": "...",
    "channels": "...",
    "cost_structure": "...",
    "revenue_streams": "..."
  },
  "sheet2": {
    "problem": "🔴 Problem 1\n...",
    "solution": "🔴 Solution 1\n...",
    "unique_value_proposition": "...",
    "high_level_concept": "...",
    "key_metrics": "...",
    "unfair_advantage": "...",
    "channels": "...",
    "customer_segments": "...",
    "early_adopters": "...",
    "existing_alternatives": "...",
    "cost_structure": "...",
    "revenue_streams": "..."
  },
  "sheet3": {
    "personas": [
      {
        "name": "Persona 1",
        "description": "One-liner description",
        "attributes": ["Attribute 1", "Attribute 2", ...]
      }
    ]
  },
  "sheet4": {
    "benefits": "🔴 Benefit 1\n...",
    "features": "🔴 Feature 1\n...",
    "value_proposition": "...",
    "experience": "...",
    "wants": "🔴 Want 1\n...",
    "fears": "🔴 Fear 1\n...",
    "rational_needs": "🔴 Need 1\n...",
    "substitutes": "..."
  }
}
```

## Note

- Contenuti con `\n` per a capo (celle merged)
- Priorità: 🔴 (alta), 🟡 (media), 🟢 (bassa)
- Sheet3 max 3 personas
- Tutti i campi sono opzionali (`.get()` con default `''`)
