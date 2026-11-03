# 工程剧本 1/3：任务类剧本

> 翻译自 `skills/poteto-mode/playbooks/`。每个剧本是 poteto-mode 内部的步骤清单，没有斜杠命令；描述任务时由 poteto-mode 匹配，也可用特定短语直接点名。文件名保持英文 kebab case（运行时按路径寻址）。**本译文仅供人阅读，Agent 执行时读英文原文。**
>
> 术语与译法基准见 [GLOSSARY.md](../GLOSSARY.md)。

---

## Bug fix（缺陷修复）`bug-fix.md`

**你拥有这个任务。规划、审查、验证。** 把调查和修复委派给子智能体，你留在主导位。按"子智能体"一节的规定，为每次派发选择合适的推理档位与速度。

要有科学态度。交付的每一行代码都要能追溯到运行时证据。"双重保险、可能有帮助"的东西是假设，不是修复，不许交付。当证据反驳某个假设时，回退它所催生的改动。只交付证据所能支撑的最小变更，仅此而已。

1. 在对应的交互面上**自己复现**（通过 control 技能，见"不可协商项"）。即使某个调试或埋点协议说"让用户来复现"，也要自己复现。只有在明确说明 control 交互面为什么够不到目标之后才能问用户，而且也要先把能驱动到的部分全部驱动完。若无法直接复现，就合成触发条件、收紧条件、或加埋点，直到它触发为止。
2. **二分定位原因。** 列出候选假设，逐一排除，直到剩下唯一幸存者。用 `how` 技能扫受影响的子系统来播种假设，用 **why** 技能查回归历史。每一轮，取能切掉最多剩余问题空间的那种分法，拿到运行时证据，排除。程序状态不清楚时，加埋点或日志，在代码运行时读它。**不要猜。** 长期或顽固的排查用 Cursor 的 `/loop` 命令驱动。在第 3 步的 architect/interrogate 扇出之前，先用运行时证据确认幸存的**机制**。
3. **规划修复。** 若跨越函数边界，先跑 `architect`。把实现委派给子智能体（用你配置的 bug-fix 模型，默认 `grok-4.7-xhigh-fast`），并给出明确范围。
4. **在同一交互面上验证。** 最初的 repro 现在通过了才算。"结果不确定"或"用错了交互面"都不算通过，要标记出来。单元测试展示的是分支行为，不是缺陷不存在。
5. **编排 commit，让失败的 repro 在 git 历史上先于修复落地。** 当该缺陷存在廉价的本地测试路径时，按 **tdd** 技能的"失败测试先行"节奏来。测试成本高、重度依赖集成、或路径不清晰时跳过。
   这正是 **sequence-verifiable-units**（串成可验证单元）原则技能的典型形态：失败测试在下，修复在上。
6. 运行 **Opening a PR**（开 PR）剧本。

**回应：** 什么坏了、根因、修复、你怎么验证的。原样粘贴"先失败后通过"的 repro 输出。

---

## Perf issue（性能问题）`perf-issue.md`

**你拥有测量这件事。规划、审查、验证数字。** 每个修复都要绑定一个测量，不要用读源码代替测量。

1. 通过对应的 control 技能抓取基线 trace。基线以及之后的每个数字，都要用 **benchmark-checklist** 技能审查。
2. 用 `how` 给假设提供依据。没有先跑过，就不要声称性能上限。
   按顺序尝试性能箴言（performance mantras），从最便宜的开始：
   1. 不做它。停掉没有任何东西使用其结果的工作，而不是把它做便宜。
   2. 做，但不重复做。
   3. 少做。
   4. 晚点做。
   5. 在没人看的时候做。
   6. 并发地做。
   7. 做得更便宜。

   当某条箴言已达标，就停。
3. 从 trace 出发规划修复。若跨越函数边界，先跑 `architect`。把实现委派给子智能体（用你配置的 perf-issue 模型，默认 `grok-4.7-xhigh-fast`）。按"子智能体"一节选档位与速度。审查 diff。抓修复后的 trace。
   应用 **sequence-verifiable-units** 原则技能，逐次尝试、逐次验证。
