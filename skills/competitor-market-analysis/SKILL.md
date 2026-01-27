---
name: competitor-market-analysis
description: Analizza competitor e posizionamento di mercato. Input flessibile - descrizione prodotto + opzionalmente analisi esistenti da approfondire + competitor specifici da analizzare. Usa WebSearch per identificare competitor diretti/indiretti, confronta features/pricing/target, analizza positioning, identifica differenziatori e gap di mercato. Output competitor-analysis.md con versioning. Utile standalone per requirements, marketing, pitch deck, business plan, valutazione strategica. 3 modalità - da zero, approfondimento competitor specifici, aggiornamento analisi esistente.
---

# Competitor & Market Analysis

## Il Tuo Compito

Analizza competitor e posizionamento di mercato creando **competitor-analysis.md** utilizzabile per requirements, marketing, pitch deck, business plan.

**Input Flessibile**:
- **Descrizione prodotto** (testuale o file) - SEMPRE necessario
- **competitor-analysis.md esistente** (opzionale) - Per approfondimento o aggiornamento
- **Competitor specifici** (opzionale) - Focus su competitor indicati dall'utente
- **Analisi parziali** (opzionale) - Research precedente da integrare

**Output**: competitor-analysis.md con:
- Competitor profiles (3-7 competitor principali)
- Comparative analysis (tabella features/pricing)
- Positioning map
- Differenziatori competitivi
- Gap di mercato e opportunità
- Raccomandazioni strategiche
- Versioning (v1.0, v1.1, v2.0)

---

## Modalità Operative

Questa skill opera in **3 modalità** basate sull'input:

### Modalità A: Analisi Da Zero
**Input**: Solo descrizione prodotto/progetto
**Processo**: WebSearch completo per identificare competitor, analisi approfondita
**Output**: competitor-analysis.md v1.0 (nuovo)

### Modalità B: Approfondimento Competitor Specifici
**Input**: competitor-analysis.md esistente + competitor specifici da approfondire
**Processo**: Focus su competitor indicati, WebSearch approfondito per quelli
**Output**: competitor-analysis.md v1.1 (aggiornamento minore)

