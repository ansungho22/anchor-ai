#!/usr/bin/env bash
# Test Skill: 다국어(Java, Go, Node.js, Python) 프로젝트 타입에 맞춘 테스트를 실행하고 리포트를 생성합니다.
set -e

echo "Running tests..."

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# 1. docs/context.md 파싱 (옵션)
if [ -f "${PROJECT_ROOT}/docs/context.md" ]; then
    echo "docs/context.md 파일을 감지했습니다. 테스트 환경에 참고합니다."
    cat "${PROJECT_ROOT}/docs/context.md"
    echo ""
fi

run_test() {
    local test_name="$1"
    local test_cmd="$2"
    
    echo "## 테스트 실행 ($test_name)"
    echo "명령어: $test_cmd"
    
    # eval을 사용하여 문자열 명령어를 실행
    if eval "$test_cmd"; then
        echo "상태: PASSED"
    else
        echo "상태: FAILED"
        exit 1
    fi
    echo ""
}

# 2. Custom Script Override
if [ -x "${PROJECT_ROOT}/scripts/test.sh" ]; then
    run_test "Custom Script" "${PROJECT_ROOT}/scripts/test.sh"

# 3. Makefile Override
elif [ -f "${PROJECT_ROOT}/Makefile" ] && grep -qE "^test\s*:" "${PROJECT_ROOT}/Makefile" 2>/dev/null; then
    run_test "Makefile" "make test"

# 4. Java Maven
elif [ -f "${PROJECT_ROOT}/pom.xml" ]; then
    run_test "Java Maven" "mvn test"

# 5. Java Gradle
elif [ -f "${PROJECT_ROOT}/build.gradle" ]; then
    if [ -f "${PROJECT_ROOT}/gradlew" ]; then
        run_test "Java Gradle" "./gradlew test"
    else
        run_test "Java Gradle" "gradle test"
    fi

# 6. Go
elif [ -f "${PROJECT_ROOT}/go.mod" ]; then
    run_test "Go" "go test ./..."

# 7. Node.js
elif [ -f "${PROJECT_ROOT}/package.json" ]; then
    run_test "Node.js" "npm test --if-present"

# 8. Python
elif [ -f "${PROJECT_ROOT}/requirements.txt" ] || [ -f "${PROJECT_ROOT}/pyproject.toml" ]; then
    if command -v pytest &> /dev/null; then
        run_test "Python" "pytest"
    else
        echo "## 테스트 실행 (Python)"
        echo "pytest 미설치. 테스트 건너뜀."
    fi

# 미지원 프로젝트
else
    echo "## 프로젝트 타입 미감지"
    echo "지원되는 프로젝트 설정 파일이 없습니다. 자동 테스트를 건너뜁니다."
fi

echo ""
echo "---"
echo "테스트 완료."
