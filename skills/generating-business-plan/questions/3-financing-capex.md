# Financing & Capex Questions

Domande guida per definire struttura di capitale, finanziamenti e investimenti (Capex).

---

## Contesto

Questa sezione definisce:
- **Quanto capitale** serve per avviare e crescere
- **Da dove arriva** (equity, debt, grants)
- **Quando serve** (timing rounds)
- **Cosa finanzia** (Capex vs Opex vs Working Capital)
- **Quanto dura** (runway analysis)

---

## PARTE 1: Equity Financing

### 1.1 Capitale Iniziale (Seed/Pre-Seed)

**Domanda**:
> "Hai già capitale iniziale disponibile? Quando e quanto?"

```
Round: _____ (es. Pre-seed, Seed, Friends & Family)
Amount: €_____
Timing: Mese _____ (es. Mese 0 = pre-launch)
Source: [ ] Founders [ ] Angels [ ] VC [ ] Accelerator [ ] Other

Dilution: _____% (if applicable)
Valuation: €_____ (pre-money, if applicable)
```

**Domande Follow-up**:
- "Committed o in corso?" → Committed = certo, In corso = mark as assumption
- "Conditions/milestones?" → Tranche releases?
- "Uso previsto" → Capex? Opex? Working capital?

**Esempio**:
```
Round: Seed
Amount: €140,000
Timing: Mese 0 (pre-launch)
Source: Founders + Angel investor
Status: Committed ✅
Use of funds:
  - Initial tech development (MVP): €90,000
  - POC development: €50,000
  - Remaining for operations
```

---

### 1.2 Round Successivi

Per ogni round futuro previsto:

```
Round: _____ (es. Pre-Series A, Series A)
Amount target: €_____
Timing: Mese _____ o Trigger: _____
Expected valuation: €_____ (if applicable)

Milestones required:
- Revenue: €_____ ARR/MRR
- Users/customers: _____
- Product: _____ (es. MVP launched, 1000 units sold)
- Team: _____ FTE
- Other: _____

Status:
[ ] Planned (not contacted investors)
[ ] In discussion (investor interest)
[ ] Term sheet (near committed)
[ ] Committed
```

**Domanda Chiave**:
> "Quali milestone vuoi raggiungere prima di ogni round?"

**Red Flags**:
- Round planning senza milestone chiare → investor readiness low
- Round needed prima di runway exhaustion → rischioso timing

---

### 1.3 Runway Analysis

**Calcolo Auto (dal modello)**:
```
Current cash: €_____
Avg monthly burn: €_____ (Opex - Revenue)
Current runway: _____ mesi

Next funding: Mese _____
Time until next funding: _____ mesi
Buffer: _____ mesi (runway - time to funding)

🔴 WARNING if buffer < 3 mesi
🟡 CAUTION if buffer < 6 mesi
✅ HEALTHY if buffer > 6 mesi
```

**Domanda**:
> "Se round successivo ritarda, hai piano B?"

Opzioni:
- Ridurre burn (tagliare costi, posticipare hiring)
- Bridge financing (debt o mini-round)
- Revenue acceleration (prepay deals, early sales push)

---

## PARTE 2: Debt Financing

### 2.1 Bank Loans / Innovation Loans

**Domanda**:
> "Prevedi di prendere debito? Quando e quanto?"

```
Loan type: _____ (es. Innovation loan, Bank term loan, Line of credit)
Amount: €_____
Timing: Mese _____
Interest rate (annual): _____% (typical 3-10% for innovation loans)
Duration: _____ mesi
Repayment: [ ] Amortizing [ ] Bullet [ ] Interest-only then bullet

Collateral: [ ] Personal guarantee [ ] Asset-backed [ ] None (public guarantee)

Source: _____ (es. Invitalia, BEI, Banca Commerciale)
```

**Programmi Italia**:
- **Invitalia Smart&Start**: Fino €1.5M, tasso 0%, 80% fondo perduto se Sud
- **BEI Innovfin**: Prestiti €25k-€7.5M per innovazione
- **Fondo Centrale Garanzia**: Garantisce fino 80% prestiti PMI innovative

**Domande Follow-up**:
- "Eligibility verificata?" → Startup innovativa? PMI? R&D >15% costs?
- "Application timeline?" → 3-6 mesi tipici
- "Use of funds restrictions?" → Capex only? Working capital ok?

**Debt Service Calc**:
```
Loan: €50,000
Interest: 6% annual = 0.5% monthly
Duration: 36 months
Monthly payment: €_____ (calc: PMT function)

Year 1 debt service: €_____
Year 1 EBITDA: €_____
Coverage ratio: _____ (EBITDA / Debt service)

⚠️ WARNING if coverage < 1.5x
✅ HEALTHY if coverage > 3.0x
```

