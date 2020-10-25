#!/usr/bin/env powershell

<#
.SYNOPSIS
Generates a SHA256 digest for a file

.DESCRIPTION
The script generates a SHA256 digest, similar to that of shasum -a 256.

.EXAMPLE
.\sha256.ps1 file
#>

Param(
    # An input file
    [Parameter(Mandatory=$True)]
    [String[]]
    $File
)


function main([string]$File) {
    Build-Sha256 "$File"
}

function Build-Sha256([string]$File) {
    Get-FileHash "$File" -Algorithm SHA256 `
        | ForEach-Object { "$($_.Hash.ToLower())  $(Split-Path $_.Path -Leaf)" }
}

main "$File"
