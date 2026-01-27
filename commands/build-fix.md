# /build-fix - Fix Build Errors

## Overview

Analizza e corregge errori di build automaticamente. Esegue build, raccoglie errori, applica fix uno alla volta.

## Syntax

```bash
/build-fix               # Fix errori di build
/build-fix --types       # Fix solo errori TypeScript
/build-fix --lint        # Fix solo errori lint
/build-fix --all         # Fix tutto (build + types + lint)
/build-fix --dry-run     # Mostra fix senza applicare
```

## Workflow

```
1. Esegui build
       │
       ▼
2. Raccogli errori
       │
       ▼
3. Per ogni errore:
   ├─ Analizza contesto
   ├─ Proponi fix
   └─ Applica (con conferma)
       │
       ▼
4. Ri-esegui build
       │
       ▼
5. Repeat fino a 0 errori
   (max 3 retry per errore)
```

## Error Categories

### TypeScript Errors

```
[TS2322] Type 'string' is not assignable to type 'number'
  File: src/utils/math.ts:15
  Context:
    const result: number = calculateTotal(items);
                           ^^^^^^^^^^^^^^^
  Fix: Return type mismatch - check calculateTotal return type

[TS2339] Property 'foo' does not exist on type 'User'
  File: src/services/user.ts:42
  Context:
    const name = user.foo;
                     ^^^
  Fix: Property missing - add to interface or fix typo
```

### Build Errors

```
[BUILD] Module not found: 'lodash'
  File: src/utils/helpers.ts:1
  Fix: Run 'npm install lodash' or fix import path

[BUILD] Cannot find module './missing-file'
  File: src/index.ts:5
  Fix: File doesn't exist - create or fix path
```

### Lint Errors

```
[LINT] 'useState' is defined but never used
  File: src/components/Button.tsx:2
  Fix: Remove unused import

[LINT] Unexpected console statement
  File: src/services/api.ts:45
  Fix: Remove console.log or use logger
```

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                     BUILD FIX REPORT                          ║
╠══════════════════════════════════════════════════════════════╣
║ Initial errors: 12                                            ║
║ Fixed: 10                                                     ║
║ Remaining: 2 (need manual fix)                                ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ ✅ Fixed: src/utils/math.ts:15                                ║
║    Type mismatch - changed return type to number              ║
║                                                               ║
║ ✅ Fixed: src/services/user.ts:42                             ║
║    Added 'foo' property to User interface                     ║
║                                                               ║
║ ❌ Manual: src/complex/logic.ts:89                            ║
║    Complex type inference issue - needs human review          ║
║                                                               ║
║ ❌ Manual: src/external/api.ts:23                             ║
║    Third-party type definition mismatch                       ║
╠══════════════════════════════════════════════════════════════╣
║ Run '/verify' to confirm all fixes                            ║
╚══════════════════════════════════════════════════════════════╝
```

## Fix Strategies

### Automatic Fixes

| Error Type | Strategy |
|------------|----------|
| Missing import | Add import statement |
| Unused import | Remove import |
| Type mismatch (simple) | Update type annotation |
| Missing property | Add to interface |
| Unused variable | Remove or prefix with _ |
| Console statements | Remove or wrap with condition |

### Manual Required

| Error Type | Why Manual |
|------------|------------|
| Complex generics | Need context understanding |
| Business logic errors | Need domain knowledge |
| Third-party types | May need version update |
| Circular dependencies | Architectural decision |

## Retry Logic

```
Per ogni errore:
  Attempt 1: Try standard fix
  Attempt 2: Try alternative fix
  Attempt 3: Try with broader context
  After 3: Mark as "needs manual review"
```

## Safety

### Before Fixing

1. Git working tree pulito (commit o stash changes)
2. Backup automatico pre-fix

### During Fixing

1. Un file alla volta
2. Verifica build dopo ogni fix
3. Rollback se fix causa nuovi errori

### After Fixing

1. Run `/verify` per conferma
2. Review changes con `git diff`
3. Commit se tutto OK

## Integration

Combina con:
- `/verify` - Prima per identificare errori
- `/code-review` - Dopo fix per quality check
- `/checkpoint create` - Prima di fix complessi
