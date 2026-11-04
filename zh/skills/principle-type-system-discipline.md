# 类型系统纪律（Type System Discipline）

> 翻译自 `skills/principle-type-system-discipline/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。
>
> 技能名 `principle-type-system-discipline`（frontmatter 的 `name` 字段，寻址键，绝不汉化）。

---

**适用时机**：设计类型、审查函数签名、或在任何静态类型语言里写代码。让非法状态不可表示，给语义原始类型打品牌，在边界解析外部数据，穷尽变体，从权威 schema 派生。

让编译器拒绝不可能的状态、错配的原始类型、未处理的变体。优先把错误与特例定义到"不存在"，而不是增殖处理器。TypeScript 语法见 `typescript-best-practices` 技能。

- **给语义原始类型打品牌。** `UserId` 与 `OrderId` 底层都是字符串，但不该可互换。各自给一个类型，如 TypeScript 的品牌交叉类型或其他语言里的 newtype。创建时验证一次，下游信任类型。两个参数共享原始类型却含义不同时，打品牌。
- **外部数据在解析前无类型。** RPC 载荷、JSON、IPC 消息、CLI 参数、配置文件、环境变量、数据库行。每个边界一个解析函数，把非结构化输入变成带类型的模型。**boundary-discipline** 原则技能说校验放哪。
- **从权威 schema 派生类型。** 协议缓冲、OpenAPI spec、GraphQL schema、数据库迁移、design-token 文件或另一个文件拥有某个形状时，从它派生，不手搓平行类型。见 **encode-lessons-in-structure** 原则技能。
