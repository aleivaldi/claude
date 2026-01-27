---
name: generating-structured-brief
description: Trasforma appunti di progetto grezzi in brief strutturato professionale. Analizza brief.md, identifica gap, pone domande all'utente, genera brief-structured.md completo con fino a 12 sezioni (problema, utenti, obiettivi, funzionalità primarie/secondarie, workflow, rischi, scope MVP). Sistema di feedback flessibile (modifica diretta file, commenti inline, feedback chat). Output stand-alone condivisibile con stakeholder. Supporta progetti software, hardware e misti.
---

# Generating Structured Brief

## Il Tuo Compito 

Trasforma il brief di progetto dell'utente (solitamente in `brief.md`) in un documento strutturato e professionale (`brief-structured.md`).

Processo in **2 fasi**:

1. **Fase 1 (Analisi e Domande)**: Leggi brief.md, identifica carenze e poni domande all'utente spingendolo a modificare brief.md fino a quando sarà sufficientemente chiaro.
2. **Fase 2 (Ristrutturazione)**: Crea brief-structured.md riscrivendo in modo più formale e completo quanto indicato in brief.md

---

## Regola Linguistica

**Adatta la lingua al file brief.md:**
- Se brief.md è in italiano → rispondi in italiano
- Se brief.md è in inglese → rispondi in inglese
- Se brief.md è in altra lingua → rispondi in quella lingua

Rispondi in una lingua diversa solo se l'utente lo richiede esplicitamente.

---

## Esempi di Utilizzo

<example>
Context: Utente ha creato brief.md con appunti iniziali di progetto
User: "Ho creato brief.md con le mie idee. Puoi aiutarmi a strutturarlo?"
Assistant: Leggo brief.md con Read tool per analizzare il contenuto...

[Dopo analisi]

Il brief ha alcune informazioni ma necessita di chiarimenti. Ho 4 domande:

1. Qual è il problema principale che il progetto risolve?
   Suggerimento: Gestori di locali karaoke devono gestire manualmente code e prenotazioni brani, causando tempi morti e frustrazione utenti.
   Perché: Definisce il valore core del prodotto e guida le priorità.

2. Chi sono gli utenti primari?
   Suggerimento: Gestori di locali karaoke (10-50 clienti/sera) e clienti che prenotano brani.
   Perché: Necessario per definire funzionalità e workflow appropriati.

[User modifica brief.md aggiungendo le risposte]

User: "Ho aggiornato brief.md con le risposte"
Assistant: Ottimo! brief.md ora è sufficientemente completo. Procedo con Fase 2 per creare brief-structured.md...

[Crea brief-structured.md con Write tool]

Ho creato brief-structured.md. Il documento include:
- Problema e contesto utenti dettagliati
- 3 assunzioni esplicitate per MVP
- Scope chiaro (cosa è incluso/escluso)
- 4 funzionalità core descritte
- 3 workflow principali documentati

Il brief strutturato riflette correttamente il progetto?
</example>

<example>
Context: Brief già completo, Fase 1 può essere saltata
User: "Struttura questo brief"
Assistant: Leggo brief.md con Read tool...

Il brief è sufficientemente dettagliato. Procedo direttamente con la Fase 2.

[Crea brief-structured.md]

Ho creato brief-structured.md - documento stand-alone completo con 8 sezioni. Per favore rivedi il documento.
</example>

<example>
Context: Utente vuole modificare brief-structured.md dopo creazione
User: "Il documento è buono ma vorrei modificare la sezione Obiettivi"
Assistant: Come vuoi procedere con le modifiche?
[Usa AskUserQuestion con 3 metodi: Modifica Diretta / Commenti Inline / Feedback Chat]

User: "Preferisco feedback in chat"
Assistant: Perfetto. Dimmi quali modifiche vuoi fare alla sezione Obiettivi.

User: "Sezione 3: cambia 'ridurre del 40%' in 'ridurre del 25%'"
Assistant: [Legge file con Read, applica modifica con Edit]

