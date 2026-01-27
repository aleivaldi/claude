# Processo Analisi Competitor e Mercato

## Obiettivo

Creare **competitor-analysis.md** completo e riutilizzabile per requirements, marketing, pitch deck, business plan.

**Caratteristiche competitor-analysis.md**:
- **Standalone** - Leggibile senza altri documenti
- **Oggettivo** - Analisi honest dei competitor (no bias)
- **Attuabile** - Informazioni utili per decisioni strategiche
- **Versionato** - Supporto aggiornamenti incrementali
- **Riutilizzabile** - Usabile in contesti multipli

---

## Overview Modalità Operative

La skill opera in 3 modalità basate sull'input ricevuto:

### Modalità A: Analisi Da Zero
- **Trigger**: Utente fornisce solo descrizione prodotto, nessuna analisi esistente
- **Output**: competitor-analysis.md v1.0 (nuovo file)
- **Durata**: ~30-45 minuti di lavoro

### Modalità B: Approfondimento Competitor Specifici
- **Trigger**: Esiste competitor-analysis.md + utente indica competitor da approfondire
- **Output**: competitor-analysis.md v1.1 (update minore)
- **Durata**: ~15-20 minuti di lavoro

### Modalità C: Aggiornamento Analisi Esistente
- **Trigger**: Esiste competitor-analysis.md + richiesta aggiornamento generale
- **Output**: competitor-analysis.md v1.2 o v2.0 (a seconda entità modifiche)
- **Durata**: ~20-30 minuti di lavoro

---

## Tools da Usare

1. **WebSearch** tool → Identificare competitor, raccogliere informazioni (CRITICO)
2. **Read** tool → Leggere analisi esistente (modalità B/C)
3. **Write** tool → Creare competitor-analysis.md (modalità A)
4. **Edit** tool → Aggiornare competitor-analysis.md (modalità B/C)
5. **AskUserQuestion** tool → Chiarire modalità, conferme

---

## Modalità A: Analisi Da Zero

### Passo 1: Ricevere e Analizzare Descrizione Prodotto

**Input da estrarre**:
- Tipo di prodotto/servizio (SaaS, Hardware, Marketplace, etc)
- Problema risolto
- Target market (B2B, B2C, verticale specifico)
- Caratteristiche principali
- Differenziatori menzionati (se presenti)

**Se descrizione vaga**: Usa AskUserQuestion per chiarire.

---

### Passo 2: WebSearch - Identificare Competitor

**Strategia di ricerca a più livelli**:

**Livello 1 - Discovery Competitor Diretti**:
```
WebSearch: "[tipo prodotto] [problema risolto] competitors"
WebSearch: "best [tipo prodotto] for [target market]"
WebSearch: "alternatives to [prodotto simile noto]"
```

**Esempi**:
- "project management SaaS competitors"
- "best IoT temperature sensors for food industry"
- "alternatives to Slack for team communication"

**Livello 2 - Competitor Indiretti**:
```
WebSearch: "[problema] solutions"
WebSearch: "how to solve [problema] without [nostro approccio]"
```

**Livello 3 - Review Platforms**:
```
WebSearch: "[categoria prodotto] reviews G2"
WebSearch: "[categoria prodotto] reviews Capterra"
WebSearch: "Product Hunt [categoria]"
```

**Obiettivo**: Identificare 7-12 competitor potenziali (restringeremo a 5-7 principali)

**⚠️ IMPORTANTE - Traccia Link Durante WebSearch**:
- **Salva URL** di ogni fonte utile trovata durante WebSearch
- **Numerazione footnotes**: Assegna [^1], [^2], [^3]... progressivamente
- **Annota data**: Quando accedi a ogni fonte
- Usa struttura temporanea durante ricerca:
  ```
  [^1]: Market Size Report - https://... - Accessed 2024-XX-XX
  [^2]: Competitor A Website - https://competitorA.com - Accessed 2024-XX-XX
  ```

---

### Passo 3: Raccogliere Informazioni per Ogni Competitor

Per ogni competitor identificato, raccogliere tramite WebSearch:

**Informazioni Base**:
- Nome e website → **Salva link**: [^N]: Competitor Website - https://...
- Tagline/positioning statement
- Tipo (direct/indirect competitor)
- Anno fondazione (se trovato) → **Salva link fonte**: [^N]: Crunchbase/About Page - https://...

**Features Principali**:
- Lista features chiave (top 5-7) → **Salva link**: [^N]: Features Page - https://competitor.com/features
- Cosa fanno meglio
- Cosa non fanno o limitazioni note

**Pricing**:
- Modello pricing (Freemium, Subscription, One-time, Usage-based)
- Range prezzi (Entry tier, Mid tier, Enterprise)
- Trial/Free tier se disponibile
- **SEMPRE salva link**: [^N]: Pricing Page - https://competitor.com/pricing - Accessed 2024-XX-XX

