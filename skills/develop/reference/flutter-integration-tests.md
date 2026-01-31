# Flutter Integration Tests - Reference

Dettagli completi per integration tests Flutter nel workflow `/develop`.

---

## Overview

**Scopo**: Validare integrazione completa Flutter app + backend reale, verificare layout su device/simulator, catturare screenshot per review manuale.

**Quando**: Configurabile (per blocco, a fine milestone, manual)

**Output**: Test results + screenshots + layout validation + user approval

---

## Setup Automatico

### Dependencies

```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

**Auto-install**: Skill esegue `flutter pub add integration_test --dev --sdk=flutter` se mancante.

### Directory Structure

```
project/
├── integration_test/
│   ├── [screen_name]_test.dart        # Test per screen
│   ├── helpers.dart                   # Helper per test (opzionale)
│   ├── screenshots/                   # Screenshot generati
│   │   ├── login_screen.png
│   │   └── device_list_screen.png
│   ├── README.md                      # Istruzioni esecuzione
│   └── E2E-TEST-REPORT.md            # Report risultati
```

---

## Test Generation

### Template Base

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:[app_name]/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('[ScreenName] E2E test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Test flow:
    // 1. Verify initial screen
    expect(find.byKey(const Key('InitialScreen')), findsOneWidget);

    // 2. Perform actions (login, navigation, etc.)
    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.tap(find.text('Submit'));

    // 3. Wait for async operations
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // 4. Verify result
    expect(find.text('Expected Widget'), findsOneWidget);
  });
}
```

### Best Practices

**Timing**:
```dart
// DON'T: pumpAndSettle without timeout (can hang)
await tester.pumpAndSettle();

// DO: Always specify timeout
await tester.pumpAndSettle(const Duration(seconds: 5));

// DO: Add explicit delay for API calls
await tester.pump(const Duration(seconds: 1));
await tester.pumpAndSettle();
```

**Widget Finding**:
```dart
// FRAGILE: find.text('QRPay') fails se TextSpan composito
expect(find.text('QRPay'), findsOneWidget);

// ROBUST: find widget unico della schermata
expect(find.text('Dashboard'), findsOneWidget);
expect(find.text('Tutti'), findsOneWidget);  // Filter tab unico
```

**Key Usage**:
```dart
// ONLY se timing non è issue
expect(find.byKey(const Key('ScreenName')), findsOneWidget);

// BETTER: verifica widget effettivi presenti
expect(find.text('Unique Widget Text'), findsOneWidget);
```

---

## Execution

### Network Configuration

**iOS Simulator**:
- `localhost` NON funziona (simulator ha proprio network stack)
- Usa IP host: `http://192.168.1.x:3000`
- Ottieni IP: `ipconfig getifaddr en0`

**Android Emulator**:
- `localhost` NON funziona
- Usa `10.0.2.2` (alias per host): `http://10.0.2.2:3000`

**Device Reale**:
- Device e host sulla stessa WiFi
- Usa IP host: `http://192.168.1.x:3000`

### Command

```bash
# iOS Simulator
HOST_IP=$(ipconfig getifaddr en0)
flutter test integration_test/[test_name].dart \
  --dart-define=API_URL=http://$HOST_IP:3000/api/v1 \
  --dart-define=WS_URL=ws://$HOST_IP:3000

# Android Emulator
flutter test integration_test/[test_name].dart \
  --dart-define=API_URL=http://10.0.2.2:3000/api/v1 \
  --dart-define=WS_URL=ws://10.0.2.2:3000
```

### Output Parsing

Cattura output e analizza:

```bash
flutter test integration_test/device_list_test.dart \
  --dart-define=API_URL=http://$HOST_IP:3000/api/v1 \
  2>&1 | tee /tmp/test-output.txt

# Check test result
if grep -q "All tests passed" /tmp/test-output.txt; then
  echo "✅ Tests PASSED"
else
  echo "❌ Tests FAILED"
fi

# Check overflow errors
if grep -q "overflowed by" /tmp/test-output.txt; then
  echo "⚠️ Layout overflow detected"
  grep -i "overflowed by" /tmp/test-output.txt
fi
```

---

## Layout Overflow Validation

### Detection

Cerca pattern output:

