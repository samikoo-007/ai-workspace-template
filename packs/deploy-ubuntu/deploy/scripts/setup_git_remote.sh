#!/usr/bin/env bash
# Configure Mac <-> Ubuntu Server git sync via SSH bare repo (no GitHub required).
#
# Usage:
#   bash deploy/scripts/setup_git_remote.sh
#   bash deploy/scripts/setup_git_remote.sh --push
#
# Config: deploy/deploy.env (copy from deploy/deploy.env.example)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/deploy_common.sh
source "${SCRIPT_DIR}/lib/deploy_common.sh"
deploy_load_config
deploy_require_git_repo

PUSH=false
if [[ "${1:-}" == "--push" ]]; then
  PUSH=true
fi

REMOTE_URL="${DEPLOY_SERVER_HOST}:${DEPLOY_GIT_BARE}"

echo "═══ ${DEPLOY_PROJECT_NAME} git remote setup ═══"
deploy_print_config
echo ""

deploy_info "Create bare repo on server (if missing)"
deploy_remote "mkdir -p $(dirname "${DEPLOY_GIT_BARE}") && test -d '${DEPLOY_GIT_BARE}' || git init --bare '${DEPLOY_GIT_BARE}'"

if git remote get-url origin >/dev/null 2>&1; then
  CURRENT="$(git remote get-url origin)"
  if [[ "${CURRENT}" != "${REMOTE_URL}" ]]; then
    deploy_info "Update Mac origin: ${CURRENT} -> ${REMOTE_URL}"
    git remote set-url origin "${REMOTE_URL}"
  else
    deploy_ok "Mac origin already ${REMOTE_URL}"
  fi
else
  deploy_info "Add Mac origin ${REMOTE_URL}"
  git remote add origin "${REMOTE_URL}"
fi

deploy_info "Configure server app checkout"
deploy_remote_bash <<REMOTE
set -euo pipefail
BARE='${DEPLOY_GIT_BARE}'
APP='${DEPLOY_APP_DIR}'
if [[ ! -d "\${APP}/.git" ]]; then
  echo "ERROR: \${APP} is not a git checkout — clone or init on server first"
  exit 1
fi
cd "\${APP}"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "\${BARE}"
else
  git remote add origin "\${BARE}"
fi
echo "Server origin: \$(git remote get-url origin)"
REMOTE

if [[ "${PUSH}" == true ]]; then
  deploy_info "Push ${DEPLOY_BRANCH} to origin"
  git push -u origin "${DEPLOY_BRANCH}"
  deploy_info "Fast-forward pull on server into ${DEPLOY_APP_DIR}"
  deploy_remote_bash <<REMOTE
set -euo pipefail
APP='${DEPLOY_APP_DIR}'
BRANCH='${DEPLOY_BRANCH}'
cd "\${APP}"
git fetch origin
if git show-ref --verify --quiet "refs/heads/\${BRANCH}"; then
  git checkout "\${BRANCH}"
  git pull --ff-only origin "\${BRANCH}"
else
  git checkout -b "\${BRANCH}" "origin/\${BRANCH}"
fi
git status -sb
git log -1 --oneline
REMOTE
fi

echo ""
deploy_ok "Git remote setup valmis"
echo "Mac:    git push origin ${DEPLOY_BRANCH}"
echo "Server: cd ${DEPLOY_APP_DIR} && git fetch origin && git merge --ff-only origin/${DEPLOY_BRANCH}"
