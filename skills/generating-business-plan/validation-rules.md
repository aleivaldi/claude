# Validation Rules - Business Plan Generator

Questo documento definisce tutte le regole di validazione da applicare agli input forniti dall'utente, con livelli di severità e messaggi standard.

---

## Livelli di Validazione

### 🔴 CRITICAL (Blocca generazione)
Errori che rendono il business plan matematicamente invalido o finanziariamente impossibile.
- **Azione**: Blocca e richiedi fix obbligatorio
- **Eccezione**: Solo se utente fornisce giustificazione esplicita documentata

### 🟡 WARNING (Richiede conferma)
Valori inusuali che potrebbero indicare errore ma possono essere intenzionali.
- **Azione**: Evidenzia problema, suggerisci alternativa, richiedi conferma
- **Eccezione**: Utente conferma esplicitamente dopo aver letto warning

### 🔵 INFO (Suggerimento)
Best practices e ottimizzazioni, non bloccanti.
- **Azione**: Menziona in chat, documenta nel Markdown
- **Eccezione**: Sempre opzionale

---

## 1. Revenue Validations

### R1. Prezzo vs COGS 🔴 CRITICAL
```
Condizione: price < total_cogs_per_unit
Dove: total_cogs = product_cogs + packaging + avg_shipping + marketplace_fee
```

**Messaggio**:
```
🔴 ERRORE CRITICO: Margine Lordo Negativo

Prezzo vendita: €{price}
COGS totale: €{total_cogs} ({product_cogs} + {packaging} + {shipping} + {fees})
Margine lordo: {margin}% (NEGATIVO)

Questo significa perdere €{loss} su ogni unità venduta.

Azioni possibili:
1. Aumentare prezzo vendita a min €{breakeven_price} (margine 0%)
2. Ridurre COGS (negoziare fornitori, ottimizzare produzione)
3. Se strategia loss-leader temporanea, documentare:
   - Durata prevista fase di perdita
   - Fonte recupero margine (upsell/cross-sell/subscription)
   - Break-even timeline

Vuoi modificare i valori o documentare strategia loss-leader?
```

### R2. Margine Lordo < 30% 🟡 WARNING
```
Condizione: (price - total_cogs) / price < 0.30
```

**Messaggio**:
```
🟡 WARNING: Margine Lordo Basso

Margine lordo attuale: {margin}%
Target raccomandato: 40-60% per prodotti consumer
Minimo sostenibile: 30%

Con margine {margin}%, coprirai difficilmente fixed costs (personnel, marketing, G&A).

Benchmark settore:
- Hardware consumer: 35-45%
- SaaS: 70-85%
- E-commerce: 40-60%

Suggerimento:
- Aumentare prezzo a €{suggested_price} → margine {target_margin}%
- Ridurre COGS a €{suggested_cogs} → margine {target_margin}%

Vuoi procedere con margine {margin}% o modificare pricing/cogs?
```

### R3. Growth Rate Mensile > 25% 🟡 WARNING
```
Condizione: monthly_growth_rate > 0.25
```

**Messaggio**:
```
🟡 WARNING: Crescita Aggressiva

Crescita mensile: {growth_rate}% ({annual_equivalent}% annualizzato)

Crescita >25% mensile è molto aggressiva per prodotti fisici.

Benchmark realistici:
- Early stage validated: 10-20% mensile
- Growth stage: 5-10% mensile
- Mature: 2-5% mensile

Hai validazione market per questa crescita?
- Waitlist esistente: {size}
- Pre-ordini: {count}
- Traction attuale: {metrics}

Vuoi confermare {growth_rate}% o rivedere proiezioni?
```

### R4. Revenue Streams Mancanti 🔵 INFO
```
Condizione: only_one_revenue_stream == True
```

**Messaggio**:
```
🔵 SUGGERIMENTO: Diversificazione Revenue

Attualmente hai un solo stream di revenue ({stream_name}).

Considera opportunità aggiuntive:
- Subscription per contenuti premium
- Extended warranty/support plans
- Consumables/accessories ricorrenti
- Data/analytics licensing
- B2B enterprise version

Diversificazione riduce rischio e aumenta LTV.

Vuoi aggiungere altri revenue streams o procedere con modello attuale?
```

