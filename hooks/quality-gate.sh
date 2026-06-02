#!/usr/bin/env bash
# Quality Gate Script for my_agent
set -e

echo "Running Quality Gate..."

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# 1. Node.js (package.json)
if [ -f "${PROJECT_ROOT}/package.json" ]; then
    echo "Detected Node.js project."
    echo "Running npm lint (if exists)..."
    npm run lint --if-present
    echo "Running npm test (if exists)..."
    npm test --if-present
    echo "Quality Gate for Node.js passed."
# 2. Python (requirements.txt or pyproject.toml)
elif [ -f "${PROJECT_ROOT}/requirements.txt" ] || [ -f "${PROJECT_ROOT}/pyproject.toml" ]; then
    echo "Detected Python project."
    if command -v ruff &> /dev/null; then
        echo "Running ruff..."
        ruff check .
    else
        echo "No linter found (ruff missing), skipping linting."
    fi
    echo "Quality Gate for Python passed."
else
    echo "No supported project configuration found. Skipping automated quality checks."
fi

echo "Quality Gate Complete."
exit 0
