#!/usr/bin/env bash
# Shared helpers for deploy scripts. Source from other deploy/scripts/*.sh only.
set -euo pipefail

deploy_root_dir() {
  local here
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  if [[ -f "${here}/deploy/deploy.env" || -f "${here}/deploy/deploy.env.example" ]]; then
    printf '%s\n' "${here}"
    return 0
  fi
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
  printf '%s\n' "${here}"
}

deploy_load_config() {
  DEPLOY_ROOT="$(deploy_root_dir)"
  cd "${DEPLOY_ROOT}"

  if [[ -f "${DEPLOY_ROOT}/deploy/deploy.env" ]]; then
    # shellcheck disable=SC1091
    set -a && source "${DEPLOY_ROOT}/deploy/deploy.env" && set +a
  elif [[ -f "${DEPLOY_ROOT}/deploy/deploy.env.example" ]]; then
    # shellcheck disable=SC1091
    set -a && source "${DEPLOY_ROOT}/deploy/deploy.env.example" && set +a
  fi

  DEPLOY_PROJECT_NAME="${DEPLOY_PROJECT_NAME:-$(basename "${DEPLOY_ROOT}")}"
  DEPLOY_SERVER_HOST="${DEPLOY_SERVER_HOST:-your-server}"
  DEPLOY_SSH_USER="${DEPLOY_SSH_USER:-deploy}"
  DEPLOY_SSH_TARGET="${DEPLOY_SSH_TARGET:-${DEPLOY_SSH_USER}@${DEPLOY_SERVER_HOST}}"
  DEPLOY_GIT_BARE="${DEPLOY_GIT_BARE:-/srv/${DEPLOY_PROJECT_NAME}/git/${DEPLOY_PROJECT_NAME}.git}"
  DEPLOY_APP_DIR="${DEPLOY_APP_DIR:-/srv/${DEPLOY_PROJECT_NAME}/app}"
  DEPLOY_DATA_DIR="${DEPLOY_DATA_DIR:-/srv/${DEPLOY_PROJECT_NAME}/data}"
  DEPLOY_LOG_DIR="${DEPLOY_LOG_DIR:-/srv/${DEPLOY_PROJECT_NAME}/logs}"
  DEPLOY_BRANCH="${DEPLOY_BRANCH:-$(git branch --show-current 2>/dev/null || echo main)}"
  DEPLOY_DOCKER_COMPOSE="${DEPLOY_DOCKER_COMPOSE:-deploy/docker-compose.yml}"
  DEPLOY_DOCKER_ENV_FILE="${DEPLOY_DOCKER_ENV_FILE:-.env}"
  DEPLOY_DOCKER_REBUILD_SERVICES="${DEPLOY_DOCKER_REBUILD_SERVICES:-worker}"
  DEPLOY_CRON_RUNNER="${DEPLOY_CRON_RUNNER:-scripts/cron_runner.py}"
  DEPLOY_SMOKE_CRON_JOBS="${DEPLOY_SMOKE_CRON_JOBS:-}"
  DEPLOY_SMOKE_REMOTE_SCRIPT="${DEPLOY_SMOKE_REMOTE_SCRIPT:-deploy/smoke_remote.sh}"
  DEPLOY_REQUIRE_GIT="${DEPLOY_REQUIRE_GIT:-1}"
}

deploy_info() { echo "▶ $*"; }
deploy_ok() { echo "✅ $*"; }
deploy_warn() { echo "⚠️  $*"; }
deploy_fail() { echo "❌ $*" >&2; }

deploy_require_git_repo() {
  if [[ "${DEPLOY_REQUIRE_GIT}" != "1" ]]; then
    return 0
  fi
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    deploy_fail "Ei git-repositoriota. Aja: git init && git add . && git commit -m 'init'"
    exit 1
  fi
}

deploy_compose_file_exists() {
  [[ -f "${DEPLOY_ROOT}/${DEPLOY_DOCKER_COMPOSE}" ]]
}

deploy_remote() {
  ssh -o BatchMode=yes -o ConnectTimeout=15 "${DEPLOY_SSH_TARGET}" "$@"
}

deploy_remote_bash() {
  deploy_remote bash -s "$@"
}

deploy_print_config() {
  deploy_info "Project:  ${DEPLOY_PROJECT_NAME}"
  deploy_info "SSH:      ${DEPLOY_SSH_TARGET}"
  deploy_info "Bare:     ${DEPLOY_GIT_BARE}"
  deploy_info "App:      ${DEPLOY_APP_DIR}"
  deploy_info "Branch:   ${DEPLOY_BRANCH}"
  deploy_info "Compose:  ${DEPLOY_DOCKER_COMPOSE}"
  deploy_info "Rebuild:  ${DEPLOY_DOCKER_REBUILD_SERVICES:-<none>}"
}
