# statechart 全文翻译

> 翻译自 `skills/statechart/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: statechart
description: "检查一个在状态之间迁移的系统的 TLA+ 模型——例如一个产品流程、一个协议或一个服务——并把它画成 Mermaid statechart。报告给出通往每个违反规则的状态的最短路径。用于 /statechart，或把一个 bug 显示为一条穿越状态的路径。"
disable-model-invocation: true
---
```

---

# Statechart

图展示系统如何在状态之间迁移，用词取自读图的那个人。那个人——读者——来判断行为是否正确。

## 运行（Run）

在一个仓库之外的临时目录里工作。写一个 TLA+ spec 及其 config。然后运行：

```sh
<skill dir>/scripts/statechart SPEC.tla [--config FILE] [--view FILE] [--out DIR]
```

`scripts/statechart.ts` 是 TypeScript，所以要用一个能执行 TypeScript 的运行时来跑它。

第一次运行会经 mise 安装 TLC 与 Java，需要网络。

## 写 spec（Write the spec）

- 把读者认可的每条规则写成一个 INVARIANT。一条规则可以关于一个屏幕、一个结果、一个存储值或一条消息。模型没有某条规则对应的变量时，就加那个变量。绝不要为了规则成立而削弱规则。
- 把 `Next` 写成各 action 的析取，例如 `YouPressPlay \/ YouPressStop`。不这样做的话，TLC 会把每一步都命名为 `Next`。
- 没有出步的状态会破坏 `NoDeadlock`，即使它是一个正确的终态。当某个 INVARIANT 或 PROPERTY 已经占用这个名字时，规则改用 `CHECK_DEADLOCK`。往 `Next` 里加一个仅在终态为真且不改变任何东西的 action，例如 `Done == phase \in {"paid", "failed"} /\ UNCHANGED vars`，并在 `step()` 里给它一个标签。

## 挑选图（Pick the chart）

需要判断力的活由你来做：每个状态与箭头上的用词、各阶段（phase）及其颜色、标题，以及给读者的报告。把你的工作放进一个 view 模块，用 `--view` 交给命令。

要呈现读者的话语，view 导出 `state(vars)`。`state()` 返回的值决定形式：

- 字符串给出扁平图：`export const state = (v) => (v.paid ? "Paid" : "Paying");`
- 数组给出父状态：`export const state = (v) => v.main.split(".");`
- 对象为每个键给出一个并行 region：`export const state = (v) => ({ Playback: v.playback, Volume: v.volume });`

给每个状态的标签写读者看得见或在乎的东西，例如"Paying"或"Lease held, write pending"。标签里不要出现变量名。在 `vars` 里，TLA+ sequence 是键从 1 开始的对象，所以 `v.pc[1]` 就是 `pc[1]`。set 是数组。

view 还可以导出 `step(action, from, to)`。它拿到 TLC action 名与这一步前后各自的值，返回箭头的标签。每条 step 标签按用户看到它发生的样子来写，例如"you press play"或"the connect fails"。不要点名代码或 TLA+ action。两个在图上终点相同的 action 用同一条标签，从而共用一根箭头。

当一步只能在某些条件下发生时，在标签末尾用方括号附上条件，用读者的话，例如 `you press play [while the file loads]`。region 图里，命令会把条件写在箭头上其他 region 的位置，措辞取它们各自标签的话，例如 `[when Offline]`。你的方括号会把它替换掉，于是一个状态发出的两根箭头可能看起来一样。所以在 region 图里，不要替另一个 region 上的条件写方括号。当某个没有任何标签显示的值决定了一步的去向时，在标签里点名结果，例如"the roster read fails"。

view 还可以导出这些：

- `group(vars)` 返回一个阶段（phase）的名字。每个图状态得到它所属 group 的颜色。一个图状态背后的模型状态分属不同 group 时，该状态不着色。
- `colors` 给每个 group 名配一个颜色 class。
- `title` 是一个字符串，图把它显示在顶部。

命令对每个模型状态至多调用一次 `state()` 与 `group()`，对每一步至多调用一次 `step()`。图与报告都用这些答案。所以让每个函数只依赖自己的参数。

图不画停留在同一标签之内的 step。读者必须看到这种 step 时，就把标签拆开。