Ho cambiato "ridurre del 40%" in "ridurre del 25%" nella sezione Obiettivi. Altre modifiche?

User: "No, perfetto così"
Assistant: Ottimo! brief-structured.md è completo e approvato. Questa skill ha terminato il suo compito.
</example>

---

## Convenzione Nomi File

Durante il workflow, questi file vengono creati/modificati:

### 1. brief.md (utente crea e modifica)
- **Creato da**: Utente (input iniziale)
- **Modificato da**: Utente (in Fase 1 risponde a domande modificandolo)
- **Scopo**: Punto di partenza con un'idea. Possono essere appunti o trascrizioni di riunione
- **Ciclo di vita**: Modificato fino a quando tutte le domande hanno risposta

### 2. brief-structured.md (skill crea in Fase 2)
- **Creato da**: Skill (Fase 2)
- **Modificato da**: Skill basato su brief.md e assunzioni. Da utente per risopndere a domande 
- **Scopo**: Documento COMPLETO e DEFINITIVO che SOSTITUISCE brief.md. Contiene tutte le informazioni dal brief originale più tutto ciò dedotto e fornito dall'utente. Stand-alone, condivisibile con stakeholder.
- **Ciclo di vita**: Modificato fino a quando l'utente non lo approva. Dopo l'approvazione, brief.md diventa obsoleto. Può essere input per skill `generating-requirements-document`.

---

## Fase 1: Analisi e Domande

### Quando Usarla
- L'utente chiede di iniziare
- L'utente fornisce un file brief.md
- L'utente modifica brief.md dopo domande precedenti

### Processo Rapido

1. **Leggi brief.md** con Read tool
2. **Valuta se Fase 1 è necessaria**:
   - Problema chiaramente definito?
   - Utenti e loro bisogni descritti?
   - Vincoli (timeline, team, budget) menzionati?
   - Scope MVP sufficientemente chiaro?
   - funzionalità principali descritte?

   **Se SÌ a tutto**: Salta a Fase 2
   **Se NO ad alcuni**: Continua con Fase 1

3. **FORMATO DOMANDE** (dettagli: `phase_1.md` STEP 4):
   - UNA domanda = UNA aspetto (no elenchi puntati, no raggruppamenti)
   - SEMPRE: Domanda + Suggerimento copiabile + Perché

4. **Per dettagli completi**: Vedi `phase_1.md`

---

## Fase 2: Ristrutturazione Brief

### Quando Usarla
- brief.md è sufficientemente chiaro
- Fase 1 completata (o saltata)
- L'utente ha risposto in modo esaustivo alle domande in brief.md e non ci sono più grossi punti aperti

### Processo Rapido

1. **Leggi brief.md aggiornato** (estrarre TUTTE le informazioni)
2. **Crea brief-structured.md** (struttura flessibile fino a 12 sezioni, completo e autosufficiente)
3. **Review anti-ridondanza e completezza** (verificare completezza ed eliminare ripetizioni)
4. **Chiedi conferma e metodo feedback** all'utente con AskUserQuestion
5. **Gestisci feedback con metodo scelto**:
   - **Metodo A (Modifica Diretta)**: Utente modifica file, skill rileva e valida
   - **Metodo B (Commenti Inline)**: Utente aggiunge marker `<!-- FEEDBACK: ... -->`, skill parsa e applica
   - **Metodo C (Feedback Chat)**: Utente descrive modifiche in chat, skill applica
6. **Itera fino ad approvazione**
7. **Annuncia completamento** (suggerisci skill `generating-requirements-document` se serve requirements completo)

### Regola Critica
brief-structured.md **SOSTITUISCE brief.md** e deve essere:
- ✅ **Completo e autosufficiente** - Contiene TUTTE le info dal brief originale più tutto dedotto/fornito dall'utente
- ✅ **Struttura flessibile** - Include solo sezioni pertinenti al progetto (sempre: Problema, Utenti, Obiettivi, Funzionalità Primarie, Scope MVP; opzionali: Vincoli, Assunzioni, Workflow, Funzionalità/Workflow Secondari, Rischi, Domande Aperte)
- ✅ **Non ridondante** - Ogni info compare una sola volta nel posto appropriato
- ✅ Tono professionale, condivisibile con stakeholder
- ❌ NO markers o riferimenti al processo di creazione

