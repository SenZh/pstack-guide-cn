# 第一性重设计（Redesign from First Principles）

> 翻译自 `skills/principle-redesign-from-first-principles/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。
>
> 技能名 `principle-redesign-from-first-principles`（frontmatter 的 `name` 字段，寻址键，绝不汉化）。

---

**适用时机**：把一个新需求接进已有设计时。

接入变更时，不要把它拴在现有设计上。假想这个需求从第一天起就是根基假设，照此重设计。

- 读所有受影响文件，理解当前设计
- 问："如果我们带着这个新需求从零写，我们会建什么？"
- 把变更传播到每一处引用：类型、文档、示例、rationale 段落
- 想清楚整个重设计，然后增量交付

这是把变更接进已有设计时保住期权价值的方法。
