# Dynamic Parallelization: Blocchi con Review Integrata

## Overview

Architettura a **due livelli di parallelismo**:
1. **Tra blocchi**: blocchi indipendenti eseguono in parallelo
2. **Dentro blocco**: Track 1 (impl -> review -> fix) e Track 2 (test-writer su contratti) in parallelo

Sostituisce la parallelizzazione wave-based. La review avviene **per-blocco** (non alla fine), riducendo il rework.

## Workflow Completo

```
+-----------------------------------------------------------------+
| 1. BLOCK DECOMPOSITION                                          |
|    - Analizza milestone scope                                   |
|    - Identifica blocchi funzionali coesi                        |
|    - Costruisci dependency DAG                                  |
|    - >>> CHECKPOINT: approvazione utente <<<                    |
+-----------------------+-----------------------------------------+
                        |
                        v
+-----------------------------------------------------------------+
| 2. BLOCK EXECUTION (Parallelo tra blocchi indipendenti)         |
|                                                                 |
|  Blocco A (no deps)        Blocco B (no deps)                  |
|  +---------------------+   +---------------------+             |
|  | Track1   | Track2   |   | Track1   | Track2   |             |
|  | Impl     | Tests    |   | Impl     | Tests    |             |
|  |   |      | (su API  |   |   |      | (su API  |             |
|  |   v      |  contract|   |   v      |  contract|             |
|  | Review   |  /tipi)  |   | Review   |  /tipi)  |             |
|  |   |      |          |   |   |      |          |             |
|  |   v      |          |   |   v      |          |             |
|  | Fix loop |          |   | Fix loop |          |             |
|  +----+-----+----+-----+   +----+-----+----+-----+             |
|       |          |              |          |                    |
|       +-- SYNC --+              +-- SYNC --+                    |
|           |                         |                           |
|       Run Tests                 Run Tests                       |
|       Fix if fail               Fix if fail                     |
|           |                         |                           |
|       BLOCK A OK                BLOCK B OK                      |
|           |                         |                           |
+-----------|-------------------------|---------------------------+
            |                         |
            v                         v
+-----------------------------------------------------------------+
| Blocco C (dipende da A)    Blocco D (dipende da A+B)           |
|  +---------------------+   (attende B)                         |
|  | Track1   | Track2   |   +---------------------+             |
|  | ...      | ...      |   | Track1   | Track2   |             |
|  +---------------------+   | ...      | ...      |             |
|                             +---------------------+             |
+-----------------------------------------------------------------+
```

## Struttura Blocco Dettagliata

```
+-----------------------------------------------------------+
| BLOCCO [id]                                               |
|                                                           |
|  +--------------------+    +------------------------+     |
|  | Track 1            |    | Track 2                |     |
|  |                    |    |                        |     |
|  | Implementer        |    | Test Writer            |     |
|  | (codice + unit     |    | (contract/integration  |     |
|  |  test interni)     |    |  test su interfacce    |     |
|  |   |                |    |  pubbliche, API,       |     |
|  |   v                |    |  schemas, tipi)        |     |
|  | Commit WIP         |    |                        |     |
|  |   |                |    |                        |     |
|  |   v                |    |                        |     |
|  | Code Review        |    |                        |     |
|  |   |                |    |                        |     |
|  |   v                |    |                        |     |
|  | Fix + commit fix   |    |                        |     |
|  | (loop max 3x)      |    |                        |     |
|  |   |                |    |                        |     |
|  |   v                |    |                        |     |
|  | Review OK          |    | Tests Ready            |     |
|  +--------+-----------+    +------------+-----------+     |
|           |                             |                 |
|           +---------- SYNC ------------+                 |
|                        |                                  |
|              Run ALL Tests                                |
|              (unit interni + contract)                    |
|                        |                                  |
|              Se fail:                                     |
|                fixer -> commit fix ->                     |
|                focused review -> retest                   |
|              (loop max 3x)                                |
|                        |                                  |
|              Squash commits                               |
|                        |                                  |
|              BLOCCO COMPLETO                              |
+-----------------------------------------------------------+
```

## Algoritmo Principale

