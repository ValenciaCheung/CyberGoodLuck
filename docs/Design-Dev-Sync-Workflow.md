# 设计与开发同步流程（Figma 协作）

## 流程概览
- 起稿：低保真线框确定信息架构与流程
- 高保真：完成主界面与关键动效帧，组件化与变体整理
- 交付：导出切片/序列，附标注与动效说明，整理资产清单
- 联调：开发按规范接入，校验色值/字号/动效时序与 Haptics

## Figma 协作要点
- 使用 `Components + Variants` 管理状态与尺寸；统一命名与 Token
- 在画板加 `Spec Overlay`：色值、字号、发光强度、边距、约束
- 出图清单：静态 PNG、动效 PNG 序列、必要的短视频参考
- 版本管理：每次重大更改建立 `Release Page` 与 `Changelog`

## 同步节奏
- 每日站会：更新设计进度与阻碍
- 周迭代：冻结一版动效与静态稿，开发拉取实现
- 回归与验收：根据 PRD 验收标准逐项检查

## 我们的资产入口
- PRD：[PRD-CyberOracle.md](file:///Users/tongzhang/Desktop/solelybootcamp/trae-06-好运求签/goodluck-1/docs/PRD-CyberOracle.md)
- Figma 命名与标注：[Figma-Components-Naming-and-Annotations.md](file:///Users/tongzhang/Desktop/solelybootcamp/trae-06-好运求签/goodluck-1/docs/Figma-Components-Naming-and-Annotations.md)
- 动效规范：[watchOS-Motion-Guidelines.md](file:///Users/tongzhang/Desktop/solelybootcamp/trae-06-好运求签/goodluck-1/docs/watchOS-Motion-Guidelines.md)
- 签文配置：[fortune_levels.json](file:///Users/tongzhang/Desktop/solelybootcamp/trae-06-好运求签/goodluck-1/config/fortune_levels.json)

