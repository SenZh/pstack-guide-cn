# pstack 指南（guide）4/4：配方、坑与宿主适配

> 翻译自上游 `docs/guide/10-recipes-and-pitfalls.md`、`docs/harness/claude-code.md`、`MIRROR.md`。收尾篇：值得照抄的配方 prompt、人人都会犯一次的坑、Claude Code 宿主环境的名称映射表，以及本镜像仓库的同步流程。**本译文仅供人阅读，Agent 执行时读英文原文。**

---

## 配方与坑（10-recipes-and-pitfalls.md）

值得照抄的 prompt，然后是每个人都会犯一次的错误。把其中的路径与完成判据换成你自己的。配方刻意写得随意——实际使用时人们就是这么敲的，技能读得懂意图。

![她尝了一道成品菜，机器人按配方盒做菜，台面上方钉着写着 /how、/tdd、/loop 的卡片。](./images/recipes.jpg)

### 理解一个陌生子系统（Understand an unfamiliar subsystem）

```text
use /how first to understand how this initialization works. then use /why to figure out why it broke recently.
```

先弄机制，再问历史。每个技能的报告都会告诉你它搜了哪些来源，所以你知道答案建立在什么之上。

### 动代码前先复述一份吵闹的报告（Restate a noisy report before touching code）

```text
/poteto-mode read this thread. restate the underlying issue in your own words, in plain english. don't change any code yet.
```

误读会在复述里现形，纠正它只花一条消息。在 agent 说出自己的理论之前，别把你的猜想说出口。只要复述、不要剧本，用 `/in-your-own-words`。

### 发送前磨尖一个 prompt（Sharpen a prompt before you send it）

```text
/sharpen write the onboarding doc for the new billing service.
```

agent 会点名专家会做但你没要求的事、他们会从什么最原始的材料出发、他们的方法与工具、以及一个证明结果正确的外部检查。它把你的 prompt 重写为索要这些内容，而不执行任务。重写稿读着对了就发。

### 先原型再挑选（Prototype before you pick）

```text
/poteto-mode prototype a few options for the settings layout. put them behind a switcher and send me screenshots of each.
```

你从能跑的东西里挑，不从描述里挑。agent 顺路回答自己遇到的布局与时机问题。

### 把定稿的设计变成计划（Turn a settled design into a plan）

```text
/poteto-mode turn this design into a plan. small verifiable PRs, each with its own proof.
```

设计定稿之后再要。计划的交付物就是这个计划本身，它会点名将来执行它的剧本。

### 给设计找第二意见（Get a second opinion on a design）

```text
ask /arena for a second opinion on this thread and our approach
```

你当前的设计成为若干候选之一，综合结论会告诉你评审面板是找到了更好的、还是确认了你原有的。相对一个难以回退的设计，这点成本不值一提。

### 并行检查相互独立的切片（Check independent slices in parallel）

```text
/swarm check every package under packages/ against its check.sh. one worker per package. one report.
```

每个 worker 负责一个包。父级等所有切片跑完，返回一份 `PASS`、`ISSUES` 或 `BLOCKED` 的汇总报告，而不是把 worker 的原始输出倒给你。

### 带着怀疑评审一个分支（Review a branch skeptically）

```text
/interrogate the whole branch, but skeptically. don't change anything yet. no nitpicks unless it's an actual bug or regression in behavior.
```

限定词都在干真活。"don't change anything yet" 保持只读，"no nitpicks" 这条规则预先滤掉噪声，让验证过的发现值得你花时间。

### 通过一个失败的测试修 bug（Fix a bug through a failing test）

```text
/poteto-mode repro the duplicate write first. if there's a cheap test path, /tdd it. then fix and rerun.
```

"if there's a cheap test path" 这半句有用。逼着测试穿过脆弱的 mock，证明力不如跑真实命令，剧本有权这么说。

### 带证据复现并修复一份报告（Repro and fix a report with proof）

```text
/poteto-mode repro this with /verify-<app>. if it repros on main, fix it and show me a video as proof.
```

"if it repros on main" 让运行在 bug 已经消失时提前收工。视频让你在读 diff 之前先检查修复效果。

### 证明测试很少触及的性质（Prove a property tests rarely reach）

```text
/create-formal-verification-skill the retry queue. a message must never be delivered twice.
```

你得到：在声明范围内的每一种情况下都检查一个性质；如果代码已经违反它，得到一个用你代码术语写出的反例；外加一个项目技能，之后任何 agent 改这段代码都会跑它。

### 发出去之前审一个数字（Vet a number before you post it）

```text
/benchmark-checklist vet this 40% speedup before it goes in the pr description
```