4. 解析并对比制品（JSON 转 sqlite，做 diff）。"结果不确定"或"用错了交互面"都不算通过，要标记出来。
5. 在 PR 里引用测量结果。
6. 运行 **Opening a PR** 剧本。

若要对某个指标做持续改进而不是一次性修复，用 Hillclimb 剧本（`playbooks/hillclimb.md`）。

**回应：** 基线数字、修复后数字、差值、制品路径。

---

## Hillclimb（爬坡优化）`hillclimb.md`

**你拥有指标与实验的完整性。监督与审查。委派尝试。** 用于对某个可度量事物对着目标做持续迭代改进。一次性修复用 Bug fix 或 Perf issue。这就是那个循环。

核心纪律：一次改一个变量，一次测量，保留或回退。绝不堆叠未经测试的改动，也绝不用代码阅读宣称胜利（**prove-it-works** 原则技能）。

1. 选指标之前先摸清工作负载与架构。对目标跑 **how** 技能，说出能真正移动结果的现实工作负载维度（数据量、历史长度、状态、并发），选一个能复现用户抱怨的案例。若没有案例能复现，先修 repro，再做爬坡。然后固定一个指标、一个"什么算更好"的方向，以及一个可检查的停止谓词——谓词要同时包含目标值和尝试次数下限，防止靠一次运气提前收工（"比基线好至少 50%，且至少迭代 10 次"就是这个形状）。用户给了数字就用用户的，否则先对齐数字。
2. 搭测量装置，证明它有区分度，然后冻结它（**build-the-lever** 原则技能）。跑对照的现实工作负载，确认目标案例能复现症状、简单案例能按预期拉开差距。若装置分不开它们，修改工作负载或指标。冻结前用 **benchmark-checklist** 技能审查装置，并让它打印错误数与完成工作量计数。冻结后，一条可重复的命令产出指标，采样足以盖过噪声（取 N 次中位数，不是单次）。在任何改动之前，记录基线指标，以及回归门禁（必须保持通过的测试）的一次绿跑。
3. 通过 **show-me-your-work** 技能开决策日志。一个 `decision.tsv`，每次尝试一行：id、假设、改动、before、after、差值、测试、结论（保留/回退）、备注。每次尝试前先读它。把它挡在版本树外（gitignore）。
4. 每条假设都要扎根在第 1 步的架构模型上，让它指向具体机制（"把 X 从启动路径上挪走，因为它阻塞首屏"），而不是"试试加个缓存"。性能指标按 Perf issue 剧本第 2 步的性能箴言排序假设。**只借它们的排序，不借那一步的停止规则。**
5. 循环，每次迭代一个假设：
   - 把改动交给子智能体（用你配置的 hillclimb 模型，默认 `grok-4.7-xhigh-fast`），范围收紧。按"子智能体"一节选档位与速度。监督并审查 diff，而不是亲手敲（**guard-the-context-window** 原则技能）。多条独立假设同时活跃时，扇出给并行的子智能体，各自在自己的 worktree 里（**separate-before-serializing-shared-state** 原则技能）。
   - 用冻结的装置测 before 和 after，跑回归门禁。
   - 只有指标移动超过噪声、且门禁保持绿，才接受。否则完整回退。"可能有帮助"的微调不保留。
   - 每个被接受的修复一个 commit，只 add 你改过的文件（`git add <files>`，绝不用 `-A`）。无论保留还是回退，都记一行日志。
   每次迭代以一个检查收尾，才开始下一次（**sequence-verifiable-units** 原则技能）。无人值守时，只借 Autonomous run 剧本（`playbooks/autonomous-run.md`）的唤醒机制，**不借它的停止规则**。
6. 推过第一个平台期。停滞时：连续多次被拒，就换类别；把差一点点的方案组合；重读源码；或试更激进的做法，然后才下"山已登顶"的结论。正确性和简单性排在数字前面。回退破坏行为的胜利，保留保住数字的简化（**laziness-protocol** 原则技能）。
7. 谓词达成即停。或者：剩余想法都边际且不值成本时停。不要为达标放松谓词，也不要在还有廉价未试假设时退出。卡住了就上报，不要空转。
8. 用被接受的 commit（按落地顺序堆叠）运行 **Opening a PR**。

