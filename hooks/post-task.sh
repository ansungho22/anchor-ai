#!/usr/bin/env bash
# Post-Task Hook: Triggered after an agent completes a task

echo "Triggering post-task hook..."

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
TEST_SKILL="${PROJECT_ROOT}/.agents/skills/test/run.sh"

# Run tests in background
if [ -x "$TEST_SKILL" ]; then
    echo "Running tests..."
    bash "$TEST_SKILL" &
else
    echo "Test skill not found or not executable."
fi

# Notify PMO Agent (Simulated via log for now)
echo "Notifying PMO to update docs/history/..."
echo "[System] Post-task hook triggered. PMO should review blackboard.md." >> "${PROJECT_ROOT}/.agents/blackboard.md"
