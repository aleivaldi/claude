# Generazione Requirements Document

## Obiettivo

Creare **requirements.md** completo e dettagliato partendo da brief-structured.md e opzionalmente altri documenti di supporto.

**Caratteristiche requirements.md**:
- **Molto più completo di brief-structured** (4000-15000 parole vs 2000-3500)
- **Visione completa sistema** + **requisiti dettagliati solo per fase corrente**
- **Architettura dettagliata** con diagramma e elementi
- **Sottoprogetti parallelizzabili** con criticità e dipendenze
- **PoC critici** da validare (se applicabile)
- **Requisiti adattati** alla fase (PoC/MVP/Production)

---

## Overview del Processo

**Generazione requirements in 9 passi**:
1. **Passo 1** - Leggere brief-structured.md (obbligatorio)
2. **Passo 2** - Verificare presenza documenti opzionali
3. **Passo 3** - Integrare informazioni da tutti i documenti
4. **Passo 4** - Identificare fase corrente (PoC/MVP/Beta/Production)
5. **Passo 5** - Adattare requisiti alla fase
6. **Passo 6** - Creare requirements.md con template
7. **Passo 7** - Review completezza
8. **Passo 8** - Chiedere conferma utente
9. **Passo 9** - Iterare se necessario

---

## Tools da Usare

1. **Read** tool → Leggere brief-structured.md e documenti opzionali
2. **Write** tool → Creare requirements.md (prima volta)
3. **Edit** tool → Modificare requirements.md (iterazioni successive)
4. **AskUserQuestion** tool → Conferme e richiesta modifiche

---

## Processo Dettagliato

### Passo 1: Leggere brief-structured.md

Usa **Read tool** per leggere il brief strutturato completo.

Estrai:
- Problema e utenti
- Obiettivi e funzionalità
- Vincoli e assunzioni
- Scope MVP
- Criticità e rischi (se presenti)
- Workflow principali

⚠️ **IMPORTANTE**: brief-structured.md è l'input OBBLIGATORIO. Se non esiste, chiedi utente di crearlo prima con skill `generating-structured-brief`.

---

### Passo 2: Verificare Presenza Documenti Opzionali

Usa **Read tool** per verificare se esistono documenti opzionali da integrare:

**competitor-analysis.md**:
- Se esiste → Integrare nella sezione Competitive Landscape
- Se non esiste → Sezione Competitive Landscape basic (da brief-structured)