---

## 2. COGS Validations

### C1. COGS Evolution (Deve Decrescere) 🔵 INFO
```
Condizione: cogs_month_12 >= cogs_month_1
```

**Messaggio**:
```
🔵 SUGGERIMENTO: Economie di Scala

Hai proiettato COGS costante nel tempo (€{cogs}).

Con crescita volumi, tipicamente COGS decresce per:
- Sconti volume fornitori (5-15% su 10x volumi)
- Ottimizzazioni produzione
- Miglior potere negoziale

Esempio: Se passi da 100 a 1000 unità/mese, COGS potrebbe scendere da €50 a €45 (-10%).

Vuoi modellare riduzione COGS o mantenere conservativo costante?
```

### C2. Shipping > 50% Product COGS 🟡 WARNING
```
Condizione: total_shipping_per_unit > product_cogs * 0.5
```

**Messaggio**:
```
🟡 WARNING: Costi Logistici Alti

Shipping totale: €{shipping} per unità
Product COGS: €{product_cogs}
Ratio: {ratio}% (>50% inusuale)

Breakdown:
- Factory → Warehouse: €{leg1}
- Warehouse → Amazon: €{leg2}
- Warehouse → Distributor: €{leg3}

Considera:
1. Consolidamento spedizioni per ridurre costi
2. Warehouse strategico più vicino a destination
3. Negoziazione rates con logistics partner

Vuoi rivedere assunzioni shipping o confermare valori?
```

---

## 3. Marketing Validations

### M1. LTV/CAC < 2.0 🔴 CRITICAL
```
Condizione: ltv_cac_ratio < 2.0
```

**Messaggio**:
```
🔴 ERRORE CRITICO: Unit Economics Insostenibili

LTV/CAC ratio: {ratio}x
Minimum viable: 2.0x
Target healthy: 3.0-5.0x

Breakdown:
- LTV (Lifetime Value): €{ltv}
- CAC (Customer Acquisition Cost): €{cac}

Con ratio <2x, non copri costi fissi oltre al CAC.

Azioni correttive:
1. Aumentare LTV:
   - Alzare prezzo: +20% → LTV €{new_ltv} → ratio {new_ratio}x
   - Aumentare repeat purchases/subscription
   - Upsell/cross-sell
2. Ridurre CAC:
   - Migliorare conversion rate: +50% → CAC €{new_cac} → ratio {new_ratio}x
   - Ottimizzare marketing channels
   - Organic growth (referral, content)

Quale approccio vuoi adottare?
```

### M2. LTV/CAC > 8.0 🔵 INFO
```
Condizione: ltv_cac_ratio > 8.0
```

**Messaggio**:
```
🔵 SUGGERIMENTO: Underinvestment in Growth

LTV/CAC ratio: {ratio}x (molto alto)

Questo è positivo per profitabilità, ma potrebbe indicare:
- Underinvestment in marketing → crescita più lenta del potenziale
- Market share lasciato a competitor

Con ratio {ratio}x, hai margine per essere più aggressivo in customer acquisition.

Esempio: Aumentando marketing budget 2x:
- CAC passa da €{cac} a €{new_cac}
- Ratio scende a {new_ratio}x (ancora healthy)
- Crescita accelera da {current_growth}% a {projected_growth}% mensile

Vuoi esplorare scenario di crescita accelerata o mantenere conservativo?
```

---

## 4. Personnel Validations

### P1. Salari Fuori Range 🟡 WARNING
```
Condizione: salary < role_min OR salary > role_max
Ranges (Italia, gross monthly):
- C-Level: €3000-€10000
- Product/Engineering: €3000-€7000
- Sales: €3000-€8000
- Marketing: €3000-€6000
- Operations: €2500-€5000
```

