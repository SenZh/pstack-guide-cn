# setup-pstack 全文翻译

> 翻译自 `skills/setup-pstack/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: setup-pstack
description: Configure which models pstack uses per role and at what reasoning budget. Detects your available models and writes an always-applied rule that overrides the skill defaults. Use for /setup-pstack, "configure pstack models", "pstack budget", or changing pstack's model choices.
---
```

---

# Setup pstack

写 pstack 的模型设置（settings file），每个角色（role）一个模型：

- **Cursor：** `~/.cursor/rules/pstack-models.mdc`，一条总是生效的规则。
- **Claude Code：** `~/.claude/rules/pstack-models.md`。Claude Code 会把 `~/.claude/rules/` 里的每个文件加载进每个新会话。
- **其余所有宿主环境**（Codex、Pi、OpenCode 及其他）：`~/.agents/pstack-models.md`。这些宿主环境不会自行加载它，所以 pstack 技能挑模型时读这个文件。

下文的"配置文件"指适用于你的宿主环境的那一份。Claude Code 里那份缺失的话，改读 `~/.agents/pstack-models.md`，本技能的旧版本写在那里。

## 步骤（Steps）

### 1. 探测可用模型

枚举本会话里你能传给子智能体（subagent）的模型 slug（Cursor 的 `Task`、Claude Code 的 `Agent`、OpenCode 的 `task`、Codex 的 `spawn_agent`）。这是可靠来源。你的宿主环境还有列出用户模型的命令的话，为求完整优先用它（如 `opencode models` 或 `pi --list-models`）。一个都探测不到的话，请用户粘贴他们可用的 slug。绝不写入一个你未确认可用的真实 slug。别名 `inherit-parent` 与 `auto` 永远有效，即使它们不是探测到的 slug。

### 2. 读取当前状态

默认的角色到模型映射是第 5 步所示的那份规则形状。配置文件已存在的话，读它，把它的 `# budget` 行与各角色值当作当前选择。否则从那些默认值起步。某个行的角色不在第 5 步里（如 `how critics`），说明来自已退役的角色。丢弃它。

### 3. 预算、映射并确认

**(a) 询问预算（budget）。** 优先用你的结构化提问工具（Cursor 的 `AskQuestion`、Claude Code 的 `AskUserQuestion`、OpenCode 的 `question`），不用自由文本。给出下面四个选项，标签一字不差，规则里记有当前预算时一并报出。没有规则时，说明 `large` 与技能默认值一致。

- `unlimited — max reasoning`
- `large — xhigh reasoning`
- `medium — high reasoning`
- `small — medium reasoning`

**(b) 应用它。** 从技能默认值构建工作表；重跑时，凡是按家族、清单或别名（`inherit-parent`、`auto`）改过的角色一律保留。`unlimited`、`large`、`medium`、`small` 把每个真实 slug（panel 条目在内）的 effort token 设为 `max`、`xhigh`、`high` 或 `medium`。effort token 是最后一个 token，或尾缀 `fast` 之前的那个，所在阶梯为 `max` > `xhigh` > `high` > `medium` > `low`。结果不是探测到的 slug，就用同家族探测到的、effort 不高于目标值的最高者，否则把该角色标记为需要选择。`inherit-parent` 与 `auto` 不变。所以 `unlimited` 把 `claude-opus-5-5-xhigh` 变成 `claude-opus-5-5-max`。Grok slug 封顶 `xhigh`，所以 `unlimited` 下回退把 Grok 放在 `xhigh`，`grok-4.7-xhigh-fast` 原样保留。`large` 两个默认值都保留。`small` 把它们变成 `claude-opus-5-5-medium` 与 `grok-4.7-medium-fast`。

