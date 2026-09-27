# 論文圖片

圖片放這裡，在 Markdown 中這樣引用：

```markdown
![圖 1.1 研究流程](images/research-flow.png){#fig:research-flow}
```

- 路徑相對於**專案根目錄**，不是相對於 `markdown/`。
- 圖說開頭的「圖 1.1」會被自動移除，由 LaTeX 重新編號。
- 圖片一律置中、寬度撐滿版面。要自訂寬度請直接在 Markdown 裡寫 `\includegraphics[width=0.6\linewidth]{...}`。

送印品質建議：向量圖（PDF、EPS）優先，點陣圖至少 300 dpi。螢幕截圖放大後會糊，圖表盡量從原始軟體匯出向量格式。
