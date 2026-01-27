# Code Review Workflow Diagram

```
┌────────────────────────────────────────────────────────────┐
│ 1. DETERMINE SCOPE                                         │
│    User specifies: files, commit, branch, or PR            │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 2. INVOKE CODE-REVIEWER AGENT                              │
│    - Read all files in scope                               │
│    - Analyze for issues                                    │
│    - Classify by severity                                  │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 3. GENERATE FINDINGS                                       │
│    - Critical: Security, data loss                         │
│    - High: Likely bugs, perf issues                        │
│    - Medium: Code smells, maintainability                  │
│    - Low: Style, minor improvements                        │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 4. AUTO-FIX (if --fix)                                     │
│    - Invoke Fixer agent                                    │
│    - Apply fixes                                           │
│    - Re-review                                             │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 5. OUTPUT REPORT                                           │
│    - Summary                                               │
│    - Detailed findings                                     │
│    - Recommendations                                       │
└────────────────────────────────────────────────────────────┘
```

## Decision Points

- **--fix flag**: Auto-invoke fixer or just report
- **Severity threshold**: Filter findings by severity
- **Scope**: Single file vs multiple vs entire codebase
