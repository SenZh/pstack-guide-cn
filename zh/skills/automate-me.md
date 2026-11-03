# automate-me 全文翻译

> 翻译自 `skills/automate-me/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: automate-me
description: "用于 \"automate me\"、\"create/update/refresh my -mode skill\"、\"turn/capture my preferences or working style into a skill\"，或想让 agent 按用户的工作方式行事时。通过 create-skill + unslop 起草或修订个人 -mode 技能，可选地从最近的会话记录（transcript）拉取新鲜证据。"
disable-model-invocation: true
---
```

---

# Automate me

一套引导式流程，把用户的工作约定变成 agent 会遵循的技能。
产出是一个为其量身定制的 `-mode` 技能（如 `jay-mode`、`priya-mode`）。

本技能编排另外三个：一个内联的挖掘环节（见第 1 步）、你的宿主环境（harness）的技能撰写技能（authoring），以及 **unslop** 技能（散文纪律）。
它给它们排顺序，不取代它们。

技能撰写技能在 Cursor 是内置的 `create-skill`，Anthropic 的是 `skill-creator`。
两个都没有的话，遵循 agentskills.io 的 Agent Skills 格式。
下文的 "`create-skill`" 指你实际使用的那一个。

## 流程（Flow）

### 0. 检查既有技能

在宿主环境的技能目录里递归查找匹配用户 handle 的 `*-mode/SKILL.md`。
项目级：`.cursor/skills/`（Cursor）、`.claude/skills/`（Claude Code）、`.pi/skills/`（Pi）或 `.agents/skills/`（Codex、OpenCode 及其他）。
用户级：`~/.cursor/skills/`、`~/.claude/skills/`、`~/.pi/agent/skills/`、`~/.codex/skills/`、`~/.config/opencode/skills/` 或 `~/.agents/skills/`。
mode 技能可以放在个人分类目录（`<skills>/<handle>/`）里，不只在顶层。
已存在的话，用你的结构化提问工具（Cursor 的 `AskQuestion`、Claude Code 的 `AskUserQuestion`、OpenCode 的 `question`）确认意图，除非他们已经说过"更新我的技能"或类似的话：

- 更新既有技能（重复运行的默认）
- 从零重写（罕见，做之前先问为什么）

更新模式改变流程的其余部分：
- 第 1 步只挖掘该技能上次被编辑之后的历史（`git log -1 --format=%cI <path>`）。
- 第 2 步问的是变了什么、缺了什么，不是从零捕获什么。
- 第 4 步就地编辑既有文件。用户没有推翻的小节保持原样。有新证据的才修订。只有真正的新规则才新增小节。

### 1. 挖掘历史

扇出（fan-out）之前，先定位活动工作区的会话记录（transcript）。
只用那个工作区的目录。
不要跨所有项目的目录去 glob。
那会越过工作区边界、读到无关项目的私人聊天。
记录在哪取决于你的宿主环境：

- **Cursor：** 系统提示词点名了 `~/.cursor/projects/` 下该工作区的 `agent-transcripts/` 目录。
- **Claude Code：** `~/.claude/projects/<slug>/*.jsonl`，其中 `<slug>` 是把工作区路径里每个非字母数字字符换成 "-"。
- **Pi：** `~/.pi/agent/sessions/--<slug>--/*.jsonl`，其中 `<slug>` 是工作区路径去掉开头斜杠、每个 "/" 换成 "-"。
- **Codex：** `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl`。只保留首行 `payload.cwd` 等于工作区路径的文件。
- **其他宿主环境：** 该宿主环境为此工作区设的会话目录。

在这个范围内排查最近的 agent 对话里反复出现的模式。
跨历史切片并行跑多个子智能体（subagent）（如最近 2-4 周切成 3 片，每片都有足量素材）。
按 **poteto-mode** 技能的 Subagents 章节，为每个子智能体挑推理档位（reasoning level）与快/标准速度。
每个切片挖掘子智能体从父级提供的工作区范围内的路径读会话记录，寻找下面的信号，并返回一份带证据指针的简明结构化模式清单。
值得搜寻的默认信号：

- 回应偏好（长度、语气、格式、"说人话"式的纠正）
- 委派（delegate）习惯（子智能体、模型、专门工作流、并行度）
- 验证姿态（"done"意味着什么、单元测试 vs 活体复现、审阅者）
- 代码与散文纪律（风格、引用的原则、lint/格式化工具）
- 流程约定（worktree、commit、PR、review/merge 工具）
- 元偏好（任务中途修技能、提议新技能）

