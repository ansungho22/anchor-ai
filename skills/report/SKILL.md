---
name: report
description: QA/보안/UAT 보고서의 표준 템플릿 마크다운 파일을 자동 생성합니다.
version: 1.0.0
---

## Goal
검증 에이전트(`qa_engineer`, `security_expert`, `user_agent`)가 테스트 결과를 보고할 때, 통일된 양식의 리포트 템플릿을 자동 생성하여 보고서 품질과 일관성을 보장합니다.

## Activation Triggers
- Phase 4(QA 검증) 또는 Phase 5(UAT 검증)에서 검증 에이전트가 리포트를 작성하기 시작할 때
- 보안 전문가가 취약점 분석 보고서를 작성할 때

## Execution Protocol
1. `run_command` 도구를 사용하여 다음 형식으로 실행합니다:
   ```
   ./.agents/skills/report/run.sh "에이전트명" "리포트타입"
   ```
   - 리포트 타입: `QA`, `Security`, `UAT` 중 하나
2. 스크립트가 `docs/reports/` 디렉토리에 타임스탬프가 포함된 템플릿 파일을 자동 생성합니다.
3. 에이전트는 생성된 템플릿 파일의 각 섹션(요약, 테스트 환경, 발견 사항, 결론)을 채워 넣습니다.

## Constraints
- 리포트 파일명은 `{타입}_report_{YYYYMMDD_HHMMSS}.md` 형식을 따릅니다.
- 기존 리포트를 덮어쓰지 않으며, 항상 새 파일로 생성됩니다.
- 인자가 2개 미만이면 사용법을 출력하고 즉시 종료합니다.
