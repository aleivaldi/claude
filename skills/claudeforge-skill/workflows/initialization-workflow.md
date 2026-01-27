# Initialization Workflow (New Projects)

When CLAUDE.md doesn't exist in your project, this skill provides an intelligent initialization workflow.

## Workflow Steps

**Step 1: Detection**
- Skill checks if CLAUDE.md exists in project root
- If not found, initialization workflow begins

**Step 2: Repository Exploration**
- Uses Claude Code's built-in `explore` command
- Analyzes project structure, files, and directories
- Examines configuration files (package.json, requirements.txt, go.mod, etc.)
- Reviews existing documentation

**Step 3: Intelligent Analysis**
- **Project Type Detection**: web_app, api, fullstack, cli, library, mobile, desktop
- **Tech Stack Detection**: TypeScript, Python, React, FastAPI, PostgreSQL, Docker, etc.
- **Team Size Estimation**: Based on project complexity (solo, small, medium, large)
- **Development Phase**: prototype, mvp, production, enterprise
- **Workflow Detection**: TDD, CI/CD, documentation-first, agile
- **Structure Recommendation**: Single file vs. modular architecture

**Step 4: User Confirmation** ✋
- Displays all discoveries in clear format
- Shows recommended CLAUDE.md structure
- Asks user to confirm or adjust settings
- **User must explicitly approve** before proceeding

**Step 5: File Creation**
- Generates customized CLAUDE.md based on confirmed settings
- Creates modular files if recommended (backend/, frontend/, etc.)
- Applies tech-specific best practices

**Step 6: Enhancement**
- Validates generated content
- Adds quality improvements
- Ensures completeness

**Step 7: Summary**
- Shows what files were created
- Provides next steps
- Ready for immediate use

## Interactive Example

```
User: "I need a CLAUDE.md for this project"

Claude: "I'll explore your repository first to understand the project.
        [Explores using built-in commands]

        Based on my exploration, here's what I discovered:

        Project Type: Full-Stack Application
        Tech Stack: TypeScript, React, Node.js, PostgreSQL, Docker
        Team Size: Small (2-9 developers)
        Development Phase: MVP
        Workflows: TDD, CI/CD

        Recommended Structure: Modular architecture
        - Root CLAUDE.md (navigation hub)
        - backend/CLAUDE.md (API guidelines)
        - frontend/CLAUDE.md (React guidelines)

        Would you like me to create these files?"

User: "Yes, please proceed"

Claude: "Creating customized CLAUDE.md files...
        ✅ Created CLAUDE.md (100 lines)
        ✅ Created backend/CLAUDE.md (150 lines)
        ✅ Created frontend/CLAUDE.md (175 lines)

        Your project is ready for AI-assisted development!"
```
