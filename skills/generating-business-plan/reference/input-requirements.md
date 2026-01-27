# Input Richiesti

**Guide interattive dettagliate**: Vedi `questions/` directory.

## 1. Periodo e Macro
- **Periodo di proiezione**: Data inizio, durata (mesi), granularità (mensile/trimestrale)
- **Annual inflation rate**: Default 2% (adattabile per paese/periodo)

## 2. Revenue Model
### Amazon (se applicabile)
- **Price (VAT excluded)**: Prezzo vendita per unità
- **Quantity**: Volume vendite per periodo
- **Growth rate**: Crescita mensile/trimestrale volumi (opzionale)

### Distribution (se applicabile)
- **Price (VAT excluded)**: Prezzo B2B per distributori
- **Quantity**: Volume vendite per periodo
- **Growth rate**: Crescita vendite (opzionale)

### Altri canali
- Specificare se SaaS subscription, licensing, servizi, etc.

## 3. Cost of Goods Sold (COGS)
- **Product COGS per unit**: Costo produzione unitario
- **Amazon referral fee %**: Default 15% (verificare per categoria)
- **Packaging cost per unit**: Costo packaging
- **Shipping costs**:
  - Factory → Warehouse
  - Warehouse → Distributor
  - Warehouse → Amazon FBA
  - Direct to customer (se D2C)

## 4. Marketing
- **LTV/CAC target**: Default 3-5x (SaaS best practice)
- **CAC per customer**: Costo acquisizione cliente (se noto)
- Oppure: **Marketing budget %** of revenue

## 5. Personnel
Per ogni ruolo:
- **Salary** (lordo mensile)
- **FTE** (Full Time Equivalent): numero persone per periodo
- **Hiring plan**: quando assumere (opzionale)

Ruoli standard:
- C-Level (Founder/CEO)
- Finance
- Sales
- Marketing
- Product/Engineering
- Operations

Altri dati:
- **Pension provision rate**: Default 6.91% (Italia, adattare per paese)
- **Capitalization rate**: % di costi R&D capitalizzabili (se applicabile)

## 6. General & Administrative (G&A)
- **Warehouse/Office rent**: Affitto mensile
- **SaaS per employee**: Tool e software per dipendente (~€200/mese)
- **CPA/Accounting**: Costi commercialista mensili
- **HR Consultant cost per employee**: ~€30/mese
- **Other costs %**: Catch-all per imprevisti (default 15% di G&A)

## 7. Taxes
- **IRES**: Corporate tax rate (Italia 24%, verificare paese)
- **IRAP**: Regional tax (Italia 3.9%, specificare se applicabile)
- **VAT**: IVA (Italia 22%, adattare per paese/prodotto)

## 8. Financing
- **Equity injection**: Capitale iniziale, timing round successivi
- **Debt**: Prestiti, interest rate
- **Grants**: Contributi a fondo perduto (specificare timing)

## 9. Capital Expenditure (Capex)
### Intangible Assets (Software, IP, R&D)
- **Tech & Product development**: Costi iniziali (es. PoC €50k, MVP €150k)
- **Ongoing R&D**: Costi ricorrenti
- **Amortization rate**: Default 20% yearly (5 anni)

### Tangible Assets (Hardware, Office Equipment)
- **Capex per employee**: ~€1000-2000 (laptop, desk, etc.)
- **Production equipment**: Macchinari, hardware specifico
- **Depreciation rate**: Default 33.33% yearly (3 anni)