你得到：更快、更慢、无可测量差异或不可判定，外加运行次数、数值区间、以及是什么在限制这个数字。

### 停止重复纠正同一个错误（Stop correcting the same mistake）

```text
/correct agents keep adding new config flags without registering them in the schema
```

修复以架构、类型、lint 或测试的形式落进仓库，下一个 agent 就犯不了这个错。

### 只问怎么走、不启动工作（Ask how without starting the work）

```text
/poteto-help how do i get poteto-mode to stay on every turn?
```

你得到一个答案、一个可发送的 prompt、一个指向来源的链接。你不发那个 prompt，什么都不跑。

### 你不在时让运行保持诚实（Keep a run honest while you're away）

```text
im going to bed, keep going autonomously until every fixture passes. do not stop. keep a decision log i can audit in the morning.
```

完整契约在"睡觉时干活"页（07-overnight.md）。任务与完成判据已经在对话里时，短版就够用。

### 拉回一次漂移的运行（Redirect a drifting run）

转向 prompt 只有一行：

```text
i said the goal is to repro. i did not ask for a fix yet.
```

```text
apply prove it works. show me the real output, not the build log.
```

```text
/unslop that, no emdashes
```

你很少需要更多字。你需要的是对的名字，原则页（08-principles.md）就是那份词汇表。

### 让回复说人话（Get the reply in plain words）

```text
/bro
```

整条 prompt 就是这两个词。[`/bro`](../skills/bro.md) 把最后一条消息复述得像一个人对另一个人说话，没有术语，更短。当一条回复技术上很详尽、你却还是不知道它说了什么时，用它。

### 接上一个你放着跑的 chat（Catch up on a chat you left running）

```text
/ketchup
```

[`/ketchup`](../skills/ketchup.md) 用平实的话告诉你，自你上一条消息以来发生了什么，然后逐项列出等你裁决的调用、它的选择、证据与风险。报告期间它什么都不改。

想"看"这份小结，跑 [`/ketchup-video`](../skills/ketchup-video.md)。它用一组带字幕的幻灯片短视频展示发生了什么，并把等你裁决的调用以文字列在视频下面。

### 那些坑（The pitfalls）

- **在 prompt 里枚举技能。**"use /how then /architect then /arena" 会重排剧本本已排好顺序的步骤。说目标与约束。只在要覆盖某个默认时才点名技能。
- **含糊的完成判据。**"make it better" 让 `/loop` 没东西可查。给一条能通过或失败的命令或制品。
- **上来就抛你的成因理论。**agent 会去你指的地方搜。先让它复述问题，再分享你的猜想。
- **接受第一个设计。**一次尝试就锁死模型最先想到的形状。要原型、或跑 `/architect`，从证据里挑。
- **打磨一份抽象计划。**对没有代码支撑的计划做对抗性评审，会编造永远不会发生的风险。用原型解决悬而未决的问题，再评审建出来的东西。
- **多个并行 agent 挤一个 worktree。**它们互相覆盖，没人说清哪个 agent 改了什么。让它们跑成云子智能体，或明说 "own worktree per attempt"。
- **还没信任循环就开循环。**不能验证自身工作的循环，只会更快地产出没人检查过的工作。先把验证技能跑通。
- **相信没审过的数字。**热缓存或被跳过的代码路径能伪造加速。数字见人之前先跑 `/benchmark-checklist`。
- **手工纠正同一个错误。**chat 里的一次纠正只帮一次运行。`/correct` 修的是仓库，之后的运行不会再犯。
- **拿 `/arena` 做覆盖。**`/arena` 重复的是同一个设计或代码任务简报，然后挑一个基底、嫁接最好的部分。`/swarm` 划分切片或声明的竞速臂，聚合出一份报告。
- **接受每一条评审意见。**bot 与人类都会把真发现和噪声混进同一份清单。`/interrogate` 只保留重跑能证明的发现，并列出它丢弃了什么、为什么；无论保留还是丢弃，你都可以推翻。
- **把 `auto` 当模型 slug。**`auto` 与 `inherit-parent` 的意思是"省略 model 字段，让子智能体继承父级 chat 的模型"。安装篇讲各个角色。
- **拿绿灯构建报告成功。**构建只证明能编译。要真实命令、真实流程、存储的值或性能画像，并要求证据出现在回复里。
- **徒手写 `SKILL.md`。**走"创作或修改技能"剧本（authoring-a-skill.md）那条路，让验证与评审都真正发生。

这就是指南的全部。如果你是跳着翻到这里的，回到安装篇（01-setup.md）跑一个真实任务。这些习惯靠使用养成，不靠阅读。

回到指南总目录（README.md）。

---

## Claude Code 宿主适配（harness/claude-code.md）

