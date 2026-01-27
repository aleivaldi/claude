# Template: Brief Strutturato

Questo template definisce la struttura per il documento **brief-structured.md** creato nella Fase 2.

## Caratteristiche del Documento

Il documento deve essere:
- **Completo e autosufficiente** - Contiene TUTTE le informazioni dal brief.md originale più tutto ciò che è stato dedotto e fornito dall'utente
- **Sostituisce brief.md** - Dopo la creazione di questo documento, brief.md diventa obsoleto e non sarà più consultato
- **Leggibile autonomamente** - Può essere letto e compreso senza accesso ad altri documenti
- **Condivisibile con stakeholder** - Formattazione professionale
- **Privo di riferimenti al processo** - Nessun marker o riferimento a domande/risposte
- **Non ridondante** - Evita ripetizioni inutili, ogni informazione compare una volta nel posto più appropriato

---

## Quali Sezioni Includere

Il documento brief-structured.md è **flessibile**. Non tutte le sezioni devono essere presenti - includi solo quelle:
- Presenti nel brief.md originale
- Pertinenti e importanti per il progetto specifico

### Sezioni Sempre Necessarie
1. **Problema** - Definizione del problema da risolvere
2. **Utenti e Contesto** - Chi userà la soluzione
3. **Obiettivi** - Cosa si vuole ottenere
4. **Funzionalità Primarie** - Must-have per MVP
5. **Scope MVP** - Cosa è incluso/escluso


### Sezioni Solitamente Necessarie
- **Vincoli** - Se ci sono vincoli tecnici, organizzativi o di business menzionati o dedotti
- **Assunzioni** - Per esplicitare assunzioni fatte dove non si hanno informazioni sufficienti
- **Workflow Principali** - Se il brief descrive processi o casi d'uso
- **Funzionalità Secondarie** - Funzionalità emerse ma ch epossono non essere sviluppate in MVP

### Sezioni Opzionali (solo se presenti nel brief o rilevanti)

- **Workflow Secondari** - Solo se il brief descrive workflow non critici
- **Criticità e Rischi** - Solo se ci sono rischi concreti identificabili
- **Domande Aperte** - Solo se ci sono decisioni posticipabili

---

## Struttura (fino a 12 Sezioni)

