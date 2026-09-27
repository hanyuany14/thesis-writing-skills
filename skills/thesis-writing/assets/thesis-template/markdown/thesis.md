# 摘要 {-}

這是範例內容，用來驗證環境能正常產出 PDF。開始寫論文前請把整份檔案的內容換掉。

本檔案是論文的**唯一內容來源**。`chapters/*.tex` 由 `make` 自動產生，每次建置都會被覆寫，不要直接編輯。

關鍵詞：Markdown、LaTeX、論文寫作

---

# Abstract {-}

This is placeholder content used to verify that the toolchain produces a PDF. Replace the entire file before writing your thesis.

Keywords: Markdown, LaTeX, thesis writing

---

# 誌謝 {-}

誌謝內容寫在這裡。這個一級標題會被抽成獨立頁面，不計入章節編號。

---

# 第一章　緒論 {#c:intro}

## 1.1　研究背景 {#s:background}

括號式引用寫成 [@smith2024example]，用在句末補充來源。敘述式引用寫成 @smith2024example，用在把作者當句子主詞。多筆引用寫成 [@smith2024example; @chen2023reproducible]。

標題裡的「第一章」「1.1」會被自動移除，由 LaTeX 重新編號——你在這裡寫的編號只是給自己看的。`{#c:intro}` 是交叉引用標籤，可省略。

## 1.2　研究目的

本研究的目的包括：

- 以 Markdown 維護論文內容
- 自動產生 LaTeX 章節檔案
- 以 XeLaTeX 與 BibTeX 產生完整 PDF

# 第二章　研究方法 {#c:method}

## 2.1　模型設定

行內公式寫成 $x_i$。獨立公式用 `$$` 包住，加 `\tag{}` 會產生編號：

$$
y_i = \alpha + \beta x_i + \varepsilon_i
\tag{2.1}
$$

表格標題要寫在表格**正上方**，格式是「表 2.1 標題文字」，腳本才抓得到 caption：

表 2.1 變數說明

| 變數 | 說明 | 範例值 |
| --- | --- | ---: |
| $y_i$ | 依變數 | 100 |
| $x_i$ | 自變數 | 10 |

欄位對齊由腳本自動判斷（數字靠右、長文字自動換行），Markdown 的 `:---:` 語法會被忽略。

## 2.2　圖片

圖片路徑相對於專案根目錄，圖說開頭的「圖 2.1」會被自動移除：

```
![圖 2.1 研究架構](images/framework.png){#fig:framework}
```

（上面用程式碼區塊示範語法，因為範例圖檔不存在。實際使用時直接寫，不要包在反引號裡。）

# 第三章　結論 {#c:conclusion}

本章彙整研究發現、限制與未來研究方向。

# 參考文獻 {-}

**這個標題以下的所有內容都不會進 PDF。** 書目由 `references.bib` 與正文中的引用自動產生，不需要手動列出。
