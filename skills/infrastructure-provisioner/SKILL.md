---
name: infrastructure-provisioner
description: Genera infrastruttura cloud personalizzata con approccio context-aware. Fa domande interattive su team structure, local dev, repo strategy, poi genera IaC (CloudFormation/Terraform) + setup scripts. Supporta minimal stack (~$2-3/mese) e full stack (~$28/mese) con upgrade path.
---

# Infrastructure Provisioner

## Il Tuo Compito

Generare setup infrastruttura completo e **personalizzato** basato su contesto progetto:
- Team structure (solo frontend? full-stack? team separati?)
- Sviluppo locale (quali servizi in locale vs cloud?)
- Repository strategy (mono-repo vs multi-repo?)
- Cloud provider & budget

**Output**:
- IaC templates (CloudFormation/Terraform)
- Setup scripts automatici (4-5 script bash)
- Docker compose per local dev
- Documentazione completa

**Approccio**: Dev-first - sviluppo veloce prima, produzione dopo.

**Prerequisito**: Tech Stack approvato (checkpoint `tech_stack_choice` completato).

---

## Materiali di Riferimento

**Templates**:
- `templates/cloudformation-minimal.yml` - Template minimal stack (~$2-3/mese)
- `templates/cloudformation-full.yml` - Template full stack (~$28/mese)
- `templates/setup-scripts/` - Template 4-5 script bash

**Reference**:
- `reference/service-mapping.md` - Mappa tech stack → cloud services
- `reference/cost-estimation.md` - Stima costi per stack
- `reference/qrpay-pattern.md` - Esempio QRPay setup come best practice
- `reference/validation-patterns.md` - Validazione workaround locale

---

## Workflow: 7 Fasi con Context Discovery

```
Fase 1: Context Discovery         → Domande interattive (team, local dev, repo)
Fase 2: Analyze Tech Stack        → Mappa tech → cloud services
Fase 3: Design Local Dev Strategy → Valida workaround, proponi setup locale
Fase 4: Generate Minimal Stack    → IaC + scripts per ~$2-3/mese
Fase 5: Generate Full Stack       → IaC + scripts per ~$28/mese (opzionale)
Fase 6: Draft + Testing           → Test syntax IaC, valida scripts
        >>> CHECKPOINT: INFRASTRUCTURE_PLAN <<<
Fase 7: Finalization              → Scrivi templates + scripts + docs
```

---

## Fase 1: Context Discovery (NUOVO - Context-Aware)

### Obiettivo
Capire contesto progetto tramite domande interattive per personalizzare infrastruttura.

**Consulta `reference/context-discovery-questions.md` per domande complete.**

### Azioni

**Usa AskUserQuestion per 4 aree**:

#### 1. Team Structure

```
Domanda: "Qual è la struttura del tuo team di sviluppo?"

Opzioni:
- Solo frontend (backend esistente/esterno)
- Full-stack su singola macchina (un dev fa tutto)
- Team separati (frontend team + backend team)
- Altro (specifica)

Impatto:
- Solo frontend → Backend stub/mock + docker-compose? O backend esterno?
- Full-stack → Docker locale per DB/cache, cloud per servizi specifici
- Team separati → Environments indipendenti, backend usa staging
```

#### 2. Sviluppo Locale

```
Domanda: "Quali servizi vuoi eseguire in locale durante sviluppo?"

Opzioni (multi-select):
- Database (PostgreSQL, MySQL, MongoDB)
- Cache (Redis, Memcached)
- Message broker (RabbitMQ, Kafka)
- Storage (S3-like, MinIO)
- Altro (specifica)

Follow-up: "Perché preferisci [servizio] in locale vs cloud?"

Validazione:
- PostgreSQL locale → ✅ (stessa interfaccia prod, veloce)
- Redis locale → ✅ (comportamento identico)
- S3 locale (MinIO) → ⚠️ "Comportamento identico a S3? Se no, usa dev cloud"
- IoT Core locale → ❌ "Non replicabile, usa dev environment cloud"
```

#### 3. Repository Strategy

```
Domanda: "Come organizzi i repository?"

Opzioni:
- Mono-repo (frontend + backend insieme)
- Multi-repo (repository separati per frontend/backend)
- Altro (specifica)

Impatto:
- Mono-repo → docker-compose unico, .env shared, script setup root
- Multi-repo → docker-compose per repo, .env separati, script setup indipendenti
```

