# Service Mapping - Tech Stack to Cloud Services

Mappatura tecnologie comuni da `tech-stack.md` a servizi cloud (AWS, GCP, Azure) e Docker locale.

---

## Database

### PostgreSQL

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker | `postgres:15-alpine` | $0 |
| Cloud Minimal | Docker (locale) | `postgres:15-alpine` | $0 |
| Cloud Full | AWS RDS | `db.t4g.micro` (20GB) | ~$15 (~$0 Free Tier) |
| Cloud Full | GCP Cloud SQL | `db-f1-micro` (10GB) | ~$7 |
| Cloud Full | Azure Database | `B_Gen5_1` (5GB) | ~$5 |

**Recommendation**: Docker locale per dev (fast, same SQL), RDS per prod.

### MySQL

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker | `mysql:8-alpine` | $0 |
| Cloud Full | AWS RDS | `db.t4g.micro` | ~$15 |
| Cloud Full | GCP Cloud SQL | `db-f1-micro` | ~$7 |
| Cloud Full | Azure Database | `B_Gen5_1` | ~$5 |

### MongoDB

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker | `mongo:7` | $0 |
| Cloud Full | MongoDB Atlas | M0 Shared (Free) | $0 |
| Cloud Full | MongoDB Atlas | M10 Dedicated | ~$57 |
| Cloud Full | AWS DocumentDB | `db.t3.medium` | ~$73 |

**Recommendation**: MongoDB Atlas M0 (free tier) per dev/small prod.

---

## Cache

### Redis

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker | `redis:7-alpine` | $0 |
| Cloud Minimal | Docker (locale) | `redis:7-alpine` | $0 |
| Cloud Full | AWS ElastiCache | `cache.t4g.micro` | ~$12 |
| Cloud Full | GCP Memorystore | `M1` (1GB) | ~$12 |
| Cloud Full | Azure Cache | `C0` (250MB) | ~$16 |

**Recommendation**: Docker locale per dev (same commands), managed per prod.

### Memcached

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker | `memcached:1-alpine` | $0 |
| Cloud Full | AWS ElastiCache | `cache.t4g.micro` | ~$12 |
| Cloud Full | GCP Memorystore | `M1` (1GB) | ~$12 |

---

## Storage

### S3-compatible

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | ❌ MinIO (NOT RECOMMENDED) | See warnings below | $0 |
| Cloud Minimal | AWS S3 | 5GB + 10k requests | ~$0.50 |
| Cloud Full | AWS S3 + CloudFront | 10GB + CDN | ~$2 |
| Cloud Full | GCP Cloud Storage | 10GB | ~$0.26 |
| Cloud Full | Azure Blob Storage | 10GB | ~$0.18 |

**⚠️ MinIO Warnings**:
- Multipart upload behavior differences
- Pre-signed URL expiration handling differences
- ListObjectsV2 pagination differences
- S3 Transfer Acceleration not supported

**Recommendation**: **Always use cloud S3** (even for dev). Cost minimal (~$0.50/mese), behavior identical.

### File Storage (NFS-like)

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Cloud Full | AWS EFS | 10GB | ~$3 |
| Cloud Full | GCP Filestore | 1TB (min) | ~$204 |
| Cloud Full | Azure Files | 100GB | ~$2 |

---

## Message Brokers

### RabbitMQ

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker | `rabbitmq:3-management` | $0 |
| Cloud Minimal | Docker (locale) | `rabbitmq:3-management` | $0 |
| Cloud Full | AWS MQ | `mq.t3.micro` | ~$17 |
| Cloud Full | CloudAMQP | Lemur (shared) | ~$19 |

**Recommendation**: Docker locale OK (behavior identical).

### Kafka

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker | `confluentinc/cp-kafka` | $0 |
| Cloud Full | AWS MSK | `kafka.t3.small` (2 brokers) | ~$100 |
| Cloud Full | Confluent Cloud | Basic | ~$145 |

**Recommendation**: Docker locale per dev, managed solo se servono features avanzate.

