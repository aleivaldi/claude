# Skill Quality Checklist

Usa questa checklist per validare qualità e completezza di una skill Claude.

---

## 1. Frontmatter (OBBLIGATORIO)

- [ ] **File SKILL.md esiste** nella root directory della skill
- [ ] **Frontmatter presente** con delimitatori `---`
- [ ] **Campo `name` presente**
  - [ ] Max 64 caratteri
  - [ ] SOLO lowercase letters, numbers, hyphens (no spaces, underscores, maiuscole)
  - [ ] Preferibilmente gerund form (verb+ing) o noun phrase
  - [ ] NO XML tags, NO reserved words (anthropic, claude)
- [ ] **Campo `description` presente**
  - [ ] Max 1024 caratteri
  - [ ] Terza persona (NON "I can help you")
  - [ ] Specifica COSA FA la skill
  - [ ] Specifica QUANDO USARLA (contesti trigger, termini chiave)
  - [ ] Include input/output se rilevanti

**Esempi Frontmatter Valido**:
```markdown
---
name: analyzing-api-performance
description: Analyzes Express.js API endpoints for performance bottlenecks, suggests optimizations, generates detailed report with metrics. Use when analyzing API performance or when user mentions slow endpoints. Input: route files. Output: performance-report.md.
---
```

---

## 1.5. Principi Architetturali (CRITICO)

- [ ] **SKILL.md < 500 righe** (Conciseness is Critical)
  - [ ] Se > 500 righe: usa progressive disclosure, sposta dettagli in file reference
- [ ] **Progressive Disclosure Architecture**
  - [ ] File ausiliari sono UN LIVELLO di profondità da SKILL.md (no nested references)
  - [ ] SKILL.md è overview che punta a references
  - [ ] Reference files > 100 righe hanno table of contents
- [ ] **Assume Claude is Smart**
  - [ ] NO spiegazioni di concetti base che Claude già conosce
  - [ ] Focus su informazioni uniche al dominio specifico
- [ ] **Match Specificity to Task Fragility**
  - [ ] High freedom tasks: istruzioni testuali
  - [ ] Medium freedom: pseudocodice/template
  - [ ] Low freedom: script specifici per operazioni fragili
- [ ] **Consistent Terminology**
  - [ ] Stesso termine usato consistentemente (es. sempre "API endpoint", mai alternare con "URL")
- [ ] **Avoid Time-Sensitive Information**
  - [ ] NO date, versioni, info che diventano obsolete
  - [ ] Usa "old patterns" sections per approcci deprecati

---

## 2. Struttura e Organizzazione

- [ ] **Header H1 principale** presente (stesso testo del `name`)
- [ ] **Sezione "Il Tuo Compito"** spiega obiettivo skill
- [ ] **Workflow/Fasi chiaramente identificati** (se multi-step)
- [ ] **Separatori `---`** usati tra sezioni principali
- [ ] **Gerarchia headers corretta** (H1 > H2 > H3, nessun salto)
- [ ] **Liste numerate** per processi sequenziali
- [ ] **Liste puntate** per features/opzioni non sequenziali

---

## 3. Chiarezza Istruzioni

- [ ] **Ogni step è actionable** (verbo imperativo chiaro)
- [ ] **Nessuna istruzione vaga** (no "handle appropriately", "process as needed")
- [ ] **Condizioni esplicite** (if-then-else ben definiti)
- [ ] **Nessuna assunzione implicita** (tutto è documentato)
- [ ] **Sezione "Quando Usarlo/Usarla"** per ogni workflow
- [ ] **Output atteso specificato** per ogni fase

**Test**: Ogni step può essere eseguito da Claude senza ambiguità?

---

## 4. Tool Usage (CRITICO)

- [ ] **Ogni tool specificato esplicitamente** (no "get the content")
- [ ] **Tool usage pattern corretti**:
  - [ ] Read PRIMA di Edit (sempre)
  - [ ] Write per file nuovi, Edit per esistenti
  - [ ] AskUserQuestion per conferme critiche
  - [ ] Bash SOLO per git/npm/sistema (NO cat/grep/echo)
- [ ] **Sequencing corretto**:
  - [ ] Operazioni indipendenti eseguite in parallelo
  - [ ] Operazioni dipendenti eseguite sequenzialmente
- [ ] **Sezione "Uso Tool"** presente con best practices
- [ ] **Parametri tool specificati** quando rilevante

**Anti-Pattern da Evitare**:
- ❌ "Modify the file" (quale tool?)
- ❌ "Get file content" (Read? Bash cat?)
- ❌ "Update configuration" (come? dove?)

---

## 5. Error Handling

- [ ] **Sezione "Gestione Errori" presente**
- [ ] **Error handling per ogni tool usato**:
  - [ ] Cosa fare se Read fallisce
  - [ ] Cosa fare se Write fallisce
  - [ ] Cosa fare se Edit fallisce (old_string not found)
  - [ ] Cosa fare se Bash comando fallisce
  - [ ] Cosa fare se AskUserQuestion non riceve risposta
