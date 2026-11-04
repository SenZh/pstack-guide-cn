# 守住上下文窗口（Guard the Context Window）

> 翻译自 `skills/principle-guard-the-context-window/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。
>
> 技能名 `principle-guard-the-context-window`（frontmatter 的 `name` 字段，寻址键，绝不汉化）。

---

**适用时机**：上下文被填满时：大输出、长文件、重复读、fan-out 规划。把重活路由给子智能体；主线程留摘要，不留原始载荷。

**为什么**：上下文溢出劣化推理质量，制造压缩伪影，让进展停摆。

**模式：**
- **给阶段定尺寸并封顶范围。** 限制每阶段文件数、设回合预算、计入机制成本。
