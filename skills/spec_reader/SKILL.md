---
name: spec_reader
description: 프로젝트의 요구사항/스펙/ADR 문서 목록을 자동으로 스캔하여 출력합니다.
version: 1.0.0
---

## Goal
개발 에이전트(`frontend_dev`, `backend_dev`, `ai_dev`, `data_engineer`)가 작업 시작 시 "지금 무엇을 기준으로 코딩해야 하는지" 즉시 파악할 수 있도록, `docs/` 내의 모든 스펙 및 요구사항 문서를 한눈에 보여줍니다.

## Activation Triggers
- Phase 3(기능 개발) 진입 시, 개발 에이전트가 코딩을 시작하기 전
- 스펙 문서가 업데이트된 후 현재 상태를 확인하고 싶을 때

## Execution Protocol
1. `run_command` 도구를 사용하여 `./.agents/skills/spec_reader/run.sh`를 실행합니다.
2. 스크립트가 아래 디렉토리를 스캔하여 파일명, 줄 수, 크기를 출력합니다:
   - `docs/requirements/` — PRD 및 요구사항 문서
   - `docs/specs/` — 아키텍처/API/UI 스펙 문서
   - `docs/adr/` — 아키텍처 결정 기록(ADR)
3. 출력된 목록을 기반으로 에이전트가 필요한 문서를 `view_file`로 읽어 작업에 참조합니다.

## Constraints
- 이 스킬은 읽기 전용(Read-Only)이며, 문서를 수정하거나 삭제하지 않습니다.
- `.gitkeep` 파일은 목록에서 제외됩니다.
