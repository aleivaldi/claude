# Phase 1: Parse Brief and Identify Gaps

## Objective

Evaluate if Phase 1 is needed. If yes: extract clear information, identify gaps, match user's technical level, propose MVP pragmatic defaults, generate 0-8 clarification questions (ONLY necessary ones), ask user to add responses directly in brief.md.

If brief is already sufficiently detailed: skip Phase 1 and proceed directly to Phase 2.

## Parsing Algorithm

### STEP 0: Evaluate if Phase 1 is Needed

**Before generating questions**, evaluate the brief completeness:

Ask yourself:
- Is the problem clearly stated?
- Are users and their needs described?
- Are constraints (timeline, team, budget) mentioned or reasonably inferable?
- Is the MVP scope clear enough to proceed?

**Decision**:
- **If YES to all, NO questions needed** (brief is complete):
**Output to user** (in chat):

   **If NO questions needed** (brief is complete):
   ```markdown
   # Phase 1: Analisi Brief - [Project Name]

   ## Cosa è chiaro

   Il brief è sufficientemente dettagliato:
   - Problema: [brief summary]
   - Utenti: [brief summary]
   - Obiettivi: [brief summary]
   - Vincoli: [brief summary]

   ## Prossimo passo

   Non ho domande aggiuntive. Procedo direttamente con **Phase 2**
   per creare il brief strutturato.
   ```

   Then proceed immediately to Phase 2.

- **If NO to some**: Continue with STEP 1

# STEP 1: Estrazione Informazioni e Analisi Gap

  ## Obiettivo
  Analizzare brief.md ed estrarre tutte le informazioni rilevanti per il progetto, identificando per ciascuna categoria se le
   informazioni sono complete, incomplete, o non applicabili al contesto specifico.

  ## Istruzioni per l'Analisi

  Per ciascuna delle seguenti categorie:
  1. Determina se la categoria è **rilevante** per questo tipo di progetto
  2. Se rilevante, estrai le informazioni disponibili dal brief
  3. Valuta lo stato delle informazioni secondo questi criteri:
     - ✅ **CHIARO**: Informazioni complete e sufficienti per procedere
     - 💡 **DEDUCIBILE**: Non menzionato, ma deducibile dal contesto o dalle conoscenze generali
     - ⚠️ **RICHIEDE CHIARIMENTI**: Menzionato ma incompleto o ambiguo
     - ❓ **NON MENZIONATO**: Non citato nel brief ma probabilmente rilevante per questo progetto
     - ⊗ **NON APPLICABILE**: Non rilevante per questo tipo di progetto

  ---

  ### 1. Definizione del Problema
  **Always Need**:
- [ ] problema che la soluzione vuole risolvere

  ### 2. Obiettivi del Progetto
  **Always Need**:
- [ ] risultati attesi
  **Usually Need**:
- [ ]  modello di business
**Often Needed**:
- [ ] come lo si vuole risolvere

  ### 3. Utenti Target
   **Always Need**:
   - [ ] Primary users identified (role/type, not names)
   **Usually Need**:
   - [ ] Utenti secondari, di amministrativi o indiretti
   - [ ] numero di utenti
  ### 4. Funzionalità Core
   **Always Need**:
   - [ ] funzionalità core
   **Usually Need**:
   - [ ] workflow principali
   **Often Needed**:
   - [ ] differenza fra must-have e nice-to have

  

  ### 5. Vincoli Tecnici
   **Always Need**:
   - [ ] 
   **Usually Need**:
   - [ ] 
   **Often Needed**:
   - [ ] richieste di tecnologie
   - [ ] linguaggi
   - [ ] sistemi esistenti in cui si sviluppa
   - [ ] cloud provider

  ### 6. Integrazioni Esterne
  **Always Need**:
   - [ ] 
   **Usually Need**:
   - [ ] 
   **Often Needed**:
   - [ ] API
   - [ ] Servizio di terze parti
   - [ ] Sistema legacy
  

  ### 7. Requisiti Hardware
  Solo se dal brief si deduce che siano necessari prodotti fisici.
  **Always Need**:
   - [ ] funzionalità
   **Usually Need**:
   - [ ] vincoli di dimensioni
   - [ ] costo massimo
   **Often Needed**:
   - [ ] certificazioni
  ### 8. Vincoli di Sicurezza e Privacy
  **Always Need**:
   - [ ] presenza di sensibili da gestire
   **Usually Need**:
   - [ ] GDPR
   **Often Needed**:
   - [ ] compliancy con altre regolamentazioni

  ### 9. Contesto e Timeline
   **Always Need**:
   - [ ] Urgenza
   **Usually Need**:
   - [ ] Contesto aziendale
   - [ ] Milestones
   **Often Needed**:
   - [ ] Deadline

  ### 10. Budget e Risorse
   **Often Needed**:
   - [ ] Budget del progetto

  ## Riepilogo Gap Identificati
  **Informazioni Critiche Mancanti**:
  1. [Lista prioritizzata dei gap che DEVONO essere colmati prima di procedere]
  **Informazioni Utili ma Non Bloccanti**:
  1. [Lista di informazioni che sarebbe utile avere ma su cui si possono fare assunzioni ragionevoli]
  **Categorie Non Applicabili**:
  - [Lista delle categorie non rilevanti per questo progetto specifico]

  ---


