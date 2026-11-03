# 工程剧本 3/3：交付与工作流

> 接 [01 任务类](playbooks-01-task.md)、[02 自主与编排](playbooks-02-autonomy.md)。本篇覆盖 PR 交付、审查辅助与工作流类剧本。文件名保持英文。**本译文仅供人阅读，Agent 执行时读英文原文。**

---

## Opening a PR（开 PR）`opening-a-pr.md`

在其他每个剧本的末尾被调用。

**Worktree。** 从 main 拉出的 git worktree 里工作。子智能体继承它。同一分支上的多个 `Task` 调用各自拿到自己的 worktree，或在两次调用之间 `git fetch && git reset --hard origin/<branch>`。分支上有无关脏工作：先 patch 出来，开新 worktree，再应用。纠缠不清的 worktree：从 main 重置，最小重做。

**Commits。** 放心提交。开 PR 之前 rebase 成小的、有序的 commit。每个 commit 是一个未来的 PR：可落地、按叙事排序。修复属于刚做的 commit 就 amend。可拆分就新开 commit。commit 正文不复述标题。

**PRs。** commit 前对 diff 跑 `cursor-team-kit` 的 `/deslop`，review 前跑 `/no-comments`。每个 PR 标题、描述、commit 正文都用 `/technical-writing` 写（除 Diátaxis 外的所有层，并应用 STE 词汇规则：一个动作一个词、保留冠词、能用平实动词就不用 `-ing` 形式），然后应用 `/unslop`。

**标题。** Conventional Commits 的 `type(scope): subject`，结尾无句号。type 如 `feat`、`fix`、`docs`、`refactor`、`test`、`chore`、`perf`。scope 是领域，如 `pstack` 或 `poteto-mode`。subject 短、祈使、当某个符号承载变更时点名它，例如 `fix(pstack): retarget opening-a-pr babysit trigger`。

**描述。** PR 正文是一份一分钟简报，不是实验记录本，读者是已经拿到 diff 的评审者。它说清变更为什么存在、刻意排除什么、可能破坏什么、你怎么证明它有效。写短句、简单句、少用标识符，不要文字墙。正文会成为 squash commit 的正文，所以整个 commit 控制在约 40 行以内。用 `##` 标题，不用加粗引子，顺序如下，没有内容可说的段落删掉：

- `## Why`：问题与思路，1–3 个短句。不写 SHA、不写 rebase 谱系、不写"基于 main"的开场白。
- `## What changed`：1–3 个短点。只在符号或路径承载变更时才点名。重命名或改目标要把两侧都写出来。
- `## Scope`：必有。1–3 个短条目，写覆盖什么、刻意不覆盖什么（一个跟进项、一个已知缺口）。不写符号、路径、逐文件散文。
- `## Tradeoffs`：只写评审者 otherwise 会追问的被否决备选。没有真实取舍就跳过。
- `## Blast Radius`：1–2 句，触到谁或什么、为什么安全或有风险。main 正红时，写明让它红着的代价。
- `## Verification`：1–3 个要点，每条是真实的运行路径及其结果。性能：一个主数字带单位，`before → after`，其余链接到 arena 或 swarm 目录。不写样本量方法论、swarm 逐项复述、指标表格。

段落之后，能证明主张才附视频或截图。完整 SHA、swarm/arena 泳道复述、杠杆修正论述、逐文件清单、"CLEAN" 裁决，都放进链接的制品，不放正文。

**Forge。** 第一次 PR 操作前裁定 forge，并为 create、edit、view、watch、merge 保持该选择。GitHub CLI（`gh`）是默认。若 `command -v origin` 成功且 Origin 能解析本仓库，优先 `origin pr ...`。Origin 不存在或无法解析时，留在 `gh` 并记录回退。不要求 Graphite（`gt`）。

**内置 PR 工具。** 运行环境提供内置 PR 工具时，创建、编辑、改目标、标记 ready 都通过它，绝不通过 forge CLI。CLI 建的 PR 会丢失工具跟踪的东西。工具不覆盖的用裁定后的 forge；运行环境没有这种工具时，所有 PR 操作都走 forge。

**尺寸与堆叠。** 宁要五个窄 PR，不要一个大 PR。堆叠是 base 分支链。根 PR 以 trunk 为目标。每个子分支 rebase 到其父分支的精确顶端，其 PR 以父分支为目标。父 PR 合并后，按 `playbooks/shipping.md` 第 4 步把子 PR 移到 trunk。没有内置 PR 工具时，按裁定后的 forge：`origin pr create --status open --base <parent-branch>` 或 `gh pr create --base <parent-branch>` 创建子 PR；`origin pr edit <pr> --base <parent-branch>` 或 `gh pr edit <pr> --base <parent-branch>` 改目标。只有独立工作才从 trunk 拉分支。实质堆叠工作前先 rebase 到 trunk。