```python
async def execute_milestone_blocks(milestone, scope, approved_blocks):
    """
    Esegue milestone con workflow a blocchi e review integrata.
    approved_blocks: lista blocchi approvata dall'utente al checkpoint.
    """
    dag = build_dependency_dag(approved_blocks)
    completed = set()
    failed = set()

    while not all_done(dag, completed, failed):
        # Trova blocchi pronti: dipendenze completate, non falliti
        ready = [
            block for block in approved_blocks
            if block.id not in completed
            and block.id not in failed
            and all(dep in completed for dep in block.dependencies)
            and not any(dep in failed for dep in block.dependencies)
        ]

        if not ready:
            if failed:
                break  # Blocchi rimanenti dipendono da blocchi falliti
            raise Exception("Deadlock: no blocks ready but not all done")

        # Rispetta limite agenti concorrenti
        batch = select_batch(ready, max_concurrent_agents)

        # Esegui blocchi pronti in parallelo
        results = await asyncio.gather(
            *[execute_block(block) for block in batch],
            return_exceptions=True
        )

        for block, result in zip(batch, results):
            if isinstance(result, Exception) or result.status == "failed":
                failed.add(block.id)
                log_block_failure(block, result)
            else:
                completed.add(block.id)
                log_block_success(block, result)

    return BlockExecutionResult(completed=completed, failed=failed)


async def execute_block(block):
    """
    Esegue singolo blocco con Track 1 + Track 2 in parallelo.
    Commit WIP prima della review, squash a fine blocco.
    """
    # STEP 0: Crea feature branch (git flow)
    # Se git_flow.enabled: branch isolato per il blocco
    # Se git_flow.enabled == false: resta sul branch corrente
    pre_block_hash = git_rev_parse("HEAD")
    if config.git_flow.enabled:
        git_checkout("develop")
        git_checkout_branch(f"feature/{block.scope}")  # -b, o riusa se esiste (retry)

    # STEP 1: Spawn parallelo Track 1 + Track 2
    track1_task = asyncio.create_task(execute_track1(block))
    track2_task = asyncio.create_task(execute_track2(block))

    # STEP 2: Attendi completamento entrambi
    track1_result, track2_result = await asyncio.gather(
        track1_task, track2_task
    )

    if track1_result.status == "failed":
        return BlockResult(status="failed", reason="Track 1 failed")

    # STEP 2b: VALIDATE Track 2 (enforcement R2 + SEMANTIC QUALITY)
    if track2_result.status == "failed":
        return BlockResult(status="failed", reason="Track 2 failed: no contract tests")
    if not track2_result.test_files_exist:
        return BlockResult(status="failed", reason="Track 2: contract test files not created")
    if track2_result.test_count == 0:
        return BlockResult(status="failed", reason="Track 2: 0 contract tests written")

    # NEW: Semantic quality validation
    quality_issues = await validate_contract_test_quality(block, track2_result)
    critical_issues = [i for i in quality_issues if i["severity"] == "CRITICAL"]

    if critical_issues:
        # Attempt auto-fix with test-writer (max 2 attempts)
        for attempt in range(2):
            fix_result = await spawn_agent(
                type="test-writer",
                prompt=f"""FIX contract test quality issues in {block.id}:

Issues found:
{format_quality_issues(critical_issues)}

CRITICAL: Contract tests must:
1. Test actual API contracts (not trivial assertions like expect(true).toBe(true))
2. Reference schemas/types from contracts (import and use)
3. Validate response schemas (using Zod, Joi, or similar)
4. Cover all HTTP methods declared in contract
5. Include error case tests (4xx responses)

Rewrite tests to be semantically meaningful."""
            )

            # Re-validate after fix
            track2_result = await verify_track2_completion(block)
            quality_issues = await validate_contract_test_quality(block, track2_result)
            critical_issues = [i for i in quality_issues if i["severity"] == "CRITICAL"]

            if not critical_issues:
                break  # Quality OK after fix

        # Se ancora critical issues dopo 2 tentativi → FAIL
        if critical_issues:
            return BlockResult(
                status="failed",
                reason=f"Track 2: contract tests still low quality after 2 fix attempts. Issues: {critical_issues}"
            )

    # STEP 3: Run ALL tests (unit interni da Track 1 + contract da Track 2)
    all_test_files = block.unit_test_files + block.contract_test_files

    for attempt in range(3):
        test_result = run_tests(all_test_files)

        if test_result.all_passed:
            break

        if attempt < 2:
            # Fix codice (non test, salvo test palesemente errati)
            fix_result = await run_fixer(
                block, test_result.failures,
                fix_target="implementation"
            )

            # Commit il fix
            git_commit(f"fix({block.scope}): fix test failures {block.id}")

            # Focused review: solo file toccati dal fixer
            focused_review = await spawn_agent(
                type="code-reviewer",
                prompt=f"Focused review: verify fix in {block.id} doesn't introduce new issues",
                context={"files": fix_result.modified_files}
            )

            if focused_review.has_issues:
                # Fix issue della focused review
                await run_fixer(block, focused_review.issues)
                git_commit(f"fix({block.scope}): address focused review {block.id}")

    if not test_result.all_passed:
        return BlockResult(status="failed", reason="Tests still failing after 3 fix attempts")

    # STEP 4: Build check
    build_ok = verify_build()
    if not build_ok:
        return BlockResult(status="failed", reason="Build broken")

    # STEP 5: Merge feature branch su develop (git flow)
    # Se git_flow.enabled (default true):
    git_checkout("develop")
    git_merge_squash(f"feature/{block.scope}")
    git_commit(
        f"feat({block.scope}): implement {block.id}\n\n"
        f"- Unit tests: {test_result.unit_passed}/{test_result.unit_total} passed\n"
        f"- Contract tests: {test_result.contract_passed}/{test_result.contract_total} passed\n"
        f"- Review issues fixed: {track1_result.issues_fixed}\n\n"
        f"Co-Authored-By: Claude <model> <noreply@anthropic.com>"
    )
    git_branch_delete(f"feature/{block.scope}")
    #
    # Se git_flow.enabled == false: fallback a squash con reset --soft
    # git_reset_soft(pre_block_hash) + git_commit(...)

    return BlockResult(
        status="completed",
        unit_passed=test_result.unit_passed,
        unit_total=test_result.unit_total,
        contract_passed=test_result.contract_passed,
        contract_total=test_result.contract_total,
        fix_rounds=test_result.fix_rounds,
        issues_fixed=track1_result.issues_fixed
    )


async def execute_track1(block):
    """
    Track 1: Implement (codice + unit test interni) -> Commit WIP -> Review -> Fix loop
    """
    # Implementazione: codice + unit test per logica interna
    impl_result = await spawn_agent(
        type=block.implementer_type,  # backend-implementer o frontend-implementer
        prompt=f"""Implement {block.id}: {block.description}

Include unit tests for internal logic (helper functions, algorithms,
business rules). These test internals; contract/integration tests
are written separately by another agent.""",
        context={
            "files": block.implementation_files,
            "unit_test_files": block.unit_test_files,
            "api_signature": block.contracts,
            "architecture": block.architecture_ref
        }
    )

    if impl_result.failed:
        return Track1Result(status="failed")

    # Commit WIP: salva lavoro implementer prima della review
    git_add(block.implementation_files + block.unit_test_files)
    git_commit(f"wip({block.scope}): implement {block.id}")

    # Review + Fix loop
    issues_fixed = 0
    for attempt in range(3):
        review = await spawn_agent(
            type="code-reviewer",
            prompt=f"""Review block {block.id}.
Also verify that unit tests for internal logic are sufficient.""",
            context={"files": block.implementation_files + block.unit_test_files}
        )

        if not review.has_issues:
            return Track1Result(status="completed", issues_fixed=issues_fixed)

        fix = await spawn_agent(
            type="fixer",
            prompt=f"Fix issues in {block.id}: {review.issues}",
            context={"files": block.implementation_files + block.unit_test_files}
        )
        issues_fixed += len(review.issues)

        # Commit fix della review
        git_commit(f"fix({block.scope}): address review {block.id}")

    return Track1Result(status="completed_with_warnings", issues_fixed=issues_fixed)


async def execute_track2(block):
    """
    Track 2: Test writer scrive contract/integration test su interfacce pubbliche.
    NON testa logica interna (quella e' coperta dagli unit test in Track 1).
    """
    result = await spawn_agent(
        type="test-writer",
        prompt=f"""Write CONTRACT and INTEGRATION tests for {block.id}.

IMPORTANT: Write tests based on CONTRACTS and PUBLIC INTERFACES only:
- API endpoint contracts (methods, paths, request/response schemas)
- Function signatures and return types
- Schema validation rules
- Edge cases defined in specs

Do NOT test internal implementation details (those are covered by
unit tests written by the implementer).
Tests must remain valid even if internal code is refactored.""",
        context={
            "test_files": block.contract_test_files,
            "contracts": block.contracts,
            "api_signature": block.api_signature_excerpt
        }
    )

    # Post-validation: verifica che i test siano stati effettivamente creati
    test_files_exist = all(file_exists(f) for f in block.contract_test_files)
    test_count = count_test_cases(block.contract_test_files)

    return Track2Result(
        status="completed" if test_files_exist and test_count > 0 else "failed",
        test_files_exist=test_files_exist,
        test_count=test_count
    )
```

