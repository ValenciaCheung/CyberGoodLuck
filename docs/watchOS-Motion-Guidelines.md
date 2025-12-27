# watchOS 动效规范拆解

## 基准
- 帧率与性能：目标 60fps；动效时长 120ms–600ms，整体轻量
- 缓动曲线：`easeOut`（揭示/完成），`easeInOut`（过渡），`spring(soft)`（物理感）
- 电量友好：避免长时间全屏发光/复杂粒子；优先静帧 + 关键帧

## 动效要素
- 祈祷双手：`200–300ms` 合十至停顿；提示摇动时加入轻微 `spring` 呼吸
- 硬币翻转：`500–700ms`，三段关键帧 `FlipStart→FlipMid→FlipEnd`；残影与发光在中段增强
- 摇签筒：`300–500ms` 循环段；抖动强度与 Haptics 同步递增
- 签条掉落与揭示：`Drop 250ms`，`Reveal 300ms`；`Glitch` 等级加入轻微抖动与噪点

## Haptics 映射（Core Haptics）
- Shake：`Transient(light)` × 多次，`Continuous(low amplitude)` 叠加
- Toss 翻转：`Transient(medium)` 在 `FlipMid`
- Result YES：`Success(heavy)`；NO：`Error(medium)`
- Fortune Reveal：`Notification(success|warning|error)` 依等级；`ERROR` 用短促重击但控制时长

## 技术路线
- SwiftUI + CoreAnimation：适合 UI 过渡与状态动画（`withAnimation`，`matchedGeometryEffect`）
- SpriteKit：适合硬币/签条等具备物理或序列帧的动效
- 图片序列动画：导出 `PNG` 序列，`WKInterfaceImage` 或 SwiftUI `Image` 逐帧播放
- 视频素材：仅用于短时展示；建议 `H.264` 小体积片段。慎用以防耗电与加载阻塞
- Lottie：watchOS 不直接支持，建议在构建期将 Lottie 转为图片序列或 SpriteKit 动画

## 导出规范
- 静态：`PNG @2x/@3x`，带透明通道
- 动效：`PNG` 序列（命名 `CO_CoinFlip_0001.png`…）或 `SpriteSheet`，必要时短 `mp4`
- 颜色与发光：避免纯白高发光，使用主题色分级与叠加发光

## 无障碍与可读性
- 对比度：时间与结果采用高对比主题色；避免红色细体小字号
- 动态降低：遵守系统“减少动态效果”设置，提供静态替代或缩短动效
- Haptics 敏感：支持弱化触觉选项

