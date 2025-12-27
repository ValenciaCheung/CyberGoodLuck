# AI 资产产出与工具指南

## 工具总览（按用途）

- 生成高保真视觉
  - Midjourney（风格与灯光控制强，适合赛博霓虹）
  - Stable Diffusion SDXL/ComfyUI（本地可控，批量与一致性强）
  - Adobe Firefly（版权友好，文本到图更稳）
- 生成 UI/组件草稿
  - Galileo AI（文本到移动/表盘 UI 草图）
  - Uizard（线框到高保真 UI）
  - Relume AI（结构与组件建议，便于拆分）
- Figma 内提升与自动化
  - Magician by Diagram（AI 填充文案/图标样式）
  - Automator（批量生成变体与属性）
  - Locofy/Anima（组件到代码雏形，便于校验结构）
- 图标与符号
  - SF Symbols（watchOS 原生图标）
  - Icon8/Phosphor（补充风格一致的矢量）
- 动效与序列
  - After Effects + Bodymovin（转 Lottie；watchOS 建议转 PNG 序列）
  - Blender（物理/硬币/签条模拟，导出序列帧）
  - Runway/Kaiber（短参考视频，指导关键帧）

## 推荐生产管线（赛博霓虹风）

1. 参考收集：Cyberpunk HUD/FUI、Tron 光盘、Dot Matrix、Neon glow
2. 生成底图：MJ/SD 生成背景与质感素材（流体暗网格、故障噪点）
3. 精修与分层：Photoshop/Photopea 分层清理，导出透明 PNG
4. 组件化：导入 Figma，按 `CO/模块/组件` 建组件与变体（见命名文档）
5. 动效关键帧：Blender/AE 生成硬币翻转、签条掉落与 Reveal 的帧序列
6. 导出与适配：输出 `@2x/@3x` PNG 和序列，命名规范与尺寸适配 watchOS
7. 联调：Core Haptics 与关键帧对齐，性能与电量回归

## Prompt 模板（可直接复用）

- 背景（暗网格+呼吸光）
  - “cyberpunk futuristic HUD background, dark fluid grid, subtle breathing neon glow, dot matrix texture, high contrast, 8-bit noise, monochrome black #111111 base with accents #00FF41 #00FFFF, watchOS aesthetic, minimal clutter”
- 赛博硬币（Tron 光盘残影）
  - “glowing neon coin like TRON disc, circuit board patterns, motion blur trail, neon cyan and magenta rim light, cinematic flip, hologram flicker, photoreal stylized, high shutter speed”
- 全息签筒与签条
  - “holographic fortune sticks tube, semi-transparent cylinder, glowing sticks inside, ambient occlusion, hologram flicker, physically plausible collision look, cyberpunk UI style”

## 输出与命名规范

- 静态：`PNG @2x/@3x` 透明底；文件名 `CO_Home_Background@2x.png`
- 序列：`CO_CoinFlip_0001.png` … `CO_CoinFlip_0060.png`
- SpriteSheet（可选）：`CO_Stick_Reveal_Sheet@2x.png` + `meta.json`
- 颜色与主题遵守配置：见 `config/fortune_levels.json`

## watchOS 适配要点

- 分辨率与尺寸：针对 40/44/45mm（可按画板 `Size` 变体出图）
- 性能：优先图片序列与 SpriteKit，避免长视频与重粒子
- 无障碍：高对比度主题；系统“减少动态效果”提供静态替代

## 质量检查清单

- 风格一致：霓虹色与发光强度统一，避免纯白过曝
- 文案与等级对应：组件变体与 5 级签文一致
- 边距与约束：8pt 基线；Monospace 时间对齐
- 动效时序：关键帧与 Haptics 映射符合规范