### STEP 3: Identify User Technical Level

Before generating questions, identify the technical level from the brief:

**Non-technical indicators**:
- No technical terms (e.g., API, database, cloud)
- Focus on business problem and user needs
- Describes workflows in user terms, not technical implementation
- Example: "I clienti devono poter prenotare facilmente"

**Semi-technical indicators**:
- Some technical mentions but not detailed
- Mentions "app" or "website" without specifics
- Mix of business and technical language
- Example: "Serve un'app web per gestire ordini"

**Technical indicators**:
- Specific technologies mentioned (React, PostgreSQL, AWS)
- Architecture concerns (microservices, API, authentication)
- Technical constraints or preferences
- Example: "Vogliamo usare Next.js con autenticazione OAuth"

**Rule**: Match your questions to their level
- Non-technical → Ask ONLY business questions
- Semi-technical → Mix business + high-level technical
- Technical → Can ask technical questions

### STEP 4: Formulate Clarification Questions 

Generate **0-8 questions** (ONLY necessary ones) using the **suggestion-based format**:

**Template for Questions**:
```
N. Che cosa intendi per [specific aspect]?
   Suggerimento: [proposed approach/default]
   Perché: [why this matters for requirements]
```

**Question Quality Examples**:

✓ Good: "Che cosa intendi per 'accesso mobile'? Suggerimento: Web responsive. Perché: Più veloce da sviluppare."
✗ Bad (technical): "Dovremmo usare GraphQL o REST?" → Better: "L'API deve supportare real-time?"
✗ Bad (vague): "Come dovrebbe funzionare?" → Better: "Qual è il flusso principale per [action]?"
✗ Bad (already answered): "Quanti utenti?" when brief says "50 utenti" → Skip
✗ Bad (implementation): "Che database?" → Skip (dev team decides)
✗ Bad (obvious): "Volete HTTPS?" → Skip (always yes)

### STEP 5: Filter Questions - Ask Only What's Needed

**DO NOT ask if**:
- ✗ Information is already stated in brief.md
- ✗ It's a technical implementation detail (DB choice, framework, hosting)
- ✗ User is non-technical and question requires technical knowledge
- ✗ Default assumption is sufficient and low-risk for MVP
- ✗ Answer doesn't impact MVP scope significantly

**DO ask if**:
- ✓ Information significantly impacts MVP scope or timeline
- ✓ Assumption would be high-risk if wrong
- ✓ User explicitly mentioned topic but without clarity
- ✓ Needed to resolve conflicts or ambiguities in brief
- ✓ Critical for estimating team/time/cost

**Result**:
- 0 questions = Brief is complete and detailed
- 1-3 questions = Brief needs minor clarification
- 4-6 questions = Brief has some gaps
- 7-8 questions = Brief is very vague (rare if you filter well)

**Filter Example**:
Brief: "App web responsive per ordini. 50 ristoranti, 5-10 camerieri ciascuno."
✗ Skip: "Piattaforma?" (already: web responsive), "Quanti utenti?" (already: 250-500), "Database?" (impl. detail)
✓ Ask: "Tablet propri o del ristorante?" (UX impact), "Solo al tavolo o anche delivery?" (scope impact)

