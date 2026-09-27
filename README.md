# thesis-writing skill

這是一套讓 AI 協助你撰寫學位論文的工作流程。你專心寫內容，排版與格式交給程式處理，一道指令就能產出符合學校規範的 PDF。

比較特別的地方在於，這套流程會要求 AI 在寫下任何一筆引用之前，先打開你電腦裡的文獻 PDF 核對原文，避免出現看似合理、實際上並不存在的文獻。

模板內建國立政治大學碩士論文格式。如果你是其他學校的學生，AI 會帶你完成格式調整。

---

## 流程說明

整套流程分成四個階段。

### 一、確認學校的格式規範

開始寫之前，先讓 AI 把格式規定確認清楚。

你告訴它你就讀的學校與系所，它會去查詢該校的論文格式規範，然後帶你逐項核對：邊界的尺寸、中文用什麼字型、章節標題如何編號、封面需要印哪些欄位、參考文獻採用哪一種格式。核對的結果會整理成 `THESIS-SPEC.md`，這份檔案往後就是你這本論文的格式依據。

建議不要略過這個步驟。不少人是在口試前一週才發現邊界不符合系所規定，回到 Word 裡調整一個設定，整份文件跟著跑版，圖表位置全部錯亂。這個階段完成之後，排版的部分就不需要再操心了。

### 二、撰寫內容

平常只需要編輯（你或者是 AI）一個檔案：`markdown/thesis.md`。章節編號、圖表編號、參考文獻的排序都由程式自動處理，中途插入一個小節也不會影響後面的編號。

動筆之前，建議先把文獻 PDF 放進 `literature/` 資料夾，檔名使用該文獻的引用代號：

```text
literature/bansal2005migrating.pdf  ←→  references.bib 裡的 @bansal2005migrating
```

有了這層對應關係，AI 在撰寫引用時就能打開對應的 PDF，確認原文確實有這樣的說法。

因此，當你請 AI 補一段文獻回顧、而你手邊還沒有相關文獻時，它會請你先提供 PDF，而不是直接寫出來。這是刻意的設計。AI 生成的虛構文獻往往相當逼真，期刊名稱正確、年份合理、標題也像模像樣，但口試委員查證時就會發現問題。

如果你已經有 Word 格式的論文稿，可以放進 `word-source/` 資料夾，AI 會先轉成 Markdown，再逐章協助你整理。公式與表格通常需要人工修整，一本完整的碩士論文大約需要半天到一天的時間。

### 三、產生 PDF

```bash
make
```

程式會把 Markdown 轉成 LaTeX，再編譯成 PDF。過程中會執行四次編譯（分別處理目錄、引用與頁碼），需要稍等一段時間屬於正常現象。隨時都可以執行。

### 四、送印前的檢查

口試通過之後，AI 會拿 `THESIS-SPEC.md` 重新核對一遍（規範有可能在你撰寫論文期間改版），檢查是否有引用了卻不在書目中的文獻，並提醒你補上系所核章的審定書掃描檔。

---

## 安裝方式

```bash
git clone https://github.com/hanyuany14/thesis-writing-skills.git
mkdir -p ~/.claude/skills
cp -R thesis-writing-skills/skills/thesis-writing ~/.claude/skills/
```

安裝完成後，在 Claude Code 裡說一句「幫我開始寫論文」就會載入。

如果你使用的是 Cursor、ChatGPT 或其他 AI 工具也沒問題。這個 skill 本身就是一組說明文件，把 `skills/thesis-writing/SKILL.md` 的內容提供給 AI 閱讀即可。

另外需要以下工具。不用自己先裝，第一次使用時 AI 會逐項檢查，缺什麼再帶你安裝：

