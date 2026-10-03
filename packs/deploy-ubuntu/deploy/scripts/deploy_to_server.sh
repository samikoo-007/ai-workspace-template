#!/usr/bin/env bash
# Full deploy pipeline: verify → commit → push → pull → rebuild → smoke
#
# Usage:
#   bash deploy/scripts/deploy_to_server.sh verify
#   bash deploy/scripts/deploy_to_server.sh commit -m "[AI] Fix X"
#   bash deploy/scripts/deploy_to_server.sh push
#   bash deploy/scripts/deploy_to_server.sh pull
#   bash deploy/scripts/deploy_to_server.sh rebuild
#   bash deploy/scripts/deploy_to_server.sh smoke
#   bash deploy/scripts/deploy_to_server.sh all -m "[AI] Fix X"
#
# Config: deploy/deploy.env (copy from deploy/deploy.env.example)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/deploy_common.sh
source "${SCRIPT_DIR}/lib/deploy_common.sh"
deploy_load_config

COMMIT_MSG=""
SKIP_COMMIT=false

usage() {
  cat <<EOF
Usage: bash deploy/scripts/deploy_to_server.sh <stage> [options]

Stages:
  verify    Local security + health + pytest
  commit    Git commit (requires -m)
  push      git push origin \$DEPLOY_BRANCH
  pull      git fetch + ff-only merge on server
  rebuild   docker compose build on server (DEPLOY_DOCKER_REBUILD_SERVICES)
  smoke     Remote smoke tests (cron jobs + smoke_remote.sh)
  all       verify → commit → push → pull → rebuild → smoke

Options:
  -m MSG    Commit message (commit / all)
  --skip-commit   all: push without new commit
  -h        Help

Setup once:
  cp deploy/deploy.env.example deploy/deploy.env   # edit paths
  bash deploy/scripts/setup_git_remote.sh --push
EOF
}

parse_args() {
  STAGE="${1:-}"
  shift || true
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -m)
        COMMIT_MSG="${2:-}"
        shift 2
        ;;
      --skip-commit)
        SKIP_COMMIT=true
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        deploy_fail "Unknown argument: $1"
        usage
        exit 2
        ;;
    esac
  done
}

stage_verify() {
  deploy_info "Stage: verify"
  bash "${SCRIPT_DIR}/pre_deploy_check.sh"
}

stage_commit() {
  deploy_require_git_repo
  if [[ -z "${COMMIT_MSG}" ]]; then
    deploy_fail "commit requires -m \"message\""
    exit 2
  fi
  deploy_info "Stage: commit"
  if [[ -f "${DEPLOY_ROOT}/scripts/security_scan.py" ]]; then
    python3 "${DEPLOY_ROOT}/scripts/security_scan.py" --all
  fi
  git status -sb
  git add -A
  git reset HEAD -- .env deploy/deploy.env mcp_config.json 2>/dev/null || true
  if git diff --cached --quiet; then
    deploy_warn "No staged changes — skipping commit"
    return 0
  fi
  git commit -m "${COMMIT_MSG}"
  deploy_ok "Commit: $(git log -1 --oneline)"
}

stage_push() {
  deploy_require_git_repo
  deploy_info "Stage: push origin/${DEPLOY_BRANCH}"
  git push origin "${DEPLOY_BRANCH}"
  deploy_ok "Push OK"
}

stage_pull() {
  deploy_info "Stage: pull on server"
  deploy_remote_bash <<REMOTE
set -euo pipefail
APP='${DEPLOY_APP_DIR}'
BRANCH='${DEPLOY_BRANCH}'
cd "\${APP}"
git fetch origin
git checkout "\${BRANCH}" 2>/dev/null || git checkout -b "\${BRANCH}" "origin/\${BRANCH}"
git merge --ff-only "origin/\${BRANCH}"
git log -1 --oneline
REMOTE
  deploy_ok "Server pull OK"
}

stage_rebuild() {
  if ! deploy_compose_file_exists; then
    deploy_warn "No ${DEPLOY_DOCKER_COMPOSE} — skipping rebuild"
    return 0
  fi
  if [[ -z "${DEPLOY_DOCKER_REBUILD_SERVICES// /}" ]]; then
    deploy_warn "DEPLOY_DOCKER_REBUILD_SERVICES empty — skipping rebuild"
    return 0
  fi
  deploy_info "Stage: rebuild ${DEPLOY_DOCKER_REBUILD_SERVICES}"
  deploy_remote_bash <<REMOTE
set -euo pipefail
APP='${DEPLOY_APP_DIR}'
COMPOSE='${DEPLOY_DOCKER_COMPOSE}'
ENV_FILE='${DEPLOY_DOCKER_ENV_FILE}'
SERVICES='${DEPLOY_DOCKER_REBUILD_SERVICES}'
cd "\${APP}"
docker compose --env-file "\${ENV_FILE}" -f "\${COMPOSE}" build \${SERVICES}
REMOTE
  deploy_ok "Docker rebuild OK"
}

stage_smoke() {
  deploy_info "Stage: smoke (remote)"
  bash "${SCRIPT_DIR}/smoke_test.sh" remote
}

stage_all() {
  echo "═══ ${DEPLOY_PROJECT_NAME} deploy ALL ═══"
  deploy_print_config
  echo ""
  stage_verify
  if [[ "${SKIP_COMMIT}" == true ]]; then
    deploy_warn "Commit skipped (--skip-commit)"
  else
    stage_commit
  fi
  stage_push
  stage_pull
  stage_rebuild
  stage_smoke
  deploy_ok "Deploy pipeline complete"
}

parse_args "$@"

case "${STAGE}" in
  verify) stage_verify ;;
  commit) stage_commit ;;
  push) stage_push ;;
  pull) stage_pull ;;
  rebuild) stage_rebuild ;;
  smoke) stage_smoke ;;
  all) stage_all ;;
  "")
    usage
    exit 2
    ;;
  *)
    deploy_fail "Unknown stage: ${STAGE}"
    usage
    exit 2
    ;;
esac
