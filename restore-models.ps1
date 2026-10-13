param([string]$Directory = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
$Directory = (Resolve-Path -LiteralPath $Directory).Path
$manifest = Join-Path $Directory 'SHA256SUMS.txt'
$expected = @{}
foreach ($line in [IO.File]::ReadAllLines($manifest)) {
    if ($line -match '^([a-fA-F0-9]{64})  (models\.zip(?:\.\d{3})?)$') {
        $expected[$Matches[2]] = $Matches[1]
    }
}
$parts = 1..4 | ForEach-Object { 'models.zip.{0:D3}' -f $_ }
$target = Join-Path $Directory 'models.zip'
if (Test-Path -LiteralPath $target) { throw 'models.zip already exists. Move it before restoring.' }
if (-not $expected.ContainsKey('models.zip')) { throw 'Missing original checksum.' }
foreach ($part in $parts) {
    $path = Join-Path $Directory $part
    if (-not $expected.ContainsKey($part)) { throw "Missing checksum: $part" }
    Write-Host "Verifying $part ..."
    if ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $expected[$part]) {
        throw "Checksum mismatch: $part"
    }
}
$outputStream = [IO.File]::Open($target, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write)
try {
    foreach ($part in $parts) {
        Write-Host "Merging $part ..."
        $inputStream = [IO.File]::OpenRead((Join-Path $Directory $part))
        try { $inputStream.CopyTo($outputStream) } finally { $inputStream.Dispose() }
    }
} finally { $outputStream.Dispose() }
if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $expected['models.zip']) {
    throw 'Restored file checksum mismatch. Do not use this file.'
}
Write-Host "Verified and restored: $target"
