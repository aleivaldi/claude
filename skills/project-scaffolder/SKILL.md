---
name: project-scaffolder
description: Inizializza repository con struttura, configurazione, CLAUDE.md, e setup base. Supporta multi-repo e mono-repo.
---

# Project Scaffolder Skill

## Obiettivo

Inizializzare i repository del progetto con:
- Struttura directory
- File configurazione (package.json, tsconfig, etc.)
- CLAUDE.md per ogni repo
- Git hooks
- CI/CD base

## Input

Richiede:
- `project-config.yaml` (lista repository)
- `docs/architecture/tech-stack.md` (tecnologie scelte)

## Fasi

### Fase 1: Analisi Configurazione

1. Leggi `project-config.yaml` per lista repository
2. Per ogni repo:
   - Tipo (flutter, nodejs, react, etc.)
   - Path
   - Dipendenze tra repo

### Fase 2: Scaffold per Tipo

**Consulta `templates/README-templates.md` per struttura completa template disponibili.**

Per ogni tipo progetto (Node.js Backend, React Frontend, Flutter App):
1. Crea struttura directory da template
2. Copia file configurazione appropriati (package.json, tsconfig, pubspec.yaml)
3. Genera CLAUDE.md specifico per repo
4. Aggiungi CI/CD workflows da `templates/shared/`
5. Setup git hooks

Template disponibili: **nodejs-backend**, **react-frontend**, **flutter-app**
```

**CLAUDE.md:**
```markdown
# Project Backend

## Overview
Backend API per [Nome Progetto]. Node.js + Express + Prisma.

## Quick Start
```bash
npm install
cp .env.example .env
npm run migrate:dev
npm run dev
```

## Structure
- `src/routes/` - API endpoints
- `src/services/` - Business logic
- `src/repositories/` - Data access
- `src/middleware/` - Express middleware
- `prisma/` - Database schema

## Commands
- `npm run dev` - Development server
- `npm test` - Run tests
- `npm run build` - Build for production

## API Specs
See `../docs/api-specs/api-signature.md`

## Environment
Copy `.env.example` to `.env` and configure.
```

#### Flutter App

```
project-app/
├── .github/
│   └── workflows/
│       └── ci.yml
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   └── utils/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   ├── presentation/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── routes/
│   │   └── app_router.dart
│   └── main.dart
├── test/
│   ├── unit/
│   └── widget/
├── pubspec.yaml
├── analysis_options.yaml
├── CLAUDE.md
└── README.md
```

**CLAUDE.md:**
```markdown
# Project App

## Overview
Mobile app per [Nome Progetto]. Flutter + Riverpod.

## Quick Start
```bash
flutter pub get
flutter run
```

## Structure
- `lib/core/` - Constants, theme, utilities
- `lib/data/` - Models, repositories, API services
- `lib/presentation/` - Screens, widgets, providers
- `lib/routes/` - Navigation

## Commands
- `flutter run` - Run debug
- `flutter test` - Run tests
- `flutter build apk` - Build Android
- `flutter build ios` - Build iOS

## API Connection
Configure API URL via `--dart-define=API_URL=http://...`

## Design Specs
See `../docs/frontend-specs/`
```

### Fase 3: Root Project CLAUDE.md

```markdown
# [Nome Progetto]

## Overview
[Descrizione dal brief]

## Repositories

| Repo | Type | Path | Description |
|------|------|------|-------------|
| project-app | Flutter | ./project-app | Mobile application |
| project-backend | Node.js | ./project-backend | Backend API |

## Documentation

- `docs/brief-structured.md` - Project brief
- `docs/frontend-specs/` - UI specifications
- `docs/api-specs/` - API specifications
- `docs/architecture/` - Architecture docs

## Workflow

Questo progetto usa il framework di automazione Claude Code.
Vedi `project-config.yaml` per configurazione workflow e checkpoint.

### Fasi
1. Discovery → `docs/brief-structured.md`
2. Specifications → `docs/frontend-specs/`, `docs/api-specs/`
3. Architecture → `docs/architecture/`
4. Implementation → Codice in repository
5. Testing → Test automatizzati
6. Deploy → CI/CD

## Quick Start

```bash
# Backend
cd project-backend
npm install
npm run dev

# App (altro terminale)
cd project-app
flutter pub get
flutter run
```

## Conventions

- Git: Conventional Commits
- Code: Vedi `~/.claude/rules/code-standards.md`
- Review: Auto-review abilitata
```

### Fase 4: CI/CD Base

**.github/workflows/ci.yml:**
```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test
```

### Fase 5: Git Initialization

```bash
# Per ogni repository
git init
git add .
git commit -m "chore: initial project scaffold"
```

## Output

- Repository strutturati e inizializzati
- CLAUDE.md per ogni repo
- CI/CD configurato
- Git inizializzato

## Principi

- **Convention over configuration**: Defaults sensati
- **Documented**: Ogni repo con README e CLAUDE.md
- **CI/CD ready**: Pipeline da subito
- **Consistent**: Stessa struttura per stesso tipo
