# Artifacts Generation Guide

Guida per generare HTML/CSS interattivi come Claude Artifacts per mockup proposals.

## Obiettivi Artifacts

1. **Immediate rendering**: Visualizzazione istantanea senza setup
2. **Interactive**: Hover states, focus, basic interactions
3. **Design token based**: CSS variables per tutti i valori
4. **Realistic**: Dummy data credibili, non placeholder
5. **Under 50KB**: Limite Claude Artifacts

## Template Structure

### Head Section

```html
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{Page}} Mockup</title>

  <!-- Google Fonts - sempre includere -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <style>
    /* CSS Variables first */
    /* Components next */
    /* Layout last */
  </style>
</head>
```

### CSS Variables (Design Tokens)

```css
:root {
  /* Primary palette */
  --color-primary: #3B82F6;
  --color-primary-hover: #2563EB;
  --color-primary-active: #1D4ED8;

  /* Semantics */
  --color-success: #10B981;
  --color-warning: #F59E0B;
  --color-error: #EF4444;

  /* Neutrals */
  --color-bg: #FFFFFF;
  --color-surface: #F9FAFB;
  --color-border: #E5E7EB;
  --color-text-primary: #111827;
  --color-text-secondary: #6B7280;

  /* Typography */
  --font-family: 'Inter', sans-serif;
  --font-size-h1: 32px;
  --font-size-h2: 24px;
  --font-size-body: 16px;

  /* Spacing */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 32px;

  /* Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
}
```

## Component Patterns

### Button

```css
.button {
  display: inline-flex;
  align-items: center;
  gap: var(--space-sm);
  padding: var(--space-sm) var(--space-md);
  border: none;
  border-radius: var(--radius-md);
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.button-primary {
  background: var(--color-primary);
  color: white;
}

.button-primary:hover {
  background: var(--color-primary-hover);
  transform: translateY(-1px);
  box-shadow: var(--shadow-md);
}
```

```html
<button class="button button-primary">
  Save Changes
</button>
```

### Card

```css
.card {
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  padding: var(--space-lg);
  box-shadow: var(--shadow-sm);
  transition: box-shadow 0.2s;
}

.card:hover {
  box-shadow: var(--shadow-md);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: var(--space-md);
  border-bottom: 1px solid var(--color-border);
  margin-bottom: var(--space-md);
}
```

```html
<div class="card">
  <div class="card-header">
    <h3>Card Title</h3>
    <button class="button button-secondary">Action</button>
  </div>
  <p>Card content...</p>
</div>
```

### Input/Form

```css
.form-group {
  margin-bottom: var(--space-lg);
}

.label {
  display: block;
  margin-bottom: var(--space-xs);
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text-primary);
}

.input {
  width: 100%;
  padding: var(--space-sm) var(--space-md);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  font-size: var(--font-size-body);
  transition: all 0.2s;
}

.input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}
```

```html
<div class="form-group">
  <label class="label" for="email">Email</label>
  <input type="email" id="email" class="input" placeholder="you@example.com">
  <p class="helper-text">We'll never share your email.</p>
</div>
```

### Status Badge

```css
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 12px;
  border-radius: var(--radius-sm);
  font-size: 12px;
  font-weight: 500;
}

.badge-success {
  background: #D1FAE5;
  color: #065F46;
}

.badge-warning {
  background: #FEF3C7;
  color: #92400E;
}

.badge-error {
  background: #FEE2E2;
  color: #991B1B;
}
```

## Page Layout Patterns

### Dashboard Grid

```css
.dashboard {
  max-width: 1200px;
  margin: 0 auto;
  padding: var(--space-xl);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: var(--space-lg);
  margin-bottom: var(--space-xl);
}

.stat-card {
  background: var(--color-surface);
  padding: var(--space-lg);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: var(--color-text-primary);
}

.stat-label {
  font-size: 14px;
  color: var(--color-text-secondary);
  margin-top: var(--space-xs);
}
```

### Login Centered

```css
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  background: white;
  padding: var(--space-xl);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-lg);
  width: 100%;
  max-width: 400px;
}

.login-header {
  text-align: center;
  margin-bottom: var(--space-xl);
}

.login-title {
  font-size: var(--font-size-h1);
  margin-bottom: var(--space-sm);
}
```

### Table List

