# ============================================
# ENVIRONMENT CONFIGURATION
# ============================================
# Copy this file to .env and fill in values
# NEVER commit .env with real values!
# ============================================

# Application
NODE_ENV=development
PORT=3000
LOG_LEVEL=debug

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp_dev
DB_USER=postgres
DB_PASSWORD=<your-password>
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

# Authentication
JWT_SECRET=<generate-with-openssl-rand-base64-32>
JWT_EXPIRY=24h
REFRESH_TOKEN_EXPIRY=7d

# Redis (if used)
REDIS_URL=redis://localhost:6379

# MQTT (if used)
MQTT_BROKER_URL=mqtt://localhost:1883
MQTT_USERNAME=
MQTT_PASSWORD=

# External Services
# API_KEY_SERVICE_X=<your-api-key>

# Feature Flags
FEATURE_NEW_UI=false
