# why 全文翻译

> 翻译自 `skills/why/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: why
description: "用于 'why does X work this way'、'why we picked Y'、设计动机、回归、复盘（postmortem）、或有数据支撑的阈值类问题。先发现可用的 MCP，再并行查询每个证据类别（源码版本历史、issue/工单跟踪器、长文档、实时团队聊天、基础设施可观测性、错误跟踪、产品分析数仓），然后返回一份带引证的、关于决策与取舍的解读。运行时行为问题用 how。"
disable-model-invocation: true
---
```

---

## Why

调查代码背后的动机与意图。配套的 `how` 技能回答代码做什么、如何运作；`why` 回答是哪些力量塑造了它如今的形状。

下文每个 spawn 都点名 pstack 配置文件（settings file）里的一行角色配置（Cursor 中为 `~/.cursor/rules/pstack-models.mdc`，Claude Code 中为 `~/.claude/rules/pstack-models.md`，其他宿主环境为 `~/.agents/pstack-models.md`）和一个默认值。把 `model` 设为该行的值；文件或该行缺失时用默认值。值为 `auto` 或 `inherit-parent` 时把 `model` 留空。你的子智能体（subagent）工具拒绝某个 slug 时，改用默认值并说明。它拒绝默认值时，从其报错信息或你的宿主环境的模型清单里取同家族最近的合法 slug。按 **poteto-mode** 技能的子智能体（Subagents）一章，为这件活给每个子智能体选推理档位与 fast/标准速度。

每个 spawn 都是 `generalPurpose` 且 `readonly: false`（agent 模式）。**不要用 readonly/Ask 模式。** 该模式会剥离 MCP 访问，从而废掉依赖 MCP 的调查员（investigator）与综合者（synthesizer）的引证抽查。调查员仍不应写任何东西。

## 运作姿态（Operating Posture）

以**细致、审慎、精确的调查员**身份运作。对你知道的与你推断的要诚实区分。读 `references/epistemics.md` 获取完整的置信度框架与措辞指南。综合者必须遵循它。

## Step 1. 理解对象与问题

**对象（target）**通常是一段代码、一个模式、一个特性，或一个有名有姓的设计决策。**问题（question）**通常是一个设计动机、一项取舍、一个促成设计的边界情形、一个外部约束、一段死代码，或一次大范围的历史梳理。

对象模糊时（"为什么我们这么做？"而无可指的具体物），从对话上下文里给出你的最佳猜测（打开的文件、最近的编辑、光标位置、刚讨论过的内容）。简要陈述你的理解，便于用户纠偏，然后继续。

## Step 2. 建立代码锚点

派出调查员之前，先在本线程内搭好种子上下文：文件路径与行区间、关键符号（函数、类、常量）、最近触及该对象的几条 commit、merge commit 里的 PR 号（subject 行中的 `(#1234)` 模式），以及所有关联 ticket ID。跑 `git blame -L <start>,<end> <file>` 拿最后触碰的 commit；`git log --follow -p -- <file>` 拿跨重命名的完整历史与补丁；`git log --oneline -20 -- <file>` 拿 PR 号可见的近期 commit；`git log -1 --format=%B <commit>` 提取 PR 号。然后为任何有实质内容的 commit 拉取 PR 正文与讨论：`gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews`。这份锚点发给每一位调查员，也发给综合者。

## Step 3. 并行派出调查员

**默认执行完整的并行调查。** 目标是一张完整的覆盖地图，不是最小覆盖。把"空"记录下来，不要跳过搜索。

### 发现（Discovery）

派出调查员之前，先列出你的宿主环境连接的 MCP 服务器。有可用工具映射就用它。Cursor 里你还可以检查它暴露的 `mcps/` 目录来确认已启用的 MCP 服务器。其他宿主环境里，MCP 工具通常直接出现在工具清单中，工具名里带服务器名（如 Claude Code 的 `mcp__<server>__<tool>`）。

把每个可用的 MCP 归入恰好一个证据类别：

1. 源码版本历史
2. issue/工单跟踪器
3. 长文档
4. 实时团队聊天
5. 基础设施可观测性
6. 错误/异常跟踪
7. 产品分析数仓

源码版本历史经 git 与 `gh` 永远可得。其余六类按 MCP 名称、服务器说明、工具名与资源描述符归类。一个 MCP 可能同时符合多个类别时，选与它的主要证据匹配的那一个。含糊的 case 记入覆盖地图。

有匹配 MCP 的每个类别各派一名调查员，全部在一条消息里派出以便并发，每人恰好认领一个工具或 MCP。不要让一个 agent 覆盖多个 MCP。`model`：`why investigators` 行，默认 `grok-4.7-xhigh-fast`。

每个调查员的 prompt 是填好的 `references/investigator-prompt.md`，再加上：