### Modalità C: Aggiornamento Analisi Esistente
**Input**: competitor-analysis.md esistente (da aggiornare)
**Processo**: WebSearch per nuove informazioni, aggiorna competitor profiles
**Output**: competitor-analysis.md v1.2 o v2.0 (a seconda dell'entità modifiche)

---

## Quando Usare Questa Skill

**Usa questa skill quando**:
- Serve **analisi competitor** per requirements document
- Necessiti **positioning competitivo** per pitch deck
- Devi preparare **market analysis** per business plan
- Vuoi **valutare mercato** prima di investire in progetto
- Hai **competitor specifici** da approfondire
- Devi **aggiornare** analisi competitor esistente

**Casi d'uso**:
- Requirements: Sezione Competitive Landscape
- Marketing: Messaging e positioning
- Pitch Deck: Competitive analysis slide
- Business Plan: Market analysis
- Strategia: Identificare gap di mercato

---

## WebSearch Abilitato

⚠️ **Questa skill usa WebSearch** per:
- Identificare competitor diretti e indiretti
- Raccogliere informazioni su features, pricing, target market
- Verificare positioning attuale dei competitor
- Trovare recensioni e feedback utenti
- Identificare trend di mercato

**Strategia WebSearch**:
- Keywords generiche per identificare competitor
- Keywords specifiche per dettagli (pricing, features)
- Focus su fonti affidabili (website ufficiali, review platforms, news)

---

## Output con Versioning

**competitor-analysis.md** supporta versioning per aggiornamenti incrementali:

**v1.0**: Analisi iniziale completa
**v1.1, v1.2**: Approfondimenti minori (es. dettaglio competitor specifico)
**v2.0**: Update maggiore (es. nuovi competitor, cambio positioning)

**Formato header**:
```markdown
# Competitor & Market Analysis: [PRODUCT NAME]

**Version**: 1.0
**Last Updated**: [Date]
**Analysis Type**: Complete / Deep-dive / Update
```

---

## Processo Rapido

### Modalità A - Da Zero
1. **Ricevi descrizione** prodotto/progetto
2. **WebSearch** per identificare competitor (keywords generiche + specifiche)
3. **Raccogli informazioni** su 5-10 competitor identificati
4. **Analizza** features, pricing, target, positioning
5. **Crea comparative table**
6. **Identifica differenziatori** e gap di mercato
7. **Scrivi raccomandazioni** strategiche
8. **Output competitor-analysis.md v1.0**

### Modalità B - Approfondimento
1. **Leggi** competitor-analysis.md esistente
2. **Identifica competitor** da approfondire (da input utente)
3. **WebSearch approfondito** per quei competitor
4. **Aggiorna** sezioni Competitor Profiles e Comparative Analysis
5. **Output competitor-analysis.md v1.1**

### Modalità C - Aggiornamento
1. **Leggi** competitor-analysis.md esistente
2. **WebSearch** per nuove informazioni su competitor esistenti
3. **Identifica** eventuali nuovi competitor entrati nel mercato
4. **Aggiorna** tutte le sezioni rilevanti
5. **Output competitor-analysis.md v1.2 o v2.0**

**Per dettagli completi del processo**: Vedi `analysis-process.md`

---

## Materiali di Riferimento

**Processi Dettagliati**:
- `analysis-process.md` - Processo completo per 3 modalità, strategia WebSearch, metodologia analisi

**Template**:
- `templates/competitor-analysis-template.md` - Struttura completa, esempi per diversi tipi prodotto

---

## Regole Chiave

### Input Flessibile
- **Descrizione prodotto**: Può essere testuale in chat o file .md
- **Analisi esistente**: Se presente, determina modalità B o C
- **Competitor specifici**: Se indicati, focus su quelli (modalità B)

### WebSearch Strategico
- Usa keywords **generiche** per discovery ("project management SaaS competitors")
- Usa keywords **specifiche** per dettagli ("Asana pricing tiers")
- Verifica **fonti multiple** per informazioni accurate
- Focus su **informazioni pubbliche** (no assumptions non verificabili)

### Obiettività
- **Evita bias** verso nostro prodotto
- **Analizza oggettivamente** punti forza competitor
- **Identifica realmente** dove siamo differenti (no marketing fluff)
- **Gap di mercato** deve essere supportato da evidenze

### References & Link Tracking
- **CRITICO**: Traccia TUTTI i link durante WebSearch
- **Footnotes**: Usa [^N] per riferimenti numerati nel documento
- **Link inline**: Includi URL diretti dove rilevante (pricing pages, feature docs)
- **Sezione References**: Ogni [^N] deve avere corrispondente entry nell'Appendix
- **Formato reference**: [^N]: [Titolo Fonte] - [URL Completo] - Accessed [Date]
- **Tipi di link da tracciare**:
  - Market data e statistiche (size, growth, trends)
  - Company data (funding, user numbers, founding date)
  - Features (link a documentazione ufficiale)
  - Pricing (link diretto a pricing page con data verifica)
  - Reviews (G2, Capterra, Reddit threads specifici)
  - News articles (funding, product launches, etc)
  - Competitor profiles (website, Crunchbase, LinkedIn)

### Versioning
- **v1.0**: Analisi nuova completa
- **v1.x**: Update minori (approfondimenti, piccole modifiche)
- **v2.0**: Update maggiore (nuovi competitor, cambio significativo mercato)

### Riutilizzo
- competitor-analysis.md è **standalone** (non dipende da altri file)
- Usabile per **requirements, marketing, pitch, business plan**
- Formattazione **professionale** condivisibile con stakeholder

---

## Uso Tool (⚠️ SEQUENZA CRITICA)

- ✅ **SEMPRE** WebSearch per raccogliere informazioni competitor
- ✅ Read per leggere analisi esistente (modalità B/C)
- ✅ Write per creare nuovo file (modalità A)
- ✅ Edit per aggiornare file esistente (modalità B/C)
- ✅ AskUserQuestion se modalità non chiara

---

## Gestione Errori

**Se descrizione prodotto vaga**:
- Chiedi utente: "Puoi fornire più dettagli sul prodotto? (es. tipo, target market, problema risolto)"

**Se WebSearch non trova competitor**:
- Prova keywords alternative
- Chiedi utente: "Ho difficoltà a trovare competitor diretti. Conosci già qualche competitor o prodotto simile?"

**Se modalità non chiara**:
- Usa AskUserQuestion: "Vuoi analisi da zero o aggiornare analisi esistente?"

**Se competitor specifici menzionati ma non trovati**:
- WebSearch con nome esatto competitor
- Chiedi utente: "Non trovo [Competitor X]. Hai un link o più informazioni?"

---

## Output Finale

Il deliverable di questa skill è **competitor-analysis.md**: un documento di analisi competitiva standalone, riutilizzabile per:
- **Requirements**: Sezione Competitive Landscape approfondita
- **Marketing**: Messaging e positioning strategico
- **Pitch Deck**: Slide competitive analysis
- **Business Plan**: Market analysis section
- **Strategia**: Identificare opportunità mercato e gap
