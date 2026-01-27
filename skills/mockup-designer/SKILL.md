# Skill: Mockup Designer

## Metadati

- **ID**: mockup-designer
- **Versione**: 1.0.0
- **Posizione Workflow**: DOPO sitemap-generator, PRIMA di architecture-designer
- **Input**: `docs/frontend-specs/sitemap.md` + `docs/brief-structured.md`
- **Output**: `docs/mockups/` (proposte HTML/CSS + design system)
- **Checkpoint**: 1 BLOCKING (mockup_approval)

## Sommario

Genera proposte visuali look&feel basate su brief e sitemap. Presenta 3 varianti HTML/CSS dettagliate (1-2 schermate chiave), itera conversazionalmente fino ad approvazione, produce design system per implementazione.

**Principio**: Validare direzione visiva PRIMA di architettura, usando context da brief (no domande generiche).

## Scope

### INCLUDE
- Analisi automatica brief per determinare stile appropriato
- 3 proposte HTML/CSS interattive (font reali, colori esatti)
- 1-2 schermate chiave molto dettagliate
- Iterazione conversazionale fluida
- Design system finale (colors, typography, spacing, components)

### EXCLUDE
- Asset grafici finali (icone custom, immagini)
- Implementazione codice applicativo
- Animazioni complesse
- Tutte le schermate dell'app (solo chiave)

## Workflow: 3 Fasi

```
Fase 1: Analyze Context
  ↓
Fase 2: Generate Proposals + Iterate
  (conversational loop - no checkpoint rigido)
  ↓
>>> CHECKPOINT: MOCKUP_APPROVAL (BLOCKING) <<<
  ↓
Fase 3: Finalization
```

---

## Fase 1: Analyze Context

### Obiettivo
Estrarre da brief e sitemap le informazioni per generare proposte mirate.

### Step

1. **Read inputs**
   ```bash
   Read docs/brief-structured.md
   Read docs/frontend-specs/sitemap.md
   ```

2. **Extract design context**
   ```yaml
   # Estrai automaticamente (NO domande user):
   industry: "hospitality-tech"           # Da brief sezione "Problema"
   target_users: ["restaurant-staff", "diners"]  # Da "Utenti"
   tone: "professional-friendly"          # Da "Obiettivi"
   constraints: ["eink-display", "touch-interface"]  # Da "Vincoli Tecnici"

   critical_pages:  # Da sitemap
     - page: "dashboard"
       priority: "high"
       patterns: ["card-grid", "status-indicators"]
     - page: "login"
       priority: "high"
       patterns: ["form", "single-action"]
   ```

3. **Determine visual approach**
   Based on industry + target:
   - Fintech → Sicurezza, professionale, data-heavy
   - E-commerce → Visual, product-first, conversion-focused
   - B2B Tool → Efficienza, table-centric, dense
   - Consumer → Playful, grande touch targets, colorful
   - Hospitality → Clean, readable, warm palette

### Output Fase 1
Context map in memoria per guidare Fase 2.

---

## Fase 2: Generate Proposals + Iterate

### Obiettivo
Creare 3 proposte HTML/CSS dettagliate, iterare conversazionalmente fino a soddisfazione user.

### Step

1. **Generate 3 variants** (mirate al context da Fase 1)

   Per ogni variante:
   - Scegli 1-2 pagine CHIAVE (es: dashboard + login)
   - Genera HTML/CSS completo con:
     * Font reali (Google Fonts embedded)
     * Colori esatti (hex codes in CSS vars)
     * Spacing preciso (design tokens)
     * Componenti styled (button, card, input, etc.)
     * Dummy data realistici
     * Stati interattivi (hover effects)

2. **Presente proposals conversationally**
   ```markdown
   Basandomi sul brief ([industry], target [users], constraint [X]):

   **Proposta 1: [Nome Descrittivo]** (consigliata)
   - Focus: [key visual principle]
   - Colori: [palette description]
   - Font: [family + rationale]
   - Best for: [use case]

   [Claude Artifact: HTML/CSS interattivo]

   **Proposta 2: [Nome]**
   - Focus: ...
   [Artifact]

   **Proposta 3: [Nome]**
   - Focus: ...
   [Artifact]

   Va bene la direzione? Hai preferenze o qualche sito/app di riferimento?
   ```

3. **Iterazione conversazionale** (NO checkpoint rigido qui)

   User può rispondere:
   - **"Approvo #1"** → Vai a Checkpoint
   - **"Rifalle tutte"** → Loop Step 1 (nuove 3 proposte)
   - **"Lavora su #2 ma cambia [X]"** → Rigenera #2 con modifiche
   - **"Mescola #1 e #3"** → Crea ibrido
   - **"Usa sito X come riferimento"** → Fetch sito, analizza, rigenera

   Loop fluido fino a user satisfaction.

### Template HTML/CSS

Usa template da `templates/proposal-template.html`:
- CSS variables per design tokens
- Component-based structure
- Responsive hints
- Interactive states

Vedi: `reference/artifacts-generation.md` per dettagli.

---

