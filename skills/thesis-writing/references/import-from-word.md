# 從 Word 匯入

適用於使用者手上已經有 Word 論文稿（初稿、指導教授改過的版本、或整本寫完只是要換排版）的情況。

**這是一次性的搬遷工程，不是一鍵轉換。** Pandoc 能把文字與結構搬過來，但公式、表格與引用幾乎都需要人工修整。一本完整的碩士論文，預期要花半天到一天整理。

先評估值不值得：如果論文已經寫完、格式也符合規定、只差口試，那留在 Word 就好。這套流程的價值在**還要繼續改**的稿子——改完一個設定全文一致、版本控制看得到每次修改、AI 能核對引用。

## 步驟

### 1. 把 Word 檔放進 `word-source/`

```bash
cp ~/Desktop/我的論文.docx word-source/
```

原始檔留在這裡當**核對基準**，全程不要刪。整理過程中一定會遇到「這裡原本長怎樣」的疑問。

### 2. 執行匯入

```bash
./scripts/import_docx_to_md.sh
```

不帶參數時會自動抓 `word-source/` 裡的 `.docx`。裡面有多份時腳本會列出來要你指定：

```bash
./scripts/import_docx_to_md.sh word-source/論文_v3_final.docx
```

產出：

| 檔案 | 說明 |
| --- | --- |
| `markdown/imported-from-word.md` | 轉換結果，**中間檔** |
| `markdown/imported-media/` | 從 Word 抽出的圖片 |

重複執行會自動備份上一次的結果為 `imported-from-word.YYYYMMDD-HHMMSS.md`。

### 3. 快速掃一遍，決定整理策略

打開 `imported-from-word.md` 先看整體品質：

- **標題階層對不對**（`#`、`##`、`###`）。Word 裡若沒用「標題1／標題2」樣式而是手動加粗放大，Pandoc 抓不到階層，會全部變成普通段落——這種情況要逐章重下標題。
- **公式變成什麼樣子**。Word 內建方程式多半轉不完整，OMML 複雜結構會掉。
- **表格有沒有跨欄合併**。合併儲存格會變成 HTML `<table>`（轉換器支援）或結構錯亂。
- **引用是純文字還是 EndNote 域碼**。

### 4. 逐章搬進 `markdown/thesis.md`

**不要**把 `imported-from-word.md` 改名成 `thesis.md`。一次搬一章，搬完一章跑一次 `make`，問題及早暴露。整章整章搬的好處是出錯時知道問題在哪一章。

每搬一章，對照原始 Word 檢查：

- [ ] 標題階層正確（章 `#`、節 `##`、小節 `###`，最多到 `####`）
- [ ] 段落沒有被合併或切斷
- [ ] 公式可以正常編譯
- [ ] 表格完整，標題行寫成 `表 1.1 標題` 且在表格上方
- [ ] 圖片路徑讀得到，圖說寫成 `![圖 1.1 說明](路徑)`
- [ ] 引用改成 `[@citekey]` 或 `@citekey`，且 bib 裡有對應條目
- [ ] 沒有殘留的 Word 樣式雜訊（`**​**` 空粗體、多餘空行、`\`轉義符號）

### 5. 全部搬完後

```bash
make clean && make
```

把產出的 PDF 跟原始 Word 逐頁對照，確認沒有整段遺失。特別檢查表格多、公式多的章節。

## 各類內容的處理

### 標題

Pandoc 只認得 Word 的**標題樣式**（「標題 1」「標題 2」）。手動加粗放大的偽標題會變成普通段落。

轉出來的標題常帶著原本的編號：

```markdown
# 第一章 緒論
## 1.1 研究背景
```

保留沒關係——轉換器會自動剝掉編號，由 LaTeX 重新編號。但要確認**階層**是對的。

### 公式

這是最需要人工的部分。Word 方程式（OMML）經 Pandoc 轉換後，簡單的行內符號多半還可以，多層分數、矩陣、對齊的多行方程式常會掉結構。

做法：對照原始 Word，用 LaTeX 語法重打。

```markdown
$$
\text{PsyAcc}_i = \beta_0 + \beta_1 \text{Dissat}_i + \beta_2 \text{Attract}_i + \varepsilon_i
\tag{3.1}
$$
```

`\tag{}` 會產生編號，沒有 `\tag{}` 就是不編號的公式。行內符號用 `$x_i$`。

數量多時，建議先全部搬完文字，最後統一處理公式——重複做同一類工作比較快，也比較不會漏。

### 表格

Pandoc 產生的 Markdown 表格通常可以直接用。要補的是**標題行**：

```markdown
表 3.2 樣本結構分析

