$inputJson = [Console]::In.ReadToEnd()

try {
    $data = $inputJson | ConvertFrom-Json
    $cmd = $data.tool_input.command
} catch {
    exit 0
}

if (-not $cmd) { exit 0 }

$blockedPatterns = @(
    'rm -rf /',
    'rm -rf ~',
    'DROP TABLE',
    'TRUNCATE',
    'push.*--force',
    'push.*-f',
    'reset --hard',
    '> /dev/sda'
)

foreach ($pattern in $blockedPatterns) {
    if ($cmd -imatch $pattern) {
        Write-Output "Blocked dangerous command: $cmd"
        exit 2
    }
}

exit 0
