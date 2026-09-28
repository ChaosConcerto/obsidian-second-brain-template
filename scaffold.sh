#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Obsidian Second Brain 專案鷹架腳本 (Scaffolder)
# 基於 Andrej Karpathy LLM Wiki 理念的個人知識庫與 AI Agent 上下文編譯管線
# ==============================================================================

PROJECT_NAME="${1:-}"
PROJECT_DESC="${2:-}"

# 若未帶參數，則進入互動式詢問
if [ -z "$PROJECT_NAME" ]; then
  echo "=================================================="
  echo " 🧠 Obsidian Second Brain 專案鷹架初始化精靈"
  echo "=================================================="
  printf "請輸入新專案資料夾名稱 (例如: 量化投資研究): "
  read -r PROJECT_NAME
fi

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ 錯誤: 專案名稱不能為空！"
  exit 1
fi

if [ -z "$PROJECT_DESC" ]; then
  printf "請輸入專案主題/領域描述 (預設: 個人知識庫與深度研究): "
  read -r PROJECT_DESC
  PROJECT_DESC="${PROJECT_DESC:-個人知識庫與深度研究}"
fi

TARGET_DIR="./$PROJECT_NAME"
TODAY=$(date +"%Y-%m-%d")

if [ -d "$TARGET_DIR" ]; then
  echo "❌ 錯誤: 目錄 '$TARGET_DIR' 已存在，請指定其他名稱以避免覆寫既有檔案。"
  exit 1
fi

echo ""
echo "🚀 正在建立 Second Brain 知識庫鷹架: $PROJECT_NAME ..."

# 1. 建立核心資料夾結構
mkdir -p "$TARGET_DIR/raw/assets"
mkdir -p "$TARGET_DIR/wiki/核心概念"
mkdir -p "$TARGET_DIR/wiki/實體標的"
mkdir -p "$TARGET_DIR/wiki/參考來源"
mkdir -p "$TARGET_DIR/wiki/策略分析"
mkdir -p "$TARGET_DIR/.obsidian"

# 2. 建立 .gitkeep 保持空目錄
touch "$TARGET_DIR/raw/assets/.gitkeep"
touch "$TARGET_DIR/wiki/核心概念/.gitkeep"
touch "$TARGET_DIR/wiki/實體標的/.gitkeep"
touch "$TARGET_DIR/wiki/參考來源/.gitkeep"
touch "$TARGET_DIR/wiki/策略分析/.gitkeep"

# 3. 建立 AGENTS.md (專案根本規則)
cat <<EOF > "$TARGET_DIR/AGENTS.md"
# $PROJECT_NAME (Obsidian Second Brain)

本專案為「$PROJECT_DESC」的個人 Obsidian 繁體中文知識庫，依據 Karpathy Second Brain 架構維護。

