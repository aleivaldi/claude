# /tdd - Test-Driven Development Guide

## Overview

Guida il ciclo TDD: RED → GREEN → REFACTOR. Genera test prima del codice, poi implementa il minimo per farli passare.

## Syntax

```bash
/tdd                     # Inizia ciclo TDD interattivo
/tdd [feature]           # TDD per feature specifica
/tdd --unit              # Solo unit tests
/tdd --integration       # Solo integration tests
```

## TDD Cycle

```
     ┌─────────────────┐
     │   1. RED        │
     │   Write failing │
     │   test first    │
     └────────┬────────┘
              │
     ┌────────▼────────┐
     │   2. GREEN      │
     │   Write minimal │
     │   code to pass  │
     └────────┬────────┘
              │
     ┌────────▼────────┐
     │   3. REFACTOR   │
     │   Improve code  │
     │   keep tests ✓  │
     └────────┬────────┘
              │
              └──────────► Repeat
```

## Workflow Process

### Phase 1: Define Interface

```typescript
// Prima: definisci l'interfaccia/tipo
interface UserService {
  create(data: CreateUserDTO): Promise<User>;
  findById(id: string): Promise<User | null>;
  update(id: string, data: UpdateUserDTO): Promise<User>;
  delete(id: string): Promise<void>;
}
```

### Phase 2: Write Failing Tests (RED)

```typescript
describe('UserService', () => {
  describe('create', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const data = { email: 'test@test.com', name: 'Test' };

      // Act
      const user = await userService.create(data);

      // Assert
      expect(user.id).toBeDefined();
      expect(user.email).toBe(data.email);
    });

    it('should throw for duplicate email', async () => {
      // Arrange
      const data = { email: 'existing@test.com', name: 'Test' };

      // Act & Assert
      await expect(userService.create(data))
        .rejects.toThrow('Email already exists');
    });
  });
});
```

### Phase 3: Minimal Implementation (GREEN)

```typescript
class UserServiceImpl implements UserService {
  async create(data: CreateUserDTO): Promise<User> {
    const existing = await this.repository.findByEmail(data.email);
    if (existing) {
      throw new ConflictError('Email already exists');
    }

    return this.repository.create(data);
  }
}
```

### Phase 4: Refactor

Migliora il codice mantenendo i test verdi:
- Estrai funzioni helper
- Migliora naming
- Rimuovi duplicazione
- Ottimizza performance

## Test Templates

### Unit Test

```typescript
describe('[Unit]', () => {
  let sut: SystemUnderTest; // System Under Test

  beforeEach(() => {
    sut = new SystemUnderTest(mockDependency);
  });

  it('should [expected behavior] when [condition]', () => {
    // Arrange
    const input = createTestInput();

    // Act
    const result = sut.method(input);

    // Assert
    expect(result).toEqual(expectedOutput);
  });
});
```

### Integration Test

```typescript
describe('[Integration]', () => {
  let app: Express;

  beforeAll(async () => {
    app = await createTestApp();
  });

  it('should [expected behavior]', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@test.com' })
      .expect(201);

    expect(response.body.data.email).toBe('test@test.com');
  });
});
```

## Key Principles

1. **Never skip RED**: Il test DEVE fallire prima
2. **Minimal GREEN**: Scrivi il minimo codice necessario
3. **Refactor safely**: I test proteggono dal breaking
4. **One test at a time**: Focus su un comportamento
5. **Fast feedback**: Tests devono essere veloci

## Anti-patterns da Evitare

| Anti-pattern | Problema | Soluzione |
|--------------|----------|-----------|
| Test after code | Mancano edge cases | Scrivi test PRIMA |
| Too much GREEN | Over-engineering | Minimal implementation |
| Skip refactor | Technical debt | Dedica tempo al refactor |
| Flaky tests | Random failures | Isola dependencies |
| Slow tests | Feedback lento | Mock external services |

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                     TDD CYCLE STATUS                          ║
╠══════════════════════════════════════════════════════════════╣
║ Feature: UserService.create                                   ║
║ Phase: RED                                                    ║
║                                                               ║
║ ❌ Test: should create user with valid data                   ║
║    Error: UserServiceImpl is not defined                      ║
║                                                               ║
║ Next: Implement minimal UserServiceImpl.create()              ║
╚══════════════════════════════════════════════════════════════╝
```

## Integration

Combina con:
- `/verify` - Valida tutto dopo TDD cycle
- `/code-review` - Review codice dopo implementation
- `/checkpoint create` - Salva stato tra cicli