**回应：** 指标与目标、基线到终值的百分比差、迭代次数（保留 vs 回退）、每个被接受修复一行、`decision.tsv` 路径，以及若继续推进你下一个最想试的想法。

---

## Runtime forensics（运行时取证）`runtime-forensics.md`

**你拥有诊断。对活着的进程做仪表测量，不要从源码空想。** 交付物是有引证的诊断，不是修复。

1. 通过 control 技能在对应交互面上抓活体信号：进程空转抓 CPU profile、泄漏抓堆快照、视觉毛刺抓 CDP trace。要真制品，不要猜。
2. 把制品压缩到冒烟的枪口：热路径上的那个函数、从泄漏对象到 GC root 的引用链、没有输入也在触发的那个循环。大制品在子智能体里解析（**guard-the-context-window** 原则技能），主线程只留压缩后的发现。按"子智能体"一节选档位与速度。
3. 相信机制之前先证明机制。通过 CDP eval 向运行中的进程注入仪表，或热修活代码不重载，廉价地确认假设。
4. 把发现映射回源码：文件、符号、分配或调度的那一行。
5. 吞吐检查点固定一行：`throughput checkpoint: n/a, read-only forensics`。

**回应：** 抓到的信号、压缩后的发现、你怎么证明机制、源码位置、制品路径。不主动修，除非被要求。根因已知后交回 Bug fix 或 Perf issue。

---

## Trace forensics（轨迹取证）`trace-forensics.md`

**你拥有来自制品的诊断。**

区别于 **Runtime forensics**（对活进程做仪表测量）。这里采集已经存在。制品是固定的数据集，读它，不要重跑。工具保持通用：cpuprofile 和 `.json.gz` 用 DevTools 或 trace 解析器，spindump 用文本编辑器，heapsnapshot 用你的堆工具。

1. 识别格式，用对的工具加载。大制品在子智能体里解析（**principle-guard-the-context-window** 技能），主线程只留压缩后的发现。按"子智能体"一节选档位与速度。
2. 把原始制品变成可查询的形态。把 trace 或堆快照灌进 sqlite，每个样本、帧或节点一行。先拿到可查询的形状，再开始读。
3. 收敛到原因。查询占据时间最多的帧，沿调用树走到热路径。泄漏场景：沿引用链从泄漏对象走到 GC root。spindump 场景：找到卡在 CPU 上或阻塞中的线程，及其等待原因。
4. 归因到源码。用制品自带的符号表把热帧映射到文件、符号和行。没有源码映射的帧不构成诊断。解析符号，或明说该制品不带符号。
5. 若有成对的采集（改前/改后），对 diff 两个制品来确认。否则把发现标记为"该制品所能支撑的最强假设"，而不是已确认的原因。
6. 交回有引证的诊断，不修，除非被要求。根因已知后路由到 Bug fix 或 Perf issue。吞吐检查点固定一行：`throughput checkpoint: n/a, read-only forensics`。

**回应：** 制品与格式、压缩后的发现、源码位置、制品路径、成对采集是否确认。

---

## Investigation（调查）`investigation.md`

**你拥有答案。规划、路由、写作。**

调查请求是只读的。产出有引证的解释或建议，不改代码。

1. 经 **how** 技能路由。动机类问题再加 **why** 技能。
2. 吞吐检查点固定一行：`throughput checkpoint: n/a, read-only investigation`。
3. 产出 `how` 形态的输出（Overview / Key Concepts / How It Works / Where Things Live / Gotchas），或——若请求是在多个备选之间做决策——产出带权衡表的建议。
4. 对回应应用 **unslop** 技能。

不开 PR，不看护，不跑 `architect`——除非调查先于一次代码变更。若是，交回用户，重路由到 Bug fix 或 Feature。

**回应：** 调查输出本身。"我们确定吗？"类答案要带上你带理由的真实判断。前提错了就顶回去（见自主权一章）。

---

## Prototype（原型）`prototype.md`

**你拥有设计决策，不是代码。原型是一次性仪表。真正的构建走 Feature。**

这是唯一一个"懒惰协议的最小变更"和验证门槛**倒置**的剧本。速度优先于打磨，代码质量不重要，不做规划。严谨性在于廉价地选对设计。提出用户没要求的变体，扔掉一个方案再试下一个。