**Target Market**:
- B2B vs B2C
- Dimensione aziende (SMB, Mid-market, Enterprise)
- Verticali specifici (se applicabile)
- Geografico (se rilevante)

**Market Position**:
- Leader / Challenger / Niche player
- Funding status (se disponibile) → **Salva link**: [^N]: Crunchbase - https://crunchbase.com/organization/...
- Numero utenti/clienti (se pubblico) → **Salva link fonte**: [^N]: Company Blog/Press Release - https://...

**Punti Forza e Debolezza**:
- Da reviews, feedback pubblici, website
- Essere oggettivi
- **Salva link reviews**: [^N]: G2 Reviews - https://g2.com/products/.../reviews
- **Salva link feedback**: [^N]: Reddit Thread - https://reddit.com/r/.../comments/...

**WebSearch per competitor specifico**:
```
WebSearch: "[Competitor Name] features pricing"
WebSearch: "[Competitor Name] reviews"
WebSearch: "[Competitor Name] vs [altro competitor]"
```

**Traccia Link per OGNI informazione**:
- Features → Link a docs ufficiale
- Pricing → Link a pricing page con data
- Reviews → Link specifici (non solo "G2" ma URL esatto)
- Funding → Crunchbase URL
- Statistics → Link a fonte (press release, about page, etc)

---

### Passo 4: Selezionare 5-7 Competitor Principali

**Criteri selezione**:
- Rilevanza (diretti > indiretti)
- Visibility nel mercato
- Mix di leader, challenger, niche
- Copertura diversi segment (se applicabile)

**Output**: 5-7 competitor per Competitor Profiles dettagliati
**Altri**: Menzione in "Other Notable Competitors"

---

### Passo 5: Creare Comparative Analysis

**Feature Comparison Matrix**:
- Righe: Features chiave (5-10 features rilevanti)
- Colonne: Competitor + Our Product
- Valori: ✓ (ha feature), ✗ (non ha), Partial (parziale), Planned (pianificato)

**Pricing Comparison**:
- Tabella con Model / Entry Price / Mid Tier / Enterprise / Target
- Evidenziare pattern (es. tutti freemium, tutti enterprise-focused)

---

### Passo 6: Positioning Map

**Creare positioning map** (descrittivo o ASCII):
- Assi X/Y: 2 dimensioni rilevanti (es. Price vs Features, Ease-of-use vs Power, etc)
- Posizionare competitor su mappa
- Identificare cluster e gap

**Esempio descrittivo**:
```
Asse X: Price (Low → High)
Asse Y: Feature Set (Basic → Advanced)

Quadrant 1 (Low Price, Basic Features):
- Competitor A, Competitor B

Quadrant 2 (High Price, Advanced Features):
- Competitor C (Leader)

Quadrant 3 (Low Price, Advanced Features):
- GAP - Nostro positioning target
```

---

### Passo 7: Identificare Differenziatori

**Nostri differenziatori** vs competitor:
- Cosa facciamo che loro non fanno?
- Cosa facciamo meglio?
- Qual è il nostro angle unico?

**Essere honesti**:
- Basare su evidenze, non wishful thinking
- Differenziatore deve essere **importante per utenti**
- Differenziatore deve essere **difendibile**

---

### Passo 8: Gap di Mercato e Opportunità

**Gap identificati**:
- Bisogni utenti non soddisfatti (da reviews competitor)
- Segment non serviti
- Price points scoperti
- Features richieste ma non disponibili

**⚠️ CRITICO - Ogni gap DEVE avere evidenze con link**:
- Gap identificato in reviews → **Link specifico**: [^N]: G2 Review mentioning gap - https://...
- Gap da Reddit/forum → **Link thread**: [^N]: Reddit discussion - https://reddit.com/...
- Gap da research report → **Link report**: [^N]: Market Research Report - https://...

**Opportunità per noi**:
- Come possiamo colmare questi gap
- Perché siamo posizionati per farlo

---

### Passo 9: Raccomandazioni Strategiche

**Positioning**: Come dovremmo posizionarci?
**Messaging**: Key message points
**Target Segment Priority**: Chi targetizzare per primi e perché?
**Competitive Strategy**: Come competere (differentiate, niche, cost leadership, etc)

---

### Passo 10: Creare competitor-analysis.md v1.0

Usa **Write tool** per creare il file usando template.

**Header**:
```markdown
# Competitor & Market Analysis: [PRODUCT NAME]

**Version**: 1.0
**Last Updated**: [Date]
**Analysis Type**: Complete
```

