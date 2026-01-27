# Template Excel Structure - Cell Mapping

Questo documento definisce **esattamente** dove scrivere in ogni foglio del template Excel.

## ⚠️ CRITICO: Celle Mergiate GRANDI

**ATTENZIONE**: Questo template usa CELLE UNICHE MERGIATE MOLTO GRANDI per ogni sezione.

### Regola Fondamentale
- **NON scrivere in celle separate** (es. B12, B13, B14...)
- **Scrivi in UN'UNICA CELLA** (top-left del merge) usando `\n` per andare a capo
- Esempio: Per Key Partners → Scrivi TUTTO in **B10** con `\n` tra items

### Formato Corretto
```
B10 = "🔴 Partner 1 - desc\n🔴 Partner 2 - desc\n🟡 Partner 3 - desc"
```

### ❌ Formato SBAGLIATO (non funziona)
```
B12 = "🔴 Partner 1"  # ← NON FARE: B12 è dentro B10:E47 merge
B13 = "🔴 Partner 2"  # ← NON FARE: errore MergedCell read-only
```

## Sheet 1: Business Model Canvas

### Metadata
- **J4**: Nome progetto (es. "Nome Progetto")
- **N4**: Designer/Team
- **R4**: Data (yyyy-MM-dd)
- **U4**: Versione

### ⚠️ IMPORTANTE: Celle Mergiate Grandi

**TUTTE le sezioni sono CELLE UNICHE MERGIATE**. NON scrivere righe separate (B12, B13, B14...), ma scrivi in UN'UNICA CELLA usando `\n` per andare a capo.

### Key Partners 
**Area di scrittura**: **B10** (cella merged B10:E47)
**Contenuto**: Lista partner con a capo `\n` tra items
**Formato**:
```
🔴 Partner 1 - description
🔴 Partner 2 - description
🟡 Partner 3 - description
```

### Key Activities 
**Area di scrittura**: **F10** (cella merged F10:I27)
**Contenuto**: Attività chiave con a capo `\n`
**Formato**: `🔴 Activity\n🟡 Activity 2\n...`

### Key Resources
**Area di scrittura**: **F30** (cella merged F30:I47)
**Contenuto**: Risorse chiave con a capo `\n`
**Formato**: `🔴 Resource\n🟡 Resource 2\n...`

### Value Propositions 
**Area di scrittura**: **J10** (cella merged J10:M47)
**Contenuto**: Value propositions con a capo `\n`
**Formato**: `🔴 Value prop\n🟡 Value prop 2\n...`

### Customer Relationships 
**Area di scrittura**: **N10** (cella merged N10:Q27)
**Contenuto**: Relazioni clienti con a capo `\n`
**Formato**: `🔴 Relationship\n🟡 Relationship 2\n...`

### Customer Segments 
**Area di scrittura**: **R10** (cella merged R10:U47)
**Contenuto**: Segmenti target con a capo `\n`
**Formato**: `🔴 Segment\n🟡 Segment 2\n...`

### Channels 
**Area di scrittura**: **N30** (cella merged N30:Q47)
**Contenuto**: Canali con a capo `\n`
**Formato**: `🔴 Channel\n🟡 Channel 2\n...`

### Cost Structure
**Area di scrittura**: **B50** (cella merged B50:K60)
**Contenuto**: Costi con a capo `\n`
**Formato**: `🔴 Cost 1\n🟡 Cost 2\n...`

### Revenue Streams
**Area di scrittura**: **L50** (cella merged L50:U60)
**Contenuto**: Revenue streams con a capo `\n`
**Formato**: `🔴 Revenue 1\n🟡 Revenue 2\n...`

---

## Sheet 2: Lean Canvas

### Metadata
- **J4**: Nome progetto (es. "Nome Progetto")
- **N4**: Designer/Team
- **R4**: Data (yyyy-MM-dd)
- **U4**: Versione



### Problem
**Area di scrittura**: **B10** (cella merged B10:E27)
**Contenuto**: Top 3 problemi con a capo `\n`
**Formato**: `🔴 Problem 1\n🟡 Problem 2\n...`

### Existing Alternatives 
**Area di scrittura**: **B30** (cella merged B30:E47)
**Contenuto**: Alternative esistenti con a capo `\n`
**Formato**: `🔴 Alternative 1\n🟡 Alternative 2\n...`

### Solution 
**Area di scrittura**: **F10** (cella merged F10:I27)
**Contenuto**: Top 3 soluzioni con a capo `\n`
**Formato**: `🔴 Solution 1\n🟡 Solution 2\n...`

### Key Metrics 
**Area di scrittura**: **F30** (cella merged F30:I47)
**Contenuto**: Metriche chiave da misurare con a capo `\n`
**Formato**: `🔴 Metrica 1\n🟡 Metrica 2\n...`

### Unique Value Proposition
**Area di scrittura**: **J10** (cella merged J10:J27)
**Contenuto**: Singolo messaggio chiaro e convincente 
**Formato**: `🔴 Clear, compelling one-liner`

### High-Level Concept
**Area di scrittura**: **J30** (cella merged J30:J47)
**Contenuto**: Concetto high-level (X for Y)
**Formato**: `🟡 "Like X but for Y"`

