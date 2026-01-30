# Cost Estimation - Cloud Infrastructure

Stima costi mensili per stack types (AWS focus, simili per GCP/Azure).

---

## Stack Tiers

| Tier | Target | Monthly Cost | Use Case |
|------|--------|--------------|----------|
| Minimal | Dev solo | ~$2-3 | Docker locale + S3/IoT cloud |
| Standard | Small prod | ~$28 (~$13 Free Tier) | Managed DB/cache |
| Production | Scale | ~$100-500 | HA, autoscaling, monitoring |

---

## Minimal Stack (~$2-3/mese)

**Locale (Docker)**: $0
- PostgreSQL 15
- Redis 7
- (Optional) RabbitMQ

**Cloud**:
- S3 (5GB storage, 10k requests): ~$0.50/mese
- IoT Core (100 devices, 1M messages): ~$2/mese

**Total**: ~$2.50/mese

---

## Standard Stack (~$28/mese, ~$13 con Free Tier)

**Cloud Managed**:
- RDS PostgreSQL db.t4g.micro (20GB): ~$15/mese
  - Free Tier: 750 ore/mese primi 12 mesi = **$0**
- ElastiCache Redis cache.t4g.micro: ~$12/mese
- S3 + CloudFront (10GB): ~$1/mese

**Total**:
- **Senza Free Tier**: ~$28/mese
- **Con Free Tier** (primi 12 mesi): ~$13/mese

---

## Production Stack (~$113-500/mese)

### Base (~$113/mese)

- RDS PostgreSQL db.t4g.small (50GB): ~$30/mese
- ElastiCache Redis cache.t3.medium: ~$50/mese
- S3 + CloudFront (50GB): ~$5/mese
- Application Load Balancer: ~$18/mese
- CloudWatch Logs (10GB): ~$5/mese
- CloudWatch Metrics (50 custom): ~$15/mese

**Total**: ~$113/mese

### Scale (~$250-500/mese)

Aggiungi:
- RDS Multi-AZ: +$30/mese (HA)
- ElastiCache replica: +$50/mese (HA)
- Fargate/EC2 compute: ~$50-200/mese
- NAT Gateway: ~$32/mese
- WAF: ~$5/mese

**Total**: ~$250-500/mese

---

## Free Tier Benefits (AWS)

**Primi 12 mesi** (new accounts):

| Service | Free Tier | Value |
|---------|-----------|-------|
| RDS | 750 ore/mese db.t2.micro | ~$15/mese saved |
| EC2 | 750 ore/mese t2.micro | ~$8/mese saved |
| S3 | 5GB storage, 20k GET, 2k PUT | ~$0.50/mese saved |
| Lambda | 1M requests, 400k GB-sec | ~$0.20/mese saved |
| CloudWatch | 10 custom metrics, 5GB logs | ~$5/mese saved |

**Always Free** (no expiration):

| Service | Always Free | Value |
|---------|-------------|-------|
| DynamoDB | 25GB storage, 200M requests | ~$6/mese saved |
| Lambda | 1M requests/mese | ~$0.20/mese saved |
| CloudWatch | 10 custom metrics | ~$3/mese saved |
| SNS | 1M publishes | ~$0.50/mese saved |
| SQS | 1M requests | ~$0.40/mese saved |

**Impact**:
- Standard Stack: $28/mese → **$13/mese** primi 12 mesi (saving ~$15)
- Production Stack: $113/mese → **~$100/mese** primi 12 mesi (saving ~$13)

---

## Cost Breakdown by Service Type

### Database (RDS PostgreSQL)

| Instance | vCPU | RAM | Storage | Cost/month | Use Case |
|----------|------|-----|---------|------------|----------|
| db.t4g.micro | 2 | 1GB | 20GB | ~$15 | Dev/small |
| db.t4g.small | 2 | 2GB | 50GB | ~$30 | Small prod |
| db.t4g.medium | 2 | 4GB | 100GB | ~$60 | Medium prod |
| db.r6g.large | 2 | 16GB | 500GB | ~$180 | Large prod |

**Multi-AZ**: +100% cost (HA)

### Cache (ElastiCache Redis)

| Instance | RAM | Cost/month | Use Case |
|----------|-----|------------|----------|
| cache.t4g.micro | 0.5GB | ~$12 | Dev/small |
| cache.t3.medium | 3.09GB | ~$50 | Small prod |
| cache.r6g.large | 13.07GB | ~$150 | Medium prod |

### Storage (S3)

| Usage | Cost/month |
|-------|------------|
| 5GB storage + 10k requests | ~$0.50 |
| 10GB storage + 50k requests | ~$1 |
| 50GB storage + 500k requests | ~$5 |
| 100GB storage + 1M requests | ~$10 |