1. 先圈定原型要做的那个决策：哪个布局、哪个交互、哪个密度；或对经验性分叉，哪个行为、哪个时序、哪个方案。没有决策就不做原型，路由到 Feature。
2. 设计空间开放时收集参考。搜已有实现，汇总主题、配色、布局的 moodboard，让用户在构建前选方向。方向已定就跳过。
3. 在隔离的临时目录里构建一次性草样，与生产源码分开。视觉决策：原生 HTML/CSS/JS 或能渲染出想法的最轻技术栈，CDN 依赖，带热重载的 dev server。行为或时序决策：能驱动该问题的最小脚本。不上生产框架，不写测试，不做抽象。
4. 对比备选方案时，把它们做在同一个切换器后面（按钮或按键），每个变体有标签。这是 **exhaust-the-design-space**（穷尽设计空间）原则技能的廉价实现。
5. 在对应交互面上验证。视觉决策：通过 control 技能给每个变体截图并驱动交互。行为或时序决策：记录时序、打印输出、观察渲染——观察你正在决定的那个东西。这里的测试就是观察本身，不是断言。
6. 呈现备选方案、权衡与推荐。产出是决策加上一次性制品，不是可交付代码。把选定的方向交给 **Feature**（或 `architect` 定形态）做真正的构建。

**回应：** 探索过的变体、证据（视觉决策给截图、行为决策给观察到的输出或时序）、权衡、你的推荐、临时目录路径。明说原型是一次性的。

---

## Visual parity（视觉一致）`visual-parity.md`

**你拥有像素级等价。基线就是规格，你不许碰它。** 等价用图像 diff 验证，不用眼睛。

1. 先立基线，早于任何迁移：一个视觉回归装置，对当前组件的各个状态截图；若是对齐两个实现，还包括目标实现。没有基线就没有一致性主张。这是阻塞前置条件，不是后续跟进项。
2. 反作弊条款，明说并守住：不改装置、不篡改基线、不为了让 diff 通过而重构组件。基线看起来不对就停下来问，不许改它。
3. 一次迁移一个组件。跨 worktree 并行，每个组件一个负责人（**separate-before-serializing-shared-state** 原则技能）。共享原语最先迁移，作为阻塞阶段。
4. 通过 control 技能在对应交互面上用图像 diff 对基线验证每个组件。非零 diff 即失败。追查像素差。每个组件用 `/loop` 跑到 diff 为零。
5. 按组件或按安全批次运行 **Opening a PR**。

**回应：** 已迁移组件、每个的 diff 结果、基线装置位置、还剩什么。

---

## Refactoring（重构）`refactoring.md`

**你拥有契约。结构变，行为不变。** 区别于 Feature（增加行为）与 Bug fix（纠正行为）。

若清理过程暴露一个缺失的功能或真实缺陷，把它拆出去，先按钉死的契约交付结构变更。允许重设计，但要明说并路由到 Feature。大型或横切的结构工作归 **figure-it-out** 技能。本剧本管聚焦到中型的变更。

1. 先钉死行为契约。对受影响子系统跑 **how** 技能弄清契约，然后写一个特征测试（characterization test）、快照或等价装置，在任何结构移动之前捕获当前行为。该区域没有覆盖就先写 pin 再动结构。类型检查和 lint 不是 pin。
2. 按 **principle-model-the-domain** 说出代码缺失的结构。形状已经清晰且局部时，无聊的代码就留着。重塑必须删除分支或非法状态，而不是增加间接层。
3. 说出目标形状。说明若今天从零建，模块布局、类型、调用图应该是什么样（**principle-foundational-thinking**、**principle-redesign-from-first-principles**）。目标跨越函数边界时，先跑 **architect** 技能对形状做并行设计探索，再动手。
4. 先减后加。引入新形状之前，删死代码、收掉只有一个调用方的包装、删冗余校验器、清孤儿引用（**principle-subtract-before-you-add**）。到达目标形状的最小变更才交付（**principle-laziness-protocol**）。"可能有帮助"的投机清理要回退。
5. 小步移动，每步保持 pin 绿。API 重塑时，同一波内迁移全部调用方并删除旧 API（**principle-migrate-callers-then-delete-legacy-apis**）。不做兼容垫片，不留新旧并行路径。每个重命名对照真实文件抽查。重命名会静默漏掉字符串、散文、反向引用里的用法。机械编辑委派给子智能体（用你配置的 refactoring 模型，默认 `grok-4.7-xhigh-fast`），范围明确（文件路径、被移动的名字、要保持的行为）。按"子智能体"一节选档位与速度。
6. 在真实制品上证明行为未变，而不是"能编译"（**principle-prove-it-works**）。较大重塑跑等价性检查：diff 新旧输出的脚本、对新代码回放录制的基线、或通过相关 control 技能在对应交互面上做冒烟。
7. 确认变更值得保留。成功度量是读者负荷下降（**principle-minimize-reader-load**）。若 diff 没有在任何地方降低读者负荷，回退它。
8. 重排为小的有序 commit。先减法的 commit，再重塑，再后续清理。用 **sequence-verifiable-units** 原则技能塑形，让每个保持行为的切片在下一切片之前保持绿。运行 **Opening a PR**。

