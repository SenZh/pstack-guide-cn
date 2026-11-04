# 先减后加（Subtract Before You Add）

> 翻译自 `skills/principle-subtract-before-you-add/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。
>
> 技能名 `principle-subtract-before-you-add`（frontmatter 的 `name` 字段，寻址键，绝不汉化）。

---

**适用时机**：排序一个新增、重构或重写时。先移除死代码、冗余校验器、stub 引用，再在更简单的基座上构建。

演化系统时，先移除复杂度，再构建。默认做减法。

把简化当作持续投资。留下比你发现时略更简单、且在同一或更小表面之后更有能力的设计。

- 移除先于构建排序
- 打磨之前先砍（先到达最小，再投资质量）
- 为观测到的用法设计，不为推测的边界情况
- 不放规格要求之外的推测性校验器、解析器、守卫
- 简化提示词（删冗余指令、过度模板）
- 引用没有新内容时，删掉它而不是留一个 stub
