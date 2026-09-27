# 自動產生的章節檔

**這個資料夾的 `.tex` 檔全部由 `make` 從 `markdown/thesis.md` 產生，每次建置都會被覆寫。**

不要直接編輯這裡的檔案，改動會在下次 `make` 時消失。要改內容請改 `markdown/thesis.md`。

這裡的檔案只有一個用途：**除錯**。排版不如預期時，先跑 `make convert` 再打開對應的 `chapter_NN.tex`，判斷問題出在 Markdown 寫法還是 LaTeX 設定。
