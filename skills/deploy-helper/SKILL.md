---
name: deploy-helper
description: Prepara e guida il deploy. Verifica prerequisiti, genera checklist, esegue deploy steps, e gestisce rollback.
---

# Deploy Helper Skill

## Obiettivo

Guidare il processo di deploy verificando prerequisiti, generando checklist, e assistendo l'esecuzione.

## Invocazione

```
/deploy-helper [environment] [options]

Esempi:
/deploy-helper staging           # Deploy to staging
/deploy-helper production        # Deploy to production
/deploy-helper staging --dry-run # Preview senza eseguire
/deploy-helper production --rollback  # Rollback
```

## Workflow

```
┌────────────────────────────────────────────────────────────┐
│              /deploy-helper [environment]                   │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 1. VERIFY PREREQUISITES                                    │
│    - All tests passing?                                    │
│    - Code review done?                                     │
│    - Environment config exists?                            │
│    - Secrets configured?                                   │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 2. GENERATE CHECKLIST                                      │
│    - Pre-deploy checks                                     │
│    - Deploy steps                                          │
│    - Post-deploy verification                              │
│    - Rollback procedure                                    │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 3. CHECKPOINT: RELEASE (if production)                     │
│    - Review checklist                                      │
│    - Confirm deploy                                        │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 4. EXECUTE DEPLOY                                          │
│    - Run deploy commands                                   │
│    - Monitor progress                                      │
│    - Capture logs                                          │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 5. POST-DEPLOY VERIFICATION                                │
│    - Health checks                                         │
│    - Smoke tests                                           │
│    - Monitoring alerts                                     │
└───────────────────────────┬────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────┐
│ 6. REPORT                                                  │
│    - Deploy summary                                        │
│    - Rollback instructions (if needed)                     │
└────────────────────────────────────────────────────────────┘
```

## Fasi

### Fase 1: Verify Prerequisites

```markdown
## Pre-Deploy Checklist

### Code Quality
- [x] All tests passing
- [x] Code review approved
- [x] No critical security issues
- [x] No TODO/FIXME in critical paths

### Environment
- [x] .env.staging configured
- [x] Secrets in secrets manager
- [x] Database migrations ready
- [ ] ⚠️ [External services accessible]

### Version Control
- [x] On main/develop branch
- [x] No uncommitted changes
- [x] Latest pull from remote

### Infrastructure
- [x] Staging environment healthy
- [x] Database backup recent (< 24h)
- [x] Rollback plan documented
```

Se fallisce:
```
❌ Pre-deploy check failed!

Issues:
1. ⚠️ [External service] not accessible from staging
   - Verify network configuration
   - Check security groups

2. ⚠️ Uncommitted changes detected
   - Commit or stash changes before deploy

Fix these issues and run /deploy-helper again.
```

### Fase 2: Generate Checklist

```markdown
# Deploy Checklist - Staging

## Pre-Deploy
- [ ] Notify team of deploy
- [ ] Check monitoring dashboards
- [ ] Verify backup exists

## Deploy Steps
1. [ ] Pull latest code
2. [ ] Build Docker image
3. [ ] Run database migrations
4. [ ] Deploy new containers
5. [ ] Wait for health checks

## Post-Deploy
- [ ] Verify health endpoint
- [ ] Run smoke tests
- [ ] Check error rates
- [ ] Verify key features

## Rollback (if needed)
```bash
# Rollback to previous version
docker-compose -f docker-compose.staging.yml pull myapp:previous
docker-compose -f docker-compose.staging.yml up -d
```
```

### Fase 3: Checkpoint (Production)

Per production deploy, checkpoint BLOCKING:

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: RELEASE <<<
═══════════════════════════════════════════════════════════════

## Production Deploy Request