### STEP 4: Add Questions in temrinal

**IMPORTANT**: Don't modify the file directly. Just ask questions in chat.
Come suggerimenti scrivi frasi che possano essere copiate e incollate in brief.md

```markdown
## Domande da chiarire

1. Che cosa intendi per [specific aspect]?
   Suggerimento: [proposed approach/default]
   Perché: [impact on requirements]

2. Ho bisogno che mi indichi [specific aspect]?
   Suggerimento: [proposed approach/default]
   Perché: [impact on requirements]

[... continue for 0-8 questions]

---
**Istruzioni**: 
   1. Apri brief.md
   2. Modificalo per far si che vi sia risposta alle domande poste sopra.  Se il suggerimento è corretto puoi copiarlo direttamente, oppure puoi scrivere quello che ritieni corretto.
   4. Quando hai finito, dimmi di procedere con Phase 2
```

---

## Edge Cases - Quick Reference

### Complete Brief (0 questions)
**Signal**: Problem, users, constraints, scope all clearly stated
**Action**: Output "Il brief è sufficientemente dettagliato. Procedo con Phase 2." → Skip to Phase 2

### Very Short Brief (4-6 basic questions)
**Signal**: "Need expense tracking app" (no details)
**Action**: Ask 4 basic questions: who uses, main problem, timeline/team, platform preference

### Technical Stack Mentioned (ignore, ask business)
**Signal**: "Want React + GraphQL + microservices..."
**Action**: Output "Chiedi di specificare le motivazioni per cui sono state richieste determinate tecnologie.

### Huge Scope (narrow down)
**Signal**: "Complete financial system with accounting, invoicing, tax, multi-currency..."
**Action**: Verifica ed evidenzia eventuali incongruenze chiedendo all'utente di dettaglaire come risolvere (sempre proponendo un default)"

### Regulatory Keywords (compliance questions)
**Signal**: "healthcare data", "financial transactions", "EU users"
**Action**: Ask 1-2 compliance questions (GDPR? HIPAA? jurisdiction?)

### Hardware/IoT Project (device + software questions)
**Signal**: "IoT sensor", "device", "hardware"
**Action**: 3-5 hardware-specific questions: device type, volume, connectivity, power, form factor
**Assumptions**: Off-shelf components, WiFi, cloud backend, 50-200 units MVP

---


## Conflict Detection

**When you spot conflicts**, flag them and add clarifying question:

Examples:
- "50 users" + "1M transactions/month" → Verify scale (20K tx/user/month?)
- "3 months" + "15 features" → Narrow to 4-5 core MVP features

**Action**: Flag in chat + add question to brief.md with pragmatic suggestion

---

## Checklist: Phase 1 Complete

### If Brief is Complete (0 questions):
- [ ] brief.md has been read with Read tool
- [ ] Evaluated that problem, users, constraints, scope are clear
- [ ] Output provided: "Il brief è sufficientemente dettagliato. Procedo con Phase 2."
- [ ] Proceed immediately to Phase 2

 ### If Questions Needed:
- [ ] brief.md has been read with Read tool
- [ ] Core problem extracted and stated clearly
- [ ] Project scope is clear
- [ ] Primary users identified
- [ ] Core functionalities and workflows identified
- [ ] User's technical level identified
- [ ] 0-8 clarification questions generated (ONLY necessary ones)
- [ ] Questions filtered: no technical questions for non-technical users
- [ ] Questions filtered: no questions about info already in brief
- [ ] Questions asked user with reasonable defaults/suggestions proposed for each question
- [ ] Any conflicts flagged and questioned
- [ ] User has clear instructions to answer in brief.md
- [ ] Output provided in chat with summary

**Then wait for user to answer questions in brief.md before Phase 2.**

---

## Tools Summary for Phase 1

1. **Read tool**: Read brief.md at start
2. **Output**: Provide structured response in chat (don't use tool for chat output)

**Do NOT**:
- Use Write or Edit tool 
- Skip the suggestion format in questions
- Create any new files in Phase 1 (only users modifies brief.md)
