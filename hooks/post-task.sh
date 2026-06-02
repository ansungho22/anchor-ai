#!/usr/bin/env bash
# Post-Task Hook: Triggered after an agent completes a task

echo "Triggering post-task hook..."

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
TEST_SKILL="${PROJECT_ROOT}/.agents/skills/test/run.sh"

QUALITY_GATE="${PROJECT_ROOT}/hooks/quality-gate.sh"

# Run Quality Gate first
if [ -x "$QUALITY_GATE" ]; then
    echo "Running Quality Gate before completing task..."
    bash "$QUALITY_GATE"
    if [ $? -ne 0 ]; then
        echo "Quality Gate failed! Please fix errors before proceeding."
        echo "[System] Quality Gate failed." >> "${PROJECT_ROOT}/docs/blackboard.md"
        exit 1
    fi
fi

# Run tests in background
if [ -x "$TEST_SKILL" ]; then
    echo "Running tests..."
    bash "$TEST_SKILL" &
else
    echo "Test skill not found or not executable."
fi

# Notify PMO Agent (Simulated via log for now)
echo "Notifying PMO to update docs/history/..."
echo "[System] Post-task hook triggered. PMO should review blackboard.md." >> "${PROJECT_ROOT}/docs/blackboard.md"
