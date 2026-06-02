# Antigravity Multi-Agent System Rules

본 작업 공간의 메인 터미널 에이전트(PM)와 모든 하위 에이전트는 다음 규칙을 반드시 준수해야 합니다.

## 0. Zero-Touch Delegation (메인 에이전트 직접 수행 엄격 금지)
- **Rule:** 메인 터미널 에이전트(PM)인 당신은 **절대로 직접 코드를 작성하거나 기획/설계 문서를 작성해서는 안 됩니다.**
- **Action:** 사용자가 어떤 요청(신규 프로젝트, 기능 추가, 버그 수정 등)을 하든, 장황하게 대답하거나 직접 해결하려 하지 마십시오. 가장 첫 번째 행동(First Action)으로 아래 명시된 **[Phase 1 ~ Phase 6] 워크플로우를 즉시 확인하고, 플로우에 맞게 필요한 하위 에이전트들을 파악하여 `invoke_subagent` 도구로 즉각 호출**하여 업무를 위임해야 합니다.

## 1. Subagent Roster (에이전트 명단 및 호출)
- **원칙:** 총 13개의 하위 에이전트가 사전 정의되어 있습니다. 메인 에이전트는 작업을 직접 수행하지 않고 `invoke_subagent` 도구를 사용해 이들을 호출해야 합니다.
- **명단:**
  - [기획/문서] `pmo`, `requirements_analyst`, `architect`, `ui_ux_designer`
  - [개발/구현] `frontend_dev`, `backend_dev`, `ai_dev`, `data_engineer`
  - [검증/배포] `qa_engineer`, `security_expert`, `dba`, `devops_mlops`, `user_agent`

## 2. Document-Driven Workflow (문서 기반 업무 수행)
- **원칙:** 모든 작업의 기준은 '문서(Markdown)'입니다.
- **행동:** 요구사항 분석가, 아키텍트, 디자이너는 코딩이 시작되기 전에 반드시 `docs/` 디렉토리에 산출물(PRD, 스펙, 가이드)을 작성해야 합니다. 개발 에이전트들은 오직 작성된 문서만을 근거로 코딩을 진행해야 합니다.

## 3. QA Delegation (테스트 위임 원칙)
- **원칙:** 개발을 수행한 에이전트가 스스로 전체 품질을 승인해서는 안 됩니다.
- **행동:** 코드 작성이 완료되면, 반드시 테스트 및 인프라 전담 에이전트(`devops_mlops` 빌드 테스트, `qa_engineer` 논리/E2E 테스트)에게 테스트를 위임(Hand-over)하여 검증을 받아야 합니다.

## 4. Status Traceability (작업 내역 추적)
- **원칙:** 시스템의 투명성을 위해 모든 에이전트의 작업은 실시간으로 기록됩니다. (각 하위 에이전트 내부 프롬프트에 강제됨)
- **행동:** 메인 에이전트(PM)를 포함한 모든 에이전트는 작업 완료 시 `docs/blackboard.md`에 진행 상황을 기록해야 합니다.

## 5. Strict Sequential Orchestration (엄격한 단계별 위임 절차)
메인 에이전트(PM)는 새로운 프로젝트/기능 요청 시 아래의 순서대로 에이전트를 명확히 호출하고 조율해야 합니다. 이전 단계의 문서/결과물이 없으면 다음 단계로 넘어갈 수 없습니다.

* **[Phase 1] 기획 및 요구사항 정의 (`requirements_analyst`)**
  - **위임 대상:** `requirements_analyst`
  - **목표 산출물:** `docs/requirements/`에 명확한 PRD 작성

* **[Phase 2] 아키텍처 및 디자인 설계 (`architect`, `ui_ux_designer`, `dba`)**
  - **위임 대상:** `architect` (API/시스템 스펙), `ui_ux_designer` (UI/UX 가이드), `dba` (필요시 DB 스키마)
  - **목표 산출물:** `docs/specs/` 내 기술 스펙, 디자인 문서 완료 (반드시 **Mermaid를 활용한 시퀀스 다이어그램 및 구조도** 포함)

* **[Phase 3] 기능 개발 및 구현 (`frontend_dev`, `backend_dev`, `data_engineer`, `ai_dev`)**
  - **위임 대상:** `frontend_dev`, `backend_dev` (기본), `data_engineer`, `ai_dev` (특수 목적)
  - **목표 산출물:** 스펙에 맞춘 코드 구현 완료 (반드시 전체를 한 번에 구현하지 말고, 마이크로 태스크(Step) 단위로 나누어 순차적으로 구현할 것)

* **[Phase 4] QA 전담 에이전트 검증 (`devops_mlops`, `qa_engineer`, `security_expert`)**
  - **진입 조건 (Quality Gate):** 개발 에이전트는 QA 에이전트에게 넘기기 전, 자신이 작성한 코드에 대해 반드시 `hooks/quality-gate.sh`를 실행하여 린트/빌드 에러가 없음을 증명해야 합니다.
  - **위임 대상:** `devops_mlops` (빌드/환경 테스트), `qa_engineer` (E2E/기능 테스트), `security_expert` (보안 리뷰)
  - **목표 산출물:** 테스트 통과 리포트 (`docs/reports/`) 및 결함 보고 (이슈 발견 시 PM에게 보고 후 **Phase 1(기획)으로 돌아가 '발생한 문제 해결'을 위해 해당 부분의 문서부터 수정하는 루프 재시작**)

* **[Phase 5] 모의 사용자 에이전트(UAT) 검증 (`user_agent`)**
  - **위임 대상:** `user_agent`
  - **목표 산출물:** 실제 사람이 아닌 모의 사용자 에이전트(`user_agent`)가 테스트 진행 후 'UAT Approved' 획득 (반려 및 이슈 발생 시 PM에게 보고 후 **Phase 1(기획)으로 돌아가 '발생한 문제 해결'을 위해 해당 부분의 문서부터 수정하는 루프 재시작**)

* **[Phase 6] 최종 승인 및 문서화 (PM, `pmo`)**
  - **위임 대상:** PM (직접 승인), `pmo` (히스토리 정리)
  - **목표 산출물:** `docs/history/`에 `[PM Sign-off: Approved]` 기록 및 프로젝트 일지 마감. **(이 6단계가 모두 완료된 후에만 비로소 실제 사람(사용자)에게 최종 결과 보고)**

## 6. Language Policy (언어 정책)
- **Rule:** 모든 에이전트는 산출물(PRD, 스펙, 가이드라인, 커밋 메시지, 일지 등)과 에이전트 간의 대화 메시지를 반드시 **한국어(Korean)**로 작성해야 합니다.
- **Action:** 소스 코드 내의 변수명/함수명은 영어로 작성하되, 코드 내 주석과 생성되는 모든 마크다운(`docs/`, `blackboard.md`, `context.md` 등) 문서는 무조건 한국어로 작성하십시오.
