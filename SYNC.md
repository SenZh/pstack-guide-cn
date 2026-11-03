# 上游同步流程

本仓库是 pstack 的完整中文译本，不复制上游英文文件。译文中的行号引用与结构描述绑定在一个固定的上游 commit 上。上游是活跃仓库，会漂移。

## 当前基线

| 项 | 值 |
|---|---|
| 上游 | `backnotprop/pstack` @ `main` |
| 基线 commit | `6c75f4e67546c2ddbf9634734c1e3ebbea34861a` |
| 采集时间 | 2026-11-02T15:17:23Z |
| poteto-mode blob sha | `53ecd5094538c52a855c09368390005a9405a70a` |
| 基线时规模 | 172 个 Markdown 文档，`skills/*.md` 合计 442 KB |

## 检测

```powershell
pwsh ./scripts/sync-check.ps1
```

退出码 0 表示引用仍然有效，1 表示已漂移。

CI 每周一自动跑一次，失败时开 issue。也可手工触发 `workflow_dispatch`。

## 处理

漂移后不是所有变更都需要重译。分三种情况。

### 情况一：仅措辞微调

manifest 变了但结构没变，行号位移在几行之内。处理：

1. 拉取上游 diff 确认改动内容。
2. 核对 `zh/skills/poteto-mode.md` 与 `zh/docs/playbooks-0*.md` 里所有指向该文件的行号引用，逐个修正。
3. 更新 `scripts/sync-check.ps1` 里的 `$baselinePotetoModeBlob`。
4. commit message 写"sync: 上游 <sha>，仅行号位移"。

### 情况二：新增或删除条目

例如新增一条 principle、新增一个 playbook、删除某个已废弃技能。处理：

1. 更新 `zh/skills/principles.md` 的条目数与对应条目。
2. 若影响 `poteto-mode` 的索引，同步更新 `zh/skills/poteto-mode.md`。
3. 更新 `README.md` 的覆盖范围数字（如"24 条原则"）。
4. 对应技能在 `zh/skills/` 下增删译文文件。
5. 更新基线。

### 情况三：寻址规则或机制变化

最需警惕。例如 kebab case 转换规则改了、模型家族判定逻辑改了、`subagent` 默认值改了。处理：

1. 重读相关章节，判断译文结论是否还成立。
2. 若上游修好了某个已知缺陷，从对应译文里删去相关译注。
3. 若新增了陷阱，补进译文。
4. 更新基线。

## 标识符门禁

```powershell
pwsh ./scripts/slug-lint.ps1
```

检查译文里的功能标识符（`SKILL.md` 路径、`principle-*`、`playbooks/*.md`、`pstack-models.md`）是否被汉化。任何含中文字符的标识符都会报错。

CI 与 drift check 一起跑。这是上游 `Encode Lessons in Structure` 原则的应用：把"不要汉化标识符"从文字提醒变成机械拦截。

该门禁本身已按上游 `Able to fail` 原则验证过：注入一个汉化的 principle 标识符后确实报错退出 1。

## 为什么必须保留英文标识符

上游 `poteto-mode/SKILL.md:41` 规定，叶子技能按 `principle-<title>` 的 kebab case 构造路径寻址。目录名或 frontmatter 的 `name` 字段一旦汉化，路径解析失败，技能会在运行中途静默丢失引用，不报错，只是失效。

同理，各技能之间按 `../<name>/SKILL.md` 相对路径互相引用，playbook 按 `playbooks/<title>.md` 寻址。因此译文中的所有标识符、路径、模型 slug、参数名一律保持英文原文。
