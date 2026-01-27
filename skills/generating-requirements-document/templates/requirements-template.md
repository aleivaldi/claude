# Template Requirements Document

⚠️ **IMPORTANTE**: Questo template è FLESSIBILE. Non tutte le sezioni devono essere presenti - includi solo quelle pertinenti al progetto e alla fase corrente.

## Caratteristiche del Documento

Il requirements.md deve essere:
- **Molto più completo di brief-structured** (4000-15000 parole vs 2000-3500)
- **Visione completa + requisiti per fase corrente** - Descrive visione completa ma requisiti dettagliati solo per fase (PoC/MVP/Production)
- **Tecnico ma accessibile** - Dettaglio tecnico appropriato, leggibile da stakeholder
- **Attuabile** - Informazioni sufficienti per architettura, planning, decisioni
- **Flessibile** - Adatta struttura a complessità progetto

---

## Quali Sezioni Includere

### Sezioni Sempre Necessarie
1. **Executive Summary e Visione** - Sempre
2. **Target Market** - Sempre (secondary opzionale)
3. **Requisiti per Fase Corrente** - Sempre (adattati a PoC/MVP/Production)
4. **Architettura Sistema** - Sempre (con diagramma)
5. **Scope** - Sempre
6. **Vincoli** - Sempre
7. **Metriche di Successo** - Sempre
8. **Next Steps** - Sempre

### Sezioni Solitamente Necessarie
- **Competitive Landscape** - Sempre basic, anche se competitor-analysis.md è disponibile ne deve essere una sintesi
- **Dettaglio Elementi Sistema** - Se sistema complesso (3+ elementi)
- **Assunzioni e Domande Aperte** - Se assunzioni significative o decisioni da prendere

### Sezioni Opzionali (solo se applicabili)
- **Sottoprogetti e Parallelizzazione** - Solo se progetto grande (3+ sottoprogetti, team multipli)
- **PoC e Validazioni Critiche** - Solo se PoC critici da validare
- **Secondary Market** - Solo se esiste mercato secondario chiaro

---

## Struttura Template