- 所选 MCP 对应的类别剧本 `references/sources/<source>.md`，改编自 `references/source-playbook.md` 中的示例
- `references/sources/incident-postmortem.md`——**当目标代码看起来是防御性的**（null 检查、重试逻辑、超时处理、限流、feature flag、出口守卫（egress guards）、OOM 处理）
- 代码锚点与用户的原始问题

**其他宿主环境。** 本技能的 spawn 用的是 Cursor 的 `Task` 工具。在其他宿主环境用它的子智能体工具：Claude Code 用 `Agent`（`subagent_type: general-purpose`），OpenCode 用 `task`（`subagent_type: general`），Codex 用 `spawn_agent`。保留 prompt 与模型。你的工具没有的参数就去掉。宿主环境没有子智能体工具时（如未装扩展的 Pi），由你逐个亲自充当调查员，一个接一个。

### 调查员名册（investigator roster），每个可用证据类别一名

下面每个类别都各自处在独一无二的位置上，最擅长浮现某一种形状的"why"，写在 "Best at" 之后。用它来预期能拿回什么、在某个类别返回空时点名缺口，以及——仅在极少数可证明不相关的情形——为跳过提供依据。

1. **源码版本历史**（git 历史、查 PR 用 `gh`、代码注释、测试）。必派，唯一有保证的来源。最擅长：*评审期被记录下来的实现期动机*。
2. **issue/工单跟踪器**（如 Linear、Jira、GitHub Issues、Plane、Shortcut 的 MCP）。最擅长：*产品或业务层面的强制力（forcing function）*。当 why 在工程之外时最有用。
3. **长文档**（如 Notion、Confluence、Google Docs、Coda 的 MCP）。最擅长：*成文的长篇设计动机*，写于它变成代码之前。
4. **实时团队聊天**（如 Slack、Discord、Microsoft Teams、Mattermost 的 MCP）。最擅长：*从未落进文档的实时讨论*。当源码、工单、文档的纸面链条很薄时尤其重要。
5. **基础设施可观测性**（如 Datadog、New Relic、Honeycomb、Grafana、Splunk 的 MCP）。最擅长：*催生这段代码的基础设施与运行时现实*。当对象在响应某个基础设施信号（超时、重试、限流、熔断器）时最有用。
6. **错误/异常跟踪**（如 Sentry、Rollbar、Bugsnag、Airbrake 的 MCP）。最擅长：*催生防御性或纠正性代码的具体异常与错误轨迹*。对 catch 块、null 守卫、类型检查、重试及其他防御最有用。
7. **产品分析数仓**（如 Databricks、Snowflake、BigQuery、ClickHouse、dbt、Redshift 的 MCP）。最擅长：*塑造了这段代码的产品与数据现实*。对 flag 门控的代码、实验驱动的上线、数据迁移，以及"这个数字是哪来的"一类问题最有用。

### 何时跳过某位调查员

只有带着**明确的、成文的理由**才能跳过，理由要进最终的 Sources Consulted。两个有效理由：

- **该类别在本环境没有可用 MCP。** 把它标为缺口，而不是一项选择："跳过实时团队聊天。没有匹配的 MCP 可用，因此对话记录无法检索。"
- **该来源可证明不相关**，而不只是"大概不相关"。门槛很高："跳过错误/异常跟踪。目标是一个构建期脚本，没有运行时代码路径。"

如果你的范围评估指向一个单 commit 的琐碎对象、且 PR 描述已包含完整答案，你可以**在确认全部七个可用类别的搜索都将是冗余之后**才 inline 作答。要明确说出这一点。这应当罕见。

## Step 4. 综合（Synthesize）

派一名综合者（synthesizer）。`model`：`why synthesizer` 行，默认 `claude-opus-5-5-xhigh`。它拿到：

1. 全部调查发现，包括空结果、以及带理由被跳过的类别
2. 代码锚点
3. 用户的原始问题
4. 来自 `references/epistemics.md` 的认识论（epistemics）框架
5. 来自 `references/synthesizer-prompt.md` 的综合者 prompt 模板

## Step 5. 呈现（Present）

把综合者的产出呈现给用户。你可以为清晰起见轻度编辑，或从对话补充上下文，但**不要改写置信度措辞**。

## 输出格式（Output Format）

结构采用 `references/synthesizer-prompt.md` 里的那一份：The Question、The Code in Question、What We Found、What We Can Reasonably Infer、Competing Hypotheses、What We Don't Know、Sources Consulted、Confidence Summary。可按需调整，但置信度的分层拆分必须原样保留；Sources Consulted 保持每位调查员一行，包括返回空的与被跳过的，并写明原因。

Sources Consulted 之后，如果用户的 `why` 问题是要改动这段代码的前奏，就把谱系发现转化为 Preserve / Change / Avoid / Risk 约束集，供规划这次改动使用。

## 常见失败模式（Common Failure Modes to Avoid）

- **近因偏差（Recency bias）**。假定最近的 commit 就是权威。如今的形状往往是更早许多次决策层层累积的结果。往前追。