**Messaggio**:
```
🟡 WARNING: Salario Inusuale

Ruolo: {role}
Salario: €{salary}/mese
Range tipico Italia: €{min}-€{max}/mese

{salary < min ?
  "Salario sotto mercato potrebbe causare: difficoltà hiring, turnover alto, qualità risorse bassa." :
  "Salario sopra mercato potrebbe indicare: seniority eccezionale (ok), o overbudget (rivedere)."}

Benchmark {role}:
- Junior: €{junior_range}
- Mid: €{mid_range}
- Senior: €{senior_range}

Vuoi confermare €{salary} o allineare a mercato?
```

### P2. Team Size vs Revenue 🔵 INFO
```
Condizione: ftes_year_1 > 10 AND revenue_year_1 < 500000
```

**Messaggio**:
```
🔵 SUGGERIMENTO: Team Size vs Revenue

Anno 1:
- Team size: {ftes} persone
- Revenue atteso: €{revenue}
- Revenue per FTE: €{revenue_per_fte}

Benchmark healthy:
- Early stage: €100k-200k revenue/FTE
- Growth stage: €200k-400k revenue/FTE

Il tuo ratio (€{revenue_per_fte}/FTE) è {below/above} benchmark.

{if below: "Considera hiring più graduale allineato a revenue traction."}
{if above: "Ottimo leverage, ma assicurati che team possa sostenere workload."}
```

### P3. Hiring Spike 🟡 WARNING
```
Condizione: ftes_month_n > ftes_month_n-1 * 1.5
```

**Messaggio**:
```
🟡 WARNING: Crescita Team Rapida

Mese {month}: {prev_ftes} → {new_ftes} persone (+{pct}%)

Crescita >50% in un mese può causare:
- Onboarding overload (ogni hire consuma ~20% tempo manager)
- Culture dilution
- Productivity dip temporanea

Best practice: Max +30% team size per trimestre.

Suggerimento: Diluire hiring su {suggested_months} mesi.

Vuoi rivedere hiring plan o confermare spike?
```

---

## 5. Cash Flow & Financing Validations

### F1. Runway < 6 Mesi Prima di Next Round 🔴 CRITICAL
```
Condizione: cash_runway_months < 6 AND no_funding_secured_next_12m
```

**Messaggio**:
```
🔴 ERRORE CRITICO: Runway Insufficiente

Current cash: €{cash}
Avg monthly burn: €{burn}
Runway: {runway} mesi

Next equity injection: {next_round_month ? f"Mese {month} (€{amount})" : "Non pianificato"}

Con runway <6 mesi, rischi:
- Fundraising sotto pressione (valuation penalties)
- Default se round ritarda
- Focus team su survival vs growth

Azioni correttive:
1. Ridurre burn rate:
   - Posticipare hiring: {suggested_hiring_plan}
   - Ridurre marketing: da €{current} a €{suggested}
   - Tagliare G&A non-essential
   → Nuovo runway: {new_runway} mesi

2. Anticipare fundraising:
   - Attuale: Mese {current_plan}
   - Suggerito: Mese {suggested_timing}

3. Aumentare round size:
   - Attuale: €{current_amount}
   - Suggerito: €{suggested_amount} (include 6m buffer)

Quale approccio preferisci?
```

### F2. Burn Rate > €50k/mese Senza Funding Secured 🟡 WARNING
```
Condizione: monthly_burn > 50000 AND next_round_commitment == False
```

**Messaggio**:
```
🟡 WARNING: Burn Rate Alto

Monthly burn rate: €{burn}/mese (€{annual}/anno)
Current runway: {runway} mesi

Con burn >€50k/mese senza funding secured, sei esposto a:
- Market downturn → fundraising più difficile
- Investor sentiment negativo
- Timeline execution allungato

Hai commitment da investor per next round? Se no, considera:
- Scenario "default alive": ridurre burn a break-even path
- Bridge financing: short-term debt per estendere runway
- Milestone-based spend: accelerare solo post-traction

Vuoi modellare scenario conservativo o confermare burn plan?
```

### F3. Debt Service > 40% EBITDA 🟡 WARNING
```
Condizione: annual_debt_service > ebitda * 0.40
```