| 變數 | 類別 | 人數 | 百分比 |
| --- | --- | ---: | ---: |
| 性別 | 男 | 142 | 46.7 |
|  | 女 | 162 | 53.3 |
```

標題必須是 `表 3.2 標題文字` 的格式、且緊接在表格上方，轉換器才會產生 `\caption` 與 `\label{tab:3-2}`。沒有標題行的表格不會出現在表目錄。

跨欄合併的表格會變成 HTML `<table>`，轉換器支援（`colspan` 會補空欄、`<br>` 轉成全形分號），但版面通常不理想，建議改寫成單純的 Markdown 表格。

欄位對齊由轉換器自動判斷，Word 裡的對齊設定不會保留。

### 圖片

圖片抽到 `markdown/imported-media/media/image1.png` 這種路徑。`thesis.tex` 的 `\graphicspath` 已掛上 `markdown/`，所以可以直接這樣寫：

```markdown
![圖 2.1 研究架構](imported-media/media/image1.png){#fig:framework}
```

建議整理時**改成有意義的檔名**並搬到 `images/`：

```bash
mv markdown/imported-media/media/image1.png images/research-framework.png
```

`image1`、`image2` 這種檔名，三個月後回來改論文時會完全不知道是哪張圖。

Word 裡的圖說通常是圖片下方的獨立段落，要改寫成 Markdown 的圖說語法。

### 引用（最麻煩的部分）

Word 稿的引用有兩種形態，處理方式不同：

**A. 純文字引用**（手動打的 `(Bansal et al., 2005)`）

Pandoc 原樣搬過來。要逐筆改成 citekey，並在 `references.bib` 建立條目：

```markdown
轉換行為受推力、拉力與繫住力共同影響 [@bansal2005migrating]。
```

**B. EndNote／Zotero 域碼**

Pandoc 通常會轉成純文字引用，但有時會帶出域碼殘骸（`ADDIN EN.CITE` 之類的字串）。看到就刪掉，改成 citekey。

**建立 bib 的順序建議：**

1. 先從 Word 的**參考文獻清單**（論文最後那一節）把所有文獻建進 `references.bib`，一次做完。EndNote／Zotero 使用者直接匯出 BibTeX 最快。
2. 決定 citekey 命名慣例：`姓氏年份關鍵字`，全小寫（`bansal2005migrating`）。
3. 把文獻 PDF 放進 `literature/`，檔名就是 citekey。
4. 最後才回頭把正文的純文字引用逐筆換成 citekey。

反過來做（邊搬正文邊建 bib）會一直中斷，而且容易建出重複條目。

**搬完後一定要跑完整性檢查**（腳本在 `literature.md`），確認正文引用的 key 都在 bib 裡——漏掉的會在 PDF 裡印成 `(author?)`。

### 註腳

Pandoc 會轉成 `[^1]` 形式，但**轉換器不支援腳註語法**。改成直接寫 LaTeX：

```markdown
這個概念源自遷移理論\footnote{完整推導見 Bansal 等人（2005）附錄 A。}。
```

### 其他 Word 雜訊

常見要清掉的：

| 症狀 | 處理 |
| --- | --- |
| `**​**` 空的粗體標記 | 刪掉 |
| 段落中間出現 `\` | Pandoc 的轉義，多數可刪 |
| 全形空格開頭的縮排 | 刪掉，LaTeX 會自動縮排 |
| 連續多個空行 | 保留一個即可 |
| `<span>` `<div>` 等 HTML 標籤 | 刪掉 |
| 目錄／圖目錄／表目錄 | **整段刪掉**，LaTeX 會自動產生 |
| 頁首頁尾、頁碼 | 刪掉，LaTeX 處理 |

## 摘要、誌謝、參考文獻怎麼放

Word 稿的前置頁要放到 `thesis.md` 對應的保留標題底下：

```markdown
# 摘要 {-}
（中文摘要與關鍵詞）

# Abstract {-}
（英文摘要與 Keywords）

# 誌謝 {-}
（謝辭）

# 第一章　緒論 {#c:intro}
...
```

Word 最後的**參考文獻清單不要搬進正文**——那些資料要進 `references.bib`，書目由 LaTeX 自動產生排版。`# 參考文獻` 標題以下的內容會被轉換器忽略。

## 版本控制

`word-source/*.docx` 預設**不進 git**（模板 `.gitignore` 已排除）。原因是論文原稿是未發表著作，避免不小心推上遠端。要納管的話刪掉 `.gitignore` 裡那一行。

`markdown/imported-from-word*.md` 也不進 git——那是中間檔，內容搬完就該刪。

## AI 引導使用者的說法

使用者不一定知道自己該做什麼。第一次接觸時可以這樣問：

> 你手上已經有 Word 的論文稿嗎？有的話放到專案的 `word-source/` 資料夾，我幫你轉成 Markdown 並逐章整理。沒有的話我們就從空白模板開始寫。

有 Word 稿時，接著要問清楚：

- **完成度多少？**（大綱／部分章節／完整初稿）這決定要整理多少內容。
- **引用是手打的還是用 EndNote／Zotero？** 用書目軟體的話可以直接匯出 BibTeX，省下大量時間。
- **文獻 PDF 在哪？** 之後要放進 `literature/` 才能做引用核對。

整理過程中**每完成一章就回報進度並請使用者確認**，不要一口氣搬完整本才給他看。論文是他的，他比你清楚哪裡轉壞了。
