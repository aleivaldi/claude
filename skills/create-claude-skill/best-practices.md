# Best Practices per Claude Skills

Documentazione completa delle best practices ufficiali per creare skills Claude di alta qualità.

---

## 0. Principi Architetturali Fondamentali

### Conciseness is Critical

Skills condividono il context window con conversazioni e altre Skills. Solo i metadata pre-loaded (name e description) consumano token all'avvio; SKILL.md si carica on-demand.

**Regola d'Oro**: Mantieni SKILL.md **sotto 500 righe**.

Per ogni pezzo di informazione chiediti: "Claude ha davvero bisogno di questo?" Se è conoscenza generale che Claude già possiede, rimuovila.

### Assume Claude is Smart

Evita spiegare concetti che Claude già conosce. Concentrati su informazioni **uniche al tuo dominio** piuttosto che su conoscenza generale.

❌ Non serve spiegare: "JSON è un formato di scambio dati..."
✅ Serve specificare: "Parse il JSON usando schema.json per validazione"

### Match Specificity to Task Fragility

Adatta il livello di specificità alla fragilità dell'operazione:

- **High freedom** (istruzioni testuali): Esistono molteplici approcci validi
- **Medium freedom** (pseudocodice/template): Pattern preferiti con elementi configurabili
- **Low freedom** (script specifici): Operazioni fragili che richiedono sequenze esatte

Esempio:
- High: "Analizza il codice e suggerisci miglioramenti" (creative task)
- Medium: "Segui questo template per l'analisi: [template]" (structured task)
- Low: "Esegui form_filler.py con questi parametri esatti" (fragile operation)

### Progressive Disclosure Architecture

Struttura le skills come un indice, dove Claude carica contenuto dettagliato solo quando necessario:

```
skill-name/
├── SKILL.md              # Overview, punta a references
├── reference.md          # Documentazione API dettagliata
├── examples.md           # Pattern di utilizzo
└── scripts/              # Utility eseguibili
```

**Tre pattern efficaci**:
1. **Guida high-level con references**: SKILL.md principale linka a file domain-specific caricati on-demand
2. **Organizzazione per dominio**: File di reference separati per dominio (finance.md, sales.md, product.md)
3. **Dettagli condizionali**: Mostra contenuto base inline, linka topic avanzati separatamente

**Linee guida chiave**:
- Mantieni references **un livello di profondità** da SKILL.md; evita nested references che causano letture incomplete
- Reference files più lunghi di 100 righe necessitano table of contents
- Usa nomi descrittivi (form_validation_rules.md, non doc2.md)

### Token Efficiency e Filesystem-Based Progressive Disclosure

Skills usano bash commands per leggere file on-demand. Solo metadata pre-caricati. Questo permette bundling di risorse complete (API docs, datasets, esempi) con **zero penalty** nel context fino all'accesso.

Scripts eseguono senza caricare codice in context—solo il loro output consuma token.

### Test Across Models

Valida skills con **Claude Haiku, Sonnet e Opus**. Ciò che funziona per modelli potenti può necessitare dettagli aggiuntivi per modelli più veloci.

### Avoid Time-Sensitive Information

**NON includere** informazioni che diventano obsolete. Usa sezioni "old patterns" con dettagli collapsed per approcci deprecati.

---

## 1. Struttura e Organizzazione

### File SKILL.md Obbligatorio

Ogni skill DEVE avere un file `SKILL.md` nella root directory con:

```markdown
---
name: Skill Name
description: Brief description of what the skill does
---

# Rest of the skill prompt
```

### Frontmatter Obbligatorio

**name** (obbligatorio):
- Max 64 caratteri
- SOLO lowercase letters, numbers, hyphens (no spaces, no underscores)
- NO XML tags, NO reserved words (anthropic, claude)
- Preferire **gerund form** (verb + -ing) o noun phrases
- Esempi buoni: "processing-pdfs", "analyzing-code-performance", "managing-databases"
- Esempi cattivi: "helper", "utils", "claude-tools", "My-Skill", "PROCESSOR"