```markdown
# Requirements: [PROJECT NAME]

**Phase**: PoC / MVP / Beta / Production
**Version**: 1.0 (incrementa dopo modifiche significative)
**Last Updated**: [Date]
**Status**: Draft / In Review / Approved

---

## 1. Executive Summary e Visione
[SEMPRE NECESSARIA]

### Executive Summary

[2-3 paragrafi sintetici - ~200 parole]

Cos'è il progetto:
[1-2 frasi che spiegano cos'è il prodotto/sistema]

Quale problema risolve:
[Chi ha il problema, gravità, impatto]

Quale valore genera:
[Business value, user value, market impact]

Fase corrente e obiettivo:
[PoC/MVP/Beta/Production - cosa vogliamo ottenere in questa fase]

### Visione

[Visione a lungo termine del prodotto/sistema completo - ~200 parole]
[Come sarà il sistema quando completamente realizzato?]
[Quale impatto avrà sugli utenti, sul mercato, sul business?]

### Competitive Landscape
[OPZIONALE - Basic sempre, approfondito solo se competitor-analysis.md disponibile]

**Competitor Principali** (se conosciuti):
- **[Competitor 1]**: [Breve descrizione - 1 frase]
- **[Competitor 2]**: [Breve descrizione - 1 frase]
- **[Competitor 3]**: [Breve descrizione - 1 frase]

**Il Nostro Vantaggio Competitivo**:
[Cosa ci differenzia e perché è importante - 2-3 frasi]

[Se competitor-analysis.md disponibile, includere anche:]
- Tabella comparativa features/pricing
- Positioning map
- Gap di mercato identificati

---

## 2. Target Market
[SEMPRE NECESSARIA]

### Primary Market

**Descrizione**: [Chi è il mercato primario target]
**Dimensionamento**: [Dimensione del mercato - ordine di grandezza, se noto]
**Caratteristiche Principali**: [Caratteristiche demografiche/psicografiche/tecnografiche]
**Accessibilità**: [Quanto è accessibile per noi - canali, go-to-market]

### Secondary Market
[OPZIONALE - Solo se esiste mercato secondario chiaro]

**Descrizione**: [Chi è il mercato secondario]
**Quando**: [Quando prevediamo di targetizzarlo - post-MVP, v2, ecc]

---

## 3. Requisiti per Fase Corrente: [PoC / MVP / Beta / Production]
[SEMPRE NECESSARIA]

### Obiettivo di Questa Fase

[Cosa vogliamo ottenere in QUESTA fase specifica - 2-3 frasi]

**Esempi**:
- PoC → Validare fattibilità tecnica di [approccio X]
- MVP → Validare valore con 50 utenti reali in [contesto Y]
- Beta → Raffinare UX e scalare a 500 utenti
- Production → Sistema completo pronto per mercato

### Focus Tecnico per Questa Fase

**Importante in questa fase**:
[Cosa è critico per questa fase]

**Non importante in questa fase** (rimandato):
[Cosa può essere rimandato e perché]

### Utenti Target per Questa Fase

**Primary Users**:
- **Role/Type**: [Descrizione del ruolo]
- **Count**: [Ordine di grandezza per questa fase: 5 per PoC, 50 per MVP, 500 per Beta, etc]
- **Technical Skill**: [Non-tecnico / Intermedio / Avanzato]
- **Environment**: [Desktop / Mobile / Field / Mixed]
- **Context**: [Dove e quando usano il sistema]

**User Scenarios** (principali per questa fase):

**Main Workflow**:
1. User [action]
2. System [response]
3. User [action]
4. System [result]

[Descrivere 1-3 workflow principali - ~100 parole ciascuno]

### Requisiti Funzionali (per questa fase)

**Feature 1: [Nome]**
- **What**: [Descrizione chiara e semplice]
- **Why**: [Quale problema risolve per utenti]
- **User Experience**: [Come l'utente la sperimenta]
- **Acceptance Criteria**: [Criteri misurabili per considerarla completa]
- **Priority**: Must-Have / Should-Have / Nice-to-Have

**Feature 2: [Nome]**
[Stessa struttura]

**Feature 3: [Nome]**
[Stessa struttura]

[Tipicamente 3-7 features per fase MVP, meno per PoC, più per Production]

### Requisiti Non-Funzionali (per questa fase)

⚠️ **IMPORTANTE**: Questi requisiti dipendono dalla FASE. Adatta i valori appropriatamente.

| Aspetto | Requisito per Questa Fase | Rationale |
|---------|---------------------------|-----------|
| **Performance** | [es. "Non rilevante per PoC" o "<2 sec" per MVP o "<1 sec, P95 <2s" per Production] | [Perché questo livello è adeguato] |
| **Availability** | [es. "Best effort" per PoC, "Business hours" per MVP, "99.9%" per Production] | [Perché questo livello è adeguato] |
| **Scale** | [es. "5 utenti" per PoC, "50-100" per MVP, "10k+" per Production] | [Perché questo livello è adeguato] |
| **Security** | [es. "Basic auth" per PoC, "Standard" per MVP, "Production-grade" per Production] | [Perché questo livello è adeguato] |
| **Platform** | [es. "Web desktop only" per MVP, "Web + mobile" per Production] | [Perché questo è sufficiente] |
| **Data** | [es. "Non persistente" per PoC, "Backups daily" per MVP, "HA + DR" per Production] | [Perché questo livello è adeguato] |
| **Monitoring** | [es. "None" per PoC, "Basic logging" per MVP, "Full observability" per Production] | [Perché questo livello è adeguato] |
| **Testing** | [es. "Manual" per PoC, "Manual + basic auto" per MVP, "CI/CD + e2e" per Production] | [Perché questo livello è adeguato] |

---

## 4. Architettura Sistema
[SEMPRE NECESSARIA]

### Visione Architetturale Completa

[Descrizione narrativa dell'architettura complessiva del sistema - ~200 parole]
[Come i vari elementi si collegano tra loro]
[Scelte architetturali principali e rationale]

### Diagramma Alto Livello

⚠️ **OBBLIGATORIO**: Includere sempre un diagramma ASCII, anche se semplice.

```
[ASCII art o descrizione testuale dei moduli e connessioni]

