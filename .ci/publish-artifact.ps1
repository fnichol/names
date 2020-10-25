#!/usr/bin/env powershell

<#
.SYNOPSIS
Uploads a release artifact for publishing

.DESCRIPTION
The script uploads a build artifact into a GitHub release.

.EXAMPLE
.\upload-release-artifact.ps1 fnichol/names v1.0.0 names-x86_64-pc-windows-msvc
#>

Param(
    # Full name of the repo
    [Parameter(Mandatory=$True)]
    [String]
    $Repo,
    # GitHub ID of the release
    [Parameter(Mandatory=$True)]
    [String]
    $Release,
    # An artifact file
    [Parameter(Mandatory=$True)]
    [String]
    $Artifact
)

function main([string]$Repo, [string]$Release, [string]$Artifact) {
    if (-Not (Test-Path "$Artifact")) {
        throw "artifact '$Artifact' not found"
    }
    if (-Not (Test-Path env:GITHUB_TOKEN)) {
        throw "missing required environment variable: GITHUB_TOKEN"
    }

    Publish-Artifact "$Repo" "$Release" "$Artifact"
}

function Publish-Artifact([string]$Repo, [string]$Release, [string]$ArtifactFile) {
    $artifact = Split-Path "$ArtifactFile" -Leaf -Resolve
    $content_type = "application/octet-stream"

    Write-Output "--- Publishing artifact '$artifact' to the '$Release' release"

    $url = "https://uploads.github.com/repos/$Repo/releases/$Release"
    $url = "$url/assets?name=$artifact"

    Write-Output "  - Uploading '$ArtifactFile' to $url"
    Invoke-WebRequest `
        -Method 'Post' `
        -Headers @{'Authorization' = "token $env:GITHUB_TOKEN"} `
        -ContentType "$content_type" `
        -InFile "$ArtifactFile" `
        -Uri "$url"
}

main "$Repo" "$Release" "$Artifact"
