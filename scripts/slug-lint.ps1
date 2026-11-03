# slug-lint.ps1
#
# 门禁：校验译文里出现的功能标识符未被汉化。
#
# 判据：一个标识符 token（SKILL.md 路径、principle-*、playbooks/*.md、pstack-models.md）
# 本身若含中文字符，则视为被翻译。句子里的中文叙述不算。

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$zh = Join-Path $root "zh"

$files = @()
if (Test-Path $zh) { $files += Get-ChildItem -Path $zh -Filter *.md -Recurse }
foreach ($extra in @("README.md", "NOTICE.md", "SYNC.md")) {
    $p = Join-Path $root $extra
    if (Test-Path $p) { $files += Get-Item $p }
}

if ($files.Count -eq 0) {
    Write-Output "LINT FAILED: 没有找到任何译文文件，门禁空转"
    exit 1
}

$failures = @()

# 按 token 边界切分，取每个片段单独判断是否含中文
$tokenSplit = '[（）()\[\]{}，。：；、！？\s`"“”‘’<>\|]+'

foreach ($file in $files) {
    $lines = [System.IO.File]::ReadAllLines($file.FullName)
    $lineNo = 0
    foreach ($line in $lines) {
        $lineNo++

        $tokens = [regex]::Split($line, $tokenSplit)
        foreach ($token in $tokens) {
            if ([string]::IsNullOrWhiteSpace($token)) { continue }

            $isIdentifier = $token -match 'SKILL\.md' -or
                            $token -match '^principle-' -or
                            $token -match 'playbooks/' -or
                            $token -match 'pstack-models\.md'

            if (-not $isIdentifier) { continue }

            if ($token -match '[\u4e00-\u9fa5]') {
                $failures += "$($file.Name):$lineNo 标识符含中文：$token"
            }
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Output "LINT FAILED"
    $failures | ForEach-Object { Write-Output "  $_" }
    exit 1
}

Write-Output "LINT OK: $($files.Count) 个文件，标识符未被汉化"
exit 0