**就绪态。** 每个 PR 都开成 ready，绝不开 draft。内置 PR 工具可能默认 draft，所以每次创建调用都显式 `draft: false`。用 Origin 时传 `--status open`；用 `gh` 时不加 `--draft`。PR 仍开成 draft 时，通过 PR 工具标记 ready，或按裁定的 forge 跑 `origin pr ready <number>` 或 `gh pr ready <number>`。引用 PR 状态之前先跑 `origin pr view <number>` 或 `gh pr view <number>`。

**看护。** 开 PR 不等于开始看护。贴出 URL，继续构建。先完成阶段或整叠堆叠。只有用户在整叠堆叠存在后明确要求，才单独跑一次看护。每个新 PR 都起一次看护会拖慢构建、把检查烧在后续波次会重启的 commit 上。反馈偏离意图时顶回去。

开 PR 的子智能体跑 `/deslop` 与 `/no-comments`，贴 URL，然后返回父级，不看护——除非它是 Autopilot-full 或 Autopilot-stack 的负责人。那种负责人的 brief 会指派看护循环，正是 `playbooks/babysit.md` 等待的那个请求。负责人在 code-ready 报告之后启动循环、报告 merge-ready，并豁免本节与 `playbooks/babysit.md` 中"等整叠堆叠建完再看护"的规则。

---

## Shipping（交付）`shipping.md`

**你拥有落地的东西。独立验证每个 PR，只落地从根部起经过验证的连续段，然后对堆叠放手。**

1. **裁定 forge，然后独立验证每个 PR。** GitHub CLI（`gh`）是默认。若 `command -v origin` 成功且 Origin 能解析本仓库，所有 PR 操作用 `origin pr`。否则留在 `gh` 并记录回退。绝不要求 Graphite（`gt`）。每个 PR 一个验证器（各自是 Cursor 云 agent），用匹配的 control 技能（如 `cursor-team-kit` 的 `control-ui` 或 `control-cli`）以用户的方式运行该变更，parent 对 head，并在该 PR 上发布 `PASS`、`PASS+NOTES` 或 `FAIL`。**只有来自没写过该代码的 agent 的裁决才算数**，因为作者检查的是"它想建成什么"。绿 CI 和通过性的 bot 评审不是裁决，因为它们都没有以用户的方式运行该变更。
2. **只落地从底部起连续的已验证段。** 从最低的未合并 PR 向上走，停在第一个没有 `PASS` 或 `PASS+NOTES` 的地方。它下面的 PR 构成这次 run，最高的已验证 PR 是天花板。在未验证 PR 之上的已验证 PR 要等，因为下面没有合它落不了。其分支既不包含也不需要那段代码的 PR，可以移到 trunk 独立落地——但要先拿新裁决，因为它的旧裁决是在那段代码之上跑出来的，trunk 上没有那段代码。
3. **复查裁决是否仍然描述当前代码。** 裁决覆盖一个补丁，而链式 rebase 会把其上每个 PR 移到新 SHA，且不打破任何检查。信任旧裁决之前，对比裁决 SHA 处的 `git patch-id` 与当前 head。补丁只在测试、文档、lint 配置上有差异时，若其泳道运行的内容在两个 SHA 上构建等价（除噪音外），结果仍有效。噪音指：在裁决 SHA 的两次构建之间也会出现的差异、或内嵌的 commit SHA。每类噪音连同其文件一起报告，让读者能复核这个判断。变更本身仍要新鲜检查与评审，因为旧裁决没见过它。没有构建输出的泳道（如 dev server）无法这样证明，重跑它，并重验其他漂移的东西。
4. **自底向上落地，一次一个 PR。** 总是合并该 run 最低的未合并 PR，用 `origin pr merge <pr>` 或 `gh pr merge <pr> --squash`。Origin 上裸命令还会合并你所指 PR 之下的每个 PR；GitHub 上 base 仍是父分支的 PR 合进父分支而不是 trunk。读回 PR 确认结果（`origin pr view <pr>` 或 `gh pr view <pr> --json state,mergedAt,baseRefName`），因为合并命令可能报成功而合并队列只是排了队，且被请求的 auto-merge 不是合并。已落地的 PR 读回应为 merged 且 base 是 trunk 而非父分支。`--auto`（Origin 的 merge-when-ready 或 GitHub 的 auto-merge）只武装在裁决覆盖其当前 head 的 PR 上，因为它落地的将是任何 ready 的 head。合并落地后，把 base 原为该分支的 PR 改目标到 trunk（`origin pr edit <pr> --base <trunk>` 或 `gh pr edit <pr> --base <trunk>`），把补丁移到合并结果上，用 `--force-with-lease` push。裁决覆盖补丁而不是 commit，所以第 3 步的 patch-id 规则决定裁决是否存活。检查通过且裁决存活后合并它。
5. **落地期间对堆叠放手。** 第 4 步对下一个 PR 的移动是对分支或 base 的唯一变更，因为合并落地的是其分支与 base 当时持有的一切，无论裁决如何。GitHub 上，用 `playbooks/babysit.md` 的排队 watcher（`scripts/watch-pr/watch-pr --queued-stack --stack-prs <自底向上>`）在 `/loop` 下监视，直到天花板报告 `COMPLETE`。Origin 上，每次 `origin pr checks <pr> --watch` 返回就用 `origin pr view <pr> --checks` 重读当前 PR，直到天花板读出 merged。父合并后 base 移到 trunk 是预期行为，不是要修复的损伤。合并停滞时先弄清原因再动任何东西。
6. **停在天花板。** 扩展 run 需要新裁决，所以那是第 1 步的新一轮。