#### 4. Cloud Provider & Budget

```
Domanda: "Quale cloud provider e budget mensile?"

Opzioni cloud:
- AWS
- GCP
- Azure
- Altro

Budget (approssimativo):
- Minimal (~$2-5/mese, solo essenziali cloud + Docker locale)
- Standard (~$20-30/mese, managed services small)
- Production (~$100+/mese, HA, scaling)

Free Tier disponibile? (primi 12 mesi AWS/GCP)
- Sì → Riduce costi ~50% primi 12 mesi
- No → Stima costi full
```

### Output Fase 1

Salva context in struttura:

```yaml
# infrastructure-context.yaml
team:
  structure: "full-stack"
  size: 1

local_dev:
  services:
    - database: postgresql
    - cache: redis
  reasoning: "Fast iteration, same interface as production"

repository:
  strategy: "mono-repo"
  structure: "project/frontend + project/backend"

cloud:
  provider: "aws"
  budget: "minimal"  # minimal | standard | production
  free_tier: true
```

---

## Fase 2: Analyze Tech Stack

### Obiettivo
Mappare tecnologie da `tech-stack.md` a servizi cloud.

**Consulta `reference/service-mapping.md` per mapping completo.**

### Azioni

1. **Leggi tech-stack.md**:
   ```
   Backend: Node.js 20 + Fastify
   Database: PostgreSQL 15
   Cache: Redis 7
   Storage: S3-compatible
   Message Broker: MQTT (AWS IoT Core)
   ```

2. **Mappa a cloud services** (basato su provider):

   | Tech | Locale (Docker) | AWS Managed | GCP Managed | Azure Managed |
   |------|----------------|-------------|-------------|---------------|
   | PostgreSQL | postgres:15 | RDS PostgreSQL | Cloud SQL | Azure Database |
   | Redis | redis:7-alpine | ElastiCache | Memorystore | Azure Cache |
   | S3 | MinIO (⚠️) | S3 | Cloud Storage | Blob Storage |
   | MQTT | Mosquitto (⚠️) | IoT Core | IoT Core | IoT Hub |

3. **Cross-reference con Context** (Fase 1):
   - Se `local_dev.services` include "database" → Docker postgres
   - Se `cloud.budget == "minimal"` → S3 + IoT Core managed, DB/Redis locale
   - Se `cloud.budget == "standard"` → RDS + ElastiCache managed

4. **Validazione workaround** (consulta `reference/validation-patterns.md`):
   - PostgreSQL locale → ✅ VALID (same SQL, same interface)
   - Redis locale → ✅ VALID (same commands)
   - S3 locale (MinIO) → ⚠️ ASK "MinIO ha comportamento identico a S3? Se no, usa S3 dev bucket"
   - MQTT locale (Mosquitto) → ❌ INVALID "IoT Core ha features specifiche (device registry, shadows), usa dev environment cloud"

### Output Fase 2

```yaml
# service-mapping.yaml
services:
  database:
    tech: PostgreSQL 15
    local: docker (postgres:15-alpine)
    cloud_minimal: docker (locale)
    cloud_full: RDS (db.t4g.micro)
    reason: "Fast local dev, RDS for production"

  cache:
    tech: Redis 7
    local: docker (redis:7-alpine)
    cloud_minimal: docker (locale)
    cloud_full: ElastiCache (cache.t4g.micro)

  storage:
    tech: S3
    local: N/A (workaround non valido)
    cloud_minimal: S3 bucket (dev)
    cloud_full: S3 bucket (prod) + CloudFront CDN
    reason: "S3 locale (MinIO) non comportamento identico, usa cloud"

  iot:
    tech: MQTT (AWS IoT Core)
    local: N/A (non replicabile)
    cloud_minimal: IoT Core (dev environment)
    cloud_full: IoT Core (prod environment)
    reason: "Device registry + shadows non replicabili localmente"
```

---

## Fase 3: Design Local Dev Strategy

### Obiettivo
Progettare strategia sviluppo locale personalizzata basando su team structure e service mapping.

**Consulta `reference/local-dev-patterns.md` per pattern comuni.**

