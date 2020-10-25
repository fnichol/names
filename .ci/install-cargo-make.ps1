#!/usr/bin/env powershell

<#
.SYNOPSIS
Installs cargo-make

.DESCRIPTION
The script will download and extract a version of `cargo-make` into
a destination path

.EXAMPLE
.\install-cargo-make.ps1
#>

param (
    # The version to install which overrides the default of latest
    [string]$Version = "",
    # Prints the latest version of cargo-make
    [switch]$PrintLatest = $false
)

function main() {
    if (Test-Path env:CARGO_HOME) {
        $dest = "$env:CARGO_HOME\bin"
    } elseif (Test-Path env:USERPROFILE) {
        $dest = "$env:USERPROFILE\.cargo\bin"
    } elseif (Test-Path env:HOME) {
        $dest = "$env:HOME\.cargo\bin"
    } else {
        throw "cannot determine CARGO_HOME"
    }

    if ($Version.Length -gt 0) {
        $version = "$Version"
    } else {
        $version = Get-LatestCargoMakeVersion
    }

    if ($PrintLatest) {
        Write-Host "$version"
    } else {
        Install-CargoMake "$version" "$dest"
    }
}

function Get-LatestCargoMakeVersion() {
    $crate = "cargo-make"

    (cargo search --limit 1 --quiet "$crate" | Select-Object -First 1).
        Split('"')[1]
}

function Install-CargoMake([string]$Version, [string]$Dest) {
    $fileBase = "cargo-make-v$Version-x86_64-pc-windows-msvc"
    $url = "https://github.com/sagiegurari/cargo-make/releases/download/$Version"
    $url = "$url/$fileBase.zip"

    Write-Output "--- Installing cargo-make $Version to $Dest"

    $archive = New-TemporaryFile
    Rename-Item "$archive" "$archive.zip"
    $archive = "$archive.zip"
    $tmpdir = New-TemporaryDirectory

    if (-Not (Test-Path "$Dest")) {
        New-Item -Type Directory "$Dest" | Out-Null
    }

    try {
        Write-Output "  - Downloading $url to $archive"
        (New-Object System.Net.WebClient).DownloadFile($url, $archive)
        Expand-Archive -LiteralPath "$archive" -DestinationPath "$tmpdir"
        Write-Output "  - Extracting cargo-make.exe to $Dest"
        Copy-Item "$tmpdir\cargo-make.exe" -Destination "$Dest"
    } finally {
        Remove-Item "$archive" -Force
        Remove-Item "$tmpdir" -Force -Recurse
    }
}

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string]$name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

main