### MQTT

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | ❌ Mosquitto (NOT RECOMMENDED) | See warnings | $0 |
| Cloud Minimal | AWS IoT Core | 100 devices, 1M msg | ~$2 |
| Cloud Full | AWS IoT Core | 1000 devices, 10M msg | ~$8 |
| Cloud Full | GCP IoT Core | DEPRECATED | N/A |
| Cloud Full | Azure IoT Hub | Basic (8k msg/day) | ~$10 |

**⚠️ Mosquitto Warnings**:
- No device registry (manual management)
- No device shadows (state management)
- No fleet management
- No rules engine

**Recommendation**: **Always use cloud IoT Core** (even for dev). Features not replicable locally.

---

## Serverless

### Functions

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | SAM Local / LocalStack | N/A | $0 |
| Cloud Minimal | AWS Lambda | 1M requests, 128MB | ~$0.20 |
| Cloud Full | AWS Lambda | 10M requests, 512MB | ~$8 |
| Cloud Full | GCP Cloud Functions | 10M invocations | ~$4 |
| Cloud Full | Azure Functions | 10M executions | ~$2 |

**⚠️ Local Lambda Warnings**:
- No VPC support
- No layers locally
- Cold start differences

**Recommendation**: SAM Local OK per simple functions, cloud per VPC/layers.

### Queues

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | ElasticMQ / LocalStack | N/A | $0 |
| Cloud Minimal | AWS SQS | 1M requests | ~$0.40 |
| Cloud Full | AWS SQS FIFO | 1M requests | ~$0.50 |
| Cloud Full | GCP Pub/Sub | 1M messages | ~$0.40 |
| Cloud Full | Azure Queue | 1M operations | ~$0.40 |

**⚠️ LocalStack SQS Warnings**:
- FIFO queue deduplication differences
- Message delay behavior
- Dead-letter queue handling

**Recommendation**: LocalStack OK per basic queues, cloud per FIFO/DLQ.

---

## Container Orchestration

### Docker Compose

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Docker Desktop | N/A | $0 |

**Recommendation**: Always use Docker Compose locale per dev (fast, reproducible).

### Kubernetes

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | ❌ Minikube (NOT RECOMMENDED) | Too heavy | $0 |
| Local Dev | ✅ docker-compose | Lightweight | $0 |
| Cloud Full | AWS EKS | 1 cluster + 2 nodes (t3.medium) | ~$100 |
| Cloud Full | GCP GKE | 1 cluster + 2 nodes (e2-medium) | ~$75 |
| Cloud Full | Azure AKS | 1 cluster + 2 nodes (Standard_B2s) | ~$60 |

**Recommendation**: **Docker Compose per dev**, NOT Minikube (too heavy). K8s solo per prod se necessario.

---

## Authentication

### Self-managed JWT

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| All | Library (jsonwebtoken, jose) | N/A | $0 |

**Recommendation**: Self-managed JWT OK per MVP, managed auth per scale.

### Managed Auth

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Cloud Full | AWS Cognito | 50k MAU | ~$0 (Free Tier) |
| Cloud Full | Auth0 | 7k MAU | ~$23 |
| Cloud Full | Firebase Auth | Unlimited | $0 (pay per verification) |
| Cloud Full | Azure AD B2C | 50k MAU | ~$0 |

**Recommendation**: Cognito/Firebase per auth management, JWT self-managed per semplice.

---

## Monitoring & Logging

### Logging

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Console + file | Winston, Pino | $0 |
| Cloud Minimal | CloudWatch Logs | 5GB ingestion | ~$2.50 |
| Cloud Full | CloudWatch Logs | 50GB ingestion | ~$25 |
| Cloud Full | Datadog | 10GB/day | ~$15 |
| Cloud Full | LogDNA / Mezmo | 10GB | ~$30 |

### Metrics

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Local Dev | Prometheus (Docker) | N/A | $0 |
| Cloud Minimal | CloudWatch Metrics | 10 custom metrics | ~$3 |
| Cloud Full | CloudWatch Metrics | 100 custom metrics | ~$30 |
| Cloud Full | Datadog | 10 hosts | ~$15/host |