## Dependency DAG

### Costruzione

```python
def build_dependency_dag(blocks):
    dag = {}

    for block in blocks:
        deps = []

        # Dipendenze logiche (da analisi scope)
        for dep_id in block.declared_dependencies:
            deps.append(dep_id)

        # Dipendenze tecniche implicite
        if block.uses_shared_types:
            deps.append("shared-types")  # Se esiste come blocco

        if block.needs_database and "db-migrations" in [b.id for b in blocks]:
            deps.append("db-migrations")

        # Validazione: no self-dependency
        deps = [d for d in deps if d != block.id]

        dag[block.id] = deps

    validate_no_cycles(dag)
    return dag
```

### Regole Sblocco

Un blocco e' **pronto** quando:
1. Tutte le sue dipendenze sono in stato `completed`
2. Nessuna dipendenza e' in stato `failed`
3. Non supera il limite di agenti concorrenti

Un blocco e' **bloccato** quando:
1. Almeno una dipendenza e' `failed` -> il blocco viene marcato `blocked_by_failure`
2. Dipendenze ancora `in_progress` -> attende

### Visualizzazione DAG

```
Esempio: Progetto con 5 blocchi

  [shared-types]
       |
  +----+----+
  |         |
  v         v
[auth]   [device-crud]
  |         |
  +----+----+
       |
       v
  [admin-panel]
       |
       v
  [dashboard-ui]

Esecuzione:
  Turno 1: shared-types (solo)
  Turno 2: auth + device-crud (parallelo)
  Turno 3: admin-panel (dopo auth + device-crud)
  Turno 4: dashboard-ui (dopo admin-panel)
```