- [ ] **Fallback paths specificati** (non lasciare utente bloccato)
- [ ] **Recovery actions actionable** (passi specifici, non vaghi)

---

## 6. Edge Cases

- [ ] **Situazioni non standard anticipate**:
  - [ ] File mancanti
  - [ ] File esistenti quando atteso nuovo
  - [ ] Permessi insufficienti
  - [ ] Input malformato/invalido
  - [ ] Directory non esistenti
- [ ] **Gestione per ogni edge case** è chiara e specifica
- [ ] **Path alternativi documentati**

---

## 7. Esempi e Anti-Pattern

- [ ] **Esempi concreti presenti** per casi complessi
- [ ] **Formato `<example>` usato** quando appropriato
- [ ] **Anti-pattern documentati** (cosa NON fare)
- [ ] **Esempi mostrano tool usage corretto**

---

## 8. Scope e Boundaries

- [ ] **Sezione scope** definisce cosa FA la skill
- [ ] **Sezione scope** definisce cosa NON FA
- [ ] **Riferimenti ad altre skills** quando appropriato
- [ ] **Scope non infinito** (skill non fa troppo)
- [ ] **Responsabilità chiare** e delimitate

---

## 9. Validazione e Feedback

- [ ] **AskUserQuestion usato** per decisioni critiche
- [ ] **Conferme richieste** prima azioni irreversibili
- [ ] **User può intervenire** nei punti chiave
- [ ] **Feedback loop presente** quando appropriato

---

## 10. File Ausiliari (se skill complessa)

Per skills medie/complesse:

- [ ] **Templates separati** in `templates/` directory
- [ ] **Fasi dettagliate** in file `phase_N.md`
- [ ] **Defaults documentati** in `defaults.md`
- [ ] **Reference docs** in `docs/` directory
- [ ] **Esempi complessi** in `examples/` directory
- [ ] **SKILL.md referenzia** file ausiliari correttamente

---

## 11. Output e Deliverable

- [ ] **Sezione "Output Finale" presente**
- [ ] **Deliverable specificato chiaramente**:
  - [ ] Nome file(s) prodotto
  - [ ] Formato e struttura
  - [ ] Contenuto atteso
  - [ ] Dimensione approssimativa se rilevante
- [ ] **Criteri di completamento chiari** (quando skill è finita?)

---

## 12. Linguaggio e Stile

- [ ] **Tono imperativo e diretto** ("Leggi", "Crea", "Valida")
- [ ] **Lingua consistente** (italiano O inglese, non misto)
- [ ] **Sezione "Regola Linguistica"** se multi-lingua
- [ ] **Emoji usati appropriatamente** (✅ ❌ ⚠️ solo per categorizzazione)
- [ ] **Terminologia tecnica corretta** e consistente

---

## 13. Testing e Validazione

- [ ] **Build Evaluations First** (BEST PRACTICE)
  - [ ] Minimo 3 evaluations create PRIMA di documentazione estesa
  - [ ] Baseline stabilita senza skill
  - [ ] Iterazione basata su failure reali
- [ ] **Test Across Models**
  - [ ] Testata con Haiku (veloce, economico)
  - [ ] Testata con Sonnet (bilanciato)
  - [ ] Testata con Opus (potente) - se applicabile
- [ ] **Skill testata** con caso reale
- [ ] **Mental simulation eseguita**:
  - [ ] Input realistici → output corretti
  - [ ] Tool sequence funziona
  - [ ] Edge cases gestiti
  - [ ] Nessun dead-end
- [ ] **Test case documentato** (opzionale ma raccomandato)

---

## 14. Advanced Patterns (se applicabili)

- [ ] **Utility Scripts** (se la skill include script)
  - [ ] Script hanno error handling esplicito (non fail silently)
  - [ ] Package dependencies documentati
  - [ ] Messaggi errore chiari ("Field X not found. Available: Y, Z")
  - [ ] Path con forward slashes (cross-platform)
  - [ ] Configuration parameters giustificati (NO magic numbers)
  - [ ] Default to execution (chiaro che vanno eseguiti, non solo letti)
- [ ] **Verifiable Intermediate Outputs** (per batch operations)
  - [ ] Analyze → create plan → validate → execute → verify
  - [ ] User può review prima di applicare cambiamenti
- [ ] **Template Pattern** (se output richiede formato specifico)
  - [ ] Template fornito e marcato come strict se necessario
- [ ] **Examples Pattern** (per task stilistici)
  - [ ] Coppie input/output mostrano stile e dettaglio desiderati
- [ ] **MCP Tool References** (se usa MCP)
  - [ ] Formato fully qualified: "ServerName:tool_name"

