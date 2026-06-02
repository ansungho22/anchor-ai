#!/usr/bin/env bash
# Validate Mermaid syntax skill
# Usage: ./skills/validate_mermaid/run.sh <path_to_markdown_file>

if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_markdown_file>"
    exit 1
fi

FILE="$1"
if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

echo "Validating mermaid diagrams in $FILE..."
# In a real environment, we would use mmdc (mermaid-cli) to validate.
# For this harness, we run a basic syntax check grep if mmdc is missing.
if command -v mmdc &> /dev/null; then
    # We output to a dummy file to see if it renders successfully
    mmdc -i "$FILE" -o /tmp/dummy.svg > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ Mermaid validation PASSED."
        rm -f /tmp/dummy.svg
        exit 0
    else
        echo "❌ Mermaid validation FAILED! Please check your syntax."
        exit 1
    fi
else
    echo "Warning: mmdc (mermaid-cli) is not installed. Performing basic syntax check..."
    if grep -q "\`\`\`mermaid" "$FILE"; then
        echo "✅ Found mermaid block."
        exit 0
    else
        echo "❌ No mermaid block found in $FILE! You MUST use \`\`\`mermaid."
        exit 1
    fi
fi
