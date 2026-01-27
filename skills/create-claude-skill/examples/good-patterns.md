# Good Patterns - Esempi di Skill Ben Fatte

Questa documentazione raccoglie esempi concreti di pattern corretti per creare skills Claude di qualità.

---

## Pattern 1: Tool Usage Esplicito

### ✅ Esempio Corretto

```markdown
## Processo

1. **Leggi file input**: Usa Read tool per leggere `input.json`
   - Se Read fallisce: verifica path con `ls input.json`, chiedi utente location corretta

2. **Valida JSON**: Parse contenuto JSON
   - Se malformato: segnala errore all'utente con dettagli specifici
   - Se valido: procedi a step 3

3. **Genera output**: Crea `output.md` con Write tool contenente:
   - Header `# Analysis Results`
   - Sezione Summary (2-3 bullet points)
   - Sezione Details (lista dettagliata findings)
```

**Perché funziona**:
- Tool specificato esplicitamente (Read, Write)
- Parametri chiari (file paths)
- Error handling per ogni step
- Output specificato (struttura esatta file)

---

## Pattern 2: Condizioni Esplicite

### ✅ Esempio Corretto

```markdown
## Workflow Selection

Determina quale workflow usare basandoti su:

**Se utente fornisce file path esistente**:
→ Leggi file con Read tool
→ Analizza contenuto
→ Usa Workflow A (Analysis)

**Se utente chiede di creare nuovo file**:
→ Chiedi template desiderato con AskUserQuestion
→ Genera contenuto
→ Usa Workflow B (Generation)

**Se intent non chiaro**:
→ Usa AskUserQuestion con opzioni:
  - "Analyze existing file"
  - "Create new file"
  - "Other (please specify)"
→ Procedi basandoti su risposta
```

**Perché funziona**:
- Condizioni if-then-else esplicite
- Azioni specifiche per ogni branch
- Gestione ambiguità con AskUserQuestion
- Nessun caso lasciato indefinito

---

## Pattern 3: Read Before Edit

### ✅ Esempio Corretto

```markdown
## Aggiornamento Configurazione

1. **Leggi config corrente**: Read `config.json` con Read tool
   - Store contenuto in memoria per reference

2. **Identifica sezione da modificare**: Trova riga con `"port": 3000`

3. **Applica modifica**: Usa Edit tool su `config.json`
   - old_string: `"port": 3000`
   - new_string: `"port": 8080`

4. **Verifica modifica**: Re-read `config.json` per confermare cambio avvenuto
   - Se old_string non trovato: re-read e cerca pattern simile
   - Se Edit fallisce: segnala utente con dettagli errore
```

**Perché funziona**:
- Read PRIMA di Edit (evita dati obsoleti)
- old_string specificato esattamente
- Verifica post-modifica
- Error handling robusto

---

## Pattern 4: Error Handling Completo

### ✅ Esempio Corretto

```markdown
## Gestione Errori

### Se Read fallisce

**Azione 1**: Verifica file path
- Usa Bash: `ls [directory path]` per vedere contenuto directory
- Identifica se typo nel nome file

**Azione 2**: Chiedi all'utente
- Messaggio: "Non trovo [filename] in [path]. Ho trovato questi file: [lista]. Quale dovrei leggere?"
- Aspetta risposta utente

**Azione 3**: Retry con path corretto
- Se utente fornisce path alternativo: riprova Read
- Se utente dice file non esiste: chiedi se crearne uno nuovo

**Fallback**: Se tutte azioni falliscono
- Segnala impossibilità di procedere
- Suggerisci prossimi step alternativi

### Se Write fallisce (permissions)

**Azione 1**: Verifica directory padre
- Bash: `ls -la [parent directory]` per vedere permessi
- Identifica se directory esiste e è scrivibile

**Azione 2**: Proponi alternative
- Messaggio: "Non posso scrivere in [path] per permessi insufficienti. Posso provare in: [location 1], [location 2]. Quale preferisci?"
- Aspetta scelta utente

**Azione 3**: Retry in location alternativa
- Procedi con location scelta da utente
```

**Perché funziona**:
- Azioni recovery specifiche e actionable
- Non lascia utente bloccato
- Propone alternative concrete
- Escalation chiara (Azione 1 → 2 → 3 → Fallback)

---

## Pattern 5: Validazione Utente

### ✅ Esempio Corretto

```markdown
## Prima di Sovrascrivere File

**Check preliminare**:
1. Verifica se `output.md` già esiste con Bash: `ls output.md`