**⚠️ CRITICO - References Section**:
- **TUTTI i footnotes [^N] devono avere entry corrispondente** nella sezione References
- **Formato obbligatorio**: [^N]: [Titolo Fonte] - [URL Completo] - Accessed [Data]
- **Organizza per categoria** nella sezione Research Sources:
  - Primary Sources (siti ufficiali, docs)
  - Secondary Sources (reports, news)
  - User Feedback Sources (reviews, forum)
  - Company Data Sources (Crunchbase, LinkedIn)

**Vedi template**: `templates/competitor-analysis-template.md`

---

### Passo 11: Output all'Utente e Conferma

**Output in chat**:
```markdown
# Competitor Analysis Completa

Ho creato **competitor-analysis.md v1.0** - analisi competitiva completa.

## Competitor Analizzati

- [N] competitor diretti
- [N] competitor indiretti

## Competitor Profiles

1. [Competitor 1] - [Type] - [Positioning]
2. [Competitor 2] - [Type] - [Positioning]
[...]

## Key Findings

- Differenziatori principali: [lista]
- Gap di mercato: [lista]
- Positioning raccomandato: [descrizione]

## Prossimo passo

Rivedi **competitor-analysis.md**.
Documento utilizzabile per requirements, marketing, pitch deck.
```

**Poi AskUserQuestion**: "L'analisi competitor è completa?"

---

## Modalità B: Approfondimento Competitor Specifici

### Quando Usare
- Esiste già competitor-analysis.md
- Utente indica competitor specifici da approfondire
- Es. "Approfondisci Competitor X e Y"

### Processo

**Passo 1**: Leggi competitor-analysis.md esistente con Read tool

**Passo 2**: Identifica competitor da approfondire (da input utente)

**Passo 3**: WebSearch approfondito per quei competitor:
```
WebSearch: "[Competitor] detailed features list"
WebSearch: "[Competitor] pricing tiers breakdown"
WebSearch: "[Competitor] customer reviews 2024"
WebSearch: "[Competitor] vs [altro competitor] comparison"
```

**Passo 4**: Aggiorna sezioni con Edit tool:
- Competitor Profiles (più dettagli per competitor selezionati)
- Comparative Analysis (più righe feature se necessario)
- Competitive Landscape (insights aggiuntivi)

**Passo 5**: Aggiorna versioning:
- Version: v1.1 (o v1.2 se già v1.1)
- Last Updated: [Date]
- Analysis Type: "Deep-dive [Competitor Names]"

**Passo 6**: Output e conferma utente

---

## Modalità C: Aggiornamento Analisi Esistente

### Quando Usare
- Esiste competitor-analysis.md (datato)
- Utente richiede aggiornamento generale
- Es. "Aggiorna analisi competitor", "Ci sono novità nel mercato?"

### Processo

**Passo 1**: Leggi competitor-analysis.md esistente con Read tool

**Passo 2**: WebSearch per aggiornamenti:

**Per ogni competitor esistente**:
```
WebSearch: "[Competitor] news 2024"
WebSearch: "[Competitor] new features"
WebSearch: "[Competitor] pricing changes"
```

**Per nuovi competitor**:
```
WebSearch: "new [categoria prodotto] 2024"
WebSearch: "emerging [categoria prodotto] startups"
```

**Passo 3**: Identifica entità modifiche:
- **Modifiche minori** (solo update info esistenti) → v1.x+1
- **Modifiche maggiori** (nuovi competitor, cambio significativo mercato) → v2.0

**Passo 4**: Aggiorna tutte sezioni rilevanti con Edit tool:
- Competitor Profiles (info aggiornate)
- Comparative Analysis (nuove features, pricing changes)
- Positioning Map (se shift significativi)
- Market Gaps (se nuove opportunità)
- Raccomandazioni (se cambiano)

**Passo 5**: Aggiorna versioning appropriatamente

**Passo 6**: Output e conferma utente

---

## Strategia WebSearch Avanzata

### Keywords Efficaci

**Discovery (trovare competitor)**:
- "[categoria] competitors"
- "best [categoria] [anno corrente]"
- "top [categoria] tools"
- "alternatives to [product noto]"

**Deep-dive (dettagli competitor)**:
- "[Competitor] features"
- "[Competitor] pricing"
- "[Competitor] reviews"
- "[Competitor] vs [altro]"

**Trends (novità mercato)**:
- "[categoria] trends [anno]"
- "new [categoria] startups"
- "[categoria] funding [anno]"

### Fonti Affidabili

**Priorità (ordine di affidabilità)**:
1. Website ufficiale competitor
2. Review platforms (G2, Capterra, TrustRadius)
3. Product hunt, comparisons websites
4. News tech (TechCrunch, VentureBeat, etc)
5. Reddit, forum (per feedback utenti honest)

