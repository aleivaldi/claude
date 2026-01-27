---
name: project-setup
description: Genera automaticamente project-config.yaml per nuovi progetti. Analizza brief esistente, fa domande interattive, e crea configurazione personalizzata.
---

# Project Setup Skill

## Obiettivo

Generare `project-config.yaml` per un nuovo progetto, configurando workflow, checkpoint, e ambienti in base alle caratteristiche del progetto.

## Fasi

### Fase 1: Analisi Contesto

1. **Cerca brief esistente**
   - Cerca `brief-structured.md` o `brief.md` nella directory corrente e in `docs/`
   - Se trovato, analizza per estrarre informazioni sul progetto

2. **Identifica struttura esistente**
   - Cerca repository esistenti (cartelle con `package.json`, `pubspec.yaml`, etc.)
   - Identifica tipo progetto dai file presenti

### Fase 2: Raccolta Informazioni

Se non disponibili dal brief, chiedi all'utente:

**Domanda 1: Tipo Progetto**
```
Che tipo di progetto è?
- full-stack (frontend + backend)
- frontend-only (solo frontend/app)
- backend-only (solo API/servizi)
- library (libreria/package)
```

**Domanda 2: Complessità**
```
Qual è la complessità del progetto?
- small (1-2 settimane, pochi endpoint/schermi)
- medium (1-2 mesi, progetto standard)
- large (3+ mesi, molti componenti)
```

**Domanda 3: Fase**
```
In che fase si trova il progetto?
- poc (proof of concept, prototipo)
- mvp (minimum viable product)
- production (produzione)
```

**Domanda 4: Repository**
```
Quanti e quali repository ci sono?
[Chiedi nome, tipo (flutter/react/nodejs/python), path]
```

### Fase 3: Configurazione Checkpoint

In base alla complessità, suggerisci checkpoint:

**Small Project:**
```yaml
checkpoints:
  brief: { enabled: true, blocking: true }
  sitemap: { enabled: true, blocking: true }
  api_signature: { enabled: true, blocking: true }
  feature_complete: { enabled: true, blocking: true }
  release: { enabled: true, blocking: true }
  # Altri disabilitati
```

**Medium Project:**
```yaml
checkpoints:
  # Tutti enabled, alcuni blocking
  brief: { enabled: true, blocking: true }
  sitemap: { enabled: true, blocking: true }
  api_signature: { enabled: true, blocking: true }
  architecture_overview: { enabled: true, blocking: true }
  tech_stack_choice: { enabled: true, blocking: true }
  feature_complete: { enabled: true, blocking: true }
  e2e_complete: { enabled: true, blocking: true }
  release: { enabled: true, blocking: true }
  # Review checkpoint (non blocking)
  frontend_specs_overview: { enabled: true, blocking: false }
  test_plan: { enabled: true, blocking: false }
```

**Large Project:**
```yaml
checkpoints:
  # Tutti abilitati
  # Più checkpoint blocking
```

### Fase 4: Generazione File

1. **Crea project-config.yaml**
   - Usa template da `~/.claude/templates/project-config.yaml`
   - Popola con informazioni raccolte
   - Adatta checkpoint in base a complessità

2. **Mostra anteprima**
   - Mostra configurazione generata
   - Evidenzia checkpoint attivi

### Fase 5: Customizzazione

```
Vuoi personalizzare i checkpoint?
- Si: [Guida attraverso ogni checkpoint]
- No: [Usa defaults]
```

### Fase 6: Conferma e Salvataggio

1. Mostra configurazione finale
2. Chiedi conferma
3. Salva `project-config.yaml`
4. Suggerisci prossimi step

## Output

File: `project-config.yaml` nella root del progetto

## Esempio Interazione

```
Tu: /project-setup

Claude: Ho trovato brief-structured.md nel progetto. Lo analizzo...

Dal brief rilevo:
- Progetto: [Nome Progetto]
- Tipo: [App mobile/Web/Backend/Full-stack]
- Complessità stimata: [Small/Medium/Large]

Confermo queste informazioni?
[S] Sì, procedi
[M] Modifica qualcosa
[N] Riparti da zero

Tu: S

Claude: Configuro i checkpoint per un progetto MEDIUM.
Checkpoint BLOCKING proposti:
- brief ✓ (già completato)
- sitemap
- api_signature
- architecture_overview
- feature_complete
- release

Checkpoint REVIEW (non bloccanti):
- frontend_specs_overview
- test_plan

Vuoi modificare questa configurazione? [S/N]

Tu: N

Claude: Genero project-config.yaml...

[Mostra file generato]

File salvato! Prossimi step suggeriti:
1. Esegui /sitemap-generator per creare la sitemap
2. Poi /api-signature-generator per definire le API
```

## Note

- Se esiste già project-config.yaml, chiedi se sovrascrivere o modificare
- Salva sempre backup se sovrascrive
- Usa linguaggio dell'utente (italiano se brief in italiano)