**回应：** 已验证 run 及其天花板、每个 PR 的裁决及产出者、落地了什么怎么确认的、下一个缺口需要什么。

---

## Show me your work（亮出你的工作）`show-me-your-work`（技能）

**为长程或无人值守的工作保留一条可评审的决策轨迹：TSV 日志，每个决策一行（做了什么、为什么、证据、结果）。默认留在本地；评审者需要凭轨迹信任结果时才提交入库。**

保留唯一权威日志。

### 格式

单个 TSV 文件，每个决策一行。单元格保持单行。证据是指针，不是散文。

复制 `references/decision-log-template.tsv`（表头行）开始一份干净日志。列：

- **ts.** ISO8601 时间戳。
- **phase.** 阶段或工作流。
- **decision.** 选了什么或做了什么，一行。
- **why.** 平实语言的理由。若是某条原则驱动，平白说出它，不要堆术语标签。
- **evidence.** 证明它的链接或路径：commit SHA、PR 号、`file:line`、或制品/trace/截图路径。绝不是一个段落。
- **result.** 结果或谓词状态：`tests green`、`reverted`、`pixel-diff 0`、`INCONCLUSIVE`、`open`。

示例（平白到评审者一眼读完）：

```
ts	phase	decision	why	evidence	result
2026-05-24T09:02:00Z	frame	counted the work first, about 100 components and roughly 75 hours	wanted to know the size before starting a long run	commit 3a9f1c2	found 5 things to sort out before starting
2026-05-24T09:40:00Z	harness	took screenshots of the old version before changing anything	so we can compare old against new and catch any visual change	scripts/snapshot.sh, baseline/	saved 120 reference screenshots
2026-05-24T11:15:00Z	widget	moved the widget styles over without changing how it looks	keep the change small and the result identical	commit 7c21e0a, pixel-diff 0	looks identical, tests pass
2026-05-24T12:30:00Z	widget	threw out a helper's work because its screenshots were blank	checked the real files instead of trusting its summary	worktree reset	reverted, tightened the instructions for next time
```

### 记一行

每条按"你会怎么跟同事说"来写。平实的词、具体的动作，没有 AI 腔或抽象行话（**unslop** 技能同样适用于日志文本）。

用辅助脚本 `scripts/log.sh <logfile> <phase> <decision> <why> <evidence> <result>`。它盖 `ts` 时间戳、首次使用时写表头、剥掉游离的制表符与换行、并给以 `=`、`+`、`-`、`@` 开头的单元格加单引号前缀。裸 `printf` 追加一行也行，但单元格来自生成文本或用户输入时，当心同样的字节。

记决策点与检查点，不是每个动作：选定的一次分叉、一个单元及其验证结果、一次转向或回退及其触发、一个浮出的阻塞、一个修好的门禁。循环运行每次迭代一行。琐碎与自明的跳过。

一次 run 是一个 agent 会话，包括其后续回合及对它的任何总结。一次 pickup、一个替补 agent、或一个新 chat 开启新的 run。run 向已有行的日志追加时，它的第一行 phase 为 `start`；在另一个 run 的 `start` 行之后的第一行也是。所以回到旧日志的 run，先读最后几行确认是否有别的 run 写入过。`start` 行写明本次未写的之前各行的 `ts` 范围，其 evidence 指明本次 run（如 agent id）。phase `start` 不作他用。

### 放在哪

默认日志是工作制品，不入库。放在工作目录的 `decisions.tsv`，多个工作并行时放 `.audit/<task-slug>.tsv`，排除在 git 之外。

只有当工作雄心到评审者需要轨迹来信任结果时才提交。

### 规则

- 只追加。错误的判断用新的一行去取代它。绝不编辑或删除历史。
- 优先用已入库脚本产出的证据，而不是手工一次性产物（**encode-lessons-in-structure** 原则技能）。

### 对照会话记录审计日志

