# CyberOracle (赛博灵签)

Apple Watch 上的赛博玄学解压工具，结合抬腕即视、摇动手势与细腻 Haptics，提供每日运势、快速抉择与电子求签的沉浸式体验。

## 文档
- 产品需求文档（PRD）：`docs/PRD-CyberOracle.md`
- 签文等级配置（JSON）：`config/fortune_levels.json`
- AI 资产产出与工具指南：`docs/AI-Asset-Production-Guide.md`

## 代码结构（可扩展）
项目按“共享核心（可被 watchOS / iOS 复用）+ 可选后端服务 + 未来 UI App 工程”拆分，优先保证可维护性与可测试性。

```
CyberGoodLuck/
  apps/
    apple/
      CyberOracleAppShared/              # 共享 App 层（依赖 Core；未来补 UI）
      CyberOracleWatchApp/               # watchOS App 入口（占位）
      CyberOracleiOSApp/                 # iOS App 入口（占位）
  packages/
    CyberOracleCore/                     # Swift Package：共享核心（Domain/Data）
      Sources/
        CyberOracleDomain/               # 纯业务模型 + 协议（不含 UI）
        CyberOracleData/                 # 数据层实现：本地生成/配置加载/远程 API 客户端
  services/
    cyberoracle-api/                     # Node/Fastify 后端（可选；便于未来多端一致）
  contracts/
    oracle-api.openapi.json              # API 合约（OpenAPI）
  config/
    fortune_levels.json                  # Fortune Sticks 5 级概率与文案配置（单一真源）
  docs/                                  # PRD 与设计/开发流程
```

## 架构要点
- `CyberOracleDomain`：只放“是什么”（模型/枚举/协议），例如 `OracleService`、`DailyLuck`、`FortuneLevel`。
- `CyberOracleData`：只放“怎么来”（配置加载、确定性随机、远程 API），提供两种实现：
  - `LocalOracleService`：纯本地生成（适合 watch 离线、启动快、无网络依赖）
  - `RemoteOracleService`：对接后端（适合跨设备一致、后续账号/历史记录/推荐算法）
- `apps/apple/CyberOracleAppShared`：预留 App 层（环境注入 + ViewModel），后续 watchOS/iOS UI 可以共用同一套业务调用方式。

## 后端（可选）
后端提供与 `OracleService` 对应的 HTTP API，便于未来 iPhone/Watch 与其它端一致。

- 目录：`services/cyberoracle-api`
- 启动开发服务：
  - `npm install --cache .npm-cache`
  - `npm run dev`
- 接口（部分）：
  - `GET /health`
  - `GET /v1/config/fortune-levels`
  - `GET /v1/daily-luck?date=YYYY-MM-DD`
  - `POST /v1/fortune/draw`
  - `POST /v1/decision/yesno`

## 设计提示关键词
- 风格：Cyberpunk HUD/FUI，Dot Matrix，Neon glow
- 颜色：#00FF41、#FF00FF、#00FFFF、#111111

## 实现进度

### ✅ Sprint 1: Foundation (已完成 Swift 代码)
- ✅ 所有 Swift 源文件已创建
- ✅ `HomeView` - 赛博时间 HUD（完整实现）
- ✅ `RootNavigationView` - TabView 导航
- ✅ 占位 Views：DailyLuck/Decision/Fortune
- ⏳ **下一步**：在 Xcode 中创建 watchOS 项目并添加文件

详细步骤见：`apps/apple/CyberOracleWatchApp/XCODE_SETUP_QUICKSTART.md`

### 🎯 下一步（实现节奏）
- Sprint 2：Daily Luck（每日运势）- 连接 ViewModel
- Sprint 3：Decision Maker（日常抉择）- CoreMotion + Haptics
- Sprint 4：Fortune Sticks（电子求签）- 完整交互流程
- Sprint 5：Visual Polish（赛博朋克视觉效果）
- Sprint 6：Sound & Final Polish（音效与最终打磨）