## Parallelismo: Due Livelli

### Livello 1: Tra Blocchi

Blocchi senza dipendenze reciproche eseguono contemporaneamente.

```
Turno 1: [Block A] || [Block B] || [Block C]
Turno 2: [Block D] (dipende da A)  || [Block E] (dipende da B)
Turno 3: [Block F] (dipende da D + E)
```

### Livello 2: Dentro Blocco

Track 1 (implementer+unit test -> commit WIP -> reviewer -> fixer) e Track 2 (contract test-writer) in parallelo.

```
Block A:
  Track 1: implementer+unit ---> commit WIP ---> reviewer ---> [fixer+commit] ---> OK
  Track 2: contract test-writer --------------------------------------------> OK
                                                                          SYNC
                                                 Run ALL tests -> [fix+commit+focused review] -> OK
                                                                          |
                                                                    Squash commits
```

### Calcolo Agenti Concorrenti

```
Per turno:
  N blocchi paralleli x 2 agenti iniziali (impl + test-writer)
  + reviewer/fixer sequenziali dentro Track 1

Picco: N x 2 (fase iniziale quando tutti i blocchi hanno impl + test attivi)
Medio: N x 1.5 (alcuni blocchi in fase review, altri ancora in impl)

Esempio con max_concurrent_agents = 8:
  Max 4 blocchi paralleli in fase iniziale (4 x 2 = 8)
  Max 8 blocchi paralleli se alcuni gia' in fase review (reviewer e' 1 agente)
```

