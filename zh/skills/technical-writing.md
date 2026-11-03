> 翻译自 `skills/technical-writing/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

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
