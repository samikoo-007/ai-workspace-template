#!/usr/bin/env python3
"""Workspace health check — verifies environment without printing secrets."""

from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def check(label: str, ok: bool, detail: str = "") -> bool:
    status = "PASS" if ok else "FAIL"
    suffix = f" — {detail}" if detail else ""
    print(f"[{status}] {label}{suffix}")
    return ok


def check_env_file() -> bool:
    env_path = ROOT / ".env"
    if not env_path.is_file():
        return check(
            ".env exists",
            False,
            "Expected on fresh clone: cp .env.example .env",
        )
    return check(".env exists", True)


def check_python_tests() -> bool:
    tests_dir = ROOT / "tests" / "python"
    if not tests_dir.is_dir():
        return check("Python tests", True, "skipped (no tests/python/)")

    if shutil.which("pytest") is None:
        return check("Python tests", True, "skipped (pytest not installed)")

    result = subprocess.run(
        ["pytest", "tests/python/", "-q"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        return check("Python tests", True, "pytest passed")
    detail = (result.stdout + result.stderr).strip().splitlines()
    summary = detail[-1] if detail else "pytest failed"
    return check("Python tests", False, summary[:200])


def check_js_tests() -> bool:
    node_modules = ROOT / "node_modules"
    if not node_modules.is_dir():
        return check("JavaScript tests", True, "skipped (run npm install first)")

    if shutil.which("npm") is None:
        return check("JavaScript tests", True, "skipped (npm not found)")

    result = subprocess.run(
        ["npm", "test"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        return check("JavaScript tests", True, "npm test passed")
    detail = (result.stdout + result.stderr).strip().splitlines()
    summary = detail[-1] if detail else "npm test failed"
    return check("JavaScript tests", False, summary[:200])


def main() -> int:
    print("Workspace Health Check")
    print("=" * 40)

    results = [
        check_env_file(),
        check_python_tests(),
        check_js_tests(),
    ]

    print("=" * 40)
    if all(results):
        print("OVERALL: PASS")
        return 0

    print("OVERALL: FAIL")
    if not results[0] and all(results[1:]):
        print("[INFO] Missing .env alone is expected on a fresh clone.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