**description** (obbligatorio):
- Max 1024 caratteri
- Scrivi in **terza persona** (NON "I can help you")
- Deve specificare **sia cosa fa sia quando usarla**
- Usa **termini chiave specifici** e contesti trigger
- Esempi buoni: "Analyzes Python code for performance bottlenecks, suggests optimizations, and generates detailed report with metrics. Use when analyzing .py files or when user mentions performance issues."
- Esempi cattivi: "Helps with code", "A useful skill for developers" (troppo vago)

### Organizzazione File

**Skill Semplice** (single-task, lineare):
```
skill-name/
  SKILL.md
```

**Skill Media** (multi-step, require template):
```
skill-name/
  SKILL.md
  templates/
    template.md
```

**Skill Complessa** (multi-fase, documentazione estesa):
```
skill-name/
  SKILL.md              # Overview e orchestrazione
  phase_1.md            # Fase 1 dettagliata
  phase_2.md            # Fase 2 dettagliata
  templates/
    template-1.md
    template-2.md
  docs/                 # Documentazione riferimento
    reference.md
  defaults.md           # Default values e assumptions
  examples/             # Esempi concreti
    example-1.md
```

**Principi**:
- SKILL.md è sempre l'entry point
- File ausiliari per dettagli, non per overview
- Template separati dal prompt
- Documentation separata da instructions

---

## 2. Writing Effective Prompts

### Principio Fondamentale: Specificità

❌ **Vago**: "Process the input appropriately"
✅ **Specifico**: "Read input.json with Read tool, parse JSON, validate schema against schema.json"

❌ **Vago**: "Handle errors gracefully"
✅ **Specifico**: "If Read fails: verify path exists, check permissions, ask user for alternative location"

### Use Consistent Terminology

Scegli un termine e mantienilo attraverso tutta la skill:
- Sempre "API endpoint" (NON alternare con "URL" o "path")
- Sempre "field" (NON alternare con "box" o "element")
- Sempre "configuration" (NON alternare con "settings" o "config")

**Rationale**: Terminologia inconsistente confonde Claude e porta a interpretazioni errate.

### Implement Workflows and Feedback Loops

Per task complessi, fornisci checklist che Claude può tracciare:

```markdown
## Workflow Checklist

- [ ] Step 1: Analyze form structure
- [ ] Step 2: Create field mapping
- [ ] Step 3: Validate mapping with user
- [ ] Step 4: Fill form fields
- [ ] Step 5: Verify output quality
```

Costruisci loop di validazione: run validator → fix errors → repeat.

```markdown
## Validation Loop

1. Generate output
2. Run validator script
3. If errors found:
   - Fix errors based on validator output
   - Return to step 2
4. If validation passes: proceed to next phase
```

### Struttura Prompt Efficace

```markdown
# Skill Name

## Il Tuo Compito / Your Task

[1-2 paragrafi introduttivi che spiegano:
- Cosa fa la skill
- Perché esiste
- Overview del processo se multi-step]

---

## [Workflow/Fase Name]

### Quando Usarlo/Usarla / When to Use

[Lista specifica di situazioni]
- User asks to [specific action]
- User provides [specific input]
- [Specific condition] is met

### Processo / Process

[Passi numerati, actionable, specifici]

1. **[Step Name]**: [Specific action] using [specific tool]
   - [Sub-action if needed]
   - [Conditional: if X then Y, else Z]

2. **[Step Name]**: [Specific action]
   - Output: [Exactly what this produces]

### Regole / Rules

[Lista ✅ DO e ❌ DON'T chiara]
- ✅ ALWAYS [specific action]
- ✅ Use [tool] for [purpose]
- ❌ NEVER [anti-pattern]
- ❌ DON'T [common mistake]

---

## Output Finale / Final Output

[Descrizione chiara e specifica del deliverable]
```

### Imperativo e Diretto

✅ **Buono**:
- "Read the file with Read tool"
- "Create documentation.md with Write tool"
- "Ask user to clarify scope using AskUserQuestion"

❌ **Cattivo**:
- "You should probably read the file"
- "Consider creating documentation"
- "Maybe ask the user about scope"

### Condizioni Esplicite

✅ **Buono**:
```markdown
If brief.md exists:
  - Read it with Read tool
  - Analyze content
  - Proceed to Phase 2
Else:
  - Ask user to create it
  - Wait for confirmation
  - Then proceed
```

