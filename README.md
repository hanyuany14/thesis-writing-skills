# thesis-writing skill

一套讓 **AI 幫你寫學位論文**的完整工作流程。

你用 Markdown 專心寫內容，格式交給程式：一道指令就產出符合學校規範的 PDF。AI 是你的寫作助手，但受規則約束——**它不能捏造文獻**，每一筆引用都必須在你的文獻庫裡找得到原文。

內建**國立政治大學碩士論文**格式，並附完整流程協助你換成自己學校的規範。

---

## 這套工作流怎麼跑

四個階段。前三個都由 AI 帶著你做，你負責回答問題和確認內容。

| 階段 | 什麼時候 | 你做什麼 | AI 做什麼 | 產出 |
| --- | --- | --- | --- | --- |
| **① 設定格式** | 開工前，一次 | 告訴 AI 學校系所 | 找規範、逐項核對、改排版設定 | `THESIS-SPEC.md` |
| **② 寫作** | 論文期間，反覆循環 | 放文獻、給方向、審閱 | 寫內容、核對引用 | `markdown/thesis.md` |
| **③ 建置** | 隨時 | 執行 `make` | — | `thesis.pdf` |
| **④ 送印檢查** | 口試後 | 補審定書掃描檔 | 對照格式契約逐項驗收 | 送印版 PDF |

### ① 設定格式——先把規矩講定

**這是整套流程最重要的一步，也是最容易被跳過的一步。**

你只要說「我是 OO 大學 OO 系的碩士生」，AI 就會去找貴校的論文格式規範，然後帶你逐項核對：邊界幾公分、中文用什麼字型、章節標題怎麼編號、封面要印哪些欄位、參考文獻用哪種格式。

核對結果會寫成 `THESIS-SPEC.md`——**這份檔案就是你這本論文的格式契約**。之後任何格式爭議（「目錄到底要列到第幾層？」）都回頭查它，不用再翻學校網站。

做完這一步，排版就再也不用管了。後面無論寫多少內容，格式永遠一致。

> 為什麼重要：很多人是口試前一週才發現邊界不合規定，然後在 Word 裡改一個設定、整份文件跑版、圖表全部亂掉。這套流程把這個風險消滅在動筆之前。

### ② 寫作——你給素材，AI 寫，你審

這是你論文期間 95% 的時間都在做的事。

**你只需要改一個檔案**：`markdown/thesis.md`。不用管章節編號、不用管圖表編號、不用管參考文獻排序——那些 LaTeX 會自動處理。

寫作前先把**文獻 PDF 放進 `literature/`**，檔名就是引用代號：

```text
literature/bansal2005migrating.pdf  ←→  references.bib 裡的 @bansal2005migrating
```

這個對應關係是整套東西的關鍵。AI 要寫 `[@bansal2005migrating]` 這筆引用時，可以直接打開那份 PDF 確認「我寫的這句話，原文真的有這樣說嗎」。

**所以當你說「幫我補一段文獻回顧」而手上沒有文獻時，AI 會請你先提供 PDF，而不是先掰再說。** 這是刻意設計的限制。AI 生出來的假文獻看起來非常像真的——正確的期刊名、合理的年份、像模像樣的標題——但口試委員一查就知道。

已經有 Word 論文稿的話，這個階段是「搬遷整理」而不是從零寫：把 `.docx` 丟進 `word-source/`，AI 會轉成 Markdown 再逐章帶你整理。

### ③ 建置——一道指令出 PDF

```bash
make
```

背後發生的事：`markdown/thesis.md` → 程式轉成 LaTeX → XeLaTeX 編譯 → `thesis.pdf`。

編譯會跑四趟（產生目錄、解析引用、算頁碼、再確認一次），所以要等一下是正常的。

隨時可以跑，看排版就重跑一次。

### ④ 送印檢查——回頭驗收

口試通過後，AI 會拿 `THESIS-SPEC.md` 逐項重新核對（規範可能在你寫論文這一年改版了），跑一次引用完整性檢查（確認沒有引用了卻不在書目裡的文獻），再提醒你補上系所核章的審定書掃描檔。

---

## 這能幫你解決什麼

| 你的痛點 | 這套流程的作法 |
| --- | --- |
| Word 裡改一個標題格式，整份文件跑版 | 排版規則寫在一個設定檔裡，改一次全文一致 |
| 口試前才發現格式不合系所規定，重排一遍 | 動筆前就核對完並寫成契約檔 |
| AI 很會寫，但會生出不存在的文獻 | 每筆引用都必須對應到本地 PDF 原文，AI 讀過才能寫 |
| 改到後來不知道哪個版本是最新的 | 內容是純文字檔，可以用 git 看每次修改 |
| 參考文獻手動排序、格式對不齊 | 書目由 `references.bib` 自動產生 |

---

## 安裝

```bash
git clone https://github.com/hanyuany14/thesis-writing-skills.git
mkdir -p ~/.claude/skills
cp -R thesis-writing-skills/skills/thesis-writing ~/.claude/skills/
```

裝好後在 Claude Code 裡說「幫我開始寫論文」就會自動載入。

**用其他 AI 工具**（Cursor、Copilot、ChatGPT 等）也可以——這個 skill 本質上就是一組 Markdown 說明文件。把 `skills/thesis-writing/SKILL.md` 貼給 AI 讀，它就知道整套流程了；需要細節時再貼對應的 `references/*.md`。

### 需要的環境