## Conflict Detection

```python
def check_file_conflicts(parallel_blocks):
    """
    Verifica che blocchi paralleli non scrivano stesso file.
    """
    file_map = {}

    for block in parallel_blocks:
        for file in block.all_files:
            if file in file_map:
                raise ConflictError(
                    f"Blocks {block.id} and {file_map[file]} both write {file}. "
                    f"Add dependency or merge into single block."
                )
            file_map[file] = block.id
```

## Strategia Test: Due Livelli

### Principio

Due tipi di test, scritti da agenti diversi, con scopi complementari:

| Chi | Tipo test | Cosa testa | Stabile dopo refactoring? |
|-----|-----------|-----------|--------------------------|
| Implementer (Track 1) | Unit test interni | Helper functions, algoritmi, business logic privata | No (cambia con refactoring) |
| Test-writer (Track 2) | Contract/integration test | API endpoints, schemas, interfacce pubbliche | Si (testa solo interfaccia) |

### Cosa testa Track 1 (Implementer)

```
Unit test interni:
  - Helper functions e utility
  - Algoritmi e business logic
  - Validazione interna
  - Edge cases implementativi
  - Error paths interni
```

Questi test sono scritti dall'implementer **insieme al codice**. Il code-reviewer verifica che siano sufficienti.

### Cosa testa Track 2 (Test Writer)

```
Contract/integration test:
  Per API endpoint:
    - Risposta corretta con input valido
    - Errori con input invalido (400, 422)
    - Autenticazione richiesta (401) se protetto
    - Schema response conforme a contratto

  Per service/module:
    - Interfaccia pubblica (metodi esportati)
    - Tipi input/output conformi a schema
    - Edge cases definiti nelle specs
    - Error handling (eccezioni dichiarate)
```

### Vantaggio della separazione

Se la code review (Track 1) modifica dettagli implementativi (rinomina variabili interne, cambia algoritmo, refactoring):
- **Unit test interni**: possono rompersi -> il fixer li aggiorna
- **Contract test**: restano validi perche' testano solo l'interfaccia pubblica

Questo garantisce che il ciclo fix-after-review non invalidi i test di Track 2.

## Limiti e Constraints

### Hardware Limits

```yaml
# project-config.yaml
execution:
  max_concurrent_agents: 8  # Default
```

```python
def select_batch(ready_blocks, max_concurrent):
    """
    Seleziona blocchi da eseguire in parallelo rispettando limiti.
    """
    agents_needed = 0
    batch = []

    for block in ready_blocks:
        block_agents = 2  # implementer + test-writer
        if agents_needed + block_agents <= max_concurrent:
            batch.append(block)
            agents_needed += block_agents
        else:
            break  # Blocchi rimanenti nel prossimo turno

    return batch
```

### Shared Resources

Se blocchi paralleli usano risorse condivise (es. stesso database in test):
- Usa database/schema separati per test
- Oppure serializza i blocchi che condividono risorse

## Esempio Esecuzione Reale

