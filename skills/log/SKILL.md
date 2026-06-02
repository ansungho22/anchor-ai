---
name: log
description: 블랙보드(docs/blackboard.md)에 표준화된 형식으로 작업 기록을 남기는 스킬입니다.
version: 1.0.0
---

## Goal
모든 에이전트가 `echo` 셸 명령어를 직접 조립하는 대신, 파라미터만 전달하면 안전하고 통일된 마크다운 형식으로 `docs/blackboard.md`에 로그를 기록할 수 있도록 합니다. 따옴표 이스케이프 오류나 포맷 불일치를 원천적으로 방지합니다.

## Activation Triggers
- 모든 에이전트가 파일을 수정하거나, 주요 체크포인트를 완료한 직후
- MANDATORY TRACEABILITY RULE에 의해 강제됨

## Execution Protocol
1. `run_command` 도구를 사용하여 다음 형식으로 실행합니다:
   ```
   ./.agents/skills/log/run.sh "에이전트명" "수행한 작업" "간단한 사유"
   ```
2. 스크립트가 자동으로 `docs/` 디렉토리 존재 여부를 확인하고, `blackboard.md` 파일이 없으면 헤더와 함께 새로 생성합니다.
3. 기록 형식: `- [에이전트명] - [수행한 작업] - [간단한 사유]`

## Constraints
- 인자가 3개 미만이면 사용법을 출력하고 즉시 종료합니다.
- 기존 `blackboard.md`의 내용을 덮어쓰지 않고, 항상 파일 끝에 추가(append)합니다.
