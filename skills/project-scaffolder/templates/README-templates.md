# Project Scaffold Templates

Questa directory contiene template completi per scaffold di progetti per diverse tecnologie.

## Struttura

```
templates/
├── nodejs-backend/
│   ├── structure.md         # Directory tree
│   ├── package.json         # Dependencies
│   ├── tsconfig.json        # TypeScript config
│   ├── .gitignore           # Git ignores
│   └── CLAUDE.md            # Claude guidelines
├── react-frontend/
│   ├── structure.md
│   ├── package.json
│   ├── vite.config.ts
│   └── CLAUDE.md
├── flutter-app/
│   ├── structure.md
│   ├── pubspec.yaml
│   └── CLAUDE.md
└── shared/
    ├── .github-workflows-ci.yml
    └── pre-commit-hooks.sh
```

## Utilizzo

1. Leggi `structure.md` per directory tree del tipo progetto
2. Copia template file di configurazione appropriati
3. Adatta CLAUDE.md con specifiche del progetto
4. Aggiungi CI/CD workflows da `shared/`
5. Setup git hooks con script da `shared/`

## Template Disponibili

- **nodejs-backend**: Express + TypeScript + Prisma
- **react-frontend**: Vite + React + TypeScript
- **flutter-app**: Flutter con architettura Riverpod
- **shared**: CI/CD workflows e git hooks riutilizzabili
