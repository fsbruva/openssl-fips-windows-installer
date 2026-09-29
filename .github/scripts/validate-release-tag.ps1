param(
    [Parameter(Mandatory = $true)]
    [string]$TagName,

    [Parameter(Mandatory = $true)]
    [string]$OpenSSLVersion
)

$ErrorActionPreference = "Stop"

if ($TagName -notmatch '^v(?<version>\d+\.\d+\.\d+)-(?<revision>\d+)$') {
    throw "Invalid release tag '$TagName'. Expected format: v<openssl-version>-<revision>, for example v3.5.9-1."
}

$tagVersion = $Matches.version

if ($tagVersion -ne $OpenSSLVersion) {
    throw @"
Release tag/version mismatch.

Tag:             $TagName
Tag OpenSSL:     $tagVersion
Configured:      $OpenSSLVersion

Update release.json before creating this release tag.
"@
}

Write-Host "Release tag validated:" -ForegroundColor Green
Write-Host "  Tag:            $TagName"
Write-Host "  OpenSSL:        $OpenSSLVersion"
Write-Host "  Release:        $($Matches.revision)"