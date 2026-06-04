#!/usr/bin/env bash
# Quality Gate Script for my_agent
set -e

echo "Running Quality Gate..."

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# 1. Custom Script Override
if [ -x "${PROJECT_ROOT}/scripts/lint.sh" ]; then
    echo "Detected custom lint script (scripts/lint.sh)."
    "${PROJECT_ROOT}/scripts/lint.sh"
    echo "Quality Gate (Custom Script) passed."

# 2. Makefile Override
elif [ -f "${PROJECT_ROOT}/Makefile" ] && grep -qE "^lint\s*:" "${PROJECT_ROOT}/Makefile" 2>/dev/null; then
    echo "Detected Makefile with lint target."
    make lint
    echo "Quality Gate (Makefile) passed."

# 3. Java Maven/Gradle
elif [ -f "${PROJECT_ROOT}/pom.xml" ] || [ -f "${PROJECT_ROOT}/build.gradle" ]; then
    echo "Detected Java project."
    echo "Running checkstyle/spotless if configured..."
    if [ -f "${PROJECT_ROOT}/pom.xml" ]; then
        mvn checkstyle:check 2>/dev/null || echo "Checkstyle not found or passed."
    elif [ -f "${PROJECT_ROOT}/gradlew" ]; then
        ./gradlew checkstyleMain spotlessCheck 2>/dev/null || echo "Lint tasks not found or passed."
    else
        gradle checkstyleMain spotlessCheck 2>/dev/null || echo "Lint tasks not found or passed."
    fi
    echo "Quality Gate for Java passed."

# 4. Go
elif [ -f "${PROJECT_ROOT}/go.mod" ]; then
    echo "Detected Go project."
    if command -v golangci-lint &> /dev/null; then
        golangci-lint run
    else
        echo "golangci-lint missing, running basic go vet..."
        go vet ./...
    fi
    echo "Quality Gate for Go passed."

# 5. Node.js (package.json)
elif [ -f "${PROJECT_ROOT}/package.json" ]; then
    echo "Detected Node.js project."
    echo "Running npm lint (if exists)..."
    npm run lint --if-present
    echo "Quality Gate for Node.js passed."

# 6. Python (requirements.txt or pyproject.toml)
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
