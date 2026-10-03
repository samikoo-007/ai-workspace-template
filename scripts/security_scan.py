#!/usr/bin/env python3
"""Scan workspace for accidental secrets before commit. Zero tolerance — FAIL blocks commit."""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Files that must never be staged
FORBIDDEN_STAGED = {".env", "mcp_config.json"}

# Placeholder values allowed in tracked files
PLACEHOLDER_PATTERNS = (
    r"your_.*_here",
    r"UPDATE_IN_ENV",
    r"changeme",
    r"xxx+",
    r"placeholder",
)

SECRET_PATTERNS: list[tuple[str, re.Pattern[str]]] = [
    ("OpenAI API key", re.compile(r"sk-[a-zA-Z0-9]{20,}")),
    ("GitHub PAT", re.compile(r"ghp_[a-zA-Z0-9]{36,}")),
    ("GitLab PAT", re.compile(r"glpat-[a-zA-Z0-9\-_]{20,}")),
    ("AWS access key", re.compile(r"AKIA[0-9A-Z]{16}")),
    ("Private key block", re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----")),
    ("JWT token", re.compile(r"eyJ[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}\.")),
]

ENV_SECRET_KEYS = (
    "SUPABASE_SERVICE_ROLE_KEY=",
    "NETLIFY_AUTH_TOKEN=",
    "GITHUB_PERSONAL_ACCESS_TOKEN=",
    "API_KEY=",
    "DATABASE_URL=",
)


def is_placeholder(value: str) -> bool:
    value = value.strip().strip('"').strip("'")
    if not value or value in ("", "''", '""'):
        return True
    return any(re.search(p, value, re.I) for p in PLACEHOLDER_PATTERNS)


def staged_files() -> list[str]:
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=A"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return []
    return [f for f in result.stdout.strip().splitlines() if f]


def is_env_file(path: Path) -> bool:
    name = path.name
    return name == ".env" or name.startswith(".env.") or name.endswith(".env.example") or name == ".env.example"


def scan_text(path: str, content: str, issues: list[str], *, env_file: bool = False) -> None:
    for name, pattern in SECRET_PATTERNS:
        if pattern.search(content):
            issues.append(f"{path}: possible {name}")

    if not env_file:
        return

    for line in content.splitlines():
        for key in ENV_SECRET_KEYS:
            if key in line and not line.strip().startswith("#"):
                _, _, val = line.partition("=")
                if val and not is_placeholder(val):
                    issues.append(f"{path}: non-placeholder value for {key.rstrip('=')}")


def scan_file(path: Path, issues: list[str]) -> None:
    if path.name == "security_scan.py":
        return
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        issues.append(f"{path}: cannot read ({exc})")
        return
    rel = str(path.relative_to(ROOT))
    scan_text(rel, content, issues, env_file=is_env_file(path))


def scan_tree(issues: list[str]) -> None:
    skip_dirs = {".git", "node_modules", ".venv", "__pycache__"}
    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue
        if any(part in skip_dirs for part in path.parts):
            continue
        if path.name in (".env", "mcp_config.json"):
            continue
        if path.suffix in (".pyc", ".png", ".jpg", ".gif", ".webp"):
            continue
        scan_file(path, issues)


def main() -> int:
    scan_all = "--all" in sys.argv
    issues: list[str] = []

    staged = staged_files()
    for rel in staged:
        if rel in FORBIDDEN_STAGED or rel.endswith("/.env"):
            issues.append(f"FORBIDDEN staged new file: {rel}")
            continue
        full = ROOT / rel
        if full.is_file():
            scan_file(full, issues)

    if scan_all or not staged:
        scan_tree(issues)

    # Deduplicate while preserving order
    seen: set[str] = set()
    unique = []
    for item in issues:
        if item not in seen:
            seen.add(item)
            unique.append(item)

    print("Security Scan")
    print("=" * 40)
    if unique:
        for item in unique:
            print(f"[FAIL] {item}")
        print("=" * 40)
        print("OVERALL: FAIL — do not commit")
        return 1

    print("[PASS] No secrets detected")
    print("=" * 40)
    print("OVERALL: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
