# Environment Variables by Service Type

## Node.js/TypeScript Backend

### Core
- `NODE_ENV`: development | staging | production
- `PORT`: Server port (default 3000)
- `LOG_LEVEL`: debug | info | warn | error

### Database (PostgreSQL)
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `DATABASE_URL`: Full connection string

### Authentication
- `JWT_SECRET`: Secret key for JWT signing
- `JWT_EXPIRY`: Token expiration (e.g., 24h)
- `REFRESH_TOKEN_EXPIRY`: Refresh token expiration (e.g., 7d)

### Redis
- `REDIS_URL`: redis://host:port

### MQTT
- `MQTT_BROKER_URL`: mqtt://host:port
- `MQTT_USERNAME`, `MQTT_PASSWORD`

### Feature Flags
- `FEATURE_*`: Boolean flags for feature toggles

## Python/FastAPI Backend

### Core
- `ENV`: development | staging | production
- `PORT`: Server port
- `LOG_LEVEL`: DEBUG | INFO | WARNING | ERROR

### Database (PostgreSQL)
- `DATABASE_URL`: postgresql://user:pass@host:port/db

### Redis
- `REDIS_URL`: redis://host:port

## Default Values by Environment

| Variable | Development | Staging | Production |
|----------|-------------|---------|------------|
| LOG_LEVEL | debug | info | warn |
| JWT_EXPIRY | 24h | 24h | 12h |
| DB_HOST | localhost | staging-db.internal | <secrets-manager> |
