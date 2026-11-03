# pstack 上游 README 全文翻译

> 翻译自 backnotprop/pstack 仓库的 README.md（镜像版，含 mirror 头部与上游正文）。**本译文仅供人阅读，Agent 不消费本文件**，Agent 执行时读英文原文。术语基准见 [GLOSSARY.md](GLOSSARY.md)。
>
> 链接改写说明：源文档中的相对链接（`./skills/...`、`./docs/...`、`./agents/...`、`./automations/...`）已改写为 `https://github.com/backnotprop/pstack/blob/main/<路径>` 绝对链接；图片引用以"[图：<alt 译文>]"替代；代码块（安装命令、prompt 示例）保留英文原样。

---

## mirror 头部

<!-- mirror:start — this top section is specific to the mirror. Everything after mirror:end is the upstream README from cursor/plugins/pstack, unchanged. To sync with upstream, follow MIRROR.md. -->
（上面这条 HTML 注释为 mirror 维护标记，原样保留：本节顶部内容为镜像专属；`mirror:end` 之后是从 cursor/plugins/pstack 原样搬来的上游 README；与上游同步的流程见 MIRROR.md。）

# pstack — standalone mirror（pstack — 独立镜像）

[图：cursor/plugins/pstack 与本镜像 backnotprop/pstack 保持同步。`npx skills add backnotprop/pstack` 会把它安装进 Claude Code、Codex、Pi、Cursor、OpenCode 及其他 agent。]

> cursor/plugins/pstack（作者 Poteto）的**镜像（Mirror）**——为独立使用而保持同步。由 Plannotator 赞助。

[图：由 Plannotator 赞助]　[图：今天就来试用 Plannotator Inbox]

