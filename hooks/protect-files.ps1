$inputJson = [Console]::In.ReadToEnd()

try {
    $data = $inputJson | ConvertFrom-Json
    $filePath = $data.tool_input.file_path
} catch {
    exit 0
}

if (-not $filePath) { exit 0 }

# Normalize backslashes to forward slashes
$filePath = $filePath -replace '\\', '/'

$protectedPatterns = @(
    '.env',
    'package-lock.json',
    'yarn.lock',
    '.git/',
    'infrastructure/',
    '.claude/settings.json',
    'docker-compose.prod',
    'Makefile'
)

foreach ($pattern in $protectedPatterns) {
    if ($filePath.Contains($pattern)) {
        [Console]::Error.WriteLine("Blocked: $filePath matches protected pattern '$pattern'")
        exit 2
    }
}

exit 0
