#!/usr/bin/env bash
# Cleanup Hook: Automatically removes temporary test and mock files
set -e

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
echo "Running Cleanup Hook..."

# Find and delete files matching tmp_test_* or tmp_mock_* to prevent environment pollution
# We use -type f and -type d to catch both files and directories if any

find "$PROJECT_ROOT" -type d -name "node_modules" -prune -o \
                     -type d -name ".git" -prune -o \
                     -type d -name ".venv" -prune -o \
                     -name "tmp_test_*" -exec rm -rf {} + \
                     -o -name "tmp_mock_*" -exec rm -rf {} +

echo "Cleanup Complete."
exit 0
