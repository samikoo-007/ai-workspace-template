#!/usr/bin/env bash
# Post-deploy smoke tests — local (Mac) or remote (Ubuntu server via SSH).
#
# Usage:
#   bash deploy/scripts/smoke_test.sh local
#   bash deploy/scripts/smoke_test.sh remote
#   bash deploy/scripts/smoke_test.sh all
#
# Config: deploy/deploy.env + optional deploy/smoke_remote.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/deploy_common.sh
source "${SCRIPT_DIR}/lib/deploy_common.sh"
deploy_load_config

MODE="${1:-remote}"
FAIL=0

run_check() {
  local label="$1"
  shift
  deploy_info "Smoke: ${label}"
  if "$@"; then
    deploy_ok "${label}"
  else
    deploy_fail "${label}"
    FAIL=1
  fi
}

smoke_local() {
  echo "═══ ${DEPLOY_PROJECT_NAME} smoke (local) ═══"
  if [[ -f "${DEPLOY_ROOT}/scripts/health_check.py" ]]; then
    run_check "health_check" python3 "${DEPLOY_ROOT}/scripts/health_check.py"
  fi
  if [[ -d "${DEPLOY_ROOT}/tests" ]] && command -v python3 >/dev/null 2>&1; then
    run_check "pytest" python3 -m pytest "${DEPLOY_ROOT}/tests/" -q --tb=line
  fi
}

smoke_remote() {
  echo "═══ ${DEPLOY_PROJECT_NAME} smoke (remote: ${DEPLOY_SSH_TARGET}) ═══"
  deploy_print_config
  echo ""

  deploy_remote_bash <<REMOTE
set -euo pipefail
APP='${DEPLOY_APP_DIR}'
COMPOSE='${DEPLOY_DOCKER_COMPOSE}'
ENV_FILE='${DEPLOY_DOCKER_ENV_FILE}'
CRON_RUNNER='${DEPLOY_CRON_RUNNER}'
SMOKE_JOBS='${DEPLOY_SMOKE_CRON_JOBS}'
SMOKE_SCRIPT='${DEPLOY_SMOKE_REMOTE_SCRIPT}'
FAIL=0

cd "\${APP}"

if [[ -f "\${COMPOSE}" ]]; then
  echo "▶ docker compose config (syntax)"
  docker compose --env-file "\${ENV_FILE}" -f "\${COMPOSE}" config >/dev/null
  echo "✅ docker compose config OK"
else
  echo "⚠️  Ei \${COMPOSE} — ohitetaan docker-smoke"
fi

if [[ -n "\${SMOKE_JOBS}" && -f "\${CRON_RUNNER}" ]]; then
  for job in \${SMOKE_JOBS}; do
    echo "▶ cron_runner --job \${job}"
    if docker compose --env-file "\${ENV_FILE}" -f "\${COMPOSE}" run --rm worker \\
        python "\${CRON_RUNNER}" --job "\${job}"; then
      echo "✅ cron job \${job} OK"
    else
      echo "❌ cron job \${job} FAILED"
      FAIL=1
    fi
  done
fi

if [[ -f "\${SMOKE_SCRIPT}" ]]; then
  echo "▶ custom smoke script: \${SMOKE_SCRIPT}"
  bash "\${SMOKE_SCRIPT}" || FAIL=1
fi

exit "\${FAIL}"
REMOTE
}

case "${MODE}" in
  local) smoke_local ;;
  remote) smoke_remote ;;
  all)
    smoke_local || true
    smoke_remote
    ;;
  *)
    deploy_fail "Tuntematon mode: ${MODE} (local|remote|all)"
    exit 2
    ;;
esac

echo ""
if [[ "${FAIL}" -eq 0 ]]; then
  deploy_ok "Smoke test passed (${MODE})"
else
  deploy_fail "Smoke test failed (${MODE})"
fi
exit "${FAIL}"
