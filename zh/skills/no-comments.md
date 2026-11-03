> 翻译自 `skills/no-comments/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

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