### Azioni

#### 3a. Valida Scelte Locale vs Cloud

Per ogni servizio da `service-mapping.yaml`:

**VALID** (locale OK):
- ✅ PostgreSQL, MySQL, MongoDB → Same interface, fast iteration
- ✅ Redis, Memcached → Same commands
- ✅ RabbitMQ, Kafka → Replicabili (se non servono features cloud-specific)

**INVALID** (locale sconsigliato):
- ❌ S3 (MinIO) → Behavior differences (multipart upload, pre-signed URLs)
- ❌ IoT Core / IoT Hub → Device registry, shadows, fleet management non replicabili
- ❌ Managed K8s → Troppo pesante per locale, usa docker-compose

**ASK USER** (dipende da use case):
- ⚠️ DynamoDB locale → Emulator OK se no global tables / streams
- ⚠️ Lambda locale → SAM/LocalStack OK se no VPC / layers
- ⚠️ SQS/SNS locale → ElasticMQ/LocalStack OK se no FIFO / message deduplication

#### 3b. Design Setup per Team Structure

**Solo Frontend** (backend esistente):
```yaml
local_services:
  - Mock API server (MSW, Prism)
  - Browser dev tools
  - Hot reload (Vite, webpack-dev-server)

cloud_services:
  - Backend staging environment (URL config)
  - Auth provider (staging)
```

**Full-Stack** (un dev):
```yaml
local_services:
  - Database (Docker)
  - Cache (Docker)
  - Backend (npm run dev)
  - Frontend (npm run dev)

cloud_services:
  - Storage (S3 dev bucket)
  - IoT Core (dev environment)
  - External APIs (staging)
```

**Team Separati** (frontend + backend team):
```yaml
frontend_team:
  local_services:
    - Mock API (contract tests)
  cloud_services:
    - Backend staging environment

backend_team:
  local_services:
    - Database (Docker)
    - Cache (Docker)
    - Backend (npm run dev)
  cloud_services:
    - Storage (S3 dev bucket)
    - IoT Core (dev environment)
```

#### 3c. Repository Strategy Impact

**Mono-repo**:
```
project/
├── docker-compose.yml           # Unified, DB + cache + services
├── .env.example                 # Shared env vars
├── frontend/
│   └── .env.local (overrides)
├── backend/
│   └── .env.local (overrides)
└── setup-scripts/               # Root level
    ├── 01-configure-aws-cli.sh
    └── 04-setup-local-dev.sh    # Start tutto
```

**Multi-repo**:
```
project-frontend/
├── .env.example
└── docker-compose.yml (se serve frontend-specific services)

project-backend/
├── docker-compose.yml           # DB + cache + backend services
├── .env.example
└── setup-scripts/
    ├── 01-configure-aws-cli.sh
    └── 04-setup-local-dev.sh
```

### Output Fase 3

```yaml
# local-dev-strategy.yaml
approach: "dev-first"  # Priorità sviluppo veloce

services_local:
  - name: postgresql
    tech: postgres:15-alpine
    port: 5432
    reason: "Fast iteration, same SQL"

  - name: redis
    tech: redis:7-alpine
    port: 6379
    reason: "Same commands, instant startup"

services_cloud_dev:
  - name: s3
    service: S3
    reason: "Behavior differences con MinIO"

  - name: iot-core
    service: AWS IoT Core
    reason: "Device registry non replicabile"

docker_compose:
  location: "root"  # mono-repo
  services:
    - postgresql
    - redis
  networks:
    - app-network

setup_scripts:
  location: "setup-scripts/"
  count: 4
  scripts:
    - 01-configure-aws-cli.sh
    - 02-activate-cost-tags.sh
    - 03-deploy-dev-stack.sh
    - 04-setup-local-dev.sh
```

---

## Fase 4: Generate Minimal Stack

### Obiettivo
Generare IaC + setup scripts per **minimal stack** (~$2-3/mese).

**Minimal stack** = Solo servizi cloud essenziali, resto su Docker locale.

**Consulta `templates/cloudformation-minimal.yml` per template base.**

### Azioni

#### 4a. Generate CloudFormation/Terraform

**Parametri da context**:
- Cloud provider: AWS | GCP | Azure
- Services cloud: Da `service-mapping.yaml` → cloud_minimal
- Budget target: ~$2-3/mese

