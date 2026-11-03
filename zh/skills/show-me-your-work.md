> 翻译自 `skills/show-me-your-work/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

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