> Poteto 的 Bro 技能由我创建：[backnotprop/bro](https://github.com/backnotprop/bro)

## 安装（Install）

pstack 是一个由纯 [Agent Skills](https://agentskills.io) 组成的文件夹（`skills/<name>/SKILL.md`）。你不需要 [Cursor](https://github.com/cursor/plugins/tree/main/pstack)。[`skills` CLI](https://skills.sh) 会把它们安装进 Claude Code、Codex、Pi、Cursor、OpenCode 及其他 agent：

```bash
npx skills add backnotprop/pstack
```

CLI 会以一个可搜索的列表展示每个技能。选中你要的技能，再选中你的 agent。

## 技能清单（Skills）

Cursor 的原始 README 在[本页下方](#pstack)。

以下技能不会调用其他 pstack 技能，因此每一个都可以独立工作：

`unslop`, `bro`, `how`, `tdd`, `typescript-best-practices`, `arena`, `swarm`, `interrogate`, `reflect`, `show-me-your-work`, `figure-it-out`, `automate-me`, `correct`, `benchmark-checklist`, `in-your-own-words`, `sharpen`, `statechart`

有些技能会调用其他技能，请成组安装：

| 技能 | 还需安装 |
|---|---|
| `teach` | `how`、`why` |
| `why` | `how` |
| `technical-writing` | `unslop` |
| `architect` | `arena`、`how` |
| `blast-radius` | `arena`、`how`、`why`、`unslop` |
| `create-verification-skill` | `maintain-verification-skill` |
| `create-formal-verification-skill` | `maintain-formal-verification-skill`、`statechart` |
| `ketchup` | `bro` |
| `ketchup-video` | `ketchup`、`bro` |
| `poteto-mode` | 全部 `principle-*` 技能与大多数其他技能 |
| `poteto-help` | 你想要其提供帮助的技能 |

会派生子智能体（subagent）的技能指向 `poteto-mode` 的"子智能体"一节，为每个子智能体选取推理力度（effort）。没有 `poteto-mode` 时，它们使用默认推理力度。

## 本镜像的改动（What this mirror changes）

许多技能原本是 Cursor 专属的。它们已被改写为可在任何宿主环境（harness）中工作。

本镜像还携带一个尚未进入上游的社区修复：

- `no-comments` 在无法核实某条外部规则（依赖、平台或协议）时，会保留关于该规则的注释并将其标记为待审查，而不是删除它。被否决的审查不再中断整个运行。（[#14](https://github.com/backnotprop/pstack/issues/14)）

<!-- mirror:end -->

---

# pstack

[查看 Pstack 博客](https://x.com/poteto/article/2094457600259842065?lang=en)

我是 [poteto](https://x.com/poteto)。我不是总裁也不是 CEO，但我在 Meta、Netflix 和 Cursor 经手过数百万行代码。我也是 react core team 的成员，参与构建和维护 react compiler。

越来越多的人感觉 AI 写了太多 slop（AI 生成的低质冗余内容）代码。我同意。我不想像一支由二十个 slop 画手组成的团队那样交付。没有质量的吞吐量不是我追求的目标。想快，先深入。

**pstack 就是我的回答。**这些正是我每天在 Cursor 用来交付高质量代码的同一批技能。它把 Cursor 变成一支真正的工程团队。目标不是最大化代码行数（loc），事实上恰恰相反。pstack 帮你写得更少，但质量更高。

**pstack 给你无所畏惧的并行。**当你能在一个 agent 上深入下去、并相信它会写出好的、可验证的代码时，你才能真正放心地并行。用 `poteto-mode` 启动多个 agent，并相信它们会对自己的工作应用严谨的工程原则。

**Cursor 给你集各家之长的世界。**每个前沿模型都有自己的长处与短板。在 pstack 里用任何模型。事实上，我的许多技能都采用多模型工作流来利用每个模型独有的长处。

fork 它。改进它。把它变成你的。欢迎 PR！

## 安装（install）

```bash
/add-plugin pstack
```

在 Claude Code 中：

```bash
/plugin marketplace add cursor/plugins
/plugin install pstack@cursor-plugins
```

Claude Code 对第三方 marketplace 默认关闭自动更新，所以 pstack 停留在你安装的那个版本上。要打开自动更新，运行 `/plugin`，打开 **marketplaces** 标签页，选中 `cursor-plugins`，选择 **enable auto-update**。要手动更新一次，运行 `claude plugin update pstack@cursor-plugins`。

Claude Code 会给插件命令与 agent 加前缀，所以 `/poteto-mode` 变成 `/pstack:poteto-mode`。[Claude Code 适配器](https://github.com/backnotprop/pstack/blob/main/docs/harness/claude-code.md)映射了其余所有 Cursor 名称。在 Claude Code 中，`/pstack:setup-pstack` 把你的模型选择写入 `~/.claude/rules/pstack-models.md`；需要 Cursor 独有功能（如 bugbot 或 automations）的步骤会以一行说明跳过。

Claude Code 会从仓库根目录的 [`harness/pstack/`](https://github.com/cursor/plugins/tree/main/harness/pstack) 安装一份生成的 pstack 副本，包括本 README 与指南。改动 pstack 之后，从仓库根目录运行 `node scripts/generate-pstack-harness-trees.mjs` 并提交结果。生成的副本未同步期间 CI 会失败。

## 开始上手（get started）

两步：

1. 运行 [`/setup-pstack`](https://github.com/backnotprop/pstack/blob/main/skills/setup-pstack/SKILL.md)，选一个推理预算（reasoning budget），并挑选你想要的模型。
2. 凡是要做任何需要严谨性的工作，就使用 [`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md)。

刚上手？[pstack 指南](https://github.com/backnotprop/pstack/blob/main/docs/guide/README.md)带你完成第一个真实任务，从安装与提示词，一路讲到验证与通宵（overnight）运行。卡住了，或者不确定哪个技能合适？问 [`/poteto-help`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-help/SKILL.md)。

就这么简单。其余技能都是场景性的，mode 技能会按需替你调用它们。开箱即用时，mode 按模型强弱分工：代码委派（feature、refactoring、bug fix、perf、hillclimb 剧本）交给 grok，而最难的变更、散文与判断交给 opus 5.5。默认面板是 opus 5.5 / grok。[ `/setup-pstack`](https://github.com/backnotprop/pstack/blob/main/skills/setup-pstack/SKILL.md) 可以改变其中任何一项。

## 用法（usage）

在任务开始时使用 [`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md)。它读取你的请求，从一组步骤剧本（playbook）中挑选合适的，并按步骤需要运行其他技能。

在输入任务之前，先从 `/` 菜单里选 `/poteto-mode`，这样 Cursor 会把该技能附加到这条消息上。

### 就用 [`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md)

这个技能是主快捷方式。每当我需要 agent 做严谨的工程工作，我就用它。它自带二十三个步骤剧本：

```
/poteto-mode this pr has a subtle bug where the scroll drifts every 750ms even when idle. repro
first, then fix and verify.
```

```
/poteto-mode i'm going to bed. land the stack even if ci flakes. i want everything merged by
morning.
```

<details>
<summary>二十三个步骤剧本（the twenty-three playbooks）</summary>

| 剧本（playbook） | 用途 |
|---|---|
| [investigation](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/investigation.md) | 一个只读的问题。x 是怎么工作的，y 为什么这样建，我们确定吗。 |
| [bug fix](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/bug-fix.md) | 复现（repro）一个缺陷，找到根因，凭运行时证据修复。 |
| [perf](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/perf-issue.md) | 追踪一处实测的缓慢，对照基线改进它。 |
| [hillclimb](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/hillclimb.md) | 围绕目标对一个指标做持续、科学的改进：循环提出假设并做前后测量，每接受一次提升就提交一次。 |
| [runtime forensics](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/runtime-forensics.md) | 从监测数据诊断线上症状（泄漏、空闲 CPU 空转、毛刺）。 |
| [trace forensics](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/trace-forensics.md) | 诊断一份采集到的性能分析制品（cpuprofile、trace、spindump、堆快照）。 |
| [feature](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/feature.md) | 从一个命名的数据形态出发，构建新的或变更的行为。 |
| [refactoring](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/refactoring.md) | 一次保持行为不变的结构或形态变更。 |
| [prototype](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/prototype.md) | 用一次性草样廉价地做出设计或行为决策，或通过观察裁决一个经验性分叉。 |
| [visual parity](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/visual-parity.md) | 两套实现之间的像素级 UI 等价。 |
| [authoring a skill](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/authoring-a-skill.md) | 编写或编辑一份 SKILL.md。 |
| [eval](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/eval.md) | 以盲测检验一次技能或 prompt 变更对 agent 行为的影响。 |
| [babysit](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/babysit.md) | 把一个 PR 或一条堆叠推进到可合并状态：冲突、审查线程、CI。 |
| [shipping](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/shipping.md) | 独立验证一条全绿的堆叠，然后自底向上把连续经过验证的运行落地（land）：默认经由 github，可用时经由 origin。 |
| [autonomous run](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/autonomous-run.md) | 把一个长任务驱动到完成，中途不停。 |
| [orchestrate](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/orchestrate.md) | 交托给一个协调者会话的常设项目：跨多日、大量堆叠 PR、成队的子智能体。 |
| [autopilot-full](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/autopilot-full.md) | 把相互独立的 PR 跑到 merged，每个 PR 一名责任人。由一个 swarm 验证每个 code-ready 的头部，之后对补丁的每一次后续修改都重新做一次检查。 |
| [autopilot-stack](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/autopilot-stack.md) | 不含合并的 autopilot-full。构建并验证 PR 供操作者审查与落地，一个 PR 只堆叠在它所依赖的 PR 之上。 |
| [session pickup](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/session-pickup.md) | 接续或接管前一个 agent 未完成的工作。 |
| [pause safely](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/pause-safely.md) | 干净地挂起进行中的工作，以便日后恢复。 |
| [multi-phase plan](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/multi-phase-plan.md) | 跨阶段或跨堆叠 PR 的工作。 |
| [worktree cleanup](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/worktree-cleanup.md) | 通过清理已合并或被放弃的 Git 工作树（worktree）与过期的 iOS 模拟器来回收磁盘，带安全门禁。 |
| [opening a pr](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/opening-a-pr.md) | 由小而有序的提交打开一个就绪的 PR，标题遵循 conventional commits，正文为任务简报式。在其他每个剧本的结尾都会被调用。 |

</details>



被调用时它会：

1. 把你的任务匹配到一个[步骤剧本](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/)，并打开一份 todo 清单，其最初的条目就是该剧本的步骤，逐字复制。
2. 在步骤触发时路由到其他技能。
3. 写出没有 AI 腔的回应，同时为使用者与维护者两种视角取材。

完整的规则与步骤剧本都在 [`skills/poteto-mode/SKILL.md`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md)。

要让 [`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md) 跨回合保持开启，从 `/` 菜单选中它，然后按 option+enter（mac）或 alt+enter（windows）而不是 enter。这会把它变成一个[自定义模式（custom mode）](https://cursor.com/docs/skills#using-a-skill-as-a-custom-mode)，Cursor 在 agents 窗口与 CLI 中都提供该功能。它会每一回合都留在上下文里，直到你退出该模式。直接按 enter 只把它附加到一条消息。

[`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md) 与 Cursor 的 `/loop` 命令配合得极好。你可以让 Cursor 连续工作许多个小时而不牺牲严谨性。

## 技能（skills）

当某个步骤需要时，[`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md) 会替你运行其中大多数（`how`、`why`、`architect`、`arena`、`swarm`、`interrogate`、`unslop`、`no-comments`、`technical-writing`、`tdd` 以及各原则技能）。下表适用于你想直接调用某个技能的情形：

```
/how do we cancel runs? do we have an n+1 when we look up every run to cancel?
```

```
/interrogate review this pr.
```

<details>
<summary>全部技能（all skills）</summary>

| 技能 | 何时使用 |
|---|---|
| [`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md) | 任何非平凡任务的默认入口。 |
| [`/poteto-help`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-help/SKILL.md) | 你刚接触 pstack，或不确定哪个技能、剧本或原则合适。它会弄清你想做什么，回答那一部分，并递给你一条可以照打的 prompt。仅在你输入 `/poteto-help` 时运行。 |
| [`/in-your-own-words`](https://github.com/backnotprop/pstack/blob/main/skills/in-your-own-words/SKILL.md) | 你想让 agent 在动手之前先用它自己的话复述你的目标与要解决的问题。仅在你输入 `/in-your-own-words` 时运行。 |
| [`/sharpen`](https://github.com/backnotprop/pstack/blob/main/skills/sharpen/SKILL.md) | 你想在发送之前把一条 prompt 打磨得更深而不是更大：顶级专业人士会做哪些你没要求的事、他们会从什么原料出发、他们的方法与工具，以及对结果是否正确的外部校验。它交回改写后的 prompt，并把你的选择权留给你。不执行任务。仅在你输入 `/sharpen` 时运行。 |
| [`/how`](https://github.com/backnotprop/pstack/blob/main/skills/how/SKILL.md) | 你想要一份子系统如何工作的逐步讲解。 |
| [`/why`](https://github.com/backnotprop/pstack/blob/main/skills/why/SKILL.md) | 你想知道某个东西为什么这样建。它在运行时发现可用的 MCP，并并行查询每一类证据（源码管理、issue 跟踪、长文档、实时聊天、基础设施可观测性、错误跟踪、分析数仓）。 |
| [`/recall`](https://github.com/backnotprop/pstack/blob/main/skills/recall/SKILL.md) | 你正开始或恢复工作，想从自己的聊天历史与共享记录中重建关于某个主题的近期上下文，并以一份紧凑的现状任务简报（brief）交回。 |
| [`/ketchup`](https://github.com/backnotprop/pstack/blob/main/skills/ketchup/SKILL.md) | 你想了解自你上次发言以来本会话发生了什么，用平实语言与小图示呈现，每一项等你拍板的事项都列出、且仅凭回复本身就能决策，哪怕这让回复变长。 |
| [`/ketchup-video`](https://github.com/backnotprop/pstack/blob/main/skills/ketchup-video/SKILL.md) | 你想要 `/ketchup` 式的进度追补，以带字幕的幻灯片短视频呈现，等你处理的调用以文本列在视频之下。 |
| [`/blast-radius`](https://github.com/backnotprop/pstack/blob/main/skills/blast-radius/SKILL.md) | 你有一个看起来很小的变更，想知道它还可能破坏什么，并以一条"它因此是安全的"的事实收尾——该事实靠运行代码证明，而不是断言。 |
| [`/architect`](https://github.com/backnotprop/pstack/blob/main/skills/architect/SKILL.md) | 你即将编写跨越函数边界的代码，想先把调用方的用法、类型与模块形态定下来。 |
| [`/arena`](https://github.com/backnotprop/pstack/blob/main/skills/arena/SKILL.md) | 你想对同一件事做 N 路并行尝试（同题竞标），然后摘取各自最好的部分。 |
| [`/swarm`](https://github.com/backnotprop/pstack/blob/main/skills/swarm/SKILL.md) | 你想要 N 路并行 worker 分布在不同切片或竞速（race）上，最后汇总为一份报告。 |
| [`/interrogate`](https://github.com/backnotprop/pstack/blob/main/skills/interrogate/SKILL.md) | 你有一份 diff，想让不同模型设法攻破它，只保留被某次运行证明的审查发现（finding）。 |
| [`/automate-me`](https://github.com/backnotprop/pstack/blob/main/skills/automate-me/SKILL.md) | 你想要一个属于你自己的 `-mode` 技能，按你实际的工作方式起草。 |
| [`/make-bot-ui`](https://github.com/backnotprop/pstack/blob/main/skills/make-bot-ui/SKILL.md) | 你想要一个页面或仪表盘，其按钮通过 webhook 唤醒一个 Grok Bot，包括发送密钥交接与 Tailscale。 |
| [`/setup-pstack`](https://github.com/backnotprop/pstack/blob/main/skills/setup-pstack/SKILL.md) | 你想挑选 pstack 在每个角色上使用哪些模型。它检测你的模型并写入一条配置规则。 |
| [`/reflect`](https://github.com/backnotprop/pstack/blob/main/skills/reflect/SKILL.md) | 一个长任务落地了，你想把其中的经验固化为一次技能编辑。 |
| [`/correct`](https://github.com/backnotprop/pstack/blob/main/skills/correct/SKILL.md) | 你在反复为 agent 的同一类错误纠正它们。它从历史中挖掘错误类别，在能生效的最高层级逐类修复（先架构，再类型、lint 与 CI，再测试，文档最后），并维护一张把每条规则与其执行者配对的表。 |
| [`/teach`](https://github.com/backnotprop/pstack/blob/main/skills/teach/SKILL.md) | 你想真正理解一次变更或一个子系统，而不只是要一份摘要。它运行 how + why，逐张图织出一个平实的解释。 |
| [`/tdd`](https://github.com/backnotprop/pstack/blob/main/skills/tdd/SKILL.md) | 你在修一个 bug，且有廉价的本地测试路径。先写失败的测试，再写修复。 |
| [`/benchmark-checklist`](https://github.com/backnotprop/pstack/blob/main/skills/benchmark-checklist/SKILL.md) | 你跑了基准测试，或测出了加速/回退。在你汇报或据以行动之前，先核验该数字（限制因素、调参、错误、重复运行、端到端相关性）。 |
| [`/no-comments`](https://github.com/backnotprop/pstack/blob/main/skills/no-comments/SKILL.md) | 在 review 之前清除注释；派生 Comment Sicko，修复被接受的审查发现，对声称的约束提供编码化方案。 |
| [`/typescript-best-practices`](https://github.com/backnotprop/pstack/blob/main/skills/typescript-best-practices/SKILL.md) | 你在读或写 TypeScript。它把 type-system-discipline 原则落到语法层面。 |
| [`/figure-it-out`](https://github.com/backnotprop/pstack/blob/main/skills/figure-it-out/SKILL.md) | 没有现成的剧本适用。它为该任务设计一个严谨、可审计的剧本。 |
| [`/show-me-your-work`](https://github.com/backnotprop/pstack/blob/main/skills/show-me-your-work/SKILL.md) | 你想要一条可审查的决策轨迹。它把决策记录到一个可提交的 tsv。 |
| [`/create-verification-skill`](https://github.com/backnotprop/pstack/blob/main/skills/create-verification-skill/SKILL.md) | 你的项目没有脚本化的方式来证明应用行为。它为任意语言或平台生成一个项目本地的 verify 技能，附功能地图（feature map）。 |
| [`/maintain-verification-skill`](https://github.com/backnotprop/pstack/blob/main/skills/maintain-verification-skill/SKILL.md) | 你的 verify 技能的功能地图已与应用漂移（drift）。一次源码扫荡 + 一次实跑，至多一个 PR 的、有证据支撑的修正。 |
| [`/create-formal-verification-skill`](https://github.com/backnotprop/pstack/blob/main/skills/create-formal-verification-skill/SKILL.md) | 测试无法触达破坏竞速、重试、状态机、解析器或不安全代码的那个用例。它用合适的工具对一条性质做形式化验证，并生成一个项目本地的技能，在每次变更时重新检验。 |
| [`/maintain-formal-verification-skill`](https://github.com/backnotprop/pstack/blob/main/skills/maintain-formal-verification-skill/SKILL.md) | 形式化验证所覆盖的代码自上次检验后已变更。它更新模型、宿主环境或性质以匹配代码并重跑，并说明每个失败究竟是验证的漂移还是代码的 bug。 |
| [`/statechart`](https://github.com/backnotprop/pstack/blob/main/skills/statechart/SKILL.md) | 行为的负责人需要看见它，而不是读一份规格。它检查一个 TLA+ 模型，把用户所见画成 mermaid 状态图，标出每个违反规则的状态，并给出到达每个状态的最短路径。 |
| [`/unslop`](https://github.com/backnotprop/pstack/blob/main/skills/unslop/SKILL.md) | 你在清理文字。它移除 AI 腔。 |
| [`/bro`](https://github.com/backnotprop/pstack/blob/main/skills/bro/SKILL.md) | 你想把最后一条消息用平实的人话复述，不用行话。 |
| [`/technical-writing`](https://github.com/backnotprop/pstack/blob/main/skills/technical-writing/SKILL.md) | 分层文档标准（Diátaxis + Google developer style + STE + Global English），适用于 docs、RFC、readme、PR 描述、commit message。 |

</details>



### 示例（examples）

大多数时候，我在任务开始时输入 [`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md)，让它路由到一个剧本。其他技能在步骤需要时触发。少数几个我会直接调用。


<details>
<summary>全部示例（all the examples）</summary>

```
bug fix:           /poteto-mode this pr has a subtle bug where the scroll drifts every 750ms even
                   when idle. repro first, then fix and verify.
perf:              /poteto-mode a big list takes a second or two to load even though we virtualize.
                   run a cpu trace and tell me why.
feature:           /poteto-mode build a small feature behind a feature flag. verify it really works.
prototype:         /poteto-mode build two prototypes of the markdown renderer so we can compare.
                   spawn an agent for each.
multi-phase:       /poteto-mode open source these skills as a plugin. nothing internal leaks, work
                   in a temp dir, show me the dependency graph first.
overnight run:     /poteto-mode i'm going to bed. land the stack even if ci flakes. i want
                   everything merged by morning.
babysit:           /poteto-mode check on pr 123. anything outstanding?
visual parity:     /poteto-mode the row spacing is too tall when this flag is on. the second image
                   is correct. repro and fix until it matches.
figure it out:     /poteto-mode i'm stepping away. migrate every caller from the synchronous store
                   to the new async one, keeping behavior identical. i want to trust it was done
                   right when i'm back.
how:               /how do we cancel runs? do we have an n+1 when we look up every run to cancel?
why:               /why is this feature flag not on yet?
architect:         design this instrumentation to be high signal with no false positives. /architect
                   this first.
arena:             /arena take my prompt to the arena verbatim. i want to compare their proposals
                   with yours.
swarm:             /swarm check every package under packages/ against its check.sh. one worker per
                   package. one report.
interrogate:       /interrogate review this pr.
tdd:               /tdd implement
unslop:            can we unslop and tighten the new changes?
reflect:           /reflect that took too long. capture what we learned so the next run doesn't
                   repeat it.
correct:           /correct
show-me-your-work: /show-me-your-work keep a decision trail i can review when i'm back.
automate-me:       /automate-me
help:              /poteto-help which skill should i use to review this branch?
```

</details>

## `poteto-agent` 与 Comment Sicko 子智能体

[`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md) 在接收到它的那个会话里运行。该会话持有剧本、todo 清单以及每一次子智能体派生。

pstack 还附带 [`subagent_type: "poteto-agent"`](https://github.com/backnotprop/pstack/blob/main/agents/poteto-agent.md)，作为运行期间被委派（delegate）的子智能体的包装器。它在做任何工作之前都会通读 `poteto-mode`，包括其内联的原则索引。换成 `generalPurpose` 就跳过了这次阅读并会漂移。不要派生 `poteto-agent` 去运行剧本本身。

[`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md) 与 [`subagent_type: "poteto-agent"`](https://github.com/backnotprop/pstack/blob/main/agents/poteto-agent.md) 经由同一个包装器路由。

pstack 还附带 [Comment Sicko](https://github.com/backnotprop/pstack/blob/main/agents/comment-sicko.md)，一个只读的注释审查者，以 `subagent_type: "comment-sicko"` 提供。通常通过 [`/no-comments`](https://github.com/backnotprop/pstack/blob/main/skills/no-comments/SKILL.md) 调用它，而不是直接调用。

## 原则（Principles）

二十四个短技能，每个承载一条原则。`poteto-mode` 把它们内联成索引，并在任务开始时读取该索引。独立文件的存在，是为了让其他技能能按名字引用一条原则，也让索引能为每条原则指向完整规则。

<details>
<summary>全部二十四条原则（all twenty-four principles）</summary>

| 原则 | 分组 | 规则 |
|---|---|---|
| [laziness-protocol](https://github.com/backnotprop/pstack/blob/main/skills/principle-laziness-protocol/SKILL.md) | 核心 | 偏向删除，以及能解决问题的最小变更。 |
| [foundational-thinking](https://github.com/backnotprop/pstack/blob/main/skills/principle-foundational-thinking/SKILL.md) | 核心 | 在写逻辑之前先应用：挑选核心类型与数据结构，安排脚手架（scaffold）与功能工作的先后顺序，追问哪些并发参与者共享什么。把数据结构定对，下游代码就变得显然。 |
| [redesign-from-first-principles](https://github.com/backnotprop/pstack/blob/main/skills/principle-redesign-from-first-principles/SKILL.md) | 核心 | 把需求当作第一天就成立的基础假设来重新设计，而不是把它外挂上去。 |
| [attack-the-premise](https://github.com/backnotprop/pstack/blob/main/skills/principle-attack-the-premise/SKILL.md) | 核心 | 当两个或更多共享同一前提的修复在同一个门禁（gate）上失败时应用。把前提写下来并直接检验它，然后才写下一个仍然假定该前提的修复。 |
| [subtract-before-you-add](https://github.com/backnotprop/pstack/blob/main/skills/principle-subtract-before-you-add/SKILL.md) | 核心 | 先移除死重、冗余的校验器与桩引用，再在更简单的基础上构建。 |
| [minimize-reader-load](https://github.com/backnotprop/pstack/blob/main/skills/principle-minimize-reader-load/SKILL.md) | 核心 | 数一数问题与答案之间隔了几层，以及读者脑中要装多少隐藏状态；合并只有一个调用方的包装层，收缩可变作用域。 |
| [outcome-oriented-execution](https://github.com/backnotprop/pstack/blob/main/skills/principle-outcome-oriented-execution/SKILL.md) | 核心 | 在有明确阶段边界的计划性重写与迁移中应用。向目标架构收敛；不要用一次性的兼容代码去维护平滑的中间状态。 |
| [experience-first](https://github.com/backnotprop/pstack/blob/main/skills/principle-experience-first/SKILL.md) | 核心 | 用户愉悦优先于实现便利；交付更少的精致功能，而不是更多的粗糙功能。 |
| [exhaust-the-design-space](https://github.com/backnotprop/pstack/blob/main/skills/principle-exhaust-the-design-space/SKILL.md) | 核心 | 先构建 2-3 个互相竞争的草样并排比较，然后才下注。 |
| [build-the-lever](https://github.com/backnotprop/pstack/blob/main/skills/principle-build-the-lever/SKILL.md) | 核心 | 适用于任何非平凡工作，不只是批量工作：编辑、迁移、分析、检查。构建能完成它或证明它的工具（codemod、脚本、生成器，或一个你的子智能体遵循的技能），而不是手工去做。工具本身就是审查者可以重跑的制品（artifact）。 |
| [model-the-domain](https://github.com/backnotprop/pstack/blob/main/skills/principle-model-the-domain/SKILL.md) | 架构 | 把领域编码进一个结构里，而不是散落各处的条件分支。 |
| [boundary-discipline](https://github.com/backnotprop/pstack/blob/main/skills/principle-boundary-discipline/SKILL.md) | 架构 | 把守卫（guard）集中在系统边界（CLI、配置、网络、外部 API）；信任内部类型，把业务逻辑留在纯函数里。 |
| [type-system-discipline](https://github.com/backnotprop/pstack/blob/main/skills/principle-type-system-discipline/SKILL.md) | 架构 | 让非法状态不可表示，给语义原语加品牌标记，在边界解析外部数据，穷尽变体，从权威 schema 派生。 |
| [make-operations-idempotent](https://github.com/backnotprop/pstack/blob/main/skills/principle-make-operations-idempotent/SKILL.md) | 架构 | 无论此前部分运行过多少次，都收敛到同一个终态。 |
| [migrate-callers-then-delete-legacy-apis](https://github.com/backnotprop/pstack/blob/main/skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md) | 架构 | 在同一波里迁移调用方并删除旧 API，而不是保留兼容层。 |
| [separate-before-serializing-shared-state](https://github.com/backnotprop/pstack/blob/main/skills/principle-separate-before-serializing-shared-state/SKILL.md) | 架构 | 先消除共享；只有当"单一共享写者"是真正的不变式（invariant）时，才做结构化串行化。 |
| [prove-it-works](https://github.com/backnotprop/pstack/blob/main/skills/principle-prove-it-works/SKILL.md) | 验证 | 在完成一个任务之后、宣布完成之前应用。对照真实制品做验证（运行功能、读取实际值、检查 diff），而不是代理物、自我报告或"它能编译"。 |
| [fix-root-causes](https://github.com/backnotprop/pstack/blob/main/skills/principle-fix-root-causes/SKILL.md) | 验证 | 把每个症状追溯回系统第一次出错的地方，并在那里修复。只有当守卫所处理的状态本身合法时，守卫才算是一次修复。 |
| [sequence-verifiable-units](https://github.com/backnotprop/pstack/blob/main/skills/principle-sequence-verifiable-units/SKILL.md) | 验证 | 适用于多步骤工作（扫荡、迁移、成批相似编辑），以及你堆叠 commit 与 PR 的方式。把工作拆成小单元，每个单元都结束于一个可验证的状态，逐个检查之后再做下一个，并按能让整个序列向审查者自我证明的方式排序交付。 |
| [test-behavior-not-implementation](https://github.com/backnotprop/pstack/blob/main/skills/principle-test-behavior-not-implementation/SKILL.md) | 验证 | 在你编写、变更或保留一个测试时应用。断言代码的使用者能观察到的东西，这样当该行为被破坏时测试失败，而当只有内部实现变化时测试保持通过。 |
| [explain-the-number](https://github.com/backnotprop/pstack/blob/main/skills/principle-explain-the-number/SKILL.md) | 验证 | 在你信任、汇报或据以行动一个你测出的数字之前应用：一次加速、一次回退、一个吞吐量、一个延迟或一个 eval 结果。找出限制它的因素，并排除"它测量的并非你以为的那份工作"的可能。 |
| [guard-the-context-window](https://github.com/backnotprop/pstack/blob/main/skills/principle-guard-the-context-window/SKILL.md) | 委派 | 把批量工作路由给子智能体；主线程里只留摘要，不留原始载荷。 |
| [never-block-on-the-human](https://github.com/backnotprop/pstack/blob/main/skills/principle-never-block-on-the-human/SKILL.md) | 委派 | 继续推进，呈现结果，让人类事后纠偏；把"请求确认"留给不可逆操作。 |
| [encode-lessons-in-structure](https://github.com/backnotprop/pstack/blob/main/skills/principle-encode-lessons-in-structure/SKILL.md) | 元 | 把规则编码为 lint、元数据开关、运行时检查或脚本，而不是更多文字。 |

</details>

## 此处未附带（not shipped here）

有几样 `poteto-mode` 引用了但并未捆绑的东西：

- `/deslop` 与 `deslop` 技能随 `cursor-team-kit` 插件交付。
- `control-cli`（用于 CLI 与 TUI）与 `control-ui`（用于浏览器、Electron、web）也随 `cursor-team-kit` 交付。
- `/create-skill` 是 Cursor 内置的。Cursor 还内置一个监视 PR 的 `/autopilot`。在 `poteto-mode` 内部，PR 状态请求改走[看护（babysit）剧本](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/playbooks/babysit.md)。

想要全套的话，把 `cursor-team-kit` 与 pstack 一起安装。

## 为什么没有规划技能？（why are there no planning skills?）

Cursor 已经有一个很好的 plan mode，它与 pstack 配合得很好。但就我个人而言，我不信奉规划。最好的规格就是代码。如果你确实想做一个计划，[`/poteto-mode`](https://github.com/backnotprop/pstack/blob/main/skills/poteto-mode/SKILL.md) 覆盖了它，但它不是默认行为。

## 把它变成你的（make it yours）

`poteto-mode` 是我的风格。你未必想要一模一样的东西。

输入 [`/automate-me`](https://github.com/backnotprop/pstack/blob/main/skills/automate-me/SKILL.md)。它挖掘你最近的会话记录（transcript），按你实际的工作方式起草一个 `<your-name>-mode` 技能，底层经由 pstack 路由。你保留 pstack 作为底座，最后在 `poteto-mode` 旁边得到属于你自己的路由技能。

模型也是可配置的。输入 [`/setup-pstack`](https://github.com/backnotprop/pstack/blob/main/skills/setup-pstack/SKILL.md)。它检测你能访问的模型，并写入一条始终生效的小规则，把每个角色（代码、判断、各审查面板）映射到一个模型。每个技能都会读它，规则缺席时回退到合理的默认值，所以你只覆盖你想要的部分。

当某个默认值发生变更时，变更前写入的规则仍会钉住旧默认值。删掉那些角色行，或删掉整个文件，然后重新运行 `/setup-pstack`。重跑会保留任何模型与默认值不同的角色。

## 自动化（automations）

pstack 还附带一个休眠的 [benny 自动化包](https://github.com/backnotprop/pstack/blob/main/automations/benny/)。benny 分诊 Slack 上的 issue 报告，然后以真实 UI 证据复现并修复确认的 bug。它的文件不注册为斜杠技能。

要配置它，把 Cursor 指向 [`FOR_AGENTS.md`](https://github.com/backnotprop/pstack/blob/main/automations/benny/FOR_AGENTS.md)。安装会把该包复制到目标仓库的 `.cursor/automations/benny/`，在那里启用 pstack 以共享技能，并让用户配置留在复制出的包之外。benny 运行在 Cursor automations 之上，所以它是 Cursor 专属的。

## 许可证（license）

MIT
