Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$timestamp = '20260923-1924'
$logDirFull = 'C:\Users\edburns\workareas\dd-3068633-win32-x64-01-shepherd-control\1-math-control-remove-before-merge\prompts\shepherd-task-20-20260923-1924'
$sessionSharePath = Join-Path $logDirFull "create-issues-session-$timestamp.md"
$sessionJsonlPath = Join-Path $logDirFull "create-issues-session-$timestamp.jsonl"
$sessionOtelPath = Join-Path $logDirFull "create-issues-otel-$timestamp.jsonl"
$promptPath = 'C:\Users\edburns\workareas\dd-3068633-win32-x64-01-shepherd-control\1-math-control-remove-before-merge\prompts\shepherd-task-20-20260923-1924\20260923-1924-invoke-shepherd-task-20-create-issues-from-plan-skill.md'
$prompt = Get-Content -LiteralPath $promptPath -Raw
Write-Output "[shepherd-task] Logging create-issues run to: $logDirFull"
$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "shepherd-redact-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $tempDir | Out-Null
$rawJsonlPath = Join-Path $tempDir 'session.jsonl'
$rawSharePath = Join-Path $tempDir 'session.md'
$env:COPILOT_OTEL_FILE_EXPORTER_PATH = $sessionOtelPath
$copilotExit = 0
try {
    $prompt | copilot --yolo --output-format json --share $rawSharePath > $rawJsonlPath
    $copilotExit = $LASTEXITCODE
    if (Test-Path -LiteralPath $rawJsonlPath) {
        Move-Item -LiteralPath $rawJsonlPath -Destination $sessionJsonlPath -Force
    }
    if (Test-Path -LiteralPath $rawSharePath) {
        Move-Item -LiteralPath $rawSharePath -Destination $sessionSharePath -Force
    }
    & 'C:\Users\edburns\.copilot\plugins\shepherd-task\scripts\redact-secrets.ps1' $logDirFull | Out-Null
}
finally {
    Remove-Item Env:\COPILOT_OTEL_FILE_EXPORTER_PATH -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}
if ($copilotExit -ne 0) {
    [Console]::Error.WriteLine("[shepherd-task] FAILED: copilot exited with code $copilotExit")
    exit $copilotExit
}
$resultPath = Join-Path $logDirFull 'stage-20-result.json'
try {
    & 'C:\Users\edburns\.copilot\plugins\shepherd-task\scripts\assert-stage20-result.ps1' -ResultPath $resultPath | Out-Null
}
catch {
    [Console]::Error.WriteLine("[shepherd-task] FAILED: $($_.Exception.Message)")
    exit 1
}
Write-Output '[shepherd-task] Create-issues session complete.'
exit 0
