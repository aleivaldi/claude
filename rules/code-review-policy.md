# Code Review Policy

## Integrazione Git

La code review avviene **esclusivamente tramite Git**:
- Pull Request (GitHub) / Merge Request (GitLab)
- Review prima di merge su branch protetti

## Branch Protection

```yaml
# Configurazione branch protection (main/develop)
required_reviews: 1
dismiss_stale_reviews: true
require_code_owner_reviews: false  # opzionale
required_status_checks:
  - lint
  - test
  - build
```

## Workflow PR

```
feature-branch → Pull Request → Review → Approve → Merge
                      │
                      ├─► CI passa (lint, test, build)
                      ├─► Almeno 1 approval
                      └─► No unresolved comments
```

## Quando Serve Review

| Situazione | Review Richiesta |
|------------|------------------|
| PR verso main/develop | Sì |
| Codice auth/pagamenti/sicurezza | Sì (+ security check) |
| Hotfix urgente | Post-merge review accettabile |
| Typo/docs minori | Opzionale |

## Review Automatica Claude

Claude Code può assistere la review **dentro il processo Git**:

```bash
# Review PR corrente
gh pr diff | claude "Review this PR for security and quality issues"

# Review con /code-review skill
/code-review PR#123
```

Output: commenti sulla PR, non report separati.

## Checklist Reviewer

### Bloccanti (MUST)
- [ ] Nessuna vulnerabilità sicurezza
- [ ] Test coprono nuovo codice
- [ ] Build passa
- [ ] No secrets/credentials

### Importanti (SHOULD)
- [ ] Error handling appropriato
- [ ] Nomi chiari
- [ ] No code smell evidenti

### Opzionali (COULD)
- [ ] Performance ottimale
- [ ] Documentazione inline

## Severity per Commenti

| Prefisso | Significato | Azione |
|----------|-------------|--------|
| `[BLOCK]` | Issue bloccante | Deve essere risolto |
| `[SUGGEST]` | Suggerimento | Consigliato ma non bloccante |
| `[NIT]` | Nitpick/style | Opzionale, ignorabile |
| `[QUESTION]` | Richiesta chiarimento | Risposta richiesta |

## Esempio Commento

```
[BLOCK] Input non validato - possibile SQL injection.
Usare query parametrizzata o ORM.

[SUGGEST] Considera di estrarre questa logica in un service.

[NIT] Preferire `const` a `let` qui.
```

## Tempo di Review

- PR piccole (< 200 righe): stesso giorno
- PR medie (200-500 righe): 1-2 giorni
- PR grandi (> 500 righe): considerare split