瞄准约 20 根箭头以内，因为更满的图难读。先让 `state()` 返回更粗的标签。行为相同的值共用一个标签，略去读者不需要的细节，例如一个在途调用、其返回值不改变任何东西。保留 bug 路径上的每个状态，保留每个标记。一次 merge 把某个 `breaks` 状态变成 `mayBreak`，就会掩盖规则在哪里被破坏。不要合并破坏不同规则的两个状态，否则读者无法看出哪条规则在哪里被破坏。图仍然太满时，对读者不需要的 step 从 `step()` 返回 `null`，例如每个状态都有的 reset，或一根箭头重复其他箭头所示内容的 step。隐藏 step 时遵守这些规则：

- 保持每个图状态都能从起始状态经箭头到达。
- 模型里有出步的每个图状态，至少保留一根出箭头。
- 一根箭头的各步要么全隐藏，要么全不藏。只藏一部分时，它的条件会变窄。
- 在交接里说明图隐藏了哪些 step。

## 读报告（Read the report）

- 图里，破坏规则的状态带 `breaks` class。它背后只有部分模型状态破坏该规则时，带 `mayBreak` class。图例（Legend）会点名每个标记对应的规则。两条规则同时被破坏时，它把两条都写进同一个标记，所以要在交接里说明哪个状态破坏哪条规则。region 图里，当一个状态所属的每个 region 状态组合都能破坏某条规则时，该状态得到标记。一个组合能破坏规则而其中任何状态都没有标记时，该组合里每个状态都得到标记。
- TLC 会越过破坏规则的状态继续走，所以图会显示 bug 之后的状态。
- 因为 TLC 会越过 bug 继续走，一个状态数没有上限的模型可能永远跑不完。把常量取小，或加一个 CONSTRAINT。
- 有 VIEW 或 SYMMETRY 时，TLC 把它视为相同的多个状态算作一个状态，图也只画那一个状态。箭头可能通向它，而不是通向该步真正到达的状态，报告会说明这一点。
- TLC 会检查每个越过 CONSTRAINT 或 ACTION_CONSTRAINT 的状态的规则，但不探索那个状态、也不对它做死锁检查。当 TLC 为某条规则找到的最短路径终结于这样的状态时，图会画出该状态，报告给出该路径。图不画越过该界限之后的其他状态。这种状态里的死锁不会显示。ACTION_CONSTRAINT 排除的每一步之后，TLC 同样会检查规则，即使下一步也可以经另一条路到达。当 TLC 为某条规则找到的最短路径终结于这样一步时，图会画出这一步。
- 命令按 config 原样用 TLC 检查规则，单 worker。某条规则被破坏时，命令移除该规则再跑一次 TLC，直到没有规则被破坏。第一次破坏之后，每轮跑到 100,000 个不同状态就停，以免大模型跑不完。某轮到达该界限或因错误停止时，报告在 "Rules not checked" 之下列出它没有检查的规则，图也不给它们打标记。未检查的规则可能成立也可能被破坏。要检查它，就把被破坏的规则从 config 里移除，或把模型变小。该界限会附加一个模块、改变 TLC 对变量的排序，因此对一个 property，TLC 可能找到与无界限运行不同的反例（counterexample）。
- `tlc.out` 是 TLC 按 config 原样运行时打印的内容。当图没有显示某条被破坏规则的 bug 路径时，`tlc-RULE.out` 是找到它的那一轮 TLC 打印的内容。当 TLC 重复它的第一条警告时，直接跑 TLC 会把它打印两遍，但 `tlc.out` 只显示一遍，因为 TLC 会把第二份从这个命令读取的输出中省掉。这只发生在 Java 带 `-XX:+UseParallelGC` 运行时；否则 TLC 的第一条警告是它建议传该 flag 的提示，只打印一次。

## 展示图（Show the chart）

把 `chart.mmd` 以 `mermaid` 代码块展示给用户。图的预算是 500 个状态，按 config 原样由 TLC 计数。超过预算，图只画通往被破坏规则的路径；没有任何规则被破坏时，命令不写 `chart.mmd`。它仍会检查每条规则，报告给出状态数与每条 bug 路径。想看整张图，就把模型变小。

用 Pele 渲染图。用户要图片、或图大到按文本读不了时，遵循 `references/render.md`。用户没有点名就不要换别的渲染器。

## 交接（Hand off）

把每张图及其 Mermaid 文本交给必须做判断的人。每个 bug 加一行：规则、该规则对应的读者语句，以及按报告编号的路径。说明模型省略了什么。给出能再次生成这些文件的命令，`--out` 用一个新目录。

模型描述的是代码时，把每条 bug 路径对照真实代码重放一遍，作为测试或现场复现（repro），每个 action 走一步。某个 bug 没有出现时，先认为模型错了，直到你证明它没错。