❌ **Cattivo**:
```markdown
Handle the brief file appropriately
```

---

## 3. Tool Usage

### Regola d'Oro: Esplicità Assoluta

**SEMPRE specificare**:
- Quale tool usare
- Con quali parametri
- In quale ordine
- Perché

### Pattern Corretti

#### Read Before Edit (CRITICO)

✅ **Sempre**:
```markdown
1. Read existing_file.md with Read tool
2. Edit existing_file.md with Edit tool (replace old_string with new_string)
```

❌ **Mai**:
```markdown
Edit the file if it exists
```

**Rationale**: Edit senza Read causa errori con dati obsoleti o old_string non trovato.

#### Write for New, Edit for Existing

✅ **Corretto**:
```markdown
If file is new:
  - Use Write tool to create it
Else:
  - Use Read tool to read current content
  - Use Edit tool to modify it
```

❌ **Sbagliato**:
```markdown
- Use Write tool to update the file
```

**Rationale**: Write sovrascrive completamente, Edit preserva contenuto non modificato.

#### AskUserQuestion for Confirmations

✅ **Corretto**:
```markdown
Before proceeding, use AskUserQuestion to confirm:
- Question: "Should I proceed with deletion?"
- Options: ["Yes, delete", "No, keep it"]

Wait for user response. Do not proceed without confirmation.
```

❌ **Sbagliato**:
```markdown
Ask if user wants to proceed
```

#### Bash for System Operations ONLY

✅ **Corretto**:
```markdown
Use Bash tool for:
- git operations: git status, git commit
- package management: npm install, pip install
- system commands: mkdir, cd
```

❌ **Sbagliato**:
```markdown
Use Bash tool for:
- Reading files: cat file.txt (use Read tool instead)
- Writing files: echo "content" > file.txt (use Write/Edit instead)
- Searching: grep "pattern" *.js (use Grep tool instead)
```

### Tool Sequencing

**Operazioni Indipendenti** → Parallelo:
```markdown
Read file1.md and file2.md in parallel
```

**Operazioni Dipendenti** → Sequenziale:
```markdown
1. Read config.json (need content first)
2. Based on config, Edit settings.json (depends on step 1)
3. Validate with Bash: npm run validate (depends on step 2)
```

### Error Handling per Tool

Ogni tool usage deve avere error handling:

```markdown
## Gestione Errori / Error Handling

### If Read fails
- Verify file path is correct
- Check if file exists using Bash: ls [path]
- Ask user: "Cannot find [file]. Does it exist? Should I check a different location?"

### If Edit fails (old_string not found)
- Re-read the file (it may have changed)
- Verify old_string matches exactly (check whitespace, newlines)
- If still fails: explain to user what you're trying to replace and ask for guidance

### If Write fails (permissions)
- Check parent directory exists
- Verify write permissions
- Ask user: "Cannot write to [path]. Should I use a different location?"

### If AskUserQuestion gets no response
- Wait for user response
- Do not proceed with critical actions without confirmation
- Remind user what decision is needed
```

---

## 4. Examples and Anti-Patterns

### Usa Esempi Concreti

Gli esempi concreti aiutano Claude a capire esattamente cosa fare in situazioni specifiche.

✅ **Buono**:
```markdown
<example>
User: "Create API documentation for my Express.js endpoints"
Assistant: I'll create API documentation for your Express.js endpoints. Let me start by:
1. Reading your route files with Read tool
2. Analyzing endpoint definitions
3. Generating documentation in docs/api.md
</example>
```

❌ **Cattivo**:
```markdown
"When user asks for documentation, create it appropriately"
```

### Format degli Esempi

Usa tag `<example>` per casi complessi:

```markdown
<example>
Context: [Situazione specifica]
User: "[Richiesta utente]"
Assistant: "[Risposta attesa step-by-step]"
</example>
```

### Pattern: Template Pattern

Fornisci formati di output attesi, marcandoli come strict quando necessario:

```markdown
## Output Template

**ALWAYS use this exact template structure:**

```
# Analysis Report

## Summary
[2-3 bullet points of key findings]

## Detailed Findings
[Numbered list with line numbers and explanations]

