# recall 全文翻译

> 翻译自 `skills/recall/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: recall
description: "从你自己的聊天历史、实时状态与共享记录（用户报告、此前的修复、事故）重建你最近的工作上下文，然后交回一份紧凑的现状简报（brief）。用于 'recall my work on X'、'catch me up'、'what have I been working on'、'where did I leave off'，在开工或续做之前。"
disable-model-invocation: true
---
```

---

# Recall

**在你开工或续做之前，重建用户最近的工作上下文，交回一份紧凑的胶囊（capsule）：现状如何、下一步做什么。**

保持紧凑、紧扣主题。只读在范围内的话题线（thread）所需要的内容，然后停。

你的上下文存在两份记录里。你自己的聊天历史记录你做了什么、决定了什么。共享记录记录在同一批代码周围、以别人名义发生的一切：用户反复上报的症状、上线又被回滚的修复、仍在生产环境触发的错误。第二份记录正是 **why** 技能所搜索的对象——横跨源码版本历史、issue 跟踪器、聊天与 issue 频道、长文档、错误跟踪。一个带着长尾 bug 的特性，它的大部分故事都留在那里，所以不要只靠你会话记录（transcript）重建它。

会话记录放在你的宿主环境存放它们的地方。每个文件是 JSONL。找到你的宿主环境下活跃工作区（workspace）的目录。分不清自己是哪个宿主环境时，检查这个工作区下哪些东西存在：

- **Cursor：** `~/.cursor/projects/<slug>/agent-transcripts/<uuid>/<uuid>.jsonl`。`<slug>` 是工作区路径去掉开头斜杠、每个 "/" 换成 "-"（`/Users/you/proj` 变成 `Users-you-proj`）。
- **Claude Code：** `~/.claude/projects/<slug>/<session-id>.jsonl`。`<slug>` 是工作区路径里每个非字母数字字符换成 "-"（`/Users/you/proj` 变成 `-Users-you-proj`）。
- **Pi：** `~/.pi/agent/sessions/--<slug>--/<timestamp>_<id>.jsonl`。`<slug>` 是工作区路径去掉开头斜杠、每个 "/" 换成 "-"（`--Users-you-proj--`）。
- **Codex：** `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl`，不按工作区分组。只保留首行 `payload.cwd` 等于工作区路径的文件。
- **OpenCode：** `~/.local/share/opencode/storage/`。会话在 `session/<project-id>/` 下是 JSON 文件，消息在 `message/` 与 `part/` 下。

1. 先分类，再路由。要恢复某一段具体的既往对话，那是 `session-pickup` 剧本的事，不是这个。把重复的习惯固化成耐用的技能，那是 `automate-me`。要一份人类可读的工作总结，那是另一个任务。Recall 是在你行动之前装载跨近期对话的工作上下文。用户已经给了你完整的状态胶囊（路径、分支、这次变更）时，直接用它，跳过挖掘。
2. 搜索前先锁定范围。钉住时间窗（"recent" 是一个真实的区间，默认最近 7 天）、主题（如果点名了）、工作区（默认活跃的那个。未被要求绝不读另一个项目的会话记录）。把范围向用户复述。绝不悄悄把 "all" 变成 "recent N"。
3. 在你的聊天历史里 fan out。在快而便宜的模型上派并发子智能体（subagent），每个领一段语料。告诉每个子智能体：按真实修改时间排序候选（`ls -t`），绝不按 UUID 文件名；先 grep 主题，然后只读命中的聊天、且只读其相关区段；跳过当前聊天与明显噪音（子智能体、eval、测试聊天）。每个子智能体返回同一份 schema，每个聊天一个块：主题、用户的目标、决策、悬而未决的话题线、受过的挫折与纠偏、制品（artifact）（PR、ticket、分支），各自引用聊天 UUID。只有一两个聊天时，跳过 fan-out 直接搜。原始会话记录留在子智能体手里。主线程只拿它们的发现。按 **poteto-mode** 技能的子智能体（Subagents）一章，为这件活给每个子智能体选推理档位与 fast/标准速度。
4. 主题点名了某个特性、文件、子系统、领域或 bug 时，扫共享记录。这是默认动作，不是临场判断，"my work on X" 也不能豁免它。把它交给 **why** 技能的源调查员（investigator），但把他们的问题从"为什么这样建"转向"现状如何、试过什么又没站住、用户还在上报什么"。复用它的按源剧本（per-source playbooks），让调查员与聊天历史挖掘并行跑，并继承它的姿态：每个来源一名调查员，空结果是发现，MCP 不可用就跳过并说明。把拿回来的东西并入简报。只有纯粹的活动回顾、没有点名目标时（"我这周干了啥"）才跳过这一步——那时你自己的历史与实时状态就是全部答案。
5. 对照实时状态验证。把挖掘与扫描浮出的 PR、分支、ticket 用 `git` 与 `gh` 核一遍。答案取决于某个 agent 实际做了什么（它跑了哪些工具、读了哪些文件、撞上哪些错误）时，读完整会话记录，不要只读裁剪过的本地副本。
6. 按下述契约写简报。按话题线分组。紧扣被点名的主题。

## 输出契约（Output contract）

胶囊先行，然后是话题线状态，然后是问题，然后是下一步。更深的细节放到底部或删掉。

- **胶囊（Capsule）。** 至多 5 条。这份工作是什么、总体进展到哪。
- **话题线（Threads）。** 每条一行，前缀恰好一个状态标签：`[merged #N]`、`[open PR #N]`、`[in flight <branch>]`、`[verified, uncommitted]`、`[reverted #N]`、或 `[planned, not started]`。没有标签的话题线就是还没完结，给它打上。
- **问题（Problems）。** 至多 5 条，取反复出现的那些。包括用户反复上报的症状、任何上线又被回滚的修复，让下一次尝试从上一次失败处起步。
- **下一步（Next move）。** 单一的最有用的下一个动作，具体。

相邻的特性或 ticket 不进简报，除非它阻塞当前这条。胶囊与话题线行超过一屏时，先删细节，后删话题线。通过 **unslop** 技能写简报，聊天发现按 UUID 引证，共享记录发现按其来源引证（PR 号、ticket ID、聊天永久链接、错误跟踪 issue），任何公开输出前先脱敏私有上下文。

**回应：** 就是简报，符合上述契约。