```
User: /develop milestone:1

Claude:
Fase 3: Decomposizione in blocchi...

Identificati 4 blocchi:

Block 1: auth-service (backend)
  Files: src/services/auth.ts, src/routes/auth.ts
  Tests: tests/auth.test.ts
  Deps: nessuna

Block 2: device-crud (backend)
  Files: src/services/device.ts, src/routes/device.ts
  Tests: tests/device.test.ts
  Deps: nessuna

Block 3: login-ui (frontend)
  Files: lib/screens/login/, lib/providers/auth_provider.dart
  Tests: test/login_test.dart
  Deps: nessuna (usa contratto API)

Block 4: device-dashboard (frontend)
  Files: lib/screens/dashboard/, lib/providers/device_provider.dart
  Tests: test/dashboard_test.dart
  Deps: nessuna (usa contratto API)

Ordine esecuzione:
  Turno 1: [auth-service] || [device-crud] || [login-ui] || [device-dashboard]
  (tutti paralleli, nessuna dipendenza)

>>> CHECKPOINT: BLOCK_DECOMPOSITION <<<
Approvi questa decomposizione?

User: Si

Turno 1: Avvio 4 blocchi in parallelo (8 agenti)...

  Block auth-service:
    Track 1: backend-implementer -> ...implementing...
    Track 2: test-writer -> ...writing tests on API contracts...

  Block device-crud:
    Track 1: backend-implementer -> ...implementing...
    Track 2: test-writer -> ...writing tests on API contracts...

  Block login-ui:
    Track 1: frontend-implementer -> ...implementing...
    Track 2: test-writer -> ...writing widget tests...

  Block device-dashboard:
    Track 1: frontend-implementer -> ...implementing...
    Track 2: test-writer -> ...writing widget tests...

  [auth-service] git checkout -b feature/auth-service
  [auth-service] Track 1: impl+unit done -> commit WIP -> reviewer -> 1 issue -> fixer -> commit fix -> re-review OK
  [auth-service] Track 2: 8 contract tests ready (validated: 8 test cases, files exist)
  [auth-service] SYNC -> Run ALL tests (5 unit + 8 contract) -> 13/13 passed
  [auth-service] -> merge --squash to develop -> delete feature/auth-service -> BLOCK COMPLETE

  [device-crud] git checkout -b feature/device-crud
  [device-crud] Track 1: impl+unit done -> commit WIP -> reviewer -> no issues -> OK
  [device-crud] Track 2: 6 contract tests ready (validated: 6 test cases, files exist)
  [device-crud] SYNC -> Run ALL tests (4 unit + 6 contract) -> 10/10 passed
  [device-crud] -> merge --squash to develop -> delete feature/device-crud -> BLOCK COMPLETE

  [login-ui] git checkout -b feature/login-ui
  [login-ui] Track 1: impl+unit done -> commit WIP -> reviewer -> no issues -> OK
  [login-ui] Track 2: 5 contract tests ready (validated: 5 test cases, files exist)
  [login-ui] SYNC -> Run ALL tests (3 unit + 5 contract) -> 8/8 passed
  [login-ui] -> merge --squash to develop -> delete feature/login-ui -> BLOCK COMPLETE

  [device-dashboard] git checkout -b feature/device-dashboard
  [device-dashboard] Track 1: impl+unit done -> commit WIP -> reviewer -> 2 issues -> fixer -> commit fix -> re-review OK
  [device-dashboard] Track 2: 7 contract tests ready (validated: 7 test cases, files exist)
  [device-dashboard] SYNC -> Run ALL tests -> 2 fail -> fixer -> commit fix -> focused review OK -> retest -> 11/11 passed
  [device-dashboard] -> merge --squash to develop -> delete feature/device-dashboard -> BLOCK COMPLETE

Tutti i blocchi completati.

| Block            | Unit | Contract | Total | Fix Rounds |
|------------------|------|----------|-------|------------|
| auth-service     | 5/5  | 8/8      | 13/13 | 0          |
| device-crud      | 4/4  | 6/6      | 10/10 | 0          |
| login-ui         | 3/3  | 5/5      | 8/8   | 0          |
| device-dashboard | 4/4  | 7/7      | 11/11 | 1          |
| **Total**        |**16/16**|**26/26**|**42/42**| **1**   |

Review issues fixati: 3
Git: develop branch (4 squash merges) -> merge to main

>>> CHECKPOINT: MILESTONE_COMPLETE <<<
```

---

## Semantic Test Validation (Track 2 Quality)

### Obiettivo

Garantire che i contract test siano **semanticamente validi**, non solo che esistano (count > 0).

### Problema

Validazione quantitativa (STEP 2b basic):
```python
if track2_result.test_count == 0:
    return BlockResult(status="failed", reason="Track 2: 0 contract tests written")
```

**Gap**: Test-writer può scrivere test inutili che passano validation:
```typescript
// Test che passa count > 0 ma è inutile
test('login endpoint exists', () => {
  expect(true).toBe(true); // ❌ Always passes!
});
```