## CHECKPOINT: MOCKUP_APPROVAL (BLOCKING)

Quando user esprime soddisfazione ("approvo", "questa va bene", etc.):

```markdown
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: MOCKUP_APPROVAL <<<
═══════════════════════════════════════════════════════════════

## Stato: BLOCKING

## Design Approvato

**Variante selezionata**: [Nome]

**Schermate dettagliate**:
- [page1]: docs/mockups/approved/page-[name].html
- [page2]: docs/mockups/approved/page-[name].html

**Design Tokens Estratti**:
- Colors: 8 definiti
- Typography: 4 scale
- Spacing: 5 scale
- Components: Button, Card, Input, Form

## Prossimi Step (dopo approvazione)

1. Espando design system completo (Fase 3)
2. Export artifacts per downstream
3. Ready for /architecture-designer

═══════════════════════════════════════════════════════════════
Approvi per procedere? [S]ì / [M]odifica ancora
═══════════════════════════════════════════════════════════════
```

### Response Handling

- **S** → Fase 3 (Finalization)
- **M** → Back to Fase 2 iteration

---

## Fase 3: Finalization

### Obiettivo
Espandere design system completo e preparare artifacts per downstream consumers.

### Step

1. **Extract design system** da HTML/CSS approvato
   ```markdown
   # Design System

   ## Colors

   ### Primary Palette
   - Primary: #3B82F6 (main actions, links)
   - Primary Hover: #2563EB
   - Primary Active: #1D4ED8

   ### Semantic Colors
   - Success: #10B981 (confirmations, success states)
   - Warning: #F59E0B (warnings, pending states)
   - Error: #EF4444 (errors, destructive actions)
   - Info: #3B82F6

   ### Neutrals
   - Background: #FFFFFF
   - Surface: #F9FAFB (cards, elevated elements)
   - Border: #E5E7EB
   - Text Primary: #111827
   - Text Secondary: #6B7280
   - Text Disabled: #9CA3AF

   ## Typography

   ### Font Families
   - Primary: 'Inter', -apple-system, sans-serif
   - Monospace: 'Fira Code', monospace

   ### Scale
   - Heading 1: 32px / 700 / 1.2 line-height
   - Heading 2: 24px / 600 / 1.3
   - Heading 3: 20px / 600 / 1.4
   - Body: 16px / 400 / 1.5
   - Small: 14px / 400 / 1.5
   - Caption: 12px / 400 / 1.4

   ## Spacing

   - xs: 4px
   - sm: 8px
   - md: 16px
   - lg: 24px
   - xl: 32px
   - 2xl: 48px

   ## Border Radius

   - sm: 4px (inputs, small elements)
   - md: 8px (cards, buttons)
   - lg: 12px (modals, major containers)
   - full: 9999px (pills, avatars)

   ## Shadows

   - sm: 0 1px 2px rgba(0,0,0,0.05)
   - md: 0 4px 6px rgba(0,0,0,0.1)
   - lg: 0 10px 15px rgba(0,0,0,0.1)

   ## Components

   ### Button
   - Primary: bg-primary text-white rounded-md px-4 py-2 font-medium
   - Secondary: bg-surface text-primary border border-primary
   - Ghost: text-primary hover:bg-surface
   - Sizes: sm (px-3 py-1.5), md (px-4 py-2), lg (px-6 py-3)

   ### Card
   - Container: bg-surface rounded-lg shadow-sm p-6
   - Header: border-b pb-4 mb-4
   - Interactive: hover:shadow-md transition cursor-pointer

   ### Input
   - Base: border border-gray-300 rounded-md px-3 py-2
   - Focus: border-primary ring-2 ring-primary/20
   - Error: border-error ring-2 ring-error/20

   ### Form
   - Label: text-sm font-medium mb-1 block
   - Helper: text-sm text-secondary mt-1
   - Error text: text-sm text-error mt-1
   ```

2. **Save artifacts**
   ```bash
   docs/mockups/approved/
   ├── page-[name1].html          # HTML/CSS completi approvati
   ├── page-[name2].html
   ├── design-system.md           # Design system completo
   └── screenshots/
       ├── page-[name1].png       # Screenshot per reference rapido
       └── page-[name2].png
   ```

3. **Update progress.yaml**
   ```yaml
   checkpoints_completed:
     - name: mockup_approval
       approved_at: "2026-01-28T..."
       variant_selected: "[nome variante]"
       iterations: 2
       pages_designed: ["dashboard", "login"]
   ```

4. **Generate summary**
   ```markdown
   # Mockup Designer - Completato

   ## Variante Selezionata
   [Nome] - [brief description]

   ## Artifacts
   - 2 schermate HTML/CSS dettagliate
   - Design system completo (8 colors, 6 typography, 5 spacing, 12+ components)
   - Screenshot PNG per reference

   ## Design Tokens Path
   docs/mockups/approved/design-system.md

   ## Next Steps
   - ✅ Ready for /architecture-designer (può referenziare design system)
   - ✅ Ready for /frontend-architecture-designer (può usare component definitions)
   - ✅ Ready for /develop (implementers seguono mockup pixel-perfect)
   ```