---

### 2.2 Grants (Fondo Perduto)

**Domanda**:
> "Hai access a grants o contributi a fondo perduto?"

```
Grant program: _____ (es. Bando Regionale, EU Horizon, PNRR)
Amount: €_____
Timing expected: Mese _____
Match required: _____% (your contribution needed)
Restrictions: _____ (es. hiring constraints, reporting)

Status:
[ ] Eligible (planning to apply)
[ ] Applied (waiting)
[ ] Approved
[ ] Received
```

**Note**:
- Grants tipicamente **post-spesa** → serve cash upfront
- Reporting burden → cost di compliance
- Milestone-based → risk di non completamento

**Modeling Approach**:
- Scenario A: Con grant (optimistic)
- Scenario B: Senza grant (conservative) ← **Use this per default**

---

## PARTE 3: Capital Expenditure (Capex)

### 3.1 Intangible Assets (Software, R&D, IP)

**Domanda**:
> "Quali investimenti in sviluppo tech/prodotto prevedi?"

#### Initial Development (Pre-Launch)
```
POC (Proof of Concept):
  Description: _____
  Cost: €_____
  Source: [ ] Internal [ ] External vendor [ ] Quotation
  Timing: Mese _____

MVP (Minimum Viable Product):
  Description: _____
  Cost: €_____
  Breakdown:
    - Design: €_____
    - Development: €_____
    - Testing: €_____
  Timing: Mese _____

Intellectual Property:
  Patents: €_____ (€5k-15k per patent)
  Trademarks: €_____ (€500-2k per mark)
  Timing: Mese _____
```

**Esempio da Doc**:
```
POC Vocal Removal (da quotazione AGA00220251117):
  Cost: €50,000
  Timing: Month 0
  Source: External quotation (Ermit) ✅ High confidence

MVP Development (estimate):
  Cost: €90,000 (1.8x POC per full production)
  Timing: Month 0-3
  Source: Industry benchmark ⚠️ Medium confidence
```

#### Ongoing R&D
```
Monthly R&D spend (post-launch): €_____
  Source: [ ] Capitalized personnel [ ] External [ ] Both

Capitalization policy:
  % of engineering cost capitalized: _____% (0-80%)
  Rationale: _____ (IAS 38 compliance)
```

**Domanda**:
- "R&D è per nuovo prodotto (capitalizzabile) o maintenance (expense)?"

---

### 3.2 Tangible Assets (Equipment, Hardware)

#### Office & IT Equipment
```
Capex per employee: €_____ (typical €800-2000)
  Breakdown:
    - Laptop: €_____ (€800-1500)
    - Monitor/peripherals: €_____ (€200-400)
    - Phone: €_____ (€300-800)
    - Desk/chair (if office): €_____ (€500-1000)

Total for team: _____ FTE × €_____ = €_____
```

#### Production Equipment (se hardware product)
```
Equipment type: _____ (es. Assembly line, Testing rig, Molds)
Cost: €_____
Capacity: _____ units/month
Timing: Mese _____

Tooling & Molds:
  Product: _____
  Cost: €_____ (one-time)
  Lifespan: _____ units (es. 50k-100k per mold)
```

**Domanda**:
- "Produci in-house o outsource?" →
  - In-house: High capex, low variable cost
  - Outsource: Low/zero capex, high variable cost (in COGS)

#### Warehouse & Logistics
```
Warehouse equipment:
  - Racking/shelving: €_____
  - Forklifts (if needed): €_____
  - Packing stations: €_____

3PL alternative:
  [ ] Use 3PL → Zero capex, costs in G&A as % of revenue
```

---

### 3.3 Depreciation & Amortization

**Policy**:
```
Intangible assets (software, R&D):
  Amortization: _____% yearly (typical 20% = 5 years)

Tangible assets (equipment):
  Depreciation: _____% yearly (typical 33% = 3 years)

Method: [ ] Straight-line [ ] Declining balance
```

**Impact**:
- D&A è **non-cash expense** → riduce EBIT ma non cash flow
- Importante per:
  - Tax shield (riduce taxable income)
  - EBITDA vs EBIT analysis
  - Asset value on Balance Sheet

---

## PARTE 4: Working Capital

### 4.1 Inventory Requirements

**Domanda**:
> "Quanta inventory devi mantenere?"

```
Lead time supplier: _____ giorni
Safety stock: _____ giorni (typically 30-60)
Total inventory: _____ giorni di sales

Example:
  Monthly sales: 200 units
  Lead time: 60 giorni
  Safety stock: 30 giorni
  Total inventory needed: (60+30) × 200/30 = 600 units

Inventory value: 600 units × €_____ COGS = €_____
```

