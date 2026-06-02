---
name: validate_mermaid
description: Mermaid 다이어그램 문법을 검증하는 스킬입니다.
version: 1.0.0
---

## Goal
아키텍트가 작성한 Mermaid 다이어그램(시퀀스 다이어그램, 구조도 등)의 문법 오류를 자동으로 검증하여, 렌더링이 깨지는 문서가 커밋되는 것을 방지합니다.

## Activation Triggers
- `architect` 에이전트가 `docs/specs/` 내에 Mermaid 블록이 포함된 마크다운 문서를 작성하거나 수정한 직후
- Phase 2(아키텍처 설계) 단계에서 시퀀스 다이어그램 또는 구조도를 최종 저장하기 전

## Execution Protocol
1. `run_command` 도구를 사용하여 `./.agents/skills/validate_mermaid/run.sh <대상_파일_경로>` 를 실행합니다.
2. `mmdc`(mermaid-cli)가 설치된 환경에서는 실제 렌더링을 시도하여 문법 오류를 검출합니다.
3. `mmdc`가 없는 환경에서는 마크다운 내 ` ```mermaid ` 블록의 존재 여부를 기본 검증합니다.
4. 검증 실패 시 에이전트는 문법을 수정한 뒤 재검증해야 합니다.

## Constraints
- 이 스킬은 읽기 전용(Read-Only)이며, 대상 파일을 수정하지 않습니다. 수정은 반드시 에이전트가 직접 수행해야 합니다.
- 검증 결과가 FAIL인 상태로 Phase 2를 종료해서는 안 됩니다.
