# 先分离再串行化共享状态（Separate Before Serializing Shared State）

> 翻译自 `skills/principle-separate-before-serializing-shared-state/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。
>
> 技能名 `principle-separate-before-serializing-shared-state`（frontmatter 的 `name` 字段，寻址键，绝不汉化）。

---

**适用时机**：并发参与者可能写同一文件、分支、键或状态对象时。先消除共享；只有一个共享写入者是真实不变式时才做结构化串行化。

并发参与者可能共享可变状态时，先问它们是否需要同一个可变对象。不需要，就消除共享。共享是真实的，就在结构上强制串行化：锁文件、顺序阶段、独占所有权。指令与约定不是并发控制。

**为什么**：对共享状态的并发写入制造间歇、难复现、调试昂贵的竞态。

**模式：**
1. **识别共享可变状态**（双方读写的文件、双方 push 的分支、双方定义并消费的 API）。
2. **默认：消除共享写目标。** 问：这些参与者需要一个规范对象，还是各自发布独立的事实？给每个参与者自己的文件、键、分支或状态目录，只在读/报告边界合并。两个 worker 把各自的 `lastX` 字段写进同一个 `state.json` 仍是共享变更。`indexer-state.json` 加 `metrics-state.json` 就不是。
3. **只有一个共享写目标是真实不变式时，才在结构上串行化访问**（锁文件、顺序阶段、单写入者 actor、或原子 compare-and-swap）。把"我们需要一把锁"当作要核查的设计坏味道，而不是默认答案。
