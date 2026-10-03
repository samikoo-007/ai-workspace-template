#!/usr/bin/env bash
# Local pre-deploy checks: security scan, health/verify, optional pytest.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/deploy_common.sh
source "${SCRIPT_DIR}/lib/deploy_common.sh"
deploy_load_config

FAIL=0
note_fail() { deploy_fail "$*"; FAIL=1; }

echo "═══ ${DEPLOY_PROJECT_NAME} pre_deploy_check ═══"
deploy_print_config
echo ""

if echo "${DEPLOY_ROOT}" | grep -qiE 'GoogleDrive|Google Drive'; then
  deploy_warn "Repo path looks like Google Drive (OK for development; not a production source of truth)"
fi

if [[ -f "${DEPLOY_ROOT}/.env" ]]; then
  PERMS="$(stat -f "%OLp" "${DEPLOY_ROOT}/.env" 2>/dev/null || stat -c "%a" "${DEPLOY_ROOT}/.env" 2>/dev/null || echo "?")"
  if [[ "${PERMS}" != "600" && "${PERMS}" != "0600" ]]; then
    deploy_warn ".env permissions: ${PERMS} (recommend 600)"
  else
    deploy_ok ".env permissions OK"
  fi
else
  deploy_warn ".env missing (copy .env.example → .env for development)"
fi

if [[ -x "${DEPLOY_ROOT}/scripts/security_scan.py" ]] || [[ -f "${DEPLOY_ROOT}/scripts/security_scan.py" ]]; then
  if python3 "${DEPLOY_ROOT}/scripts/security_scan.py" --all; then
    deploy_ok "security_scan passed"
  else
    note_fail "security_scan failed — do not deploy"
  fi
fi

if [[ -f "${DEPLOY_ROOT}/scripts/health_check.py" ]]; then
  if python3 "${DEPLOY_ROOT}/scripts/health_check.py"; then
    deploy_ok "health_check passed"
  elif [[ ! -f "${DEPLOY_ROOT}/.env" && -f "${DEPLOY_ROOT}/.env.example" ]]; then
    deploy_warn "health_check: .env missing (OK on a fresh template — copy .env.example before production)"
  else
    note_fail "health_check failed"
  fi
elif [[ -f "${DEPLOY_ROOT}/package.json" ]] && command -v npm >/dev/null 2>&1; then
  if npm run verify --if-present; then
    deploy_ok "npm verify passed"
  else
    note_fail "npm verify failed"
  fi
fi

if [[ -d "${DEPLOY_ROOT}/tests" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -m pytest "${DEPLOY_ROOT}/tests/" -q --tb=no 2>/dev/null; then
    deploy_ok "pytest passed"
  else
    note_fail "pytest failed (pip install -r requirements.txt && pytest)"
  fi
fi

if deploy_compose_file_exists; then
  deploy_ok "docker compose found: ${DEPLOY_DOCKER_COMPOSE}"
else
  deploy_warn "No ${DEPLOY_DOCKER_COMPOSE} — rebuild/smoke cron skipped until you add a compose file"
fi

echo ""
echo "═══ pre_deploy_check done (exit ${FAIL}) ═══"
exit "${FAIL}"