### Unfair Advantage 
**Area di scrittura**: **N10** (cella merged N10:N27)
**Contenuto**: Vantaggi non copiabili con a capo `\n`
**Formato**: `🔴 Advantage 1\n🟡 Advantage 2\n...`

### Channels 
**Area di scrittura**: **N30** (cella merged N30:N47)
**Contenuto**: Percorsi verso clienti con a capo `\n`
**Formato**: `🔴 Channel 1\n🟡 Channel 2\n...`

### Customer Segments 
**Area di scrittura**: **R10** (cella merged R10:R27)
**Contenuto**: Target Customers + Target Users con a capo `\n`
**Formato**: `🔴 Target Customers description 1\n🟡 Target Users description 2\n...`

### Early Adopters 
**Area di scrittura**: **R30** (cella merged R30:R47)
**Contenuto**: Early adopters specifici con a capo `\n`
**Formato**: `🔴 Early adopter profile  1\n🟡 Early adopter profile  2\n...`

### Cost Structure 
**Area di scrittura**: **B50** (cella merged B50:K60)
**Contenuto**: Costi con categorie specifiche con a capo `\n`
**Formato**: `🔴 CAC: €50/customer\n🟡 🔴 Hosting: €xx/mese\n...`

### Revenue Streams 
**Area di scrittura**: **L50** (cella merged L50:U60)
**Contenuto**: Revenue model details con a capo `\n`
**Formato**: `🔴 Revenue Model: Subscription\n🟡 🔴 LTV:...\n...`

---

## Sheet 3: Customer Personas Canvas

### Metadata
- **J4**: Nome progetto (es. "Nome Progetto")
- **N4**: Designer/Team
- **R4**: Data (yyyy-MM-dd)
- **U4**: Versione

### ⚠️ CELLE MERGIATE A BLOCCHI

Sheet 3 usa merge "a blocchi" più piccoli (ogni 2-3 righe), NON un'unica cella grande.

### Persona 1 (Colonne D-I)

**Persona Name**:
- **Area**: D8 (cella merged D8:I9)
- **Contenuto**: Nome descrittivo persona
- **Formato**: `Nome Persona`

**Description**:
- **Area**: D10 (cella merged D10:I12)
- **Contenuto**: One-liner con a capo se necessario
- **Formato**: `Descrizione di una riga della persona`

**Attributes**:
Ogni attributo occupa un merge di 2-3 righe. 
Le celle in cui scrivere sono:
- **D15** → Demographics
- **D18** → Comportamenti
- **D21** → Altri attributi
- [continua pattern ogni 3 righe fino alla cella D57]

**Formato**: Metti un solo attributo ogni cella

### Persona 2 (Colonne L-Q)
**Struttura identica a Persona 1 su colonna L**:


### Persona 3 (Colonne T-Y)
**Struttura identica a Persona 1 su colonna T**:
---

## Sheet 4: Value Proposition Canvas i

### Metadata
### Metadata
- **J4**: Nome progetto (es. "Nome Progetto")
- **N4**: Designer/Team
- **R4**: Data (yyyy-MM-dd)
- **U4**: Versione

### ⚠️ CELLE UNICHE MERGIATE GRANDI (come Sheet 1 e 2)

### PRODUCT SIDE (Sinistra)

#### Benefits 
**Area di scrittura**: **B10** (cella merged B10:E27)
**Contenuto**: Benefici con `\n` tra items
**Formato**: `🔴 Benefit 1\n🔴 Benefit 2\n🟡 Benefit 3`

#### Features 
**Area di scrittura**: **B30** (cella merged B30:E47)
**Contenuto**: Feature fattuali con `\n`
**Formato**: `🔴 Feature 1\n🟡 Feature 2`


#### Value Proposition
**Area di scrittura**: **F57**
**Contenuto**: Statement value proposition
**Formato**: `Valore principale offerto ai clienti`

#### Experience
**Area di scrittura**: **F10**
**Contenuto**: Statement value proposition
**Formato**: `The product experience is the way that owning your product makes the customer feel. It’s the sum total of the combined features and benefits. Product epxierence is different to features and benefits because it’s more about the emotional reasons why people buy your product. The product experience is the kernel that will help identify the market positioning and brand essence that is usually built out of the value proposition`

### CUSTOMER SIDE (Destra)

#### Wants
**Area di scrittura**: **N10** (cella merged N10:Q27)
**Contenuto**: Driver emozionali con `\n`
**Formato**: `🔴 Driver 1\n🔴 Driver 2`

#### Fears 
**Area di scrittura**: **R10** (cella merged R10:U47)
**Contenuto**: Paure/concerns con `\n`
**Formato**: `🔴 Fear 1\n🟡 Fear 2`

#### Rational Needs 
**Area di scrittura**: **N30** (cella merged N30:Q47)
**Contenuto**: Bisogni razionali con `\n`
**Formato**: `🔴 Need 1\n🟡 Need 2`

#### Substitutes (N54:U63 - MERGE)
**Area di scrittura**: **N54**
**Contenuto**: Alternative non ovvie con `\n`
**Formato**: `Alternativa 1\nAlternativa 2`

---