pstack 技能使用 Cursor 的名称。在 Claude Code 里，每个会话先读一遍本文件，然后用下面的表，把技能里出现的每个 Cursor 名称映射过去。`<pstack>` 指存放 `skills/` 与 `docs/` 的那个文件夹。某个 Cursor 字段在表里没有对应行时，丢弃它并说明。绝不传工具 schema 会拒绝的字段或值。

### 工具（Tools）

| Cursor | Claude Code |
| --- | --- |
| `Task` | `Agent` |
| `AskQuestion` | `AskUserQuestion`。`-p` 模式下它不存在，所以用纯文本提问。 |
| 打开一份待办清单 | 会话提供 `TodoWrite` 就用它。否则把清单留在你的回复里，每个阶段更新一次。 |
| 运行另一个 pstack 技能（`/name` 或 "the **name** skill"） | `Read` `<pstack>/skills/<name>/SKILL.md` 并照它做。`Skill` 工具会拒绝大多数 pstack 技能。要用户自己输入时，写 `/pstack:<name>`。 |
| `Grep`、`Glob` | 会话没有 `Grep` 或 `Glob` 时，用带 `rg` 的 `Bash`。 |

### 子智能体字段（Subagent fields）

| Cursor | Claude Code |
| --- | --- |
| `subagent_type: generalPurpose` | `subagent_type: "general-purpose"` |
| `poteto-agent`、`comment-sicko` | `pstack:poteto-agent`、`pstack:comment-sicko` |
| `readonly: true` | `subagent_type: "Explore"`。它保留 `Bash`，所以任务简报（brief）里还要写明"do not edit files"，并且你事后查一遍 `git status`。 |
| `readonly: false` | `general-purpose`。它保留会话的 MCP 服务器。 |
| `environment: "cloud"` | `isolation: "worktree"`。点名 worker 要检出的分支或提交。 |
| `environment: "local"` | 省略。 |
| `cloud_base_branch: <b>` | 告诉 worker 先检出 `<b>`。 |
| `run_in_background: true` | 省略。子智能体默认就在后台运行，完成时会通知你。 |
| `resume` | 生成一个新 agent，把之前的结果贴进它的任务简报。 |
| `file_attachments` | 在任务简报里列出这些路径。 |

### 模型（Models）

| Cursor | Claude Code |
| --- | --- |
| `claude-<family>-<version>-<effort>[-fast]`，如 `claude-opus-5-5-xhigh` | `model: "opus"` 与 `effort: "xhigh"`。`model` 只接受 `opus`、`sonnet`、`haiku`、`fable`。去掉 `-fast`。 |
| `grok-*`、`gpt-*` 或其他非 Claude slug | 省略 `model`，让 agent 跑在会话模型上，并且说明这一点。 |
| `auto` 或 `inherit-parent` | 省略 `model`。 |
| `pstack-models.mdc` 规则，`~/.cursor/rules/pstack-models.mdc` | `~/.claude/rules/pstack-models.md`。Claude Code 把它加载进每个新会话，所以它的角色行已经在上下文里。如果不在，读那个文件。文件或该角色的行缺失时，用技能默认的 slug。 |
| 角色值 `<model> <effort>`，如 `opus high` | `model: "opus"` 与 `effort: "high"`。 |

### setup-pstack

Claude Code 把 `~/.claude/rules/` 里的每个 `.md` 文件都加载进每个新会话，所以 `setup-pstack` 把它的规则写在那里。按它的步骤走，改动如下：

- 探测。探测到的模型就是 `Agent` 工具 schema 列出的那些 `model` 值，各配其 `effort` 取值中的一个档位。真实模型写成 `<model> <effort>`，如 `opus xhigh`。档位是最后一个 token，所以推理预算那一步照原样工作。
- 默认。把每个默认 slug 按上表映射：`claude-opus-5-5-xhigh` 对应 `opus xhigh`，`grok-4.7-xhigh-fast` 对应 `inherit-parent`。
- 写。写 `~/.claude/rules/pstack-models.md`：不带 frontmatter，然后是注释行、`# budget` 行、以及第 5 步每个角色一行。整文件覆盖。绝不把角色行放进 `CLAUDE.md` 或 `AGENTS.md`。

### 路径（Paths）

