# Git Flow per Develop Skill

## Overview

Feature branch workflow per blocchi develop. Ogni blocco lavora su un branch isolato, merge su `develop` a blocco completo, merge su `main` a milestone completo.

```
main ─────────────────────────────────────────── M ──►
  \                                             /
   develop ──── B1 ──── B2 ──── B3 ──── B4 ───►
                 \     / \     / \     / \     /
     feature/b1   ───►   ───►   ───►   ───►
     feature/b2         ───►
     feature/b3               ───►
     feature/b4                     ───►
```

## Configurazione

```yaml
# project-config.yaml
git_flow:
  enabled: true                    # Master switch per git flow
  parallel_blocks: auto            # auto | true | false
  develop_branch: develop          # Nome branch develop
  merge_to_main: on_milestone      # on_milestone | manual | never
```

### Opzioni `parallel_blocks`

| Valore | Comportamento |
|--------|---------------|
| `auto` | **RACCOMANDATO**: Auto-detect in fase decomposizione. Se tutti blocchi indipendenti → parallelo (no feature branch). Se ci sono dipendenze → sequenziale (feature branch). |
| `true` | Forza parallelismo sempre. **DISABILITA feature branch** (impossibile branch paralleli stessa working dir). Commit diretti su develop. |
| `false` | Forza sequenziale sempre. Usa feature branch per ogni blocco. |

### Logica Auto-detect (`parallel_blocks: auto`)

Durante **Fase 3 (Block Decomposition)**:

1. **Analizza dependency DAG**:
   - Se TUTTI blocchi indipendenti (DAG piatto, no archi) → `use_parallel = true, use_git_flow = false`
   - Se esistono dipendenze (DAG con archi) → `use_parallel = false, use_git_flow = true`

2. **Notifica utente**:
   ```
   Dependency Analysis:
   - Total blocks: 6
   - Independent blocks: 6
   - Dependencies: 0

   → PARALLEL MODE enabled (no feature branches)
   → Commit diretti su develop con WIP
   ```

3. **Salva decisione** per Fase 4 (Execute Blocks)

## Fase 2: Setup Develop Branch

All'inizio di `/develop`, dopo verify prerequisites:

```bash
# Se develop non esiste, crealo da main
git checkout main
git checkout -b develop 2>/dev/null || git checkout develop

# Assicurati develop sia aggiornato
git merge main --no-edit
```

Se il repo non ha branch `main` (primo sviluppo), usa il branch corrente come base.

## Feature Branch per Blocco

### Creazione (Fase 4b)

```bash
# Da develop, crea feature branch per il blocco
git checkout develop
git checkout -b feature/[block-scope]
```

### Naming Convention

```
feature/[block-scope]

Esempi:
  feature/auth-service
  feature/device-crud
  feature/login-ui
  feature/admin-panel
```

`block-scope` = ID blocco dalla decomposizione (lowercase, kebab-case).

### Commit su Feature Branch

Tutti i commit del blocco vanno sul feature branch (ciclo di vita completo):

```bash
# 1. WIP dopo implementazione (4b)
git commit -m "wip([scope]): implement [block-name]"

# 2. Fix dopo code review (4c - loop max 3x)
git commit -m "fix([scope]): address review [block-name]"

# 3. Fix dopo test failure (4e - loop max 3x)
git commit -m "fix([scope]): fix test failures [block-name]"

# 4. Fix completeness - rimozione stub/mock (4e.5 - loop max 2x)
git commit -m "fix([scope]): complete implementation (remove stub/mock)"
```

**Note**:
- Commit incrementali preservano progresso durante sviluppo
- Tutti collassati in 1 commit finale via squash merge (4f)
- Branch isolato → zero conflitti durante sviluppo
- Rollback facile se blocco fallisce (`git branch -D feature/[block]`)

## Squash Merge su Develop (Fase 4f)

Blocco completo: squash merge feature branch su develop.