**AWS Minimal Stack** (esempio):
```yaml
# infrastructure/cloudformation/minimal-stack.yml
Resources:
  # S3 bucket per storage (no CloudFront in minimal)
  AppBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub "${ProjectName}-dev-storage"
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true

  # IoT Policy per devices (se MQTT nel tech stack)
  DevicePolicy:
    Type: AWS::IoT::Policy
    Properties:
      PolicyName: !Sub "${ProjectName}-device-policy"
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action: ["iot:Connect", "iot:Publish", "iot:Subscribe"]
            Resource: "*"

  # Cost allocation tags
  Tags:
    - Key: Project
      Value: !Ref ProjectName
    - Key: Environment
      Value: dev
    - Key: CostCenter
      Value: minimal-stack

Outputs:
  BucketName:
    Value: !Ref AppBucket
    Export:
      Name: !Sub "${ProjectName}-bucket-name"

  IoTEndpoint:
    Value: !GetAtt IoTCoreEndpoint.EndpointAddress
```

**Costo stimato**:
- S3: ~$0.50/mese (5GB storage + 10k requests)
- IoT Core: ~$1-2/mese (100 devices, 1M messages)
- **Totale: ~$2-3/mese**

#### 4b. Generate Setup Scripts

**Script 1: Configure AWS CLI** (`01-configure-aws-cli.sh`):
```bash
#!/bin/bash
set -e

echo "=== AWS CLI Configuration ==="

# Check if AWS CLI installed
if ! command -v aws &> /dev/null; then
  echo "AWS CLI not installed. Install: https://aws.amazon.com/cli/"
  exit 1
fi

# Configure profile
aws configure --profile ${PROJECT_NAME}-dev

echo "✅ AWS CLI configured"
```

**Script 2: Activate Cost Tags** (`02-activate-cost-tags.sh`):
```bash
#!/bin/bash
set -e

echo "=== Activating Cost Allocation Tags ==="

aws ce update-cost-allocation-tags-status \
  --cost-allocation-tags-status \
    TagKey=Project,Status=Active \
    TagKey=Environment,Status=Active \
    TagKey=CostCenter,Status=Active \
  --profile ${PROJECT_NAME}-dev

echo "✅ Cost tags activated (visible in 24h)"
```

**Script 3: Deploy Dev Stack** (`03-deploy-dev-stack.sh`):
```bash
#!/bin/bash
set -e

STACK_NAME="${PROJECT_NAME}-dev-minimal"
TEMPLATE_FILE="infrastructure/cloudformation/minimal-stack.yml"

echo "=== Deploying Minimal Stack ==="
echo "Stack: $STACK_NAME"
echo "Template: $TEMPLATE_FILE"
echo ""

# Deploy stack
aws cloudformation deploy \
  --template-file $TEMPLATE_FILE \
  --stack-name $STACK_NAME \
  --parameter-overrides ProjectName=${PROJECT_NAME} \
  --capabilities CAPABILITY_IAM \
  --profile ${PROJECT_NAME}-dev \
  --region ${AWS_REGION:-us-east-1}

# Get outputs
aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs' \
  --profile ${PROJECT_NAME}-dev

echo ""
echo "✅ Minimal stack deployed (~$2-3/mese)"
echo "Duration: ~5-10 minutes"
```

**Script 4: Setup Local Dev** (`04-setup-local-dev.sh`):
```bash
#!/bin/bash
set -e

echo "=== Setting Up Local Development ==="

# Start Docker services
echo "Starting Docker services..."
docker-compose up -d

# Wait for PostgreSQL
echo "Waiting for PostgreSQL..."
until docker-compose exec -T postgres pg_isready; do
  sleep 1
done

# Run migrations (se backend presente)
if [ -d "backend" ]; then
  echo "Running database migrations..."
  cd backend
  npm run migrate
  cd ..
fi

# Seed test data (se script presente)
if [ -f "backend/prisma/seed.ts" ]; then
  echo "Seeding test data..."
  cd backend
  npm run seed
  cd ..
fi

echo ""
echo "✅ Local dev environment ready"
echo ""
echo "Services running:"
echo "- PostgreSQL: localhost:5432"
echo "- Redis: localhost:6379"
echo ""
echo "Start backend: cd backend && npm run dev"
echo "Start frontend: cd frontend && npm run dev"
```