run 结束、交回之前，检查日志说了真话。从当前 workspace 的会话目录读本次会话记录：Cursor 是系统提示点名的 `agent-transcripts/`；Claude Code 是 `~/.claude/projects/<slug>/`（workspace 路径中每个非字母数字字符换成 "-"）；Pi 是 `~/.pi/agent/sessions/--<slug>--/`；Codex 是 `~/.codex/sessions/` 中首行 `payload.cwd` 等于 workspace 路径的文件。不要跨所有项目的目录 glob，那会读到无关的私人聊天。把本次 run 的各行与实际发生的事对走。每段从本次 run 的一个 `start` 行开始（或本次 run 创建日志时的第一行），到下一个其他 run 的 `start` 行结束：

- 检查每行都对应一个真实决策或动作。
- 检查每行的 evidence 能解析、且显示该行主张的东西。
- 塑造了工作却没有入册的分叉、转向或被放弃的方案是缺口，补上。

**修正日志，而不是修正故事。** 审计绝不编辑或删除行——哪怕是编造的行。某行既非真实决策也非真实动作、或其主张与证据有错时，加一行取代之，写明实际发生的事和能解析的指针。本审计不检查本次 run 区段之外的行；若本次工作显示某行有错，像任何错误判断一样取代它。

### 轨迹的跨模型评审

交回之前，派一个与干活模型**不同家族**的子智能体。自我评审不是替代品。子智能体读审计轨迹与会话记录，标出用户该注意什么。不是重做工作，是扫描次优与风险。按 **poteto-mode** 的"子智能体"一节选档位与速度。

- 证据薄弱或缺失的已记决策。
- 会话记录里被跳过、或宣称却无证明的验证步骤。
- 事后看有风险的选择（过早、范围蔓延、粉饰症状）。
- 用户粗读会漏掉的缺口。

产出轨迹的 run，每条回应以"Attention"一节收尾。首行单独写评审模型（`reviewed by <model>`），然后逐条列出 flag 并指向具体行或时刻。"No flags" 是合法值。模型名不是。

### 评审轨迹

自顶向下读、跟着证据指针、抽查。GitHub 把入库的 TSV 渲染成表格。终端里用 `column -s$'\t' -t decisions.tsv`。

### 组合本技能

其他技能把审计轨迹路由到这里，而不是各造一份。按名字引用，让它拥有格式。不要复述列定义。

---

## No comments（无注释）`no-comments`（技能）

派生 Comment Sicko，执行被接受的发现。

尊重 Comment Sicko 的新鲜视角。

### 范围

用调用方给的文件或 diff。否则用当前 diff 对 base 分支（默认 `main`），含工作树。

### 步骤

