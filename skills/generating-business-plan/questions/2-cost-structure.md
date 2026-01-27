# Cost Structure Questions

Domande guida per raccogliere tutti i costi (variabili e fissi) necessari al business plan.

---

## Framework Costi

```
Total Costs
├── Variable Costs (scale con volume)
│   ├── COGS (Cost of Goods Sold)
│   │   ├── Product manufacturing
│   │   ├── Packaging
│   │   ├── Shipping & logistics
│   │   └── Marketplace fees
│   └── Marketing (customer acquisition)
│
└── Fixed Costs (ricorrenti indipendenti da volume)
    ├── Personnel
    ├── G&A (General & Administrative)
    ├── R&D / Capex ammortizzato
    └── Interests & Taxes
```

---

## PARTE 1: Variable Costs (COGS)

### 1.1 Product Manufacturing Cost

**Domanda**:
> "Qual è il costo di produzione per singola unità?"

**Breakdown Richiesto**:
```
Materiali diretti: €_____
  - Componente A: €_____
  - Componente B: €_____
  - ...

Lavorazione/Assembly: €_____
  - Labor cost: €_____
  - Factory overhead allocation: €_____

Import Duties (se applicable): €_____ (_____%)

COGS per unit (FOB factory): €_____
```

**Fonti Dati Accettabili**:
- ✅ Quotazione fornitore ricevuta (best)
- ✅ RFQ (Request for Quote) in corso
- ✅ BOM (Bill of Materials) + labor estimate
- ⚠️ Benchmark competitor (reverse engineering) - mark as low confidence
- ⚠️ Industry average - mark as placeholder

**Domande Follow-up**:
- "Hai quotazioni da più fornitori?" → Min/Max/Avg?
- "COGS evolve con volumi?" → Break points? (es. 1k units → -10%)
- "MOQ (Minimum Order Quantity)?" → Implication su inventory
- "Payment terms fornitore?" → Net 30/60/90? Impatto cash flow

**Validazione**:
- ⚠️ Se COGS > 70% del prezzo vendita → margine lordo <30% (warning)
- ⚠️ Se single-source supplier → documentare supply chain risk

---

### 1.2 Packaging Cost

**Domanda**:
> "Costo packaging completo per unità pronta alla spedizione?"

**Componenti**:
```
Primary packaging (product box): €_____
Secondary packaging (shipping box): €_____
Inserts/manuals/accessories: €_____
Labeling/branding: €_____
Protective materials (bubble, foam): €_____

Total packaging per unit: €_____
```

**Benchmark**:
- Consumer electronics: €5-€15 per unit
- Small appliances: €3-€8
- Premium products: €10-€25

**Domande**:
- "Packaging custom o stock?"
- "Eco-friendly materials?" (potenziale premium cost +20-30%)

---

### 1.3 Shipping & Logistics

Definire OGNI tratta della supply chain:

#### Leg 1: Factory → Warehouse
```
Origin: _________ (es. Shenzhen, China)
Destination: _________ (es. Warehouse Milano)
Transportation mode: [ ] Air [ ] Sea [ ] Truck

Cost per unit: €_____
(o Cost per container: €_____ / Units per container: _____)

Lead time: _____ days
Frequency: _____ shipments/month
```

**Calcolo**:
- Sea freight: ~€3000-5000 per 20ft container (holds ~2000-5000 units → €0.60-2.50/unit)
- Air freight: ~€5-15 per kg (fast but expensive)

#### Leg 2: Warehouse → Amazon FBA
```
Warehouse location: _________
Amazon FBA center: _________

Inbound shipping cost: €_____ per unit
(o Amazon partnered carrier rate)

Frequency: _____ shipments/week
```

#### Leg 3: Warehouse → Distributor
```
Avg distance: _____ km
Carrier: _________
Cost per unit: €_____
Payment: [ ] Included in wholesale [ ] Separate
```

#### Leg 4: Direct to Customer (se D2C)
```
Carrier: [ ] National post [ ] Courier [ ] Amazon Logistics
Avg cost domestic: €_____
Avg cost international: €_____
Free shipping threshold: €_____ (if applicable)
```

**Total Shipping Breakdown**:
```
Per ogni unità venduta via Amazon:
- Factory → Warehouse: €_____
- Warehouse → FBA: €_____
Total: €_____

Per ogni unità venduta via Distribution:
- Factory → Warehouse: €_____
- Warehouse → Distributor: €_____
Total: €_____
```

**Validazione**:
- ⚠️ Se total shipping > 50% product COGS → considerare ottimizzazioni logistiche

---

### 1.4 Marketplace & Payment Fees

#### Amazon Fees
```
Referral fee: _____% (varia per categoria)
  Source: [Amazon Fee Schedule for category]

FBA fulfillment fee: €_____ per unit
  (Based on size/weight tier - check FBA calculator)

Storage fee: €_____ per unit per month
  (Peak vs off-peak season)

Other: €_____ (returns, removals, long-term storage)
```

