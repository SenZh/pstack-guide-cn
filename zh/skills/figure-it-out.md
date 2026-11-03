# figure-it-out 全文翻译

> 翻译自 `skills/figure-it-out/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: figure-it-out
description: "没有更窄的剧本（playbook）适用时，设计一份可审计的步骤剧本：大型迁移、野心十足的多部分变更，或人类离开之后回来审阅的工作。把严谨度随任务伸缩，跑假设循环，记录决策。用于 /figure-it-out 或 \"figure it out\"。"
disable-model-invocation: true
---
```

---

# Figure it out

任务匹配不上任何剧本时，自己设计一个。
任何代码之前的交付物就是工作流本身：一串阶段，严谨度随任务伸缩、跑科学方法、并留下人类离开后可审计的决策轨迹。

## 开始（Start）

开一个 todolist，第一项是读 **poteto-mode** 技能的 Principles 章节。
然后把下面的阶段加为待办。

## Phase A: Frame（框定）

先落地事实，再下承诺。能陈述以下内容之前不开跑：

- 完成的定义，写成一个可证伪的谓词（**prove-it-works** 原则技能）。
- 范围，量化：粗略单位与工作量，加上事实落地时暴露的阻塞。
- 严谨档位，偏高取。
  单向门（one-way door）与高爆炸半径（blast radius）多给；可逆的低风险步骤少给。
  严谨是门禁（gate）与制品（artifact），不是"更用力"。

长跑之前先呈现框定与取舍。
可逆的工作继续推进（**never-block-on-the-human** 原则技能），但一个多小时级的运行值得一次检查点（checkpoint）。

## Phase B: Design the workflow（设计工作流）

分解为原子的、可独立落地的单元。风险最大的未知排在最前。
脚手架（scaffold）与验证先于功能（**foundational-thinking** 原则技能）。

- 先建验证宿主（harness）再干活，基线从改动前状态捕获，让检查读作"旧值 vs 新值"。
- 单向门式的设计决策，跑 **architect** 技能（它会跑 **arena**）。
  形状已经具体的机械性工作跳过它。
  在一个已定设计上再开一场 arena 是过度工程（**laziness-protocol** 原则技能）。
- 决定什么做扇出（fan-out）。
  只在接缝处并行，给每个 worker 自己的 worktree 或分支（**separate-before-serializing-shared-state** 原则技能）。
  不要过度扇出。
  按 **poteto-mode** 技能的 Subagents 章节，为每个子智能体（subagent）挑推理档位（reasoning level）与快/标准速度。
- 把设计好的阶段清单写下来。那份清单就是人类审阅的东西。

然后执行这个设计。
把它的步骤作为具体条目加进 todolist，插在 Phase C 与 Phase D 条目之间。
每一步都在 Phase C 的循环纪律下运行，并把 Phase D 的日志贯穿其间：每落地一步就记一行，而不是把整条轨迹攒到最后。

## Phase C: Run the loop（跑循环）

每个单元都是一次实验。
陈述假设，做最小改动，对着谓词在真实制品上测量，有进展就保留，没有就回退。
应用 **sequence-verifiable-units** 原则技能：先验证当前单元再开始下一个，不把检查攒到最后批量做。

- 靠检查制品验证，绝不信自述。
  什么东西通过得太轻松时，先怀疑观测方法，再怀疑系统。
- 委派（delegate）出去的工作配上裁判。
  worker 把门禁耍过去了，重置并加固契约。
  门禁本身错了，在它自己的变更里修门禁，不要绕行。
- 裁决只有三种：VERIFIED、NOT VERIFIED、INCONCLUSIVE。
  Inconclusive 不是通过。不藏负面结果。

## Phase D: Keep the audit trail（保持审计轨迹）

用 **show-me-your-work** 技能记录这次运行。
figure-it-out 的活通常够重大，值得把轨迹提交进库，让审阅者能在 PR 里读它。
轨迹加 diff，人类回来才能信任这份工作。

## Phase E: Verify and hand back（验证并交回）

对整个成果在真实产品上对照 Phase A 的谓词检查，不只是在宿主上。
反复出现的纠正，编码为门禁、lint 规则、检查或脚本（**encode-lessons-in-structure** 原则技能）。

**回应（Reply）：** 你设计的剧本、严谨档位及其理由、决策轨迹的路径、对照谓词验证了什么、还有什么没解决。
