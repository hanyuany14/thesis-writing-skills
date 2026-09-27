# 論文專案

用 Markdown 寫論文，自動產生 LaTeX 與 PDF。

```text
markdown/thesis.md  →  chapters/*.tex  →  thesis.pdf
   ↑ 只改這裡           ↑ 自動產生，勿手改
```

## 開始之前

1. **先填 `THESIS-SPEC.md`**——對照貴校論文格式規範逐項核對，改掉與模板不同的設定。模板預設是**政治大學碩士論文**格式，直接沿用很可能被退件。
2. 在 `thesisvars.tex` 填入系所、題目、姓名、指導教授、口試年月。
3. 確認環境：需要 `xelatex`、`bibtex`（macOS 裝 MacTeX）、Python 3.9+、`make`。從 Word 匯入才需要 `pandoc`。
4. 跑一次 `make` 確認能出 PDF，再開始寫內容。

## 日常使用

| 指令 | 用途 |
| --- | --- |
| `make` | 產出 `thesis.pdf` |
| `make convert` | 只做 Markdown → LaTeX，用來檢查轉換結果 |
| `make watermarked` | 產出含浮水印版本 |
| `make clean` | 清掉所有產物 |

編譯要跑四趟（xelatex → bibtex → xelatex → xelatex），交叉引用與書目才正確，所以比較慢。

## 目錄

| 路徑 | 用途 |
| --- | --- |
| `markdown/thesis.md` | **論文內容，只改這裡** |
| `THESIS-SPEC.md` | 格式規範對照表，本論文的格式契約 |
| `references.bib` | 書目資料庫 |
| `literature/` | 文獻 PDF，檔名 = citation key |
| `images/` | 論文圖片 |
| `thesisvars.tex` | 封面資料 |
| `thesisclass.cls` | 排版規則（邊界、行距、章節格式、封面） |
| `thesis.tex` | LaTeX 主檔（字型、套件、前置頁順序） |
| `scripts/` | Markdown → LaTeX 轉換器、Word 匯入工具 |
| `chapters/` | 自動產生，勿手改 |
| `pdfs/watermark.pdf` | 浮水印（預設政大校徽） |

## 從 Word 匯入

```bash
./scripts/import_docx_to_md.sh /完整路徑/原始論文.docx
```

產出 `markdown/imported-from-word.md`，圖片在 `markdown/imported-media/`。**這是待整理的中間檔**，要逐章搬進 `markdown/thesis.md`，並檢查標題階層、公式、表格、圖片路徑與引用格式。原始 Word 檔請留著當核對基準。

## 出問題時

- 排版不對 → 先 `make convert` 看 `chapters/*.tex`。轉換結果就錯 → Markdown 寫法問題；轉換對但 PDF 錯 → `thesisclass.cls` 或 `thesis.tex` 的設定問題。
- 編譯失敗 → 先試 `make clean && make`。看 `thesis.log` 裡**第一個** `!` 開頭的錯誤，後面的通常是連鎖反應。
- 引用變成 `(author?)` → citekey 不在 `references.bib` 裡。

完整說明見 [thesis-writing skill](https://github.com/hanyuany14/thesis-writing-skills) 的 `skills/thesis-writing/references/` 目錄。

## 模板來源

`thesisclass.cls` 衍生自 Tz-Huan Huang 的台大 XeLaTeX 論文模板，採 Chocolate-ware License，原始授權聲明保留在檔案內。