```
A RenderFlex overflowed by 53 pixels on the bottom.

The relevant error-causing widget was:
  Column
  Column:file:///path/to/widget.dart:108:20

constraints: BoxConstraints(w=124.5, 0.0<=h<=43.8)
```

**Info utili**:
- File e line number del widget
- Overflow amount (pixels)
- Constraints (width, height disponibile)
- Widget type (Column, Row, Stack)

### Common Fixes

**1. childAspectRatio troppo basso (GridView)**

```dart
// BEFORE (overflow 53px)
GridView.count(
  childAspectRatio: 2.8,  // Card troppo bassa
  children: [...],
)

// AFTER (no overflow)
GridView.count(
  childAspectRatio: 1.8,  // Card più alta
  children: [...],
)
```

**2. fontSize troppo grande**

```dart
// BEFORE (overflow)
Text(
  value,
  style: TextStyle(fontSize: 32),
)

// AFTER (no overflow)
Text(
  value,
  style: TextStyle(fontSize: 28),
)
```

**3. Missing Expanded/Flexible**

```dart
// BEFORE (overflow)
Column(
  children: [
    Text('Long text...'),
    Text('More text...'),
  ],
)

// AFTER (no overflow)
Column(
  children: [
    Flexible(child: Text('Long text...')),
    Text('More text...'),
  ],
)
```

### Auto-Fix Strategy

1. **Parse overflow error** → Identifica widget + constraints
2. **Determine fix** basato su widget type:
   - GridView → Increase childAspectRatio
   - Text → Reduce fontSize o add overflow: TextOverflow.ellipsis
   - Column/Row → Add Expanded/Flexible
3. **Apply fix** → Edit file
4. **Re-run test** → Verify overflow risolto
5. **Max 2 attempts** → Se ancora overflow, escalate a user

---

## Screenshot Capture

### Durante Test

**Opzione 1: Manuale nel test**

```dart
testWidgets('Screen test', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Cattura screenshot
  await expectLater(
    find.byType(MyApp),
    matchesGoldenFile('screenshots/my_screen.png'),
  );
});
```

**Opzione 2: Tool esterno (consigliato)**

Usa device/simulator screenshot durante test:

```bash
# iOS Simulator
xcrun simctl io booted screenshot integration_test/screenshots/screen.png

# Android Emulator
adb exec-out screencap -p > integration_test/screenshots/screen.png
```

**Opzione 3: Flutter screenshot plugin**

```dart
import 'package:screenshot/screenshot.dart';

final screenshotController = ScreenshotController();

// Wrap widget
Screenshot(
  controller: screenshotController,
  child: MyScreen(),
)

// Capture
await screenshotController.captureAndSave('integration_test/screenshots');
```

### Screenshot Checklist

**User deve verificare**:
- [ ] Layout matches mockup/design
- [ ] Text leggibile (no cut, no overflow)
- [ ] Images/icons visibili
- [ ] Spacing corretto
- [ ] Colors match branding
- [ ] Responsive (test su diversi device)
- [ ] Loading states visible
- [ ] Error states visible

---

## User Approval Flow

### Presentation Format

```
═══════════════════════════════════════════════════════════════
>>> FLUTTER INTEGRATION TEST RESULTS <<<
═══════════════════════════════════════════════════════════════

✅ Tests: 2/2 passed
✅ Overflow: 0 errors
⏱️ Duration: 49s

Screenshots (REVIEW REQUIRED):
1. LoginScreen
   Path: integration_test/screenshots/login_screen.png
   Size: 1024x768
   Device: iPad Pro 12.9"

2. DeviceListScreen
   Path: integration_test/screenshots/device_list_screen.png
   Size: 1024x768
   Device: iPad Pro 12.9"

Backend Integration:
✅ POST /api/v1/auth/login (200ms)
✅ GET /api/v1/devices (150ms)

Manual Checklist:
- [ ] Layout correct
- [ ] No visual bugs
- [ ] Responsive
- [ ] Loading/error states

═══════════════════════════════════════════════════════════════
APPROVAL REQUIRED
[A] Approve | [R] Reject with feedback | [I] Ignore review
═══════════════════════════════════════════════════════════════
```

### Response Handling

**[A] Approve**:
```yaml
# Log in progress.yaml
flutter_integration:
  user_approval: "approved"
  approved_at: "2026-01-31T12:00:00Z"
  screenshots_reviewed: true
```

