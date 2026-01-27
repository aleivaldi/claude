---
name: claude-md-enhancer
description: Analyzes, generates, and enhances CLAUDE.md files for any project type using best practices, modular architecture support, and tech stack customization. Use when setting up new projects, improving existing CLAUDE.md files, or establishing AI-assisted development standards.
---

# CLAUDE.md File Enhancer

This skill provides comprehensive CLAUDE.md file generation and enhancement for Claude Code projects. It analyzes existing files, validates against best practices, and generates customized guidelines tailored to your project type, tech stack, and team size.

## Capabilities

- **🆕 Interactive Initialization**: Intelligent workflow that explores repository, detects project type/tech stack, creates customized CLAUDE.md
- **✨ 100% Native Format Compliance**: Follows official Claude Code format (matching `/update-claude-md`)
- **Analyze Existing Files**: Scan and evaluate CLAUDE.md for structure, completeness, quality
- **Validate Best Practices**: Check against Anthropic guidelines
- **Generate New Files**: Create complete CLAUDE.md from scratch
- **Enhance Existing Files**: Add missing sections, improve structure
- **Modular Architecture**: Support context-specific files (backend/, frontend/, docs/)
- **Tech Stack Customization**: Tailor to specific technologies
- **Team Size Adaptation**: Adjust complexity (solo, small, medium, large)
- **Template Selection**: Choose based on project complexity and phase

## Materiali di Riferimento

**Formati**:
- `templates/io-formats.md` - Input/output format examples, context parameters, analysis report structure

**Workflow**:
- `workflows/initialization-workflow.md` - Workflow dettagliato 7-step per nuovi progetti, esempi interattivi

**Script**:
- `scripts/README.md` - workflow.py, analyzer.py, validator.py, generator.py, template_selector.py

**Template e Metriche**:
- `reference/templates-and-metrics.md` - Template categories (minimal/core/detailed), quality score calculation

**Advanced**:
- `reference/advanced-features.md` - Modular architecture, tech stack detection, team size adaptation

## How to Use

### Caso 1: Initialize New Project (Interactive)

```
I need a CLAUDE.md for this project
```

**Workflow**: Explora repo → Analizza tech stack → Chiede conferma → Genera file customizzati. Vedi `workflows/initialization-workflow.md` per dettagli.

### Caso 2: Analyze Existing CLAUDE.md

```
Analyze my current CLAUDE.md and suggest improvements
```

### Caso 3: Enhance Existing File

```
Enhance my CLAUDE.md by adding missing sections
```

### Caso 4: Generate Modular Architecture

```
Create modular CLAUDE.md for full-stack project (Python/FastAPI backend, React frontend)
```

## Best Practices

### Critical Validation Rule ⚠️

**"Always validate your output against official native examples before declaring complete."**

Before finalizing any CLAUDE.md generation:
1. Compare output against `/update-claude-md` slash command format
2. Check official Claude Code documentation for required sections
3. Verify all native format sections are present (Overview, Project Structure, File Structure, Setup & Installation, Architecture, etc.)
4. Cross-check against reference examples in `examples/` folder

### For New Projects
1. Start with minimal template (50-100 lines) and grow as needed
2. Use modular architecture for projects with >3 major components
3. Include tech stack reference immediately
4. Add workflow instructions before team grows beyond 5 people

### For Enhancement
1. Analyze before modifying - understand current structure first
2. Preserve custom content - only enhance, don't replace
3. Validate after changes - ensure improvements don't break existing patterns
4. Test with Claude Code - verify guidelines work as intended

### General Guidelines
1. **Keep root file concise** - Max 150 lines, use as navigation hub
2. **Use context-specific files** - backend/CLAUDE.md, frontend/CLAUDE.md, etc.
3. **Avoid duplication** - Each guideline should appear once
4. **Link to external docs** - Don't copy official documentation
5. **Update regularly** - Review guidelines quarterly or when stack changes

## Limitations

### Technical Constraints
- Requires valid project context for accurate template selection
- Tech stack detection is keyword-based, may need manual refinement
- Modular generation assumes standard directory structure

### Scope Boundaries
- Focuses on CLAUDE.md structure, not project-specific business logic
- Best practice recommendations are general
- Validation is guideline-based, not enforcement

### When NOT to Use
- Non-Claude AI tools (Claude Code specific)
- Projects not using Claude Code
- Highly specialized domains (legal, medical compliance)

## References

- **Anthropic Claude Code Docs**: https://docs.claude.com/en/docs/claude-code
- **CLAUDE.md Best Practices**: Based on community patterns and Anthropic guidance
- **Example CLAUDE.md Files**: See `examples/` folder for 6 reference implementations covering different project types and team sizes

## Version

**Version**: 1.0.0
**Last Updated**: November 2025
**Compatible**: Claude Code 2.0+, Claude Apps, Claude API

Remember: The goal is to make Claude more efficient and context-aware, not to create bureaucracy. Start simple, iterate based on real usage, and automate quality checks where possible.
