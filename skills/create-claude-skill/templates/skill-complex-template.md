---
name: [Skill Name - Max 50 chars, descrittivo]
description: [Descrizione completa: cosa fa, input/output attesi, quando usarla, workflow supportati - 150-200 chars]
---

# [Skill Name]

## Il Tuo Compito

[2-3 paragrafi introduttivi che spiegano:
- Cosa fa la skill in dettaglio
- Perché esiste e problema che risolve
- Overview dei workflow supportati]

Questa skill supporta **N workflow principali**:

1. **[Workflow 1]**: [Descrizione e quando usarlo]
2. **[Workflow 2]**: [Descrizione e quando usarlo]
3. **[Workflow N]**: [Descrizione e quando usarlo]

---

## Regola Linguistica

**Adatta la lingua al contesto**:
- Se [condizione 1] → rispondi in [lingua]
- Se [condizione 2] → rispondi in [lingua]
- Se [condizione 3] → rispondi in [lingua]
- Cambia lingua solo se utente lo richiede esplicitamente

---

## Workflow 1: [Nome Workflow]

### Quando Usarlo

[Lista dettagliata situazioni]
- L'utente [scenario 1]
- L'utente [scenario 2]
- [Condizione specifica] è vera

### Processo in [N] Fasi

#### Fase 1: [Nome Fase]
**Obiettivo**: [Cosa raggiunge questa fase]

1. **[Step Name]**: [Azione dettagliata] con [Tool]
   - [Sub-azione 1]
   - [Sub-azione 2]
   - Output: [Cosa produce questo step]

2. **[Step Name]**: [Azione condizionale]
   - Se [condizione A]: [azione specifica]
   - Altrimenti se [condizione B]: [azione alternativa]
   - Altrimenti: [default action]

3. **[Step Name]**: [Azione finale fase]
   - Deliverable fase: [Descrizione]

#### Fase 2: [Nome Fase]
**Obiettivo**: [Cosa raggiunge questa fase]

[Ripeti struttura step come Fase 1]

#### Fase N: [Nome Fase]
**Obiettivo**: [Finalizzazione]

[Step finali]

### Regole Critiche Workflow 1

- ✅ **SEMPRE** [regola critica 1]
- ✅ **SEMPRE** [regola critica 2]
- ✅ [Best practice specifica]
- ❌ **MAI** [anti-pattern 1]
- ❌ **MAI** [anti-pattern 2]
- ❌ [Errore comune da evitare]

---

## Workflow 2: [Nome Workflow]

[Ripeti struttura completa di Workflow 1]

---

## Workflow N: [Nome Workflow]

[Ripeti struttura completa]

---

## Materiali di Riferimento

**Processi Dettagliati**:
- `phase_1.md` - [Descrizione dettagli Fase 1]
- `phase_2.md` - [Descrizione dettagli Fase 2]
- `phase_N.md` - [Descrizione dettagli Fase N]

**Template**:
- `templates/template-1.md` - [Descrizione e uso]
- `templates/template-2.md` - [Descrizione e uso]

**Documentazione**:
- `docs/reference.md` - [Documentazione reference]
- `defaults.md` - [Default values e assumptions]

