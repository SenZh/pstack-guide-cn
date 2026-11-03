# 术语对照表（翻译基准）

全文翻译必须遵守本表。改动本表需同步检查全部译文。

## 一、绝不翻译（功能标识符）

| 保留原文 | 理由 |
|---|---|
| 模型 slug（`grok-4.7-xhigh-fast` 等） | 传给 subagent 工具的标识符 |
| 技能目录名与 `name:` 字段（`poteto-mode`、`principle-*`） | 运行时寻址键 |
| playbook 文件名（`playbooks/bug-fix.md`） | kebab case 路径寻址 |
| 参数名（`subagent_type`、`run_in_background`、`effort`） | API 参数 |
| 路径（`.agents/skills/`、`~/.agents/pstack-models.md`） | 文件系统路径 |
| 工具名（`Task`、`AskQuestion`、`gh`、`grep`） | 实际工具 |

## 二、保留英文并加中文注释（首现时）

| 术语 | 注释 | 适用 |
|---|---|---|
| playbook | 步骤剧本，poteto-mode 内部步骤清单，无斜杠命令 | 全文 |
| skill | 技能，可独立调用的单元 | 全文 |
| subagent | 子智能体 | 全文 |
| fan-out | 一对多并发派发 | 全文 |
| worktree | Git 工作树 | 全文 |
| finding | 审查发现 | interrogate 相关 |
| repro | 复现 | bug-fix 相关 |
| slop | AI 生成的低质冗余内容 | unslop 相关 |
| pipeline | 数据管道 | 分析场景 |
| selector | 选择器 | UI 驱动场景 |

## 三、标准译法（同词必须同译）

| 英文 | 译法 | 禁用 |
|---|---|---|
| skill folder | 技能目录 | 技能文件夹 |
| settings file | 配置文件 | 设置文件 |
| reasoning budget | 推理预算 | 思考预算 |
| reasoning level | 推理档位 | 推理等级 |
| effort | 推理力度（仅当指模型档位参数时保留原文） | 努力值 |
| verification | 验证 | 核验 |
| formal verification | 形式化验证 | — |
| invariant | 不变式 | 不变量（数学语境除外） |
| model checker | 模型检验器 | 模型检查器 |
| feature map | 功能地图 | 特性映射 |
| harness | 宿主环境 | 马具 |
| blast radius | 爆炸半径 | — |
| adversarial | 对抗性的 | — |
| grounded | 有依据的 | 基于地面的 |
| scaffold | 脚手架 | — |
| gate | 门禁 | 关卡 |
| guard | 守卫 | 护栏 |
| surface | 交互面 | 表面 |
| drive | 驱动（动词，指操作被测应用） | 驾驶 |
| evidence | 证据 | 证明 |
| artifact | 制品 | 人工制品 |
| delegate | 委派 | 委托 |
| brief | 任务简报 | 摘要 |
| transcript | 会话记录 | 转录 |
| checkpoint | 检查点 | 检查站 |
| counterexample | 反例 | — |
| counterexample trace | 反例路径 | — |
| one-way door | 单向门 | 不可逆决策 |
| bakeoff | 同题竞标 | — |
| graft | 嫁接 | 移植 |
| race | 竞速 | 种族 |
| gauntlet | 连环考验 | 手套 |
| sicko | （Comment Sicko 保留不译） | — |
| babysit | 看护 | 保姆 |
| land | 落地（指合并 PR） | 着陆 |
| stack | 堆叠（指 PR 堆叠） | 栈 |
| overnight | 通宵（指夜间无人值守运行） | 隔夜 |
| drift | 漂移 | 偏移 |
| findings stay findings | 发现就是发现（不得弱化） | — |

## 四、标题与专名处理

- 章节标题（`# Poteto mode` 等）保留英文原题，正文标题可译。
- `## Non-negotiables` → `## 不可协商项`
- `## Principles` → `## 原则`
- `## Autonomy` → `## 自主权`
- `## Subagents` → `## 子智能体`
- `## Harness` → `## 宿主环境适配`
- `## Writing the reply` → `## 回应的写法`
- `## Comments` → `## 注释`
- `## Playbooks` → `## 工程剧本`
- 原则名（如 `Laziness Protocol`）保留英文 + 首现中文注释。

## 五、语气与标点

1. 译句以中文表达习惯断句，不逐词对应，但**不得丢失、合并、弱化任何条款**。
2. 原文的禁令、门禁、例外条款一条不落。
3. 原文的括号补充内容照译，用中文括号。
4. 代码块、命令、路径、模型名保持原样。
5. 引用原文行号时写法为：`（SKILL.md:96）`。
6. 原文的粗体强调在译文中保留粗体。
7. 原文的"you"译为"你"，"your harness"译为"你的宿主环境"。
8. 原文的"the human"译为"人类"，"the user"译为"用户"，"operator"译为"操作者"。
