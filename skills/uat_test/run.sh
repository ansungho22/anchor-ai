#!/usr/bin/env bash
# UAT Test Skill: user_agent가 동적 탐색을 마친 후, 최종 피드백과 승인/반려 상태를 공식 리포트로 발행합니다.
# Usage: ./run.sh <APPROVE|REJECT> <path_to_feedback_markdown>
set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <APPROVE|REJECT> <path_to_feedback_markdown>"
    echo "Example: $0 APPROVE tmp_mock_feedback.md"
    exit 1
fi

DECISION=$(echo "$1" | tr '[:lower:]' '[:upper:]')
FEEDBACK_FILE="$2"

if [[ "$DECISION" != "APPROVE" && "$DECISION" != "REJECT" ]]; then
    echo "Error: First argument must be APPROVE or REJECT"
    exit 1
fi

if [ ! -f "$FEEDBACK_FILE" ]; then
    echo "Error: Feedback file '$FEEDBACK_FILE' not found."
    exit 1
fi

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
mkdir -p "${PROJECT_ROOT}/docs/reports"
REPORT_FILE="${PROJECT_ROOT}/docs/reports/uat-report.md"

echo "Generating UAT Report..."

echo "# UAT 리포트" > "$REPORT_FILE"
echo "실행 시각: $(date)" >> "$REPORT_FILE"
echo "담당 에이전트: user_agent" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## 사용자 에이전트 피드백 (Dynamic UAT Findings)" >> "$REPORT_FILE"
cat "$FEEDBACK_FILE" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "---" >> "$REPORT_FILE"
if [ "$DECISION" = "APPROVE" ]; then
    echo "### 최종 상태: UAT Approved" >> "$REPORT_FILE"
    echo "✅ UAT 성공 (UAT Approved). 리포트: $REPORT_FILE"
else
    echo "### 최종 상태: UAT Rejected" >> "$REPORT_FILE"
    echo "❌ UAT 실패 (UAT Rejected). 리포트: $REPORT_FILE"
fi

exit 0
