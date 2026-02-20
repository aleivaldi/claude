# Branch Policy

## Principio

Ogni modifica ha il suo branch. Nessuna eccezione.

## Regole

### Branch obbligatorio
- MAI committare su `main` o `develop` direttamente
- Ogni task = 1 branch = 1 PR
- Branch creato PRIMA di iniziare a lavorare

### Naming
```
feature/{scope}     — nuova funzionalità
fix/{scope}         — bug fix
refactor/{scope}    — refactoring senza cambio funzionale
docs/{scope}        — solo documentazione
test/{scope}        — solo test
```

Scope = area del codice (auth, devices, mqtt, ui-login, ecc.)

### Working directory
- Ogni agente lavora su una **copia separata** del repo
- Path: `/tmp/dev/{repo}-{branch}/`
- MAI due agenti sulla stessa working directory
- `git clone` + `git checkout -b {branch}` all'inizio

### Lifecycle
1. Clone repo in dir dedicata
2. Crea branch da develop
3. Lavora, commit atomici
4. Push branch
5. PR creata dall'orchestratore (Edi)
6. Review + merge
7. Cleanup dir temporanea

### Parallelo
```
/tmp/dev/myapp-feature-auth/     ← Agente A
/tmp/dev/myapp-feature-devices/  ← Agente B
/tmp/dev/myapp-fix-mqtt/         ← Agente C
```

Agenti diversi, directory diverse, branch diversi. Zero conflitti.

### Conflitti
Se due branch toccano gli stessi file:
1. Il primo che finisce fa merge
2. Il secondo fa rebase su develop aggiornato
3. Se conflitti complessi → escalation a Edi