**research/** directory o altri .md files**:
- Chiedi utente: "Ci sono documenti di research tecnico o altri file da integrare?"
- Se sì → Leggi e integra dove rilevante

**Documenti da cercare**:
```
ls competitor-analysis.md 2>/dev/null
ls research/*.md 2>/dev/null
ls poc-*.md 2>/dev/null
```

---

### Passo 3: Integrare Informazioni da Tutti i Documenti

**Strategia di integrazione**:

**Da brief-structured.md** (base primaria):
- Problema, utenti, obiettivi → Sezioni 1-3
- Funzionalità → Input per sezione Requisiti
- Vincoli, assunzioni → Sezioni 9-10
- Scope MVP → Sezione 8

**Da competitor-analysis.md** (se presente):
- Competitor profiles → Sezione 1 (Competitive Landscape)
- Comparative analysis → Sezione 1 (Tabella comparativa)
- Differentiators → Sezione 1 (Vantaggio competitivo)

**Da research tecnico** (se presente):
- Validazioni tecniche → Sezione 7 (PoC)
- Scelte architetturali → Sezione 4 (Architettura)
- Benchmark performance → Sezione 3 (Requisiti non-funzionali)

---

### Passo 4: Identificare Fase Corrente

**Chiedi all'utente con AskUserQuestion** qual è la fase corrente:

```
Domanda: "Qual è la fase corrente del progetto?"

Opzioni:
- "PoC (Proof of Concept) - Validare fattibilità tecnica"
- "MVP - Validare valore con utenti reali"
- "Beta - Raffinare prodotto con early adopters"
- "Production - Sistema completo pronto per mercato"
```

**Questa informazione è CRITICA** perché determina:
- Quali requisiti non-funzionali includere
- Livello di dettaglio architettura
- Focus del documento

---

### Passo 5: Adattare Requisiti alla Fase

**Tabella Adattamento Requisiti**:

| Aspetto | PoC | MVP | Beta | Production |
|---------|-----|-----|------|------------|
| **Performance** | Non rilevante | <2 sec page load | <1.5 sec | <1 sec, P95 <2 sec |
| **Availability** | Best effort | Business hours | Extended hours | 99.9% uptime |
| **Security** | Basic auth | Standard (HTTPS, auth) | Enhanced | Production-grade, audit |
| **Scale** | 5-10 test users | 50-100 users | 500-1000 users | 10k+ concurrent |
| **Monitoring** | None/minimal | Basic logging | Monitoring + alerts | Full observability |
| **Testing** | Manual | Manual + basic auto | Automated suite | CI/CD + e2e tests |

**Esempi Adattamento**:

**PoC per Fattibilità Tecnica**:
```markdown
### Requisiti Non-Funzionali (per PoC)

| Aspetto | Requisito per PoC | Rationale |
|---------|-------------------|-----------|
| **Performance** | Non rilevante per questa fase | PoC valida fattibilità, non performance |
| **Availability** | Best effort, no SLA | Sufficiente per validazione tecnica |
| **Security** | Basic auth (username/password) | Adeguato per test interni |
| **Scale** | 5 utenti di test | Sufficiente per validare approccio tecnico |
```

**MVP per Validazione Valore**:
```markdown
### Requisiti Non-Funzionali (per MVP)

| Aspetto | Requisito per MVP | Rationale |
|---------|-------------------|-----------|
| **Performance** | Page load <2 sec | Esperienza utente accettabile |
| **Availability** | Business hours (9-6), best effort | Utenti MVP tollerano downtime limitato |
| **Security** | HTTPS, auth standard, DB encryption | Standard adeguato per dati MVP |
| **Scale** | 50-100 utenti concorrenti | Target MVP realistico |
```

---

### Passo 6: Creare requirements.md con Template

Usa **Write tool** per creare requirements.md usando il template completo.

**Sezioni da includere** (usa template come guida):

**SEMPRE Includi**:
1. Executive Summary e Visione
2. Target Market
3. Requisiti per Fase Corrente (adattati)
4. Architettura Sistema (con diagramma)
5. Scope
6. Vincoli
7. Metriche di Successo
8. Next Steps

**Includi SE APPLICABILE**:
- Competitive Landscape (sempre basic, approfondito se competitor-analysis.md)
- Dettaglio Elementi Sistema (se sistema complesso con 3+ elementi)
- Sottoprogetti e Parallelizzazione (se progetto grande, 3+ team)
- PoC e Validazioni Critiche (se PoC critici da validare)

**Vedi template completo**: `templates/requirements-template.md`

#### Diagramma Architettura

⚠️ **IMPORTANTE**: Il diagramma ASCII è OBBLIGATORIO, anche se semplice.

**Esempio semplice**:
```
┌─────────────┐
│   Web App   │
└──────┬──────┘
       │
       v
┌─────────────┐
│  Backend    │
└──────┬──────┘
       │
       v
┌─────────────┐
│  Database   │
└─────────────┘
```

**Esempio complesso**:
```
┌─────────────────┐          ┌──────────────────┐
│  Landing Page   │─────────>│   Backend API    │
└─────────────────┘          └────────┬─────────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    │                 │                 │
                    v                 v                 v
            ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
            │   Admin Web  │  │   Database   │  │ Monitoring   │
            └──────────────┘  └──────────────┘  └──────────────┘
                                      │
                                      v
                              ┌──────────────┐
                              │ IoT Devices  │
                              └──────────────┘
```

#### Dettaglio Elementi Sistema

**Usa strutture differenziate** per tipo di elemento:

**Web Application**:
- Descrizione, funzionalità principali
- Requisiti tecnici (frontend, autenticazione, integrazioni)
- Interfacce e API
- Utenti

**Backend Service**:
- Descrizione, responsabilità
- API endpoints principali
- Data model
- Integrazioni esterne
- Requisiti tecnici (scalability, availability, performance)

**Hardware (IoT Device)**:
- Descrizione, specifiche hardware
- Form factor, power, connectivity, sensori
- Componenti principali (must-have vs nice-to-have)
- Software/firmware
- Integrazione sistema
- Manufacturing e supply

**Landing Page / Marketing Website**:
- Descrizione, contenuti principali
- Requisiti tecnici (SEO, performance, analytics)
- Integrazioni

**Vedi template** per strutture complete di ogni tipo.

---

### Passo 7: Review Completezza

**Prima di procedere**, rivedi mentalmente il documento appena creato:

**Checklist Completezza**:
- [ ] TUTTE le informazioni da brief-structured.md sono presenti
- [ ] Informazioni da documenti opzionali integrate (se presenti)
- [ ] Fase corrente identificata e requisiti adattati
- [ ] Diagramma architettura presente (anche se semplice)
- [ ] Elementi sistema dettagliati (se applicabile)
- [ ] Sottoprogetti identificati (se applicabile)
- [ ] PoC critici documentati (se applicabile)
- [ ] Metriche di successo misurabili
- [ ] Next steps attuabili

**Checklist Qualità**:
- [ ] Documento stand-alone (leggibile senza altri documenti)
- [ ] Tono professionale
- [ ] No markers o riferimenti al processo
- [ ] Requisiti adattati alla fase (non over-engineering per PoC)
- [ ] Architettura chiara con diagramma
- [ ] Sottoprogetti con priorità e dipendenze (se presenti)

**Se trovi lacune**: Usa Edit tool per correggere prima di procedere.

---

### Passo 8: Chiedere Conferma Utente

Usa **AskUserQuestion** tool per chiedere conferma.

**Output all'utente in chat** (prima dell'AskUserQuestion):

```markdown
# Requirements Document Creato

Ho creato **requirements.md** - documento tecnico completo del progetto.

## Cosa contiene

- Executive summary e visione
- Competitive landscape [basic / approfondito da competitor-analysis]
- Target market [primary + secondary]
- Architettura sistema con diagramma ([N] elementi)
- [Se applicabile: Dettaglio [N] elementi sistema]
- [Se applicabile: [N] sottoprogetti parallelizzabili]
- [Se applicabile: [N] PoC critici da validare]
- Requisiti adattati per fase [PoC/MVP/Beta/Production]
- Scope, vincoli, metriche, next steps

## Fase Corrente: [PoC/MVP/Beta/Production]

Requisiti non-funzionali adattati per questa fase:
- Performance: [requisito]
- Availability: [requisito]
- Security: [requisito]
- Scale: [requisito]

[Se documenti integrati]
## Documenti Integrati

- brief-structured.md (base)
- competitor-analysis.md (sezione competitive)
- [altri documenti]

## Prossimo passo

Rivedi **requirements.md**.
È un documento tecnico completo utilizzabile per architettura, planning, decisioni tecniche.
```

**Poi usa AskUserQuestion**:
```
Domanda: "Il documento requirements riflette correttamente il progetto?"

Opzioni:
- "Sì, è completo"
- "Sì, ma voglio alcune modifiche"
- "No, ci sono errori o mancanze"
```

---

### Passo 9: Iterare se Necessario

Se l'utente richiede modifiche:

1. **Ascolta le modifiche** richieste
2. **Leggi requirements.md** con Read tool (sempre!)
3. **Usa Edit tool** per applicare modifiche specifiche
4. **Comunica in chat** cosa hai modificato
5. **Chiedi conferma di nuovo** con AskUserQuestion
6. **Ripeti** fino a quando l'utente approva

**Esempio Output Dopo Modifica**:
```markdown
# Modifiche Applicate a requirements.md

Ho aggiornato il documento con le tue richieste:

## Cosa ho modificato

- **[Sezione X]**: [Cosa cambiato e perché]
- **[Sezione Y]**: [Cosa cambiato e perché]

## Cosa ho aggiunto

- [Cosa aggiunto]

## Cosa ho rimosso

- [Cosa rimosso]

Rivedi di nuovo requirements.md.
```

---

## Gestione Input Multipli

### Caso A: Solo brief-structured.md
- Competitive landscape: Basic (da brief-structured)
- Architettura: Derivata da funzionalità e vincoli
- Documenti sufficienti per requirements completo

### Caso B: brief-structured + competitor-analysis
- Competitive landscape: Approfondito
- Sezione 1 molto più dettagliata
- Vantaggio competitivo chiaro

### Caso C: brief-structured + research tecnico
- PoC e validazioni: Dettagliati con risultati research
- Architettura: Informata da validazioni tecniche
- Sottoprogetti: Identificati da research

### Caso D: Tutti i documenti
- Requirements completo e dettagliato
- Ogni sezione arricchita da documenti pertinenti
- Massima completezza

---

## Adattamento Fase - Esempi Dettagliati

### Esempio PoC Fattibilità Tecnica

**Focus**: Validare che approccio tecnico funziona

**Requisiti Non-Funzionali**:
- Performance: "Non rilevante - PoC valida fattibilità"
- Availability: "Best effort - no SLA"
- Security: "Basic auth - test interni"
- Scale: "5 utenti di test"

**Sezioni Rilevanti**:
- ✅ Obiettivo PoC (cosa validare)
- ✅ PoC e Validazioni Critiche (criteri successo/fallimento)
- ✅ Architettura di massima
- ❌ Sottoprogetti (troppo presto)
- ❌ Metriche utente (non ci sono utenti reali)

### Esempio MVP Validazione Valore

**Focus**: Validare valore con 50-100 utenti reali

**Requisiti Non-Funzionali**:
- Performance: "<2 sec page load"
- Availability: "Business hours, best effort"
- Security: "Standard (HTTPS, auth, encryption)"
- Scale: "50-100 utenti concorrenti"

**Sezioni Rilevanti**:
- ✅ Tutti le sezioni
- ✅ Architettura dettagliata
- ✅ Elementi sistema core
- ✅ Metriche di successo utente
- ⚠️ Sottoprogetti (se team >3 persone)

### Esempio Production

**Focus**: Sistema completo per mercato

**Requisiti Non-Funzionali**:
- Performance: "<1 sec page load, P95 <2 sec"
- Availability: "99.9% uptime, 24/7"
- Security: "Production-grade, audit log, compliance"
- Scale: "10k+ utenti concorrenti"

**Sezioni Rilevanti**:
- ✅ TUTTE le sezioni
- ✅ Architettura completa e dettagliata
- ✅ Tutti gli elementi sistema
- ✅ Sottoprogetti con team assignments
- ✅ Monitoring, observability, disaster recovery

---

## Checklist: Generazione Completata

Prima di considerare la generazione completa, verifica:

### Documento requirements.md Creato
- [ ] File requirements.md creato con Write tool
- [ ] Tutte le sezioni obbligatorie presenti
- [ ] Sezioni opzionali incluse se applicabili
- [ ] Diagramma architettura presente
- [ ] Requisiti adattati alla fase corrente
- [ ] Tono professionale tecnico

### Qualità Contenuto
- [ ] Executive summary chiaro
- [ ] Visione articolata
- [ ] Competitive landscape (basic o approfondito)
- [ ] Target market dimensionato
- [ ] Architettura con diagramma leggibile
- [ ] Elementi sistema dettagliati (se applicabili)
- [ ] Sottoprogetti con priorità/criticità (se applicabili)
- [ ] PoC con criteri successo/fallimento (se applicabili)
- [ ] Requisiti adattati alla fase (no over-engineering)
- [ ] Metriche misurabili
- [ ] Next steps attuabili

### Processo Seguito
- [ ] brief-structured.md letto con Read tool
- [ ] Documenti opzionali verificati
- [ ] Fase corrente identificata (chiesto se non chiaro)
- [ ] Requisiti adattati alla fase
- [ ] Informazioni integrate da tutti i documenti
- [ ] Review completezza effettuata
- [ ] Output riepilogo fornito in chat
- [ ] AskUserQuestion usato per conferma
- [ ] Modifiche gestite con Edit tool (se richieste)
- [ ] Utente ha approvato esplicitamente

---

## Errori Comuni da Evitare

### ❌ Errore 1: Over-engineering per PoC
**Sbagliato**:
```markdown
### Requisiti Non-Funzionali (per PoC)
- Performance: <500ms response time, P99 <1 sec
- Availability: 99.9% uptime con disaster recovery
- Security: Multi-factor auth, encryption at rest, audit log
```

**Corretto**:
```markdown
### Requisiti Non-Funzionali (per PoC)
- Performance: Non rilevante per questa fase (PoC valida fattibilità tecnica)
- Availability: Best effort, no SLA (5 utenti di test)
- Security: Basic auth (username/password, test interni)
```

### ❌ Errore 2: Diagramma Mancante
**Sbagliato**: Nessun diagramma architettura

**Corretto**: Sempre includere diagramma ASCII, anche semplice

### ❌ Errore 3: Elementi Troppo Dettagliati per Progetto Semplice
**Sbagliato**: 5 pagine di dettaglio per semplice web app

**Corretto**: Dettaglio proporzionato a complessità

### ❌ Errore 4: Ignorare Documenti Opzionali
**Sbagliato**: Non chiedere se ci sono altri documenti

**Corretto**: Sempre verificare e chiedere all'utente

### ❌ Errore 5: Sottoprogetti per Progetto Piccolo
**Sbagliato**: Identificare 5 sottoprogetti per 1-2 persone

**Corretto**: Sottoprogetti solo se team grande (3+) o parallelizzazione chiara

---

## Riepilogo Tool per Generazione Requirements

1. **Read tool**: Leggere brief-structured.md e documenti opzionali
2. **AskUserQuestion tool**: Identificare fase corrente, conferme
3. **Write tool**: Creare requirements.md (prima volta)
4. **Edit tool**: Modificare requirements.md (iterazioni)
5. **Output diretto**: Comunicare summary in chat (non tool)

**NON usare**:
- ❌ Write su file esistente (usa Edit)
- ❌ Edit senza Read prima
- ❌ Procedere senza conferma utente
