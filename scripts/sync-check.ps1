$ErrorActionPreference = "Stop"
$repo = "backnotprop/pstack"
$branch = "main"

# 本仓库锁定的基线，升级时手工改这里
$baselinePotetoModeBlob = "53ecd5094538c52a855c09368390005a9405a70a"

Write-Output "== pstack upstream drift check =="

$latestCommit = gh api "repos/$repo/commits/$branch" --jq .sha
Write-Output ("latest commit      : $latestCommit")
Write-Output ("baseline blob      : $baselinePotetoModeBlob")

$latestPotetoMode = gh api "repos/$repo/contents/skills/poteto-mode/SKILL.md?ref=$branch" --jq .sha
Write-Output ("latest poteto-mode : $latestPotetoMode")

if ($latestPotetoMode -ne $baselinePotetoModeBlob) {
    Write-Output ""
    Write-Output "DRIFT: skills/poteto-mode/SKILL.md 已变更"
    Write-Output "动作：复核本仓库所有 (poteto-mode/SKILL.md:*) 行号引用，确认后更新基线"
    exit 1
}

Write-Output ""
Write-Output "OK: 基于 poteto-mode 的行号引用与上游一致"
exit 0
