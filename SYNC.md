# 上游同步流程

本仓库为原创中文评述，不复制上游正文。但正文里有大量 `(文件:行号)` 引用，这些引用绑定在一个固定的上游 commit 上。上游是活跃仓库，引用会漂移。

## 当前基线

| 项 | 值 |
|---|---|
| 上游 | `backnotprop/pstack` @ `main` |
| 基线 commit | `6c75f4e67546c2ddbf9634734c1e3ebbea34861a` |
| 采集时间 | 2026-11-02T15:17:23Z |
| poteto-mode blob sha | `53ecd5094538c52a855c09368390005a9405a70a` |

## 检测

```powershell
pwsh ./scripts/sync-check.ps1
```

退出码 0 表示引用仍然有效，1 表示已漂移。

CI 每周一自动跑一次，失败时开 issue。也可手工触发 `workflow_dispatch`。

## 处理

漂移后不是所有变更都需要重写。分三种情况。

### 情况一：仅措辞微调

manifest 变了但结构没变，行号位移在几行之内。处理方式：

1. 拉取上游 diff 确认改动内容。
2. 核对本仓库所有指向该文件的引用行号，逐个修正。
3. 更新 `scripts/sync-check.ps1` 里的 `$baselinePotetoModeBlob`。
4. commit message 写清"sync: 上游 <sha>，仅行号位移"。

### 情况二：新增或删除条目

例如新增一条 principle、新增一个 playbook、删除某个已废弃技能。处理方式：

1. 更新 [docs/02-24条工程原则.md](docs/02-24条工程原则.md) 的条目数与该条内容。
2. 若影响 `poteto-mode` 的索引，同步更新 [docs/01-原理与设计立场.md](docs/01-原理与设计立场.md) 的层级描述。
3. README 里的数字（如"24 条原则"）一并改。
4. 更新基线。

### 情况三：寻址规则或机制变化

最需要警惕的一类。例如 kebab case 转换规则改了、模型家族判定逻辑改了、`subagent` 默认值改了。处理方式：

1. 重读相关章节，判断本仓库的结论是否还成立。
2. 若本仓库的"失效条款"判断已不成立（上游修了），从 [docs/05-失效与误导条款清单.md](docs/05-失效与误导条款清单.md) 删除该条并在 commit message 说明。
3. 若新增了失效条款，补进去。
4. 更新基线。

## 为什么不做全量镜像翻译

这个决定值得记录，因为它是本仓库最核心的取舍。

上游 `skills/*.md` 合计 442 KB、61 个 `SKILL.md`。全量镜像翻译会引入三个结构性风险：

1. **寻址断裂**。`poteto-mode/SKILL.md:41` 规定按 `principle-<title>` 的 kebab case 构造叶子技能路径。目录名或 `name` 字段一旦汉化，路径解析失败，技能运行中途静默丢失引用。
2. **英文写作规则误导**。`poteto-mode/SKILL.md:120-122` 的短句、破折号、冒号禁令针对英文。直译会让中文读者按错误规范写作。
3. **漂移维护成本落在一个人身上**。上游活跃迭代且 MIT 不提供支持义务。发布的译本过期后，issue 会打到镜像仓而非上游。

因此本仓库选择：只写原创中文评述，引用短片段并标注源文件与行号，不做可安装的技能包。

## 标识符门禁

```powershell
pwsh ./scripts/slug-lint.ps1
```

检查正文里的功能标识符（`SKILL.md` 路径、`principle-*`、`playbooks/*.md`、`pstack-models.md`）是否被汉化。任何含中文字符的标识符都会报错。

CI 与 drift check 一起跑。这是 `principle-encode-lessons-in-structure` 的应用：把"不要汉化标识符"从文字提醒变成机械拦截。

该门禁本身已按 `Able to fail` 原则验证过——注入 `principle-懒惰协议` 与 `playbooks/缺陷修复.md` 后确实报错退出 1。
