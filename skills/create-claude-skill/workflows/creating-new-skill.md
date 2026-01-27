# Workflow 1: Creazione Nuova Skill

## Quando Usarlo
- L'utente chiede di creare una nuova skill
- L'utente descrive un task che vorrebbe automatizzare
- L'utente vuole trasformare un processo ripetitivo in skill

## Processo in 5 Fasi

### Fase 1: Discovery e Planning
**Obiettivo**: Capire cosa la skill deve fare

1. **Leggi richiesta utente** e identifica:
   - Task principale che la skill deve svolgere
   - Input attesi (file, informazioni dall'utente, ecc.)
   - Output desiderati (file generati, analisi, report, ecc.)
   - Complessità (semplice, media, complessa)

2. **Poni domande di chiarimento** (usando AskUserQuestion) su:
   - Scope esatto della skill (cosa FA e cosa NON FA)
   - Tool necessari (Read, Write, Edit, Bash, Grep, Glob, AskUserQuestion, ecc.)
   - Processo step-by-step ideale
   - Edge cases da gestire
   - Skills correlate (se esistono)

3. **Valuta complessità**:
   - **Semplice**: Single-file skill, processo lineare
   - **Media**: Multi-file, require template o docs
   - **Complessa**: Multi-fase, require validation, template multipli

### Fase 2: Design Struttura
**Obiettivo**: Pianificare file e organizzazione

Basandoti sulla complessità, proponi struttura:

**Skill Semplice**:
```
skill-name/
  SKILL.md          # Main prompt
```

**Skill Media**:
```
skill-name/
  SKILL.md          # Main prompt
  templates/        # Template files
    template.md
```

**Skill Complessa**:
```
skill-name/
  SKILL.md          # Main prompt overview
  phase_1.md        # Detailed phase instructions
  phase_2.md
  phase_N.md
  templates/        # Templates
    template-1.md
  docs/            # Reference documentation
    reference.md
  defaults.md      # Default values/assumptions
```

**Chiedi conferma** all'utente sulla struttura proposta.

### Fase 3: Scrittura SKILL.md
**Obiettivo**: Creare il prompt principale della skill

**Struttura Obbligatoria** - Consulta `templates/skill-template.md` per template completo:

```markdown
---
name: skill-name-here  # lowercase+hyphens, gerund form, max 64 char
description: [Cosa fa + quando usarla, terza persona, max 1024 char]
---

# Skill Name

## Il Tuo Compito
[Cosa fa, perché esiste, overview processo]

## [Workflow/Fase Name]
### Quando Usarlo/Usarla
### Processo
### Regole Critiche

## Materiali di Riferimento  # Se hai file ausiliari
## Uso Tool (⚠️ CRITICO)
## Gestione Errori
## Output Finale
```

**Best Practices Critiche**:
- **Frontmatter**: name lowercase+hyphens only, max 64; description terza persona, max 1024
- **SKILL.md < 500 righe**: Usa progressive disclosure, sposta dettagli in file reference
- **Specificità**: Tool espliciti, parametri chiari, sequenza definita
- **Read before Edit SEMPRE**: Previeni dati obsoleti
- **Error handling**: Per ogni tool, con fallback paths

Vedi `best-practices.md` per guida completa.

### Fase 4: File Ausiliari (se necessario)

Se la skill è complessa, crea file aggiuntivi:

**phase_N.md** - Per processi dettagliati:
```markdown
# [Nome Fase]: [Descrizione]

## Obiettivo

[Cosa raggiunge questa fase]

---

## Processo Dettagliato

### Step 1: [Nome Step]

**Obiettivo**: [Cosa raggiunge]

**Azioni**:
1. [Azione dettagliata]
2. [Azione dettagliata]

**Output**: [Cosa produce]

[Ripeti per ogni step]

---

## Edge Cases

[Gestione situazioni non standard]

---

## Esempi

[Esempi concreti se utili]
```

**templates/template.md** - Template per file generati:
```markdown
[Contenuto template con placeholder chiari]

[Usa {{ variable }} o [PLACEHOLDER] per indicare dove inserire contenuto dinamico]
```

**defaults.md** - Default e assunzioni:
```markdown
# Default Values

[Elenco puntato di default pragmatici con rationale]

## [Categoria]

- **[Aspetto]**: [Valore default] - [Rationale]
```

### Fase 5: Testing e Iterazione
**Obiettivo**: Validare che la skill funzioni

1. **Valida skill contro checklist** (usa `skill-quality-checklist.md`)
2. **Simula esecuzione** mentalmente:
   - Input realistici producono output corretti?
   - Tool usage è corretto e ordinato?
   - Edge cases sono gestiti?
3. **Proponi miglioramenti** se trovi gaps
4. **Chiedi all'utente di testare** con caso reale
5. **Itera** basandosi su feedback