**回应：** 变了的结构、你钉住它的 pin、等价性证明、读者负荷差值、交付了什么回退了什么。无新行为。

---

## Feature（新功能）`feature.md`

**你拥有设计。规划、审查、验证。** 委派实现。留在主导位。

1. 对受影响子系统跑 `how`。
2. 跑 `architect` 做并行设计探索。
3. 把吞吐检查点写成四个待办项。某维度确实不适用（单文件、无扇出）时，保留该项并标 `n/a: <原因>`，而不是删掉：
   - **阻塞型先行步骤。** 扇出前先跑的门禁。
   - **独立工作流。** 不相交的文件、服务或层可以并行。共享写入必须串行。
   - **共享可变状态。** 默认拆分目标（**separate-before-serializing-shared-state** 原则技能）。只为真实不变式才串行化。
   - **最小安全分解。** 若单 worker 最优，说出为什么。
4. 把写代码委派给子智能体（用你配置的 feature 模型，默认 `grok-4.7-xhigh-fast`），范围具体（文件路径、命名的数据形态及其组织结构——按 **principle-model-the-domain** 选：用状态机而非散落布尔量、用表/注册表而非分支、用带类型的模型而非重复的形状假设，这些在委派者写逻辑**之前**选定——以及成功标准）。按"子智能体"一节选档位与速度。当实现允许多种有效形状（错误处理、抽象层、测试结构）时，改用 **arena** 技能委派，让各 runner 呈现备选、交叉裁判守卫选择。**强制项**：不允许"有理由跳过"，懒惰协议也不能覆盖它（其收益是审查分离，不是省行数）。被禁止派生的子智能体可以通过亲自持有 diff 并保持同样的审查分离来满足此项。不许回复"待命中"等嵌套 agent。注释遵循**注释**一章。外科手术式编辑；对上游派生文件，重新对照源码。把共享原语的改进同步移植到所有消费方并逐一验证。勤 commit。
5. 在对应交互面上验证。"结果不确定"或"用错了交互面"不算通过，要标记。
6. 重排为小的有序 commit。堆叠后续项。
   用 **sequence-verifiable-units** 原则技能：构建、验证、提交每个小单元，然后才进下一个。
7. 设计有争议时，交付前跑 `interrogate`。
8. 运行 **Opening a PR**。

代码耦合的工作（一个功能、一次迁移）交给单一负责人，检查点内联在它的任务里。负责人在阻塞阶段完成后于内部扇出。父级扇出用于产出独立制品的切片（审计、跨子系统调查、竞争性实验）。在阶段边界重写检查点。派全新负责人，不串联打断。

**回应：** 你构建了什么、你选了什么为什么、吞吐检查点、未决决策。设计备选方案用表格。

---

## Multi-phase or multi-PR plan（多阶段 / 多 PR 计划）`multi-phase-plan.md`

**你拥有计划，不是代码。计划是一张核对清单，由负责人逐格执行、由操作者凭证据审计。** 计划就是交付物。不要实现。

