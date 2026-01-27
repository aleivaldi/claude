# Code Standards

## Principi Fondamentali

### KISS
Soluzione più semplice che funziona. No over-engineering.

### YAGNI
Implementa solo ciò che serve ORA. No future-proofing speculativo.

### DRY (con giudizio)
3 ripetizioni → considera astrazione. Ma: duplicazione > astrazione sbagliata.

---

## Commenti: SEMPRE MINIMI

**Il codice deve essere autoesplicativo. Commenti = fallimento del naming.**

### VIETATI
```
counter++;                    // ❌ incrementa counter
function getUser() {}         // ❌ ottiene utente
for (item of items) {}        // ❌ loop items
// ========== SEZIONE ==========  // ❌ header decorativi
// const old = x;             // ❌ codice commentato
```

### PERMESSI (solo questi)
```
// WHY: bypass rate limit per admin - TICKET-123
// TODO(mario): rimuovere dopo migrazione v2
// HACK: workaround bug lib X - github.com/x/issue/1
// WARNING: modifica anche cache globale
```

### JSDoc/Docstring
- ❌ Funzioni private
- ❌ Nomi autoesplicativi
- ✅ Solo API pubbliche di librerie

---

## Naming

```
// Variabili: descrittive
userAuthentication    ✅
usrAuth              ❌

// Funzioni: verbo + oggetto
calculateTotal()     ✅
total()              ❌

// Boolean: prefisso
isActive, hasPermission, canEdit

// Costanti
MAX_RETRY, API_URL
```

---

## Struttura

- File: < 300 righe (ideale), < 500 (max)
- Funzione: < 30 righe (ideale), < 50 (max)
- Linea: < 100 caratteri

---

## Error Handling

```javascript
// Fail fast
if (!user) throw new Error('User required');

// Errori specifici
throw new ValidationError('Email invalid');

// MAI silenzioso
try { } catch (e) { /* ❌ */ }

// Sempre log + rethrow o gestisci
try {
  await op();
} catch (error) {
  logger.error('Failed', { error });
  throw error;
}
```

---

## TypeScript

### Config
```json
{ "compilerOptions": { "strict": true } }
```

### Types
```typescript
// No any
function process(data: any) {}     // ❌
function process(data: unknown) {} // ✅

// Interface per oggetti, Type per union
interface User { id: string; }
type Status = 'active' | 'inactive';
```

### Async
```typescript
// Parallel quando indipendenti
const [users, posts] = await Promise.all([
  fetchUsers(),
  fetchPosts()
]);
```

---

## Dart/Flutter

### Null Safety
```dart
String? nullable;
final name = user?.name ?? 'Guest';
// user!.name → solo se 100% sicuro
```

### Immutabilità
```dart
const EdgeInsets.all(16);  // const dove possibile
final user = await fetch(); // final per non-riassegnate

@immutable
class User {
  final String id;
  const User({required this.id});
}
```

### State Management (Riverpod)
```dart
final userProvider = FutureProvider<User>((ref) async {
  return ref.watch(repoProvider).getUser();
});
```

---

## Python

### Type Hints (sempre)
```python
def get_user(user_id: str) -> User | None:
    return db.get(User, user_id)
```

### Dataclass
```python
@dataclass(frozen=True)
class User:
    id: str
    email: str
```

### Async
```python
users, posts = await asyncio.gather(
    fetch_users(),
    fetch_posts()
)
```

---

## Testing (tutti i linguaggi)

### Naming
```
describe('UserService')
  describe('createUser')
    it('should create with valid data')
    it('should throw for invalid email')
```

### AAA Pattern
```javascript
it('calculates total', () => {
  // Arrange
  const items = [{price: 100}];

  // Act
  const total = calculate(items);

  // Assert
  expect(total).toBe(100);
});
```
