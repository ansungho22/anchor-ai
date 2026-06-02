#!/usr/bin/env bash
# Security Scan skill
# Usage: ./skills/security_scan/run.sh

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
echo "Running Security Scan on $PROJECT_ROOT..."

if [ -f "${PROJECT_ROOT}/package.json" ]; then
    echo "Scanning Node.js dependencies via npm audit..."
    npm audit --production || echo "⚠️ Vulnerabilities found in npm audit."
fi

if [ -f "${PROJECT_ROOT}/requirements.txt" ] || [ -f "${PROJECT_ROOT}/pyproject.toml" ]; then
    if command -v bandit &> /dev/null; then
        echo "Scanning Python code via bandit..."
        bandit -r "${PROJECT_ROOT}" -ll || echo "⚠️ Vulnerabilities found by bandit."
    else
        echo "bandit is not installed. Skipping Python security scan."
    fi
fi

echo "Security Scan Complete."
exit 0
