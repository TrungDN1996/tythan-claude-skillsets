$inputJson = [Console]::In.ReadToEnd()
$data = $inputJson | ConvertFrom-Json

$content = $data.tool_input.content
$filePath = $data.tool_input.file_path

if (-not $content) { exit 0 }

# Skip .env files (they're supposed to have secrets)
if ($filePath -match '\.env($|\.)') { exit 0 }

$patterns = @(
    'sk-[a-zA-Z0-9]{20,}',
    'ghp_[a-zA-Z0-9]{36}',
    'AKIA[0-9A-Z]{16}',
    '-----BEGIN .* PRIVATE KEY-----',
    'xoxb-[0-9]+-[a-zA-Z0-9]+'
)

foreach ($pattern in $patterns) {
    if ($content -match $pattern) {
        Write-Output "Blocked: detected potential secret in $filePath"
        exit 2
    }
}

exit 0
