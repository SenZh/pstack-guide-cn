# pstack 中文全译本

pstack 的完整中文翻译，**仅供人阅读**。Agent 执行时读英文原文——技能的运行时寻址、跨技能引用全部依赖英文文件名，汉化会破坏功能（详见 [zh/GLOSSARY.md](zh/GLOSSARY.md) 的翻译取舍）。

## 上游与出处

| 项 | 位置 |
|---|---|
| 作者 | [poteto](https://github.com/backnotprop) |
| 原始插件 | [cursor/plugins/tree/main/pstack](https://github.com/cursor/plugins/tree/main/pstack) |
| 独立镜像（MIT） | [backnotprop/pstack](https://github.com/backnotprop/pstack) |
| 安装 | `npx skills add backnotprop/pstack` |

本仓库不复制上游英文文件，只有译文与术语基准。与上游的关系、引用范围见 [NOTICE.md](NOTICE.md)。上游是活跃仓库，译文基于基线 commit `6c75f4e`（2026-11-02），漂移检测见 [SYNC.md](SYNC.md)。

## 覆盖范围

**上游全部 172 个 Markdown 文档中的 170 个**已翻译（约 44 万字节译文），唯二未译：上游 `MIRROR.md` 的英文操作细节（已在 guide-4 摘译）与 `SYNC-LOG.md`（空日志）。

| 区域 | 文件 | 内容 |
|---|---|---|
| 术语基准 | [zh/GLOSSARY.md](zh/GLOSSARY.md) | 翻译宪法：绝不翻译清单、标准译法表、语气规则 |
| 总控 | [zh/skills/poteto-mode.md](zh/skills/poteto-mode.md) | 25KB 主文件全文：不可协商项、原则索引、自主权、子智能体、宿主适配、写作规范、剧本目录 |
| 24 条原则 | [zh/skills/principles.md](zh/skills/principles.md) | Core/Architecture/Verification/Delegation/Meta 全文 |
| 23 个剧本 | [zh/docs/playbooks-01-task.md](zh/docs/playbooks-01-task.md) · [02-autonomy](zh/docs/playbooks-02-autonomy.md) · [03-delivery](zh/docs/playbooks-03-delivery.md) | bug-fix、perf、hillclimb、取证、调查、原型、视觉一致、重构、feature、多阶段计划、自主长跑、编排、autopilot、看护、接手、暂停、清理、开 PR、交付 |
| 24 个技能 | [zh/skills/](zh/skills/) 每技能一文件 | arena、swarm、interrogate、architect、how、why、blast-radius、statechart、recall、ketchup、ketchup-video、teach、create/maintain-verification、create/maintain-formal-verification、benchmark-checklist、figure-it-out、automate-me、reflect、correct、setup-pstack、poteto-help、make-bot-ui |
| 工作流技能 | [zh/docs/playbooks-03-delivery.md](zh/docs/playbooks-03-delivery.md) 后半 | show-me-your-work、no-comments、unslop、technical-writing、tdd、typescript-best-practices、bro、in-your-own-words、sharpen |
| 上游 README | [zh/skills/README.md](zh/skills/README.md) | 37.7KB 全文，含三个大表（剧本 23 行、技能 34 行、原则 24 行） |
| 指南 10 篇 | [zh/docs/guide-1.md](zh/docs/guide-1.md) ~ [guide-4.md](zh/docs/guide-4.md) | 安装、路由、理解、设计、构建、验证交付、通宵、原则转向、个人化、配方与坑、Claude Code 适配、镜像说明 |
| 子智能体 | [zh/agents/subagents.md](zh/agents/subagents.md) | poteto-agent 与 Comment Sicko 的 system prompt 全文 |

## 阅读路径建议

- **只想要 pstack 的思想**：读 [poteto-mode.md](zh/skills/poteto-mode.md) 的原则一节 + [principles.md](zh/skills/principles.md)。33KB，与语言、平台、模型无关。
- **准备实际启用**：guide-1 → guide-2 → [setup-pstack.md](zh/skills/setup-pstack.md)，然后对照 [GLOSSARY](zh/GLOSSARY.md) 读你用得到的技能原文。
- **翻译质量争议**：一律以 [GLOSSARY.md](zh/GLOSSARY.md) 为准；GLOSSARY 未覆盖的以英文原文为准。

## 质量门禁

```powershell
pwsh ./scripts/sync-check.ps1   # 上游漂移检测：译文基线 vs 上游 blob sha
pwsh ./scripts/slug-lint.ps1    # 标识符门禁：功能标识符被汉化即报错
```

两条都进 CI（每周一 + 手动触发），失败自动开 issue。slug-lint 自身按上游 `Able to fail` 原则验证过：注入汉化的 principle 标识符确实报错退出 1。

## 许可

译文与原创内容 MIT，见 [LICENSE](LICENSE)。上游 pstack 由 poteto 以 MIT 发布，归其所有；出处与引用范围见 [NOTICE.md](NOTICE.md)。