**Cash Impact**:
- Devi pagare inventory **prima** di vendere → cash outflow anticipato
- Inventory financing options:
  - Purchase order financing
  - Inventory loans
  - Supplier payment terms (Net 60/90)

---

### 4.2 Receivables & Payables

```
Days Sales Outstanding (DSO):
  B2C (Amazon/D2C): _____ giorni (typically 14-30)
  B2B (Distribution): _____ giorni (typically 30-60)

Days Payables Outstanding (DPO):
  Suppliers: _____ giorni (typically 30-60)

Net working capital cycle: DSO - DPO = _____ giorni
```

**Example**:
```
Amazon: DSO 14 giorni (payout bi-weekly)
Distribution: DSO 60 giorni (Net 60 terms)
Supplier: DPO 30 giorni (Net 30)

Weighted avg DSO: (Amazon 70% × 14) + (Dist 30% × 60) = 28 giorni
Net cycle: 28 - 30 = -2 giorni (slightly positive cash conversion!)
```

**Domanda**:
- "Hai negoziato payment terms?" → Longer DPO helps cash flow

---

## Template Summary

```markdown
## Financing & Capex - [Project Name]

### Equity Rounds

**Round 1: Seed**
- Amount: €140,000
- Timing: Month 0 (pre-launch)
- Source: Founders (€100k) + Angel (€40k)
- Status: Committed ✅
- Use: Initial tech development + POC

**Round 2: Pre-Series A**
- Amount target: €500,000
- Timing: Month 12
- Milestones required:
  - €15k MRR (€180k ARR)
  - 1500 units sold
  - Product-market fit validated
- Status: Planned (investor outreach Q4)

**Runway Analysis:**
- Initial cash (Month 0): €140,000
- Avg burn (Month 1-6): €12,500
- Avg burn (Month 7-12): €18,000
- Runway to Round 2: 11 months
- Buffer: -1 month ⚠️ **RISK**
- Mitigation: Reduce hiring if revenue <€10k by Month 6

---

### Debt Financing

**None planned** (rely on equity)

Alternative considered:
- Invitalia Smart&Start: Up to €150k, 0% interest
- Timing: Month 6 (if revenue traction)
- Use: Scale manufacturing capacity

---

### Capital Expenditure

**Intangible Assets:**
- POC Vocal Removal: €50,000 (Month 0)
  Source: Quotation Ermit AGA00220251117 ✅
- MVP Development: €90,000 (Month 0-3)
  Source: Estimate 1.8x POC ⚠️
- Total initial: €140,000

**Capitalized Personnel (ongoing):**
- 50% of Product team (2 FTE avg)
- Monthly: €3,500 × 2 × 0.5 = €3,500
- Annual Year 1: €42,000

**Amortization:** 20% yearly (5-year life)

**Tangible Assets:**
- Capex per employee: €1,000
- Month 1: 3 FTE → €3,000
- Month 12: 5 FTE → €2,000 (incremental)
- Total Year 1: €5,000

**Depreciation:** 33.33% yearly (3-year life)

---

### Working Capital

**Inventory:**
- Lead time: 60 days (China production)
- Safety stock: 30 days
- Total: 90 days inventory
- Month 6 sales: 150 units → Inventory: 450 units
- Value: 450 × €50 COGS = €22,500

**Cash Conversion Cycle:**
- DSO: 20 days (blended Amazon 14 + Dist 60)
- DPO: 30 days (supplier Net 30)
- Net: -10 days (favorable)

---

### Total Funding Need (First 12 Months)

| Source | Amount | Timing |
|--------|--------|--------|
| Seed (committed) | €140,000 | Month 0 |
| **Uses:** | | |
| - Initial Capex | €140,000 | Month 0 |
| - Opex (net of revenue) | €180,000 | Month 1-12 |
| - Inventory build | €25,000 | Month 3-6 |
| **Total need** | **€345,000** | |
| **Shortfall** | €205,000 | **Month 12** |
| **Filled by** | Pre-Series A | **Month 12** |
```

---

## Validation Checklist

- [ ] Initial equity amount definito + timing
- [ ] Runway calcolato: Cash / Burn rate
- [ ] Buffer >6 mesi fino a next round (o mitigation plan)
- [ ] Debt (se applicabile): Terms, debt service coverage check
- [ ] Capex breakdown: Intangible + Tangible
- [ ] Capex fonti: Quotations (high confidence) vs Estimates (mark clearly)
- [ ] Amortization/Depreciation rates definiti
- [ ] Working capital considerato (inventory + receivables/payables)
- [ ] Total funding need = Capex + Opex + Working capital
- [ ] Funding sources coprano total need (con buffer)

---

## Next Step

Con Financing e Capex completi → Tutti gli input sono raccolti!

Prossimo: **Genera JSON strutturato** e **Popola Excel**.
