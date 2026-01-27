# Environment Setup Guide

## Prerequisites

- Docker & Docker Compose
- Node.js 20+ (for local development without Docker)

## Quick Start (Development)

```bash
# Copy environment file
cp .env.example .env

# Start services
docker-compose up -d

# Run migrations
npm run migrate:dev

# Start in development
npm run dev
```

## Environment Details

### Development
- Uses local Docker services
- Hot reload enabled
- Debug logging

### Staging
- Mirrors production setup
- Uses staging secrets manager
- Connected to staging DB

### Production
- All secrets from AWS Secrets Manager
- Minimum 2 replicas
- Warn-level logging only

## Secrets Management

### Development
Secrets in local `.env` file (gitignored)

### Staging/Production
Secrets managed via:
- AWS Secrets Manager
- Environment variables in ECS task definition

Never commit real credentials!
