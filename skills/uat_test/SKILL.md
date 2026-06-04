# UAT Test Skill

이 스킬은 `user_agent`가 시스템을 동적으로 탐색하고 모의 테스트를 완료한 후, **최종 UAT(User Acceptance Testing) 리포트**를 시스템에 공식 발행하기 위해 사용됩니다. 

Phase 5에서 `user_agent`는 스스로 판단하여 앱을 구동하고 동적으로 테스트를 진행해야 합니다. 고정된 정형 스크립트에 의존하지 않고 실제 사람처럼 자유롭게 탐색한 뒤, 이 스킬을 호출하여 결과를 남기세요.

## 파일 위치
`skills/uat_test/run.sh`

## 작동 원리
1. `user_agent`는 `run_command` 등을 활용하여 애플리케이션을 구동하고, `tmp_mock_...` 형태의 모의 데이터를 활용해 동적으로 앱을 검증합니다.
2. 검증 중 발견한 모든 내용(피드백, 에러, UX 개선점)을 마크다운 파일(예: `tmp_mock_feedback.md`)에 작성합니다.
3. 이 스킬을 호출하여 최종 상태(`APPROVE` 또는 `REJECT`)와 피드백 파일을 시스템에 제출합니다. 시스템은 이 정보를 포맷팅하여 `docs/reports/` 폴더에 공식 저장합니다.

## 사용법
에이전트는 모든 테스트를 마친 후 터미널에서 아래 명령을 실행해야 합니다.
```bash
# 승인할 경우
./.agents/skills/uat_test/run.sh APPROVE tmp_mock_feedback.md

# 문제가 있어 반려할 경우
./.agents/skills/uat_test/run.sh REJECT tmp_mock_feedback.md
```

## 출력
명령이 완료되면 `docs/reports/uat_report_[timestamp].md` 파일이 생성됩니다. `APPROVE` 인자를 넘기면 문서 마지막에 **UAT Approved** 문구가 포함되며, 이를 통해 Phase 6 (PM 최종 승인)으로 넘어갈 수 있습니다.