### Output Fase 3
Documentazione design completa per guidare tutto il downstream.

---

## Configurazione

### project-config.yaml

```yaml
checkpoints:
  mockup_approval:
    enabled: true
    blocking: true
    description: "Approve visual design and design system"

workflow:
  mockup_designer:
    proposals_count: 3             # Numero varianti da generare
    key_pages_count: 2             # Schermate dettagliate per proposta (1-2)
    max_iterations: 5              # Loop Fase 2 conversazionale
    format: "html-css-artifacts"   # html-css-artifacts | excalidraw | figma-link
```

---

## Integrazione Downstream

### Architecture Designer
```markdown
# Fase 1: Analyze Prerequisites
IF EXISTS docs/mockups/approved/design-system.md:
  Read design-system.md
  Note: "Frontend styling approach defined, use design tokens in tech-stack"
```

### Frontend Architecture Designer
```markdown
# Fase 2: Component Architecture
IF EXISTS docs/mockups/approved/design-system.md:
  Read design-system.md
  Use component definitions as base for component hierarchy
  Reference design tokens for styling strategy
```

### Develop Skill - Frontend Implementer
```markdown
# In frontend-implementer prompt
Context:
  "Reference mockups: docs/mockups/approved/page-*.html"
  "Follow design-system.md for all styling (colors, typography, spacing)"
  "Match mockups pixel-perfect where applicable"
```

---

## HTML/CSS Generation Guidelines

### Structure
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Page Name] - Mockup</title>

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* CSS Variables - Design Tokens */
    :root {
      --color-primary: #3B82F6;
      --color-text: #111827;
      /* ... */
    }

    /* Reset */
    * { margin: 0; padding: 0; box-sizing: border-box; }

    /* Base */
    body {
      font-family: 'Inter', -apple-system, sans-serif;
      color: var(--color-text);
    }

    /* Components */
    .button { /* ... */ }
    .card { /* ... */ }

    /* Layout */
    .dashboard { /* ... */ }
  </style>
</head>
<body>
  <!-- Realistic dummy content -->
  <div class="dashboard">
    <!-- ... -->
  </div>
</body>
</html>
```

### Best Practices
- Use CSS variables for all design tokens
- Include realistic dummy data (no Lorem Ipsum)
- Show interactive states (hover, focus, active) via CSS
- Make responsive (mobile-first approach)
- Keep under 50KB for Claude Artifacts limit

Vedi: `reference/artifacts-generation.md` per esempi completi.

---

## Error Handling

### Brief/Sitemap Non Trovati
```
ERROR: Required files not found.

Missing:
- docs/brief-structured.md (run /generating-structured-brief first)
- docs/frontend-specs/sitemap.md (run /sitemap-generator first)

Mockup Designer requires approved brief and sitemap.
```

### Iterazione Eccessiva
Se loop Fase 2 > 5 iterazioni:
```
INFO: 5 iterations completed.

Current proposals should be refined enough. Recommend:
- Approve current design and iterate during implementation
- OR schedule separate design review session

Proceed with checkpoint? [S]
```

---

## Best Practices

### Proposte Efficaci
- **Mirate al dominio**: Non generic, usa context da brief
- **Dettagliate**: Font/colori/spacing chiari, non placeholder
- **Poche schermate**: 1-2 pagine CHIAVE, non mappare tutta app
- **Realistiche**: Dummy data che sembrano veri, non "User 1, User 2"

### Iterazione Produttiva
- **Prima iterazione**: Tweaks colori, font, spacing minori
- **Seconda iterazione**: Cambio layout significativo
- **Terza+**: Solo se cambio direzione major o nuovi reference
- **Evitare**: Infinite micro-modifiche, meglio iterare in impl

### Design System Scope
- **Minimal viable**: Solo tokens usati nei mockup
- **No over-specification**: Non definire 50 varianti button se ne usi 3
- **Extensible**: Lasciare pattern chiari per aggiungere durante impl

---

## Testing

Quick test workflow:
```bash
# Setup test project
mkdir test-mockup && cd test-mockup
mkdir -p docs/frontend-specs

# Create minimal inputs
cat > docs/brief-structured.md << EOF
# Brief

## Problema
Sistema per ristoranti.

## Utenti
- Restaurant staff
- Diners

## Vincoli
- eInk display
EOF

cat > docs/frontend-specs/sitemap.md << EOF
# Sitemap

- Dashboard
- Login
- Device List
EOF

# Run skill
/mockup-designer

# Verify outputs
ls docs/mockups/approved/
# Expect: design-system.md, page-*.html, screenshots/
```

---

## Reference Files

- `templates/proposal-template.html`: Template base per HTML/CSS proposals
- `reference/artifacts-generation.md`: Guide dettagliata generazione Artifacts interattivi

---

## Versioning

- **v1.0.0**: Initial release
  - 3 proposte mirate a brief
  - HTML/CSS interattivo (Claude Artifacts)
  - Iterazione conversazionale fluida
  - 1 checkpoint bloccante (mockup_approval)
  - Design system completo export
