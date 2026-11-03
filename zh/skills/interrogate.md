# interrogate 全文翻译

> 翻译自 `skills/interrogate/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: interrogate
description: "用于 \"interrogate\"、\"adversarial review\"、\"multi-model review\"、\"challenge this\"、\"stress test this code\"、\"find blind spots\" 或 \"tear this apart\"。对抗者（adversary）试图打破一个变更或设计，只有被一次运行证明的 finding（审查发现）才能存活。"
disable-model-invocation: true
---
```

---

## Interrogate

对抗者试图打破一个变更或一个设计。finding（审查发现）只有被一次运行证明才算存活。报告这些 findings，不要动手修。

## 定框（Frame）

范围是用户点名的那个。没点名时，就是该分支相对其与基准分支（base branch）的 merge base 的 diff，包含工作树（working tree）。用 **in-your-own-words** 技能陈述意图，依据用户的消息、commit 与 PR 描述。意图不清楚时问用户。

## 扇出（Fan out）

跑 **arena** 技能的 Phase A 第 3、4 步与 Phase B，改四处：改读 `interrogate reviewers` 行，替代 `arena runners`；把范围的未提交变更复制进每个 worktree（Git 工作树）；每个对抗者作为 general-purpose 子智能体派生（Cursor 中为 `generalPurpose`）；不放 arena 的任务与 rationale，改给每个对抗者范围、意图与这份任务简报：

> 打破这个变更。每个 finding 都用对真实代码的一次运行来证明，比如一个失败的测试、一个 repro（复现）脚本、或显示错误行为的命令输出。对设计或方案，跑一个原型（prototype）或在当前树上探查。repro 留在你自己的 worktree 里。每个 finding 报告四件事：标题、确切命令、它打印的输出、以及意图所要求的输出。没跑过的东西一律不报。这包括风格、命名、结构，以及要靠未来变更才成立的风险。没有 findings 也是一个合法结果。

## 验证（Verify）

按 arena 的 Phase F 验证每个 finding：重跑它的命令。输出显示失败、且失败破坏意图时，保留该 finding。其余丢掉。共享同一根因的 findings 合并。

跳过 arena 的 Phase C、D、E。各对抗者找到的失败不同，所以裁决保留每一个已验证的 finding，而不是某一个对抗者的清单。

## 输出（Output）

- **Intent（意图）**：那段复述。
- **Findings**：每个已验证的 finding 给出命令、其输出、它如何破坏意图、以及发现它的对抗者。一个都没活下来时写 "no verified findings"。
- **Dropped（丢弃）**：每个对抗者被丢弃的 finding 数量及原因。