```bash
git checkout develop
git merge --squash feature/[block-scope]
git commit -m "feat([scope]): implement [block-name]

- Unit tests: X/Y passed
- Contract tests: X/Y passed
- Review issues fixed: N

Co-Authored-By: Claude <model> <noreply@anthropic.com>"

# Cleanup feature branch
git branch -d feature/[block-scope]
```

## Merge Develop -> Main (Fase 6)

Strategia configurabile in `merge_to_main`:

### `on_milestone` (default)

```bash
# A milestone completo, merge develop su main
git checkout main
git merge develop --no-ff -m "milestone([name]): complete [milestone-name]

Blocks: N completed
Tests: X/Y passed

Co-Authored-By: Claude <model> <noreply@anthropic.com>"
git checkout develop
```

### `manual`

Non merge automatico. Report suggerisce all'utente:
```
Milestone completo su branch develop.
Per merge su main: git checkout main && git merge develop --no-ff
```

### `never`

Tutto resta su develop. Utile per progetti con CI/CD che gestisce merge.

## Error Handling

### Branch gia' esistente

```bash
# Se feature/[scope] esiste gia' (retry di blocco fallito)
git checkout feature/[block-scope]
# Riusa branch esistente, continua da dove era
```

### Merge Conflict su Develop

```bash
git checkout develop
git merge --squash feature/[block-scope]

# Se conflict:
# 1. Tenta rebase feature su develop
git checkout feature/[block-scope]
git rebase develop

# 2. Se rebase riesce: riprova merge
# 3. Se rebase fallisce: STOP, notifica utente
```

### Divergenza Develop/Main

Prima del merge milestone su main:
```bash
git checkout main
git pull --ff-only  # Se fallisce: divergenza, notifica utente
git merge develop --no-ff
```

## Workflow Parallelo (No Feature Branch)

Quando `use_git_flow = false` (auto-detect o `parallel_blocks: true`):

**Blocchi lavorano direttamente su develop senza feature branch.**

```
develop ─── wip(b1) ─── wip(b2) ─── wip(b3) ─── feat(milestone) ──►
```

### Commit per Blocco (Parallelo)

```bash
# Blocco1 completa
git checkout develop
git add [block1-files]
git commit -m "wip(block1): implement auth service

Co-Authored-By: Claude <model> <noreply@anthropic.com>"

# Blocco2 completa (in parallelo)
git checkout develop
git add [block2-files]
git commit -m "wip(block2): implement device CRUD

Co-Authored-By: Claude <model> <noreply@anthropic.com>"

# ... tutti i blocchi ...
```

### Squash Finale (Opzionale)

A milestone completo, puoi pulire la storia:

```bash
# Conta commit WIP da ultimo feat commit
git log --oneline --grep="^wip"

# Squash N commit WIP in 1 feat
git reset --soft HEAD~N
git commit -m "feat(milestone-1): complete auth and devices

Blocks: 6 completed
Tests: 245/245 passed

Co-Authored-By: Claude <model> <noreply@anthropic.com>"
```

### Vincolo Critici (Parallelo)

**LA DECOMPOSIZIONE DEVE GARANTIRE**: Blocchi paralleli NON toccano gli stessi file.

- ✅ auth-service (src/auth/) + device-service (src/devices/) → OK
- ❌ auth-routes (src/routes/auth.ts) + device-routes (src/routes/auth.ts) → CONFLITTO

Se due blocchi toccano stesso file → DEVONO essere sequenziali (aggiungi dipendenza nel DAG).

## Workflow Sequenziale (Feature Branch)

Quando `use_git_flow = true` (auto-detect o `parallel_blocks: false`):

**Ogni blocco ha il suo feature branch.**

```
develop ──────────────────────────────────►
  \         /         /
   feat/b1 ─►  feat/b2 ─►
```

Questo è il workflow documentato nelle sezioni precedenti (Feature Branch per Blocco, Squash Merge, etc.).
