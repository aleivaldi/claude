# Checkpoint Protocol

## Definizione

Un **checkpoint** è un punto di controllo nel workflow dove si richiede validazione umana prima di procedere.

> **Principio guida**: Checkpoint = Decisione critica che influenza molto lavoro successivo

## Tipi di Checkpoint

### Blocking (STOP)

L'esecuzione si ferma e attende approvazione esplicita.

```
>>> CHECKPOINT: [nome] <<<
Status: BLOCKING

[Descrizione di cosa è stato completato]

Approvi per procedere?
- [S] Sì, procedi
- [N] No, fermati
- [M] Modifica (specifica cosa)
```

### Review (NOTIFICA)

Notifica il risultato ma continua automaticamente.

```
>>> CHECKPOINT: [nome] <<<
Status: REVIEW (continuo automaticamente)

[Descrizione di cosa è stato completato]

Review consigliata per: [aspetti specifici]
```

## Checkpoint Standard

| Fase | Checkpoint | Tipo | Descrizione |
|------|------------|------|-------------|
| Discovery | `brief` | BLOCKING | Brief strutturato completo |
| Requirements | `user_stories` | BLOCKING | User stories definite |
| Frontend | `sitemap` | BLOCKING | Struttura pagine approvata |
| Frontend | `frontend_specs_overview` | REVIEW | Overview schermate |
| API | `api_signature` | BLOCKING | Contratto API definito |
| API | `api_specs_detail` | REVIEW | OpenAPI completo |
| Architecture | `architecture_overview` | BLOCKING | Design architettura |
| Architecture | `tech_stack_choice` | BLOCKING | Linguaggi/framework scelti |
| Architecture | `data_model` | BLOCKING | Schema dati approvato |
| Architecture | `user_flows` | BLOCKING | Flussi utente critici |
| Impl. Architecture | `frontend_architecture` | BLOCKING | Architettura implementativa frontend |
| Impl. Architecture | `backend_architecture` | BLOCKING | Architettura implementativa backend |
| Environment | `environment_config` | BLOCKING | Setup ambienti |
| Implementation | `frontend_style` | REVIEW | Design system/stile |
| Implementation | `milestone_sync` | REVIEW | Sync point tra track |
| Implementation | `feature_complete` | BLOCKING | Tutte feature implementate |
| Testing | `test_plan` | REVIEW | Piano test definito |
| Testing | `e2e_complete` | BLOCKING | Test E2E passano |
| Review | `code_review` | REVIEW | Review codice |
| Deploy | `release` | BLOCKING | Pronto per produzione |

## Configurazione

### project-config.yaml

```yaml
checkpoints:
  brief:
    enabled: true
    blocking: true

  user_stories:
    enabled: false  # Skip per questo progetto

  sitemap:
    enabled: true
    blocking: true

  frontend_architecture:
    enabled: true
    blocking: true

  backend_architecture:
    enabled: true
    blocking: true

  api_signature:
    enabled: true
    blocking: true

  feature_complete:
    enabled: true
    blocking: true
```

## Comportamento Orchestratore

### Quando si ferma

1. **Checkpoint BLOCKING** configurato attivo
2. **Max retry superato** (3 tentativi di fix falliti)
3. **Errore critico** (file non trovato, dipendenza mancante)
4. **Richiesta esplicita** (checkpoint manuale)

### Quando continua

1. **Checkpoint REVIEW** → Notifica e procede
2. **Checkpoint disabled** → Salta completamente
3. **Approvazione ricevuta** → Procede al prossimo step

## Output Checkpoint

### Formato Standard

```markdown
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: [NOME_CHECKPOINT] <<<
═══════════════════════════════════════════════════════════════

## Stato: [BLOCKING|REVIEW]

## Completato
- Item 1 fatto
- Item 2 fatto
- Item 3 fatto

## Artefatti Generati
- `path/to/file1.md`
- `path/to/file2.yaml`

## Prossimi Passi (dopo approvazione)
1. Passo successivo 1
2. Passo successivo 2

## Metriche (se applicabili)
- Test passati: X/Y
- Coverage: Z%
- Issues risolti: N

═══════════════════════════════════════════════════════════════
Approvi? [S]ì / [N]o / [M]odifica
═══════════════════════════════════════════════════════════════
```

## Gestione Risposte

### Approvazione

```
User: S
→ Procede al prossimo step
→ Log: "Checkpoint [nome] approvato da [user] alle [timestamp]"
```

### Rifiuto

```
User: N
→ Stop completo
→ Chiedi: "Cosa vuoi modificare?"
→ Attendi nuove istruzioni
```

### Modifica

```
User: M - [descrizione modifica]
→ Applica modifiche richieste
→ Re-presenta checkpoint
→ Loop fino ad approvazione
```

## Best Practices

### Checkpoint Efficaci

- **Chiari**: Stato evidente di cosa è completato
- **Actionable**: Chiaro cosa succede dopo approvazione
- **Informativi**: Metriche e artefatti visibili
- **Reversibili**: Possibilità di tornare indietro

### Anti-patterns

- Troppi checkpoint → friction eccessiva
- Checkpoint vaghi → decisioni difficili
- Checkpoint tardivi → lavoro sprecato se rifiutato
- No checkpoint su decisioni critiche → rischio disallineamento

## Tracking

### progress.yaml

```yaml
checkpoints_completed:
  - name: brief
    approved_at: "2025-01-22T10:00:00"
    approved_by: user

  - name: sitemap
    approved_at: "2025-01-22T11:30:00"
    approved_by: user
    modifications:
      - "Aggiunta pagina Settings"

current_checkpoint: api_signature
status: awaiting_approval
```
