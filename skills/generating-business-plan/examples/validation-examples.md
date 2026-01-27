# Validation Examples - Business Plan

Esempi concreti di come la skill gestisce validazioni e warning durante la raccolta dati.

---

## Esempio 1: Margine Lordo Negativo (CRITICAL)

### Input Utente
```
Prezzo vendita Amazon: €150
COGS per unit: €180
```

### Output Validazione
```
🔴 ERRORE CRITICO: Margine Lordo Negativo

Prezzo vendita: €150
COGS totale: €180 (€180 prodotto + €0 altri)
Margine lordo: -20% (NEGATIVO)

Questo significa perdere €30 su ogni unità venduta.

Possibili scenari:
1. COGS sovrastimato → Dovresti negoziare con fornitore o ottimizzare produzione
2. Prezzo sottostimato → Valuta aumento prezzo o riposizionamento
3. Strategia loss-leader temporanea → OK se recuperi con upsell/cross-sell

Suggerimento: Per margine positivo 30%, COGS dovrebbe essere max €105

Vuoi:
A) Confermare COGS €180 (procedo con margine negativo)
B) Modificare COGS a €105
C) Rivedere prezzo vendita
D) Fornire altro valore
```

### Azione Skill
- ❌ **BLOCCA** generazione Excel
- ⏸️ Attende fix utente prima di procedere

---

## Esempio 2: LTV/CAC Borderline (WARNING)

### Input Utente
```
Prezzo Amazon: €100
LTV/CAC ratio: 2.2
```

### Calcoli
```
LTV = €100
CAC = €100 / 2.2 = €45.45
```

### Output Validazione
```
🟡 WARNING: LTV/CAC Borderline

LTV/CAC ratio attuale: 2.2x
Minimo raccomandato: 3.0x
Target healthy: 3.0-5.0x

Breakdown:
- LTV (Lifetime Value): €100
- CAC (Customer Acquisition Cost): €45.45

Con ratio 2.2x, margine su customer acquisition è stretto:
- Revenue per customer: €100
- Costo acquisizione: €45.45
- Margine netto (esclusi COGS/opex): €54.55

Per unit economics più solide:
- Aumentare LTV a €136 → ratio 3.0x (€45 CAC)
- Ridurre CAC a €33 → ratio 3.0x (€100 LTV)

Vuoi:
A) Confermare ratio 2.2x (procedo ma documentato come rischio)
B) Modificare LTV/CAC a 3.0x
C) Fornire valori LTV e CAC diversi
```

### Azione Skill
- ⚠️ Evidenzia warning
- ✅ Permette di procedere SE utente conferma esplicitamente
- 📝 Documenta warning nel Markdown finale

---

## Esempio 3: Growth Rate Aggressivo (WARNING)

### Input Utente
```
Quantità Amazon:
- Mese 1-3: 0
- Mese 4: 100
- Growth rate: 30% mensile
```

### Proiezione Risultante
```
Mese 4: 100
Mese 5: 130
Mese 6: 169
Mese 7: 220
Mese 8: 286
Mese 12: 620
```

### Output Validazione
```
🟡 WARNING: Crescita Aggressiva

Crescita mensile: 30%
Annualizzato: 2,330% (23x in un anno)

Crescita >25% mensile è molto aggressiva per prodotti fisici.

Benchmark realistici:
- Early stage validated: 10-20% mensile
- Growth stage: 5-10% mensile
- Mature: 2-5% mensile

Con 30% mensile:
- Mese 4: 100 unità
- Mese 12: 620 unità (6.2x in 8 mesi)
- Anno 2: 10,200+ unità/mese

Hai validazione market per questa crescita?
- Waitlist esistente: [non fornito]
- Pre-ordini: [non fornito]
- Traction attuale: [non fornito]

Suggerimento: Considera growth rate 15-20% mensile per proiezione realistica.

Vuoi:
A) Confermare 30% (documentare assunzioni)
B) Modificare a 15% (conservativo)
C) Modificare a 20% (aggressivo ma realistico)
D) Fornire altro valore
```