提升某个信号之前先跨切片交叉核对。
2 个以上切片都见到的模式是高置信。
孤证是弱信号，通常直接丢弃。

### 2. 直接问用户

挖掘会漏掉还没出现过的意图。
用你的结构化提问工具（结构化多选：Cursor 的 `AskQuestion`、Claude Code 的 `AskUserQuestion`、OpenCode 的 `question`），不要让用户从零打字。
宿主环境没有的话，在聊天里用编号选项提问。

形态：一到两个问题、每个 4-6 个选项、分类问题允许多选（Cursor 的 `allow_multiple: true`）。
先宽问（"哪些领域最重要？"），再对选中的领域用具体选项追问。
结构化轮次之后，留一个自由格式的聊天问题兜住选项漏掉的。

别一口气甩 20 个问题。

### 3. 聚类发现（findings）

把合并后的信号分组为小节。常见小节（只取适用的）：

- **Response style**：长度、语气、格式。
- **Autonomy**：不问就做多少事、MCP 工具使用。
- **Understand first**：圈定范围或调查改动时先伸手拿哪些技能。
- **Subagents**：默认、并行度、模型配任务、专门工作流。
- **Prose / code discipline**：原则、lint 工具、风格指南。
- **Review and verify**：复现（repro）姿态、验证技能、活体测试工具。
- **Process**：git worktree、commit、PR、review/merge 工具。
- **Skills**：技能撰写习惯、先修技能、提议新技能。

**poteto-mode** 技能展示了这个形状。
读它学颗粒度。不要抄它的内容。
用户的规则不等于 poteto-mode 的规则。

### 4. 起草技能

用你的技能撰写技能（`create-skill`）来撰写。放置位置：

- 路径：保留既有 mode 技能的分类。
  新的 mode，当仓库已为该 handle 建立了个人分类时用 `<skills>/<handle>/<handle>-mode/SKILL.md`。
  否则默认放项目的 `<skills>/<handle>-mode/SKILL.md`，用户偏好个人技能则放用户级技能目录。
  `<skills>` 是第 0 步确定的宿主环境技能目录。
- Handle：用户的名或自选标识符。
- Frontmatter `description`：由他们的名字 + `/<handle>-mode` + "work in their style" 触发，不由"写代码""review PR"这类泛化关键词触发。
- Frontmatter 格式：遵循 `create-skill` 的 YAML 规则。
  `description` 保持单个 YAML 标量。
  标点或换行需要时，加引号或用 `description: >-` 加缩进续行。
- Frontmatter `disable-model-invocation: true` 为默认。
  只有用户明确希望自己的 mode 在每一轮都生效才关闭它。

### 5. 打磨散文

对每一行应用 **unslop** 技能与 `create-skill` 的写作指南。

把草稿给用户看并收集反馈。
预期多轮迭代。狠心删。
mode 技能不是操作手册。

### 6. 落地（Land）

在 main 之外开一个 worktree 里干活。
commit 并开 PR。不要直接 push 到 main。

## 护栏（Guardrails）

- **不要对单次对话过拟合。** 说过一次又被另一次推翻的偏好是噪音。立为规则前要求多次出现。
- **不要耍聪明。** 复述其他技能的内容、发明比喻、给 agent 读者写"诗意"散文，都是有成本无收益。保持可操作。
- **引用，不内联。** 用户依赖的其他技能应以路径引用出现，不是粘贴摘录。他们在别处维护的原则文档同理。
- **小节保持极简。** 只在用户对某小节有具体的、非默认的规则时才加小节。"清晰沟通"不配成一个小节。"短段落。比较选项时用表格。只有条目真正并列才用列表。"配。
- **命名约定用泛称。** 祈使句里用"the user"或"the human"，不用作者的名字。
- **不要强求对称。** 用户没有值得写下来的流程规则，就整个跳过 Process 小节。

## 评估（Evaluation）

`-mode` 技能是主观产物。
`create-skill` 式的测试/迭代基准循环在这里没用。
和用户一起做氛围校验（vibe-check）：读起来像不像他们？漏了什么？然后交付。

只有技能的触发准确率在实践中成了问题，才跑 description 优化循环。

## 何时不适用

- 用户要的是任务专用技能（不是工作约定）：单用 `create-skill`，不需要挖掘。
- 用户想捕获一个窄工作流（如"我怎么写 commit message"）。那是普通技能，不是 mode 技能。
