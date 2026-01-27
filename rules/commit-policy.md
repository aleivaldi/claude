# Commit Policy

## Quando Fare Commit

### SI - Commit consigliato

- **Unità logica completa**: Feature, fix, o refactor funzionante
- **Prima di cambiare contesto**: Stai per lavorare su altro
- **Dopo test che passano**: Codice verificato
- **Milestone raggiunta**: Checkpoint di progresso
- **Fine sessione**: Salva il lavoro fatto

### NO - Non fare commit

- **Codice che non compila**: Mai commit broken
- **Test che falliscono**: A meno che non sia branch WIP esplicito
- **Cambiamenti parziali**: Feature a metà che rompe funzionalità
- **Debug code**: console.log, print statements temporanei
- **Secrets/credentials**: Mai committare dati sensibili

## Granularità

### Commit Atomici

Un commit = un cambiamento logico. Preferisci commit piccoli e frequenti.

```
BUONO:
- feat(auth): add password validation
- feat(auth): add email validation
- feat(auth): integrate validation in form

EVITARE:
- feat(auth): add all form validations and fix bugs and update styles
```

### Raggruppamento Accettabile

- Feature + suoi test → stesso commit OK
- Refactor preparatorio + feature → commit separati
- Fix multipli correlati → stesso commit se piccoli

## Commit Message Quality

### Descrizione Chiara

```
BUONO:
fix(api): handle 404 response in user fetch

EVITARE:
fix bug
update code
wip
```

### Quando Serve il Body

- Cambiamento non ovvio dal diff
- Decisione architetturale
- Workaround temporaneo (spiega perché)
- Breaking change

## Pre-commit Checks

Prima di ogni commit, verifica:

1. **Lint passa**: Nessun errore di stile
2. **Test passano**: Almeno unit test
3. **Build OK**: Il progetto compila
4. **No secrets**: Controlla .env, credentials
5. **Conventional format**: Segue convenzioni

## WIP Commits

Se devi salvare lavoro incompleto:

```
wip(scope): [descrizione stato]

Esempi:
wip(auth): login form layout done, validation pending
wip(api): endpoints defined, implementation 50%
```

Regole WIP:
- Solo su feature branch personali
- Squash prima di merge
- Non su develop/main MAI
