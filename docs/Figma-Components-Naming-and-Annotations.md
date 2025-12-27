# Figma 组件命名方案与画板标注

## 命名总则
- 采用层级前缀：`CO/`（CyberOracle）+ 模块 + 组件名
- 使用驼峰或中划线保持一致：`CO/Home/TimeDisplay`，`CO/DailyLuck/ItemCard`
- 状态用 `Variant` 命名：`State=Default|Pressed|Disabled|Glitch`
- 尺寸用 `Size` 变体：`Size=40|44|45`（Apple Watch 常见屏幕）
- 颜色主题用 `Theme` 变体：`Theme=DarkNeon|GlitchYellow|ErrorRed`

## 设计 Token
- 颜色：`Token/Color/Primary=#00FF41`，`Accent=#00FFFF`，`Error=#FF2D55`，`Bg=#111111`
- 字体：`Token/Font/Time=Monospace`，`UI=SF Compact`
- 阴影与发光：`Token/FX/GlowSmall`，`GlowHeavy`，`GlitchNoise`
- 间距：`Token/Space/4`，`8`，`12`

## 组件清单
- `CO/Home/TimeDisplay`（Variants：`WithSeconds`，`NoSeconds`）
- `CO/Home/DateBadge`（Variants：`YearMonth`，`DateHighlight`）
- `CO/Home/Background`（Variants：`FluidDark`，`DotMatrix`）
- `CO/DailyLuck/Grid`（Variants：`4Cell`，`Radar`）
- `CO/DailyLuck/ItemCard`（Variants：`Love|Money|Career|Health` × `Level=1|2|3|4`）
- `CO/Decision/PrayerHands`（Variants：`Static`，`ShakePrompt`）
- `CO/Decision/CyberCoin`（Variants：`FlipStart`，`FlipMid`，`FlipEnd`）
- `CO/Decision/ResultBadge`（Variants：`YES`，`NO`）
- `CO/Fortune/TubeHologram`（Variants：`Idle`，`Shake`）
- `CO/Fortune/Stick`（Variants：`Drop`，`Reveal` × `Level=ULTRA|SUPER|BASIC|GLITCH|ERROR`）

## 画板与标注
- 画板命名：`CO/Screens/Home`，`CO/Screens/DailyLuck`，`CO/Screens/Decision`，`CO/Screens/Fortune`
- 布局网格：8pt 基线 + 4pt 微调；等宽字体对齐时间数字
- 约束与自动布局：父容器 `Auto Layout`，子组件设置 `Hug` 与 `Fixed` 合理组合
- 出图标注：颜色代码、字体大小、发光强度、动画关键帧序列号（见动效文档）
- 导出切片：`@2x` 和 `@3x` PNG；动效导出采用图片序列（PNG）或 Lottie 转序列

