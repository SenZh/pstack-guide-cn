# 懒惰协议（Laziness Protocol）

> 翻译自 `skills/principle-laziness-protocol/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。
>
> 技能名 `principle-laziness-protocol`（frontmatter 的 `name` 字段，寻址键，绝不汉化）。

---

**适用时机**：重构、评估 diff 尺寸、或想加抽象、分层、信号传递时。偏向删除与解决问题的最小变更。

- **合并决策。** 不要在多个地方重复同一个选择。把它放进唯一的事实来源，把结果作为简单 flag 传递。
- **最小化 diff。** 做能解决问题的最小变更。更少的行胜过"优雅"的样板。
