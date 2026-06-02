#!/usr/bin/env bash
# Report Skill: QA/보안/UAT 보고서 표준 템플릿을 자동 생성합니다.
# Usage: ./skills/report/run.sh "에이전트명" "리포트타입(QA|Security|UAT)"
set -e

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 \"에이전트명\" \"리포트타입(QA|Security|UAT)\""
    exit 1
fi

AGENT_NAME="$1"
REPORT_TYPE="$2"

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
mkdir -p "${PROJECT_ROOT}/docs/reports"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_FILE="${PROJECT_ROOT}/docs/reports/${REPORT_TYPE}_report_${TIMESTAMP}.md"

cat > "$REPORT_FILE" << EOF
# ${REPORT_TYPE} 리포트

- **작성자:** ${AGENT_NAME}
- **작성일시:** $(date '+%Y-%m-%d %H:%M:%S')
- **리포트 유형:** ${REPORT_TYPE}

---

## 요약 (Summary)
<!-- 전체적인 테스트/검토 결과를 간략히 기술하세요 -->


## 테스트 환경 (Environment)
<!-- 테스트한 환경 정보를 기술하세요 (OS, 브라우저, Node 버전 등) -->


## 발견 사항 (Findings)

| # | 심각도 | 항목 | 설명 | 재현 경로 |
|---|--------|------|------|-----------|
| 1 |        |      |      |           |

## 결론 (Conclusion)
<!-- PASSED / FAILED / UAT Approved / UAT Rejected -->


---
*이 리포트는 \`.agents/skills/report/run.sh\`에 의해 자동 생성되었습니다.*
EOF

echo "리포트 템플릿 생성 완료: $REPORT_FILE"