1. 变更只涉及一两个文件且做法显而易见时，跳过计划。说明并停止。
2. 动笔之前用原型解决开放问题。每个问题跑一次 `playbooks/prototype.md`。保留分支、SHA 和截图给附录 A。只有任何运行都无法裁决的产品或偏好问题才问操作者，并给出选项（**never-block-on-the-human** 原则技能）。
3. 在子智能体里探索，用 `subagent_type: "poteto-agent"` 并按"子智能体"一节显式指定模型（**guard-the-context-window** 原则技能）。按该节规定为每个子智能体选推理档位与速度。每个返回文件指针、约定、测试命令与入口点。不许内联倾倒大段内容。
4. 把下面的骨架复制进计划文件，填满每个占位符。操作者未指定路径时，写到 agent 存储的 `docs/` 下。每个标题、每个子块的顺序照抄。一个章节一个 PR。一个 PR 是一个自带证据的变更（**sequence-verifiable-units** 原则技能）。在 **How to read this** 里写明执行剧本。可能合入的选 `playbooks/autopilot-full.md`。由操作者落地 PR 的选 `playbooks/autopilot-stack.md`。常设工程用 `playbooks/orchestrate.md`。
5. 全文按 `/technical-writing` 写，然后 `/unslop`。正文只用一种 Diátaxis 模式：how-to。附录放解释与参考。每个标题直接陈述任务或发现。无长破折号，无句中冒号。
6. 跑 `node pstack/skills/poteto-mode/scripts/check-plan.mjs <plan.md>`，修掉它打印的每一行（**encode-lessons-in-structure** 原则技能）。
7. 交回。贴出计划路径与脚本输出，然后停。执行在操作者明确放行后才开始，按计划点名的执行剧本进行。

**验证。** 只跑测试不构成充分验证。一个 PR 只有当它的 unit、live、perf 三组格子全部勾选才算验证过（**prove-it-works** 原则技能）。这句话就是验证规则，每个验证块都以它开头。live 块是强制的。十条泳道在 PR head 上通过 control 技能驱动真实交互面（按 **swarm** 技能），跑在 `swarm workers` 模型上（默认 `grok-4.7-xhigh-fast`）。每条泳道是一个格子：具体场景、它保存的截图、通过谓词。其中一条是 **对主干（trunk）的回归泳道**：在 trunk 和 head 上跑同一个承重场景。若 trunk 没有该功能，该泳道记录这一事实，改为约束"diff 新增的行为加上用户等待的终态"，而不是编造一个 trunk 结果。性能门禁是双侧的。trunk 与 head 都必须产出指名指标。若 trunk 缺该功能，则隔离 diff 新增的工作，为它设绝对预算，加上用户等待的端到端状态。不许在不等价场景之间声称比值。perf 块写明指标、交错探针、先测的 trunk 基线、以及带失败数字的规则。改变交互的 PR 是评审门禁的：操作者在聊天里看截图和视频后才合并。不改交互的 PR 写 `**Review gate.** None. <PR id> is not review-gated.`，其下无格子。

**Control 技能。** 按交互面选。浏览器、Electron、web UI 用 `cursor-team-kit` 的 `control-ui`。CLI 与 TUI 用 `cursor-team-kit` 的 `control-cli`。原生移动端用仓库里现成的模拟器驱动技能。触及两个交互面的 PR 两边都要有泳道。没有 control 技能的交互面是附录 C 里的风险项，其 live 块仍要写明每条泳道怎么驱动它。

````markdown
# <工程名> plan

<十行以内。改什么、为谁改、本工程强制执行的那条规则、按顺序列出 PR id。>

## How to read this

一个格子是一个工作单元。每个格子写明检查它的证据。嵌套格子是上方格子的子步骤。只有证据存在时才勾选：一个文件、一行日志、一张截图、一次测试运行、或一个 SHA。正文是 how-to。附录负责解释与记录。

本工程运行 `pstack/skills/poteto-mode/playbooks/<执行剧本>.md`。<谁合并；哪些 PR id 是操作者的、停在 merge-ready 的项。>

Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

## Program checklist

### Arm the program（武装工程）

