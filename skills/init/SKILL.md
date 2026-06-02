---
name: init
description: 워크스페이스 환경을 초기화하고 프로젝트 컨텍스트를 생성합니다.
version: 1.1.0
---

## Goal
워크스페이스 초기에 필요한 폴더 구조(`docs/` 등)와 상태 공유소(`docs/blackboard.md`)를 설정하고, 프로젝트 컨텍스트를 스캔하여 에이전트들의 작업 환경을 완벽하게 구성합니다.

## Activation Triggers
- 프로젝트 시작 시 사용자가 초기 셋업을 요청할 때 (`/init`)
- 프로젝트 구조가 크게 변경되어 컨텍스트 갱신이 필요할 때

## Execution Protocol
1. `.agents/skills/init/run.sh` 쉘 스크립트를 실행하여 다음 작업을 수행합니다.
   - 프로젝트 스택 및 패키지 매니저(`package.json`, `pyproject.toml` 등) 스캔
   - 코어 폴더 구조 맵핑
   - `docs/blackboard.md` 및 `docs/`(requirements, specs, adr, reports, history) 디렉토리 초기화
2. 수집된 프로젝트 정보를 `docs/context.md` 파일로 출력하여 모든 에이전트가 공유할 수 있도록 합니다.

## Constraints
- 이미 생성된 `docs/blackboard.md` 파일이나 기존 문서를 함부로 덮어쓰거나 삭제하여 기록을 날려서는 안 됩니다.
- 스크립트 실행 중 권한 에러나 생성 실패가 발생하면 즉시 중단하고 에러를 뱉어야 합니다.
