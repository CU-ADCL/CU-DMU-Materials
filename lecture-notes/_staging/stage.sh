#!/bin/bash
#
# Export reveal.js presentations from Slides App to PDFs
#
# Usage: stage.sh [number]
#   e.g., stage.sh 010
#   If no number given, exports the most recently modified presentation
#
# Outputs:
#   1. ../<number>-<name>-blank.pdf - without fragments on separate pages (in lecture-notes)
#   2. <number>-<name>.pdf - with fragments on separate pages (in _staging)

set -e

SLIDES_DIR="$HOME/Dropbox/Apps/Slides App"

if [ -z "$1" ]; then
    # Find most recently modified presentation (excluding hash-suffixed versions)
    HTML_FILE=$(ls -t "$SLIDES_DIR"/*.html 2>/dev/null | grep -v -E '[0-9a-f]{6}\.html$' | head -1)
    if [ -z "$HTML_FILE" ]; then
        echo "Error: No presentations found in $SLIDES_DIR"
        exit 1
    fi
else
    NUM="$1"
    # Find the HTML file matching the number (prefer the clean version without hash suffix)
    HTML_FILE=$(ls "$SLIDES_DIR"/${NUM}-*.html 2>/dev/null | grep -v -E '[0-9a-f]{6}\.html$' | head -1)
fi

if [ -z "$HTML_FILE" ]; then
    echo "Error: No presentation found matching '$NUM'"
    echo "Available presentations:"
    ls "$SLIDES_DIR"/*.html | grep -v -E '[0-9a-f]{6}\.html$' | sed 's/.*\//  /' | sort
    exit 1
fi

# Extract the base name (e.g., "010-introduction" from "010-introduction.html")
BASENAME=$(basename "$HTML_FILE" .html)

echo "Exporting: $BASENAME"

# Export without fragments (blank version) - for lecture-notes directory
echo "  Creating ../${BASENAME}-blank.pdf (without fragments)..."
npx decktape reveal \
    --size 1280x720 \
    --chrome-arg=--no-sandbox \
    "file://$HTML_FILE" \
    "../${BASENAME}-blank.pdf"

# Export with fragments - for staging directory (current directory)
echo "  Creating ${BASENAME}.pdf (with fragments)..."
npx decktape reveal \
    --size 1280x720 \
    --chrome-arg=--no-sandbox \
    --fragments \
    "file://$HTML_FILE" \
    "${BASENAME}.pdf"

echo "Done!"
echo "  ../${BASENAME}-blank.pdf"
echo "  ${BASENAME}.pdf"
