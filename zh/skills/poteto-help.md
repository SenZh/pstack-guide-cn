# poteto-help 全文翻译

> 翻译自 `skills/poteto-help/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: poteto-help
description: Guides users through pstack setup, /poteto-mode, and picking the skill, playbook, or principle for a task. Type /poteto-help with a question.
disable-model-invocation: true
---
```

---

## Poteto help

回答用户关于 pstack 的问题，递给他们一条可以直接发送的 prompt，并附上答案所出的文件链接。
帮助类问题，不要直接开工。
用户问的是"怎么做"，而一次 pstack 运行花的是真金白银的 token，所以把 prompt 留给他们自己发。

一条要求干活的消息（如 "use pstack to fix this bug"）不是帮助类问题。
读 [`poteto-mode`](./poteto-mode.md)，在它之下干活，并提一次 Custom Mode 可以让它常驻。

本文件把问题映射到持有答案的技能与指南页。
细节归那些文件所有。
引用之前先读你路由过去的那份，它与本地图冲突时信它。
这里的链接指向已安装的插件，用户未必打得开，所以给用户该文件的公开副本：`https://github.com/cursor/plugins/blob/main/pstack/` 后接其路径。

## 弄清他们要什么

从消息与对话推断需求。
点名的情形（如 "which skill reviews a PR?"）直接跳到对应小节。
仍不清楚的话，用这些选项问一道多选题，然后只回答他们选中的小节：

- Get set up（完成安装配置）
- Start a task with `/poteto-mode`（用 /poteto-mode 开工）
- Pick a skill for a situation（为某个情形挑技能）
- Fix a run that went wrong（修一次出问题的运行）
- Make pstack my own（把 pstack 变成自己的）

检查会改变答案的状态，只在有影响时提及：

- 没有 pstack 配置文件（settings file）（Cursor 是 `~/.cursor/rules/pstack-models.mdc`，Claude Code 是 `~/.claude/rules/pstack-models.md`，其他宿主环境是 `~/.agents/pstack-models.md`）说明 `/setup-pstack` 还没为这个用户跑过，每个角色都在用默认模型。
- 项目里没有 `verify-*` 技能或其他应用宿主（harness）说明 agent 没有脚本化手段驱动应用。
  问题涉及证明改动有效时，提及 `/create-verification-skill`。
- 项目里没有形式化验证技能，说明测试够得着之外没有任何性质被检查。
  问题涉及竞速（race）、不变式（invariant）或其他测试很少命中的用例时，提及 `/create-formal-verification-skill`。
  已有其一、且它记录的"最后同步" commit 之后被覆盖代码变过的话，问题触及那段代码就提及 `/maintain-formal-verification-skill`。

模型规则缺失且这件事要紧时，问用户是否现在就为每个角色挑模型、定推理预算（reasoning budget）。
要紧的情形：用户是新用户、问题关于安装或成本、或答案取决于跑哪些模型。
每次聊天至多问一次。
需求本身也不清楚的话，两个问题一起问。给两个选择：

- 现在：把 `/setup-pstack` 给他们打，同时也回答他们的问题。
- 以后：回答他们的问题，另加一句：在他们跑 `/setup-pstack` 之前，每个角色继续用默认模型。

## Get set up（完成安装配置）

1. 在聊天里用 `/add-plugin pstack` 安装，或从侧边栏的 Customize 安装。
   Cursor 之外，跑 `npx skills add backnotprop/pstack` 并挑技能。
2. 跑 [`/setup-pstack`](./setup-pstack.md)。
   它询问推理预算，为每个角色映射模型，并写入一条规则。规则对新聊天生效。
   随后它会各推荐一次为项目生成验证技能与形式化验证技能，除非项目已有其一。
3. 用 `/poteto-mode` 开一个真实任务，带一个目标，和一个能判过判不过的检查。