### Changes to Deploy
- feat(auth): add OAuth login (PR #45)
- fix(api): connection timeout (PR #47)
- chore(deps): update dependencies (PR #48)

### Risk Assessment
- Low risk: No database schema changes
- Auth changes: Medium impact, well tested

### Rollback Plan
- Previous version: v1.2.3
- Rollback command ready
- Database compatible with previous version

### Approvals
- [ ] Code review: ✅ Approved
- [ ] QA sign-off: ✅ Passed
- [ ] Tech lead: ⏳ Pending

═══════════════════════════════════════════════════════════════
Proceed with production deploy? [S]ì / [N]o / [D]elay
═══════════════════════════════════════════════════════════════
```

### Fase 4: Execute Deploy

```
═══════════════════════════════════════════════════════════════
                    DEPLOYING TO STAGING
═══════════════════════════════════════════════════════════════

Step 1/5: Building Docker image...
  ✓ Image built: myapp:staging-abc123

Step 2/5: Running database migrations...
  ✓ 2 migrations applied

Step 3/5: Pushing image to registry...
  ✓ Image pushed

Step 4/5: Deploying containers...
  ✓ Container myapp-1 started
  ✓ Container myapp-2 started

Step 5/5: Waiting for health checks...
  ⏳ Checking myapp-1... ✓ healthy
  ⏳ Checking myapp-2... ✓ healthy

═══════════════════════════════════════════════════════════════
                    DEPLOY COMPLETE
═══════════════════════════════════════════════════════════════
```

### Fase 5: Post-Deploy Verification

```
═══════════════════════════════════════════════════════════════
                  POST-DEPLOY VERIFICATION
═══════════════════════════════════════════════════════════════

Health Checks:
  ✓ /health → 200 OK
  ✓ /api/v1/status → 200 OK

Smoke Tests:
  ✓ Login endpoint responding
  ✓ Main API endpoints working
  ✓ External services connected

Metrics (last 5 min):
  - Error rate: 0.1% (baseline: 0.2%) ✓
  - Response time P95: 180ms (baseline: 200ms) ✓
  - Active connections: 45 (normal) ✓

═══════════════════════════════════════════════════════════════
  ✅ Deploy successful! All checks passing.
═══════════════════════════════════════════════════════════════
```

### Rollback

```
/deploy-helper staging --rollback

═══════════════════════════════════════════════════════════════
                    ROLLBACK INITIATED
═══════════════════════════════════════════════════════════════

Current version: v1.3.0 (abc123)
Rolling back to: v1.2.3 (def456)

Step 1/3: Pulling previous image...
  ✓ Image pulled

Step 2/3: Deploying previous version...
  ✓ Containers updated

Step 3/3: Verifying rollback...
  ✓ Health checks passing
  ✓ Version confirmed: v1.2.3

═══════════════════════════════════════════════════════════════
  ✅ Rollback complete
═══════════════════════════════════════════════════════════════

Note: Investigate and fix the issue before redeploying.
```

## Output

### deploy-report.md

```markdown
# Deploy Report

**Date**: 2025-01-22 18:00
**Environment**: Staging
**Version**: v1.3.0 (abc123)
**Status**: ✅ SUCCESS

## Changes Deployed
- feat(auth): add OAuth login
- fix(api): connection timeout
- chore(deps): update dependencies

## Timeline
| Step | Duration | Status |
|------|----------|--------|
| Build | 45s | ✅ |
| Migrations | 3s | ✅ |
| Deploy | 30s | ✅ |
| Health checks | 15s | ✅ |
| **Total** | **1m 33s** | ✅ |

## Post-Deploy Metrics
| Metric | Before | After | Status |
|--------|--------|-------|--------|
| Error rate | 0.2% | 0.1% | ✅ |
| P95 latency | 200ms | 180ms | ✅ |
| Memory | 450MB | 460MB | ✅ |

## Rollback Info
- Previous version: v1.2.3
- Rollback tested: Yes
- Command: `docker-compose pull myapp:v1.2.3 && docker-compose up -d`
```

## Principi

- **Safety first**: Verifica sempre prima di deploy
- **Rollback ready**: Piano rollback sempre pronto
- **Observability**: Monitora metriche pre/post
- **Incremental**: Staging prima di production
- **Documented**: Report per ogni deploy