#### 4c. Generate docker-compose.yml

```yaml
# docker-compose.yml (Mono-repo)
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: ${PROJECT_NAME:-app}-postgres
    environment:
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
      POSTGRES_DB: ${DB_NAME:-appdb}
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: ${PROJECT_NAME:-app}-redis
    ports:
      - "6379:6379"
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

volumes:
  postgres-data:

networks:
  app-network:
    driver: bridge
```

#### 4d. Generate .env.example

```bash
# .env.example
# Database (Docker local)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=appdb
DB_USER=postgres
DB_PASSWORD=postgres
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/appdb

# Redis (Docker local)
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_URL=redis://localhost:6379

# AWS (Minimal stack - cloud services)
AWS_REGION=us-east-1
AWS_PROFILE=${PROJECT_NAME}-dev

# S3 Storage
S3_BUCKET=${PROJECT_NAME}-dev-storage
S3_REGION=us-east-1

# IoT Core (se MQTT nel tech stack)
IOT_ENDPOINT=<get-from-stack-output>
IOT_TOPIC_PREFIX=${PROJECT_NAME}/dev

# Backend
NODE_ENV=development
PORT=3000
API_BASE_URL=http://localhost:3000
LOG_LEVEL=debug

# Frontend
VITE_API_URL=http://localhost:3000
VITE_APP_ENV=development
```

### Output Fase 4

```
infrastructure/
├── cloudformation/
│   └── minimal-stack.yml        # ~$2-3/mese
├── terraform/                   # (se Terraform scelto)
│   └── minimal/
│       ├── main.tf
│       └── variables.tf
setup-scripts/
├── 01-configure-aws-cli.sh
├── 02-activate-cost-tags.sh
├── 03-deploy-dev-stack.sh
└── 04-setup-local-dev.sh
docker-compose.yml
.env.example
```

---

## Fase 5: Generate Full Stack (Opzionale)

### Obiettivo
Generare IaC + scripts per **full stack** (~$28/mese con managed services).

**Full stack** = RDS, ElastiCache, S3 + CloudFront, etc.

**Consulta `templates/cloudformation-full.yml` per template base.**

### Azioni

#### 5a. Generate CloudFormation Full

```yaml
# infrastructure/cloudformation/full-stack.yml
Resources:
  # VPC
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true

  # RDS PostgreSQL
  DBInstance:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceIdentifier: !Sub "${ProjectName}-db"
      Engine: postgres
      EngineVersion: "15.4"
      DBInstanceClass: db.t4g.micro
      AllocatedStorage: 20
      MasterUsername: !Ref DBUser
      MasterUserPassword: !Ref DBPassword
      VPCSecurityGroups:
        - !Ref DBSecurityGroup
      PubliclyAccessible: false

  # ElastiCache Redis
  CacheCluster:
    Type: AWS::ElastiCache::CacheCluster
    Properties:
      CacheNodeType: cache.t4g.micro
      Engine: redis
      NumCacheNodes: 1

  # S3 + CloudFront CDN
  AppBucket:
    Type: AWS::S3::Bucket

  CloudFrontDistribution:
    Type: AWS::CloudFront::Distribution
    Properties:
      DistributionConfig:
        Origins:
          - DomainName: !GetAtt AppBucket.DomainName
            Id: S3Origin
            S3OriginConfig:
              OriginAccessIdentity: !Sub "origin-access-identity/cloudfront/${CloudFrontOAI}"

Outputs:
  RDSEndpoint:
    Value: !GetAtt DBInstance.Endpoint.Address

  RedisEndpoint:
    Value: !GetAtt CacheCluster.RedisEndpoint.Address

  CDNDomain:
    Value: !GetAtt CloudFrontDistribution.DomainName
```

**Costo stimato**:
- RDS db.t4g.micro: ~$15/mese (con Free Tier ~$0 primi 12 mesi)
- ElastiCache cache.t4g.micro: ~$12/mese
- S3 + CloudFront: ~$1/mese
- **Totale: ~$28/mese (o ~$13/mese con Free Tier)**

