#!/usr/bin/env bash
# Blackboard Log Skill
# Usage: ./skills/log/run.sh "Agent Name" "File/Action" "Brief Reason"

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 \"Agent Name\" \"File/Action\" \"Brief Reason\""
    exit 1
fi

AGENT_NAME="$1"
ACTION="$2"
REASON="$3"

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
BLACKBOARD="${PROJECT_ROOT}/docs/blackboard.md"

# Ensure the docs directory exists
mkdir -p "${PROJECT_ROOT}/docs"

if [ ! -f "$BLACKBOARD" ]; then
    echo "# 에이전트 작업 기록 (Blackboard Log)" > "$BLACKBOARD"
    echo "" >> "$BLACKBOARD"
    echo "*모든 에이전트는 작업을 완료할 때마다 이 파일의 끝에 \`[에이전트 이름] - [수정된 파일/수행한 작업] - [간단한 이유]\` 형식으로 기록을 남겨야 합니다.*" >> "$BLACKBOARD"
    echo "" >> "$BLACKBOARD"
    echo "---" >> "$BLACKBOARD"
fi

echo "- [${AGENT_NAME}] - [${ACTION}] - [${REASON}]" >> "$BLACKBOARD"
echo "Successfully logged to docs/blackboard.md"
exit 0
