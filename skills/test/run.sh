#!/usr/bin/env bash
# Test Skill: 프로젝트 타입에 맞춘 빌드/테스트를 실행하고 리포트를 생성합니다.
set -e

echo "Running tests..."

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
mkdir -p "${PROJECT_ROOT}/docs/reports"
REPORT_FILE="${PROJECT_ROOT}/docs/reports/test_report_$(date +%Y%m%d%H%M%S).md"

echo "# 테스트 리포트" > "$REPORT_FILE"
echo "실행 시각: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. Node.js
if [ -f "${PROJECT_ROOT}/package.json" ]; then
    echo "## 빌드 및 린트 검사 (Node.js)" >> "$REPORT_FILE"
    if npm run build --if-present 2>&1 | tee -a "$REPORT_FILE"; then
        echo "상태: PASSED" >> "$REPORT_FILE"
    else
        echo "상태: FAILED" >> "$REPORT_FILE"
        exit 1
    fi

    echo "" >> "$REPORT_FILE"
    echo "## 테스트 실행 (Node.js)" >> "$REPORT_FILE"
    if npm test --if-present 2>&1 | tee -a "$REPORT_FILE"; then
        echo "상태: PASSED" >> "$REPORT_FILE"
    else
        echo "상태: FAILED" >> "$REPORT_FILE"
        exit 1
    fi

# 2. Python
elif [ -f "${PROJECT_ROOT}/requirements.txt" ] || [ -f "${PROJECT_ROOT}/pyproject.toml" ]; then
    echo "## 테스트 실행 (Python)" >> "$REPORT_FILE"
    if command -v pytest &> /dev/null; then
        if pytest 2>&1 | tee -a "$REPORT_FILE"; then
            echo "상태: PASSED" >> "$REPORT_FILE"
        else
            echo "상태: FAILED" >> "$REPORT_FILE"
            exit 1
        fi
    else
        echo "pytest 미설치. 테스트 건너뜀." >> "$REPORT_FILE"
    fi

# 3. 미지원 프로젝트
else
    echo "## 프로젝트 타입 미감지" >> "$REPORT_FILE"
    echo "지원되는 프로젝트 설정 파일이 없습니다. 자동 테스트를 건너뜁니다." >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "테스트 완료. 리포트: $REPORT_FILE"

# 리포트 가비지 컬렉션 (최근 5개만 유지)
echo "docs/reports/ 가비지 컬렉션 실행 중 (최근 5개 유지)..."
ls -t "$PROJECT_ROOT/docs/reports/"test_report_*.md 2>/dev/null | tail -n +6 | xargs -I {} rm -f {}
echo "가비지 컬렉션 완료."