#### 5b. Update Setup Scripts

Modifica `03-deploy-dev-stack.sh` per supportare `--full` flag:

```bash
#!/bin/bash
set -e

# Parse arguments
MODE="minimal"
while [[ $# -gt 0 ]]; do
  case $1 in
    --full)
      MODE="full"
      shift
      ;;
    --minimal)
      MODE="minimal"
      shift
      ;;
  esac
done

STACK_NAME="${PROJECT_NAME}-dev-${MODE}"
TEMPLATE_FILE="infrastructure/cloudformation/${MODE}-stack.yml"

echo "=== Deploying ${MODE} Stack ==="

# Deploy
aws cloudformation deploy \
  --template-file $TEMPLATE_FILE \
  --stack-name $STACK_NAME \
  --profile ${PROJECT_NAME}-dev

if [ "$MODE" = "minimal" ]; then
  echo "✅ Minimal stack deployed (~$2-3/mese)"
else
  echo "✅ Full stack deployed (~$28/mese, ~$13 con Free Tier)"
fi
```

### Output Fase 5

```
infrastructure/
├── cloudformation/
│   ├── minimal-stack.yml        # ~$2-3/mese
│   └── full-stack.yml           # ~$28/mese (NUOVO)
setup-scripts/
├── 03-deploy-dev-stack.sh       # Supporta --minimal | --full
└── ...
```

---

## Fase 6: Draft + Testing

### Obiettivo
Validare IaC syntax e testare scripts logic.

### Azioni

#### 6a. Validate IaC Syntax

**CloudFormation**:
```bash
aws cloudformation validate-template \
  --template-body file://infrastructure/cloudformation/minimal-stack.yml
```

**Terraform**:
```bash
cd infrastructure/terraform/minimal
terraform init
terraform validate
```

#### 6b. Test Scripts (Dry-run)

```bash
# Test AWS CLI configured
aws sts get-caller-identity --profile ${PROJECT_NAME}-dev

# Test Docker
docker-compose config

# Test script syntax
shellcheck setup-scripts/*.sh
```

#### 6c. Generate Documentation

```markdown
# docs/infrastructure-setup.md

## Quick Start

1. Prerequisites:
   - AWS CLI installed
   - Docker Desktop running
   - Node.js 20+ (per backend)

2. Setup (15-20 minuti):
   ```bash
   cd setup-scripts
   ./01-configure-aws-cli.sh       # 2 min
   ./02-activate-cost-tags.sh      # 1 min
   ./03-deploy-dev-stack.sh        # 5-10 min (--minimal default)
   ./04-setup-local-dev.sh         # 5 min
   ```

3. Development:
   ```bash
   # Backend
   cd backend && npm run dev

   # Frontend
   cd frontend && npm run dev
   ```

## Upgrade to Full Stack

Quando pronto per managed services:

```bash
./03-deploy-dev-stack.sh --full  # ~15 min
```

Costo: ~$28/mese (~$13 con Free Tier)

## Cost Tracking

Costi tracciabili in AWS Cost Explorer con tag:
- Project: ${PROJECT_NAME}
- Environment: dev
- CostCenter: minimal-stack | full-stack
```

### CHECKPOINT: INFRASTRUCTURE_PLAN

Presenta all'utente:

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: INFRASTRUCTURE_PLAN <<<
═══════════════════════════════════════════════════════════════

## Context

Team: Full-stack (1 developer)
Local Dev: PostgreSQL + Redis (Docker)
Cloud Dev: S3 + IoT Core (AWS)
Repository: Mono-repo

## Infrastructure Plan

### Minimal Stack (~$2-3/mese)
- S3 bucket (storage)
- IoT Core policy (MQTT devices)
- PostgreSQL locale (Docker)
- Redis locale (Docker)

### Full Stack (~$28/mese, optional)
- RDS PostgreSQL db.t4g.micro
- ElastiCache Redis cache.t4g.micro
- S3 + CloudFront CDN

## Generated Files

- infrastructure/cloudformation/minimal-stack.yml
- infrastructure/cloudformation/full-stack.yml
- setup-scripts/ (4 script)
- docker-compose.yml
- .env.example
- docs/infrastructure-setup.md

## Setup Time

- Minimal: ~15 min (4 script sequenziali)
- Full: ~30 min (+ RDS provisioning)

