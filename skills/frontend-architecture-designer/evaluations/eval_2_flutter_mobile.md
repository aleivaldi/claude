# Evaluation: Flutter Mobile Application

## Scenario

Mobile app con:
- Flutter 3.x
- Riverpod state management
- GoRouter navigation
- Clean architecture

## Input

### tech-stack.md (excerpt)
```markdown
## Mobile
- Framework: Flutter 3.16
- Language: Dart
- State: Riverpod
- Navigation: GoRouter
- HTTP: Dio
- Storage: Hive
```

### sitemap.md (excerpt)
```markdown
## Screens
- Splash
- Onboarding (first launch)
- Login
- Register
- Home (tabs)
  - Dashboard
  - Search
  - Profile
- Item Detail
- Settings
```

## Expected Output

### frontend-architecture.md (key sections)

```markdown
## Directory Structure

lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── home/
│   ├── search/
│   ├── profile/
│   └── settings/
├── shared/
│   ├── widgets/
│   ├── extensions/
│   └── constants/
├── core/
│   ├── network/
│   ├── storage/
│   └── error/
└── l10n/

## Feature Module Pattern

Ogni feature contiene:
- data/ (repository impl, datasources, models)
- domain/ (entities, repository interfaces, usecases)
- presentation/ (providers, screens, widgets)

## State Management

- Riverpod per tutto
- StateNotifierProvider per complex state
- FutureProvider per async data
- Provider per dependencies

## Navigation

- GoRouter con ShellRoute per tabs
- Redirect guards per auth
- Deep linking support

## Testing

flutter test                    # Unit + Widget
flutter test --coverage         # Coverage
flutter drive                   # Integration
```

## Evaluation Criteria

| Criterio | Peso | Pass |
|----------|------|------|
| Clean Architecture layers | 25% | ✓ data/domain/presentation |
| Feature-based organization | 25% | ✓ Features isolate |
| Riverpod patterns corretti | 20% | ✓ StateNotifier + Providers |
| Navigation con guards | 15% | ✓ GoRouter + redirect |
| Testing strategy | 15% | ✓ Unit + Widget + Integration |

## Common Mistakes to Avoid

1. **God classes**: Tutto in un file
2. **Business logic in widgets**: Viola separation
3. **Hardcoded strings**: No l10n
4. **No error handling**: Crashes silenti
5. **Missing offline support**: No local storage