### Azione Skill
- ⚠️ Evidenzia warning con calcoli proiezione
- ✅ Permette procedere con conferma
- 📝 Nel Markdown documenta: "Growth rate 30% basato su [fonte/assunzione utente]"

---

## Esempio 4: Salario Fuori Range (WARNING)

### Input Utente
```
Salary C-Level: €2,000/mese
```

### Output Validazione
```
🟡 WARNING: Salario Inusuale

Ruolo: C-Level
Salario: €2,000/mese
Range tipico Italia: €3,000-€10,000/mese

Salario sotto mercato potrebbe causare:
- Difficoltà hiring
- Turnover alto
- Qualità risorse bassa

Benchmark C-Level:
- Startup early stage: €3,000-5,000
- Startup validated: €5,000-7,000
- Scale-up: €7,000-12,000+

Questo è founder salary ridotto? Considerazioni:
- Runway: Salario basso estende runway
- Fundraising: Investor potrebbero vedere come commitment founder
- Sostenibilità: Valuta sostenibilità personale lungo termine

Vuoi:
A) Confermare €2,000 (procedo)
B) Allineare a mercato €5,000
C) Fornire altro valore
```

### Azione Skill
- ⚠️ Warning (non bloccante)
- ✅ Permette procedere
- 📝 Documenta nel Markdown se confermato valore basso

---

## Esempio 5: Runway Insufficiente (CRITICAL)

### Input Utente
```
Equity injection: €100,000 (mese 1)
Monthly burn rate (calcolato): €15,000
Next equity round: Mese 12
```

### Calcoli
```
Initial cash: €100,000
Burn rate: €15,000/mese
Runway: 100k / 15k = 6.67 mesi
Time to next round: 12 mesi
Gap: 12 - 6.67 = 5.33 mesi SENZA CASH
```

### Output Validazione
```
🔴 ERRORE CRITICO: Runway Insufficiente

Current cash: €100,000
Avg monthly burn: €15,000
Runway: 6.7 mesi

Next equity injection: Mese 12 (€X)

Con runway 6.7 mesi, esaurirai cash a MESE 7.
Hai 5.3 mesi di gap fino a round successivo.

Rischi:
- Fundraising sotto pressione (valuation penalties)
- Default se round ritarda
- Focus team su survival vs growth

Azioni correttive OBBLIGATORIE:

1. Ridurre burn rate:
   - Posticipare hiring: Da 5 FTE mese 6 → 3 FTE
   - Ridurre marketing: Da €10k a €6k/mese
   - Tagliare G&A non-essential: -€2k/mese
   → Nuovo burn: €10k → Runway: 10 mesi ✅

2. Anticipare fundraising:
   - Attuale: Mese 12
   - Suggerito: Mese 6 (6 mesi buffer)

3. Aumentare round size:
   - Attuale: €100k
   - Suggerito: €180k (18 mesi runway)

Quale approccio preferisci?
```

### Azione Skill
- 🔴 **BLOCCA** generazione
- 🛑 Richiede fix obbligatorio
- 💡 Propone 3 soluzioni concrete con numeri
- ⏸️ Attende decisione utente prima di procedere

---

## Esempio 6: Ipotesi Generate da Documenti (Step B)

### Documenti Forniti
- `POC_Vocal_Removal_Lyrics_Extraction_Alignment.md` (quotazione €50k)
- `brief-structured.md` (mention "karaoke AI device, target price €150-200")