═══════════════════════════════════════════════════════════════
Approvi? [S]ì / [N]o / [M]odifica
═══════════════════════════════════════════════════════════════
```

Gestisci risposta:
- **Approva** → Fase 7 (Finalization)
- **Modifica** → Rileggi feedback, riapplica Fase 4-5, ripresenta
- **No** → STOP completo

---

## Fase 7: Finalization

### Obiettivo
Scrivere tutti i file generati.

### Azioni

1. **Scrivi IaC templates**:
   - `infrastructure/cloudformation/minimal-stack.yml`
   - `infrastructure/cloudformation/full-stack.yml`

2. **Scrivi setup scripts**:
   - `setup-scripts/01-configure-aws-cli.sh`
   - `setup-scripts/02-activate-cost-tags.sh`
   - `setup-scripts/03-deploy-dev-stack.sh`
   - `setup-scripts/04-setup-local-dev.sh`
   - `setup-scripts/SETUP.md` (guida completa)

3. **Scrivi docker-compose.yml**

4. **Scrivi .env.example**

5. **Scrivi documentazione**:
   - `docs/infrastructure-setup.md`

6. **Update progress.yaml**:
   ```yaml
   checkpoints_completed:
     - name: infrastructure_plan
       approved_at: "2026-01-30T10:00:00"
       approved_by: user
       files_generated:
         - infrastructure/cloudformation/minimal-stack.yml
         - infrastructure/cloudformation/full-stack.yml
         - setup-scripts/ (4 script)
         - docker-compose.yml
   ```

7. **Comunica completamento**:
   ```
   ✅ Infrastructure setup completato

   Generated:
   - CloudFormation templates (minimal + full)
   - 4 setup scripts (automatici)
   - docker-compose.yml (PostgreSQL + Redis)
   - .env.example
   - Docs: docs/infrastructure-setup.md

   Next steps:
   1. Run setup-scripts/01-configure-aws-cli.sh
   2. Run setup-scripts/03-deploy-dev-stack.sh (minimal)
   3. Run setup-scripts/04-setup-local-dev.sh
   4. Start development!

   Upgrade to full stack when ready: ./03-deploy-dev-stack.sh --full
   ```

---

## Regole Tool

- ✅ Read tech-stack.md prima di iniziare
- ✅ AskUserQuestion per context discovery (Fase 1)
- ✅ Write per templates e scripts
- ✅ AskUserQuestion per checkpoint
- ❌ **MAI** saltare context discovery (critico per personalizzazione)
- ❌ **MAI** procedere senza validare workaround locale

---

## Gestione Errori

### Tech Stack Mancante
```
ERROR: Tech stack not found

Prerequisito mancante: docs/architecture/tech-stack.md

Run /architecture-designer prima di /infrastructure-provisioner
```

### Workaround Locale Invalido
```
WARNING: S3 locale (MinIO) sconsigliato

MinIO non ha comportamento identico a S3:
- Multipart upload differences
- Pre-signed URL differences

Raccomandazione: Usa S3 dev bucket (costo ~$0.50/mese)

Procedi con MinIO? [S]ì (rischio) / [N]o (usa S3)
```

### CloudFormation Syntax Error
```
ERROR: CloudFormation template validation failed

Template: infrastructure/cloudformation/minimal-stack.yml
Error: Property ValidationError at line 42

Fix automatico applicato. Re-validating...
```

---

## Principi

- **Context-aware**: Domande interattive per personalizzare
- **Dev-first**: Priorità sviluppo veloce, produzione dopo
- **Validate workaround**: No S3/IoT locale se comportamento diverso
- **Minimal → Full**: Upgrade path chiaro
- **Cost-conscious**: Costi espliciti, Free Tier leveraged
- **Automated**: Script automatici, zero manual AWS console

---

## Avvio Workflow

1. Verifica prerequisito (tech-stack.md)
2. Fase 1: Context discovery (domande interattive)
3. Fase 2-3: Analyze e design
4. Fase 4-5: Generate minimal + full
5. Fase 6: Draft + testing → **CHECKPOINT**
6. Fase 7: Finalization

**Principio**: Setup infrastruttura personalizzato per contesto, non one-size-fits-all.
