# 二十四条工程原则（索引）

> 翻译自 `skills/principle-*/SKILL.md`，每条的完整译文是独立文件，与上游目录一一对应。**本译文仅供人阅读，Agent 执行时读英文原文。** 术语见 [GLOSSARY.md](../GLOSSARY.md)。

每条原则是一个独立技能，`poteto-mode` 在任务开始时读它自己的内联索引，应用某条时才读该条的完整原文。这里同样按索引 + 独立文件组织，与上游的寻址结构保持一致。

技能名（`principle-<title>` 的 kebab case）是运行时寻址键，**绝不汉化**。

## Core 核心组

| # | 原则 | 适用时机 |
|---|---|---|
| 1 | [Laziness Protocol（懒惰协议）](principle-laziness-protocol.md) | 重构、评估 diff 尺寸、想加抽象或分层时。偏向删除与最小变更 |
| 2 | [Foundational Thinking（根基思考）](principle-foundational-thinking.md) | 写逻辑之前：核心类型与数据结构、脚手架与功能的先后、并发共享什么 |
| 3 | [Redesign from First Principles（第一性重设计）](principle-redesign-from-first-principles.md) | 把新需求接进已有设计时，假想它从第一天起就是根基假设 |
| 4 | [Attack the Premise（攻击前提）](principle-attack-the-premise.md) | 两个以上共享同一前提的修复在同一关卡失败时 |
| 5 | [Subtract Before You Add（先减后加）](principle-subtract-before-you-add.md) | 排序一个新增、重构或重写时，先移除死重 |
| 6 | [Minimize Reader Load（最小化读者负荷）](principle-minimize-reader-load.md) | 审阅或塑形难以追踪的代码时 |
| 7 | [Outcome-Oriented Execution（结果导向执行）](principle-outcome-oriented-execution.md) | 有明确阶段边界的计划性重写与迁移 |
| 8 | [Experience First（体验优先）](principle-experience-first.md) | 产品、UX 或功能范围的权衡 |
| 9 | [Exhaust the Design Space（穷尽设计空间）](principle-exhaust-the-design-space.md) | 无先例的新交互或架构决策 |
| 10 | [Build the Lever（造杠杆）](principle-build-the-lever.md) | 任何非平凡工作：造工具而不是手工做 |

## Architecture 架构组

| # | 原则 | 适用时机 |
|---|---|---|
| 11 | [Model the Domain（为领域建模）](principle-model-the-domain.md) | 写有状态逻辑，或分支很多、同一形状假设散落多文件时 |
| 12 | [Boundary Discipline（边界纪律）](principle-boundary-discipline.md) | 接校验、错误处理或框架适配器时 |
| 13 | [Type System Discipline（类型系统纪律）](principle-type-system-discipline.md) | 在任何静态类型语言里设计类型或签名 |
| 14 | [Make Operations Idempotent（让操作幂等）](principle-make-operations-idempotent.md) | 设计在崩溃、重启、重试中运行的命令与循环 |
| 15 | [Migrate Callers Then Delete Legacy APIs（先迁移调用方再删旧 API）](principle-migrate-callers-then-delete-legacy-apis.md) | 引入新内部 API 而旧调用方仍存在时 |
| 16 | [Separate Before Serializing Shared State（先分离再串行化共享状态）](principle-separate-before-serializing-shared-state.md) | 并发参与者可能写同一文件、分支、键或对象时 |

## Verification 验证组

| # | 原则 | 适用时机 |
|---|---|---|
| 17 | [Prove It Works（证明它真的能跑）](principle-prove-it-works.md) | 任务之后、宣布完成之前，对着真实制品验证 |
| 18 | [Fix Root Causes（修根因）](principle-fix-root-causes.md) | 调试时，把症状回溯到系统最初出错的那一处 |
| 19 | [Sequence Work into Verifiable Units（串成可验证单元）](principle-sequence-verifiable-units.md) | 多步骤工作，以及 commit 与 PR 的堆叠方式 |
| 20 | [Test Behavior, Not Implementation（测行为不测实现）](principle-test-behavior-not-implementation.md) | 写、改、保留测试时 |
| 21 | [Explain the Number（解释那个数字）](principle-explain-the-number.md) | 测量之前，以及信任或汇报某个测出的数字之前 |

## Delegation 委派组

| # | 原则 | 适用时机 |
|---|---|---|
| 22 | [Guard the Context Window（守住上下文窗口）](principle-guard-the-context-window.md) | 上下文被填满：大输出、长文件、重复读、fan-out 规划 |
| 23 | [Never Block on the Human（绝不停下来等人类）](principle-never-block-on-the-human.md) | 对可逆工作想说"要不要我做 X？"时 |

## Meta 元

| # | 原则 | 适用时机 |
|---|---|---|
| 24 | [Encode Lessons in Structure（把教训编码进结构）](principle-encode-lessons-in-structure.md) | 发现自己第二次写同一条指令，或注意到反复出现的纠正 |

## 三条最值得先读的

若只读三条：[Prove It Works](principle-prove-it-works.md)（最普遍的失效模式是宣称完成而实际没完成）、[Attack the Premise](principle-attack-the-premise.md)（最浪费时间的失效模式是连续修三次都没修好）、[Guard the Context Window](principle-guard-the-context-window.md)（最隐蔽的失效模式是上下文污染后判断力下降）。

## 三条容易被读歪的

`Laziness Protocol` 不是偷懒，是克制加抽象，反义词是过度设计。`Never Block on the Human` 不是不要汇报，是不要为可逆决策索取批准，在不可逆操作前必须被更严的权限规则覆盖。`Experience First` 不是忽略技术约束，是功能范围与实现便利冲突时优先用户。

## 一条统计

24 个源文件合计 33,868 字符，24 篇译文合计约 16,100 字节（中文 UTF-8 三字节每字，约 5,300 汉字）。列表项数量逐条核对一致：90 = 90。
