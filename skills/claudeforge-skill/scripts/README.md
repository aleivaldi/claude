# Scripts Reference

## workflow.py
Manages the interactive initialization workflow for new projects.

**Key Functions**:
- `check_claude_md_exists()` - Detect if CLAUDE.md exists
- `generate_exploration_prompt()` - Guide Claude to explore repository
- `analyze_discoveries()` - Analyze exploration results
- `generate_confirmation_prompt()` - Create user confirmation prompt
- `get_workflow_steps()` - Get complete workflow steps

## analyzer.py
Analyzes existing CLAUDE.md files to identify structure, sections, and quality issues.

**Key Functions**:
- `analyze_file()` - Parse and analyze CLAUDE.md structure
- `detect_sections()` - Identify present and missing sections
- `calculate_quality_score()` - Score file quality (0-100)
- `generate_recommendations()` - Provide actionable improvement suggestions

## validator.py
Validates CLAUDE.md files against best practices and Anthropic guidelines.

**Key Functions**:
- `validate_length()` - Check file length (warn if >300 lines)
- `validate_structure()` - Verify required sections present
- `validate_formatting()` - Check markdown formatting quality
- `validate_completeness()` - Ensure critical information included

## generator.py
Generates new CLAUDE.md content or missing sections based on templates.

**Key Functions**:
- `generate_root_file()` - Create main CLAUDE.md orchestrator
- `generate_context_file()` - Create context-specific files (backend, frontend, etc.)
- `generate_section()` - Generate individual sections (tech stack, workflows, etc.)
- `merge_with_existing()` - Add new sections to existing files

## template_selector.py
Selects appropriate template based on project context.

**Key Functions**:
- `select_template()` - Choose template based on project type and team size
- `customize_template()` - Adapt template to tech stack
- `determine_complexity()` - Calculate appropriate detail level
- `recommend_modular_structure()` - Suggest subdirectory organization
