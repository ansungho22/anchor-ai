---
name: test
description: 프로젝트 타입에 맞춘 자동 빌드/테스트를 수행하여 코드 무결성을 검증합니다.
version: 1.1.0
---

## Goal
작업한 코드가 정상적으로 컴파일(빌드)되고 런타임 환경에서 치명적인 문제 없이 기동되는지 검증하여 무결성을 확보합니다.

## Activation Triggers
- 실무 에이전트(Frontend, Backend 등)가 태스크를 완료하고 PM에게 보고하기 직전 (필수 사항)
- CI/CD 파이프라인에서 자동화된 훅(`post-task.sh`)이 트리거될 때

## Execution Protocol
1. `run_command` 도구를 사용하여 `./.agents/skills/test/run.sh` 쉘 스크립트를 실행합니다.
2. 스크립트가 프로젝트 타입을 자동 감지하여 적절한 테스트를 수행합니다:
   - **Node.js** (`package.json` 존재): `npm run build` → `npm test`
   - **Python** (`requirements.txt` 또는 `pyproject.toml` 존재): `pytest`
3. 테스트 실행 후 타임스탬프가 포함된 리포트를 `docs/reports/test_report_YYYYMMDDHHMMSS.md`에 자동 생성합니다.
4. 리포트는 최근 5개만 유지되며, 오래된 리포트는 자동으로 삭제(가비지 컬렉션)됩니다.
5. 빌드/테스트 실패 시 스크립트가 즉시 비정상 종료(`exit 1`)하여 후속 작업을 차단합니다.

## Constraints
- 테스트 과정에서 생성하는 임시 파일은 반드시 `tmp_test_` 접두사를 붙여야 합니다. 시스템의 `hooks/cleanup.sh`가 자동으로 정리합니다.
- 테스트 환경이 시스템의 실제 상용(운영) 데이터나 상태를 훼손하지 않도록 주의해야 합니다.
- 스킬을 강제로 통과시키기 위해 테스트 스크립트(`run.sh`) 자체를 임의로 조작하거나 우회해서는 절대 안 됩니다.