- [ ] 向操作者陈述协议与本计划，然后停。仅在操作者明确放行后开始执行。
- [ ] 工程开始时从 trunk 读以下文件，每个 tick 重读。
  - [ ] `git show origin/main:pstack/skills/poteto-mode/playbooks/<执行剧本>.md`
  - [ ] `git show origin/main:pstack/skills/swarm/SKILL.md`
  - [ ] `git show origin/main:<control 技能路径>`
  - [ ] `git show origin/main:pstack/skills/poteto-mode/playbooks/opening-a-pr.md`
  - [ ] `git show origin/main:pstack/skills/<工程用到的其他每个叶子技能>`
- [ ] 操作者放行后，用下方的 tick 提示词把审计 tick 武装为 `/loop 1h`。绝不让节奏依赖记忆。
- [ ] 逐字使用这个 tick 提示词："从 trunk 重读执行剧本。对照它审计本次操作并在本 tick 内修复漂移。探测每条活跃泳道，只凭副作用判断进度。让卡住的泳道退场，立即派它的替补。然后仅当审计发现了此前任何状态消息都没报告过的被追踪变更时，才在聊天里给操作者发一条简短状态，例如：PR 已开、代码就绪的 head、一轮已启动或已关闭、一个裁决、一次合并、一个卡住的 agent 及处置、一个新增或已清除的阻塞、或一个只有操作者能做的决策。只报这类变更，别的都不说。不要重复表格、已合并清单或未变化的阻塞项。审计没发现任何这类变更时，本回合无回复文本结束。无论哪种情况，都在决策轨迹里记下本 tick 的行，行里写明上报的条目或 none。"
- [ ] 操作者叫停或待命时，立刻向每个负责人下达零写入命令。

### Spawn owners（派负责人）

- [ ] 每个 PR 一个负责人，带执行剧本点名的完整生命周期。
- [ ] 遵循依赖图。父 PR 合并后才开依赖工作；执行剧本堆叠时，可基于父分支。
  - [ ] <PR id> 与 <PR id> 相互独立且先行。都从 `main` 拉分支。
  - [ ] <PR id> 在 <PR id> 之后。
- [ ] 守住文件边界。<PR id 或类别> 只触 `<glob>`。
- [ ] 守住评审门禁。<PR id> 改变交互。它们等操作者在聊天里看截图与视频后才合并。

### PR mechanics, for every PR（每个 PR 的机械步骤）

- [ ] 一次性裁定 forge。默认 `gh`；若 `command -v origin` 成功且 Origin 能解析本仓库，所有 PR 操作用 `origin pr`。记录任何回退到 `gh` 的情况。绝不要求 Graphite（`gt`）。
- [ ] 按 **Opening a PR** 开 PR，ready 而非 draft。有内置 PR 工具就用它，否则按裁定的 forge 用 `origin pr create --status open --base <base-branch>` 或 `gh pr create --base <base-branch>`。堆叠子 PR 以父分支为 base。
- [ ] 面向 PR 的 push 之前，跑一次仓库的 lint 与 typecheck。开着 hooks push。
- [ ] 每次 commit 前跑 `/deslop`，review 前跑 `/no-comments`。
- [ ] 按 `../references/bugbot-triage.md` 分诊每条 Bugbot 与安全审查评论。
- [ ] 在 code-ready 报告与看护之前 rebase 到当前 trunk。修复轮次保持该合并基。仅在合并准备时、`git merge-tree` 与 trunk 冲突时、CI 失败源于 trunk 变更时、或已知同文件并发变更落地时，才再次 rebase。

### Verdict and merge, for every PR（每个 PR 的裁决与合并）

- [ ] 完整 swarm 只跑一次，在 code-ready head 上。仅新行为、重设计或大 diff 才再跑一次完整 swarm。rebase、合并冲突解决或小修在新 head 上跑单个验证器；纯措辞变更不跑。按 `pstack/skills/swarm/SKILL.md` 跑每个完整 swarm。一条门禁泳道。PR **Verify, live** 块的十条 live 泳道。**Verify, perf** 块的 perf 泳道。两条以上审计泳道，各有侧重，读 diff 与回执且不信任 PR 正文。root 在裁决前审计 merge-ready 报告里的回执。
- [ ] 按执行剧本的阻塞规则评判每条发现。无阻塞即 clean。标记为"对 trunk 的回归泳道"里出现的 trunk 侧行为失败记在 trunk 头上，不阻塞 PR。新 head 要新裁决，但按 `playbooks/shipping.md` 的 patch-id 规则仍有效的结果除外。
- [ ] <执行剧本的合并或交接规则，带 `playbooks/shipping.md` 的 patch-id 规则。>