```css
.table-container {
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}

.table {
  width: 100%;
  border-collapse: collapse;
}

.table th {
  background: var(--color-bg);
  padding: var(--space-md);
  text-align: left;
  font-weight: 600;
  color: var(--color-text-primary);
  border-bottom: 2px solid var(--color-border);
}

.table td {
  padding: var(--space-md);
  border-bottom: 1px solid var(--color-border);
}

.table tr:hover {
  background: var(--color-bg);
}
```

## Realistic Dummy Data

### ❌ BAD (Generic)
```html
<h3>User 1</h3>
<p>Lorem ipsum dolor sit amet</p>
```

### ✅ GOOD (Domain-specific)
```html
<!-- For restaurant app -->
<h3>Table 5 - Main Hall</h3>
<p>Device online • Menu displayed • Last update: 2 min ago</p>

<!-- For fintech -->
<h3>Transaction #TXN-2024-00123</h3>
<p>€1,234.56 • Completed • Visa ****1234</p>

<!-- For SaaS -->
<h3>Project Alpha - Q1 2024</h3>
<p>12 tasks • 3 overdue • Team: 8 members</p>
```

## Interactive States

### Hover Effects
```css
.card-interactive {
  cursor: pointer;
  transition: all 0.2s;
}

.card-interactive:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}
```

### Focus States
```css
.input:focus,
.button:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
}
```

### Active States
```css
.button:active {
  transform: translateY(0);
}

.tab.active {
  border-bottom: 2px solid var(--color-primary);
  color: var(--color-primary);
}
```

## Responsive Approach

```css
/* Mobile-first */
.grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--space-md);
}

/* Tablet and up */
@media (min-width: 768px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(3, 1fr);
    gap: var(--space-lg);
  }
}
```

## Complete Example: Dashboard

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Mockup</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --color-primary: #3B82F6;
      --color-success: #10B981;
      --color-warning: #F59E0B;
      --color-bg: #F9FAFB;
      --color-surface: #FFFFFF;
      --color-border: #E5E7EB;
      --color-text: #111827;
      --color-text-secondary: #6B7280;
      --space-md: 16px;
      --space-lg: 24px;
      --space-xl: 32px;
      --radius-lg: 12px;
      --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      font-family: 'Inter', sans-serif;
      background: var(--color-bg);
      color: var(--color-text);
    }

    .dashboard {
      max-width: 1200px;
      margin: 0 auto;
      padding: var(--space-xl);
    }

    .header {
      margin-bottom: var(--space-xl);
    }

    .title {
      font-size: 32px;
      font-weight: 700;
      margin-bottom: 8px;
    }

    .subtitle {
      color: var(--color-text-secondary);
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: var(--space-lg);
      margin-bottom: var(--space-xl);
    }

    .stat-card {
      background: var(--color-surface);
      padding: var(--space-lg);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
    }

    .stat-value {
      font-size: 32px;
      font-weight: 700;
      margin-bottom: 8px;
    }

    .stat-label {
      color: var(--color-text-secondary);
      font-size: 14px;
    }

    .badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: 500;
      margin-top: 8px;
    }

    .badge-success {
      background: #D1FAE5;
      color: #065F46;
    }
  </style>
</head>
<body>
  <div class="dashboard">
    <div class="header">
      <h1 class="title">Dashboard</h1>
      <p class="subtitle">Welcome back, Restaurant Manager</p>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-value">24</div>
        <div class="stat-label">Active Devices</div>
        <span class="badge badge-success">All Online</span>
      </div>

      <div class="stat-card">
        <div class="stat-value">156</div>
        <div class="stat-label">QR Scans Today</div>
        <span class="badge badge-success">+12% vs yesterday</span>
      </div>

      <div class="stat-card">
        <div class="stat-value">8</div>
        <div class="stat-label">Active Menus</div>
      </div>
    </div>
  </div>
</body>
</html>
```

## Size Optimization

- Minify CSS in production artifacts
- Use shorthand CSS properties
- Inline small SVG icons (< 1KB)
- Avoid external images (use data URIs if needed)
- Target < 50KB total

## Accessibility Basics

```css
/* Focus visible for keyboard navigation */
*:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* Color contrast WCAG AA minimum */
/* Text on background: 4.5:1 ratio */
/* Large text (18px+): 3:1 ratio */
```

```html
<!-- Semantic HTML -->
<button>Action</button>  <!-- Not <div onclick> -->
<label for="input-id">Label</label>

<!-- Alt text for images -->
<img src="..." alt="Descriptive text">
```
