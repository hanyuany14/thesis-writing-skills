# 格式設定清單

模板預設實作**國立政治大學碩士學位論文**格式。本文件列出所有現行設定值與修改位置，供逐項核對。

核對流程：對照貴校規範，把有差異的項目改掉，並把結論記在專案根目錄的 `THESIS-SPEC.md`（模板已附預填版本）。

> **現值僅供比對，不是任何學校的官方規定。** 規範會改版，一律以使用者取得的官方文件為準。

## 現行設定一覽

### 版面

| 項目 | 現值 | 改哪裡 |
|---|---|---|
| 紙張 | A4 | `thesisclass.cls` → `\LoadClass[a4paper,12pt,oneside]{book}` |
| 內文字級 | 12pt | 同上（LaTeX 只吃 10/11/12pt） |
| 單／雙面 | 單面 | 同上，`oneside` → `twoside` |
| 邊界 | 上 1cm、下 1cm、左右各 2.54cm，含頁首頁尾 | `thesisclass.cls` → `\RequirePackage[...]{geometry}` |
| 內文行距 | 1.62 倍 | `thesisclass.cls` → `\def\@onehalfline{1.62}` |
| 英文摘要行距 | 1.9 倍 | `thesisclass.cls` → `\def\@doubleline{1.9}` |
| 段落首行縮排 | 2 字元 | `thesisclass.cls` → `\setlength{\parindent}{2em}` |

⚠️ **邊界務必核對。** 模板上下邊界只有 1cm，與多數學校常見的「上下左右 2.54～3cm」差很多。裝訂邊（通常左側）若規定 3～3.5cm，改成 `left=3.5cm`。

⚠️ **行距換算。** `\setstretch` 的倍率不等於 Word 的「1.5 倍行距」。規範若寫死 pt 值，改用 `\setlength{\baselineskip}{Xpt}` 並印出來實際量測。

### 字型（設定在 `thesis.tex`，不在 cls）

| 用途 | 現值 | 找不到時的備援 |
|---|---|---|
| 中文 | 標楷體 `BiauKaiTC` | `Kaiti TC` → `FandolKai-Regular` |
| 英數 | Times New Roman | TeX Gyre Termes |
| 等寬 | `lmmono10-regular.otf` | 無 |

改中文字型就換 `\setCJKmainfont` 的字型名（新細明體 `PMingLiU`、宋體 `Songti TC`、黑體 `Heiti TC`）。字型名必須與系統安裝名完全相同，用 `fc-list :lang=zh family` 查。字型不存在時 XeLaTeX 會直接報錯，不會默默替換。

**保留 `\IfFontExistsTF` 的備援結構**，只改字型名——這樣換機器時才不會編不出來。

### 章節標題（`thesisclass.cls` 的 `\ifzh` 區塊，檔案後段）

| 層級 | Markdown | 現值 |
|---|---|---|
| 章 | `#` | 18pt 粗體、置中、標示「第一章」 |
| 節 | `##` | 16pt 粗體、置中、標示「第一節」 |
| 小節 | `###` | 14pt 粗體、靠左、標示「一、」 |
| 小小節 | `####` | 12pt 粗體、靠左、標示「1. 」 |

⚠️ `\naiveZhNum` 只支援 1–9。超過 9 章（或某章超過 9 節）該編號會變成阿拉伯數字。

### 前置頁

現行順序（定義在 `thesis.tex`）：封面 → 審定書（預設註解掉）→ 誌謝 → 中文摘要 → 英文摘要 → 目錄 → 圖目錄 → 表目錄 → 正文。

| 項目 | 現值 |
|---|---|
| 封面頁碼 | 不編號 |
| 前置頁頁碼 | 羅馬數字 i, ii, iii |
| 正文頁碼 | 阿拉伯數字，從 1 重新起算 |
| 目錄收錄深度 | 到「節」（`tocdepth=2`） |
| 標題編號深度 | 到「小節」（`secnumdepth=3`） |
| 目錄標題字級 | 16pt 粗體置中 |

### 封面欄位

由上而下：學校系所（18pt）→ 學位論文（18pt）→ 中文題目（20pt）→ 英文題目（16pt）→ 指導教授（18pt）→ 研究生（18pt）→ 中華民國年月（18pt）。

⚠️ 模板封面**不印學號、不印系所英文名、不印完整口試日期**。部分學校要求這些欄位。

資料填在 `thesisvars.tex`，版面排在 `thesisclass.cls` 的 `\makecover`。

### 圖表

| 項目 | 現值 |
|---|---|
| 圖標題 | 圖下方 |
| 表標題 | 表上方 |
| 編號 | 依章編號（圖 1.1、表 2.3） |
| 表格線 | 三線表（booktabs，APA 風格） |
| 標題與編號分隔 | 空格 |