| 工具 | 用途 | 安裝方式 |
| --- | --- | --- |
| Command Line Tools | 提供 make 與 Python | `xcode-select --install` |
| Homebrew | 安裝下面的工具 | 見 [brew.sh](https://brew.sh) |
| TeX Live | 產生 PDF | `brew install texlive` |
| Pandoc | 從 Word 匯入（選用） | `brew install pandoc` |

TeX Live 裝完約 4.7GB，下載需要 20 到 30 分鐘，請預留至少 10GB 的磁碟空間。

目前只在 macOS 上驗證過。Windows 使用者可以請 AI 參考這張清單，協助找出對應的安裝方式。

---

## 開始使用

先建立論文專案：

```bash
cp -R ~/.claude/skills/thesis-writing/assets/thesis-template/ ~/我的論文/
cd ~/我的論文
make          # 先確認環境能順利產生 PDF，再開始撰寫
```

接下來依照情境跟 AI 說明需求即可，不需要記任何指令：

| 你想做的事 | 可以這樣說 |
| --- | --- |
| 第一次開始 | 我要寫 OO 大學 OO 系的碩士論文，請幫我確認格式規範並完成設定 |
| 匯入 Word 稿 | 我的 Word 論文稿放在 `word-source/` 了，請幫我轉進這套流程 |
| 撰寫某一節 | 請幫我寫第二章文獻探討的第一節，文獻放在 `literature/` |
| 新增文獻 | 我放了三篇新的 PDF 進 `literature/`，請幫我建立 bib 條目 |
| 核對引用 | 請幫我核對第三章的所有引用，確認與原文一致 |
| 調整格式 | 系上要求邊界改成上下 3 公分，請幫我修改 |
| 編譯失敗 | `make` 執行失敗了，錯誤訊息是……（貼上內容） |
| 準備送印 | 我口試通過了，請幫我執行送印前的檢查 |

第一次對話時，AI 會主動詢問三件事：你的學校系所、是否已有 Word 稿、以及文獻 PDF 放在哪裡。

---

## 專案的檔案結構

```text
我的論文/
├── markdown/thesis.md      ★ 論文內容，平常只需要改這個檔案
├── THESIS-SPEC.md          ★ 格式依據，第一階段產出
├── references.bib          ★ 書目資料
├── literature/             ★ 文獻 PDF，檔名為引用代號
├── images/                 ★ 圖片
├── word-source/              Word 原稿放在這裡
└── （其餘檔案由 AI 在設定階段處理，平常不需要更動）
```

有一點需要留意：`chapters/` 資料夾裡的檔案每次執行 `make` 都會重新產生，請不要直接編輯，改動會在下次建置時消失。

其餘檔案（`thesisclass.cls` 負責排版規則、`thesisvars.tex` 存放封面資料、`thesis.tex` 是 LaTeX 主檔）都由 AI 在設定階段協助修改，你不需要具備 LaTeX 的知識。

---

## 論文的撰寫格式

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

你寫在標題裡的「1.1」只是方便自己辨識，PDF 中的編號由程式重新計算。

支援的語法有一定範圍，斜體、超連結、腳註與巢狀清單並不支援。完整的語法對照表請參考 `skills/thesis-writing/references/markdown-syntax.md`。

---

## 其他學校的格式調整

排版規則集中在 `thesisclass.cls` 這個檔案，AI 會依照 `references/format-settings.md` 的說明協助修改，你不需要直接接觸 LaTeX。

常見需要調整的項目包括：邊界（模板的上下邊界只有 1 公分，多數學校要求 2.54 至 3 公分）、章節編號的用字（模板使用「第一節」，不少學校採用 1.1 的形式）、封面欄位（模板沒有印學號）、引用格式（APA 第 7 版需要另外安裝套件），以及浮水印（預設為政大校徽）。

---

## 授權說明

- `thesisclass.cls` 與 `thesisvars.tex` 衍生自 Tz-Huan Huang 的台大 XeLaTeX 論文模板，採用 Chocolate-ware License，原始授權聲明保留在檔案內。
- `pdfs/watermark.pdf` 為國立政治大學校徽，著作權屬該校所有，僅供該校學生製作學位論文使用。
- 其餘文件與腳本採用 MIT License，詳見 [LICENSE](LICENSE)。

模板內的格式設定並不代表任何學校的官方規定，僅供核對時的參考起點。各校規範會不定期改版，正式送印前請以學校提供的官方文件為準，並向系所助教確認。