### Output Step B
```
IPOTESI GENERATE DA DOCUMENTI ESISTENTI

1. Capex iniziale Tech & Product: €140,000
   Fonte: Quotazione POC vocal removal (€50k) da documento "POC_Vocal_Removal_Lyrics_Extraction_Alignment.md"
   Giustificazione: PoC €50k + MVP development €90k (stima 1.8x PoC per produzione completa)
   Confidence: MEDIA
   Nota: MVP estimate basato su industry benchmark, non quotazione esplicita

2. Prezzo vendita Amazon: €175
   Fonte: Brief menziona "target price €150-200"
   Giustificazione: Midpoint range fornito
   Confidence: MEDIA
   → DA VALIDARE: Confermi €175 o preferisci estremo range?

3. COGS per unit: €60
   Fonte: Non disponibile nei documenti
   Giustificazione: Reverse engineering per margine 40% con prezzo €175:
     - Target margin: 40%
     - COGS max: €175 * 0.6 = €105
     - Conservative estimate: €60 (margin 66% - buffer per uncertainties)
   Confidence: BASSA
   → DA VALIDARE CON UTENTE: Hai quotazione fornitore?

4. LTV/CAC ratio: 3.0
   Fonte: Best practice SaaS/Hardware hybrid
   Giustificazione: Standard industry per prodotti con componente subscription/recurring
   Confidence: ALTA
   Nota: Se no recurring revenue, valuta ratio più conservativo 4-5x

5. Team iniziale: 3 FTE (C-Level, Product, Operations)
   Fonte: Tipico per hardware startup early stage
   Giustificazione: Minimum viable team per PoC→MVP→Launch
   Confidence: ALTA

SUMMARY:
- 2 dati con confidence ALTA (pronti)
- 2 dati con confidence MEDIA (suggest validation)
- 1 dato con confidence BASSA (richiede input utente)
```

### Step C - Conferma Utente
```
Ho generato ipotesi per 5 dati mancanti basandomi sui tuoi documenti.

Posso procedere con:
✅ LTV/CAC 3.0x (confidence alta)
✅ Team 3 FTE (confidence alta)

Richiedo conferma su:
⚠️ Capex €140k (confidence media) - Confermi o hai quotazione MVP più precisa?
⚠️ Prezzo €175 (confidence media) - Confermi midpoint o preferisci €150/€200?

Richiedo input obbligatorio su:
❌ COGS €60 (confidence bassa) - Hai quotazione fornitore reale?

Come vuoi procedere?
```

---

## Pattern Comuni di Validazione

### 1. Validazioni Matematiche
- Margine = (Price - COGS) / Price
- LTV/CAC = Customer Lifetime Value / Customer Acquisition Cost
- Runway = Cash / Monthly Burn Rate
- Break-even = Fixed Costs / (Price - Variable Costs)

### 2. Validazioni di Coerenza
- Salari vs range mercato per paese/ruolo
- Growth rate vs benchmark industry
- Capex vs equity available
- Team size vs revenue (revenue per FTE)

### 3. Validazioni di Sostenibilità
- Cash flow positivo entro projection period?
- Break-even raggiunto entro 3-5 anni?
- Runway copre fino a next funding milestone?
- Debt service < 40% EBITDA?

### 4. Validazioni Opportunità
- LTV/CAC >7x → underinvestment in growth?
- Margine >60% → pricing power sottoutilizzato?
- Team <5 FTE con revenue >€500k → scaling opportunity?

---

## Legenda Livelli

| Livello | Emoji | Azione | Esempio |
|---------|-------|--------|---------|
| CRITICAL | 🔴 | Blocca generazione | Margine negativo, Runway <3 mesi |
| WARNING | 🟡 | Richiede conferma | Margine <30%, Growth >25% |
| INFO | 🔵 | Suggerimento | Diversificazione revenue, Economie scala |

---

## Best Practice per Utente

**Quando ricevi WARNING**:
1. Leggi analisi completa (rationale, benchmark, suggerimenti)
2. Valuta se il tuo caso è exception giustificata
3. Se confermi valore: Sarà documentato come assumption nel Markdown
4. Se modifichi: Skill ricalcola e ri-valida

**Quando ricevi CRITICAL**:
1. Devi fixare prima di procedere (non opzionale)
2. Skill propone soluzioni concrete con numeri
3. Scegli soluzione o fornisci alternativa
4. Skill ri-valida dopo fix

**Per Ipotesi Generate (Step B)**:
1. Confidence ALTA: Può procedere senza conferma
2. Confidence MEDIA: Suggerito review, non bloccante
3. Confidence BASSA: Richiede input esplicito utente
