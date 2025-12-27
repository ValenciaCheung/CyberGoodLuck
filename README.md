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

## 如何运行

### 环境要求
- macOS 26.0.1+ (Sequoia)
- Xcode 26.2+
- watchOS 11.2 Simulator 或真机

### 运行步骤
1. 打开 Xcode 项目：
   ```bash
   open apps/apple/CyberOracleWatch/CyberOracleWatch.xcodeproj
   ```

2. 选择 Apple Watch 模拟器（例如 Apple Watch Series 9）

3. 构建并运行：
   - ⌘B 构建
   - ⌘R 运行

4. 在模拟器上测试：
   - 左右滑动切换屏幕
   - 查看实时时钟显示

### 可选：启动后端 API
```bash
cd services/cyberoracle-api
npm install --cache .npm-cache
npm run dev
```

## 实现进度

### ✅ Sprint 1: Foundation (已完成 - 2025-12-27)
**成果**：可运行的 watchOS App，带实时时钟 HUD
- ✅ Xcode watchOS 项目创建并配置
- ✅ Swift Package `CyberOracleCore` 集成（Domain + Data 层）
- ✅ 所有 ViewModels 实现（DailyLuck/Decision/FortuneStick）
- ✅ `HomeView` - 赛博时间 HUD（完整实现）
  - 实时时钟（霓虹绿/青色）
  - PRD 标准日期格式：`2025/12 / date 27`
  - 等宽字体 + 黑色背景
- ✅ `RootNavigationView` - TabView 导航（支持左右滑动）
- ✅ 占位 Views：DailyLuck/Decision/Fortune（Sprint 2-4）
- ✅ Node.js 后端 API（Fastify + TypeScript）
- ✅ 项目文档完善（CLAUDE.md, 设置指南）

**验证**：
- ✅ 在 Apple Watch 模拟器成功运行
- ✅ 导航流畅（4 个屏幕可滑动切换）
- ✅ 时间每秒更新

**提交**：`de01d5e` - feat: Complete Sprint 1

---

### ✅ Sprint 2: Daily Luck (已完成 - 2025-12-27)
**成果**：完整的每日运势显示，带自动刷新

**完成任务**：
- ✅ 实现 `DailyLuckView` 的 2x2 宫格布局（Love/Money/Career/Health）
- ✅ 连接 `DailyLuckViewModel` 获取真实数据
- ✅ 显示 4 个指标，带等级特定的 emoji 和颜色
  - 🤩 极好 (great) - 霓虹绿
  - 🙂 尚可 (good) - 蓝色
  - 😐 一般 (ok) - 黄色
  - 😵 较差 (bad) - 红色
- ✅ 添加午夜自动刷新逻辑（每分钟检查日期变化）
- ✅ ScrollView + 响应式布局（适配不同 Apple Watch 尺寸）
- ✅ Loading/Error 状态处理

**验证**：
- ✅ 在 Apple Watch 模拟器成功显示
- ✅ 同一天结果一致（确定性算法）
- ✅ 布局适配不同手表尺寸

**提交**：`ad3bb5b` - feat: Complete Sprint 2

---

### ✅ Sprint 3: Decision Maker (已完成 - 2025-12-27)
**成果**：完整的 Yes/No 决策功能，带震动反馈

**完成任务**：
- ✅ 实现 `DecisionView` 的 3 阶段状态机
  - Prayer（祈祷）：显示 🙏 + "Shake it" 提示
  - Tossing（投掷）：💫 旋转动画 + "Deciding..."
  - Result（结果）：✅ YES (绿色) / ❌ NO (红色)
- ✅ 创建 `ShakeDetector.swift` - CoreMotion 震动检测
  - 加速度阈值：2.5g
  - 震动强度可视化指示器
- ✅ 创建 `HapticEngine.swift` - 触觉反馈引擎
  - Coin flip haptic（投掷）
  - Success/Failure haptics（结果）
- ✅ 完整动画实现
  - 旋转动画（360° × 3 圈）
  - 缩放动画（弹簧效果）
- ✅ "Again" 按钮重置功能
- ✅ 模拟器调试按钮（真机自动隐藏）

**验证**：
- ✅ 在 Apple Watch 模拟器成功运行
- ✅ 3 阶段流程流畅切换
- ✅ 动画效果正常
- ✅ 触觉反馈正常触发

**注意**：watchOS 模拟器不支持真实震动检测，已添加仅限模拟器的调试按钮。真机部署后震动检测将正常工作。

---

### 🎯 后续 Sprints（实现节奏）
- **Sprint 4**：Fortune Sticks（电子求签）- 完整交互流程
- **Sprint 5**：Visual Polish（赛博朋克视觉效果）
- **Sprint 6**：Sound & Final Polish（音效与最终打磨）
