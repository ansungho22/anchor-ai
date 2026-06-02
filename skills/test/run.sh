#!/usr/bin/env bash
# Test Skill: 다국어(Java, Go, Node.js, Python) 프로젝트 타입에 맞춘 테스트를 실행하고 리포트를 생성합니다.
set -e

echo "Running tests..."

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
mkdir -p "${PROJECT_ROOT}/docs/reports"
REPORT_FILE="${PROJECT_ROOT}/docs/reports/test_report_$(date +%Y%m%d%H%M%S).md"

echo "# 테스트 리포트" > "$REPORT_FILE"
echo "실행 시각: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. docs/context.md 파싱 (옵션)
if [ -f "${PROJECT_ROOT}/docs/context.md" ]; then
    echo "docs/context.md 파일을 감지했습니다. 테스트 환경에 참고합니다."
    echo "## Context" >> "$REPORT_FILE"
    cat "${PROJECT_ROOT}/docs/context.md" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

# 테스트 실행 함수
run_test() {
    local test_name="$1"
    local test_cmd="$2"
    
    echo "## 테스트 실행 ($test_name)" >> "$REPORT_FILE"
    echo "명령어: $test_cmd" >> "$REPORT_FILE"
    
    # eval을 사용하여 문자열 명령어를 실행하고 로그를 기록
    if eval "$test_cmd" 2>&1 | tee -a "$REPORT_FILE"; then
        echo "상태: PASSED" >> "$REPORT_FILE"
    else
        echo "상태: FAILED" >> "$REPORT_FILE"
        exit 1
    fi
    echo "" >> "$REPORT_FILE"
}

# 2. Java Maven
if [ -f "${PROJECT_ROOT}/pom.xml" ]; then
    run_test "Java Maven" "mvn test"

# 3. Java Gradle
elif [ -f "${PROJECT_ROOT}/build.gradle" ]; then
    if [ -f "${PROJECT_ROOT}/gradlew" ]; then
        run_test "Java Gradle" "./gradlew test"
    else
        run_test "Java Gradle" "gradle test"
    fi

# 4. Go
elif [ -f "${PROJECT_ROOT}/go.mod" ]; then
    run_test "Go" "go test ./..."

# 5. Node.js
elif [ -f "${PROJECT_ROOT}/package.json" ]; then
    run_test "Node.js" "npm test --if-present"

# 6. Python
elif [ -f "${PROJECT_ROOT}/requirements.txt" ] || [ -f "${PROJECT_ROOT}/pyproject.toml" ]; then
    if command -v pytest &> /dev/null; then
        run_test "Python" "pytest"
    else
        echo "## 테스트 실행 (Python)" >> "$REPORT_FILE"
        echo "pytest 미설치. 테스트 건너뜀." >> "$REPORT_FILE"
    fi

# 미지원 프로젝트
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