### Verificare Informazioni

- **Cross-reference** informazioni importanti (pricing, features)
- **Data recente** (preferire informazioni <6 mesi)
- **Fonti multiple** per claim importanti

---

## Versioning Guidelines

### v1.0 - Analisi Iniziale
- Prima analisi completa da zero
- Tutti competitor principali analizzati

### v1.1, v1.2, v1.3 - Update Minori
- Approfondimento competitor specifici
- Piccole correzioni
- Info aggiornate competitor esistenti

### v2.0 - Update Maggiore
- Nuovi competitor aggiunti (>2)
- Cambio significativo positioning market
- Re-analisi completa dopo tempo (>6 mesi)

### v3.0+ - Major Changes
- Pivot mercato
- Nuova categoria competitor

---

## Checklist: Analisi Completata

### Modalità A (Da Zero)
- [ ] WebSearch identificato 7-12 competitor
- [ ] Raccolte informazioni per 5-7 competitor principali
- [ ] **TUTTI i link tracciati durante WebSearch**
- [ ] Competitor Profiles completi con link a fonti
- [ ] Feature comparison matrix creata
- [ ] Pricing comparison creata con link a pricing pages
- [ ] Positioning map descritto
- [ ] Differenziatori identificati (oggettivamente)
- [ ] Gap di mercato identificati (supportati da evidenze CON LINK)
- [ ] Raccomandazioni strategiche formulate
- [ ] **Sezione References completa con TUTTI i footnotes**
- [ ] **Sezione Research Sources organizzata per categorie**
- [ ] competitor-analysis.md v1.0 creato
- [ ] Output fornito all'utente
- [ ] Conferma utente ricevuta

### Modalità B (Approfondimento)
- [ ] competitor-analysis.md esistente letto
- [ ] Competitor da approfondire identificati
- [ ] WebSearch approfondito effettuato
- [ ] **Link tracciati per nuove informazioni**
- [ ] Sezioni aggiornate con dettagli e link
- [ ] **References section aggiornata con nuovi link**
- [ ] Versioning aggiornato (v1.x+1)
- [ ] Output fornito all'utente
- [ ] Conferma utente ricevuta

### Modalità C (Aggiornamento)
- [ ] competitor-analysis.md esistente letto
- [ ] WebSearch per updates effettuato
- [ ] **Link tracciati per informazioni aggiornate**
- [ ] Nuovi competitor identificati (se presenti)
- [ ] Tutte sezioni rilevanti aggiornate
- [ ] **References section aggiornata**
- [ ] Versioning appropriato (v1.x o v2.0)
- [ ] Output fornito all'utente
- [ ] Conferma utente ricevuta

---

## Errori Comuni da Evitare

### ❌ Errore 1: Bias verso Nostro Prodotto
**Sbagliato**: Dipingere competitor come inferiori senza evidenze

**Corretto**: Analisi oggettiva, riconoscere punti forza competitor

### ❌ Errore 2: Informazioni Non Verificate
**Sbagliato**: Assumere pricing/features senza verificare

**Corretto**: WebSearch con fonti affidabili, cross-reference

### ❌ Errore 3: Troppi Competitor
**Sbagliato**: 15 competitor con dettagli superficiali

**Corretto**: 5-7 competitor principali con dettagli completi

### ❌ Errore 4: Differenziatori Vague
**Sbagliato**: "Migliore UX", "Più innovativo"

**Corretto**: Specifici e misurabili - "Solo tool con feature X", "50% più veloce su benchmark Y"

### ❌ Errore 5: Gap Non Supportati
**Sbagliato**: "Market vuole feature X" senza evidenze

**Corretto**: "Da 50+ reviews competitor A, utenti richiedono feature X[^10]" con link a G2

### ❌ Errore 6: Link Mancanti o Vaghi
**Sbagliato**: "Secondo G2..." senza link specifico, o "pricing verificato" senza URL

**Corretto**: "Competitor A costa $99/mese[^15]" con [^15]: Competitor A Pricing - https://competitorA.com/pricing - Accessed 2024-01-15

---

## Riepilogo Tool per Analisi Competitor

1. **WebSearch tool**: Identificare competitor, raccogliere informazioni (CRITICO)
2. **Read tool**: Leggere analisi esistente (modalità B/C)
3. **Write tool**: Creare competitor-analysis.md (modalità A)
4. **Edit tool**: Aggiornare competitor-analysis.md (modalità B/C)
5. **AskUserQuestion tool**: Chiarire modalità, conferme
6. **Output diretto**: Comunicare summary in chat (non tool)

**NON usare**:
- ❌ Write su file esistente (usa Edit)
- ❌ Edit senza Read prima
- ❌ Assumption senza WebSearch
- ❌ Procedere senza conferma utente
