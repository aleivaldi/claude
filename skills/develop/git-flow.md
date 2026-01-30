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
  enabled: true                    # false disabilita tutto il git flow (backward-compatible)
  develop_branch: develop          # nome branch develop
  merge_to_main: on_milestone     # on_milestone | manual | never
```

Se `git_flow.enabled: false`, il workflow usa il comportamento precedente (commit diretti, squash con reset --soft).

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

## Isolamento Blocchi Paralleli

Blocchi paralleli lavorano su branch separati -> no conflitti tra loro.
I conflitti possono emergere solo al merge su develop (sequenziale per natura).

```
develop ─────────────────────────────────►
  \           \         /       /
   feature/b1  feature/b2     /
    (merge)     (merge dopo b1)
```

Il merge su develop e' serializzato: ogni blocco mergia quando completa.
Se due blocchi completano simultaneamente, uno attende l'altro.