| 工具 | 用途 | 怎麼裝 |
| --- | --- | --- |
| XeLaTeX + BibTeX | 產生 PDF | macOS 裝 [MacTeX](https://tug.org/mactex/)；Linux `apt install texlive-full` |
| Python 3.9+ | Markdown → LaTeX 轉換 | 系統通常內建 |
| make | 建置流程 | macOS 裝 Xcode Command Line Tools |
| Pandoc | 從 Word 匯入（選用） | `brew install pandoc` |

MacTeX 大約 5GB，下載要一段時間，建議先開始裝再看下面的說明。

---

## 怎麼讓你的 AI 用這套流程

建立論文專案：

```bash
cp -R ~/.claude/skills/thesis-writing/assets/thesis-template/ ~/我的論文/
cd ~/我的論文
make          # 先確認環境能出 PDF，再開始寫內容
```

然後照情境對 AI 說話就好——**不需要記指令，AI 知道該做什麼**：

| 你想做什麼 | 對 AI 說 |
| --- | --- |
| 第一次開始 | 我要寫 **OO 大學 OO 系**的碩士論文，幫我確認格式規範並完成設定 |
| 有 Word 稿要搬 | 我的 Word 論文稿放在 `word-source/` 了，幫我轉進這套流程 |
| 開始寫某一節 | 幫我寫第二章文獻探討的第一節，文獻我放在 `literature/` 了 |
| 加新文獻 | 我放了三篇新的 PDF 進 `literature/`，幫我建好 bib 條目 |
| 檢查引用 | 幫我核對第三章所有引用，確認跟原文說的一致 |
| 改格式 | 系上說邊界要改成上下 3 公分，幫我改 |
| 編譯出錯 | `make` 失敗了，錯誤訊息是……（貼上） |
| 準備送印 | 我口試通過了，幫我跑送印前的檢查 |

第一次對話時，AI 會主動問你三件事：**學校系所**（決定格式）、**有沒有 Word 稿**（決定是搬遷還是從零寫）、**文獻 PDF 在哪**（決定能不能開始寫引用）。

---

## 資料夾與重要檔案

安裝後你會接觸到兩個地方：**skill 本身**（AI 讀的說明書）和**你的論文專案**（你實際工作的地方）。

### 你的論文專案

從 `assets/thesis-template/` 複製出來的，是你每天打開的資料夾：

```text
我的論文/
├── markdown/thesis.md      ★ 論文內容，唯一要改的檔案
├── THESIS-SPEC.md          ★ 格式契約，設定階段產出
├── references.bib          ★ 書目資料庫
├── literature/             ★ 文獻 PDF，檔名 = 引用代號
├── images/                 ★ 論文圖片
├── word-source/              Word 原稿（要匯入的話放這）
│
├── thesisclass.cls           排版規則（邊界、行距、章節格式、封面）
├── thesisvars.tex            封面資料（系所、題目、指導教授）
├── thesis.tex                LaTeX 主檔（字型、前置頁順序）
├── scripts/                  轉換器與 Word 匯入工具
├── Makefile                  建置流程
├── chapters/                 自動產生，不要手改
└── pdfs/watermark.pdf        浮水印（預設政大校徽）
```

★ 標記的是你會實際碰到的。下半部是 AI 在設定階段會幫你改的，平常不用管。

**最重要的一條規則：只改 `markdown/thesis.md`。** `chapters/` 裡的檔案每次 `make` 都會被覆寫，寫在那裡的東西會消失。

### skill 本體

AI 讀的說明書，你平常不用打開：

```text
skills/thesis-writing/
├── SKILL.md                      # AI 入口：工作流與協作規則
├── references/
│   ├── format-settings.md        # 格式設定清單（現值 + 改法）
│   ├── import-from-word.md       # 從 Word 搬進來的完整流程
│   ├── literature.md             # 文獻管理與引用核對
│   ├── markdown-syntax.md        # 支援的 Markdown 語法
│   └── troubleshooting.md        # 疑難排解
└── assets/thesis-template/       # 論文專案範本（就是上面那包）
```

想知道 AI 為什麼這樣做事，或想調整它的行為，改 `SKILL.md`。

---

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
| --- | --- | ---: |
| 慣性 | 維持既有使用方式的傾向 | 3.05 |
```

章節編號、圖表編號、交叉引用、參考文獻都由 LaTeX 自動處理——你在 Markdown 裡寫的「1.1」只是給自己看的，PDF 裡的編號是程式重新算的。所以中間插入一節不會打亂後面的編號。

轉換器只支援特定語法子集（**不支援**斜體、超連結、腳註、巢狀清單），完整對照表在 `references/markdown-syntax.md`。

---

## 換成其他學校

模板的排版規則全部集中在 `thesisclass.cls`（字型例外，在 `thesis.tex`）。`references/format-settings.md` 列出每一項現行設定與對應的修改位置，AI 照著改即可——你不需要懂 LaTeX。

常見要調整的：

- **邊界**：模板上下只有 1cm，多數學校要 2.54～3cm
- **章節編號用字**：模板用「第一節」，很多學校用 1.1
- **封面欄位**：模板不印學號，部分學校要求
- **引用格式**：APA 第 7 版需加裝 `biblatex-apa` 套件
- **浮水印**：預設是政大校徽，要換成貴校的

---

## 授權

- `thesisclass.cls` 與 `thesisvars.tex` 衍生自 Tz-Huan Huang 的台大 XeLaTeX 論文模板，採 **Chocolate-ware License**，原始授權聲明保留在檔案內。
- `pdfs/watermark.pdf` 是國立政治大學校徽，著作權屬該校，僅供政大學生製作論文使用。其他學校請換成貴校提供的浮水印。
- 其餘文件與腳本採 **MIT License**，見 [LICENSE](LICENSE)。

## 免責

模板內的格式設定**不代表任何學校的官方規定**，僅供比對起點。各校規範會改版，正式送印前一律以你從學校取得的官方文件為準，並請系所助教確認。
