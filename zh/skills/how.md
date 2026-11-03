# how 全文翻译

> 翻译自 `skills/how/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: how
description: "用于 \"how does X work\"、改东西之前的代码走读，以及落位 / 所有权 / 分层问题（\"where should this live\"、\"which package owns this\"、\"is this the right layer\"）。解释子系统架构、运行时流程、上手心智模型。动机类问题用 why。"
disable-model-invocation: true
---
```

---

# How

探索代码库来回答 "how does X work?" 这类问题。产出架构级解释，深度对标一个资深工程师刚接手某个子系统时的上手需求：足以建立能运转的心智模型，又不至于读起来像带注释的源码。

每次派生都是一个 `subagent_type: generalPurpose`、`readonly: true` 的 Task 子智能体（subagent）。探索者（explorer）用 pstack 配置文件（settings file）里的 `how explorer` 行（Cursor 中为 `~/.cursor/rules/pstack-models.mdc`，Claude Code 中为 `~/.claude/rules/pstack-models.md`，其他宿主环境为 `~/.agents/pstack-models.md`；默认 `grok-4.7-xhigh-fast`），每个讲解者（explainer）用 `how explainer` 行（默认 `claude-opus-5-5-xhigh`）。`model` 设为该行的值；文件或该行缺失时用默认值。值为 `auto` 或 `inherit-parent` 时 `model` 留空。你的子智能体工具拒绝某个 slug 时，用默认值并说明。它拒绝默认值时，从其报错信息或你的宿主环境的模型清单里取同家族最近的合法 slug。每个子智能体的推理档位与 fast/标准速度，按 **poteto-mode** 技能的子智能体（Subagents）一章为这件活来选。

## 1. 评估复杂度（Assess complexity）

范围有歧义时，陈述你的理解并开始探索。用户可以随后纠正方向。

- **简单**（单个模块、小工具、或 "how does function X work" 这类窄问题）：不用探索者。派生一个讲解者，一次探索加讲解一起完成，由 `references/explainer-prompt.md` 构建并去掉 explorer-findings 小节。去第 4 步。
- **复杂**（跨多个文件或服务的子系统、横切功能、完整架构概览）：去第 2 步。

拿不准时，走简单路径。

**其他宿主环境。** 本技能的派生使用 Cursor 的 `Task` 工具。在其他宿主环境，用它的子智能体工具：Claude Code 的 `Agent`（`subagent_type: general-purpose`）、OpenCode 的 `task`（`subagent_type: general`）、Codex 的 `spawn_agent`。prompt 与模型保留。你的工具没有的参数丢掉。宿主环境没有子智能体工具时（如无扩展的 Pi），自己按顺序逐个跑每个角色。

## 2. 探索（Explore）（仅复杂情形）

把问题分解成 2 到 4 个角度，每个角度是子系统的一个不同切片。在一条消息里派生全部探索者，每个带 `references/explorer-prompt.md` 并填入自己的角度。

## 3. 综合（Synthesize）（仅复杂情形）

全部探索者返回后，派生一个讲解者，带 `references/explainer-prompt.md` 并填入每个探索者的 findings（审查发现）。

## 4. 呈现（Present）

呈现讲解者的输出。为清晰或补充对话上下文做轻度编辑是可以的。不要大幅重写它。

## 输出格式（Output format）

讲解使用 `references/explainer-prompt.md` 定义的小节，不适用的小节去掉：Overview、Key Concepts、How It Works、Where Things Live、Gotchas。