**Messaggio**:
```
🟡 WARNING: Over-Leveraged

Debt service annuo: €{debt_service}
EBITDA: €{ebitda}
Coverage ratio: {debt_service/ebitda}x

Debt service >40% EBITDA indica alto leverage:
- Poco cushion per imprevisti
- Covenants bancari a rischio
- Difficoltà refinancing

Benchmark healthy:
- Debt service: <30% EBITDA
- Interest coverage: >3x (EBIT/Interest)

Il tuo interest coverage: {coverage}x

Suggerimenti:
- Rinegoziare termini: allungare durata, ridurre rate
- Convertire parte debito in equity
- Aspettare profitabilità maggiore prima di leverage

Vuoi rivedere debt structure?
```

---

## 6. Capex Validations

### X1. Capex > 80% Equity Injection 🟡 WARNING
```
Condizione: initial_capex > equity_round_1 * 0.80
```

**Messaggio**:
```
🟡 WARNING: Capex Consuma Equity

Equity injection: €{equity}
Capex iniziale: €{capex} ({pct}% di equity)
Residuo per operations: €{remaining}

Con capex >{80}% equity, hai poco runway operativo:
- Remaining cash: €{remaining}
- Monthly burn (excl. capex): €{opex_burn}
- Runway: {runway} mesi

Opzioni:
1. Diluire capex nel tempo:
   - MVP minimo: €{mvp_capex} (mese 1)
   - Enhancements: €{enh_capex} (mese 6, post-validation)
   → Runway esteso a {new_runway} mesi

2. Aumentare round size: da €{current} a €{suggested}

3. Financing alternativo per capex:
   - Innovation loans (Invitalia, BEI)
   - Equipment leasing
   - Co-development con partner

Quale strategia preferisci?
```

### X2. Hardware Product Senza Production Capex 🔵 INFO
```
Condizione: product_type == "hardware" AND production_equipment_capex == 0
```

**Messaggio**:
```
🔵 SUGGERIMENTO: Production Setup

Hai modellato prodotto hardware ma capex produzione = €0.

Questo implica outsourcing completo (contract manufacturer)?

Considera se include:
- Molds/tooling setup: €{estimate_tooling}
- Testing equipment: €{estimate_testing}
- QA infrastructure: €{estimate_qa}

Anche con outsourcing, initial setup costs tipicamente €{total_estimate}.

Vuoi aggiungere production setup capex o confermi outsourcing completo?
```

---

## 7. Cross-Validations (Coerenza Multi-Campo)

### X1. Revenue vs Personnel Alignment
```python
def validate_revenue_personnel_alignment(data):
    year_1_revenue = sum(data['revenues']['total'][:12])
    year_1_ftes = avg(data['personnel']['ftes'][:12])
    revenue_per_fte = year_1_revenue / year_1_ftes

    if revenue_per_fte < 50000:
        return {
            'level': 'WARNING',
            'message': f'Revenue/FTE molto basso: €{revenue_per_fte}. Team oversized per revenue atteso?'
        }
    elif revenue_per_fte > 500000:
        return {
            'level': 'WARNING',
            'message': f'Revenue/FTE molto alto: €{revenue_per_fte}. Team undersized per scale target?'
        }
```

### X2. Marketing Budget vs CAC Implied
```python
def validate_marketing_cac_consistency(data):
    marketing_budget = data['marketing']['monthly_budget']
    new_customers = data['revenues']['new_customers_month']
    implied_cac = marketing_budget / new_customers if new_customers > 0 else 0

    stated_cac = data['marketing']['cac_override']

    if stated_cac and abs(implied_cac - stated_cac) / stated_cac > 0.20:
        return {
            'level': 'WARNING',
            'message': f'Inconsistenza CAC: dichiarato €{stated_cac} vs implied €{implied_cac} (budget/customers). Verificare.'
        }
```