**Esempi**:
- `examples/example-1.md` - [Esempio caso d'uso 1]
- `examples/example-2.md` - [Esempio caso d'uso 2]

**Skill Correlate**:
- `skill-correlata-1` - [Quando usarla e relazione]
- `skill-correlata-2` - [Quando usarla e relazione]

---

## Uso Tool (⚠️ SEQUENZA CRITICA)

### Best Practices Generali

- ✅ **SEMPRE** Read prima di Edit (prevenire dati obsoleti)
- ✅ **SEMPRE** [altra regola critica]
- ✅ Write SOLO per file nuovi
- ✅ Edit per file esistenti (MAI Write)
- ✅ AskUserQuestion per [decisioni critiche]
- ✅ [Pattern specifico skill]
- ❌ **MAI** Edit senza Read prima
- ❌ **MAI** Bash per file operations (usa Read/Write/Edit/Grep)
- ❌ **MAI** [anti-pattern specifico]

### Tool Sequencing per Workflow

**Workflow 1**:
```
1. Read [file1] e [file2] in parallelo
2. [Analisi basata su step 1]
3. Write [output1] (dipende da step 2)
4. AskUserQuestion [conferma]
5. Procedi basandoti su risposta
```

**Workflow 2**:
```
[Sequenza specifica]
```

### Tool Specifici per Fase

**Fase 1**: [Tool necessari e sequenza]
**Fase 2**: [Tool necessari e sequenza]
**Fase N**: [Tool necessari e sequenza]

---

## Gestione Errori

### Errori Tool Comuni

#### Se Read fallisce
- Verifica file path corretto
- Controlla esistenza con Bash: `ls [path]`
- Chiedi utente: "[Messaggio specifico]"
- Se ancora problemi: [fallback action]

#### Se Write fallisce
- Verifica directory padre esiste
- Controlla permessi scrittura
- Proponi location alternativa
- Se ancora problemi: [fallback action]

#### Se Edit fallisce (old_string not found)
- Re-read file (potrebbe essere cambiato)
- Verifica old_string esatto (whitespace, newlines)
- Se ancora fallisce: spiega utente e chiedi guidance
- Fallback: [azione alternativa]

#### Se Bash comando fallisce
- [Gestione specifica]

#### Se AskUserQuestion non riceve risposta
- Wait for user response
- Non procedere con azioni critiche
- Remind user della decisione necessaria

### Errori Specifici Workflow

**Workflow 1**:
- Se [condizione errore specifica]: [recovery action]
- Se [altra condizione]: [recovery action]

**Workflow 2**:
- [Gestione specifica]

### Edge Cases

**Edge Case 1: [Descrizione]**
- Riconoscimento: [Come identificare]
- Azione: [Cosa fare]

**Edge Case 2: [Descrizione]**
- Riconoscimento: [Come identificare]
- Azione: [Cosa fare]

---

## Avvio Workflow

Quando l'utente invoca questa skill:

1. **Analizza richiesta** e identifica:
   - Intent primario (quale workflow?)
   - Input forniti
   - Output desiderati
   - Contesto aggiuntivo

2. **Determina workflow**:
   - Se [condizione 1] → Workflow 1
   - Se [condizione 2] → Workflow 2
   - Se [condizione N] → Workflow N
   - Se ambiguo → AskUserQuestion con opzioni chiare

3. **Pre-Flight Checks**:
   - [Verifica prerequisiti]
   - [Check disponibilità risorse]
   - [Validazione input]

4. **Conferma all'utente**:
   - "[Messaggio conferma workflow e piano]"
   - Se multi-step: presenta overview step

5. **Procedi** con workflow selezionato

---

## Output Finale

[Descrizione dettagliata deliverable]

### Workflow 1 Output

Il deliverable è **[nome file/artifact]**:

- **Formato**: [Markdown/JSON/altro]
- **Location**: [Dove salvato]
- **Struttura**:
  - Sezione 1: [Descrizione]
  - Sezione 2: [Descrizione]
  - Sezione N: [Descrizione]
- **Contenuto**: [Dettagli contenuto]
- **Dimensione**: [Approssimativa]

### Workflow 2 Output

[Descrizione output specifico]

### Workflow N Output

[Descrizione output specifico]

---

## Esempi Completi

### Esempio Workflow 1

<example>
Context: [Situazione dettagliata]
User: "[Richiesta utente completa]"
Assistant: "[Risposta dettagliata step-by-step mostrando:
- Analisi richiesta
- Selezione workflow
- Esecuzione step
- Output generato]"
</example>

### Esempio Workflow 2

<example>
[Scenario diverso con esempio completo]
</example>

---

## Principi Guida

1. **[Principio 1]**: [Descrizione e rationale]
2. **[Principio 2]**: [Descrizione e rationale]
3. **[Principio 3]**: [Descrizione e rationale]
4. **[Principio N]**: [Descrizione e rationale]

---

## Validazione e Quality Check

Prima di finalizzare output:

- [ ] [Check 1 specifico]
- [ ] [Check 2 specifico]
- [ ] [Check N specifico]
- [ ] Tutti deliverable generati correttamente
- [ ] Nessun TODO o placeholder rimasto
- [ ] User informato di completamento

---

## Maintenance Notes

[OPZIONALE - Note per manutenzione futura]

**Aree comuni di modifica**:
- [Area 1]: [Dove e perché]
- [Area 2]: [Dove e perché]

**Quando aggiornare**:
- [Trigger 1]: [Azione raccomandata]
- [Trigger 2]: [Azione raccomandata]
