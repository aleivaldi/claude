#!/bin/bash
# ============================================================================
# Environment Verification for E2E/Smoke Tests
# ============================================================================
# Verifica che l'ambiente sia pronto per eseguire test integration/E2E
# Da invocare in /develop Fase 4.5 PRIMA di eseguire test
#
# Exit codes:
#   0 = All checks passed
#   1 = Critical failure (stop execution)
#   2 = Warning (can proceed but with caution)

set -e

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funzioni helper
print_header() {
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}  $1${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

# Track failures
CRITICAL_FAILURES=0
WARNINGS=0

# ============================================================================
# 1. Backend Health Check
# ============================================================================
print_header "1. Backend Health Check"

# Determina backend URL (da config o default)
BACKEND_URL=${BACKEND_URL:-"http://localhost:3000"}
HEALTH_ENDPOINT="${BACKEND_URL}/health"

print_info "Checking backend at: ${HEALTH_ENDPOINT}"

if curl -s -f -m 5 "${HEALTH_ENDPOINT}" > /dev/null 2>&1; then
  print_success "Backend is UP and responding"
else
  print_error "Backend is DOWN or not responding"
  print_info "Expected: ${HEALTH_ENDPOINT}"
  print_info "Action: Start backend with 'npm run dev' or 'docker-compose up'"
  CRITICAL_FAILURES=$((CRITICAL_FAILURES + 1))
fi

# ============================================================================
# 2. Database Connection Check
# ============================================================================
print_header "2. Database Connection Check"

# Se DATABASE_URL è definito, tenta connessione
if [ -n "$DATABASE_URL" ]; then
  print_info "Database URL configured: ${DATABASE_URL%%@*}@***"

  # PostgreSQL check (se URL contiene postgres://)
  if [[ "$DATABASE_URL" == postgres* ]]; then
    if command -v psql &> /dev/null; then
      if psql "$DATABASE_URL" -c "SELECT 1" > /dev/null 2>&1; then
        print_success "PostgreSQL connection OK"
      else
        print_error "Cannot connect to PostgreSQL"
        CRITICAL_FAILURES=$((CRITICAL_FAILURES + 1))
      fi
    else
      print_warning "psql not installed, skipping direct DB check"
      WARNINGS=$((WARNINGS + 1))
    fi
  fi

  # MySQL check (se URL contiene mysql://)
  if [[ "$DATABASE_URL" == mysql* ]]; then
    if command -v mysql &> /dev/null; then
      # Parse URL per estrarre credenziali (basic parsing)
      if mysql -e "SELECT 1" > /dev/null 2>&1; then
        print_success "MySQL connection OK"
      else
        print_error "Cannot connect to MySQL"
        CRITICAL_FAILURES=$((CRITICAL_FAILURES + 1))
      fi
    else
      print_warning "mysql not installed, skipping direct DB check"
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
else
  print_warning "DATABASE_URL not set, skipping database check"
  print_info "If your app requires DB, ensure it's configured"
  WARNINGS=$((WARNINGS + 1))
fi

# ============================================================================
# 3. Test Data Seeding (Optional but Recommended)
# ============================================================================
print_header "3. Test Data Seeding"

# Controlla se esiste script seed per test
SEED_SCRIPT=""

# Check common locations
if [ -f "package.json" ]; then
  # Node.js project
  if grep -q '"db:seed:test"' package.json; then
    SEED_SCRIPT="npm run db:seed:test"
  elif grep -q '"seed:test"' package.json; then
    SEED_SCRIPT="npm run seed:test"
  fi
fi

if [ -n "$SEED_SCRIPT" ]; then
  print_info "Running seed script: ${SEED_SCRIPT}"

  if eval "$SEED_SCRIPT" > /dev/null 2>&1; then
    print_success "Test data seeded successfully"
  else
    print_warning "Seed script failed or returned non-zero"
    print_info "Tests may fail if they expect seeded data"
    WARNINGS=$((WARNINGS + 1))
  fi
else
  print_info "No seed script found (checked: db:seed:test, seed:test)"
  print_info "If tests require specific data, seed manually first"
fi

# ============================================================================
# 4. Frontend/App Running (for E2E tests)
# ============================================================================
print_header "4. Frontend/App Check"

# Se test E2E, verifica che frontend sia up
FRONTEND_URL=${FRONTEND_URL:-"http://localhost:8080"}

print_info "Checking frontend at: ${FRONTEND_URL}"

if curl -s -f -m 5 "${FRONTEND_URL}" > /dev/null 2>&1; then
  print_success "Frontend is UP and serving"
else
  print_warning "Frontend not responding at ${FRONTEND_URL}"
  print_info "For E2E tests, ensure frontend is running"
  print_info "Start with: npm run dev (in frontend directory)"
  WARNINGS=$((WARNINGS + 1))
fi

# ============================================================================
# 5. Test Environment Variables
# ============================================================================
print_header "5. Environment Configuration"

# Variabili critiche per test
REQUIRED_ENV_VARS=("NODE_ENV")
OPTIONAL_ENV_VARS=("API_URL" "TEST_USER_EMAIL" "TEST_USER_PASSWORD")

for var in "${REQUIRED_ENV_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    print_warning "Required env var not set: $var"
    WARNINGS=$((WARNINGS + 1))
  else
    print_success "$var is set"
  fi
done

for var in "${OPTIONAL_ENV_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    print_info "$var not set (optional)"
  else
    print_success "$var is set"
  fi
done

# ============================================================================
# 6. Chrome/Playwright Browser Check (for smoke tests)
# ============================================================================
print_header "6. Browser Availability"

# Check se Playwright è installato (per E2E)
if [ -f "package.json" ]; then
  if grep -q '"@playwright/test"' package.json; then
    print_success "Playwright detected in package.json"

    # Verifica browsers installati
    if npx playwright --version > /dev/null 2>&1; then
      PLAYWRIGHT_VERSION=$(npx playwright --version)
      print_success "Playwright available: ${PLAYWRIGHT_VERSION}"
    else
      print_warning "Playwright installed but browsers may be missing"
      print_info "Run: npx playwright install"
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
fi

# Check Claude Chrome plugin (se configurato)
if command -v claude-chrome &> /dev/null; then
  print_success "Claude Chrome plugin available"
else
  print_info "Claude Chrome plugin not found (optional for smoke tests)"
  print_info "Install: https://code.claude.com/docs/en/chrome"
fi

# ============================================================================
# Summary
# ============================================================================
print_header "Verification Summary"

echo ""
if [ $CRITICAL_FAILURES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  print_success "All checks passed! Environment ready for tests."
  echo ""
  exit 0
elif [ $CRITICAL_FAILURES -eq 0 ]; then
  print_warning "Environment ready with ${WARNINGS} warning(s)."
  echo ""
  print_info "You can proceed, but tests may be flaky or incomplete."
  echo ""
  exit 2
else
  print_error "Environment NOT ready. ${CRITICAL_FAILURES} critical failure(s), ${WARNINGS} warning(s)."
  echo ""
  print_info "Fix critical issues before running tests."
  echo ""
  exit 1
fi