### X3. Break-Even Reachability
```python
def validate_breakeven_reachable(projections):
    ever_profitable = any(month['net_profit'] > 0 for month in projections)

    if not ever_profitable and len(projections) >= 36:
        cumulative_loss = sum(month['net_profit'] for month in projections)
        return {
            'level': 'WARNING',
            'message': f'Break-even non raggiunto in {len(projections)} mesi. Cumulative loss: €{cumulative_loss}. Rivedere unit economics o estendere proiezione.'
        }
```

---

## 8. Summary Validation Flow

### Ordine Esecuzione Validazioni

#### Phase 1: Input Integrity (blockers)
1. Check required fields present
2. Check data types correct
3. Check arrays lengths consistent

#### Phase 2: Financial Soundness (criticals)
1. R1: Margine lordo negativo
2. M1: LTV/CAC <2x
3. F1: Runway <6 mesi

→ Se CRITICAL fails: **STOP**, richiedi fix, restart da Phase 1

#### Phase 3: Business Viability (warnings)
1. R2: Margine lordo <30%
2. R3: Growth rate >25%
3. P1: Salari fuori range
4. P3: Hiring spikes
5. F2: Burn rate alto
6. F3: Debt service >40% EBITDA
7. X1: Capex >80% equity

→ Se WARNING: Present warning, suggest fix, ask confirmation

#### Phase 4: Optimization Suggestions (info)
1. R4: Single revenue stream
2. C1: COGS non decrescenti
3. M2: LTV/CAC >8x
4. P2: Team size vs revenue
5. X2: Missing production capex

→ INFO: Mention, document in markdown, don't block

#### Phase 5: Cross-Validations
1. Revenue/Personnel alignment
2. Marketing/CAC consistency
3. Break-even reachability
4. Cash flow sustainability

→ Output validation summary report

---

## 9. Validation Output Format

### Durante Interactive Loop (Step C)
```markdown
## 🔍 VALIDATION RESULTS

### 🔴 CRITICAL ISSUES (require fix)
1. [R1] Margine lordo negativo: €150 price vs €180 COGS
   → See details below

### 🟡 WARNINGS (require confirmation)
1. [M1] LTV/CAC borderline: 2.3x (target 3-5x)
2. [P3] Hiring spike: +5 people in month 6
   → See suggestions below

### 🔵 SUGGESTIONS (optional)
1. [C1] Consider COGS reduction from €50 to €45 in year 2
2. [M2] LTV/CAC 6.5x allows more aggressive marketing

---

### 🔴 DETAIL: [R1] Margine Lordo Negativo
[Full message as defined above]

---

### Next Steps
Please review issues above and:
- Fix CRITICAL issues (mandatory)
- Confirm or adjust WARNINGS
- Consider SUGGESTIONS

Reply with updates or confirmation to proceed.
```

### Nel Markdown Finale
```markdown
## ⚠️ Assumptions & Caveats

### Validated Concerns
The following concerns were raised during validation and explicitly confirmed:

1. **Low Gross Margin (28%)**
   - User confirmed competitive pricing strategy
   - Plan: Improve margin to 35% by year 2 through volume discounts

2. **High Initial Burn (€45k/month)**
   - User confirmed aggressive hiring for fast market entry
   - Mitigation: Series A round planned month 12 (€500k)

### Optimization Opportunities Not Pursued
- COGS reduction potential (-10% via negotiation) - kept conservative
- Marketing investment increase (LTV/CAC 6x allows 2x budget) - prioritized capital efficiency
```

---

## 10. Validation Checklist (per Skill Execution)

Prima di generare Excel:
- [ ] Tutti i CRITICAL resolved
- [ ] Tutti i WARNING acknowledged (user confirmed or fixed)
- [ ] INFO suggestions documented
- [ ] Cross-validations passed
- [ ] Validation report generato

Durante generazione:
- [ ] Formula errors check (recalc.py output)
- [ ] Negative cash flow warning (if applicable)
- [ ] Break-even calculation verified

Post-generazione Markdown:
- [ ] Sezione "Assumptions & Caveats" include validation results
- [ ] Ogni assumption tracciata con source + confidence
- [ ] Warning confermati dall'utente documentati
