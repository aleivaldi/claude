# Environments Configuration

## Ambienti Standard

| Ambiente | Scopo | Dati | Debug |
|----------|-------|------|-------|
| `development` | Sviluppo locale | Mock/seed | ON |
| `staging` | Test pre-produzione | Copy prod (anonimizzati) | ON |
| `production` | Produzione | Reali | OFF |

## File Structure

```
project/
├── environments/
│   ├── .env.development      # Locale
│   ├── .env.staging          # Staging
│   └── .env.production.example  # Template (no secrets!)
├── .env                      # Gitignored - override locale
└── .gitignore               # Include .env
```

## Naming Convention

```bash
# Formato variabile
PREFISSO_NOME_VARIABILE=valore

# Prefissi comuni
APP_*        # Configurazione app
API_*        # Endpoint API
DB_*         # Database
AUTH_*       # Autenticazione
MQTT_*       # Message broker
AWS_*        # Cloud provider
```

## Variabili Obbligatorie per Tipo

### Backend Node.js

```bash
# Base
NODE_ENV=development|staging|production
PORT=3000
LOG_LEVEL=debug|info|warn|error

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USER=user
DB_PASSWORD=secret  # Solo in .env locale!

# Auth
JWT_SECRET=xxx      # Solo in .env locale!
JWT_EXPIRY=24h

# API
API_BASE_URL=http://localhost:3000
CORS_ORIGINS=http://localhost:3000,http://localhost:8080
```

### Frontend/Mobile

```bash
# Base
APP_ENV=development|staging|production
APP_DEBUG=true|false

# API
API_BASE_URL=http://localhost:3000
API_TIMEOUT=30000

# Feature Flags
FEATURE_NEW_UI=true|false
```

### Flutter Specifico

```dart
// Usa --dart-define per build-time config
// flutter run --dart-define=API_URL=http://localhost:3000

const String apiUrl = String.fromEnvironment('API_URL');
```

## Secrets Management

### Cosa NON va in Git

- Password, API keys, tokens
- Certificati e chiavi private
- Dati personali
- Qualsiasi credential

### Pattern Sicuro

```bash
# .env.production.example (in git)
DB_PASSWORD=<set-in-vault>
JWT_SECRET=<set-in-vault>
API_KEY=<set-in-vault>

# .env.production (NON in git, in secret manager)
DB_PASSWORD=actual-secret-password
JWT_SECRET=actual-jwt-secret
API_KEY=actual-api-key
```

### Secret Managers Consigliati

- **Development**: File .env locale (gitignored)
- **Staging/Prod**:
  - AWS Secrets Manager
  - HashiCorp Vault
  - Google Secret Manager
  - Environment variables CI/CD

## Validazione Ambiente

### Startup Check

```javascript
// config/env.js
const required = ['DB_HOST', 'DB_PASSWORD', 'JWT_SECRET'];

for (const key of required) {
  if (!process.env[key]) {
    throw new Error(`Missing required env var: ${key}`);
  }
}
```

### Schema Validation

```javascript
// Usando zod o joi
const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'staging', 'production']),
  PORT: z.string().transform(Number),
  DB_HOST: z.string().min(1),
  // ...
});

const env = envSchema.parse(process.env);
```

## Docker Environments

```yaml
# docker-compose.yml
services:
  api:
    env_file:
      - ./environments/.env.development
    environment:
      - NODE_ENV=development
```

```yaml
# docker-compose.staging.yml
services:
  api:
    env_file:
      - ./environments/.env.staging
    environment:
      - NODE_ENV=staging
```

## CI/CD Integration

### GitHub Actions

```yaml
jobs:
  deploy-staging:
    env:
      NODE_ENV: staging
    steps:
      - name: Deploy
        env:
          DB_PASSWORD: ${{ secrets.STAGING_DB_PASSWORD }}
          JWT_SECRET: ${{ secrets.STAGING_JWT_SECRET }}
```

## Environment Switching

### Script Consigliato

```bash
#!/bin/bash
# scripts/use-env.sh

ENV=${1:-development}
cp "environments/.env.${ENV}" .env
echo "Switched to ${ENV} environment"
```

### Package.json Scripts

```json
{
  "scripts": {
    "dev": "NODE_ENV=development node src/index.js",
    "staging": "NODE_ENV=staging node src/index.js",
    "start": "NODE_ENV=production node src/index.js"
  }
}
```
