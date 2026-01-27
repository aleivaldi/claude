# Advanced Features

## Modular Architecture Support

Automatically generates context-specific files:

```
project-root/
├── CLAUDE.md                 # Root orchestrator (100-150 lines)
├── backend/
│   └── CLAUDE.md            # Backend-specific (150-200 lines)
├── frontend/
│   └── CLAUDE.md            # Frontend-specific (150-200 lines)
├── database/
│   └── CLAUDE.md            # Database operations (100-150 lines)
└── .github/
    └── CLAUDE.md            # CI/CD workflows (100-150 lines)
```

## Tech Stack Detection

Automatically detects technologies from:
- `package.json` (Node.js/TypeScript)
- `requirements.txt` or `pyproject.toml` (Python)
- `go.mod` (Go)
- `Cargo.toml` (Rust)
- `pom.xml` or `build.gradle` (Java)

## Team Size Adaptation

Adjusts detail level:
- **Solo**: Minimal guidelines, focus on efficiency
- **Small (<10)**: Core guidelines, workflow basics
- **Medium (10-50)**: Detailed guidelines, team coordination
- **Large (50+)**: Comprehensive guidelines, process enforcement
