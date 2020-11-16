#!/usr/bin/env powershell

<#
.SYNOPSIS
Generates checksum digests for a file

.DESCRIPTION
The script generates a SHA256 and MD5 digest, similar to that of shasum -a 256.

.EXAMPLE
.\build-checksums.ps1 file
#>

Param(
    # An input file
    [Parameter(Mandatory=$True)]
    [String[]]
    $File
)


function main([string]$File) {
    Write-Host "--- Generating checksums for '$File'"

    Build-Sha256 "$File"
    Build-Md5 "$File"
}

function Build-Sha256([string]$File) {
    Write-Host "  - Generating SHA256 checksum digest"

    Get-FileHash "$File" -Algorithm SHA256 `
        | ForEach-Object { "$($_.Hash.ToLower())  $(Split-Path $_.Path -Leaf)" } `
        > "$File.sha256"
}

function Build-Md5([string]$File) {
    Write-Host "  - Generating MD5 checksum digest"

    Get-FileHash "$File" -Algorithm MD5 `
        | ForEach-Object { "$($_.Hash.ToLower())  $(Split-Path $_.Path -Leaf)" } `
        > "$File.md5"
}

main "$File"
