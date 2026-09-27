# Word 原稿

如果你已經有 Word 的論文稿，把 `.docx` 檔放進這個資料夾，然後執行：

```bash
./scripts/import_docx_to_md.sh
```

腳本會自動抓這裡的 `.docx`，轉成 `markdown/imported-from-word.md`，圖片解壓到 `markdown/imported-media/`。

資料夾裡有多份 Word 檔時，腳本會列出來要你指定：

```bash
./scripts/import_docx_to_md.sh word-source/論文_v3.docx
```

## 原始檔請留著

轉出來的 Markdown 是**待整理的中間檔**，不是成品。公式、表格與引用多半需要人工修整，整理過程中會不斷需要回頭對照「原本長什麼樣」。

整本搬完、PDF 也核對過之前，不要刪掉這裡的檔案。

## 不進 git

`.docx` 檔預設不納入版本控制（`.gitignore` 已排除），避免未發表的論文稿不小心推上遠端。要納管的話刪掉 `.gitignore` 裡的 `/word-source/*.docx` 那一行。

完整的搬遷流程與各類內容的處理方式，見 thesis-writing skill 的 `references/import-from-word.md`。
