# architect 全文翻译

> 翻译自 `skills/architect/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: architect
description: "写代码之前先勾出类型、签名与模块结构，然后留在环里看实现把它们填满。用于 /architect、'architect this'、'design this'，或直接跳进代码会把错误形状定死的非平凡工作。"
disable-model-invocation: true
---
```

---

## Architect

用 `not implemented` 的函数体与伪代码勾出类型、函数签名、类的形状与模块边界。综合多个模型视角，然后对着选定的草图填代码。

## 开始（Start）

动手之前，先打开一个待办清单，每个阶段一个条目。

1. Ground（落证）
2. Sketch（草图）
3. Agree（确认）
4. Implement（实现）
5. Scrap（推翻重来）

## Phase A：落证（Ground the problem）

为新代码触及的每一个系统建立真实的心智模型。对相关子系统跑 **how** 技能。只点名一个文件不叫落证。产出 `how` 规定的架构级解释。设计要重定义所有权或分层时，对现有形状再跑 **why** 技能，让那份 rationale 变成约束，而不是猜测。

只有工作确实是全新绿地（greenfield）、周围没有要对接的系统时，才跳过 Phase A。

## Phase B：草图（Sketch）

跑 **arena** 技能，任务是设计草图，依据材料（grounding）用 Phase A 的制品。把 `references/runner-prompt.md` 作为每个参赛者（runner）的 prompt。

参赛者从 pstack 配置文件的 `architect runners` 行取，替代 `arena runners` 行（Cursor 中为 `~/.cursor/rules/pstack-models.mdc`，Claude Code 中为 `~/.claude/rules/pstack-models.md`，其他宿主环境为 `~/.agents/pstack-models.md`）。文件或该行缺失时，用 `claude-opus-5-5-xhigh` 与 `grok-4.7-xhigh-fast`。别名条目与被拒绝条目按 **arena** 技能 Phase A 的参赛者规则处理。

做两遍设计（design it twice）。综合之前，强制至少两个结构上互不相同的候选，哪怕第一个看起来就够了。这是 **exhaust-the-design-space** 原则技能的具体化。要的是整体形状层面的备选，不是同一个形状内部的点修。

综合之前，每个候选都对照 [`references/design-red-flags.md`](https://github.com/backnotprop/pstack/blob/main/skills/PLACEHOLDER/references/design-red-flags.md) 筛一遍。假定下一个贡献者是一个 agent：只看它打开过的文件、复制最靠近的示例、走能编译的最短路径。选那种"从某一个文件看正确的变更，对整个仓库也正确"的设计。

在接口深度上比较可行的候选。选把更多复杂度藏在一个更小、更简单的公开交互面（surface）后面的设计。富接口可以集中能力来让调用链保持短，而不是把能力散落到各层。

arena 返回一份综合后的设计包。它的综合决定填进 rationale 的 "Synthesis decision" 一节。

## Phase C：确认（Agree）（可选 opt-in）

默认：拿着综合后的设计直接进实现。没有人类检查点（checkpoint）。

调用方明确要求检查点时才启用："/architect with checkpoint"、"stop and show me before implementing" 或类似措辞。此时展示综合后的设计并暂停等待签核。

无论哪种方式，综合结果都可以作为自己的 commit 交付，即 **foundational-thinking** 原则技能的 "scaffold first"（脚手架先行）模式。填代码期间的、在计划与范围内的破坏是可以的，依据 **outcome-oriented-execution** 原则技能。要在实现之前对设计施加对抗性压力，就对综合后的草图跑 **interrogate** 技能。

人类对形状提出异议时（无论在检查点里还是事后），把它当作 Phase A 的证据。重新落证、重跑 Phase B，再写更多代码。

## Phase D：对着草图实现（Implement against the sketch）

把 `not implemented` 的函数体换成代码，把伪代码换成逻辑。综合后的草图就是契约。对它的偏离是要浮出水面的信号，不是要静默吸收的摩擦。某个函数需要一个草图没预料的参数时，问清楚是草图错了、需求漏了、还是实现越权了。

## Phase E：架构错误时推翻重来（Scrap when the architecture is wrong）

实现不断产生草图吸收不了的摩擦时，扔掉草图。不要在错误设计上打补丁，依据 **redesign-from-first-principles** 与 **fix-root-causes** 原则技能。

信号是一个*模式*，不是单次实例。征兆：

- 同一种形状的 workaround 在互不相关的代码里反复出现。
- 多个互不相关的边界情况全都要靠特例分支。
- 类型需要逃生舱（`any`、cast、实际上总会被设置的可选字段）才能编译。
- 草图明说状态不共享，却冒出"我们需要一把锁"的条件反射。
- 调用方必须知道抽象的内部规则才能使用它。
- 实现中出现两处以上同形状的独立 Phase D 偏离。

用判断力。几个边界情况不足以判一个架构死刑。有些问题本身就合法地复杂。数据里的复杂度不是设计里的复杂度。

决定推翻时：

1. 对已经建出来的东西重跑 **how** 技能。
2. 假想新约束从第一天起就是前提，按 redesign-from-first-principles 重新设计。
3. 先减后加，依据 **subtract-before-you-add** 原则技能。新草图在开始生长之前就应该比旧草图更小。
4. 回到 Phase B 重跑 arena。

## 输出（Outputs）

调用方的用法先行，类型草图由它推导而来。小变更是一个包含新类型与签名的文件。大一点的工程是模块地图加类型定义。rationale 随附交付，按 `references/rationale-template.md` 的形状写，包含用法草图与综合决定。
