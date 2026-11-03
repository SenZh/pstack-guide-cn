# create-verification-skill 全文翻译

> 翻译自 `skills/create-verification-skill/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## YAML Frontmatter

```yaml
---
name: create-verification-skill
description: "生成一个项目本地的验证技能，用用户的方式驱动你的应用——不限语言、框架或平台。用于 /create-verification-skill、\"make a control skill for this repo\"（为本仓库做一个 control 技能），或项目没有脚本化手段证明 UI/CLI/服务行为时。"
disable-model-invocation: true
---
```

---

# Create a verification skill

每个严肃的项目都需要一种脚本化的方式来驱动真实应用并证明行为：启动它、以用户会有的方式演练某个功能、捕获证据。本技能把这件事生成为一个项目本地技能（`<skills>/verify-<app>/`），为该仓库量身定制。`<skills>` 是你的宿主环境的项目技能目录：Cursor 中是 `.cursor/skills/`，Claude Code 中是 `.claude/skills/`，Pi 中是 `.pi/skills/`，Codex、OpenCode 及其他是 `.agents/skills/`。如果仓库已经把技能放在其中某处，就用那一处。你写生成物是给下一个 agent 看的，不是给人看的：它会被一个从未见过这个应用的 agent 在任务中途冷读。

## 1. 采访仓库，而不是用户

从代码库回答这些问题，只有你无法观测的才拿去问用户：

- **交互面（Surface）：** 用户实际触到的是什么？Web UI、CLI/TUI、桌面应用、API、移动应用，还是库？一个仓库可以有多个；选主要的，记下其余的。
- **运行（Run）：** 应用在本地怎么启动？优先用仓库自己文档化的开发命令（package scripts、Makefile、README quickstart）。记下端口、环境变量、种子数据、认证。
- **驱动（Drive）：** agent 怎么以编程方式与它交互？先用现成的宿主——Playwright/Cypress 用例、expect 脚本、PTY 助手、可 curl 的端点、调试端口。然后才挑一个通用配方：Web 与 Electron 用浏览器/CDP，CLI/TUI 用 tmux/PTY 宿主，服务用普通 HTTP。
- **观测（Observe）：** 能捕获什么证据？截图、终端会话记录、响应体、日志、退出码、数据库状态。
- **隔离（Isolate）：** 两个实例能否并排运行（端口、数据目录、profile）？不能的话，在生成的技能里写明：拒绝双重驱动一个共享实例，好过弄坏用户的会话。

如果 checkout 按现状构建或启动不了，先修好（或精确报告）再生成；对着坏掉的基座写出的技能会教错步骤。当一个无关的缺失资源阻塞了启动（API 从不服务的静态目录、一个示例配置），生成的技能可以创建它，明确标记为验证脚手架，并在清理时移除。

## 2. 生成技能

写 `<skills>/verify-<app>/SKILL.md`，带 YAML frontmatter（`name: verify-<app>`，以及一个点名应用、交互面、何时用它的 `description`——没有 frontmatter，技能永远不会注册），加上这些小节，每一节都立足于采访的实际发现（不留占位符）：

- **Launch（启动）：** 为验证启动应用的精确命令，以及如何判断它就绪（一行日志、一个提示符）。启动必须从空数据目录到达可用状态，包括所有迁移与种子数据。就绪意味着可用，不只是有进程应答。数据库健康检查可以通过，而它的初始化脚本仍在跑。包含拆除（teardown）。对短命的 CLI 或 TUI，没有需要保活的服务器：启动意味着构建二进制（或装依赖）一次，然后每次驱动都在自己隔离的 PTY 或 tmux 会话里进行。
- **Doctor（体检）：** 一个只读检查，回答"这个实例值得驱动吗？"——进程在跑、版本/构建正确、端口归我们所有、认证有效。任何时候看起来不对劲，agent 都先跑它。
- **Drive（驱动）：** 宿主配方，用本仓库真实的选择器（selector）/命令，不是示例。优先用稳定句柄（ARIA 标签、data 属性、提示符字符串、路由路径），不用坐标和 tab 顺序。
- **Evidence（证据）：** 一次证明要捕获什么、放到哪里。写明证明标准：演练真实的用户路径，不是内部 setter 或仅供测试的端点；既捕获动作也捕获 resulting 状态，不只是最终画面；把副作用（写进的文件、插入的行、发出的消息）与可见内容一起验证；只在生产边界已经隔离外部系统的地方用 mock。安全路径是 dry-run 或测试模式时，用观测（文件、网络、git ref）验证它实际跳过了什么，不要信它的名字：有些 dry-run 仍然碰网络或开浏览器。
- **Cleanup（清理）：** 怎么拆除运行创建的实例。绝不按进程名杀；杀你启动的。清理移除实例与临时状态，绝不移除证据：证明制品在拆除后幸存，放在技能点名的位置。
- **Helpers（辅助脚本）：** 技能附带的任何脚本必须可执行，且调用方式展示在技能正文里。要读者逆向工程才能用的辅助脚本不是辅助脚本。

## 3. 播种功能地图

创建 `<skills>/verify-<app>/features/README.md`，外加你能识别的每个用户可见功能一个文件（起步瞄准前 3-5 个，从路由、命令、菜单或文档来）。遵循 [`references/feature-map-example/`](https://github.com/backnotprop/pstack/blob/main/skills/PLACEHOLDER/references/feature-map-example/) 的形状：一个 README 索引加每功能一个文件。每个文件从用户视角回答：这个功能是什么、怎么到达它、怎么用宿主驱动它、什么可观测的终态证明它工作。四个 H2 是 `Sub-features`、`How to get to it (user POV)`、`Driving it with <harness>` 与 `Gotchas`。种子数据缺某个旅程需要的前置条件的话，该旅程报告失败，原因写进那个功能的 `Gotchas`。绝不为让旅程通过而削弱旅程。地图是仓库持续维护的验证源；地图列出了其他入口时，只驱动一个方便入口的证明是不完整的。

## 4. 交付前证明生成的技能

把它的指令从头到尾完整跑一遍：启动、doctor、驱动一个已映射的功能（一个就够；地图的存在就是为了后续运行覆盖其余）、捕获证据、清理。清理之后，确认证据仍在指定位置——一个吃掉证明的清理在此步失败。修好失败之处，且每次失败的迭代之后也要跑生成的清理，这样坏掉的尝试不会留下进程与端口。从未执行过的生成技能是草稿，不是交付物。你是在真实目标的替身上证明的话（容器代替全新 VM、本地堆栈代替远端），列出替身做了而真实目标不会做的每一个搭建步骤。这些步骤保持未验证，直到在真实目标上的一次运行覆盖它们。

## 5. 提供维护闭环

指引用户去 `/maintain-verification-skill`，在应用变化时保持地图诚实。只在他们问的时候才建议节奏。
