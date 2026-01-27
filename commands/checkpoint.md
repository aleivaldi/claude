# /checkpoint - State Management

## Overview

Gestisce checkpoint di stato del progetto. Salva, verifica, e ripristina stati verificati.

## Syntax

```bash
/checkpoint create [name]   # Crea checkpoint con nome
/checkpoint verify [name]   # Confronta stato corrente con checkpoint
/checkpoint list            # Lista tutti i checkpoint
/checkpoint clear           # Rimuove vecchi checkpoint (mantiene ultimi 5)
/checkpoint restore [name]  # Ripristina a checkpoint (git stash)
```

## Commands

### Create

Crea un nuovo checkpoint verificato:

1. Esegue `/verify` completo
2. Se passa, crea git tag o stash
3. Salva metadata in `.checkpoints/`

```bash
/checkpoint create pre-refactor
```

Output:
```
╔══════════════════════════════════════════════════════════════╗
║                   CHECKPOINT CREATED                          ║
╠══════════════════════════════════════════════════════════════╣
║ Name: pre-refactor                                            ║
║ Created: 2025-01-25 10:30:00                                  ║
║ Commit: abc123f                                               ║
║ Status: ✅ Verified (all checks passed)                       ║
║                                                               ║
║ Files: 42 tracked, 3 modified                                 ║
╚══════════════════════════════════════════════════════════════╝
```

### Verify

Confronta stato corrente con checkpoint:

```bash
/checkpoint verify pre-refactor
```

Output:
```
╔══════════════════════════════════════════════════════════════╗
║                 CHECKPOINT COMPARISON                         ║
╠══════════════════════════════════════════════════════════════╣
║ Comparing: current vs pre-refactor                            ║
╠══════════════════════════════════════════════════════════════╣
║ Files changed: 8                                              ║
║ Lines added: 245                                              ║
║ Lines removed: 112                                            ║
║                                                               ║
║ New files:                                                    ║
║   + src/services/new-feature.ts                               ║
║   + src/services/new-feature.test.ts                          ║
║                                                               ║
║ Modified files:                                               ║
║   ~ src/routes/index.ts (+15, -3)                             ║
║   ~ src/config/index.ts (+5, -2)                              ║
║                                                               ║
║ Tests: ✅ Still passing                                       ║
║ Build: ✅ Still compiling                                     ║
╚══════════════════════════════════════════════════════════════╝
```

### List

Mostra tutti i checkpoint:

```bash
/checkpoint list
```

Output:
```
╔══════════════════════════════════════════════════════════════╗
║                   CHECKPOINTS                                 ║
╠══════════════════════════════════════════════════════════════╣
║ # │ Name              │ Date       │ Commit  │ Status        ║
╠══════════════════════════════════════════════════════════════╣
║ 1 │ pre-refactor      │ 2025-01-25 │ abc123f │ ✅ Verified   ║
║ 2 │ feature-complete  │ 2025-01-24 │ def456g │ ✅ Verified   ║
║ 3 │ mvp-done          │ 2025-01-20 │ ghi789h │ ✅ Verified   ║
╚══════════════════════════════════════════════════════════════╝
```

### Clear

Rimuove checkpoint vecchi:

```bash
/checkpoint clear
```

Mantiene gli ultimi 5 checkpoint, rimuove i più vecchi.

### Restore

Ripristina a un checkpoint (usa git):

```bash
/checkpoint restore pre-refactor
```

⚠️ **Warning**: Stash o commit changes prima di restore.

## Workflow

### Prima di Refactoring

```bash
/checkpoint create pre-refactor
# ... refactoring ...
/checkpoint verify pre-refactor  # Verifica non ho rotto nulla
```

### Durante Feature Development

```bash
/checkpoint create feature-start
# ... implement feature ...
/checkpoint create feature-wip
# ... more work ...
/checkpoint create feature-done
```

### Prima di Merge

```bash
/checkpoint verify feature-start  # Confronta tutto il lavoro
/verify pre-pr                     # Verifiche complete
```

## Storage

I checkpoint sono salvati in:

```
.checkpoints/
├── manifest.json          # Lista checkpoint
├── pre-refactor/
│   ├── metadata.json      # Info checkpoint
│   ├── verify-results.json # Risultati verify
│   └── git-ref.txt        # Reference git
└── feature-complete/
    └── ...
```

## Key Principles

1. **Verify before create**: Checkpoint solo se stato è valido
2. **Descriptive names**: Nomi che descrivono lo stato
3. **Regular checkpoints**: Crea spesso durante lavoro complesso
4. **Clean old ones**: Mantieni solo checkpoint utili

## Integration

Combina con:
- `/verify` - Eseguito automaticamente su create
- `/commit` - Dopo checkpoint confermato
- `/tdd` - Checkpoint tra cicli TDD