## Recommendations
[Actionable next steps]
```

**DO NOT deviate from this structure.**
```

**Quando usarlo**: Per output che richiedono formato specifico e consistente.

### Pattern: Examples Pattern

Mostra coppie input/output che dimostrano lo stile e il livello di dettaglio desiderati.

```markdown
## Examples

### Example 1: Simple Function Analysis

**Input**: `def add(a, b): return a + b`

**Expected Output**:
- Function name: add
- Parameters: a, b
- Complexity: O(1)
- Recommendation: Add type hints

### Example 2: Complex Loop Analysis

**Input**: `for i in range(1000000): process(data[i])`

**Expected Output**:
- Loop iterations: 1,000,000
- Complexity: O(n)
- Bottleneck: Array access in tight loop
- Recommendation: Consider vectorization with numpy
```

**Quando usarlo**: Specialmente per task stilistici come commit messages, documentation, o analysis reports.

### Anti-Pattern Comuni

Documenta cosa NON fare:

❌ **Anti-Pattern 1: Vaghe Istruzioni**
```markdown
"Process the files as needed"
```
**Problema**: Claude non sa cosa significa "as needed"

✅ **Corretto**:
```markdown
"Read all .js files in src/ directory using Glob tool with pattern 'src/**/*.js', then analyze each with Read tool"
```

❌ **Anti-Pattern 2: Assunzioni Implicite**
```markdown
"Update the configuration"
```
**Problema**: Quale config? Come? Con quale tool?

✅ **Corretto**:
```markdown
"Read config.json with Read tool, then use Edit tool to replace 'port: 3000' with 'port: 8080'"
```

❌ **Anti-Pattern 3: Tool Usage Ambiguo**
```markdown
"Get the file content somehow"
```
**Problema**: Bash cat? Read tool? Quale?

✅ **Corretto**:
```markdown
"Read file.txt using Read tool (NOT Bash cat command)"
```

---

## 5. Scope e Boundaries

### Definisci Cosa FA

Specifica esplicitamente le responsabilità della skill:

```markdown
## Scope di Questa Skill

Questa skill:
- ✅ Analizza file Python per performance bottlenecks
- ✅ Genera report con metriche dettagliate
- ✅ Suggerisce ottimizzazioni specifiche
```

### Definisci Cosa NON FA

Altrettanto importante:

```markdown
Questa skill NON:
- ❌ Modifica il codice direttamente (usa skill `refactor-python` per questo)
- ❌ Esegue il codice (usa skill `test-runner` per testing)
- ❌ Gestisce altri linguaggi oltre Python
```

### Riferimenti ad Altre Skills

Quando appropriato, guida l'utente verso skills correlate:

```markdown
## Skills Correlate

**Se vuoi applicare le ottimizzazioni**: Usa skill `refactor-python`
**Se vuoi testare le performance**: Usa skill `benchmark-python`
**Per analisi generica codice**: Usa skill `code-review`
```

---

## 6. Testing e Validazione

### Self-Testing Mental Model

Prima di finalizzare una skill, esegui mental simulation:

**Checklist Mental Test**:
1. ❓ Input realistici producono output corretti?
2. ❓ Ogni step è actionable e specifico?
3. ❓ Tool usage è esplicito e ordinato correttamente?
4. ❓ Edge cases sono gestiti?
5. ❓ Error handling è presente per ogni tool?
6. ❓ User può capire cosa aspettarsi?

### Test con Caso Reale

Dopo creazione, testa con scenario concreto:

```markdown
## Test Case

**Input**: User chiede "Analizza performance di main.py"
**Expected Flow**:
1. Read main.py
2. Analyze code structure
3. Identify bottlenecks (loops, I/O, algorithms)
4. Generate report in performance-analysis.md
5. Present findings to user

**Expected Output**: File performance-analysis.md con sezioni:
- Executive Summary
- Bottlenecks Found (con line numbers)
- Optimization Suggestions (specifiche e actionable)
- Impact Estimates
```

### Iterazione Basata su Feedback

Skills migliorano con uso:

1. **Raccogli feedback** da esecuzioni reali
2. **Identifica pattern** di fallimento/confusione
3. **Aggiorna prompt** per chiarire ambiguità
4. **Aggiungi esempi** per casi problematici
5. **Raffina error handling** per errori comuni

