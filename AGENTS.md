# 我的第二大腦 (Obsidian Second Brain)

本專案為個人深度研究與知識沉澱的 Obsidian 繁體中文知識庫，依據 Karpathy Second Brain 架構維護。

## 目錄架構與分工
- `raw/`: 原始資料來源（文章、論文、書籍摘要、網頁剪藏、數據）。唯讀/增量收錄，禁止任意修改或覆蓋既有原始檔。
- `wiki/`: 經提煉蒸餾的結構化知識庫：
  - `wiki/核心概念/`: 原子化概念筆記（命名一律採直觀繁體中文，如 `概念名稱.md`）。
  - `wiki/實體標的/`: 標的、實體、工具或物件筆記（採「代號_名稱」或「名稱.md」）。
  - `wiki/參考來源/`: 來源文檔的提煉萃取摘要。
  - `wiki/策略分析/`: 深度情境分析、策略評估或跨篇研究。
  - `wiki/index.md` & `wiki/overview.md`: 索引與高階導覽總覽。
  - `wiki/conventions.md`: 使用慣例與個人偏好（所有操作優先參考此處規範）。
  - `wiki/log.md`: 知識庫變更歷史紀錄。
- `.obsidian/`: Obsidian 編輯器核心配置，嚴禁修改。

## 格式與語法規範
- **語言**：標準繁體中文（台灣技術與領域慣用語）。
- **雙向連結**：使用 Obsidian Wikilinks（如 `[[概念名稱]]`），不使用標準 Markdown 相對檔案路徑。
- **YAML Frontmatter**：筆記頂部需包含 YAML frontmatter：
  ```yaml
  ---
  title: 頁面名稱
  aliases: [英文別名, 簡稱]
  type: concept | entity | source | analysis | overview
  created: YYYY-MM-DD
  updated: YYYY-MM-DD
  tags: [領域標籤]
  ---
  ```
- **結構化表徵**：推導優先使用結構化因果鏈（A → B → C），多概念評比優先使用 Markdown 表格。

## 上下文維護與安全守則
1. **路由優先**：回答查詢時優先檢索 `wiki/index.md` 定位核心節點，避免遍歷無關內文以節省 Token。
2. **原子化收錄 (Ingest)**：新資料進入時，需同步萃取至 `核心概念/`、更新相關節點的雙向連結，並刷新 `index.md` 與 `log.md`。
3. **無損守則**：任何可能導致資料不可逆遺失的操作，必須先列出影響清單並徵詢使用者同意。
4. **即時同步**：修改知識庫核心檔案或新增概念後，記得同步更新索引與日誌。
