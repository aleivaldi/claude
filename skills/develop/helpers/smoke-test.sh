#!/bin/bash
# ============================================================================
# Smoke Tests Runner (Chrome Plugin Integration)
# ============================================================================
# Esegue smoke test automatici usando Claude Chrome plugin per browser automation
# Copre happy path critici: login, creazione entità, navigazione base
#
# Prerequisito: Claude Chrome plugin installato
#   https://code.claude.com/docs/en/chrome
#
# Usage:
#   ./smoke-test.sh [config-file]
#
# Exit codes:
#   0 = All tests passed
#   1 = One or more tests failed
#   2 = Setup/environment error

set -e

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurazione default
APP_URL=${APP_URL:-"http://localhost:3000"}
TEST_EMAIL=${TEST_EMAIL:-"admin@test.com"}
TEST_PASSWORD=${TEST_PASSWORD:-"password"}
SMOKE_TEST_CONFIG=${1:-"smoke-test-config.yaml"}

# Counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}  $1${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
}

print_test() {
  echo -e "${BLUE}▶ Running test: $1${NC}"
}

print_pass() {
  echo -e "${GREEN}✅ PASS: $1${NC}"
  TESTS_PASSED=$((TESTS_PASSED + 1))
}

print_fail() {
  echo -e "${RED}❌ FAIL: $1${NC}"
  echo -e "${RED}   Reason: $2${NC}"
  TESTS_FAILED=$((TESTS_FAILED + 1))
}

print_skip() {
  echo -e "${YELLOW}⏭  SKIP: $1${NC}"
}

# Wrapper per comandi Claude Chrome plugin
chrome_cmd() {
  local cmd=$1
  shift

  if ! command -v claude-chrome &> /dev/null; then
    echo "ERROR: claude-chrome command not found"
    echo "Install Claude Chrome plugin: https://code.claude.com/docs/en/chrome"
    exit 2
  fi

  # Esegui comando con timeout
  timeout 30s claude-chrome "$cmd" "$@" 2>&1
}

# ============================================================================
# Pre-flight Checks
# ============================================================================

print_header "Smoke Tests - Pre-flight"

# Check Claude Chrome plugin
if ! command -v claude-chrome &> /dev/null; then
  echo -e "${RED}ERROR: Claude Chrome plugin not installed${NC}"
  echo "Install from: https://code.claude.com/docs/en/chrome"
  exit 2
fi

echo -e "${GREEN}✅ Claude Chrome plugin available${NC}"

# Check app is running
if ! curl -s -f -m 5 "${APP_URL}" > /dev/null 2>&1; then
  echo -e "${RED}ERROR: App not responding at ${APP_URL}${NC}"
  echo "Start app first: npm run dev"
  exit 2
fi

echo -e "${GREEN}✅ App is running at ${APP_URL}${NC}"
echo ""

# ============================================================================
# Test Suite
# ============================================================================

print_header "Smoke Test Suite"

# ----------------------------------------------------------------------------
# Test 1: Login Flow (Happy Path)
# ----------------------------------------------------------------------------
TESTS_RUN=$((TESTS_RUN + 1))
print_test "Login flow with valid credentials"

# Navigate to login
if chrome_cmd navigate "${APP_URL}/login"; then
  # Fill email
  if chrome_cmd fill "input[name=email],input[type=email],#email" "${TEST_EMAIL}"; then
    # Fill password
    if chrome_cmd fill "input[name=password],input[type=password],#password" "${TEST_PASSWORD}"; then
      # Submit form
      if chrome_cmd click "button[type=submit],button:has-text('Login'),button:has-text('Sign In')"; then
        # Verify redirect to dashboard/home
        sleep 2 # Wait for redirect
        if chrome_cmd verify "url-contains" "/dashboard|/home|/app"; then
          print_pass "Login flow completed successfully"
        else
          print_fail "Login flow" "Did not redirect to expected page after login"
        fi
      else
        print_fail "Login flow" "Could not click submit button"
      fi
    else
      print_fail "Login flow" "Could not fill password field"
    fi
  else
    print_fail "Login flow" "Could not fill email field"
  fi
