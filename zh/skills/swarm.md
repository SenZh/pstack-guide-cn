# swarm 全文翻译

> 翻译自 `skills/swarm/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: swarm
description: "fan-out（一对多并发派发）N 个并行 worker，收齐全部结果后返回一份报告。用于 /swarm、'swarm this'，或并行覆盖、竞速（race）、连环考验（gauntlet）与探索。"
disable-model-invocation: true
---
```

---

## Swarm

## 开始（Start）

启动任何东西之前，先打开一个待办清单，每个阶段一个条目。

1. Frame（定框）
2. Fan out（扇出）
3. Aggregate（汇总）
4. Report（报告）

## Phase A：定框（Frame）

1. 写明完成谓词（done predicate），以及 swarm 必须返回的制品或报告。
2. 选形状。切成多个切片（slice）分区，或用相同的任务简报（brief）让 N 个 worker 竞速，或两者混合。竞速或混合形状时，派生之前先声明 `first pass`、`rank all` 或 `best-of`。
3. 从 pstack 配置文件的 `swarm workers` 行选 worker 模型（Cursor 中为 `~/.cursor/rules/pstack-models.mdc`，Claude Code 中为 `~/.claude/rules/pstack-models.md`，其他宿主环境为 `~/.agents/pstack-models.md`）。文件或该行缺失时，用 `grok-4.7-xhigh-fast`。`auto` 或 `inherit-parent` 时省略 `model`，让 worker 跑在父模型上。你的子智能体工具拒绝某个 slug 时，用默认值并说明。它拒绝默认值时，从其报错信息或你的宿主环境的模型清单里取同家族最近的合法 slug。模型竞速时，事先点名每个臂（arm）的模型。每个子智能体的推理档位与 fast/标准速度，按 **poteto-mode** 技能的子智能体（Subagents）一章为这件活来选。
4. worker 要写输出时，给每个 worker 自己的可写输出。worker 验证或度量 commit 时，每份任务简报点名确切的 SHA。度量类任务简报还要点名方法（样本数、一个样本是什么、顺序）。worker 把两者都记进自己的结果。

## Phase B：扇出（Fan out）

在一条消息里派生全部 N 个 worker，带 `subagent_type: generalPurpose`、`environment: "cloud"`、`run_in_background: true` 与第 3 步的模型（`auto` 或 `inherit-parent` 时留空）。仅当 worker 需要访问用户电脑上的东西时，才用 `environment: "local"`。

worker 必须从非默认的已推送分支开始时，传 `cloud_base_branch`。

**其他宿主环境。** 这些参数属于 Cursor 的 `Task` 工具，`environment: "cloud"` 跑的是 Cursor 云 agent。在其他宿主环境，用它的子智能体工具：Claude Code 的 `Agent`（`subagent_type: general-purpose`）、OpenCode 的 `task`（`subagent_type: general`）、Codex 的 `spawn_agent`。worker 在那边本地运行，所以给每个 worker 自己的 worktree（Git 工作树）或输出路径。任务简报与模型保留。你的工具没有的参数丢掉。宿主环境没有子智能体工具时（如无扩展的 Pi），自己逐个跑 worker。

每份任务简报独立成立。包含目标、范围、确切的切片或竞速臂、如何验证、要报告什么。报告用 `PASS`、`ISSUES` 或 `BLOCKED` 并附证据。能证明缺陷的 worker 报 `ISSUES`，并列出它能证明的每一个问题，不只是第一个。

某个 worker 缺席时，按 N-1 继续，并记下它。

## Phase C：汇总（Aggregate）

读取最终结果。没记录其任务简报点名的 SHA 与方法的结果直接丢掉，并把该 worker 重新派生一次。第二次仍未达标时，记一个缺口（gap）。缺口不算通过。覆盖任务里，每个要求的切片都要有一个结果。竞速任务里，套用事先声明的选择规则，用 first pass、rank all 或 best-of。不要原样粘贴 worker 的原始输出。

## Phase D：报告（Report）

在聊天里返回一份合并报告，含结果表格、问题单行摘要、缺口或缺席、以及（用到时）竞速规则。
