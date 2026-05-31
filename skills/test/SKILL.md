---
name: test
description: Performs automated builds and runtime checks to ensure code integrity.
version: 1.0.0
---

## Goal
작업한 코드가 정상적으로 컴파일(빌드)되고 런타임 환경에서 치명적인 문제(Panic) 없이 기동되는지 검증하여 무결성을 확보합니다.

## Activation Triggers
- 실무 에이전트(Frontend, Backend 등)가 태스크를 완료하고 PM에게 보고하기 직전 (필수 사항)
- CI/CD 파이프라인에서 자동화된 훅(`post-task.sh`)이 트리거될 때

## Execution Protocol
1. `.agents/skills/test/run.sh` 쉘 스크립트를 실행하여 다음 작업을 수행합니다.
   - 프로젝트 언어 및 프레임워크에 맞는 컴파일 및 문법 검사 실행
   - 로컬 개발 서버 또는 애플리케이션 기동 테스트 진행 (런타임 크래시 탐지)
2. 테스트 실행 후 생성된 결과를 분석하고, 상세한 타임스탬프 리포트를 `docs/reports/` 폴더에 기록합니다.
3. 빌드 실패 시 해당 이슈를 DevOps 에이전트(환경 문제)나 PM 에이전트(코드 문제)에게 즉시 리포트합니다.

## Constraints
- 테스트 환경이 시스템의 실제 상용(운영) 데이터나 상태를 훼손하지 않도록 주의해야 합니다.
- 스킬을 강제로 통과시키기 위해 테스트 스크립트(`run.sh`) 자체를 임의로 조작하거나 우회해서는 절대 안 됩니다.
