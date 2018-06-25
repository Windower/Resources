$ErrorActionPreference = "Stop"

$buildRoot = Join-Path $env:TEMP "windower-build"

$stagingDir = if ($env:BUILD_PATH) { $env:BUILD_PATH } else { Join-Path $buildRoot "staging" }
$deployedDir = Join-Path $buildRoot "deployed"

Remove-Item $stagingDir -Recurse -Force -ErrorAction SilentlyContinue

New-Item $stagingDir -ItemType Directory | Out-Null
if ($env:CI) {
    Remove-Item $deployedDir -Recurse -Force -ErrorAction SilentlyContinue
    try {
        & git clone -q --depth=1 --branch="gh-pages" https://github.com/${env:APPVEYOR_REPO_NAME}.git $deployedDir 2>&1 | Out-Null
    } catch { }
    $buildAll = -not $?

    if($env:APPVEYOR_PULL_REQUEST_NUMBER) {
        $changedFiles = & git log --name-only --pretty=oneline --full-index master..
    } else {
        $changedFiles = & git log --name-only --pretty=oneline --full-index HEAD^..HEAD
    }
    $buildAll = $buildAll -or -not $?

    if (-not $buildAll) {
        $changedPackages = 
            @($changedFiles |
                Select-Object -Skip 1 |
                ForEach-Object { ($_ -split "/")[0] } |
                Select-Object -Unique |
                Where-Object { Test-Path $_ -PathType Container }) +
            @(Get-ChildItem -Directory -Name |
                Where-Object { -not (Test-Path (Join-Path $deployedDir $_) -PathType Container) }) |

                Select-Object -Unique

        if ($null -eq $changedPackages -or $changedPackages.count -eq 0) {
            "Nothing has changed"
            "Skipping build"
            ""
            Exit
        }

        Get-ChildItem $deployedDir -Directory |
            Where-Object { -not $changedPackages.Contains($_.Name) } |
            Copy-Item -Destination $stagingDir -Recurse -Force
    }
} else {
    $buildAll = $true
}

if ($buildAll) {
    $changedPackages = Get-ChildItem -Directory -Name
}

if (Test-Path ".docs") {
    Get-ChildItem ".docs" | Copy-Item -Destination $stagingDir -Recurse -Force
}

Get-ChildItem -Directory -Exclude ".docs" |
    Where-Object { $changedPackages.Contains($_.Name) } |
    Copy-Item -Destination $stagingDir -Recurse -Force

$now = Get-Date
$build = [int](New-TimeSpan -Start (Get-Date -Year 2000 -Month 1 -Day 1) -End $now).TotalDays
$revision = [int]$now.TimeOfDay.TotalSeconds / 2

$manifestPath = Join-Path $stagingDir "resources_data" | Join-Path -ChildPath "manifest.xml"

$xmlSettings = New-Object System.XMl.XmlWriterSettings
$xmlSettings.Indent = $true
$xmlSettings.IndentChars = "  "
$xmlSettings.NewLineChars = "`n"
$manifestWriter = [System.XMl.XmlWriter]::Create($manifestPath, $xmlSettings)

$manifestWriter.WriteStartDocument()
$manifestWriter.WriteStartElement("package")
$manifestWriter.WriteElementString("name", "resources_data")
$manifestWriter.WriteElementString("version", "5.0.$build.$revision")
$manifestWriter.WriteElementString("type", "library")
$manifestWriter.WriteEndElement()
$manifestWriter.WriteEndDocument()

$manifestWriter.Flush()
$manifestWriter.Close()