## 目錄架構與分工
- \`raw/\`: 原始資料來源（文章、論文、書籍摘要、網頁剪藏、數據）。唯讀/增量收錄，禁止任意修改或覆蓋既有原始檔。
- \`wiki/\`: 經提煉蒸餾的結構化知識庫：
  - \`wiki/核心概念/\`: 原子化概念筆記（命名一律採直觀繁體中文，如 \`概念名稱.md\`）。
  - \`wiki/實體標的/\`: 標的、實體、工具或物件筆記（採「代號_名稱」或「名稱.md」）。
  - \`wiki/參考來源/\`: 來源文檔的提煉萃取摘要。
  - \`wiki/策略分析/\`: 深度情境分析、策略評估或跨篇研究。
  - \`wiki/index.md\` & \`wiki/overview.md\`: 索引與高階導覽總覽。
  - \`wiki/conventions.md\`: 使用慣例與個人偏好（所有操作優先參考此處規範）。
  - \`wiki/log.md\`: 知識庫變更歷史紀錄。
- \`.obsidian/\`: Obsidian 編輯器核心配置，嚴禁修改。

## 格式與語法規範
- **語言**：標準繁體中文（台灣技術與領域慣用語）。
- **雙向連結**：使用 Obsidian Wikilinks（如 \`[[概念名稱]]\`），不使用標準 Markdown 相對檔案路徑。
- **YAML Frontmatter**：筆記頂部需包含 YAML frontmatter：
  \`\`\`yaml
  ---
  title: 頁面名稱
  aliases: [英文別名, 簡稱]
  type: concept | entity | source | analysis | overview
  created: YYYY-MM-DD
  updated: YYYY-MM-DD
  tags: [領域標籤]
  ---
  \`\`\`
- **結構化表徵**：推導優先使用結構化因果鏈（A → B → C），多概念評比優先使用 Markdown 表格。

## 上下文維護與安全守則
1. **路由優先**：回答查詢時優先檢索 \`wiki/index.md\` 定位核心節點，避免遍歷無關內文。
2. **原子化收錄 (Ingest)**：新資料進入時，需同步萃取至 \`核心概念/\`、更新相關節點的雙向連結，並刷新 \`index.md\` 與 \`log.md\`。
3. **無損守則**：任何可能導致資料不可逆遺失的操作，必須先列出影響清單並徵詢使用者同意。
4. **即時同步**：修改知識庫核心檔案或新增概念後，記得同步更新索引與日誌。
EOF

# 4. 同步相容 CLAUDE.md
cp "$TARGET_DIR/AGENTS.md" "$TARGET_DIR/CLAUDE.md"

# 5. 建立 wiki/conventions.md
cat <<EOF > "$TARGET_DIR/wiki/conventions.md"
---
title: 使用慣例與偏好
aliases: [約定, Conventions]
type: conventions
created: $TODAY
updated: $TODAY
tags: [meta, settings]
---

# 使用慣例與個人偏好 (Conventions)

> 此頁面記錄您對本知識庫的特定操作習慣與輸出要求。
> AI Agent 在執行收錄、查詢、回寫與檢查時均會優先遵守此處記載之規則。

## 查詢風格 (Query)
- 遇到機制推導時，優先以結構化因果鏈表徵（A → B → C）。
- 比較類問題優先採用 Markdown 表格或對比清單呈現。

## 命名與結構慣例 (Naming & Structure)
- 資料夾與檔案命名優先採直觀繁體中文（如 \`核心概念/概念名.md\`）。
- 筆記的 YAML frontmatter 需在 \`aliases\` 保留英文對應詞，以支援多語系模糊檢索。
- 繁體中文內文與專有名詞保持標準台灣用語。

## 健康檢查 (Lint)
- 發現孤島頁面時主動分析是否有潛在交叉引用可補全。
- 發現概念間衝突或矛盾時主動標註。

## 通用設定 (General)
- （可隨時透過自然語言對話新增您的個人偏好，系統將自動寫入此處）
EOF

# 6. 建立 wiki/index.md
cat <<EOF > "$TARGET_DIR/wiki/index.md"
# Wiki 索引 (Index)

> 此文件由 AI Agent 自動維護，為知識庫的全域內容索引。
> Agent 在回答查詢時會優先閱讀此文件以快速定位相關篇章。

## 總覽與設定 (Overview & Conventions)
- [知識庫總覽](overview.md) — 知識庫全貌與圖譜架構
- [使用慣例](conventions.md) — 使用者操作偏好與自訂規範

## 參考來源 (Sources)

## 實體標的 (Entities)

## 核心概念 (Concepts)

## 策略分析 (Analyses)
EOF

# 7. 建立 wiki/overview.md
cat <<EOF > "$TARGET_DIR/wiki/overview.md"
---
title: 知識庫總覽
aliases: [總覽, Overview]
type: overview
created: $TODAY
updated: $TODAY
tags: [overview, meta]
---

# 知識庫總覽 (Overview)

## 📊 數量統計

| 指標類別 | 當前數量 |
|---|---|
| 原始素材 (raw/) | 0 |
| 參考來源 (參考來源/) | 0 |
| 實體標的 (實體標的/) | 0 |
| 核心概念 (核心概念/) | 0 |
| 策略分析 (策略分析/) | 0 |

## 🧠 知識圖譜摘要
- （待收錄素材後提煉核心網絡）

## 🕒 近期活動
- **[$TODAY]** 完成知識庫初始化
EOF

# 8. 建立 wiki/log.md
cat <<EOF > "$TARGET_DIR/wiki/log.md"
# 操作日誌 (Log)

> 記錄 Second Brain 知識庫的所有維護與變動紀錄（時間倒序）。

## [$TODAY] init | 知識庫初始化
- 建立 Second Brain 標準目錄結構
- 初始化 index.md、log.md、overview.md、conventions.md
EOF

# 9. 建立 .gitignore
cat <<EOF > "$TARGET_DIR/.gitignore"
# macOS 系統檔案
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes

# Obsidian 暫存、回收站與視窗工作區狀態（避免同步衝突）
.trash/
**/.trash/
.obsidian/workspace*.json
.obsidian/cache/

# 敏感資訊與環境變數
.env*
*.local
.agents/openai_config.json
EOF

# 10. 建立基礎 Obsidian 設定
cat <<EOF > "$TARGET_DIR/.obsidian/app.json"
{}
EOF

cat <<EOF > "$TARGET_DIR/.obsidian/appearance.json"
{}
EOF

cat <<EOF > "$TARGET_DIR/.obsidian/core-plugins.json"
[
  "file-explorer",
  "global-search",
  "switcher",
  "graph",
  "backlink",
  "canvas",
  "outgoing-link",
  "tag-pane",
  "page-preview",
  "command-palette",
  "markdown-importer",
  "word-count",
  "open-with-default-app",
  "file-recovery"
]
EOF

echo "✨ 第二大腦專案已成功建立於: $TARGET_DIR"
echo ""
echo "👉 下一步："
echo "   1. 使用 Obsidian 開啟資料夾: '$TARGET_DIR'"
echo "   2. 將原始文件放入 '$TARGET_DIR/raw/'"
echo "   3. 呼叫 AI Agent 執行: 「幫我把 raw 底下的文件收錄進知識庫」"
echo "=================================================="
