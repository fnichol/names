#!/usr/bin/env powershell

<#
.SYNOPSIS
Builds cargo-make into a dedicated directory for caching

.DESCRIPTION
The script will run `cargo install <PLUGIN>` to target a non-default directory,
allowing a user to cache the installation directory for caching in a CI
context. The executables in the `bin` directory are linked back into
`$env:CARGO_HOME\bin` so that no further PATH manipulation is necessary.

.EXAMPLE
.\build-cargo-make.ps1
#>

param (
)

function main() {
    if (Test-Path env:CARGO_HOME) {
        $dest = "$env:CARGO_HOME"
    } elseif (Test-Path env:USERPROFILE) {
        $dest = "$env:USERPROFILE\.cargo"
    } elseif (Test-Path env:HOME) {
        $dest = "$env:HOME\.cargo"
    } else {
        throw "cannot determine CARGO_HOME"
    }

    Install-CargoMake "$dest"
}

function Install-CargoMake([string]$Dest) {
    $plugin = "cargo-make"

    Write-Output "--- Building $plugin in $Dest"

    if (-Not (Test-Path "$Dest")) {
        New-Item -Type Directory "$Dest" | Out-Null
    }
    rustup install stable
    cargo +stable install --root "$Dest\opt\$plugin" --force --verbose "$plugin"

    # Create symbolic links for all execuatbles into $env:CARGO_HOME\bin
    Get-ChildItem "$Dest\opt\$plugin\bin\*.exe" | ForEach-Object {
        $dst = "$Dest\bin\$($_.Name)"

        if (-Not (Test-Path "$dst")) {
            Write-Debug "Symlinking $_ to $dst"
            New-Item -Path "$dst" -Type SymbolicLink -Value "$_" | Out-Null
        }
    }
}

main