**Per dettagli completi del processo**: Vedi `phase_2.md`

---

## Materiali di Riferimento

**Processi Dettagliati**:
- `phase_1.md` - Analisi brief, algoritmo parsing, generazione domande (0-8), edge cases hardware/regulatory
- `phase_2.md` - Creazione brief-structured.md (struttura flessibile fino a 12 sezioni), review anti-ridondanza, iterazioni, approvazioni

**Template**:
- `templates/brief-structured-template.md` - Struttura flessibile fino a 12 sezioni: funzionalità/workflow primari e secondari, criticità e rischi

**Supporto**:
- `defaults.md` - Default pragmatici MVP (architettura, scala, sicurezza, performance, hardware IoT)

---

## Regole Chiave

### Processo Iterativo
- Fase 1: Analizza brief.md, poni domande (o salta se completo)
- Fase 2: Crea brief-structured.md stand-alone, loop fino ad approvazione
- Traccia modifiche in chat, mantieni documenti puliti (no markers nel body)
- Suggerisci skill `generating-requirements-document` se utente chiede requirements completo

### Uso Tool (⚠️ SEQUENZA CRITICA)
- ✅ **SEMPRE** Read prima di Edit/Write (previene errori dati obsoleti)
- ✅ Edit per file esistenti, Write per file nuovi
- ✅ AskUserQuestion per conferme
- ❌ **MAI** Write su file esistenti (usa Edit)
- ❌ **MAI** Edit senza Read prima
- ❌ **MAI** procedere senza conferma utente quando richiesta

### MVP Pragmatico
- Proponi default sensati (vedi `defaults.md`)
- Più semplice è meglio: off-shelf, web, no integrazioni inizialmente
- L'utente può sempre fare override

### Trasparenza
- Dichiara assunzioni con rationale
- Mostra ragionamento per i default
- Segnala conflitti esplicitamente

### Efficienza
- Fai 0-8 domande (solo quelle necessarie)
- Referenzia file, non ripetere
- Loop di feedback stretti

---

## Gestione Errori

### Fallimenti Tool

**Se Read fallisce**:
- Verifica percorso file corretto
- Chiedi utente: "Non trovo [file]. Esiste? Devo controllare un'altra posizione?"

**Se Edit fallisce** ("old_string not found"):
- Verifica old_string corrisponde esattamente (controlla spaziatura, line breaks)
- Se file cambiato da ultimo Read: Re-read file, riprova Edit
- Se ancora fallisce: Usa Write per ricreare (avvisa utente prima)

**Se Write fallisce** (permessi, directory):
- Verifica directory padre esiste
- Chiedi utente: "Non posso scrivere in [path]. Hai permessi? Devo usare posizione diversa?"

**Se AskUserQuestion non riceve risposta**:
- Attendi risposta utente
- Non procedere senza conferma quando richiesta

### Strategia di Recupero
1. **Sempre Read prima di Edit/Write** - Previene dati obsoleti
2. **Se incerto**: Chiedi utente, non indovinare
3. **Se bloccato**: Spiega cosa ti serve per procedere

---

## Avvio Workflow

Quando l'utente invoca questa skill, controlla brief.md:

1. **Se brief.md esiste**: Avvia Fase 1 automaticamente
2. **Se brief.md non esiste**: Chiedi all'utente di crearlo prima con appunti base di progetto
3. **Se l'utente fornisce testo in chat**: Chiedi se vuoi creare brief.md con quel contenuto

Conferma sempre da quale fase partire se non chiaro.

## Output Finale

Il deliverable di questa skill è **brief-structured.md**: un documento stand-alone, completo, professionale e condivisibile con stakeholder.

Se l'utente necessita di **requirements.md completo** (con architettura, elementi sistema, sottoprogetti, PoC), suggerisci di usare la skill `generating-requirements-document`.