### Boot recipe, for every live lane（每条 live 泳道的启动配方）

每条 live 泳道在自己的云 VM 上跑 PR head。通过 `cursor-team-kit` 的 `control-ui` 或 `control-cli` 驱动。

- [ ] `git fetch origin <head-branch> && git checkout <head SHA>`。
- [ ] <启动后端与交互面。等待就绪。>
- [ ] <只通过 control 技能的命令投递输入。写明只读诊断手段。>
- [ ] 每张截图存到 `/tmp/swarm-<pr-id>/worker-<n>/<slug>.png`，随报告返回路径。

## <任务，动词短语>（<PR id>）

**Depends on.** <PR id，或 None。>

**Files.**

- [ ] 编辑 `<path>`。
- [ ] 创建 `<path>`。
- [ ] 删除 `<path>`。

**Build.**

- [ ] <一个变更。点名符号与文件。>

**You see.**

- [ ] <一个可观察结果，带精确日志行或屏幕状态。>

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] <测试文件与其新增用例。> 运行 `<command>`。

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. 按 boot 配方，在 PR head 上跑十条泳道（`<swarm workers 模型>`）。

- [ ] Lane 1. 对 trunk 的回归泳道。在 trunk 与 head 上跑<同一承重场景>。trunk 缺该功能则记录之，并约束<diff 新增的行为加上用户等待的终态>。保存 `<slug>.png`。通过条件：<谓词>。
- [ ] Lane 2. <场景。> 保存 `<slug>.png`。通过条件：<谓词>。
- [ ] Lane 3 至 Lane 10 同构：<场景> / 保存 `<slug>.png` / 通过条件：<谓词>。

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] 指标。<在 trunk 与 head 两端各测什么。trunk 缺该功能时，再写明 diff 新增的工作与用户可见的端到端状态。>
- [ ] 探针。<命令或过程，在 trunk 与 head 上交错运行。两侧都必须产出指标。>
- [ ] 基线。先记录 trunk 的 <值>。
- [ ] 规则。<head 对 trunk 的规则，带失败的数字。场景不等价时，为 diff 新增工作与用户可见终态设绝对预算，不设无效比值。>

**Review gate.** 操作者在合并前评审。

- [ ] 把泳道 <n> 的截图复制到 `<media path>/<pr-id>-review-<slug>.png`。
- [ ] 在泳道 VM 上录制该变更的 30 至 60 秒视频，存为 `<media path>/<pr-id>-review.mp4`。
- [ ] 在聊天里贴截图与视频。停在 merge-ready。等操作者点击。

**Merge.**

- [ ] root 在精确 head SHA 上的 clean 裁决。
- [ ] Bugbot 分诊完成。
- [ ] 裁决后 rebase 到当前 trunk，patch-id 不变。
- [ ] <负责人 squash 合并自己的 PR；或 root 把它追加进 base-branch 堆叠、由操作者自底向上落地。>

## Close the program（收尾工程）

- [ ] 上面每个格子都带着证据勾选。
- [ ] 按执行剧本点名的报告回复操作者。

## Appendix A. 原型证据

<每个被原型回答的开放问题，带分支、SHA 与制品链接。每个仍未被证明的问题。>

## Appendix B. 被否决的备选

<每个被权衡过的方案及其落败原因。>

## Appendix C. 风险

<每条风险及它落在哪个 PR、负责人盯什么。>

## Appendix D. 链接与阅读清单

<动笔前要读的文档。哪些 PR 会用到 `pstack/skills/how/SKILL.md` 与 `pstack/skills/interrogate/SKILL.md`。按 `pstack/skills/show-me-your-work/SKILL.md` 的轨迹。>
````

**回应：** 计划路径、各 PR id 及其依赖与评审门禁集合、原型证明了什么什么仍未证明、检查脚本输出。

---

> 本文覆盖 23 个剧本中的 11 个。其余见：[02 自主与编排](playbooks-02-autonomy.md)、[03 交付与维护](playbooks-03-delivery.md)。