---

## 15. Maintainability

- [ ] **Struttura modulare** per skills complesse
- [ ] **File non troppo lunghi** (SKILL.md < 500, reference files < 1000)
- [ ] **Sezioni ben organizzate** e facili da trovare
- [ ] **Changelog presente** se skill è stata modificata (opzionale)
- [ ] **Facile identificare** cosa modificare per aggiornamenti futuri

---

## Score e Valutazione

### Critico (Must-Have) ⚠️

Questi DEVONO essere tutti ✅ per skill funzionante:

1. **Frontmatter completo e conforme** (name lowercase+hyphens max 64, description terza persona max 1024)
2. **SKILL.md < 500 righe** (se più lungo, usa progressive disclosure)
3. **Tool usage esplicito** (quale tool, parametri, sequenza)
4. **Read before Edit pattern** (SEMPRE)
5. **Error handling base presente** (per ogni tool usato)
6. **Scope definito** (cosa FA e NON FA)
7. **Progressive disclosure** (references un livello deep da SKILL.md)
8. **Assume Claude is Smart** (no spiegazioni concetti base)

**Se anche solo UNO è ❌ → skill NON è production-ready**

### Importante (Should-Have) 📋

Questi dovrebbero essere ✅ per skill di qualità:

1. **Esempi concreti** (con tag `<example>` per casi complessi)
2. **Edge cases gestiti** (file mancanti, permessi, input invalido)
3. **Validazione utente** per azioni critiche (AskUserQuestion)
4. **Output specificato** chiaramente (nome file, formato, struttura)
5. **Anti-pattern documentati** (cosa NON fare)
6. **Terminologia consistente** (stesso termine per stesso concetto)
7. **Build evaluations first** (3+ evaluations prima di docs estese)

**Percentuale target: 80%+ ✅**

### Nice-to-Have (Could-Have) ⭐

Questi migliorano qualità ma non essenziali:

1. **Changelog/versioning** (per tracking evoluzioni)
2. **Test cases documentati** (con expected input/output)
3. **Examples directory** (con esempi complessi separati)
4. **Reference documentation estesa** (API docs, datasets)
5. **Multiple language support** (con Regola Linguistica)
6. **Test across models** documentato (Haiku, Sonnet, Opus)
7. **Utility scripts** per operazioni ripetitive
8. **Visual analysis** (per PDFs/immagini quando layout importa)

**Percentuale target: 50%+ ✅**

---

## Azioni Post-Checklist

### Se Score Critico < 100%
→ **NON procedere con deployment**
→ **Fixa issue critici immediatamente**
→ **Re-valida dopo fix**

### Se Score Importante < 80%
→ **Migliora prima di considerare "completa"**
→ **Documenta gap noti**
→ **Pianifica iterazione miglioramenti**

### Se Score Nice-to-Have < 50%
→ **OK per uso interno/testing**
→ **Considera miglioramenti per production**
→ **Itera basandosi su feedback utenti**

---

## Quick Validation

Domande rapide per validation veloce:

1. ❓ **SKILL.md è sotto 500 righe?** (conciseness critical)
2. ❓ **Frontmatter è conforme?** (name lowercase+hyphens, description terza persona con "quando usarla")
3. ❓ **Posso eseguire questa skill senza fare domande?** (tutto è chiaro?)
4. ❓ **So esattamente quali tool usare in ogni step?** (espliciti, non impliciti)
5. ❓ **So cosa fare se qualcosa fallisce?** (error handling presente)
6. ❓ **So cosa aspettarmi come output?** (deliverable specificato)
7. ❓ **Ci sono situazioni in cui sarei bloccato?** (fallback paths presenti)
8. ❓ **References sono un livello deep?** (no nested references)
9. ❓ **Terminologia è consistente?** (stesso termine per stesso concetto)
10. ❓ **Assume Claude is smart?** (no spiegazioni concetti base)

Se risposta è "NO" a qualsiasi domanda → skill ha problemi di qualità.

---

## Esempio Validation Report

```markdown
# Validation Report: [Skill Name]

**Data**: 2024-01-15
**Validatore**: [Nome]

## Score Summary

- Critico: 5/5 ✅ (100%)
- Importante: 4/5 ⚠️ (80%)
- Nice-to-Have: 2/5 📋 (40%)

## Issue Critici

Nessuno ✅

## Issue Importanti

- ❌ Manca gestione edge case per file già esistente
- ⚠️ AskUserQuestion non usato per conferma sovrascrittura

## Raccomandazioni

1. **Alta Priorità**: Aggiungere AskUserQuestion prima di sovrascrivere file
2. **Media Priorità**: Documentare edge case file esistente
3. **Bassa Priorità**: Considerare aggiungere examples/ directory

## Verdict

✅ **Approvata per uso con minor fixes** (fixare issue importanti raccomandato)
```
