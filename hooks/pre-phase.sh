#!/usr/bin/env bash
# Pre-Phase Hook: Phase 전환 시 선행 산출물 존재 여부를 검증합니다.
# Usage: hooks/pre-phase.sh <phase_number>
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <phase_number (1-6)>"
    exit 1
fi

PHASE="$1"
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

echo "Phase $PHASE 진입 전제조건 검증 중..."

case "$PHASE" in
    1)
        # Phase 1은 첫 단계이므로 전제조건 없음
        echo "✅ Phase 1: 전제조건 없음. 진입 허용."
        ;;
    2)
        # Phase 2 진입 → docs/requirements/ 내 PRD 파일 존재 확인
        if ls "$PROJECT_ROOT"/docs/requirements/*.md 1>/dev/null 2>&1; then
            echo "✅ Phase 2: PRD 문서 확인됨. 진입 허용."
        else
            echo "❌ Phase 2 진입 차단: docs/requirements/ 에 PRD 문서(.md)가 없습니다."
            echo "   Phase 1(요구사항 분석)을 먼저 완료해 주세요."
            exit 1
        fi
        ;;
    3)
        # Phase 3 진입 → docs/specs/ 내 아키텍처 스펙 파일 존재 확인
        if ls "$PROJECT_ROOT"/docs/specs/*.md 1>/dev/null 2>&1; then
            echo "✅ Phase 3: 아키텍처 스펙 문서 확인됨. 진입 허용."
        else
            echo "❌ Phase 3 진입 차단: docs/specs/ 에 스펙 문서(.md)가 없습니다."
            echo "   Phase 2(아키텍처 설계)를 먼저 완료해 주세요."
            exit 1
        fi
        ;;
    4)
        # Phase 4 진입 → 소스 코드가 존재하는지 기본 확인
        if find "$PROJECT_ROOT/src" "$PROJECT_ROOT/app" "$PROJECT_ROOT/pages" "$PROJECT_ROOT/components" "$PROJECT_ROOT/cmd" "$PROJECT_ROOT/pkg" "$PROJECT_ROOT/internal" "$PROJECT_ROOT/lib" "$PROJECT_ROOT/api" -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" -o -name "*.cpp" 2>/dev/null | head -1 | grep -q .; then
            echo "✅ Phase 4: 소스 코드 확인됨. 진입 허용."
        else
            echo "❌ Phase 4 진입 차단: 구현된 소스 코드를 찾을 수 없습니다."
            echo "   Phase 3(기능 개발)을 먼저 완료해 주세요."
            exit 1
        fi
        ;;
    5)
        # Phase 5 진입 → docs/reports/ 내 테스트 리포트 존재 확인
        if ls "$PROJECT_ROOT"/docs/reports/*.md 1>/dev/null 2>&1; then
            echo "✅ Phase 5: 테스트 리포트 확인됨. 진입 허용."
        else
            echo "❌ Phase 5 진입 차단: docs/reports/ 에 테스트 리포트(.md)가 없습니다."
            echo "   Phase 4(QA 검증)를 먼저 완료해 주세요."
            exit 1
        fi
        ;;
    6)
        # Phase 6 진입 → UAT Approved 문구 확인
        if grep -rq "UAT Approved" "$PROJECT_ROOT/docs/reports/" 2>/dev/null; then
            echo "✅ Phase 6: UAT 승인 확인됨. 진입 허용."
        else
            echo "❌ Phase 6 진입 차단: 'UAT Approved' 승인을 찾을 수 없습니다."
            echo "   Phase 5(UAT 검증)를 먼저 완료해 주세요."
            exit 1
        fi
        ;;
    *)
        echo "알 수 없는 Phase 번호: $PHASE (1-6 사이의 값을 입력해 주세요)"
        exit 1
        ;;
esac
