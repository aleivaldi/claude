# Revenue Model Questions

Domande guida per raccogliere informazioni sul modello di revenue.

---

## Contesto

Il modello di revenue è il cuore del business plan. Definisce:
- **Chi** paga (customer segments)
- **Cosa** acquista (product/service)
- **Quanto** paga (pricing)
- **Quando** paga (frequency, timing)
- **Come** cresce (growth drivers)

---

## Domande Primarie

### 1. Canali di Vendita

**Domanda**:
> "Attraverso quali canali venderai il prodotto/servizio?"

**Opzioni Comuni**:
- [ ] Amazon/Marketplace (Amazon, eBay, etc.)
- [ ] Direct-to-Consumer (proprio e-commerce)
- [ ] Distribution B2B (wholesale a distributori/retailer)
- [ ] Direct B2B (vendita diretta ad aziende)
- [ ] Subscription/SaaS
- [ ] Licensing
- [ ] Altro: ___________

**Follow-up**:
- "Qual è la priorità tra questi canali?" (rank)
- "Timing di launch per ciascun canale?"

---

### 2. Pricing per Canale

Per ogni canale selezionato:

#### Amazon/Marketplace
**Domande**:
```
- Prezzo di vendita (IVA esclusa): €_____
- Categoria prodotto Amazon: _________
- Referral fee attesa: ____% (default 15%)
```

**Contesto**:
- Prezzo deve essere competitivo ma sostenere margini
- Referral fee varia 8-20% per categoria ([Fee Schedule](https://sellercentral.amazon.com/gp/help/200336920))
- Considera: price perception, competitor pricing, psychological pricing

**Validazioni**:
- Prezzo > COGS + fees + shipping
- Confronto con competitor (±20% è range accettabile)

#### Distribution B2B
**Domande**:
```
- Prezzo wholesale (IVA esclusa): €_____
- Discount vs retail price: ____%
- Minimum order quantity: _____ unità
- Payment terms: Net ___ giorni
```

**Best Practices**:
- Wholesale tipicamente 40-60% di retail price
- MOQ basato su economie shipping (pallet, container)
- Payment terms: Net 30-60 common, ma impatta cash flow

#### Direct-to-Consumer
**Domande**:
```
- Prezzo listino (IVA esclusa): €_____
- Shipping cost passed to customer: €_____ o [ ] Free shipping
- Average order value target: €_____
- Return rate expected: ____%
```

#### Subscription/SaaS
**Domande**:
```
- Monthly subscription price: €_____
- Annual subscription (discount %): €_____ (___% off)
- Freemium tier? [ ] Yes [ ] No
- Churn rate mensile atteso: ____% (2-7% typical)
```

---

### 3. Volumi di Vendita

**Approccio Top-Down**:
```
Total Addressable Market (TAM): ___________
Serviceable Addressable Market (SAM): ___________
Serviceable Obtainable Market (SOM) Year 1: ___________

Assumptions:
- Market size source: ___________
- Our target % of SAM: _____%
```

**Approccio Bottom-Up (preferito)**:
```
Mese 1-3 (Launch/Beta):
- Volumi attesi: _____ unità/mese
- Source: (waitlist, pre-order, pilot)

Mese 4-6 (Early Growth):
- Volumi attesi: _____ unità/mese
- Growth rate: ____% mensile
- Driver: (marketing ramp-up, word-of-mouth)

Mese 7-12 (Scale):
- Volumi attesi: _____ unità/mese
- Growth rate: ____% mensile
- Driver: (brand awareness, optimization)

Anno 2-3:
- Growth rate atteso: ____% mensile
- Rationale: ___________
```

**Domande di Supporto**:
- "Hai waitlist/pre-order esistenti?" → Quanti? → Conversion rate atteso?
- "Hai run test marketing?" → CAC osservato? → Conversion rate?
- "Competitor benchmark?" → Loro volumi stimati? → Market share target?

---

### 4. Revenue Growth Drivers

**Domanda**:
> "Cosa guiderà la crescita dei tuoi revenue nei prossimi 3 anni?"

**Framework AARRR** (per valutare realism):
```
Acquisition:
- Budget marketing mese 1: €_____ → mese 12: €_____
- CAC target: €_____
- New customers/mese: _____

Activation:
- Conversion rate (visitor → buyer): _____%
- Average time to first purchase: ___ giorni

Retention:
- Repeat purchase rate: ____%
- Frequency: ogni ___ mesi

Revenue:
- Average order value: €_____
- Upsell/cross-sell rate: ____%

Referral:
- Referral rate: ____% customers
- Viral coefficient: _____ (1+ è virale)
```

**Red Flags**:
- Growth senza marketing budget → unrealistic
- CAC non definito ma volumi aggressivi → no unit economics
- No repeat purchase ma LTV assume recurring → model broken

---

### 5. Revenue Seasonality

**Domanda**:
> "Il tuo prodotto ha stagionalità?"

**Se YES**:
```
Mesi high season: ___________ (es. Nov-Dec per gift items)
Revenue boost: ____% vs avg month
Mesi low season: ___________
Revenue dip: ____% vs avg month
```

**Impatto su**:
- Inventory planning
- Cash flow (need buffer per low season)
- Marketing allocation

---

## Template Risposta Completa

```markdown
## Revenue Model - [Project Name]

### Canali di Vendita
1. **Amazon** (Primary - Launch Month 1)
   - Price: €149 (IVA escl.)
   - Referral fee: 15%
   - Target volume: 0-0-100-150-200-250 (primi 6 mesi)
   - Growth rate: 15% mensile post-launch

2. **Distribution B2B** (Secondary - Launch Month 4)
   - Wholesale price: €99 (34% discount vs Amazon)
   - MOQ: 50 unità
   - Payment: Net 60
   - Target volume: 0-0-0-50-75-100 (primi 6 mesi)

### Growth Drivers
- **Marketing Budget**: €5k month 1 → €15k month 12
- **CAC Target**: €35 (LTV/CAC = 4.3x)
- **Conversion Rate**: 2.5% (e-commerce benchmark)
- **Repeat Purchase**: 20% annual (accessory sales)

### Seasonality
- High season: Nov-Dec (+40% vs avg)
- Planning: Increase inventory month 9-10

### Assumptions & Sources
- TAM: €500M (Source: Statista EU Smart Home Audio 2025)
- SAM: €50M (Italy + targeting)
- Year 1 SOM: 0.1% (€50k) = 335 unità
- Competitor benchmark: Brand X does est. 500 units/month (Source: Amazon BSR analysis)
- Waitlist: 150 people (conversion assumption: 50%)
```

---

## Checklist Completeness

Prima di procedere al passo successivo, verificare:

- [ ] Almeno 1 canale definito con pricing
- [ ] Volumi mensili proiettati per 12-36 mesi
- [ ] Growth rate giustificato (non "pulled from air")
- [ ] Se Amazon: categoria e referral fee verificati
- [ ] Se B2B: payment terms definiti (impatto cash flow)
- [ ] Se Subscription: churn rate ipotizzato
- [ ] Pricing validato vs COGS (margine positivo)
- [ ] Benchmark competitor considerato
- [ ] Seasonality valutata (se applicabile)

---

## Next Step

Una volta raccolti i dati revenue → passare a **2-cost-structure.md** per COGS e operating costs.
