#!/usr/bin/env bash
# Init Skill: Scans the project and generates context.md

# [예방책 1] 파이프라인 에러 및 비정상 종료 감지 방어 로직 추가
set -eo pipefail

echo "Scanning project environment..."

# [예방책 2] 더 견고한 프로젝트 루트 탐색
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
else
    # Git 저장소가 아닐 경우 대비
    PROJECT_ROOT=$(pwd)
fi

CONTEXT_FILE="${PROJECT_ROOT}/docs/context.md"

# [예방책 3] 디렉토리 쓰기 권한 사전 체크
if [ ! -w "$PROJECT_ROOT" ]; then
    echo "ERROR: $PROJECT_ROOT 에 쓰기 권한이 없습니다." >&2
    exit 1
fi

# [예방책 4] docs 폴더 누락 방지
mkdir -p "$PROJECT_ROOT/docs"

# 블랙보드(상태 공유소)가 없으면 초기화 (기존 기록 보존)
if [ ! -f "$PROJECT_ROOT/docs/blackboard.md" ]; then
    echo "# 에이전트 작업 기록 (Blackboard Log)" > "$PROJECT_ROOT/docs/blackboard.md"
    echo "" >> "$PROJECT_ROOT/docs/blackboard.md"
    echo "*모든 에이전트는 작업을 완료할 때마다 이 파일의 끝에 \`[에이전트 이름] - [수정된 파일/수행한 작업] - [간단한 이유]\` 형식으로 기록을 남겨야 합니다.*" >> "$PROJECT_ROOT/docs/blackboard.md"
    echo "" >> "$PROJECT_ROOT/docs/blackboard.md"
    echo "---" >> "$PROJECT_ROOT/docs/blackboard.md"
fi

echo "Creating global docs directories if they don't exist..."
# 디렉토리 생성 실패 시 에러 출력 후 안전하게 스크립트 종료
mkdir -p "$PROJECT_ROOT/docs/requirements" "$PROJECT_ROOT/docs/specs" "$PROJECT_ROOT/docs/adr" "$PROJECT_ROOT/docs/reports" "$PROJECT_ROOT/docs/history" "$PROJECT_ROOT/docs/templates" || {
    echo "ERROR: docs 하위 디렉토리 생성에 실패했습니다. 권한을 확인해주세요." >&2
    exit 1
}

# .gitkeep 생성 (실패해도 치명적이지 않으므로 경고만 띄우고 계속 진행)
touch "$PROJECT_ROOT/docs/requirements/.gitkeep" "$PROJECT_ROOT/docs/specs/.gitkeep" "$PROJECT_ROOT/docs/adr/.gitkeep" "$PROJECT_ROOT/docs/reports/.gitkeep" "$PROJECT_ROOT/docs/history/.gitkeep" "$PROJECT_ROOT/docs/templates/.gitkeep" || {
    echo "WARNING: .gitkeep 파일 생성에 실패했습니다. 계속 진행합니다." >&2
}

# [예방책 4.1] 템플릿 파일 복사
# 스크립트 자신의 위치를 기준으로 프레임워크 루트를 찾음 (skills/init/run.sh → ../../)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FRAMEWORK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE_SRC="$FRAMEWORK_ROOT/templates"

if [ -d "$TEMPLATE_SRC" ]; then
    echo "Copying reference templates from $TEMPLATE_SRC..."
    cp "$TEMPLATE_SRC/"*.md "$PROJECT_ROOT/docs/templates/" 2>/dev/null || true
fi

# [예방책 5] context.md 파일 쓰기 검증
if ! echo "# Project Context" > "$CONTEXT_FILE"; then
    echo "ERROR: $CONTEXT_FILE 파일에 기록할 수 없습니다. 저장 공간 및 권한을 확인해주세요." >&2
    exit 1
fi

echo "Generated at: $(date)" >> "$CONTEXT_FILE"
echo "" >> "$CONTEXT_FILE"

echo "## Detected Technologies & Environments" >> "$CONTEXT_FILE"

# 1. Containerization (Docker)
if find "$PROJECT_ROOT" -maxdepth 2 -name "Dockerfile" -o -name "docker-compose.yml" 2>/dev/null | grep -q .; then
    echo "- **Containerization:** Docker detected (Dockerfile or docker-compose.yml)" >> "$CONTEXT_FILE"
fi

# 2. Node.js Ecosystem
if find "$PROJECT_ROOT" -maxdepth 2 -name "package.json" 2>/dev/null | grep -q .; then
    echo "- **Node.js Environment:** Detected" >> "$CONTEXT_FILE"
    for pkg in $(find "$PROJECT_ROOT" -maxdepth 2 -name "package.json" 2>/dev/null); do
        dir_name=$(basename "$(dirname "$pkg")")
        [ "$dir_name" = "$(basename "$PROJECT_ROOT")" ] && dir_name="Root"
        echo "  - Module [\`$dir_name\`]: Check package.json for frameworks (e.g., React, Vue, Express, Vite)" >> "$CONTEXT_FILE"
    done
fi

# 3. Python Ecosystem
if find "$PROJECT_ROOT" -maxdepth 2 \( -name "pyproject.toml" -o -name "requirements.txt" \) 2>/dev/null | grep -q .; then
    echo "- **Python Environment:** Detected" >> "$CONTEXT_FILE"
    for pyfile in $(find "$PROJECT_ROOT" -maxdepth 2 \( -name "pyproject.toml" -o -name "requirements.txt" \) 2>/dev/null); do
        dir_name=$(basename "$(dirname "$pyfile")")
        [ "$dir_name" = "$(basename "$PROJECT_ROOT")" ] && dir_name="Root"
        echo "  - Module [\`$dir_name\`]: Check pyproject.toml / requirements.txt for frameworks (e.g., FastAPI, Django, Flask, uv)" >> "$CONTEXT_FILE"
    done
fi

# 4. Java / Spring
if find "$PROJECT_ROOT" -maxdepth 2 \( -name "pom.xml" -o -name "build.gradle" \) 2>/dev/null | grep -q .; then
    echo "- **Java/JVM Environment:** Detected (Maven/Gradle)" >> "$CONTEXT_FILE"
fi

# 5. Go
if find "$PROJECT_ROOT" -maxdepth 2 -name "go.mod" 2>/dev/null | grep -q .; then
    echo "- **Go Environment:** Detected" >> "$CONTEXT_FILE"
fi

# 6. Database & Migrations
if find "$PROJECT_ROOT" -maxdepth 3 \( -name "alembic.ini" -o -name "prisma" -o -name "migrations" \) 2>/dev/null | grep -q .; then
    echo "- **Database/ORM:** Migrations or ORM config detected (e.g., Alembic, Prisma)" >> "$CONTEXT_FILE"
fi

# 아무것도 발견되지 않았을 경우
if ! grep -q "Environment:\*\*" "$CONTEXT_FILE"; then
    echo "- **Type:** Unknown / Generic / Plain Text" >> "$CONTEXT_FILE"
fi

echo "" >> "$CONTEXT_FILE"
echo "## Folder Structure" >> "$CONTEXT_FILE"
echo '```' >> "$CONTEXT_FILE"
# [예방책 7] tree 명령어가 없을 때 ls 폴백 과정에서 에러 발생 시 무시
tree -L 2 "$PROJECT_ROOT" -I "node_modules|venv|.git|.agents" >> "$CONTEXT_FILE" 2>/dev/null || ls -la "$PROJECT_ROOT" >> "$CONTEXT_FILE" || true
echo '```' >> "$CONTEXT_FILE"

echo "Init complete. Context written to $CONTEXT_FILE."