else
  print_fail "Login flow" "Could not navigate to login page"
fi

# ----------------------------------------------------------------------------
# Test 2: Dashboard Loads Data
# ----------------------------------------------------------------------------
TESTS_RUN=$((TESTS_RUN + 1))
print_test "Dashboard loads and displays data"

if chrome_cmd navigate "${APP_URL}/dashboard"; then
  # Verify key dashboard elements are visible
  if chrome_cmd verify "element-visible" ".dashboard,#dashboard,[data-testid=dashboard]"; then
    print_pass "Dashboard rendered successfully"
  else
    print_fail "Dashboard load" "Dashboard container not visible"
  fi
else
  print_fail "Dashboard load" "Could not navigate to dashboard"
fi

# ----------------------------------------------------------------------------
# Test 3: Create Entity (Happy Path - Generic)
# ----------------------------------------------------------------------------
# NOTA: Questa sezione deve essere customizzata per il progetto specifico
# Esempio generico per "create device" flow

TESTS_RUN=$((TESTS_RUN + 1))
print_test "Create new entity (happy path)"

# Esempio: Create Device flow (customizza per il tuo progetto)
if chrome_cmd navigate "${APP_URL}/devices"; then
  # Click "Add" or "Create" button
  if chrome_cmd click "button:has-text('Add'),button:has-text('Create'),button:has-text('New')"; then
    sleep 1 # Wait for modal/form

    # Fill form (CUSTOMIZZA questi selectors per il tuo progetto)
    if chrome_cmd fill "input[name=name]" "Test Entity $(date +%s)"; then
      # Submit
      if chrome_cmd click "button[type=submit],button:has-text('Save'),button:has-text('Create')"; then
        sleep 2 # Wait for creation

        # Verify success (cerca messaggio success o nuovo elemento in lista)
        if chrome_cmd verify "element-visible" ".success,.toast-success,[role=alert]:has-text('success')"; then
          print_pass "Entity created successfully"
        else
          # Fallback: cerca elemento nella lista
          if chrome_cmd verify "element-visible" "text=Test Entity"; then
            print_pass "Entity created successfully"
          else
            print_fail "Create entity" "No success confirmation found"
          fi
        fi
      else
        print_fail "Create entity" "Could not submit form"
      fi
    else
      print_fail "Create entity" "Could not fill form fields"
    fi
  else
    print_fail "Create entity" "Could not find create/add button"
  fi
else
  print_fail "Create entity" "Could not navigate to entities page"
fi

# ----------------------------------------------------------------------------
# Test 4: Navigation Works
# ----------------------------------------------------------------------------
TESTS_RUN=$((TESTS_RUN + 1))
print_test "Main navigation is functional"

# Click on nav items and verify page change
if chrome_cmd click "nav a:has-text('Settings'),a[href*=settings]"; then
  sleep 1
  if chrome_cmd verify "url-contains" "settings"; then
    print_pass "Navigation to settings works"
  else
    print_fail "Navigation" "Settings link did not navigate"
  fi
else
  print_skip "Navigation test (no settings link found)"
fi

# ============================================================================
# Custom Tests (da config file se esiste)
# ============================================================================

if [ -f "$SMOKE_TEST_CONFIG" ]; then
  print_header "Custom Smoke Tests (from config)"

  # Parse YAML config e esegui custom tests
  # TODO: Implementare parsing YAML per custom tests
  # Per ora skip
  echo "Custom test config found but not yet implemented"
else
  echo "No custom smoke test config found (${SMOKE_TEST_CONFIG})"
fi

# ============================================================================
# Summary
# ============================================================================

print_header "Smoke Test Summary"

echo ""
echo "Tests Run:    ${TESTS_RUN}"
echo -e "Tests Passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Tests Failed: ${RED}${TESTS_FAILED}${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
  echo -e "${GREEN}✅ All smoke tests passed!${NC}"
  echo ""
  exit 0
else
  echo -e "${RED}❌ Some smoke tests failed${NC}"
  echo ""
  echo "Smoke tests verify critical happy paths work."
  echo "Failures indicate integration issues that should be fixed before proceeding."
  echo ""
  exit 1
fi