---

## 7. Maintainability

### Versionamento e Changelog

Per skills complesse, considera:

```markdown
## Changelog

### v1.2.0 (2024-01-15)
- Added support for async/await analysis
- Improved error handling for malformed Python
- Added examples for complex decorators

### v1.1.0 (2024-01-10)
- Fixed issue with nested function analysis
- Enhanced report formatting

### v1.0.0 (2024-01-05)
- Initial release
```

### Modularità

Skills grandi devono essere modulari:

- **SKILL.md**: Overview e orchestrazione
- **phase_N.md**: Dettagli implementativi
- **templates/**: Template riusabili
- **docs/**: Reference documentation

**Rationale**: Più facile aggiornare parte specifica senza rompere tutto

### Documentazione dei Cambiamenti

Quando modifichi skill esistente:

```markdown
## Recent Updates

**2024-01-15**: Added Bash error handling for permission issues
**2024-01-12**: Clarified when to use Read vs Grep for file searching
**2024-01-10**: Added examples for multi-file analysis
```

---

## 8. Best Practices Summary

### DO ✅

1. **Mantieni SKILL.md sotto 500 righe** (conciseness is critical)
2. **Specificità assoluta** in ogni istruzione
3. **Tool usage esplicito** (quale, quando, perché)
4. **Read before Edit** sempre
5. **Error handling** per ogni tool
6. **Esempi concreti** per casi complessi
7. **Condizioni esplicite** (if-then-else chiari)
8. **Scope boundaries** (cosa FA e NON FA)
9. **Validazione utente** per azioni critiche (AskUserQuestion)
10. **Frontmatter completo** (name max 64 char, description max 1024 char)
11. **Struttura modulare** con progressive disclosure (references un livello deep)
12. **Terminologia consistente** attraverso tutta la skill
13. **Test con Haiku, Sonnet e Opus**
14. **Build 3+ evaluations** prima di scrivere documentazione estesa
15. **Match specificity to task fragility** (high/medium/low freedom)
16. **Verifiable intermediate outputs** per batch operations
17. **Default to execution** per utility scripts
18. **Assume Claude is smart** (no spiegazioni concetti base)
19. **Avoid time-sensitive information**
20. **Justified constants** (no magic numbers)

### DON'T ❌

1. **Istruzioni vaghe** ("handle appropriately")
2. **Tool impliciti** ("get the content")
3. **Edit senza Read** (causa errori)
4. **Nessun error handling**
5. **Assunzioni non documentate**
6. **Scope infinito** (skill fa troppo)
7. **Write su file esistenti** (usa Edit)
8. **Bash per file operations** (usa Read/Write/Edit/Grep)
9. **Nessuna validazione** per azioni pericolose
10. **Frontmatter incompleto** o mancante
11. **Deeply nested references** (causa letture incomplete)
12. **Magic numbers** senza giustificazione
13. **Excessive options** (lista di approcci equivalenti)
14. **Vague content** ("helps with documents")
15. **Generic names** ("helper", "utils", "processor")
16. **Terminologia inconsistente**
17. **Documentazione estesa senza evaluations** (test first!)

---

## 9. Common Pitfalls

### Pitfall 1: "Smart Defaults" Non Documentati

❌ **Problema**:
```markdown
"Use sensible defaults for configuration"
```

✅ **Soluzione**:
```markdown
"Use these defaults (can be overridden by user):
- port: 8080
- timeout: 30s
- retries: 3

Ask user with AskUserQuestion if they want to change defaults before proceeding."
```

### Pitfall 2: Tool Sequencing Errato

❌ **Problema**:
```markdown
"Edit config.json to update port, then read it to verify"
```

✅ **Soluzione**:
```markdown
"1. Read config.json with Read tool
2. Edit config.json with Edit tool to replace old port value
3. Read config.json again to verify changes"
```

### Pitfall 3: Mancanza Fallback Paths

❌ **Problema**:
```markdown
"Read settings.json and proceed with configuration"
```

✅ **Soluzione**:
```markdown
"Try to read settings.json with Read tool.

If successful:
- Parse configuration
- Proceed to next step

If Read fails (file not found):
- Ask user: 'settings.json not found. Should I create default settings or use different path?'
- Wait for response
- Act accordingly"
```

### Pitfall 4: Output Non Specificato

❌ **Problema**:
```markdown
"Generate report about the analysis"
```

✅ **Soluzione**:
```markdown
"Generate report.md with Write tool containing:
- # Analysis Report header
- ## Summary section (2-3 bullet points)
- ## Findings section (detailed list with line numbers)
- ## Recommendations section (actionable next steps)
- Total: 500-1000 words approximately"
```

---

## 10. Advanced Patterns

### Pattern: Multi-Phase Workflows

Per processi complessi, usa fasi separate:

```markdown
## Workflow Overview

This skill operates in **3 phases**:

1. **Discovery Phase**: Analyze input and gather context
2. **Processing Phase**: Transform/analyze data
3. **Output Phase**: Generate deliverables

Each phase is detailed in separate files for maintainability.
```

### Pattern: Conditional Workflows

Gestisci branches con chiarezza:

```markdown
## Workflow Selection

**Determine user intent** using these conditions:

If user provides existing file path:
→ Use Workflow A (Analysis)

If user wants to create new artifact:
→ Use Workflow B (Generation)

If user asks for validation only:
→ Use Workflow C (Validation)

Ask with AskUserQuestion if intent is unclear.
```

### Pattern: Iterative Refinement

Skills che migliorano output iterativamente:

```markdown
## Iterative Process

1. **Initial Draft**: Generate first version
2. **Present to User**: Show draft and ask for feedback
3. **Gather Feedback**: Use AskUserQuestion with options:
   - "Looks good, finalize"
   - "Needs changes: [specify]"
   - "Start over with different approach"
4. **Refine**: Apply feedback and repeat from step 2
5. **Finalize**: When user approves, create final version
```

### Pattern: Utility Scripts (Solve, Don't Punt)

Fornisci script pre-built piuttosto che generare codice al momento:

**Vantaggi**:
- Maggiore reliability
- Minor costo token
- Esecuzione più veloce
- Consistenza

**Gestione Errori negli Script**:
- Handle error conditions explicitly rather than failing
- Usa messaggi di errore espliciti: "Field 'signature_date' not found. Available fields: customer_name, order_total..."
- Documenta package dependencies richiesti
- Verifica che packages siano disponibili nell'ambiente di esecuzione
- Include justified configuration parameters con spiegazioni (NO voodoo constants)

**Path Conventions**:
- Usa sempre forward slashes (scripts/helper.py, non scripts\helper.py) per compatibilità cross-platform

**MCP Tool References**:
- Usa fully qualified names: "ServerName:tool_name" (es. "BigQuery:bigquery_schema")

**Default to Execution**:
Quando fornisci utility scripts, rendi chiara l'intenzione di esecuzione:
- ✅ "Run `analyze_form.py` to extract fields"
- ❌ "See `analyze_form.py` for the algorithm"

Scripts sono fatti per essere eseguiti, non solo letti.

### Pattern: Verifiable Intermediate Outputs

Per operazioni batch: analyze → create plan file → validate plan → execute → verify.

Questo cattura errori **prima** di applicare cambiamenti.

```markdown
## Batch Operation Process

1. **Analyze**: Read all target files and create operation plan
2. **Generate Plan**: Write plan.json with all intended changes
3. **Validate Plan**: Present plan to user, ask for confirmation
4. **Execute**: Apply changes only after validation
5. **Verify**: Check results and report success/failures
```

### Pattern: Visual Analysis

Converti PDFs in immagini e fai analizzare layout visivamente a Claude quando la struttura è importante.

```markdown
## Visual PDF Analysis

For complex forms or documents where layout matters:
1. Convert PDF pages to images (pdf2image)
2. Use Read tool on images (Claude is multimodal)
3. Analyze visual structure and field positions
4. Map fields based on visual layout
```

---

## 11. Evaluation e Iteration

### Build Evaluations First

**SEMPRE** crea test scenarios prima di documentazione estensiva:

**Workflow Raccomandato**:
1. **Identifica gap reali** nelle performance di Claude
2. **Costruisci 3 evaluations rappresentative** (minimo)
3. **Stabilisci baseline** senza la skill
4. **Scrivi minimal instructions** per passare le evaluations
5. **Itera basandoti su failure reali**

❌ **Anti-Pattern**: Scrivere 50 pagine di documentazione e sperare funzioni
✅ **Best Practice**: Test → Minimal docs → Iterate → Expand

### Develop Skills with Claude's Help

Usa due istanze di Claude:
- **Claude A**: Crea e itera la skill
- **Claude B**: Testa su task reali

**Workflow**:
1. Claude B usa la skill per task reale
2. Osserva comportamento di Claude B
3. Riporta insights a Claude A
4. Claude A itera basandosi su **uso osservato**, non assunzioni

### Observe Navigation Patterns

Osserva come Claude usa la tua skill:
- Legge file in ordine inaspettato?
- Ignora certe references?
- Si confonde in punti specifici?

Questo rivela **problemi strutturali** da sistemare.

---

## 12. Anti-Patterns da Evitare

### Anti-Pattern: Excessive Options

❌ **Non fare**: Elencare molteplici approcci equivalenti

✅ **Fai**: Fornisci un metodo raccomandato con escape hatch per eccezioni

```markdown
✅ Buono:
"Use pdfplumber for text extraction. For scanned PDFs requiring OCR, use pdf2image with pytesseract instead."

❌ Cattivo:
"You can use pdfplumber, or PyPDF2, or pdfminer, or camelot, or tabula-py..."
```

### Anti-Pattern: Magic Numbers

❌ **Non fare**: Usare costanti arbitrarie senza giustificazione

```python
# Perché 47? Numero magico!
timeout = 47
```

✅ **Fai**: Giustifica ogni costante

```python
# Timeout empirico per API lente (95th percentile di risposta + buffer)
timeout = 45
```

### Anti-Pattern: Deeply Nested References

❌ **Non fare**: References annidate che causano letture incomplete

```
SKILL.md → references section1.md → references subsection1a.md
```

✅ **Fai**: Tutti i references **un livello di profondità** da SKILL.md

```
SKILL.md → section1.md
SKILL.md → section2.md
SKILL.md → section3.md
```

### Anti-Pattern: Vague Content

❌ Vago: "helps with documents", "processes data"
✅ Specifico: "Extracts text and tables from PDF files, fills PDF forms, merges multiple PDFs"

### Anti-Pattern: Overly Generic Names

❌ Cattivo: "helper", "utils", "processor", "tool"
✅ Buono: "processing-pdfs", "analyzing-sql-queries", "validating-json-schemas"

---

## Conclusione

### Skills Claude di Qualità Richiedono

- **Chiarezza** > ambiguità
- **Specificità** > generalità
- **Struttura** > caos
- **Testing** > speranza
- **Conciseness** > verbosità

### Key Architectural Principles Recap

1. **Filesystem-Based Progressive Disclosure**: Skills usano bash commands per leggere file on-demand. Solo metadata pre-caricati. Questo permette bundling di risorse complete (API docs, datasets, esempi) con zero context penalty fino all'accesso.

2. **Token Efficiency**: Scripts eseguono senza caricare codice in context—solo il loro output consuma token. Reference files caricano completamente quando necessari, supportando il modello di accesso selettivo.

3. **Default to Execution**: Quando fornisci utility scripts, rendi chiara l'intenzione di esecuzione. Scripts sono fatti per essere eseguiti, non solo letti.

4. **Match Specificity to Task Fragility**: Adatta il livello di specificità alla fragilità dell'operazione (high/medium/low freedom).

5. **Build Evaluations First**: Crea 3+ test scenarios prima di documentazione estensiva. Test → Minimal docs → Iterate → Expand.

### Seguendo Queste Best Practices, Creerai Skills

- Affidabili e predicibili
- Facili da mantenere
- User-friendly
- Production-ready
- Token-efficient
- Testabili e iterabili

### Risorse Aggiuntive

- Documentazione ufficiale: https://docs.claude.com/en/docs/agents-and-tools/agent-skills
- Best practices guide: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices
- Skill examples: Consulta le skills esistenti in `.claude/skills/` per pattern concreti