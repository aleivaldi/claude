# Evaluation 2: Mobile App Sitemap

## Input

**brief-structured.md**:
```markdown
## Applicazioni
- Mobile app (iOS/Android)

## Funzionalità
- Onboarding
- Tab navigation (Home, Search, Profile)
- Product catalog
```

## Expected Behavior

### Fase 2: Generazione Draft

Genera struttura mobile-specific:

```markdown
## Navigation Structure

### Tab Bar (Bottom)
1. Home Tab
2. Search Tab
3. Profile Tab

### Screens

#### Onboarding Flow
- Welcome Screen
- Feature Tour (3 screens)
- Permissions Request
- Complete

#### Home Tab
- Home Screen
- Product Detail
- Product List (category)

#### Search Tab
- Search Screen
- Search Results
- Filters

#### Profile Tab
- Profile Screen
- Settings
- Edit Profile
```

## Expected Output

**sitemap.md**:
```markdown
# Mobile App Sitemap

## Navigation Type
Bottom Tab Bar (3 tabs)

## Screens by Tab

### Home Tab (5 screens)
| Screen | Route | Description |
|--------|-------|-------------|
| Home | /home | Main feed |
| Product Detail | /product/:id | Dettaglio prodotto |
| Category List | /category/:id | Lista per categoria |

### Search Tab (3 screens)
...

### Profile Tab (3 screens)
...

## Flows

### Onboarding
Welcome → Tour → Permissions → Home

### Product View
Home → Product Detail → Add to Cart
```

## Success Criteria
- ✅ Tab navigation documentata
- ✅ Screen count per tab
- ✅ Flows mobili (onboarding)
- ✅ Route pattern mobile (/home, /profile, non /pages/)

## Pass/Fail
**PASS**: Nav mobile, tab structure, flows specifici mobile
**FAIL**: Struttura web in mobile app, no onboarding, no tab navigation
