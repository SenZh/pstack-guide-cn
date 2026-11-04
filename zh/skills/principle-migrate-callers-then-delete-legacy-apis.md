# 先迁移调用方再删旧 API（Migrate Callers Then Delete Legacy APIs）

> 翻译自 `skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。
>
> 技能名 `principle-migrate-callers-then-delete-legacy-apis`（frontmatter 的 `name` 字段，寻址键，绝不汉化）。

---

**适用时机**：引入新内部 API 而旧调用方仍存在时。同一波之内迁移调用方并删除旧 API，而不是保留兼容层。

- 更新测试以断言新契约，删除只保护重构前实现细节的测试

**适用条件：**
- 没有外部用户依赖向后兼容
- 项目能吸收协调好的破坏性变更
- 新 API 是某次简化或重构行动的一部分
