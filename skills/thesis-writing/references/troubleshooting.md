# 疑難排解

按錯誤訊息查。找不到對應項目時，先跑 `make clean && make` 排除中繼檔汙染——這能解掉相當比例的怪問題。

## 環境

### `make: xelatex: command not found`

沒裝 TeX，或裝了但不在 PATH。

- 沒裝：執行 `brew install texlive`（完整步驟見 SKILL.md 的「⓪ 環境準備」）。
- 已裝但找不到：確認 `/opt/homebrew/bin` 在 PATH 裡。剛裝好 Homebrew 的話，照安裝結束時畫面上的 Next steps 設定，再開新的終端機。

### `! LaTeX Error: File 'xxx.sty' not found`

缺套件。`brew install texlive` 是完整版，不會缺；會出現這個錯誤，通常是之前裝過 BasicTeX 等精簡版，而且它排在 PATH 前面。用 `which xelatex` 確認實際執行的是 `/opt/homebrew/bin/xelatex`。

模板用到的非標準套件：`xeCJK`、`setspace`、`titlesec`、`titletoc`、`tocloft`、`tocbibind`、`etoolbox`、`algorithm`、`algpseudocode`、`caption`、`biblatex`、`wallpaper`、`pdfpages`、`tabularx`、`adjustbox`、`booktabs`、`enumitem`、`mathtools`。

### `Package fontspec Error: The font "BiauKaiTC" cannot be found`

系統沒有該字型。列出可用的中文字型：

```bash
fc-list :lang=zh family | sort -u        # fc-list 會隨 brew install texlive 一起裝好
```

把 `thesis.tex` 的 `\setCJKmainfont` 改成實際存在的字型名。字型名要與系統登記的名稱完全相同（含大小寫與空格）。

## 編譯

### PDF 出來了，但中文全部不見或變成方框

用錯編譯器。**必須用 XeLaTeX**，不能用 pdfLaTeX。`make` 已經指定 `xelatex`；若你是在編輯器裡按「編譯」鍵出問題，去設定裡把引擎改成 XeLaTeX。

`thesis.tex` 第一行的 `% !TEX program = xelatex` 是給編輯器看的提示，多數 LaTeX 編輯器會讀。

### 引用印成 `(author?)`、`[?]` 或 `(Smith?)`

三種可能，依序檢查：

1. **bib 裡沒有這個 key。** 用 `literature.md` 的完整性檢查腳本找出來。
2. **bibtex 沒跑或跑失敗。** 看 `thesis.blg` 的錯誤訊息，常見是 bib 條目語法錯（少逗號、括號不對稱）。
3. **編譯輪數不夠。** 引用需要 xelatex → bibtex → xelatex → xelatex 共四趟。`make` 已經跑滿，但手動編譯時容易漏。

### 目錄或交叉引用的頁碼是 `??` 或不正確

編譯輪數不夠。`make clean && make` 重跑一次。頁碼變動會連鎖影響目錄，所以正文改動大時最後一定要完整重編。

### `! Undefined control sequence`

Markdown 裡寫了 LaTeX 指令但拼錯，或用了沒載入套件的指令。錯誤訊息下一行 `l.123 \xxxx` 會指出是哪個指令。

回頭看 `chapters/chapter_NN.tex` 的第 123 行附近，再對應回 `markdown/thesis.md` 的原文。

### `! Missing $ inserted`

數學模式沒配對。常見原因：

- Markdown 裡寫了單獨的 `$`（當貨幣符號用）。要印錢字號請寫 `\$`。
- `$$` 區塊沒有成對關閉。
- 行內公式 `$...$` 跨行了。

### `! LaTeX Error: File 'images/xxx.png' not found`

- 路徑要相對於**專案根目錄**，不是相對於 `markdown/`。
- 副檔名要寫對（`.png` 與 `.PNG` 在 Linux 下不同）。
- 從 Word 匯入的圖片在 `markdown/imported-media/media/`，`thesis.tex` 的 `\graphicspath` 已掛上 `markdown/`，所以可以寫 `imported-media/media/image1.png`。

### 編譯過程卡住不動

通常是 LaTeX 在等你回應錯誤。`make` 已加 `-interaction=nonstopmode -halt-on-error` 避免這情況；若手動編譯卡住，按 `X` 加 Enter 離開，再看 `.log` 檔。

## 排版

### 表格超出頁面寬度

轉換腳本會自動判斷欄寬並套用縮放，但極寬的表格仍可能出問題。依序考慮：

1. **縮短欄標題文字**（腳本用標題長度判斷是否需要換行欄）。
2. **拆成兩個表**。
3. **改成橫式頁面**：手動在 Markdown 裡寫 `\begin{landscape}...\end{landscape}`，並在 `thesis.tex` 加 `\usepackage{pdflscape}`。

表格若被縮到字太小（小於內文兩級以上），多半該拆表了，審查委員會看不清楚。

### 圖片太大／位置跑掉

轉換腳本固定用 `width=\linewidth` 與 `[H]`（強制放在當前位置）。要自訂就別用 Markdown 圖片語法，直接在 Markdown 裡寫 LaTeX：

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.6\linewidth]{images/model.png}
  \caption{研究架構}
  \label{fig:model}
\end{figure}
```

### 章標題位置太高或太低

調 `thesisclass.cls` 的 `\titlespacing*{\chapter}{0pt}{-3em}{9pt}` 第二個參數（`-3em` 是上方距離）。改過邊界後這個值通常要跟著調。

### 段落之間空隙過大

模板開了 `\raggedbottom`（不強制撐滿頁面）。若仍然鬆散，檢查 Markdown 裡是否有連續多個空行——雖然轉換器會處理，但夾在環境之間的空行偶爾會產生額外間距。

### 中文粗體看起來不對

標楷體沒有真正的粗體字重，模板用描邊模擬（`\def\xeCJKembold{0.4}`）。太粗調小、太細調大，建議範圍 0.2～0.6。

## 轉換

### 改了 Markdown 但 PDF 沒變

`make` 會自動先轉換。若你是直接跑 `xelatex`，會用到舊的 `chapters/*.tex`。一律用 `make`。

### 某段內容在 PDF 裡整個不見了

檢查它是不是在 `# 參考文獻` 之後——該標題以下的所有內容都會被忽略。

### Markdown 語法沒有生效

轉換器只支援特定語法子集。斜體、超連結、腳註、巢狀清單都不支援，會原樣印出。完整清單見 `markdown-syntax.md`。

### 想確認轉換結果

```bash
make convert          # 只轉換不編譯
less chapters/chapter_01.tex
```

**先判斷問題出在哪一段**：`chapters/*.tex` 就已經不對 → 是 Markdown 寫法問題；`.tex` 正確但 PDF 不對 → 是 `thesisclass.cls` 或 `thesis.tex` 的設定問題。

## 怎麼讀 LaTeX 錯誤訊息

`.log` 檔很長，但有效資訊在固定位置：

1. 搜尋 `!` 開頭的行，那是錯誤本身。
2. 緊接著的 `l.NNN` 是出錯的行號（指向 `chapters/*.tex`，不是 Markdown）。
3. **第一個錯誤才是真的**。後面的錯誤往往是第一個造成的連鎖反應，修好第一個再重編。

`Overfull \hbox` 是警告不是錯誤，表示某行文字超出版面寬度。中文論文常見，通常可忽略；若 PDF 上看得出來文字溢出邊界才需要處理（改寫句子或在適當處斷行）。