**Recommendation**: Console/file locale, CloudWatch Logs minimal per dev, Datadog per production.

---

## CI/CD

### GitHub Actions

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| Public Repos | GitHub Actions | Unlimited | $0 |
| Private Repos | GitHub Actions | 2000 min/month | $0 |
| Private Repos | GitHub Actions | 3000 min/month | ~$4 |

### GitLab CI

| Context | Solution | Spec | Cost (monthly) |
|---------|----------|------|----------------|
| GitLab.com | GitLab CI | 400 min/month | $0 |
| GitLab.com | GitLab CI | Unlimited | ~$29 (Premium) |

**Recommendation**: GitHub Actions (free tier generoso).

---

## Summary: Minimal vs Full Stack

### Minimal Stack (~$2-3/mese)

**Local (Docker)**:
- PostgreSQL
- Redis
- (Optional) RabbitMQ

**Cloud**:
- S3 bucket (~$0.50)
- IoT Core (~$2, se MQTT)

**Totale**: ~$2-3/mese

### Standard Stack (~$28/mese)

**Cloud**:
- RDS PostgreSQL db.t4g.micro (~$15, ~$0 Free Tier)
- ElastiCache Redis cache.t4g.micro (~$12)
- S3 + CloudFront (~$1)

**Totale**: ~$28/mese (~$13 con Free Tier primi 12 mesi)

### Production Stack (~$100+/mese)

**Cloud**:
- RDS PostgreSQL db.t4g.small (~$30)
- ElastiCache Redis cache.t3.medium (~$50)
- S3 + CloudFront (~$5)
- Load Balancer (~$18)
- CloudWatch (~$10)

**Totale**: ~$113/mese

---

## Mapping Decision Tree

```
Tech: PostgreSQL
  ├─ Local Dev? → Docker (postgres:15-alpine)
  ├─ Cloud Minimal? → Docker locale
  └─ Cloud Full? → RDS db.t4g.micro

Tech: Redis
  ├─ Local Dev? → Docker (redis:7-alpine)
  ├─ Cloud Minimal? → Docker locale
  └─ Cloud Full? → ElastiCache cache.t4g.micro

Tech: S3
  ├─ Local Dev? → ❌ NO MinIO → Use S3 dev bucket
  ├─ Cloud Minimal? → S3 bucket
  └─ Cloud Full? → S3 + CloudFront CDN

Tech: MQTT
  ├─ Local Dev? → ❌ NO Mosquitto → Use IoT Core dev
  ├─ Cloud Minimal? → IoT Core (dev environment)
  └─ Cloud Full? → IoT Core (prod environment)

Tech: RabbitMQ
  ├─ Local Dev? → ✅ Docker (rabbitmq:3-management)
  ├─ Cloud Minimal? → Docker locale
  └─ Cloud Full? → AWS MQ mq.t3.micro

Tech: Kubernetes
  ├─ Local Dev? → ❌ NO Minikube → Use docker-compose
  └─ Cloud Full? → EKS / GKE / AKS
```

---

## Validation Patterns

Use questa mapping table per validare scelte:

| Tech | Local Valid? | Reason |
|------|-------------|--------|
| PostgreSQL | ✅ YES | Same SQL, same interface |
| Redis | ✅ YES | Same commands |
| RabbitMQ | ✅ YES | Behavior identical |
| S3 (MinIO) | ❌ NO | Behavior differences (multipart, pre-signed) |
| IoT Core (Mosquitto) | ❌ NO | Features non-replicable (registry, shadows) |
| K8s (Minikube) | ⚠️ AVOID | Too heavy, use docker-compose |
| Lambda (SAM) | ⚠️ LIMITED | OK simple functions, not VPC/layers |
| SQS (ElasticMQ) | ⚠️ LIMITED | OK basic, not FIFO/DLQ |

**Rule**: Se comportamento cloud-specific (device registry, CDN, multipart upload), **always use cloud** (anche per dev).
