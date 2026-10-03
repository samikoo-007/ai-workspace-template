#!/usr/bin/env bash
# Project-specific remote smoke checks — run on Ubuntu server after deploy.
# Copy to deploy/smoke_remote.sh and customize (deploy/smoke_remote.sh is gitignored).
#
# Example for your-project dashboard:
#   curl -sf -o /dev/null -w "api=%{http_code}\n" http://127.0.0.1:8000/api/v1/pipeline/health
#   curl -sf -o /dev/null -w "web=%{http_code}\n" http://127.0.0.1:8080/

set -euo pipefail

APP_DIR="${DEPLOY_APP_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
cd "${APP_DIR}"

echo "▶ smoke_remote: ${APP_DIR} (default — customize this script)"

if [[ -f scripts/health_check.py ]]; then
  python3 scripts/health_check.py
fi

echo "✅ smoke_remote default OK"