1. 派 `Task`，`subagent_type: "comment-sicko"`。传范围。按 **poteto-mode** 的"子智能体"一节选档位与速度。不复述其规则。宿主没注册 comment-sicko（Cursor 之外的一切宿主）时改派 general 子智能体：Claude Code 的 `Agent`（`subagent_type: general-purpose`）、OpenCode 的 `task`（`subagent_type: general`）、Codex 的 `spawn_agent`。其 prompt 是 [`references/comment-sicko.md`](https://github.com/backnotprop/pstack/blob/main/skills/PLACEHOLDER/references/comment-sicko.md) 原文，加范围。宿主没有子智能体工具（如无扩展的 Pi）时，自己在一次全新遍历中执行该 prompt。
2. 检查其报告与 diff。拒绝：应用代码编辑、越界、带异常保护的删除、失实的 `MUST KILL` 理由、以及把刻意保留代码当有罪的 flag。针对"我们代码里的意外"的 flag 保持可执行。不恢复那些注释。一条 keep（保留）只有在证明它关于我们无法改变的东西时才存活。审计遗漏的作用域 lint 与 TypeScript 抑制。正确性或安全类抑制保持可执行的 `MUST KILL`。只有精确的例外与作用域内的证明才能恢复删除。接受单薄的 `IMPORTANT` 或"勿删"类 kill/keep 之前，对其符号跑 `/how` 或 `/why`。kill 含糊就不恢复。keep 被驳倒或仍含糊就删——关于外部规则的 `REVIEW` 类 keep 除外，它留着直到有人核实那条规则，并报告为 open。被拒绝的报告回退后点名失败原因重跑一次。重跑仍被拒，则只回退其被拒发现、报告 open、继续用被接受的。
3. 直接修复琐碎的被接受 flag：删死路径、删参数、改用真实 API。某修复需要定形状时，对被接受集合及其周边代码跑一次 `/architect`。停在草图。architect 定形状，第 4 步实现。
4. 在范围内实现最小根因修复。移除每个被点名的变通。根因出界时，落地最小的界内修复，其余报告 open。**principle-fix-root-causes** 与 **principle-redesign-from-first-principles** 技能只指导意图。两者都不授权扩大围栏或修围栏外的实例。绝不钉症状守卫。
5. 约束类注释说"勿删"、"勿改措辞"、"改前先找 X"。为无法改变的东西保留 keep。提供最便宜的界内编码：类型、运行时、测试或 CI lint。等交互式批准。无人值守与 eval 场景需调用方预批准。批准则编码后删除。否则删除、报告约束 open、草图出界工作。
6. 报告：删除数、恢复的注释、`REVIEW` keeps、重跑、architect 草图、修复、编码提案、已编码项、未被强制执行的约束、其他 open 工作。

---

## Unslop（去 AI 腔）`unslop`（技能）

编辑文本以移除 AI 模式。扫描下列模式，然后重写。保住含义，匹配预期语气。

> 译注：规则编号是稳定 id，被其他技能引用。规则 13/14 涉及英文标点，中文写作不适用原文约束（详见《失效与误导条款清单》），但保留原文以完整呈现技能全貌。各条末尾括注为中文写作的对应建议。

### 内容

3. **表层 `-ing` 短语。** "highlighting..."、"ensuring..."、"reflecting..."、"showcasing..."、"fostering..."。删除，或用真实来源展开。（中文对应：空泛的"旨在……""致力于……"）
5. **模糊归因。** "Experts believe"、"Industry reports suggest"、"Some critics argue"。点名来源或删除。（中文对应："专家认为""有分析指出"）

### 语言

7. **AI 词汇。** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape（抽象义）, pivotal, showcase, tapestry（抽象义）, testament, underscore, vibrant。换平实词。（中文对应：赋能、抓手、闭环、沉淀、打通、颗粒度等黑话）
8. **花式说"is"。** "serves as"、"stands as"、"boasts"、"features"。直接说 "is" 或 "has"。
9. **"不仅是 X，更是 Y。"** 直接陈述要点。
10. **三段式强迫症。** 不要硬凑三个一组。用自然数量。
11. **同义词轮换。** 同一段里 protagonist、main character、central figure、hero 换着用。选一个，重复它。
12. **虚假区间。** "from X to Y" 而 X、Y 不在有意义刻度上。直接列条目。

### 风格

13. **Em dash 滥用。** 完全避免 em dash。只用句号或逗号（不用括号、en dash、连字符替代）。需要分隔就结束句子或用逗号。
14. **冒号滥用。** 列表或示例前的冒号可以；句中连接符不行。"If you're coming from traditional automation: instead of..."这种冒号不增加任何信息。重写让要点自立。
15. **粗体滥用。** 不要每个专有名词或缩写都加粗。
16. **行内标题式列表。** 标志是加粗标签加冒号复述本行："**Performance:** Performance improved..."。改成散文。以句号结尾、点名字目、后接真新信息的加粗引子（"**Schema in TypeScript.** Tables live in one file."）没问题，不是标志。
17. **标题 Title Case。** 用 sentence case。
18. **装饰性 emoji。** 从标题与要点移除。
19. **弯引号。** 用直引号。

### 对话腔

20. **聊天机器人短语。** "I hope this helps!"、"Let me know if..."、"Of course!"、"Certainly!"、"Found the smoking gun!"。删除。
22. **谄媚语气。** "Great question! You're absolutely right!"。直接回应。

### 填充

23. **填充短语。** "In order to" 改 "To"。"Due to the fact that" 改 "Because"。删 "It is important to note that"。（中文对应："值得注意的是""众所周知"）
24. **过度对冲。** "could potentially possibly be argued that it might" 改 "may"。
25. **泛泛结论。** "The future looks bright."。陈述具体计划或事实。

### 行话

26. **抽象隐喻名词。** Substrate（→base）、wedge、wedge in（→add）、vector（→way, method）、locus、vantage、nexus、作名词的 primitive、作隐喻的 harness、"API surface" 的 surface、bedrock、作隐喻的 scaffolding、modality、paradigm、gold-plating（超过工作所需的镀金）、作隐喻的 ratchet（写机制真名，或"只会收紧的限制"）、evacuate 移动代码（→move out）、endgame（→最后阶段）、north star、flywheel。这些读起来很技术，但几乎都有更平实的具体词。选具体的词。

### 平实言语

27. **说它做什么，不说它感觉如何。** "the database stays close at hand"、"SQL you can read"、"types that follow your schema" 命名的是一种感觉。修复是命名机制或数字："`.toSQL()` 返回发给数据库的精确字符串"、"重命名一列会让构建失败"。问这句想让读者做什么或知道什么，然后写那个。无法改写成具体指令、事实或数字就砍。多一个检查：这句话若能原样出现在另一个项目的文档里，它对本项目就什么都没说。砍。
28. **压缩或拆分密句。** 读者要回读才能解析的句子，断成两句或去掉从句。一句一个想法。
29. **主动语态。** 优先。"is/are/was/were + 过去分词"要抓出来并点名行动者："queries are validated" → "the compiler validates queries"；"the file is parsed by the loader" → "the loader parses the file"。行动者未知或确实无关紧要时被动可以。
30. **砍副词，或换更强的动词。** "runs quickly" → "is fast" 或那个数字；"significantly improves" → 实测差值。副词撑着弱动词，说明动词选错了。
31. **优先平实词。** "utilize"、"leverage" → "use"；"facilitate" → "help"；"numerous" → "many"；"in the event that" → "if"。花哨的同义词很少更清楚。
32. **做作的散文。** 有字面短语却用隐喻或花腔：格言式表达（"wire it or delete it"）、修辞性残句、拟人化代码（"the plan holds it"）、比喻性动词（"rides along"、"stands on"）、套话框架。"A dial worth turning" → "a parameter worth varying"。说你的意思。规则 26 覆盖隐喻名词。
33. **过度压缩。** 掉冠词、无动词残句、符号腔、逼读者解码而非阅读的缩写。"Parser rejects bad date → exit 2, no write" → "The parser rejects a bad date, exits with code 2, and writes nothing."。写带冠词与动词的完整句子，箭头与缩写展开写。

---

## Technical writing（技术写作）`technical-writing`（技能）

写到让一个疲惫的工程师第一遍就懂。应用全部四层。

三条规则高于各层：

- **砍掉每个不做功的词。** 句子少了某个词仍然成立，那个词就走。"In order to" 就是 "to"。"It is important to note that" 什么都不是。
- **用短的、日常的词。** "Use"，不是 "utilize"。"Help"，不是 "facilitate"。"Do"，不是 "perform"。长词要用精确性来赎回它的长度。
- **当一条规则让句子变差，换一种方式修句子或别管它。** 每条规则都遵守、读起来像机器写的句子，已经失败了。

代码库就是词汇表。写真实的符号、文件、flag、命令名，不写同义词或对它的描述。

不发明行话。用开发者会大声说出来的词："move"、"delete"、"a budget that only decreases"，而不是 "evacuate"、"ratchet"、"endgame"。命名模式可以，只要文档第一次出现时说清它指什么。发现新的违规者，在回应里作为 `unslop` 抽象隐喻规则的增补提案提交，带 diff。不要直接改那个技能。

## 变化节奏

一份文档可以每层都合规、读起来仍是机器写的：每个句子都短促，全文无观点，无具体物。

- 有意识地混合句子长度。短句落地一个点。长句携带带条件或后果的事实。
- "一句一个想法"不等于"一句一个长度"。承载两个想法的句子拆开。承载一个想法的长句保留。
- 在文体允许处给出观点。Explanation 权衡取舍，就说你怎么取舍，而不是罗列正反。Reference 保持干。
- 具体胜过无菌。不是"schema 变更可能引发问题"，而是"重命名一列会让构建失败"。

## 先选模式（Diátaxis）

一份文档，一种模式。两个问题选定它：内容是服务行动（做）还是理解（想）；服务学习还是服务工作？

- 行动 + 学习：**tutorial**。
- 行动 + 工作：**how-to**。
- 理解 + 工作：**reference**。
- 理解 + 学习：**explanation**。

罗盘可用于整份文档，也可用于一个句子。

**Tutorial：边做边学。** 学习者的成功是你的工作，不是他们的。开篇说学习者将建成什么，而不是他们将"学到什么"。每一步都尽早且频繁地产出可见结果。告诉他们应该看到什么：预期输出、提示符变化、日志行。解释压缩到一个从句加一个链接。保持具体。以"我们"的口吻写命令："First, do x. Now, do y."

**How-to：通往目标的步骤。** 解决一个人拥有的问题，不是机器能执行的运算。假设胜任，跳过教学。只有行动：不跑题、不铺背景、不为完整而完整。要跑题和背景就链接过去。允许分叉与判断："If you want x, do y." 以任务命名指南："How to calibrate the radar array"，不是 "Radar array calibration"。

**Reference：供查阅的事实。** 只描述。无指令、无说服、无观点。干燥、完整、笃定。陈述事实、选项、限制、错误，不加对冲。镜像被描述物的结构，让代码与文档可以并排导航。材料放在读者期望的位置。尽量从代码生成。

**Explanation：理解与为什么。** 一个有界主题，可以在产品之外独立阅读。每个标题容忍一个隐含的"About..."前缀。锚定一个真实的 why 问题。给上下文：设计决策、历史、约束、备选。观点允许出现在这里，且只在这里。

不混模式：tutorial 里不放 reference 表格，reference 里不放 tutorial 手把手，how-to 里不辩论。拆开并链接。

## 面向读者写句子（Google 开发者文档风格）

- 以"你"称呼读者，用现在时。"Will"只留给真正以后发生的事。
- 说清谁做谁："the compiler checks"，不是 "is checked"。行动者未知或无关紧要时被动可以。
- 指令写成命令："Click Submit."。平实陈述事实。绝不"should be done"。
- 条件放指令之前："To delete the document, click Delete."
- 常见情形在前。例外在后。
- 像一个懂行的朋友说话。无 buzzword、无比喻、指令里无"please"、流程里绝无 "simply"、"easy"、"quickly"。若真简单，读者不会在这里。
- 不预告（"we will soon support..."），连续句子不以同一短语开头。
- 用说清去向的词做链接：页面标题或一句描述。绝不"click here"。页内一句上下文优于页外一个链接。
- 标题承载要点，不只是话题（"Pick the mode first"，不是 "Modes"）。Sentence case。任务标题是裸动词短语（"Create an instance"），概念标题是名词短语。每页一个 h1，不跳级。
- 序列用编号列表，其余用圆点。列表前给一个完整句子。条目保持平行。
- 代码用代码字体。UI 元素加粗。用串行逗号。删 "etc."，并预先声明列表是部分的。

## 让陈述一次只装载一条（STE 规则）

- 一句一条指令。其余句子一句一个想法。
- 约 20 词以上的指令、约 25 词以上的其他句子，拆分。
- 警告或条件放在它所守卫的步骤之前："If hot oil touches your skin, injuries can occur."
- 保留 "the" 和 "a"："Remove backup file"有两种读法。"Remove the backup file"只有一种。
- 每个词一个含义、一份工作，然后保持住。"check"若意为检查，就不要再用它表达"约束"。
- 每个动作选一个词并坚持："start"，不在这里用 "start" 在那里用 "initiate"。
- 流程写成直接命令，绝不写成叙述、绝不用被动："Install the component"，不是 "the component must be installed"。
- 能避开就避开 "-ing" 词。

## 不给句子留下两种读法（Global English）

- "only"、"not" 这类词紧贴它们修饰的词："only fails on growth" 与 "fails only on growth" 说的是不同的事。
- 拆长名词串："the proto import budget check script" → "the script that checks the proto-import budget"。
- 每个 "it"、"they"、"this" 指向一个显然的东西。拿不准就重复名词。绝不用 "this" 或 "which" 指代整个从句。
- 不掉动词："Phase 1 moves the converters and Phase 2 the runtime" 让 Phase 2 没了动词。给它一个。
- 保留显示结构的小词，如 "Ensure that the switch is off" 里的 "that"。绝不用字数换清晰度。
- 系列中重复冠词以避免误读："the client and the host"，当它们是两个东西时。
- 句子可能有两种分组时，说清 "and"/"or" 连接的是哪些部分。"Both...and"、"either...or"、"if...then" 是免费消歧器。
- 用句号，不用分号。em dash 换成新句子。
- 括号内文字是完整语法单元或独立句子。绝不用 "(s)" 构成复数。
- 无斜杠：写 "a, b, or both"，不写 "a/b" 或 "and/or"。
- 每个东西一个名字，处处如此。一份文档把同一个东西叫 "the gate"、"the ratchet"、"the budget check"，等于教读者三件事。没变的东西不要翻搅。
- 跳过习语、口语、拉丁缩写、隐喻。

## 语气与仓库细节

- 本技能触及的每份文档都应用 **unslop** 技能。slop 模式目录归它管：AI 词汇、填充、对冲、格式化标志。
- PR 描述与 commit message 也是写作。除 Diátaxis 外的所有层都适用。PR 正文是一份评审者一分钟能读完的简报。不粘贴 swarm 日志、SHA 清单、指标表格，链接它们。
- 产品 UI 文案不是文档。那些用你产品的文案指南。
- 代码片段用 tab 缩进。写真实路径。让每个计数或目录声明在落地的那个 commit 上为真，并附上能重新生成它的命令。

## 完整示例

改前：

> Configuration of the proto import ratchet budget script parameters is performed via budget.json. Note that it's important to remember that running with --write, which updates the committed budget to reflect the current count, should only be done when lowering it. If exceeded, CI fails.

改后：

> `budget.mjs` reads the committed budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.

---

## TDD（测试驱动缺陷修复）`tdd`（技能）

仅当用户明确要求 TDD、失败测试或回归测试，**或**该缺陷有明显的廉价本地测试目标时使用。测试路径不清晰、昂贵、重度集成、或未被要求时跳过。

修一个有清晰、廉价测试路径的缺陷时，在改生产代码之前让坏掉的行为变得可执行。目标是一个聚焦的回归测试：修复前失败，修复后通过。

测试不切实际时不硬造。若可用测试需要大范围装置搭建、脆弱 mock、缓慢的端到端基础设施、只在生产存在的状态、含糊的复现步骤、或大量无关 fixture 变动，就跳过新测试，用最接近的有用验证替代。

### 工作流

1. **理解缺陷。** 识别预期行为、当前行为、受影响路径、最小可观察复现。
2. **选择最窄的可执行检查。** 优先该代码路径已有的最近的单元、组件、集成或回归测试。没有现实测试路径时，不要为了走流程从零造一个。
3. **先写失败测试。** 添加本可以抓住该缺陷的最小聚焦测试。测试编码预期行为，不镜像当前实现。
4. **修复前先跑新测试。** 确认它因预期的原因失败。通过、或因无关原因失败时，先修测试或复现，再动实现。
5. **修缺陷。** 做满足预期行为、同时保住周边契约的最小生产变更。
6. **重跑回归测试。** 确认现在通过。

### 失败测试不现实时

用最接近的可执行回归检查替代：定向脚本、手工复现命令、浏览器自动化、快照对比、日志断言、或聚焦集成检查。

宁可不加测试，也不要加坏测试。坏测试：主要在测 mock、编码当前实现细节、依赖时序或无关全局状态、为小修需要昂贵基础设施、或在证明修复后立刻会被删除。

### 护栏

- 不为迁就错误实现而改测试。
- 不弱化既有断言，除非预期行为真的变了且理由清楚。
- 回归测试聚焦该缺陷。避免大范围 fixture 变动或无关覆盖扩张。
- 缺陷是 flaky 的，尽量让测试确定性化，并记录被锁定的信号。
- 缺陷暴露更大一类失败时，先落地聚焦的回归路径，再考虑同族补充覆盖。

### 最终回应

报告证据，不只是结果：

- 点名修复前失败的测试或可执行检查，及它产生的失败。
- 点名修复后通过的测试运行及执行的周边验证。
- 若无法演示修复前失败证据，说明原因并描述替代使用的最近回归检查。

---

## TypeScript best practices（TypeScript 最佳实践）`typescript-best-practices`（技能）

先应用 **type-system-discipline** 原则技能。

| 规则 | 摘要 |
|------|---------|
| 可判别联合 | 用 `kind` 字面判别量建模变体，让不可能状态无法表示。不用可选字段袋。 |
| 品牌类型 | 用 `& { readonly __brand: "X" }` 给原始类型打品牌，防止混用。边界处验证一次。品牌来自验证型类型守卫（`input is AgentId`），绝不来自 `as`。 |
| 构造性建模 | 把形状造成非法值根本构造不出来：非空用 `[T, ...T[]]`，偶数长度用 `[T, T][]`，区间用 `start` 加 `duration`。不是运行时守卫，不是对 refinement types 的空想。 |
| 最简单全类型 | 只要其上每个操作保持全（total），就保持 `T[]`。只有当宽松类型逼出 `!`、cast、或"不应发生"的 throw 时，才强化为 `NonEmpty<T>`。 |
| `unknown` 优于 `any` | 外部数据是 `unknown`。 |
| Schema 先于守卫 | 手写逐属性类型守卫之前，用仓库的运行时 schema 库并从 schema 推导类型，如 `z.infer`。 |
| 无 `as` 强转 | 每个 `as` 都是一次等着的运行时崩溃。只在验证之后 cast。 |
| 收窄层级 | 判别 switch > `in` 运算符 > `typeof`/`instanceof` > 用户定义类型守卫 > `as`。 |
| 类型守卫 | 必须真验证。说谎的守卫比 `as` 更糟，因为缺陷藏在声称安全的名字后面。命名为 `isX` 或 `hasX`。 |
| 穷尽性 | 在 default 分支内联 `const _exhaustive: never = x;`，新增变体时编译器报错。 |
| `satisfies` 优于 `as` | 验证值而不拓宽字面量类型。 |
| 边界验证 | 在数据流入处解析为命名的领域类型。`Record<string, unknown>`（无论怎么拼写）止于该次解析。内部信任类型。见 **boundary-discipline** 原则技能。 |
| Schema 派生类型 | 声明新 interface 之前先用 `Pick`/`Omit`/`Parameters`/`ReturnType`/`Awaited`/`typeof`。 |
| 对象参数 | 传对象不传位置参数，参数顺序自说明。热路径（逐帧渲染、tokenizer、parser）例外。 |
| 真测试 | 能跑的不 mock。优先框架的真测试原语并带泄漏/释放检查，UI 在运行中的构建里验证。只 mock 本地跑不了的。 |
| 结构化遥测 | 优先结构化日志诊断，带足以凭一个 id 调试的上下文。交付代码里无 `console.log`。 |

示例见 `references/patterns.md`。

---

## Bro（人话重述）`bro`（技能）

用平实的人类语言重述你的上一条消息。停止使用行话，连贯地说。说得更简单、更精炼，像一个人对另一个人说话。

---

## In your own words（用自己的话）`in-your-own-words`（技能）

用自己的话复述：你认为用户的目标是什么，他们想解决什么问题。

---

## Sharpen（磨尖）`sharpen`（技能）

我要这个任务**更深**的版本，不是**更大**的版本。重写之前做四件事：

1. 说出这个领域的顶级专家会做、而我没有要求的事。
2. 说出他们会从什么最原始的材料出发，而不是已经被消化过喂给我的东西。
3. 说出他们会用的具体方法与工具。
4. 说出除了你和我之外，什么能证明结果是对的。

然后重写我的 prompt，精确地要求这些。

属于我做的选择保持开放，不要替我决定。