**[R] Reject**:
```
User feedback: "StatsBar overflow still visible, text cut in DeviceCard"

Actions:
1. Parse feedback
2. Identify affected widgets
3. Invoke fixer
4. Re-run tests
5. Re-present results
```

**[I] Ignore**:
```yaml
# Log warning
flutter_integration:
  user_approval: "ignored"
  warning: "User skipped manual screenshot review - visual bugs may exist"
```

---

## Thread Parallel Handling

### Scenario: Backend + Frontend Parallel

```
Milestone 1: User Management

Thread 1 (Backend):          Thread 2 (Frontend):
- auth-service                - login-screen
- user-crud                   - user-list-screen
- permissions                 - user-detail-screen
    ↓                             ↓
Backend Complete          Frontend Complete
    ↓                             ↓
    └──────────┬──────────────────┘
               ↓
         SYNC POINT
               ↓
    Flutter Integration Tests
    (login + user CRUD E2E)
```

**Regola**: Esegui integration tests al **SYNC POINT** quando entrambi thread completi.

**Perché**: Integration tests richiedono backend funzionante + frontend funzionante insieme.

### Scenario: Multiple Frontend Screens Parallel

```
Thread A: LoginScreen ────────► OK ──┐
Thread B: DashboardScreen ────► OK ──┼──► MERGE
Thread C: SettingsScreen ─────► OK ──┘
                                       ↓
                           Integration Tests
                           (login → dashboard → settings)
```

**Regola**: Esegui integration tests quando TUTTE screen da testare sono complete.

---

## Configuration Examples

### Minimal (default)

```yaml
develop:
  validations:
    flutter_integration_tests:
      enabled: true
      timing: "per_milestone"
      screenshot_always: true
      approval_required: true
```

### Per-Block (early feedback)

```yaml
develop:
  validations:
    flutter_integration_tests:
      enabled: true
      timing: "per_block"
      auto_generate_tests: true
      screenshot_always: true
      approval_required: true
      overflow_validation: true
```

### Manual Only (max control)

```yaml
develop:
  validations:
    flutter_integration_tests:
      enabled: false  # Skill NON esegue auto
      # User esegue manualmente quando vuole
```

---

## Troubleshooting

### Test Timeout

**Symptom**: Test si blocca, no output

**Cause**:
- Backend non raggiungibile (wrong IP)
- API infinito loop
- pumpAndSettle senza timeout

**Fix**:
```dart
// Add timeout
await tester.pumpAndSettle(const Duration(seconds: 10));

// Check backend
curl http://$HOST_IP:3000/api/health
```

### Widget Not Found

**Symptom**: `Expected: exactly one matching candidate. Actual: Found 0 widgets`

**Cause**:
- Timing issue (widget non ancora renderizzato)
- Wrong widget text (TextSpan composito)
- Navigation non completata

**Fix**:
```dart
// Add more wait time
await tester.pump(const Duration(seconds: 1));
await tester.pumpAndSettle();

// Verify actual widgets present
print(tester.allWidgets.map((w) => w.runtimeType).take(20));
```

### Overflow Persiste

**Symptom**: Auto-fix fallisce, overflow ancora presente

**Cause**:
- Fix insufficiente
- Widget constraint complesso
- Dynamic content varia

**Fix**:
- Escalate a user per fix manuale
- Fornisci dettagli widget + constraints
- Suggerisci fix alternativi

---

## Benefits Summary

✅ **Backend Integration**: Valida API reali, no mock
✅ **Layout Validation**: Trova overflow automaticamente
✅ **Screenshot Always**: Review visuale obbligatoria
✅ **User Approval**: No silent failures
✅ **Configurable**: Per blocco, milestone, manual
✅ **Thread-Aware**: Test quando merge paralleli
✅ **Auto-Fix**: Overflow risolti automaticamente (max 2 attempts)

---

## Effort Breakdown

| Activity | Time | Frequency |
|----------|------|-----------|
| Setup (first time) | ~30s | Once per project |
| Generate test (auto) | ~10s | Per screen |
| Run test | ~40-50s | Per test run |
| Screenshot review | ~1-2 min | Per milestone |
| Fix overflow (if needed) | ~2-3 min | Rarely |
| **Total per milestone** | **~2-4 min** | Per milestone |

**ROI**: 2-4 min investment → Previene ore di debug layout issues post-deployment.