**Tool**: [Amazon Revenue Calculator](https://sellercentral.amazon.com/fba/profitabilitycalculator/index)

#### Payment Processing (se Direct)
```
Stripe/PayPal fee: 2.9% + €0.25 per transaction
Average order: €_____ → Fee: €_____
```

---

### 1.5 Total COGS Summary

```
Per unità venduta via AMAZON:
Product COGS: €_____
Packaging: €_____
Shipping (factory→warehouse→FBA): €_____
Amazon fees (referral + FBA): €_____
─────────────────
TOTAL COGS: €_____

Selling price: €_____
GROSS MARGIN: €_____ (_____%)
```

```
Per unità venduta via DISTRIBUTION:
Product COGS: €_____
Packaging: €_____
Shipping (factory→warehouse→distributor): €_____
─────────────────
TOTAL COGS: €_____

Wholesale price: €_____
GROSS MARGIN: €_____ (_____%)
```

**Target Benchmarks**:
- ✅ Gross margin 40-60%: Healthy
- ⚠️ Gross margin 30-40%: Acceptable ma tight
- 🔴 Gross margin <30%: Rivedere pricing o costi

---

## PARTE 2: Marketing Costs

### 2.1 Customer Acquisition Model

**Approccio A: LTV/CAC Ratio (raccomandato)**

```
LTV (Lifetime Value):
  Average order value: €_____
  × Repeat purchases (lifetime): _____
  = LTV: €_____

CAC (Customer Acquisition Cost):
  Target LTV/CAC ratio: _____ (default 3-5x)
  = CAC max: €_____ (LTV / ratio)

Monthly marketing budget:
  New customers target: _____ /month
  × CAC: €_____
  = Budget: €_____ /month
```

**Domande**:
- "Hai già testato marketing?" → CAC osservato? → Use that invece di LTV/ratio
- "Repeat purchase?" → Frequency? → Calculate true LTV
- "Referral rate?" → Può ridurre blended CAC

**Approccio B: % of Revenue**

```
Marketing budget: _____% of revenue
(Typical: 15-30% per consumer products early stage)

Month 1 revenue: €_____ → Marketing: €_____
Month 12 revenue: €_____ → Marketing: €_____
```

**Domande**:
- "Quale approccio preferisci?" → A per unit economics rigor, B per simplicity

---

### 2.2 Marketing Mix Allocation

Se vuoi dettagliare (opzionale ma utile):

```
Digital Ads (60%): €_____
  - Google Ads: €_____
  - Meta Ads: €_____
  - Amazon PPC: €_____

Content/SEO (15%): €_____

Influencer/PR (15%): €_____

Offline (10%): €_____
```

---

## PARTE 3: Personnel

### 3.1 Team Composition

Per ogni ruolo, definire:

```
Ruolo: _________
Salary (gross monthly): €_____
Benefits/Overhead: _____% (typical 30-40% in Italy)
Total cost per FTE: €_____ /month

Hiring timeline:
  Month 1: _____ FTE
  Month 3: _____ FTE
  Month 6: _____ FTE
  Month 12: _____ FTE
  Year 2: _____ FTE
  Year 3: _____ FTE
```

#### Ruoli Standard

**C-Level / Founders**
```
CEO/Founder: €_____ × _____ FTE
COO: €_____ × _____ FTE
CTO (if applicable): €_____ × _____ FTE
```

**Product & Engineering**
```
Product Manager: €_____ × _____ FTE
Software Engineer: €_____ × _____ FTE
QA/Testing: €_____ × _____ FTE
Designer: €_____ × _____ FTE
```

**Operations**
```
Supply Chain Manager: €_____ × _____ FTE
Customer Support: €_____ × _____ FTE
Warehouse Staff: €_____ × _____ FTE
```

**Sales & Marketing**
```
VP Sales: €_____ × _____ FTE
Account Manager: €_____ × _____ FTE
Marketing Manager: €_____ × _____ FTE
Content Creator: €_____ × _____ FTE
```

**Finance & Admin**
```
CFO/Finance Manager: €_____ × _____ FTE
Accountant: €_____ × _____ FTE
HR (if >10 people): €_____ × _____ FTE
```

**Benchmark Salari Italia (gross monthly)**:
- Junior (0-2 anni): €2500-3500
- Mid (3-5 anni): €3500-5000
- Senior (5-10 anni): €5000-7000
- C-Level/Director: €5000-12000+

---

### 3.2 Altri Costi Personale

```
TFR (Trattamento Fine Rapporto): 6.91% in Italy
  Auto-calcolato nel modello

INPS (datore di lavoro): ~30% in Italy
  Incluso in "Total cost per FTE"

Capitalization (R&D):
  % di engineering cost capitalizzabile: _____% (0-80%)
  Se sviluppi software/IP, parte va in Capex vs Opex
```

**Domanda**:
- "Operi in Italia?" → Use defaults above
- "Se estero, quale paese?" → Adjust tax/benefits

---

## PARTE 4: General & Administrative (G&A)

### 4.1 Facilities
```
Office rent: €_____ /month
Warehouse rent: €_____ /month
Utilities: €_____ /month
Insurance: €_____ /month
```

**Domande**:
- "Lavori remote o serve office?"
- "Warehouse proprio o 3PL?" → Se 3PL, costi in logistics (Part 1.3)

### 4.2 Software & Tools
```
SaaS per employee: €_____ /month (typical €100-300)
  - Productivity (Slack, Notion): €50
  - CRM (HubSpot, Salesforce): €50
  - Analytics/BI: €30
  - Design tools: €20
  - DevOps: €50

Enterprise software:
  - ERP: €_____ /month
  - Inventory management: €_____ /month
```

### 4.3 Professional Services
```
Commercialista/CPA: €_____ /month (€500-2000 tipico)
Legal counsel: €_____ /month (o €_____ retainer)
HR consultant: €_____ per employee /month (€20-50)
IT support: €_____ /month
```

### 4.4 Other G&A
```
Travel & expenses: €_____ /month
Office supplies: €_____ /month
Marketing materials (non-ads): €_____ /month
Training & development: €_____ /month
Other: €_____ /month

% buffer for unforeseen: _____% (typical 10-20%)
```

---

## PARTE 5: Taxes

### 5.1 Income Taxes
```
IRES (corporate income tax): _____% (Italy: 24%)
IRAP (regional tax): _____% (Italy: 3.9%, varies by region)

Effective tax rate: _____%
  (Applied on EBT - Earnings Before Tax)
```

**Domanda**:
- "Paese di registrazione azienda?" → Determine tax regime
- "Deduzioni/crediti attesi?" → R&D tax credit? Startup incentives?

### 5.2 VAT/IVA
```
VAT rate: _____% (Italy: 22% standard, 10% reduced, 4% super-reduced)
Product category: _________
Applicable VAT: _____%

Note: VAT è neutra se gestita correttamente (in - out = 0)
      Ma impatta cash flow timing.
```

---

## Template Summary

```markdown
## Cost Structure - [Project Name]

### Variable Costs (per unit)

**Amazon Channel:**
- Product COGS: €50.00
- Packaging: €5.00
- Shipping (factory→warehouse→FBA): €7.00
- Amazon fees: €24.00 (15% referral + €2 FBA)
**Total COGS: €86.00**
**Selling price: €149.00**
**Gross margin: €63.00 (42.3%)** ✅

**Distribution Channel:**
- Product COGS: €50.00
- Packaging: €5.00
- Shipping (factory→warehouse→dist): €5.00
**Total COGS: €60.00**
**Wholesale price: €99.00**
**Gross margin: €39.00 (39.4%)** ✅

### Marketing
- Model: LTV/CAC ratio
- LTV: €149 (single purchase, no repeat modeled)
- Target ratio: 3.5x
- CAC max: €42.57
- Month 1 budget: €5,000 (118 customers)
- Month 12 budget: €15,000 (352 customers)

### Personnel (Year 1)
| Role | Salary | FTE M1 | FTE M12 | Annual Cost |
|------|--------|--------|---------|-------------|
| CEO | €5,000 | 1 | 1 | €60,000 |
| Product | €3,500 | 1 | 2 | €52,500 |
| Operations | €3,500 | 1 | 1 | €42,000 |
| **Total** | | **3** | **4** | **€154,500** |

**TFR provision**: €10,676 (6.91%)
**Capitalization**: 50% Product → €26,250 to Capex

### G&A (monthly)
- Warehouse rent: €1,000
- SaaS (€200 × avg 3.5 FTE): €700
- CPA: €1,000
- HR consultant (€30 × 3.5 FTE): €105
- Other (15% buffer): €420
**Total G&A: €3,225 /month** (€38,700 /year)

### Taxes
- IRES: 24%
- IRAP: 3.9%
- VAT: 22% (neutra)
```

---

## Validation Checklist

- [ ] COGS breakdown completo (product + packaging + shipping + fees)
- [ ] Gross margin validato (target >30%, ideally >40%)
- [ ] Marketing budget approach scelto (LTV/CAC o % revenue)
- [ ] Personnel: Tutti i ruoli con salary + hiring timeline
- [ ] G&A: Tutte le voci (facilities, software, services)
- [ ] Taxes: Regime fiscale corretto per paese
- [ ] Total fixed costs < Gross profit (almeno a regime)

---

## Next Step

Con revenue (Part 1) e costs completi → Passare a **3-financing-capex.md** per finanziamenti e investimenti.