Esempio semplice:

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

Esempio complesso:

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

### Elementi del Sistema

Il sistema è composto dai seguenti elementi (vedi Sezione 5 per dettagli):

1. **[Nome Elemento 1]** - [Tipo: Web App / Backend / Hardware / Landing / etc]
2. **[Nome Elemento 2]** - [Tipo]
3. **[Nome Elemento 3]** - [Tipo]
[...]

### Flussi Dati Principali

**Flusso 1: [Nome - es. "User Registration"]**
[Descrizione del flusso dati attraverso gli elementi - 2-3 frasi]

**Flusso 2: [Nome - es. "Data Processing Pipeline"]**
[Descrizione del flusso dati attraverso gli elementi - 2-3 frasi]

[Descrivere 2-4 flussi principali]

---

## 5. Dettaglio Elementi Sistema
[OPZIONALE - Solo se sistema complesso con 3+ elementi distinti]

[NOTA: Ogni elemento ha un sottocapitolo dedicato con struttura adattata al tipo]

### 5.1 [Nome Elemento - es. "Sito Web Amministrazione"]

**Tipo**: Software - Web Application
**Priorità nella Fase Corrente**: Critica / Alta / Media / Bassa
**Status**: Da Iniziare / In Corso / Completato

#### Descrizione

[Descrizione dettagliata dell'elemento - ~150 parole]
[Scopo e funzione nel sistema complessivo]

#### Funzionalità Principali

- **[Funzionalità 1]**: [Descrizione - 1 frase]
- **[Funzionalità 2]**: [Descrizione - 1 frase]
- **[Funzionalità 3]**: [Descrizione - 1 frase]

#### Requisiti Tecnici

- **Frontend**: [Tecnologie/approccio - es. "SPA moderna", "Server-side rendering"]
- **Autenticazione**: [Approccio autenticazione]
- **Integrazioni**: [Con quali altri elementi si integra]
- **Data Storage**: [Dove/come memorizza i dati]

#### Interfacce e API

**API Esposte**:
- [Endpoint/interfaccia esposta - se applicabile]

**API Consumate**:
- [Servizi/API che questo elemento consuma]

#### Utenti

[Chi usa questo elemento e come - 2-3 frasi]

---

### 5.2 [Nome Elemento - es. "Dispositivo IoT"]

**Tipo**: Hardware - IoT Device
**Priorità nella Fase Corrente**: Critica / Alta / Media / Bassa
**Status**: Da Iniziare / In Corso / Completato

#### Descrizione

[Descrizione dettagliata del dispositivo hardware - ~150 parole]
[Scopo e funzione nel sistema complessivo]

#### Specifiche Hardware

**Form Factor**: [Dimensioni, peso, design industriale]
**Power**: [Alimentazione: batteria/cavo, autonomia target]
**Connectivity**: [WiFi / Bluetooth / Cellular / LoRa / etc]
**Sensori/Attuatori**: [Quali sensori/attuatori include]
**Processore**: [Tipo di processore/microcontrollore]
**Memoria**: [RAM, Storage]
**Environmental**: [Temperatura operativa, IP rating, etc]

#### Componenti Principali

**Must-Have per Fase Corrente**:
- [Componente 1]
- [Componente 2]
- [Componente 3]

**Nice-to-Have** (fasi future):
- [Componente opzionale]

#### Software/Firmware

**Firmware**: [Descrizione firmware embedded]
**Update Mechanism**: [Come viene aggiornato il firmware]

#### Integrazione Sistema

**Connessione Backend**: [Come comunica con backend/cloud]
**Protocollo Comunicazione**: [MQTT / HTTP / CoAP / etc]
**Frequenza Trasmissione**: [Quanto spesso invia dati]

#### Manufacturing e Supply

**Sourcing Componenti**: [Dove si acquistano i componenti]
**Assembly**: [Interno o outsourced]
**Cost Target**: [BOM cost target per unità]
**Volume Iniziale**: [Quanti pezzi per fase corrente]

---

### 5.3 [Nome Elemento - es. "Backend API"]

**Tipo**: Software - Backend Service
**Priorità nella Fase Corrente**: Critica / Alta / Media / Bassa
**Status**: Da Iniziare / In Corso / Completato

#### Descrizione

[Descrizione dettagliata del backend - ~150 parole]
[Scopo e funzione nel sistema complessivo]

#### Responsabilità

- **[Responsabilità 1]**: [Descrizione]
- **[Responsabilità 2]**: [Descrizione]
- **[Responsabilità 3]**: [Descrizione]

#### API Endpoints Principali

**Endpoint 1**: `[METHOD] /path`
- **Purpose**: [Scopo]
- **Input**: [Parametri]
- **Output**: [Risposta]

**Endpoint 2**: `[METHOD] /path`
[Stessa struttura]

[Elencare 5-10 endpoints principali]

#### Data Model

[Schema dati principale o entità gestite]
[Può essere descrittivo o diagramma ER semplificato]

#### Integrazioni Esterne

- **[Servizio 1]**: [Perché e come integrato]
- **[Servizio 2]**: [Perché e come integrato]

#### Requisiti Tecnici

**Scalability**: [Requisiti di scala per fase corrente]
**Availability**: [Requisiti di availability per fase corrente]
**Performance**: [Requisiti di performance per fase corrente]

---

### 5.4 [Nome Elemento - es. "Landing Page"]

**Tipo**: Software - Marketing Website
**Priorità nella Fase Corrente**: Media / Bassa
**Status**: Da Iniziare / In Corso / Completato

#### Descrizione

[Descrizione della landing page - ~100 parole]
[Obiettivo marketing/acquisizione]

#### Contenuti Principali

- **Hero Section**: [Messaggio principale]
- **Value Proposition**: [Perché gli utenti dovrebbero usare il prodotto]
- **Features Highlight**: [Features chiave da evidenziare]
- **Call-to-Action**: [Azione principale richiesta]

#### Requisiti Tecnici

**SEO**: [Requisiti SEO se applicabili]
**Performance**: [Target di performance - es. "Lighthouse score >90"]
**Analytics**: [Tracking e analytics richiesti]

#### Integrazioni

- **[Servizio 1]**: [es. "Email marketing platform"]
- **[Servizio 2]**: [es. "Analytics"]

---

## 6. Sottoprogetti e Parallelizzazione
[OPZIONALE - Solo se progetto grande con 3+ sottoprogetti o team multipli]

### Overview

[Descrizione di come il lavoro può essere parallelizzato tra team - 2-3 frasi]
[Identificazione dipendenze critiche]

### Sottoprogetto 1: [Nome]

**Criticità**: 🔴 Alta / 🟡 Media / 🟢 Bassa
**Priorità**: P0 (Bloccante) / P1 (Importante) / P2 (Nice-to-have)
**Sfide Tecniche Principali**: [Se presenti - altrimenti "Nessuna sfida tecnica significativa"]

**Descrizione**:
[Descrizione basilare del sottoprogetto - 2-3 frasi]

**Deliverable**:
- [Deliverable 1]
- [Deliverable 2]

**Dipendenze**:
- Dipende da: [Altri sottoprogetti da cui dipende]
- Bloccante per: [Altri sottoprogetti che dipendono da questo]

**Team Suggerito**:
- [Competenze necessarie - es. "1 fullstack, 1 designer"]

**Timeline Stimata**: [Tempo stimato - es. "2-3 settimane"]

**Rischi Specifici**:
[Eventuali rischi specifici di questo sottoprogetto]

---

### Sottoprogetto 2: [Nome]
[Stessa struttura del Sottoprogetto 1]

---

### Grafo Dipendenze

```
[Rappresentazione testuale delle dipendenze tra sottoprogetti]

Esempio:

Sottoprogetto 1 (Backend API)
    │
    ├──> Sottoprogetto 2 (Web Admin)
    │
    └──> Sottoprogetto 3 (Mobile App)

Sottoprogetto 4 (Landing Page) [PARALLELO - no dipendenze]
```

---

## 7. PoC e Validazioni Critiche
[OPZIONALE - Solo se ci sono PoC critici da validare]

### PoC 1: [Nome - es. "Validazione Algoritmo ML"]

**Obiettivo**: [Cosa deve validare questo PoC - 1-2 frasi]

**Descrizione**:
[Descrizione del PoC - 2-3 paragrafi, ~150 parole]

**Criteri di Successo** (trigger per procedere):
- [Criterio 1 - misurabile]
- [Criterio 2 - misurabile]
- [Criterio 3 - misurabile]

**Criteri di Fallimento** (trigger per pivot):
- [Cosa indicherebbe che l'approccio non funziona]

**Timeline**: [Quanto tempo per completare il PoC]

**Risorse Necessarie**: [Team, strumenti, budget]

**Deliverable**: [Cosa viene prodotto dal PoC]

**Prossimi Passi se Successo**: [Cosa succede se PoC ha successo]

**Prossimi Passi se Fallimento**: [Cosa succede se PoC fallisce - pivot? alternative?]

---

### PoC 2: [Nome]
[Stessa struttura del PoC 1]

---

## 8. Scope
[SEMPRE NECESSARIA]

### Incluso nella Fase Corrente

- [Elemento/feature/capability incluso]
- [Elemento/feature/capability incluso]
- [Elemento/feature/capability incluso]

[Lista concisa - 5-10 items]

### Esplicitamente NON Incluso (Fase Corrente)

- [Feature esclusa] → [Rationale: perché non ora]
- [Feature esclusa] → [Rationale: perché non ora]
- [Feature esclusa] → [Rationale: perché non ora]

[Essere espliciti - "Nessuna integrazione terze parti in v1" meglio di "Integrazioni future"]

### Roadmap Fasi Future

**Fase Successiva** ([Nome fase - es. "MVP" se ora è PoC]):
- [Enhancement/feature pianificato]
- [Enhancement/feature pianificato]

**Long-term** (12-24 mesi):
- [Visione long-term]
- [Visione long-term]

---

## 9. Vincoli
[SEMPRE NECESSARIA]

### Risorse

- **Team**: [Composizione team - es. "2 fullstack, 1 designer, 1 PM"]
- **Timeline**: [Timeline per fase corrente - es. "3 mesi a MVP"]
- **Budget**: [Se rilevante - es. "Budget limitato, cost-conscious"]

### Tecnici

- **Piattaforme**: [Vincoli di piattaforma - es. "Web-first, no native apps v1"]
- **Tecnologie**: [Tecnologie richieste o da evitare]
- **Integrazioni**: [Sistemi con cui deve integrarsi]
- **Compliance**: [Requisiti compliance - GDPR, HIPAA, etc]

### Organizzativi

- **Approvazioni**: [Chi deve approvare cosa]
- **Skill Gaps**: [Competenze mancanti nel team]
- **Processi**: [Processi aziendali da rispettare]

---

## 10. Assunzioni e Domande Aperte
[SOLITAMENTE NECESSARIA]

### Assunzioni Chiave

[NOTA: Queste sono assunzioni DI PROGETTO, non scelte tecniche]

| Assunzione | Se Sbagliata | Come Lo Sapremo | Mitigazione |
|-----------|--------------|-----------------|-------------|
| [Assunzione 1] | [Impatto se incorretta] | [Segnale/metrica da monitorare] | [Come mitigare se sbagliata] |
| [Assunzione 2] | [Impatto se incorretta] | [Segnale/metrica da monitorare] | [Come mitigare se sbagliata] |
| [Assunzione 3] | [Impatto se incorretta] | [Segnale/metrica da monitorare] | [Come mitigare se sbagliata] |

[3-6 assunzioni principali]

### Domande da Validare Presto

Queste domande impattano roadmap e priorità:

- [ ] [Domanda che influenza direzione tecnica]
- [ ] [Domanda che influenza priorità features]
- [ ] [Domanda che influenza architettura]

[3-5 domande]

### Decisioni Aperte

- **[Topic 1]**: [Cosa stiamo rimandando e perché]
- **[Topic 2]**: [Cosa stiamo rimandando e perché]

[Solo decisioni veramente posticipabili]

---

## 11. Metriche di Successo
[SEMPRE NECESSARIA]

### Metriche per Fase Corrente

Come misuriamo il successo di QUESTA fase:

| Metrica | Misurazione | Target | Owner |
|---------|-------------|--------|-------|
| [Metrica 1] | [Come misuriamo concretamente] | [Target numerico specifico] | [Chi è responsabile] |
| [Metrica 2] | [Come misuriamo concretamente] | [Target numerico specifico] | [Chi è responsabile] |
| [Metrica 3] | [Come misuriamo concretamente] | [Target numerico specifico] | [Chi è responsabile] |

[5-8 metriche principali]

**Esempi**:
- PoC: "Algoritmo raggiunge 85% accuracy su dataset test", "PoC completato in 4 settimane"
- MVP: "50 utenti attivi dopo 1 mese", "NPS >40", "80% task completion rate"
- Production: "10k utenti attivi", "99.9% uptime", "Revenue $X/mese"

### Metriche Long-term
[OPZIONALE - Solo se utile distinguerle da metriche fase corrente]

---

## 12. Next Steps
[SEMPRE NECESSARIA]

### Azioni Immediate

- [ ] Approvazione stakeholder di questo documento
- [ ] Condivisione con team design
- [ ] Condivisione con team development
- [ ] Setup ambiente di sviluppo
- [ ] [Altra azione immediata]

[5-10 azioni immediate]

### Timeline Fase Corrente

| Quando | Milestone | Owner | Note |
|--------|-----------|-------|------|
| Week 1-2 | [Milestone 1] | [Owner] | [Note] |
| Week 3-4 | [Milestone 2] | [Owner] | [Note] |
| Week 5-6 | [Milestone 3] | [Owner] | [Note] |
| Week 7-8 | [Milestone 4] | [Owner] | [Note] |

[Timeline realistico per fase corrente]

### Rischi e Mitigazioni

| Rischio | Likelihood | Impact | Mitigation | Owner |
|---------|-----------|--------|-----------|-------|
| [Rischio 1] | L/M/H | L/M/H | [Come mitigare] | [Chi] |
| [Rischio 2] | L/M/H | L/M/H | [Come mitigare] | [Chi] |
| [Rischio 3] | L/M/H | L/M/H | [Come mitigare] | [Chi] |

[5-8 rischi principali]

---

## Appendix

### Glossary
[OPZIONALE - Solo se termini tecnici o domain-specific da definire]

[Termini e definizioni]

### Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Author] | Initial version |

### Riferimenti
[OPZIONALE - Link a documenti correlati, PoC, research]

- [Documento correlato 1]
- [Documento correlato 2]

```

---

## Linee Guida per Sezioni

### 1. Executive Summary e Visione
**Lunghezza**: ~400-500 parole totali
**Tono**: Chiaro, accessibile a stakeholder non-tecnici
**Focus**: Problema, valore, visione, competitive positioning

### 2. Target Market
**Lunghezza**: ~200-300 parole
**Includere**: Primary sempre, secondary solo se chiaro
**Evitare**: Stime di mercato non supportate

### 3. Requisiti per Fase Corrente
**Lunghezza**: ~1000-1500 parole (sezione più grande)
**Funzionali**: 3-7 features, ognuna con What/Why/UX/Acceptance Criteria
**Non-Funzionali**: Adattati alla fase (PoC molto diverso da Production)
**Focus**: Fase corrente, no over-engineering

### 4. Architettura Sistema
**Lunghezza**: ~400-600 parole + diagramma
**Diagramma**: OBBLIGATORIO, anche se semplice
**Essere chiari**: Elementi identificabili, connessioni evidenti

### 5. Dettaglio Elementi Sistema
**Lunghezza**: ~300-500 parole per elemento
**Quando includere**: Solo se sistema complesso (3+ elementi)
**Strutture differenziate**: Web App ≠ Backend ≠ Hardware ≠ Landing

### 6. Sottoprogetti e Parallelizzazione
**Lunghezza**: ~200-300 parole per sottoprogetto
**Quando includere**: Solo se progetto grande (3+ team o chiara parallelizzazione)
**Focus**: Criticità, priorità, dipendenze

### 7. PoC e Validazioni Critiche
**Lunghezza**: ~200-300 parole per PoC
**Quando includere**: Solo se PoC critici da validare
**Focus**: Criteri successo/fallimento misurabili

### 8. Scope
**Lunghezza**: ~300-400 parole
**Essere espliciti**: Incluso/Escluso/Futuro con rationale
**Evitare**: Vago tipo "Altro in futuro"

### 9. Vincoli
**Lunghezza**: ~200-300 parole
**Essere realistici**: Non nascondere vincoli
**Focus**: Risorse, tecnici, organizzativi

### 10. Assunzioni e Domande Aperte
**Lunghezza**: ~300-400 parole
**Formato**: Tabella per assunzioni
**Scopo**: Rendere le scommesse esplicite

### 11. Metriche di Successo
**Lunghezza**: ~200-300 parole
**Formato**: Tabella
**Essere specifici**: Target misurabili, no obiettivi vaghi

### 12. Next Steps
**Lunghezza**: ~300-400 parole
**Essere attuabili**: Chi fa cosa e quando
**Focus**: Azioni immediate, timeline, rischi

---

## Linee Guida Lunghezza Documento

- **Progetto piccolo** (PoC semplice, MVP basic): 4000-6000 parole
- **Progetto medio** (MVP complesso, sistema multi-elemento): 6000-10000 parole
- **Progetto complesso** (Production, hardware+software, team multipli): 10000-15000 parole

Raramente oltre 15000 parole (troppo dettagliato).

---

## Adattamento per Fase

### PoC (Proof of Concept)
**Focus**: Validare fattibilità tecnica
**Sezioni chiave**: Obiettivo PoC, PoC e Validazioni, Architettura di massima
**Sezioni ridotte/omesse**: Sottoprogetti, Metriche utente, Dettaglio elementi
**Requisiti non-funzionali**: Minimali ("Non rilevante", "Best effort")

### MVP (Minimum Viable Product)
**Focus**: Validare valore con utenti reali
**Sezioni chiave**: Tutte le sezioni base
**Sezioni opzionali**: Sottoprogetti (se team >2), PoC (se validazioni necessarie)
**Requisiti non-funzionali**: Standard ("business hours", "50-100 utenti")

### Beta
**Focus**: Raffinare prodotto con early adopters
**Sezioni chiave**: Tutte le sezioni
**Sezioni opzionali**: Tutti applicabili
**Requisiti non-funzionali**: Enhanced ("extended hours", "500-1000 utenti")

### Production
**Focus**: Sistema completo per mercato
**Sezioni chiave**: TUTTE le sezioni pertinenti
**Requisiti non-funzionali**: Production-grade ("99.9% uptime", "10k+ concorrenti")

---

## Suggerimenti di Scrittura

1. **Usa il linguaggio dell'utente** - Se utenti sono tecnici, usa termini tecnici; se non-tecnici, semplifica
2. **Rendi le tabelle leggibili** - Più facili da scansionare dei paragrafi
3. **Evidenzia chiaramente le assunzioni** - Usa tabelle e format chiaro
4. **Sii specifico**: "50 utenti concorrenti" non "scalabile"
5. **Mostra i tradeoff**: "Abbiamo scelto X invece di Y perché fase PoC"
6. **Mantieni linguaggio appropriato** - Tecnico ma accessibile
7. **Usa voce attiva** - "L'utente clicca il pulsante" non "il pulsante viene cliccato"
8. **Evita jargon inutile** - Oppure definiscilo nel Glossario
9. **Diagrammi semplici ma chiari** - ASCII art va benissimo
10. **Adatta dettaglio alla fase** - PoC non necessita 50 pagine

---

## Errori Comuni da Evitare

### ❌ Errore 1: Over-engineering per PoC
**Sbagliato**: PoC con requisiti production-grade (99.9% uptime, <500ms latency, multi-region deployment)

**Corretto**: PoC con focus su fattibilità, requisiti minimali

### ❌ Errore 2: Troppo tecnico per audience
**Sbagliato**: "Useremo React 18 con Suspense, Server Components, Tailwind CSS v3, PostgreSQL 15 con pgvector extension"

**Corretto**: "Web app moderna con database relazionale e supporto vector search"

### ❌ Errore 3: Troppo vago
**Sbagliato**: "Il sistema dovrebbe essere veloce e scalabile"

**Corretto**: "Page load <2 secondi su banda standard, supporto 50-100 utenti concorrenti per MVP"

### ❌ Errore 4: Solo lista funzionalità
**Sbagliato**: Elencare 20 funzionalità senza contesto

**Corretto**: 5-7 funzionalità core con Why/User Experience/Acceptance Criteria

### ❌ Errore 5: Nessun confine di scope
**Sbagliato**: Tutto è "fasi future" senza specificare cosa

**Corretto**: Chiaro cosa c'è in v1, cosa NON c'è in v1 con rationale, cosa è futuro

### ❌ Errore 6: Assunzioni nascoste
**Sbagliato**: Assumere cose senza dichiararle (es. "utenti hanno smartphone")

**Corretto**: Tabella assunzioni esplicite con scenari se-sbagliata

### ❌ Errore 7: Diagramma mancante o illeggibile
**Sbagliato**: Nessun diagramma o diagramma troppo complesso

**Corretto**: Diagramma ASCII semplice ma chiaro

### ❌ Errore 8: Sottoprogetti per progetto piccolo
**Sbagliato**: 5 sottoprogetti per team di 2 persone

**Corretto**: Sottoprogetti solo se parallelizzazione chiara e team sufficiente

---

## Checklist Finale

Prima di considerare il documento completo:

- [ ] Tutte le sezioni obbligatorie presenti
- [ ] Sezioni opzionali incluse solo se applicabili
- [ ] Fase corrente identificata
- [ ] Requisiti non-funzionali adattati alla fase
- [ ] Diagramma architettura presente e leggibile
- [ ] Elementi sistema dettagliati appropriatamente
- [ ] Sottoprogetti solo se progetto grande
- [ ] PoC solo se validazioni critiche
- [ ] Assunzioni esplicite in tabella
- [ ] Metriche misurabili
- [ ] Next steps attuabili
- [ ] Lunghezza appropriata (4000-15000 parole)
- [ ] Tono professionale ma accessibile
- [ ] No jargon non necessario
- [ ] Specifico, non vago
- [ ] Stand-alone (leggibile senza altri documenti)
