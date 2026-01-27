# Generating Business Plan - Claude Skill

Skill Claude per generare Business Plan finanziari completi in Excel + Markdown, con workflow interattivo guidato e validazione intelligente dei dati.

---

## 🎯 Overview

Questa skill supporta l'utente nella creazione di un business plan finanziario professionale partendo da:
- Documenti esistenti (brief, quotazioni, competitor analysis)
- Input forniti direttamente dall'utente
- Ipotesi intelligenti generate automaticamente (con giustificazione)

**Output**:
1. `business-plan.xlsx` - Modello finanziario Excel con 3 fogli (Input, Output, Financial Statements)
2. `business-plan.md` - Documentazione dettagliata con assunzioni, analisi e scenari

---

## 📁 Struttura File

```
generating-business-plan/
├── SKILL.md                          # Skill definition e workflow principale
├── README.md                         # Questo file
│
├── validation-rules.md               # Regole validazione (CRITICAL, WARNING, INFO)
│
├── questions/                        # Guide per raccolta dati
│   ├── 1-revenue-model.md           # Pricing, canali, volumi
│   ├── 2-cost-structure.md          # COGS, Marketing, Personnel, G&A
│   └── 3-financing-capex.md         # Equity, Debt, Capex
│
├── scripts/                          # Script Python per generazione
│   ├── populate_excel.py            # Popola Excel da JSON
│   └── recalc.py                    # Ricalcola formule con LibreOffice
│
└── template/                         # Template Excel base
    └── business-plan-template.xlsx  # File con struttura e formule
```

---

## 🚀 Come Usare la Skill

### Step 1: Invoca la Skill
```bash
/skill generating-business-plan
```

### Step 2: Fornisci Documenti (opzionale)
La skill accetta input da:
- `brief.md` o `brief-structured.md`
- `requirements.md`
- `competitor-analysis.md`
- Quotazioni tecniche (PDF, MD)
- Qualsiasi documento con dati rilevanti

**Esempio**:
```
Ho questi documenti:
- brief-structured.md (progetto K-Karaoke)
- POC_Vocal_Removal_Lyrics_Extraction_Alignment.md (quotazione €50k)
- competitor-analysis.md

Genera business plan per 3 anni.
```

### Step 3: Workflow Interattivo
La skill seguirà questi step:

**A. Analisi Input**
- Estrae dati da documenti forniti
- Identifica: costi sviluppo, pricing, market size, team

**B. Genera Ipotesi**
- Per dati mancanti, genera ipotesi giustificate
- Esempio: "Ho ipotizzato COGS €50 basandomi su benchmark competitor"
- Ogni ipotesi ha confidence level (Alta/Media/Bassa)

**C. Validazione Interattiva**
- Presenta ipotesi + richiede conferma
- Evidenzia valori incongrui con suggerimenti
- Esempio: "⚠️ COGS €180 > Prezzo €150 → margine negativo. Vuoi rivedere?"

**D-E. Genera Excel**
- Crea JSON strutturato
- Popola Excel con script Python
- Ricalcola formule con LibreOffice

**F-H. Review Loop**
- Chiede verifica Excel
- Genera Markdown esplicativo
- Loop fino ad approvazione finale

---

## 📊 Struttura Excel Generato

### Foglio INPUT
Tutti i dati di input organizzati per sezione:
- **Macro**: Inflazione
- **Revenues**: Amazon, Distribution (prezzi, quantità, growth)
- **Costs**:
  - COGS (prodotto, fees, packaging, shipping)
  - Marketing (LTV/CAC model)
  - Personnel (salari, FTE per ruolo)
  - G&A (rent, SaaS, professional services)
  - Taxes (IRES, IRAP, VAT)
- **Financing**: Equity, Debt
- **Capex**: Intangible (R&D, software), Tangible (equipment)

### Foglio OUTPUT
Prospetti finanziari mensili:
- **P&L**: Revenues → Gross Profit → EBITDA → EBIT → Net Profit
- **Balance Sheet**: Assets, Liabilities, Equity
- **Cash Flow**: Operating, Financing, Cash position

### Foglio FINANCIAL STATEMENTS
Consolidamento annuale degli stessi prospetti.

---

## ✅ Sistema di Validazione

### 🔴 CRITICAL (Blocca generazione)
- **Margine lordo negativo**: Prezzo < COGS
- **LTV/CAC < 2x**: Unit economics insostenibili
- **Runway < 3 mesi**: Cash insufficiente

→ **Richiede fix obbligatorio**

### 🟡 WARNING (Richiede conferma)
- **Margine < 30%**: Difficile coprire fixed costs
- **Growth > 25% mensile**: Aggressivo senza traction
- **Salari fuori range**: Confronto con mercato
- **Burn rate alto**: Senza funding secured
- **Capex > 80% equity**: Poco runway operativo

→ **Evidenzia + suggerisce alternativa + chiede conferma**

