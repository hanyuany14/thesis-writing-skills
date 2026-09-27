#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /path/to/thesis.docx" >&2
  exit 2
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "pandoc is required. On macOS, install it with: brew install pandoc" >&2
  exit 1
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
input_dir=$(CDPATH= cd -- "$(dirname -- "$1")" && pwd)
input_file="$input_dir/$(basename -- "$1")"

cd "$project_dir"
mkdir -p markdown/imported-media
pandoc "$input_file" \
  --from=docx \
  --to=gfm \
  --wrap=none \
  --extract-media=markdown/imported-media \
  --output=markdown/imported-from-word.md

echo "Wrote markdown/imported-from-word.md"
echo "Review headings, equations, tables, footnotes, citations, and image paths before merging."