**Se file esiste**:

2. Leggi contenuto esistente con Read tool
3. Presenta summary all'utente: "Ho trovato output.md esistente con [breve descrizione contenuto]"
4. Chiedi conferma con AskUserQuestion:
   - Question: "Il file output.md esiste già. Come vuoi procedere?"
   - Options:
     - label: "Sovrascrivi"
       description: "Elimina contenuto esistente e crea nuovo file"
     - label: "Backup e crea nuovo"
       description: "Rinomina esistente a output.backup.md, poi crea nuovo"
     - label: "Annulla"
       description: "Non modificare nulla"
   - multiSelect: false

5. Aspetta risposta utente (NON procedere senza)

6. Agisci basandoti su scelta:
   - Se "Sovrascrivi": Write output.md direttamente
   - Se "Backup": Bash `mv output.md output.backup.md` poi Write output.md
   - Se "Annulla": Termina processo, segnala all'utente

**Se file NON esiste**:
→ Procedi direttamente con Write (no conferma necessaria)
```

**Perché funziona**:
- Check preventivo (verifica esistenza)
- Informazione contestuale (mostra cosa esiste)
- AskUserQuestion con opzioni chiare
- Rispetta scelta utente completamente
- Non assume default per azioni critiche

---

## Pattern 6: Output Specificato

### ✅ Esempio Corretto

```markdown
## Output Finale

Il deliverable di questa skill è **`analysis-report.md`** con struttura:

**Header**:
```
# Code Analysis Report
**Generated**: [Data ISO 8601]
**Analyzed Files**: [Count]
```

**Summary Section**:
- 3-5 bullet points con key findings
- Max 150 parole
- Focus su issues critici

**Detailed Findings**:
- Lista numerata di tutti findings
- Ogni finding include:
  - File path e line number (es. `src/main.js:42`)
  - Severity (Critical/High/Medium/Low)
  - Descrizione issue (2-3 frasi)
  - Recommended fix (actionable)

**Recommendations**:
- Top 5 azioni prioritizzate
- Ogni raccomandazione: cosa fare e perché

**Appendix** (opzionale):
- Metriche statistiche
- Files analyzed list completa

**Dimensione totale**: 1000-2000 parole
**Location**: Same directory del progetto analizzato
```

**Perché funziona**:
- Struttura esatta specificata
- Formato di ogni sezione chiaro
- Contenuto atteso dettagliato
- Dimensione/scope definito
- Location output esplicita

---

## Pattern 7: Multi-Phase con Checkpoint

### ✅ Esempio Corretto

```markdown
## Processo in 3 Fasi

### Fase 1: Discovery

1. [Step Discovery...]
2. [...]
3. **Checkpoint Fase 1**:
   - Presenta all'utente: "Ho trovato [N files], [N issues potenziali]. Vuoi che proceda con analisi dettagliata?"
   - AskUserQuestion: Procedi? [Sì/No/Modifica scope]
   - Se No: termina qui
   - Se Modifica scope: chiedi nuovi parametri e riparti

### Fase 2: Analysis

[SOLO se Fase 1 approvata]

1. [Step Analysis...]
2. [...]
3. **Checkpoint Fase 2**:
   - Presenta draft findings all'utente
   - Chiedi: "Questi findings ti sembrano corretti? Vuoi che generi report finale?"
   - Se No: raccogli feedback e re-analizza

### Fase 3: Report Generation

[SOLO se Fase 2 approvata]

1. [Step Generation...]
2. Genera report finale
3. Presenta all'utente per review finale
```

**Perché funziona**:
- Checkpoints tra fasi critiche
- Utente può intervenire/correggere early
- Evita lavoro inutile se direzione sbagliata
- Feedback loop stretto

---

## Pattern 8: Esempi Concreti

### ✅ Esempio Corretto

```markdown
## Esempi Uso

<example>
Context: User ha progetto Node.js con 50 file JavaScript
User: "Analizza il mio codice per performance issues"
Assistant: "Analizzerò il tuo progetto Node.js per performance issues. Ecco il mio piano:

1. Uso Glob tool per trovare tutti file *.js in src/
2. Leggo ogni file e analizzo per:
   - Synchronous operations che bloccano event loop
   - N+1 query patterns
   - Memory leaks potenziali
   - Algoritmi O(n²) o peggio
3. Genero performance-analysis.md con findings e raccomandazioni

Procedo? [Yes/No/Modify scope]"

[User conferma]