```markdown
# [NOME PROGETTO] - Brief Strutturato

## 1. Problema
[SEMPRE NECESSARIA]

[Descrizione completa del problema che il progetto risolve]
[Chi è affetto da questo problema]
[Gravità e impatto del problema]
[Situazione attuale e pain points]

## 2. Utenti e Contesto
[SEMPRE NECESSARIA]

### Utenti Primari
Per ognuno:
[Tipo di utente, ruolo, competenze tecniche]
[Ambiente, eventuali strumenti utilizzati]
[Quanti utenti (ordine di grandezza)]
[Contesto d'uso (dove, quando, come)]

### Utenti Secondari 
[SE APPLICABILE]
Per ognuno:
[Altri stakeholder o utenti indiretti]

## 3. Obiettivi
[SEMPRE NECESSARIA]

### Obiettivo Primario
[Cosa si vuole ottenere con questo MVP/PoC]

### Obiettivi Secondari
- [Obiettivo 2]
- [Obiettivo 3]

### Criteri di Successo
[Come misuriamo se abbiamo raggiunto gli obiettivi]

## 4. Vincoli
[SOLITAMENTE NECESSARIA - Solo se ci sono vincoli espliciti nel brief]

### Vincoli Tecnici
[Tecnologie richieste o da evitare]
[Sistemi esistenti con cui integrarsi]
[Piattaforme target]

### Vincoli Organizzativi
[Team disponibile, competenze]
[Processi aziendali da rispettare]
[Stakeholder e approvazioni necessarie]

### Vincoli di Business
[Timeline e deadline]
[Budget disponibile]
[Priorità aziendali]

## 5. Assunzioni
[SOLITAMENTE NECESSARIA - Per esplicitare assunzioni che sono state fatte nel brief o durante i confronti con l'utente]

Le seguenti assunzioni sono state fatte per definire l'MVP:

- **[Aspetto 1]**: [Assunzione fatta]. Rationale: [Perché questa assunzione è ragionevole per MVP]
- **[Aspetto 2]**: [Assunzione fatta]. Rationale: [Perché questa assunzione è ragionevole per MVP]
- **[Aspetto 3]**: [Assunzione fatta]. Rationale: [Perché questa assunzione è ragionevole per MVP]

[Nota: Usa defaults.md per scegliere assunzioni pragmatiche per MVP]

## 6. Funzionalità Primarie (Must-Have per MVP)
[SEMPRE NECESSARIA]

Funzionalità essenziali senza le quali l'MVP non può funzionare.

### Funzionalità 1: [Nome]
**Priorità**: Must-Have
[Descrizione dettagliata della funzionalità]
[Come l'utente la usa]
[Perché è essenziale per MVP]

### Funzionalità 2: [Nome]
**Priorità**: Must-Have
[Descrizione dettagliata della funzionalità]
[Come l'utente la usa]
[Perché è essenziale per MVP]

### Funzionalità 3: [Nome]
**Priorità**: Must-Have
[Descrizione dettagliata della funzionalità]
[Come l'utente la usa]
[Perché è essenziale per MVP]

[Tipicamente 2-5 funzionalità must-have per MVP]

## 7. Funzionalità Secondarie (Nice-to-Have)
[OPZIONALE - Solo se il brief menziona funzionalità che non sono core]

Funzionalità desiderabili ma non bloccanti. Se citate nel brief originale, devono essere tutte elencate qui.

### Funzionalità Secondaria 1: [Nome]
**Priorità**: Nice-to-Have | **Quando**: [v2 / v3 / se tempo disponibile]
[Descrizione]
[Perché non è essenziale per MVP]
[Benefit se implementata]

### Funzionalità Secondaria 2: [Nome]
**Priorità**: Nice-to-Have | **Quando**: [v2 / v3 / se tempo disponibile]
[Descrizione]
[Perché non è essenziale per MVP]
[Benefit se implementata]

[Includere TUTTE le funzionalità menzionate nel brief, anche quelle non prioritarie]

## 8. Workflow Principali
[SOLITAMENTE NECESSARIA - Se il brief descrive processi o casi d'uso principali]

### Workflow 1: [Nome]
1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Risultato]

### Workflow 2: [Nome]
1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Risultato]

[Descrivere almeno 2-4 workflow principali che coprono i casi d'uso più comuni]

## 9. Workflow Secondari
[OPZIONALE - Solo se il brief descrive workflow non critici o casi d'uso secondari]

Workflow desiderabili ma non essenziali per MVP. Se descritti nel brief originale, devono essere documentati qui.

### Workflow Secondario 1: [Nome]
**Priorità**: Nice-to-Have | **Quando**: [v2 / v3 / se tempo disponibile]
1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Risultato]

[Perché non è critico per MVP]
[Benefit se implementato]

### Workflow Secondario 2: [Nome]
**Priorità**: Nice-to-Have | **Quando**: [v2 / v3 / se tempo disponibile]
1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Risultato]

[Perché non è critico per MVP]
[Benefit se implementato]

[Includere TUTTI i workflow secondari menzionati nel brief, anche quelli non prioritari]

## 10. Criticità e Rischi
[OPZIONALE - Solo se ci sono rischi concreti identificabili per il progetto]

Identificazione dei rischi principali che potrebbero impattare il progetto. Vanno evidenziati solo quelli concreti, se presenti

### Fattibilità Tecnica
**Rischio**: [Descrizione rischio tecnico]
**Probabilità**: [Bassa / Media / Alta]
**Impatto**: [Basso / Medio / Alto]
**Mitigazione**: [Come affrontiamo questo rischio]

### Time-to-Market
**Rischio**: [Rischio che possa ritardare il lancio]
**Probabilità**: [Bassa / Media / Alta]
**Impatto**: [Basso / Medio / Alto]
**Mitigazione**: [Come affrontiamo questo rischio]

### Costi
**Rischio**: [Rischio di superamento budget]
**Probabilità**: [Bassa / Media / Alta]
**Impatto**: [Basso / Medio / Alto]
**Mitigazione**: [Come affrontiamo questo rischio]

### Dipendenze Esterne
**Rischio**: [Dipendenze da terze parti, API, fornitori]
**Probabilità**: [Bassa / Media / Alta]
**Impatto**: [Basso / Medio / Alto]
**Mitigazione**: [Come affrontiamo questo rischio]

### Adozione Utente
**Rischio**: [Rischi legati all'adozione da parte degli utenti]
**Probabilità**: [Bassa / Media / Alta]
**Impatto**: [Basso / Medio / Alto]
**Mitigazione**: [Come affrontiamo questo rischio]

[Includere solo i rischi rilevanti per il progetto specifico. Non tutte le categorie sono sempre applicabili]

## 11. Scope MVP
[SEMPRE NECESSARIA]

### Incluso in MVP v1
- [Funzionalità/capability inclusa]
- [Funzionalità/capability inclusa]
- [Funzionalità/capability inclusa]

### Esplicitamente NON Incluso in v1
- [Funzionalità esclusa] → [perché: future phase / workaround manuale accettabile / dipende da feedback v1]
- [Funzionalità esclusa] → [perché]
- [Funzionalità esclusa] → [perché]

### Fasi Future (dopo v1)
**v2 (basato su apprendimento v1)**:
- [Enhancement possibile]
- [Integrazione possibile]

**v3+**:
- [Nice-to-have dallo scoping originale]

## 12. Domande Aperte
[OPZIONALE - Solo se ci sono decisioni posticipabili dopo MVP]

[Lista di decisioni ancora da prendere o aspetti da validare]
[Solo se ci sono decisioni veramente posticipabili dopo MVP]
[Se non ce ne sono, omettere questa sezione]
```

---

## Linee Guida di Scrittura

### ✅ FARE
- Scrivere come documento completo e leggibile autonomamente
- Integrare risposte e assunzioni in modo seamless
- Usare paragrafi narrativi con tono professionale
- Rendere il documento condivisibile con stakeholder
- Scrivere come se fosse il primo e unico documento del progetto

### ❌ NON FARE
- NO markers tipo [CONFERMATO], [AGGIUNTO], [MODIFICATO], [ASSUNTO]
- NO riferimenti a "Q[N]", "risposta alla domanda N", "come da Q3"
- NO riferimenti a "defaults.md", "template.md", o altri file tecnici
- NO linguaggio tipo "Basato su brief.md", "Come indicato in brief.md"
- NO riferimenti al processo di creazione del documento
- NO linguaggio "diff-like" che mostra cosa è cambiato
