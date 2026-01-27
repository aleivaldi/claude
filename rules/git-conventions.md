# Git Conventions

## Conventional Commits

Formato: `<type>(<scope>): <description>`

### Types

| Type | Descrizione | Esempio |
|------|-------------|---------|
| `feat` | Nuova feature | `feat(auth): add login with OAuth` |
| `fix` | Bug fix | `fix(api): handle null response` |
| `refactor` | Rifattorizzazione senza cambio funzionale | `refactor(utils): simplify date parsing` |
| `docs` | Solo documentazione | `docs(readme): add setup instructions` |
| `test` | Aggiunta/modifica test | `test(auth): add login unit tests` |
| `chore` | Manutenzione, build, dipendenze | `chore(deps): update axios to 1.5` |
| `style` | Formattazione, no logic change | `style(lint): fix eslint warnings` |
| `perf` | Miglioramenti performance | `perf(query): add index for user lookup` |
| `ci` | Modifiche CI/CD | `ci(github): add deploy workflow` |

### Scope

Lo scope è opzionale ma consigliato. Indica l'area del codice modificata:
- `auth`, `api`, `ui`, `db`, `config`, `deps`, etc.
- Per multi-repo: `backend`, `frontend`, `app`, `shared`

### Description

- Inizia con verbo imperativo lowercase: `add`, `fix`, `update`, `remove`
- Max 72 caratteri
- No punto finale
- Descrivi COSA, non COME

### Body (opzionale)

- Separato da riga vuota
- Spiega il PERCHÉ se non ovvio
- Wrap a 72 caratteri

### Footer (opzionale)

- `BREAKING CHANGE:` per cambiamenti incompatibili
- `Closes #123` per riferimenti issue
- `Co-Authored-By:` per pair programming

## Branch Naming

```
<type>/<short-description>

Esempi:
feature/user-authentication
fix/login-redirect-loop
refactor/api-error-handling
```

## Merge Strategy

- **Feature branches**: Squash merge su develop
- **Develop to main**: Merge commit (mantieni storia)
- **Hotfix**: Cherry-pick o merge diretto

## Feature Branch Workflow (/develop)

Quando `/develop` esegue con `git_flow.enabled: true`, ogni blocco usa un feature branch:

```
develop ──────────────────────────────────────►
  \           \         /       /
   feature/b1  feature/b2     /
    (squash     (squash      /
     merge)      merge)     /
```

### Ciclo di vita branch per blocco

1. **Creazione**: `git checkout -b feature/[block-scope]` da develop
2. **Commit WIP**: `wip([scope]): implement [block-name]`
3. **Commit fix**: `fix([scope]): address review [block-name]`
4. **Squash merge**: `git checkout develop && git merge --squash feature/[scope]`
5. **Cleanup**: `git branch -d feature/[scope]`

### Milestone merge

A milestone completo: `develop` -> `main` con merge commit (`--no-ff`).

Dettagli completi in `~/.claude/skills/develop/git-flow.md`.

## Co-Author

Per commit generati con Claude Code:
```
Co-Authored-By: Claude <model> <noreply@anthropic.com>
```