安装本身什么也不改变，直到用户调用某个技能。
只有 `/setup-pstack` 从用户的话里加载。
[README](../../README.md) 与[指南第 1 页](../docs/guide-1.md)有细节。
主动提出帮他们一起打磨第一条 prompt，依据 [`references/prompting.md`](https://github.com/backnotprop/pstack/blob/main/skills/PLACEHOLDER/references/prompting.md)。

担心的是成本的话，讲清 token 花在哪、怎么少花。
pstack 的额外 token 花在子智能体（subagent）与审阅 panel 上。
重跑 `/setup-pstack` 选更小的预算或更便宜的模型。
设为 `auto` 或 `inherit-parent` 的角色跑在聊天的模型上，聊天本身跑在 Auto 或便宜模型上时省 token。
更短的 panel 清单跑更少的子智能体，每个条目一个。
把 `/poteto-mode` 留给需要严谨度的活。

pstack 为 Cursor 而建，也能装进 Claude Code：先 `/plugin marketplace add cursor/plugins`，再 `/plugin install pstack@cursor-plugins`。
在那里每个命令带 `pstack:` 前缀，如 `/pstack:poteto-mode`。
[Claude Code 适配层](../docs/guide-4.md)负责映射 Cursor 的名字；需要 Cursor 专属功能（如 Bugbot 或 Automations）的步骤会被跳过并附一行说明。

本镜像的技能在其他宿主环境（Claude Code、Codex、Pi、OpenCode 及其他）也能用，走 `npx skills add backnotprop/pstack`。
[poteto-mode](./poteto-mode.md) 的 Harness 章节把 Cursor 的子智能体、提问、会话记录与配置路径映射到对应宿主环境自己的。
Custom Modes 是 Cursor 的功能。

## Start a task with `/poteto-mode`（用 /poteto-mode 开工）

`/poteto-mode` 把任务匹配到一份剧本（playbook），把剧本的步骤复制进待办清单，并在步骤需要时调用其他技能。
它跳过的步骤以 `skip: <reason>` 留在清单里。
好的 prompt 陈述目标以及怎么算完成。
它不罗列技能，因为手写的顺序往往会丢掉或打乱剧本本会保住的步骤。
帮人打磨 prompt 之前先读 [`references/prompting.md`](https://github.com/backnotprop/pstack/blob/main/skills/PLACEHOLDER/references/prompting.md)。
[指南第 2 页](../docs/guide-1.md)有示例。

`/poteto-mode` 是否常驻取决于用户怎么启动它：

- 回车进入：把技能附加到一条消息。聊天推进后随之淡出。
- Mac 上 Option+Enter、Windows 上 Alt+Enter，或从技能条目选 Use as Mode：使它成为 Custom Mode。
  它每轮都留在上下文里，直到用户退出该模式，并且不会出现在闲聊轮次里。
- Cursor 的文档在 Agents Window 与 CLI 里列出 Custom Modes。
  其他地方，每个新任务都用 `/poteto-mode` 重新启动。

这种情况出现时附上 [Cursor 的 skills 文档](https://cursor.com/docs/skills)链接。
聊天中途，"new task" 会让模式匹配一份新剧本。
`/poteto-mode` 的剧本步骤派生的子智能体已经用 `poteto-agent`。
想让你自己的子智能体也有同样的风格，用 `subagent_type: "poteto-agent"` 派生它。

## Pick a skill（挑技能）

默认答案是 `/poteto-mode`，它在步骤需要时运行大多数其他技能。
用户想要比剧本给的更多或更少的东西时，直接点名技能。
推荐之前先读那个技能，并给一条示例 prompt。

| 用户想要 | 技能 |
|---|---|
| 以严谨度做任何非平凡任务 | [`/poteto-mode`](./poteto-mode.md) |
| 让 agent 开工前先复述它理解的目标与问题 | [`/in-your-own-words`](./in-your-own-words.md) |
| 发送前把 prompt 改写得更深而非更大：顶级专业人士会补充什么、他们的原材料与方法、外加一道外部核查。返回改写后的 prompt，不执行任务 | [`/sharpen`](./sharpen.md) |
| 弄清代码现在怎么工作，或新代码该放哪 | [`/how`](./how.md) |
| 弄清代码为什么长这样，或某个数字从哪来 | [`/why`](./why.md) |
| 平实地讲解一个改动或子系统 | [`/teach`](./teach.md) |
| 追自己的近况：最近在某主题上做过什么 | [`/recall`](./recall.md) |
| 追本聊天自用户上一条消息以来发生了什么，平实的语言加小型可视化，列出所有等他们拍板的条目，且回应本身足以让他们拍板 | [`/ketchup`](./ketchup.md) |
| 像 `/ketchup` 那样追况，但做成带字幕的幻灯短视频，待拍板的调用以文字排在下方 | [`/ketchup-video`](./ketchup-video.md) |
| 弄清一个小 diff 可能破坏它之外的什么 | [`/blast-radius`](./blast-radius.md) |
| 在跨越函数边界的代码之前定下类型与模块形状 | [`/architect`](./architect.md) |
| 对同一份任务简报（brief）拿多个版本，合并出最好的一个 | [`/arena`](./arena.md) |
| 以云端 agent 对切片并行检查，或让 worker 竞速 | [`/swarm`](./swarm.md) |
| 让不同模型审一个 diff 并设法弄坏它 | [`/interrogate`](./interrogate.md) |
| 存在便宜本地测试时以测试先行修 bug | [`/tdd`](./tdd.md) |
| 对 `.ts`/`.tsx` 工作应用 TypeScript 规则 | [`/typescript-best-practices`](./typescript-best-practices.md) |
| review 前清掉注释，且用一个没写过它们的审阅者 | [`/no-comments`](./no-comments.md) |
| 清除散文里的 AI 腔 | [`/unslop`](./unslop.md) |
| 按标准写文档、RFC、README、PR 描述或 commit message | [`/technical-writing`](./technical-writing.md) |
| 用平实的话把上一条回应再讲一遍 | [`/bro`](./bro.md) |
| 给 agent 一条脚本化路径去驱动应用并证明行为 | [`/create-verification-skill`](./create-verification-skill.md) |
| 让验证技能及其功能地图与应用重新对齐 | [`/maintain-verification-skill`](./maintain-verification-skill.md) |
| 形式化验证竞速、不变式或其他测试很少触达的性质 | [`/create-formal-verification-skill`](./create-formal-verification-skill.md) |
| 被覆盖代码变更后把形式化验证拉回一致，并弄清失败是漂移还是 bug | [`/maintain-formal-verification-skill`](./maintain-formal-verification-skill.md) |
| 向 PM 或设计师展示用户所见，画成经 TLA+ 模型检验的图，标注破坏规则的每个状态的最短路径 | [`/statechart`](./statechart.md) |
| 在汇报或采信一个性能数字之前先审查它 | [`/benchmark-checklist`](./benchmark-checklist.md) |
| 跑一次大型或横切的变更，或一次离开后回来审阅的变更 | [`/figure-it-out`](./figure-it-out.md) |
| 运行期间记决策日志，事后审阅它 | [`/show-me-your-work`](./show-me-your-work.md) |
| 为每个角色挑模型并定推理预算 | [`/setup-pstack`](./setup-pstack.md) |
| 把用户自己的工作习惯变成个人 mode 技能 | [`/automate-me`](./automate-me.md) |
| 把一次完成的任务教给我们的东西变成技能修改 | [`/reflect`](./reflect.md) |
| 阻止 agent 在本仓库重复犯同样的错误 | [`/correct`](./correct.md) |
| 构建一个按钮能经 webhook 唤醒 Grok Bot 的页面 | [`/make-bot-ui`](./make-bot-ui.md) |
| 在 pstack 里找路 | `/poteto-help` |

本文件旁边有技能目录不在上表里的话，读它的 frontmatter，按其 description 路由。
`principle-*` 目录在下面的原则一节覆盖。

近义抉择（Close calls）：

- `/how` 解释代码做什么。`/why` 解释为什么。`/teach` 运行其中之一或两者，并平实讲解结果。
- `/arena` 给每个 worker 同一份任务简报并合并最好的部分。`/swarm` 把工作切成切片或竞速，返回一份报告。
- `/architect` 定完设计紧接着实现。加 "with checkpoint" 可在写代码前先审设计。
- `/interrogate` 审 diff。`/blast-radius` 找 diff 之外的破坏，并证明那个让改动安全的唯一事实。
- `/recall` 跨近期聊天重建上下文。`/ketchup` 只覆盖本聊天自用户上一条消息以来。
  恢复某个特定聊天或分支走 Session pickup 剧本。
- `/figure-it-out` 设计一次严谨的运行。
  Orchestrate 剧本跑的是一个跨数天、许多 PR 的程序。
  Autonomous run 剧本把一个任务推进到终止条件。

不在 pstack 里：

- `/deslop`、`control-cli`、`control-ui` 随 `cursor-team-kit` 插件发行。
- `/loop` 与 `/create-skill` 是 Cursor 内置。
- pstack 没有 `/orchestrate` 技能。
  Orchestrate 是 `/poteto-mode` 的一份剧本。
  斜杠菜单里出现 `/orchestrate` 的话，是另一个插件提供的。

## Playbooks and principles（剧本与原则）

剧本（playbook）是 `/poteto-mode` 内部的步骤清单，不是技能，所以没有斜杠命令。
在 `/poteto-mode` 里，描述任务即可选中一份，下面这些短语直接点名：

- "babysit this pr" 或 "check on pr 123" 触发 Babysit。
  它把 PR 推到可合并状态即止。
  用户没要求 merge、land 或 ship 就不合并。
- "land the stack" 触发 Shipping。
- "take over this branch" 触发 Session pickup。
- "pause safely" 触发 Pause safely。
- "full autopilot on this queue" 触发 Autopilot-full。
  "autopilot, don't merge" 触发 Autopilot-stack。
- "run the eval playbook" 触发 Eval。

没有 `/poteto-mode` 的话，"babysit this pr" 这类短语可能误触 Cursor 自带的同职责技能。
[poteto-mode](./poteto-mode.md) 的 Playbooks 章节列出每份剧本及适用时机。
[指南第 6 页](../docs/guide-2.md)覆盖开 PR、看护（babysit）与落地（land）PR。

pstack 没有规划技能。Cursor 的 Plan Mode 与它并行工作。
跨阶段或堆叠（stack）PR 的活，向 `/poteto-mode` 要计划会触发 [Multi-phase plan 剧本](../docs/playbooks-01-task.md)，它写计划、不实现。
设计类问题，Prototype 剧本或 `/architect` 先在代码里定夺。

原则（principles）是单条规则的技能，`/poteto-mode` 读它们并在回应里引用。
用户很少直接调用。
他们用名字来施加影响，如 "apply prove it works. show me the real output."。
输入 `/principle-<name>` 仍可按需加载一个。
[指南第 8 页](../docs/guide-3.md)列出了它们。

## Fix a run that went wrong（修一次出问题的运行）

| 症状 | 解法 |
|---|---|
| 模式几轮之后就不再生效 | 它是回车启动的。改用 Custom Mode 启动，或每个任务都用 `/poteto-mode` 启动。 |
| 一个提问被当成了上个任务的下一步 | 说 "new task"，或说明这一轮不需要该模式。 |
| 新选的模型没生效 | `/setup-pstack` 写的规则对新聊天生效。开一个新聊天。 |
| 运行比预期贵 | 看 Get set up 一节的成本段落。 |
| 某个技能没有自行加载 | 只有 `/setup-pstack` 从用户的话里加载。其余技能靠用户输入，或靠 `/poteto-mode` 调用，而它不会调用每一个技能。 |
| 并行 agent 互相覆盖 | 给每个 agent 自己的 worktree，或以云端 agent 运行，它们各自有独立的机器。 |
| 通宵（overnight）运行有动静但一无所成 | `/loop` 需要一个能判过判不过的检查，不是一个时长。见[指南第 7 页](../docs/guide-3.md)。 |
| 回应拿绿色构建当成功证据 | 要真实的命令、流程、落库的值或 profile。这是 prove-it-works 原则。 |

对跑偏的运行，[`references/prompting.md`](https://github.com/backnotprop/pstack/blob/main/skills/PLACEHOLDER/references/prompting.md) 有单行纠偏语。
[指南第 10 页](../docs/guide-4.md)有更多坑与值得照抄的配方。

## Make pstack my own（把 pstack 变成自己的）

- [`/automate-me`](./automate-me.md) 从用户自己的历史起草一份个人 mode 技能，与 `/poteto-mode` 并用。
- [`/reflect`](./reflect.md) 在一次会话之后把它的经验教训变成用户批准的技能修改。
- `/poteto-mode write a skill for <workflow>` 触发 authoring 剧本。
  eval 剧本对技能修改做盲测。
- 坏掉的技能在它自己的 PR 里修，不要在出错的那个功能工作里顺手修。

[指南第 9 页](../docs/guide-3.md)逐一覆盖这些。

## Reply（回应）

答案先行。
示例 prompt 至多给一条，放代码块里，[`references/recipes.md`](https://github.com/backnotprop/pstack/blob/main/skills/PLACEHOLDER/references/recipes.md) 有合适的就改编一条，然后附该文件的链接。
用户没要完整地图就保持简短。