**(c) 展示各角色并确认。** 展示每个角色及其模型，凡不在探测集合里的真实 slug 都标记为需要选择。同时列出第 2 步丢弃的每一行。问是按现状接受还是改具体角色，选项给探测到的模型加 `inherit-parent` 与 `auto`（两者含义都是：该角色跑在父级聊天模型上，Auto 用户正是这样留在 Auto）。优先用结构化提问工具，不用自由文本。panel 角色（arena runners、architect runners、interrogate reviewers）的值是一个清单，每个条目跑一个子智能体，别名条目也计入，所以清单长度决定数量。`arena cross-judge pool` 也是清单，但 Arena 只跑一个裁判。它只尝试与父级家族不同的值，按清单顺序，所以按偏好排序。`inherit-parent` 或 `auto` 的值永远不当裁判。`swarm workers` 是每个 worker 的默认模型，除非某次竞速（race）或对比按 arm 指派了别的模型。

### 4. 校验

写入的每个真实 slug 必须在探测集合里。`inherit-parent` 与 `auto` 永远通过。选中的真实 slug 不可用的话，停下重新询问。

### 5. 写入规则

写配置文件，带一行 `# budget`（含所选标签及其目标 effort），每个角色一行，标签与 poteto-mode 用的一致。Cursor 里要带上下面的 frontmatter（`alwaysApply: true`）。其他宿主环境写配置文件不带 frontmatter（从第一个 `#` 行开始）。整文件覆写，让重跑保持幂等。形状：

```
---
description: pstack per-role model choices (overrides skill defaults)
alwaysApply: true
---
# pstack model configuration. One line per role. Delete a line to fall back to the skill default.
# `inherit-parent` or `auto` as a value: the role runs on the parent chat model (omit the subagent `model`). Alias entries in a panel list still count toward its fan-out.
# budget: large (xhigh)
feature, refactoring: grok-4.7-xhigh-fast
bug-fix: grok-4.7-xhigh-fast
perf-issue: grok-4.7-xhigh-fast
hillclimb: grok-4.7-xhigh-fast
judgment and prose: claude-opus-5-5-xhigh
hardest tasks: claude-opus-5-5-xhigh
how explorer: grok-4.7-xhigh-fast
how explainer: claude-opus-5-5-xhigh
why investigators: grok-4.7-xhigh-fast
why synthesizer: claude-opus-5-5-xhigh
reflect tooling: grok-4.7-xhigh-fast
reflect judgment, divergent, synthesizer: claude-opus-5-5-xhigh
arena runners: claude-opus-5-5-xhigh, grok-4.7-xhigh-fast
arena cross-judge pool: claude-opus-5-5-xhigh, grok-4.7-xhigh-fast
swarm workers: grok-4.7-xhigh-fast
architect runners: claude-opus-5-5-xhigh, grok-4.7-xhigh-fast
interrogate reviewers: claude-opus-5-5-xhigh, grok-4.7-xhigh-fast
```

### 6. 确认

告诉用户写入了哪个文件。Cursor 与 Claude Code 里，它对新会话生效。其他宿主环境里，pstack 技能挑模型时读 `~/.agents/pstack-models.md`。重跑本技能会更新它。

### 7. 推荐一个验证技能（可选）

检查项目是否已有驱动真实应用拿证明的手段（某个 `verify-*` 技能，或既有宿主）。没有的话，只推荐一次："want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill."（要一个项目本地验证技能吗？让 agent 能像用户一样驱动应用、证明改动有效。我可以用 /create-verification-skill 生成一个。）同意则调用 `/create-verification-skill`（无论 pstack 装在工作区、用户级还是插件都能解析）。拒绝则继续推进，不再纠缠。

### 8. 推荐一个形式化验证技能（可选）

检查项目是否已有形式化验证技能（对代码跑模型检验器、证明器或其他验证器的项目技能）。没有的话，只推荐一次："want a formal verification skill, so agents can prove a key property of your code holds in every case in scope, not only the cases tests reach? I can generate one with /create-formal-verification-skill."（要一个形式化验证技能吗？让 agent 能证明代码的关键性质在范围内每个用例都成立，而不只是测试够得着的那些。我可以用 /create-formal-verification-skill 生成一个。）同意则调用 `/create-formal-verification-skill`（无论 pstack 装在工作区、用户级还是插件都能解析）。拒绝则继续推进，不再纠缠。
