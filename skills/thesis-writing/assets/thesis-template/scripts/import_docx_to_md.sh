#!/bin/sh
# 把 Word 論文稿轉成 Markdown 中間檔。
#
# 用法：
#   ./scripts/import_docx_to_md.sh                    # 自動抓 word-source/ 裡的 .docx
#   ./scripts/import_docx_to_md.sh /路徑/論文.docx     # 指定檔案
#
# 產出 markdown/imported-from-word.md（中間檔，需人工逐章整理後搬進
# markdown/thesis.md），圖片解壓到 markdown/imported-media/。

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
cd "$project_dir"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "錯誤：需要 pandoc。macOS 請執行 brew install pandoc" >&2
  exit 1
fi

if [ "$#" -gt 1 ]; then
  echo "用法：$0 [/路徑/論文.docx]" >&2
  exit 2
fi

if [ "$#" -eq 1 ]; then
  source_path="$1"
else
  # 沒給參數就掃 word-source/，並排除 Word 開檔時產生的 ~$ 暫存檔
  mkdir -p word-source
  set -- word-source/*.docx
  filtered=""
  count=0
  for candidate in "$@"; do
    [ -f "$candidate" ] || continue
    case "$(basename -- "$candidate")" in
      '~$'*) continue ;;
    esac
    filtered="$candidate"
    count=$((count + 1))
  done

  if [ "$count" -eq 0 ]; then
    echo "word-source/ 裡沒有 .docx 檔。" >&2
    echo "請把原始 Word 論文稿複製進 word-source/ 後重跑，或直接指定路徑：" >&2
    echo "  $0 /路徑/論文.docx" >&2
    exit 2
  fi

  if [ "$count" -gt 1 ]; then
    echo "word-source/ 裡有多個 .docx，請指定要匯入哪一個：" >&2
    for candidate in "$@"; do
      [ -f "$candidate" ] || continue
      case "$(basename -- "$candidate")" in
        '~$'*) continue ;;
      esac
      echo "  $0 $candidate" >&2
    done
    exit 2
  fi

  source_path="$filtered"
fi

if [ ! -f "$source_path" ]; then
  echo "錯誤：找不到檔案 $source_path" >&2
  exit 1
fi

input_dir=$(CDPATH= cd -- "$(dirname -- "$source_path")" && pwd)
input_file="$input_dir/$(basename -- "$source_path")"

if [ -f markdown/imported-from-word.md ]; then
  backup="markdown/imported-from-word.$(date +%Y%m%d-%H%M%S).md"
  mv markdown/imported-from-word.md "$backup"
  echo "已把前一次的匯入結果備份為 $backup"
fi

mkdir -p markdown/imported-media
pandoc "$input_file" \
  --from=docx \
  --to=gfm \
  --wrap=none \
  --extract-media=markdown/imported-media \
  --output=markdown/imported-from-word.md

echo ""
echo "已匯入：$input_file"
echo "  → markdown/imported-from-word.md（中間檔）"
echo "  → markdown/imported-media/（圖片）"
echo ""
echo "接下來："
echo "  1. 這是待整理的中間檔，不要直接改名成 thesis.md。"
echo "  2. 逐章把內容搬進 markdown/thesis.md，每搬一章檢查標題階層、"
echo "     公式、表格、圖片路徑與引用格式。"
echo "  3. 原始 Word 檔請留在 word-source/ 當作核對基準。"
echo "  4. 搬完一章就跑一次 make，及早發現問題。"