| Cursor | Claude Code |
| --- | --- |
| `.cursor/skills/`、`~/.cursor/skills/` | `.claude/skills/`、`~/.claude/skills/` |
| `~/.cursor/plugins/`、`.cursor-plugin/plugin.json` | `~/.claude/plugins/`、`.claude-plugin/plugin.json` |
| `.cursor/rules/*.mdc`，总是生效的规则 | `CLAUDE.md`，没有 `CLAUDE.md` 时用 `AGENTS.md`。Claude Code 从不读 `.mdc` 文件。模型规则是例外，见"模型"。 |
| `https://github.com/cursor/plugins/blob/main/pstack/<path>` | 该文件存在时用 `<pstack>/<path>`。插件自带技能、`docs/guide/` 与 `README.md`。读本地副本，永远不要去网上抓。用户需要链接时把 URL 给他。 |
| 会话记录（transcript）在 `~/.cursor/projects/<slug>/agent-transcripts/` | `~/.claude/projects/<slug>/<session>.jsonl`。slug 是工作区路径把每个 `/` 与 `.` 换成 `-`，所以 `/Users/you/proj` 变成 `-Users-you-proj`。该文件夹最上层最新的 `.jsonl` 就是当前会话。它的 `<session>/subagents/` 文件夹存放子智能体的会话记录。只读这个工作区自己的文件夹。 |

### 仅 Cursor 有的功能（Cursor-only features）

Claude Code 没有 Cursor Automations、Bugbot、Cursor 云子智能体或内置 PR 工具。某一步需要它们时，在你的回复里放一行 `Skipped in Claude Code: <step>. <reason>.`，然后继续下一步。不停下、不询问、不重试。后面的步骤需要被跳过那一步的产出（例如一个 URL 或一个 key）时，留一个占位符，并在那一行里点名它。

| Cursor | Claude Code |
| --- | --- |
| Cursor Automations：例程、`update_state` 例程调用、`api2.cursor.sh/automations` webhook、例程唤醒，以及 `SendToUser` 密钥请求 | 用那一行跳过。 |
| Bugbot | Bugbot 在 GitHub PR 上的评论就是普通评审线程，用该步给出的 forge（代码托管平台）命令去分诊即可。PR 没有 Bugbot 检查或评论时，跳过启动、等待或配置 Bugbot 的步骤。 |
| Cursor 云子智能体 | `environment: "cloud"` 映射为 worktree，同"子智能体字段"。需要云子智能体本身的步骤（如它的面板状态或它自己的机器）跳过。 |
| 内置 PR 工具 | 用该步给出的 forge 命令，如 `gh pr create`。这不算跳过，所以不写那一行。 |

---

## 镜像说明（MIRROR.md）

### 同步本镜像（Syncing this mirror）

本仓库镜像 [`cursor/plugins/pstack`](https://github.com/cursor/plugins/tree/main/pstack)，并带有自己的改动：`README.md` 的顶部内容，以及部分技能里与宿主环境无关的措辞改写。

两条分支保护这些改动：

- `upstream` 分支原样保存 Cursor 的文件，不带任何本地改动。
- `main` 分支是 `upstream` 加上本镜像的改动。

绝不把 Cursor 的文件直接复制到 `main`。那会抹掉这些改动。

### 步骤（Steps）

1. 把 Cursor 最新的 `pstack/` 文件夹复制到 `upstream` 分支：

   ```bash
   git clone --depth 1 --filter=blob:none --sparse https://github.com/cursor/plugins.git /tmp/cursor-plugins
   git -C /tmp/cursor-plugins sparse-checkout set pstack
   git switch upstream
   rsync -a --delete --exclude .git --exclude MIRROR.md /tmp/cursor-plugins/pstack/ ./
   git add -A
   git commit -m "upstream: cursor/plugins/pstack @ $(git -C /tmp/cursor-plugins rev-parse --short HEAD)"
   ```

2. 把它合并进 `main`。Git 只应用上游变化的部分，并保留本镜像的改动：

   ```bash
   git switch main
   git merge upstream
   ```

   出现冲突，说明 Cursor 改动了本镜像也改过的一行。保留 Cursor 的新含义，重新套用与宿主环境无关的措辞。

   同时保留 `README.md` 的"What this mirror changes"清单下列出的社区修复，除非 Cursor 已发布了相同的修复。那样就采用 Cursor 的版本，并从清单里删掉那条修复。

3. 刷新随附的 Comment Sicko prompt，然后确认没有新的 Cursor 专用指令混进来：

   ```bash
   cp agents/comment-sicko.md skills/no-comments/references/comment-sicko.md
   git diff upstream@{1} upstream -- skills | grep -nE '\.cursor/|agent-transcripts|cursor-team-kit|create-skill|Task'
   ```

   对新的命中项，按现有改动的方式重写。`skills/poteto-mode/SKILL.md` 的宿主环境适配（Harness）章节列出了映射。

4. 在 `SYNC-LOG.md` 顶部加一行，写明日期、上游版本与结果。上游没有变化时也加一行。

5. 推送两个分支：

   ```bash
   git push origin main upstream
   ```
