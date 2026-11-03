> 翻译自 `skills/typescript-best-practices/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## TypeScript best practices（TypeScript 最佳实践）`typescript-best-practices`（技能）

先应用 **type-system-discipline** 原则技能。

| 规则 | 摘要 |
|------|---------|
| 可判别联合 | 用 `kind` 字面判别量建模变体，让不可能状态无法表示。不用可选字段袋。 |
| 品牌类型 | 用 `& { readonly __brand: "X" }` 给原始类型打品牌，防止混用。边界处验证一次。品牌来自验证型类型守卫（`input is AgentId`），绝不来自 `as`。 |
| 构造性建模 | 把形状造成非法值根本构造不出来：非空用 `[T, ...T[]]`，偶数长度用 `[T, T][]`，区间用 `start` 加 `duration`。不是运行时守卫，不是对 refinement types 的空想。 |
| 最简单全类型 | 只要其上每个操作保持全（total），就保持 `T[]`。只有当宽松类型逼出 `!`、cast、或"不应发生"的 throw 时，才强化为 `NonEmpty<T>`。 |
| `unknown` 优于 `any` | 外部数据是 `unknown`。 |
| Schema 先于守卫 | 手写逐属性类型守卫之前，用仓库的运行时 schema 库并从 schema 推导类型，如 `z.infer`。 |
| 无 `as` 强转 | 每个 `as` 都是一次等着的运行时崩溃。只在验证之后 cast。 |
| 收窄层级 | 判别 switch > `in` 运算符 > `typeof`/`instanceof` > 用户定义类型守卫 > `as`。 |
| 类型守卫 | 必须真验证。说谎的守卫比 `as` 更糟，因为缺陷藏在声称安全的名字后面。命名为 `isX` 或 `hasX`。 |
| 穷尽性 | 在 default 分支内联 `const _exhaustive: never = x;`，新增变体时编译器报错。 |
| `satisfies` 优于 `as` | 验证值而不拓宽字面量类型。 |
| 边界验证 | 在数据流入处解析为命名的领域类型。`Record<string, unknown>`（无论怎么拼写）止于该次解析。内部信任类型。见 **boundary-discipline** 原则技能。 |
| Schema 派生类型 | 声明新 interface 之前先用 `Pick`/`Omit`/`Parameters`/`ReturnType`/`Awaited`/`typeof`。 |
| 对象参数 | 传对象不传位置参数，参数顺序自说明。热路径（逐帧渲染、tokenizer、parser）例外。 |
| 真测试 | 能跑的不 mock。优先框架的真测试原语并带泄漏/释放检查，UI 在运行中的构建里验证。只 mock 本地跑不了的。 |
| 结构化遥测 | 优先结构化日志诊断，带足以凭一个 id 调试的上下文。交付代码里无 `console.log`。 |

示例见 `references/patterns.md`。

---
