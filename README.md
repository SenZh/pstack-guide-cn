# pstack 中文落地指南

面向人类读者的 pstack 原理讲解与落地手册。**这不是 pstack 的可安装技能包**，Agent 读的仍是上游英文原文。

pstack 的英文文档默认你有一个可本地启动并可写入的应用、GitHub 与 `gh` CLI、以及多家云模型。这三样在受限环境里常同时缺失，缺了之后技能不会报错，只会产出格式完整、内容空转的成果。本仓库逐条说明哪些条款能直接用、哪些要替换、哪些必须删。

本仓库所有内容与具体语言、框架、云厂商、公司无关，只讲方法。文中出现的配置与表格都是占位形式，需按你自己环境填入真实值。

## 目录

| 文件 | 内容 |
|---|---|
| [docs/00 版本基线与引用规范](docs/00-版本基线与引用规范.md) | 引用对应哪个上游 commit，漂移怎么检测 |
| [docs/01 原理与设计立场](docs/01-原理与设计立场.md) | 三层结构、三个有效机制、三项代价、使用分级 |
| [docs/02 24 条工程原则](docs/02-24条工程原则.md) | 每条原则的适用时机、原意与落地要点 |
| [docs/03 OpenCode 与跨宿主适配](docs/03-OpenCode与跨宿主适配.md) | subagent、模型、transcript、技能目录的映射与两处坑 |
| [docs/04 受限环境落地方案](docs/04-受限环境落地方案.md) | 无本地应用、只有远程环境时怎么落地 |
| [docs/05 失效与误导条款清单](docs/05-失效与误导条款清单.md) | 哪些直译会错，哪些是宿主专有必须删 |
| [docs/06 术语表与翻译取舍](docs/06-术语表与翻译取舍.md) | 保留英文的理由与最易混淆的术语对照 |

同步流程见 [SYNC.md](SYNC.md)。

## 上游

| 项 | 位置 |
|---|---|
| 作者 | [poteto](https://github.com/backnotprop) |
| 原始插件 | [cursor/plugins/tree/main/pstack](https://github.com/cursor/plugins/tree/main/pstack) |
| 独立镜像（MIT） | [backnotprop/pstack](https://github.com/backnotprop/pstack) |
| 安装 | `npx skills add backnotprop/pstack` |

本仓库为原创中文评述，不复制上游正文，仅短引并标注源文件与行号。基线与引用规则见 docs/00。

## 阅读顺序

第一次接触：先读 01 再读 02。这两篇与语言、平台、模型无关，是 pstack 里可迁移价值最高的部分。

准备在真实项目启用：直接读 04 和 05。

## 门禁

```powershell
pwsh ./scripts/sync-check.ps1   # 引用是否仍对得上上游
pwsh ./scripts/slug-lint.ps1    # 标识符是否被汉化
```

两条都在 CI 里跑，失败自动开 issue。

## 许可

原创中文内容以 MIT 发布，见 [LICENSE](LICENSE)。与上游的关系、引用范围、致谢见 [NOTICE.md](NOTICE.md)。