### 參考文獻

| 項目 | 現值 |
|---|---|
| 引用樣式 | `authoryear`（作者—年份） |
| 姓名順序 | 姓在前 |
| 名字 | 縮寫為首字母 |
| 內文最多列 | 2 位作者，超過用 et al. |
| 書目最多列 | 99 位作者 |

設定在 `thesis.tex` 的 `\usepackage[...]{biblatex}`。

⚠️ **中英文文獻混排**（中文在前、英文在後，中文不縮寫名字）模板沒有內建，需要時另外設定 `\DeclareSortingTemplate`。

### 浮水印

`pdfs/watermark.pdf` 是政大校徽。其他學校換掉同名檔案，或不執行 `make watermarked`。位置微調在 `src/with-watermark.tex`。

多數學校只有**紙本送印版**要浮水印，電子上傳版不用。

---

## 常見修改做法

改完一定重跑 `make`。**一次只改一項再重編**，比一口氣改完再 debug 快得多。

### 改邊界

```latex
% thesisclass.cls
\RequirePackage[top=3cm,left=3.5cm,bottom=3cm,right=2.5cm]{geometry}
```

拿掉 `includeheadfoot` 後，邊界指的是內文區域到紙緣的距離（更貼近規範字面）。

### 改章節標題格式

每個層級一組 `\titleformat` + `\titlespacing`：

```latex
\titleformat{\chapter}
  {\centering\fontsize{18}{20.7}\selectfont\bfseries}  % ← 字級與對齊
  {第\naiveZhNum{\arabic{chapter}}章}{1em}{}           % ← 編號文字
\titlespacing*{\chapter}{0pt}{-3em}{9pt}               % ← 左縮排、上距、下距
```

| 要求 | 改法 |
|---|---|
| 標題靠左 | 拿掉 `\centering` |
| 節編號用 `1.1` 而非「第一節」 | 編號參數改成 `{\thesection}` |
| 章編號用「第1章」 | 改成 `{第\arabic{chapter}章}` |
| 標題字級 | 改 `\fontsize{字級}{行高}`，行高慣例為字級的 1.15～1.5 倍 |
| 標題與內文間距 | 改 `\titlespacing*` 第四個參數 |

`\titlespacing*{\chapter}` 上距是負值 `-3em`（把章標題往上拉）。改邊界後章標題位置跑掉，優先調這個。

### 改封面欄位

`\makecover` 是一個 `center` 環境，照既有模式插入即可。例如加學號：

```latex
研究生：\@authorzh\quad 撰\par
\vspace{0.5cm}
學號：\@studentid\par
```

可用資料：`\@universityzh`、`\@collegezh`、`\@institutezh`、`\@titlezh`、`\@titleen`、`\@authorzh`、`\@advisorzh`、`\@studentid`、`\@yearzh`、`\@monthzh`、`\@day`，皆有對應 `en` 版本。

**用學校官網的封面 Word 範本逐字比對**（「指導教授：」後面有沒有「博士」、有沒有「撰」字）。

### 改前置頁順序或名稱

順序直接調整 `thesis.tex` 中對應區塊的先後。名稱改這兩行（例如用「謝誌」而非「誌謝」）：

```latex
% thesisclass.cls
\abstractname{Abstract}{摘要}
\acknowledgements{Acknowledgements}{誌謝}
```

目錄相關用語改這裡：

```latex
\renewcommand{\contentsname}{目錄}
\renewcommand{\listfigurename}{圖目錄}
\renewcommand{\listtablename}{表目錄}
\renewcommand{\bibname}{參考文獻}
```

參考文獻標題另外還要改 `thesis.tex` 的 `\printbibliography[...,title={參考文獻}]`。

### 改引用格式

```latex
% thesis.tex
\usepackage[backend=bibtex, style=apa, ...]{biblatex}
```

APA 第 7 版需另外安裝 `biblatex-apa` 套件。

### 加審定書

口試通過後取得系所核章的掃描檔，存成 `pdfs/cert.pdf`，取消 `thesis.tex` 這行的註解：

```latex
\includepdf[pages={1}]{pdfs/cert.pdf}
```

cls 裡的 `\makecertification` 只能排版空白審定書供預覽，**正式論文一律用掃描檔**。

### 博士論文

`thesis.tex` 第一行改成：

```latex
\documentclass[zh,phd]{thesisclass}
```

### 中文粗體太粗／太細

標楷體沒有粗體字重，模板用描邊模擬：

```latex
\def\xeCJKembold{0.4}   % 建議範圍 0.2～0.6
```

### 附錄

在 `thesis.tex` 的 `\backmatter` 之前呼叫（注意要包 `\makeatletter`）：

```latex
\makeatletter
\@startappendix
\makeatother
```
