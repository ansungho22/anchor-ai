#!/usr/bin/env bash
# Spec Reader Skill: docs/specs/ 및 docs/requirements/ 내 최신 문서 목록을 출력합니다.
# Usage: ./skills/spec_reader/run.sh

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

echo "=== 📋 현재 프로젝트 스펙 및 요구사항 문서 ==="
echo ""

echo "## 요구사항 (docs/requirements/)"
if ls "$PROJECT_ROOT"/docs/requirements/*.md 1>/dev/null 2>&1; then
    for f in "$PROJECT_ROOT"/docs/requirements/*.md; do
        echo "  - $(basename "$f") ($(wc -l < "$f" | tr -d ' ')줄, $(stat -f%z "$f" 2>/dev/null || stat -c%s "$f" 2>/dev/null) bytes)"
    done
else
    echo "  (문서 없음)"
fi

echo ""
echo "## 기술 스펙 (docs/specs/)"
if ls "$PROJECT_ROOT"/docs/specs/*.md 1>/dev/null 2>&1; then
    for f in "$PROJECT_ROOT"/docs/specs/*.md; do
        echo "  - $(basename "$f") ($(wc -l < "$f" | tr -d ' ')줄, $(stat -f%z "$f" 2>/dev/null || stat -c%s "$f" 2>/dev/null) bytes)"
    done
else
    echo "  (문서 없음)"
fi

echo ""
echo "## ADR (docs/adr/)"
if ls "$PROJECT_ROOT"/docs/adr/*.md 1>/dev/null 2>&1; then
    for f in "$PROJECT_ROOT"/docs/adr/*.md; do
        echo "  - $(basename "$f")"
    done
else
    echo "  (문서 없음)"
fi

echo ""
echo "=== 스펙 스캔 완료 ==="
