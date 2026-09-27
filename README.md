# thesis-writing skill

一套給 **AI 協作寫學位論文**的工作流程。你用 Markdown 寫，程式自動轉成符合學校格式規範的 LaTeX 與 PDF；AI 幫你寫作，但受規則約束——不能捏造文獻。

```text
① 設定格式  →  ② 寫作 Markdown  →  ③ 一道指令出 PDF  →  ④ 送印檢查
   一次性        AI 協作，反覆循環      make              口試後
```

內建**國立政治大學碩士論文**格式，並附完整流程協助你換成自己學校的規範。

## 這套東西解決什麼

寫論文時最花時間的往往不是寫，是：

- **排版**：Word 裡調一個標題格式，整份文件跑版。
- **格式規範**：口試前才發現邊界、字型、封面欄位不合系所規定，重排一遍。
- **引用**：AI 很會寫，但會生出不存在的文獻，而且看起來非常像真的。

這個 skill 的對策分別是：排版交給 LaTeX（改一次設定，全文一致）；格式規範在**動筆前**就核對完並寫成契約檔；每一筆引用都必須對應到本地文獻庫裡的 PDF 原文。

## 安裝

```bash
git clone https://github.com/<你的帳號>/thesis-writing-skills.git
mkdir -p ~/.claude/skills
cp -R thesis-writing-skills/skills/thesis-writing ~/.claude/skills/
```

裝好後在 Claude Code 裡問「幫我開始寫論文」就會自動載入。

**用其他 AI 工具**（Cursor、Copilot、ChatGPT 等）也可以——這個 skill 就是一組 Markdown 文件，把 `skills/thesis-writing/SKILL.md` 貼給 AI 讀，它就知道流程了。需要細節時再貼對應的 `references/*.md`。

### 需要的環境

| 工具 | 用途 | 安裝 |
|---|---|---|
| XeLaTeX + BibTeX | 產生 PDF | macOS 裝 [MacTeX](https://tug.org/mactex/)；Linux `apt install texlive-full` |
| Python 3.9+ | Markdown → LaTeX 轉換 | 系統通常內建 |
| make | 建置流程 | macOS 裝 Xcode Command Line Tools |
| Pandoc | 從 Word 匯入（選用） | `brew install pandoc` |

## 開始使用

建立論文專案：

```bash
cp -R ~/.claude/skills/thesis-writing/assets/thesis-template/ ~/我的論文/
cd ~/我的論文
make          # 先確認環境能出 PDF，再開始寫
```

然後對你的 AI 說：

> 我要寫 **OO 大學 OO 系**的碩士論文，幫我確認格式規範並完成設定。

AI 會依 skill 的流程：問清楚你的學校系所 → 找出官方格式規範 → 帶你逐項核對 `THESIS-SPEC.md` → 改掉與模板不同的排版設定。**這一步做完再開始寫內容**，可以省下口試前重排全文的痛苦。

設定完成後的日常：

> 幫我寫第二章文獻探討的第一節，文獻我放在 literature/ 了。

## 工作流

### ① 設定格式

模板預設政大格式。AI 會協助你取得貴校規範、逐項比對、修改設定，並把結論寫進 `THESIS-SPEC.md`——這份檔案之後就是你這本論文的**格式契約**，任何格式爭議都回頭查它。

### ② 寫作

只改 `markdown/thesis.md` 一個檔案。文獻 PDF 放 `literature/`，**檔名就是 citation key**：

```text
literature/bansal2005migrating.pdf  ←→  references.bib 的 @bansal2005migrating
```

這個對應關係讓 AI 能從引用直接找到原文核對。skill 規定 AI 寫下任何引用前必須確認：citekey 在 bib 裡、PDF 存在、而且**讀過相關段落確認敘述與原文一致**。

所以當你說「幫我補一段文獻回顧」而手上沒文獻時，AI 會請你先提供 PDF，而不是先掰再說。這是刻意設計的——這是整套東西最有價值的部分。

### ③ 建置

```bash
make              # 產出 thesis.pdf
make convert      # 只做 Markdown → LaTeX，用來檢查轉換結果
make watermarked  # 含浮水印版本
make clean        # 清掉所有產物
```

### ④ 送印檢查

口試後回頭用 `THESIS-SPEC.md` 逐項驗收、跑引用完整性檢查、補上審定書掃描檔。

## Markdown 寫起來長這樣

```markdown
# 第一章　緒論 {#c:intro}

## 1.1　研究背景

近年來生成式 AI 快速發展 [@gupta2024generative]。@bansal2005migrating 指出，
使用者的服務轉換行為受推力、拉力與繫住力共同影響。

$$
y_i = \alpha + \beta x_i + \varepsilon_i
\tag{1.1}
$$

![圖 1.1 研究架構](images/framework.png){#fig:framework}

表 1.1 變數操作型定義

| 變數 | 說明 | 平均數 |
|---|---|---:|
| 慣性 | 維持既有使用方式的傾向 | 3.05 |
```

章節編號、圖表編號、交叉引用、參考文獻都由 LaTeX 自動處理。你在 Markdown 裡寫的編號只是給自己看的。

轉換器只支援特定語法子集（不支援斜體、超連結、腳註、巢狀清單），完整對照表在 `references/markdown-syntax.md`。

## repo 結構

```text
skills/thesis-writing/
├── SKILL.md                      # AI 入口：工作流與協作規則
├── references/
│   ├── format-settings.md        # 格式設定清單（現值 + 改法）
│   ├── literature.md             # 文獻管理與引用核對
│   ├── markdown-syntax.md        # 支援的 Markdown 語法
│   └── troubleshooting.md        # 疑難排解
└── assets/thesis-template/       # 整包複製走就能用的論文專案
    ├── THESIS-SPEC.md            # 格式規範對照表（預填政大現值）
    ├── markdown/thesis.md        # 論文內容，唯一手改的檔案
    ├── literature/               # 文獻 PDF（不進 git）
    ├── references.bib            # 書目資料庫
    ├── thesisclass.cls           # 排版規則
    ├── thesisvars.tex            # 封面資料
    ├── thesis.tex                # LaTeX 主檔
    ├── scripts/                  # 轉換器與 Word 匯入工具
    └── Makefile
```

## 換成其他學校

模板的排版全部集中在 `thesisclass.cls`（字型例外，在 `thesis.tex`）。`references/format-settings.md` 列出每一項現行設定與對應的修改位置，AI 照著改即可。

常見要調整的：邊界（模板上下只有 1cm，多數學校要 2.54～3cm）、章節編號用字（模板用「第一節」，很多學校用 1.1）、封面欄位（模板不印學號）、引用格式（APA 7 需加裝 `biblatex-apa`）。

## 授權

- `skills/thesis-writing/assets/thesis-template/thesisclass.cls` 與 `thesisvars.tex` 衍生自 Tz-Huan Huang 的台大 XeLaTeX 論文模板，採 **Chocolate-ware License**，原始授權聲明保留在檔案內。
- `pdfs/watermark.pdf` 是國立政治大學校徽，著作權屬該校，僅供政大學生製作論文使用。其他學校請換成貴校提供的浮水印。
- 其餘文件與腳本採 **MIT License**，見 [LICENSE](LICENSE)。

## 免責

模板內的格式設定**不代表任何學校的官方規定**，僅供比對起點。各校規範會改版，正式送印前一律以你從學校取得的官方文件為準，並請系所助教確認。
