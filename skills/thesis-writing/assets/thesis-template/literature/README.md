# 文獻庫

文獻 PDF 放這裡，**檔名就是 `references.bib` 的 citation key**：

```text
literature/
├── bansal2005migrating.pdf     ←→  @bansal2005migrating
├── goodhue1995task.pdf         ←→  @goodhue1995task
└── polites2012shackled.pdf     ←→  @polites2012shackled
```

有了這個對應，看到引用 `[@bansal2005migrating]` 就能直接推出檔案路徑，AI 可以打開原文核對「論文裡寫的這句話，原文真的有這樣說嗎」。這是防止 AI 捏造文獻最實際的機制。

## 命名慣例

`姓氏 + 年份 + 標題第一個關鍵字`，全部小寫、無空格：

- `Bansal, H. S. (2005). "Migrating" to new service providers...` → `bansal2005migrating`
- `Goodhue, D. L. (1995). Task-technology fit and individual performance` → `goodhue1995task`

## 拿不到 PDF 的文獻

仍要寫進 `references.bib`，但加上註記：

```bibtex
@book{kotler2016marketing,
  author = {Kotler, Philip},
  title  = {Marketing Management},
  year   = {2016},
  note   = {NO-PDF: 紙本書，引用內容以第 3 章 p.88 為準}
}
```

## 版本控制

**這個資料夾的 PDF 不進 git**（`.gitignore` 已排除）：期刊 PDF 有版權不該推上公開 repo，而且文獻庫動輒數百 MB 會拖垮 clone。

進 git 的是 `references.bib`——它才是真正的資產。換電腦時 bib 帶著走，PDF 從圖書館重新下載即可。要備份 PDF 請用雲端硬碟同步這個資料夾，不要用 git。

完整的文獻管理與核對流程見 skill 的 `references/literature.md`。
