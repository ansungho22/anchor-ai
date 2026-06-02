---
name: security_scan
description: 프로젝트의 보안 취약점을 자동으로 스캔하는 스킬입니다.
version: 1.0.0
---

## Goal
보안 전문가(`security_expert`) 에이전트가 코드를 눈으로만 리뷰하는 것이 아니라, 실제 정적 분석(SAST) 도구를 실행하여 객관적인 취약점 데이터를 확보할 수 있도록 지원합니다.

## Activation Triggers
- Phase 4(QA 검증) 단계에서 `security_expert` 에이전트가 보안 리뷰를 시작할 때
- 보안 관련 의존성이 변경되었을 때 (예: `package.json`, `requirements.txt` 업데이트 후)

## Execution Protocol
1. `run_command` 도구를 사용하여 `./.agents/skills/security_scan/run.sh` 를 실행합니다.
2. 프로젝트 타입에 따라 적절한 도구가 자동 선택됩니다:
   - **Node.js**: `npm audit --production`
   - **Python**: `bandit -r . -ll` (설치된 경우)
3. 스캔 결과를 바탕으로 `security_expert` 에이전트가 취약점 분석 보고서를 작성합니다.

## Constraints
- 이 스킬은 읽기 전용(Read-Only)이며, 코드를 수정하거나 패치를 적용하지 않습니다. 수정은 PM을 통해 개발 에이전트에게 위임되어야 합니다.
- 스캔 도구(`npm`, `bandit` 등)가 설치되지 않은 환경에서는 해당 단계를 건너뛰고 경고를 출력합니다.