### Soluzione: Quality Checks

```python
async def validate_contract_test_quality(block, track2_result):
    """
    Valida qualità semantica dei contract test.
    Returns: lista di Issue objects con severity CRITICAL | WARNING | INFO
    """
    issues = []

    for test_file in track2_result.test_files:
        # Run semantic validator (Python script)
        result = run_command([
            "python",
            "helpers/semantic-test-validator.py",
            test_file,
            "--format", "json"
        ])

        issues.extend(json.loads(result)["issues"])

    return issues


def format_quality_issues(issues):
    """
    Formatta issue per prompt test-writer.
    """
    formatted = []

    for issue in issues:
        line_info = f" (line {issue['line']})" if issue.get('line') else ""
        formatted.append(
            f"- [{issue['check']}]{line_info}: {issue['message']}"
        )

    return "\n".join(formatted)
```

### Quality Checks Implemented

Vedi: `helpers/semantic-test-validator.py` per implementation.

**1. Trivial Assertions (CRITICAL)**
```python
# Patterns detected:
- expect(true).toBe(true)
- expect(false).toBe(false)
- assert True
- expect("foo").toBe("foo")  # Same string comparison
```

**2. Contract References (CRITICAL)**
```python
# Check se test importa/usa schemas/types/contracts:
- import ... Schema ... from
- from ...schemas import
- .validate(, schema.parse(, Zod usage
```

**3. HTTP Method Coverage (WARNING)**
```python
# Per API tests, verifica coverage metodi HTTP
- Declared: GET, POST, DELETE (da comments/describe)
- Tested: GET, POST (pattern matching .get(, .post()
- → Warning: "DELETE declared but not tested"
```

**4. Response Validation (WARNING)**
```python
# Verifica che response sia validato:
- expect(response.body).toMatchSchema
- schema.parse(response)
- expect(response).toHaveProperty (almeno)
```

**5. Error Cases (WARNING)**
```python
# Verifica test error cases (4xx):
- Pattern: 400|401|403|404|422 status codes
- test.*error, test.*invalid
- expect.*toThrow
```

### Integration in Workflow

**STEP 2b Enhanced** (già modificato sopra):
```python
# After quantitative validation (count > 0)
quality_issues = await validate_contract_test_quality(block, track2_result)
critical_issues = [i for i in quality_issues if i["severity"] == "CRITICAL"]

if critical_issues:
    # Auto-fix: invoke test-writer max 2x
    for attempt in range(2):
        fix_result = await spawn_agent(type="test-writer", ...)
        # Re-validate
        quality_issues = await validate_contract_test_quality(...)
        if not critical_issues:
            break

    # Se ancora critical dopo 2 fix → FAIL block
    if critical_issues:
        return BlockResult(status="failed", reason="Track 2: low quality tests")
```

### Example Fix Prompt

```
FIX contract test quality issues in auth-service:

Issues found:
- [trivial_assertion] (line 12): Trivial assertion found: expect(true).toBe(true)
- [contract_reference] Test does not reference any schemas, types, or contracts
- [response_validation] (WARNING) No response validation found

CRITICAL: Contract tests must:
1. Test actual API contracts (not trivial assertions like expect(true).toBe(true))
2. Reference schemas/types from contracts (import and use)
3. Validate response schemas (using Zod, Joi, or similar)
4. Cover all HTTP methods declared in contract
5. Include error case tests (4xx responses)

Rewrite tests to be semantically meaningful.
```

### Benefits

- ✅ Garantisce test **quality** non solo **quantity**
- ✅ Auto-fix integrato (max 2 attempts, poi fail)
- ✅ Previene "expect(true).toBe(true)" che passa ma non testa nulla
- ✅ Enforce best practices (schema validation, error cases)

### Config

```yaml
# project-config.yaml
execution:
  track2_validation:
    semantic_quality: true        # Enable quality checks (default: true)
    max_fix_attempts: 2           # Auto-fix iterations
    fail_on_critical: true        # Fail block se critical issues
    fail_on_warning: false        # Continue con warnings
```