**CloudFront CDN**: +$0.085/GB transferred (primi 10TB)

### IoT Core

| Devices | Messages/month | Cost/month |
|---------|----------------|------------|
| 100 | 1M | ~$2 |
| 1000 | 10M | ~$8 |
| 10000 | 100M | ~$80 |

**Pricing**: $0.08/million messages

### Compute (Fargate)

| vCPU | RAM | Hours/month | Cost/month |
|------|-----|-------------|------------|
| 0.25 | 0.5GB | 730 | ~$10 |
| 0.5 | 1GB | 730 | ~$20 |
| 1 | 2GB | 730 | ~$40 |

---

## Cost Optimization Tips

### 1. Use Free Tier Aggressively

- RDS db.t2.micro free primi 12 mesi → Save $15/mese
- Lambda 1M requests free sempre → Use serverless dove possibile

### 2. Right-size Instances

- Start small (t4g.micro), scale when needed
- Monitor CloudWatch metrics per usage reale

### 3. Use Spot/Reserved Instances (Prod)

- Reserved Instances: -40% su compute (commit 1-3 anni)
- Spot Instances: -70% per workload fault-tolerant

### 4. Local Dev Always

- PostgreSQL/Redis locale → Save $27/mese vs managed
- Docker compose: $0 vs managed services

### 5. Tag Everything for Cost Tracking

```yaml
Tags:
  - Key: Project
    Value: MyProject
  - Key: Environment
    Value: dev
  - Key: CostCenter
    Value: minimal-stack
```

→ Cost Explorer filter per Project = accurate tracking

### 6. Set Budget Alerts

```bash
aws budgets create-budget \
  --budget BudgetName=MyProject-Dev,BudgetLimit=Amount=10.0,Unit=USD \
  --notifications-with-subscribers NotificationType=ACTUAL,Threshold=80
```

---

## Upgrade Paths

### Path 1: Minimal → Standard

**When**: >1000 users, >10k requests/hour

**Changes**:
- Docker PostgreSQL → RDS db.t4g.micro (+$15)
- Docker Redis → ElastiCache cache.t4g.micro (+$12)

**Cost**: $2/mese → $28/mese (+$26)

**Effort**: ~15 min (change env vars, deploy stack)

### Path 2: Standard → Production

**When**: >10k users, need HA

**Changes**:
- RDS db.t4g.micro → db.t4g.small Multi-AZ (+$30)
- ElastiCache single → replica (+$50)
- Add Load Balancer (+$18)
- Add monitoring (+$20)

**Cost**: $28/mese → $113/mese (+$85)

**Effort**: ~2 ore (IaC update, testing)

---

## Cost Comparison: AWS vs GCP vs Azure

### Standard Stack Equivalent

| Service | AWS | GCP | Azure |
|---------|-----|-----|-------|
| Database (2GB RAM, 50GB) | RDS $30 | Cloud SQL $20 | Azure DB $25 |
| Cache (3GB RAM) | ElastiCache $50 | Memorystore $45 | Azure Cache $55 |
| Storage (10GB) | S3 $1 | Cloud Storage $0.50 | Blob $0.80 |
| Load Balancer | ALB $18 | Load Balancer $18 | Load Balancer $20 |

**Total**:
- AWS: ~$99/mese
- GCP: ~$83/mese (**cheapest**)
- Azure: ~$100/mese

**Note**: GCP spesso più economico per compute/storage, AWS più servizi, Azure integrazione enterprise.

---

## Cost Tracking & Monitoring

### 1. Enable Cost Allocation Tags

```bash
aws ce update-cost-allocation-tags-status \
  --cost-allocation-tags-status \
    TagKey=Project,Status=Active \
    TagKey=Environment,Status=Active
```

### 2. Create Budget

```bash
aws budgets create-budget \
  --account-id 123456789012 \
  --budget file://budget.json
```

### 3. Monitor in Cost Explorer

- Group by: Tag (Project)
- Filter: Environment = dev
- Time range: Last 30 days

### 4. Set Alerts

- 50% budget: Email warning
- 80% budget: Email + Slack alert
- 100% budget: Email + stop non-critical resources

---

## Summary

| Stack | Cost/month | Use Case | Upgrade Effort |
|-------|------------|----------|----------------|
| Minimal | ~$2-3 | Solo dev, MVP | N/A |
| Standard | ~$28 (~$13 FT) | Small prod (<1k users) | 15 min |
| Production | ~$113-500 | Scale, HA (>10k users) | 2 ore |

**Key Insight**: Start Minimal ($2/mese), upgrade Standard when traction ($28/mese), Production quando scale ($100+/mese).

**Free Tier**: Save ~$15-20/mese primi 12 mesi → Standard stack costa $13/mese invece di $28.
