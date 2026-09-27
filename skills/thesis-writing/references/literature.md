# 文獻管理與引用核對

這套流程的核心是：**每一筆引用都能在 `literature/` 裡找到對應的 PDF 原文**。這是防止 AI 捏造文獻最實際的機制。

## 目錄結構

PDF 檔名必須等於 `references.bib` 的 citation key：

```text
論文專案/
├── references.bib              # 書目資料庫
└── literature/
    ├── bansal2005migrating.pdf     ← @bansal2005migrating
    ├── goodhue1995task.pdf         ← @goodhue1995task
    └── polites2012shackled.pdf     ← @polites2012shackled
```

有了這個對應關係，看到 `[@bansal2005migrating]` 就能直接推出檔案路徑 `literature/bansal2005migrating.pdf`，不需要另外維護索引表。

拿不到 PDF 的文獻（絕版書、付費牆），仍要寫進 `references.bib`，但**在 bib 條目加上註記**：

```bibtex
@book{kotler2016marketing,
  author = {Kotler, Philip},
  title  = {Marketing Management},
  year   = {2016},
  note   = {NO-PDF: 紙本書，引用內容以第 3 章 p.88 為準}
}
```

AI 引用這類文獻時要特別謹慎，只能寫使用者明確提供過的內容。

## 加入一筆新文獻

1. **取得 PDF**，放進 `literature/`。
2. **決定 citation key**，慣例是 `姓氏年份第一個關鍵字`，全小寫無空格：`bansal2005migrating`。
3. **從 PDF 第一頁抓書目資料**寫進 `references.bib`。期刊論文通常在首頁頁尾或 DOI 頁面就有完整資訊。
4. **把 PDF 改名成 `<citekey>.pdf`**。
5. 確認 `references.bib` 的 key 與檔名完全一致（大小寫也要一致）。

DOI 是最可靠的來源。有 DOI 時可以用它查正確書目：

```bash
curl -LH "Accept: text/bibliography; style=bibtex" "https://doi.org/10.1234/example"
```

## 從 EndNote / Zotero 搬過來

兩者都能匯出 BibTeX，但**匯出的 PDF 檔名通常是流水號**（例如 `0008936986/paper.pdf`），必須重新命名才能對應。

建議做法：

1. 從 EndNote／Zotero 匯出 `.bib` 檔，覆蓋或合併進 `references.bib`。
2. 檢查匯出的 citation key。EndNote 預設 key 可能是 `Bansal2005` 這種格式，統一成小寫慣例比較好維護。
3. 逐筆把 PDF 改名成對應的 citekey。文獻數量多時，可以請 AI 開啟每個 PDF 的第一頁辨識標題與作者，再比對 bib 條目決定檔名。
4. 改名後跑一次下方的完整性檢查。

## AI 撰寫時的引用規則

這是這個 skill 最重要的約束。**AI 在論文中寫下任何引用之前，必須做到：**

1. **該 citekey 存在於 `references.bib`。** 不在就先補條目，補之前要先有來源。
2. **`literature/<citekey>.pdf` 存在**（或該 bib 條目有 `NO-PDF` 註記）。
3. **讀過該 PDF 的相關段落**，確認自己寫的敘述與原文一致。用 Read 工具開 PDF，必要時指定 `pages` 範圍。

**絕對不可以：**

- 憑印象寫出 `(Smith, 2020)` 這類引用卻沒有對應 bib 條目。
- 為了讓段落看起來有依據，生出看似合理但不存在的文獻。
- 把 A 文獻的論點寫成 B 文獻的。
- 在 `references.bib` 裡補上自己沒有驗證過的書目資料（年份、期刊名、頁碼都可能錯）。

使用者要求「幫我補一段文獻回顧」而手上沒有文獻時，正確的回應是**請使用者先提供 PDF 或文獻清單**，而不是先寫再說。可以協助的是：從現有 `literature/` 的文獻中找出可用的、指出論述缺口需要補哪類文獻、根據使用者提供的關鍵字建議搜尋方向。

## 引用核對

寫完一章後，逐筆核對該章的引用。核對一筆引用要確認三件事：

1. **文獻存在**：citekey 在 bib 裡，PDF 在 `literature/` 裡。
2. **內容相符**：論文中的敘述，在 PDF 原文找得到對應段落。轉述要忠於原意，不能加強或弱化原作者的主張。
3. **引用形式正確**：括號式 `[@key]` 用在句末補充來源；敘述式 `@key` 用在把作者當句子主詞（「@bansal2005migrating 指出……」）。

## 完整性檢查

送印前跑一次，確認 bib 與 PDF 雙向對得上：

```bash
# bib 裡有、literature/ 缺 PDF 的（排除標記 NO-PDF 的條目）
grep -oE '^@[a-zA-Z]+\{[^,]+' references.bib | sed 's/.*{//' | while read k; do
  [ -f "literature/$k.pdf" ] || echo "缺 PDF: $k"
done

# literature/ 有 PDF、bib 裡卻沒有條目的
for f in literature/*.pdf; do
  k=$(basename "$f" .pdf)
  grep -q "{$k," references.bib || echo "缺 bib 條目: $k"
done

# 正文引用了、bib 裡卻沒有的
grep -oE '@[A-Za-z0-9][A-Za-z0-9_:.+-]*' markdown/thesis.md | sort -u | sed 's/@//' | while read k; do
  grep -q "{$k," references.bib || echo "正文引用不存在的 key: $k"
done
```

第三項若有輸出，代表 PDF 裡那個引用會印成 `(author?)` 之類的問號，**一定要修掉才能送印**。

## 版本控制

`literature/*.pdf` 預設**不納入 git**（模板的 `.gitignore` 已排除）。原因：

- 期刊論文 PDF 有版權，不該推上公開 repo。
- 文獻庫動輒數百 MB，會拖垮 clone 速度，且 git 對二進位檔的處理效率很差。

納入 git 的是 `references.bib` —— 它才是真正的資產。換電腦時 bib 帶著走，PDF 從學校圖書館重新下載即可。

要備份 PDF 的話用雲端硬碟同步 `literature/` 資料夾，不要用 git。
