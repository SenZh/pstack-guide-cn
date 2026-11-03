# 出处与致谢

## 上游

本仓库讨论的 pstack 体系由 poteto 创作，以 MIT 许可发布。

| 项 | 位置 |
|---|---|
| 作者 | poteto，[github.com/backnotprop](https://github.com/backnotprop) |
| 原始插件 | [github.com/cursor/plugins/tree/main/pstack](https://github.com/cursor/plugins/tree/main/pstack) |
| 独立镜像 | [github.com/backnotprop/pstack](https://github.com/backnotprop/pstack) |
| 许可 | MIT |

## 本仓库与本上游的关系

**本仓库不是上游的中文翻译，也不是上游的分发形式。**

正文为原创中文评述，围绕上游的设计与条款展开分析。文中引用上游原文时只保留必要的短片段，并标注来源文件与行号，便于读者回到上游核对。

具体地：

- 上游 `skills/**/SKILL.md` 的正文没有被复制进本仓库。
- 上游的目录结构、`SKILL.md`、playbook 文件均未在本仓库重新发布。
- 本仓库不提供任何可被 Agent 安装或加载的技能。

## 引用标注规范

所有引用格式为 `（相对 skills/ 的路径:行号）`，行号绑定在一个固定的上游 commit 上。基线 commit 与核对方式见 [docs/00-版本基线与引用规范.md](docs/00-版本基线与引用规范.md)。

上游变更后引用可能失效，仓库提供 `scripts/sync-check.ps1` 与 CI 定时检测来处理这件事。

## 许可

本仓库原创中文内容以 MIT 许可发布，全文见 [LICENSE](LICENSE)。

上游片段归原作者所有，受其 MIT 许可约束。若你是上游作者并认为本仓库的引用方式不妥，请开 issue，会立即调整。
