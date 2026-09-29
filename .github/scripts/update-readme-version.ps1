param(
    [Parameter(Mandatory = $true)]
    [string]$OpenSSLVersion,

    [string]$ReadmePath = "README.md"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ReadmePath)) {
    throw "README file not found: $ReadmePath"
}

$content = Get-Content -LiteralPath $ReadmePath -Raw

$startMarker = '<!-- OPENSSL_VERSION_BADGE:START -->'
$endMarker   = '<!-- OPENSSL_VERSION_BADGE:END -->'

$badge = @"
$startMarker
[![OpenSSL](https://img.shields.io/badge/OpenSSL-$OpenSSLVersion-green.svg)](https://www.openssl.org/)
$endMarker
"@

$pattern = '(?s)<!-- OPENSSL_VERSION_BADGE:START -->.*?<!-- OPENSSL_VERSION_BADGE:END -->'

if ($content -notmatch $pattern) {
    throw "README does not contain the expected OpenSSL version badge markers."
}

$newContent = [regex]::Replace(
    $content,
    $pattern,
    [System.Text.RegularExpressions.MatchEvaluator]{
        param($match)
        $badge.TrimEnd()
    },
    1
)

if ($newContent -eq $content) {
    Write-Host "README OpenSSL badge is already $OpenSSLVersion." -ForegroundColor Yellow
    exit 0
}

Set-Content -LiteralPath $ReadmePath -Value $newContent -NoNewline -Encoding utf8

Write-Host "Updated README OpenSSL badge to $OpenSSLVersion." -ForegroundColor Green