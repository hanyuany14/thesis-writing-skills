# thesis-writing skill

讓 AI 幫你寫論文，而且不會幫你掰文獻。

你專心寫內容，格式交給程式——一道指令產出符合學校規範的 PDF。預設是政大碩論格式，換別的學校 AI 會帶你改。

---

## 怎麼運作

### 開工前，先把格式講定

你跟 AI 說「我是 OO 大學 OO 系的碩士生」，它就去找你們學校的論文格式規範，帶你一項一項核對：邊界幾公分、用什麼字型、章節怎麼編號、封面要印哪些欄位。結果寫成 `THESIS-SPEC.md`，這份檔案之後就是你這本論文的格式標準。

**這步不要跳過。** 很多人是口試前一週才發現邊界不合規定，然後在 Word 裡改一個設定、整份文件跑版、圖表全部亂掉。這步做完，排版你就再也不用管了。

### 然後就是寫

只改一個檔案：`markdown/thesis.md`。章節編號、圖表編號、參考文獻排序都是程式自動算的，中間插一節不會打亂後面。

寫之前先把文獻 PDF 丟進 `literature/`，檔名用引用代號：

```text
literature/bansal2005migrating.pdf  ←→  references.bib 的 @bansal2005migrating
```

這樣 AI 要寫這筆引用時，可以打開 PDF 確認原文真的有這樣說。

**所以當你說「幫我補一段文獻回顧」而手上沒文獻時，它會要你先給 PDF，不會先掰再說。** 這是故意的。AI 生出來的假文獻看起來超級真——期刊名正確、年份合理、標題也像那麼回事——但口試委員一查就露餡。

已經有 Word 稿的話，丟進 `word-source/`，AI 會轉成 Markdown 再逐章帶你整理。公式和表格多半要手動修，一本完整的碩論大概要花半天到一天。

### 要看成果就 `make`

```bash
make
```

Markdown → LaTeX → PDF。會跑四趟（算目錄、解引用、排頁碼），等一下是正常的。隨時可以跑。

### 口試完，回頭驗收

AI 拿 `THESIS-SPEC.md` 重新核對一遍（規範可能在你寫論文這一年改版了），檢查有沒有引用了卻不在書目裡的文獻，再提醒你補上系所核章的審定書掃描檔。

---

## 安裝

```bash
git clone https://github.com/hanyuany14/thesis-writing-skills.git
mkdir -p ~/.claude/skills
cp -R thesis-writing-skills/skills/thesis-writing ~/.claude/skills/
```

裝好後在 Claude Code 說「幫我開始寫論文」就會載入。

用 Cursor、ChatGPT 之類的也行——這 skill 本質上就是一組說明文件，把 `skills/thesis-writing/SKILL.md` 貼給 AI 讀就好。

還需要這些工具：

| 工具 | 用途 | 怎麼裝 |
| --- | --- | --- |
| XeLaTeX + BibTeX | 產生 PDF | macOS 裝 [MacTeX](https://tug.org/mactex/)；Linux `apt install texlive-full` |
| Python 3.9+ | Markdown → LaTeX | 通常系統內建 |
| make | 建置 | macOS 裝 Xcode Command Line Tools |
| Pandoc | 從 Word 匯入（選用） | `brew install pandoc` |

MacTeX 有 5GB，先開始下載再看下面。

---

## 開始用

```bash
cp -R ~/.claude/skills/thesis-writing/assets/thesis-template/ ~/我的論文/
cd ~/我的論文
make          # 先確認環境能出 PDF，再開始寫
```

然後照情境跟 AI 講話就好，不用記指令：

| 你想做什麼 | 就說 |
| --- | --- |
| 第一次開始 | 我要寫 OO 大學 OO 系的碩士論文，幫我確認格式規範並完成設定 |
| 有 Word 稿要搬 | 我的 Word 稿放在 `word-source/` 了，幫我轉進這套流程 |
| 寫某一節 | 幫我寫第二章文獻探討的第一節，文獻我放在 `literature/` 了 |
| 加新文獻 | 我放了三篇新 PDF 進 `literature/`，幫我建好 bib 條目 |
| 檢查引用 | 幫我核對第三章所有引用，確認跟原文一致 |
| 改格式 | 系上說邊界要改成上下 3 公分，幫我改 |
| 編譯出錯 | `make` 失敗了，錯誤訊息是……（貼上） |
| 準備送印 | 我口試通過了，幫我跑送印前的檢查 |

第一次對話時 AI 會主動問你三件事：學校系所、有沒有 Word 稿、文獻 PDF 在哪。

---

## 你會碰到的檔案

```text
我的論文/
├── markdown/thesis.md      ★ 論文內容，只改這裡
├── THESIS-SPEC.md          ★ 格式標準，設定階段產出
├── references.bib          ★ 書目資料
├── literature/             ★ 文獻 PDF，檔名 = 引用代號
├── images/                 ★ 圖片
├── word-source/              Word 原稿放這裡
└── （其他都是 AI 幫你設定的，平常不用管）
```

**唯一要記住的規則：只改 `markdown/thesis.md`。** `chapters/` 裡的檔案每次 `make` 都會重新產生，寫在那裡的東西會不見。

其餘檔案（`thesisclass.cls` 排版規則、`thesisvars.tex` 封面資料、`thesis.tex` 主檔）是 AI 在設定階段會幫你改的，你不用懂 LaTeX。

---

## 論文寫起來長這樣

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

你寫的「1.1」只是給自己看的，PDF 裡的編號是程式重新算的。

支援的語法有限（**不支援**斜體、超連結、腳註、巢狀清單），完整清單在 `skills/thesis-writing/references/markdown-syntax.md`。

---

## 換成別的學校

排版規則都集中在 `thesisclass.cls`，AI 照著 `references/format-settings.md` 改就行，你不用碰 LaTeX。

通常要改的：邊界（模板上下只有 1cm，多數學校要 2.54～3cm）、章節編號用字（模板用「第一節」，很多學校用 1.1）、封面欄位（模板不印學號）、引用格式（APA 7 要加裝套件）、浮水印（預設是政大校徽）。

---

## 授權

- `thesisclass.cls` 與 `thesisvars.tex` 衍生自 Tz-Huan Huang 的台大 XeLaTeX 論文模板，採 Chocolate-ware License，原始聲明保留在檔案內。
- `pdfs/watermark.pdf` 是政大校徽，著作權屬該校，僅供政大學生製作論文使用。
- 其餘採 MIT License，見 [LICENSE](LICENSE)。

模板裡的格式設定**不代表任何學校的官方規定**，只是比對的起點。各校規範會改版，送印前請以學校官方文件為準，並找系所助教確認。
