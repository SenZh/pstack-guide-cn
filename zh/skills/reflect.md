# reflect 全文翻译

> 翻译自 `skills/reflect/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: reflect
description: Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete edit on an existing skill. Use when the user says reflect.
disable-model-invocation: true
---
```

---

## Reflect

从当前对话中挖出可沉淀的经验教训（learnings），再把它们路由成对既有技能的具体修改。

用户说 "reflect" 或 "/reflect" 时调用。
对话琐碎、跑题、或已被父级正确遵循的既有技能覆盖时跳过。
一次性的事情不算 learnings。

## 1. 定位活动会话记录（transcript）

扇出（fan-out）之前，先在活动工作区的会话目录里找到本对话的会话记录。
不要跨所有项目的目录去 glob。
那会越过工作区边界、读到无关项目的私人聊天。

会话记录在哪取决于你的宿主环境（harness）：

- **Cursor：** 系统提示词点名的 `agent-transcripts/` 目录。

  ```bash
  ls -t <agent-transcripts>/*.jsonl <agent-transcripts>/*/*.jsonl <agent-transcripts>/*/subagents/*.jsonl 2>/dev/null | head -10
  ```

  它覆盖了旧的扁平布局（`<id>.jsonl`）、当前的嵌套布局（`<id>/<id>.jsonl`）与子智能体（subagent）布局（`<parent>/subagents/<child>.jsonl`）。
  对每个候选，读第一行 JSONL。
  取 `message.content[0].text` 含本对话开头用户 prompt 的那个文件。
- **Claude Code：** `~/.claude/projects/<slug>/<session-id>.jsonl`，其中 `<slug>` 是把工作区路径里每个非字母数字字符换成 "-"。
- **Pi：** `~/.pi/agent/sessions/--<slug>--/*.jsonl`，其中 `<slug>` 是工作区路径去掉开头斜杠、每个 "/" 换成 "-"。
- **Codex：** `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl`。只保留首行 `payload.cwd` 等于工作区路径的文件。
- **其他宿主环境：** 查该宿主环境为此工作区设的会话目录。

Cursor 之外，先取最新的候选，靠在其中第一条用户消息里找到本对话的开头用户 prompt 来确认。
都不匹配的话，改为传入一份该会话的紧凑摘要（digest）。

## 2. 并行派出三个审阅者

一条消息、三个 `Task` 调用、`subagent_type: generalPurpose`、agent 模式（`readonly: false`）。
审阅者需要 MCP 访问去查会话记录引用的工单、聊天线程和可观测性 trace，readonly 会剥掉 MCP。

**其他宿主环境。** 本技能的派生用 Cursor 的 `Task` 工具。
在别的宿主环境，用它自己的子智能体工具：Claude Code 的 `Agent`（`subagent_type: general-purpose`）、OpenCode 的 `task`（`subagent_type: general`）、Codex 的 `spawn_agent`。
prompt 与模型保留。
你的工具没有的参数去掉。
宿主环境没有子智能体工具（如 Pi 不装扩展）的话，由你自己逐个角色轮流执行。

每个审阅者与合成者（synthesizer）都在 pstack 配置文件（settings file）里点名一个角色行和一个默认值。
Cursor 是 `~/.cursor/rules/pstack-models.mdc`，Claude Code 是 `~/.claude/rules/pstack-models.md`，其他宿主环境是 `~/.agents/pstack-models.md`。
`model` 设为那一行的值，文件或那一行缺失则设为默认值。
值为 `auto` 或 `inherit-parent` 时把 `model` 留空。
子智能体工具拒绝某个 slug 的话，用默认值并说明。
默认值也被拒的话，用其报错信息或你宿主环境模型列表里同家族最接近的有效 slug。
按 **poteto-mode** 技能的 Subagents 章节，为每个子智能体挑推理档位（reasoning level）与快/标准速度。

| 视角（Lens） | 角色行 | 默认 `model` | Prompt 模板 |
|---|---|---|---|
| Judgment | `reflect judgment, divergent, synthesizer` | `claude-opus-5-5-xhigh` | `references/judgment-reviewer.md` |
| Tooling | `reflect tooling` | `grok-4.7-xhigh-fast` | `references/tooling-reviewer.md` |
| Divergent | `reflect judgment, divergent, synthesizer` | `claude-opus-5-5-xhigh` | `references/divergent-reviewer.md` |

每个模板逐字传入，在标记处替换会话记录路径或摘要。
审阅者的发现（findings）放在 `Task` 响应体里返回。

## 3. 合成（Synthesize）

一次 `Task` 调用、`subagent_type: generalPurpose`、`model` 取 `reflect judgment, divergent, synthesizer` 那一行（默认 `claude-opus-5-5-xhigh`）、agent 模式（`readonly: false`）。
它通过 MCP 抽查引用，readonly 会剥掉 MCP。
逐字传入 `references/synthesizer.md`，并在标记处内联每个审阅者的完整输出。
它返回 Accepted / Rejected / Backlog 清单。

## 4. 结构化强制检查

凡是 lint 规则、脚本、元数据标记或运行时检查能更可靠地强制执行的 Accepted 项，移到 Backlog。
见 **encode-lessons-in-structure** 原则技能。

## 5. 应用（Apply）

呈现合成者的完整 Accepted / Rejected / Backlog 输出，等待明确批准后再应用任何 Accepted 修改。
用户挑选子集，并可能改写路由。
技能修改影响组织里未来的每一个 agent。绝不自动应用。

每个 Backlog 项不等审批、直接归档到你们团队的 devex 或 backlog 追踪器。
只有 Accepted 清单等批准。

绝不编辑 `plugins/cache/` 下的技能。
批准前，展示目的地：Cursor 的 `.cursor/skills/<skill>/` 或 `~/.cursor/skills/<skill>/`，或你的宿主环境的项目/用户技能目录，如 `.claude/skills/<skill>/` 或 `~/.agents/skills/<skill>/`。
批准后，把技能目录复制过去并编辑副本。
绝不开 PR 或 push。

严格按每个已批准行的 Routing（路由）执行：

- 微小的既有技能修改（一行要点、一句收紧的话、一个过时事实的订正）：父级直接做。
- 实质性的既有技能修改（新小节、新模式表、超过约 10 行）：交给你的宿主环境的技能撰写技能，跑它的起草/测试/迭代循环。
  Cursor 是内置的 `create-skill`，Anthropic 是 `skill-creator`。
  两个都没有的话，遵循 agentskills.io 的 Agent Skills 格式。
  下文的 "`create-skill`" 指你实际使用的那一个。
- `tune description: <skill path>`（技能存在但该触发时没触发）：交给 `create-skill`，跑它的 description 优化循环。
- `new skill via create-skill: <kebab-name>`：把创建交给 `create-skill`。不要临时发明形状。

你的环境自带 SKILL.md 校验器的话，宣布完成前对每个触碰过的技能跑一遍。

## 6. 给用户做总结

简短清单，不要开场白：

- 已应用的修改：`<skill path>`。改了什么，每条一行。
- 新建的技能：`<skill path>`。每条一行（罕见）。
- 已归档到 devex 追踪器的 Backlog：`<issue title>`（`<tags>`）。每条一行。
- 已丢弃：每个被拒的发现一行 + 合成者给出的理由。
