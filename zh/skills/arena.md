# arena 全文翻译

> 翻译自 `skills/arena/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: arena
description: "在同一任务上并行派生 N 个候选（candidate），选出一个基底（base），把落选者最强的部分嫁接（graft）进去。用于 /arena、'arena this'、'throw it in the arena'，或当对一份非平凡制品（artifact）的一次尝试就会把错误的形状定死时。"
disable-model-invocation: true
---
```

---

# Arena

启动任何东西之前，先打开一个待办清单，每个阶段一个条目：Frame（定框）、Fan out（扇出）、Cross-judge（交叉评审）、Pick（选基底）、Graft（嫁接）、Verify（验证）。

## Phase A：定框（Frame）

每个候选拿到同一个 prompt，所以 prompt 就是契约。

1. 写明每个候选要产出的制品。
2. 推导评分标准（rubric）：3-6 条具体的、可打分的准则，定义*本*任务上成功长什么样。它是 Phase D 里挑选者的工具。候选只看到任务。
3. 选参赛者（runner）。用 pstack 配置文件（settings file）里的 `arena runners` 行（Cursor 中为 `~/.cursor/rules/pstack-models.mdc`，Claude Code 中为 `~/.claude/rules/pstack-models.md`，其他宿主环境为 `~/.agents/pstack-models.md`）。文件或该行缺失时，默认在 `claude-opus-5-5-xhigh` 与 `grok-4.7-xhigh-fast` 上各占一席。该行中的 `auto` 或 `inherit-parent` 条目指父模型，此时省略其 `model`。你的子智能体（subagent）工具拒绝某个已配置条目时，该席位改跑其家族的默认模型，并说明。家族按前缀划分：`claude-*`，以及 `grok-*`（含 `cursor-grok-*` 与 `composer-*`）。被拒绝的 `composer-*` 条目改跑 `grok-4.7-xhigh-fast`。该家族没有默认模型、或你的子智能体工具拒绝该默认时，从其报错信息或你的宿主环境的模型清单里取同家族最近的合法 slug；一个都没有时丢掉该席位并说明。被丢的席位导致参赛者不足两个时，补参赛者直到有两个；该行只有一个条目时补到一个即可。每个新增参赛者跑在某个剩余参赛者的模型上；一个都不剩时省略 `model`，让它跑在父模型上，并说明。竞技场覆盖多个设计方向时多派参赛者。工作受生成吞吐限制而不是对判断敏感时，同一模型用 N 次。每个子智能体的推理档位与 fast/标准速度，按 **poteto-mode** 技能的子智能体（Subagents）一章为这件活来选。
4. 给每个候选自己的输出位置：能上 git worktree（Git 工作树）就上，否则用 `/tmp/arena-<slug>/candidate-<n>/`。依据 **separate-before-serializing-shared-state** 原则技能。

## Phase B：扇出（Fan out）

在一条消息里派生全部 N 个子智能体，带 `run_in_background: true`；每个拿到任务、共享依据材料（grounding）的路径、自己的输出路径，以及产出制品并写一份简短 rationale 的指令——rationale 要点名它考虑过哪些备选、拒绝了什么。

某个候选没有产出时，按 N-1 继续，并记下这次缺席。

## Phase C：交叉评审（Cross-judge）

Phase B 全部候选完成后，从 pstack 配置文件的 `arena cross-judge pool` 行里选一个模型。文件或该行缺失时，从 `claude-opus-5-5-xhigh` 与 `grok-4.7-xhigh-fast` 里选。派生一个 readonly 评审子智能体（judge）。评审者绝不来自父模型的家族，家族划分见 Phase A 第 3 步。只按池内顺序尝试来自另一个家族的条目。`auto` 或 `inherit-parent` 条目即父模型，永远不评审。默认池下，Claude 父模型拿到 `grok-4.7-xhigh-fast`；其他任何家族的父模型先试 `claude-opus-5-5-xhigh`。你的子智能体工具拒绝某个条目时，从其报错信息或你的宿主环境的模型清单里取同一模型最近档位或速度的合法 slug；没有就换下一个条目。来自另一家族的条目一个都没跑起来时，按同样方式改试默认池里来自另一家族的条目。这些也都不行时，跳过评审者，Phase D 独自选基底，并说明。不知道父模型是什么时，按池内顺序试池中的真实 slug，并说明家族检查没有执行。评审者看到 rubric 与以路径标签指代的各候选，逐条准则打分，并给出基底推荐与理由。它与你在 Phase D 的阅读并行。候选还在写时不要派它。

## Phase D：选基底（Pick a base）

挑选之前，每个候选从头到尾读完。按 rubric 逐条准则给每个候选打分，不凭整体感觉；Phase C 跑了交叉评审时与它对照。双方对基底一致，确认这次挑选。不一致说明你们之一有偏差、或 rubric 有歧义。决定之前，把两份 rationale 都读一遍。

选那个未来的维护者最容易在不破坏不变式（invariant）的前提下扩展的基底。两个感觉打平时，按 Laziness Protocol（懒惰协议）选边界更干净或 API 更小的那个。

## Phase E：嫁接（Graft）

把每个落选候选再过一遍，找值得搬进基底的东西，通常每个候选一两处，不是它的大部分。每个嫁接（graft）都手工融合，依据 **redesign-from-first-principles** 原则技能，让结果在同一个心智模型下保持连贯。不要机械粘贴。

候选收敛到同一个形状，就是强共识。记下它，交付共识形状，无需嫁接。它们剧烈发散，则是 Phase A 定得不够细。重新定框重跑，不要把发散取平均。

## Phase F：验证（Verify）

像验证任何其他产出一样验证综合出的制品，依据 **prove-it-works** 原则技能。验证发现竞技场漏掉的问题时，要么是 Phase A 错了（重新定框重跑），要么是某个候选抓到了它而你漏了嫁接（回到 Phase E）。不要粉饰过去。

## 输出（Outputs）

一份综合出的制品，旁边附一段简短的综合说明，写明基底及其理由、交叉评审的裁决（或 Phase C 跳过了评审者）、每个嫁接及其来源候选、拒绝了什么及为何、任何收敛或缺席，以及验证结果。