### 🔵 INFO (Suggerimenti)
- Diversificazione revenue streams
- Economie di scala COGS
- Ottimizzazioni marketing (LTV/CAC alto)
- Team size vs revenue alignment

→ **Menziona, documenta, non blocca**

---

## 🎯 Esempi di Utilizzo

### Caso 1: Ho solo brief
```
User: Ho brief-structured.md, genera business plan 3 anni

Skill:
→ Analizza brief, estrae info disponibili
→ Genera ipotesi per dati mancanti (con giustificazione)
→ Chiede conferma su ~10-15 input chiave
→ Genera Excel + Markdown
```

### Caso 2: Ho quotazioni tecniche
```
User: Ho quotazione PoC €50k e brief. Target price prodotto ~€150.

Skill:
→ Usa €50k come initial capex (confidence: Alta)
→ Ipotizza COGS basandomi su target price
→ Valida margine lordo €150 - COGS
→ Se margine OK → procede, altrimenti → warning
```

### Caso 3: Ho competitor analysis
```
User: Ho competitor-analysis.md con pricing €99-€249 per prodotti simili.

Skill:
→ Usa range competitor per validare pricing
→ Ipotizza COGS reverse-engineering da competitor
→ Confidence: Media (mark come assumption da validare)
```

---

## 🔧 Requisiti Tecnici

### Software Necessario
1. **Python 3.7+** con librerie:
   ```bash
   pip install openpyxl python-dateutil
   ```

2. **LibreOffice** (per recalc.py):
   - macOS: `/Applications/LibreOffice.app`
   - Linux: `/usr/bin/libreoffice`
   - Windows: `C:\Program Files\LibreOffice\`

### Verifica Installazione
```bash
python3 --version
libreoffice --version  # o soffice --version
```

---

## 🧪 Testing della Skill

### Test Manuale Rapido
1. Crea JSON di test:
```json
{
  "metadata": {
    "project_name": "Test Project",
    "start_date": "2026-01-01",
    "projection_months": 12,
    "currency": "EUR"
  },
  "revenues": {
    "amazon": {"price": 150, "quantities": [0,0,100,150,200,250]}
  },
  "cogs": {
    "product_cogs_per_unit": 50,
    "packaging_per_unit": 5,
    "shipping": {"factory_to_warehouse": 3}
  }
}
```

2. Testa populate:
```bash
cd ~/.claude/skills/generating-business-plan
cp template/business-plan-template.xlsx test-bp.xlsx
python3 scripts/populate_excel.py test-bp.xlsx test-data.json
```

3. Testa recalc:
```bash
python3 scripts/recalc.py test-bp.xlsx
```

### Expected Output
```json
{
  "status": "success",
  "total_errors": 0,
  "total_formulas": 500+
}
```

---

## 🐛 Troubleshooting

### Error: "Excel file not found"
→ Verifica che template esista: `ls template/business-plan-template.xlsx`

### Error: "LibreOffice not found"
→ Installa LibreOffice o specifica path manualmente in recalc.py

### Error: Formula errors (#REF!, #DIV/0!)
→ `recalc.py` ritorna JSON con location errori:
```json
{
  "error_summary": {
    "#DIV/0!": {
      "count": 2,
      "locations": ["Input!D60", "Output!D15"]
    }
  }
}
```
→ Fix riferimenti celle e riprova

### Warning: "Margine negativo"
→ Normale se intenzionale (loss-leader), skill chiede conferma
→ Se errore: rivedi COGS o pricing

---

## 📚 Best Practices

### Per Utenti
1. **Fornisci documenti esistenti**: Skill estrae dati automaticamente
2. **Conferma ipotesi critiche**: Specialmente pricing e COGS
3. **Valida warning**: Anche se non bloccanti, indicano potenziali problemi
4. **Itera**: Prima versione raramente perfetta, usa loop di review

### Per Sviluppatori Skill
1. **Mantieni formule nel template**: `populate_excel.py` scrive solo valori
2. **Test con recalc.py**: Sempre verificare zero errori
3. **Documenta fonti**: Ogni ipotesi deve avere giustificazione chiara
4. **Validation first**: Bloccare errori critici prima di generare Excel

---

## 🔄 Aggiornamenti Futuri

- [ ] Supporto scenari multipli (Base, Optimistic, Pessimistic)
- [ ] Export PowerPoint con slide executive summary
- [ ] Integrazione con tool finanziari (import da QuickBooks, Xero)
- [ ] Grafici automatici in Excel (revenue growth, cash flow waterfall)
- [ ] Supporto valute multiple con conversioni automatiche

---

## 📞 Support

Per issue, bug o feature request:
1. Verifica troubleshooting sopra
2. Controlla file `validation-rules.md` per logiche validazione
3. Leggi `questions/*.md` per capire input attesi

---

## 📄 License

Parte della Claude Skills collection - Internal use.
