# Input/Output Formats

## Input Requirements

### For Analysis and Enhancement

Provide existing CLAUDE.md file content or file path:

```json
{
  "mode": "enhance",
  "file_path": "CLAUDE.md",
  "content": "[existing CLAUDE.md content]",
  "project_context": {
    "type": "web_app",
    "tech_stack": ["typescript", "react", "node", "postgresql"],
    "team_size": "small",
    "phase": "mvp"
  }
}
```

### For New File Generation

Provide project context:

```json
{
  "mode": "create",
  "project_context": {
    "type": "api",
    "tech_stack": ["python", "fastapi", "postgresql", "docker"],
    "team_size": "medium",
    "phase": "production",
    "workflows": ["tdd", "cicd", "documentation_first"]
  },
  "modular": true,
  "subdirectories": ["backend", "database", "docs"]
}
```

### Context Parameters

- **type**: Project type (`web_app`, `api`, `fullstack`, `cli`, `library`, `mobile`, `desktop`)
- **tech_stack**: Array of technologies (e.g., `["typescript", "react", "node"]`)
- **team_size**: `solo`, `small` (<10), `medium` (10-50), `large` (50+)
- **phase**: Development phase (`prototype`, `mvp`, `production`, `enterprise`)
- **workflows**: Key workflows (`tdd`, `cicd`, `documentation_first`, `agile`, etc.)

## Output Formats

### Analysis Report

```json
{
  "analysis": {
    "file_size": 450,
    "line_count": 320,
    "sections_found": [
      "Quick Navigation",
      "Core Principles",
      "Tech Stack",
      "Workflow Instructions"
    ],
    "missing_sections": [
      "Testing Requirements",
      "Error Handling Patterns"
    ],
    "issues": [
      {
        "type": "length_warning",
        "severity": "medium",
        "message": "File exceeds recommended 300 lines (320 lines)"
      },
      {
        "type": "missing_section",
        "severity": "low",
        "message": "Consider adding 'Testing Requirements' section"
      }
    ],
    "quality_score": 75,
    "recommendations": [
      "Split into modular files (backend/CLAUDE.md, frontend/CLAUDE.md)",
      "Add testing requirements section",
      "Reduce root file to <150 lines"
    ]
  }
}
```

### Generated Content

Complete CLAUDE.md file content or specific sections to add:

```markdown
# CLAUDE.md

This file provides guidance for Claude Code when working with this project.

## Quick Navigation

- [Backend Guidelines](backend/CLAUDE.md)
- [Frontend Guidelines](frontend/CLAUDE.md)
- [Database Operations](database/CLAUDE.md)
- [CI/CD Workflows](.github/CLAUDE.md)

## Core Principles

1. **Test-Driven Development**: Write tests before implementation
2. **Type Safety First**: Use TypeScript strict mode throughout
3. **Component Composition**: Favor small, reusable components
4. **Error Handling**: Always handle errors with proper logging
5. **Documentation Updates**: Keep docs in sync with code changes

[... additional sections based on template ...]
```
