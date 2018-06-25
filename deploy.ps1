$ErrorActionPreference = "Stop"

if (-not $env:CI) {
    throw "Deploy should only be done by the CI server."
}

$buildRoot = Join-Path $env:TEMP "windower-build"

$stagingDir = if ($env:BUILD_PATH) { $env:BUILD_PATH } else { Join-Path $buildRoot "staging" }

if (-not (Test-Path $stagingDir -PathType Container)) {
    "Skipping deploy"
    ""
    Exit
}

function Get-PackageValid ([Parameter(Mandatory=$true)][string[]]$name) {
    $manifest = (Join-Path $name "manifest.xml")
    (Test-Path $manifest) -and ([xml](Get-Content $manifest)).package.name -ceq $name
}

"Removing invalid packages..."
Get-ChildItem $stagingDir -Directory -Name |
    Where-Object { (Test-Path $_) -and -not (Get-PackageValid $_) } |
    Remove-Item -Recurse -Force

function Get-BoolValue ([object]$value, [bool]$default = $true) {
    if ($value -is [string]) {
        $c = $value[0]
        $c -eq "t" -or $c -eq "y" -or $c -eq "1"
    } else {
        $default
    }
}

function Write-PackageInfo ([Parameter(Mandatory=$true)][string[]]$path,
        [Parameter(Mandatory=$true)][System.XMl.XmlWriter]$writer) {
    $manifest = (Join-Path $path "manifest.xml")
    if (-not (Test-Path $manifest)) {
        return
    }
    $package = ([xml](Get-Content $manifest)).package
    $writer.WriteStartElement("package")
    $writer.WriteElementString("name", $package.name)
    $writer.WriteElementString("version", $package.version)
    $writer.WriteElementString("type", $package.type)

    $dependencies = $package.dependencies.dependency |
        Where-Object { Get-BoolValue $_.required } |
        ForEach-Object { if ($_ -is [System.Xml.XmlElement]) { $_.'#text' } else { $_ } }
    if ($dependencies.Count -gt 0) {
        $writer.WriteStartElement("dependencies")
        $dependencies | ForEach-Object { $writer.WriteElementString("dependency", $_) }
        $writer.WriteEndElement()
    }

    $writer.WriteStartElement("files")
    Get-ChildItem $path -Recurse -File | ForEach-Object {
        Push-Location $stagingDir
        $relativePath = (Resolve-Path $_.FullName -Relative).Replace(".\", "")
        Pop-Location

        $writer.WriteStartElement('file')
        $writer.WriteAttributeString('size', $_.Length)
        $writer.WriteString($relativePath.Replace("\", "/"))
        $writer.WriteEndElement()
    }
    $writer.WriteEndElement()

    $writer.WriteEndElement()
}

"Building package list..."

$xmlSettings = New-Object System.XMl.XmlWriterSettings
$xmlSettings.Indent = $true
$xmlSettings.IndentChars = "  "
$xmlSettings.NewLineChars = "`n"
$packagesWriter = [System.XMl.XmlWriter]::Create((Join-Path $stagingDir "packages.xml"), $xmlSettings)

$packagesWriter.WriteStartDocument()
$packagesWriter.WriteStartElement("packages")

Get-ChildItem $stagingDir -Directory |
    ForEach-Object { Write-PackageInfo $_.FullName $packagesWriter }

$packagesWriter.WriteEndElement()
$packagesWriter.WriteEndDocument()
$packagesWriter.Flush()
$packagesWriter.Close()

Get-ChildItem -Force | Remove-Item -Recurse -Force

"`nCloning deployment repository..."
$cloneUrl = "https://${env:GITHUB_USERNAME}:${env:GITHUB_TOKEN}@github.com/${env:APPVEYOR_REPO_NAME}.git"
try { & git clone -q --branch="gh-pages" --depth=1 $cloneUrl . 2>&1 | Out-Null } catch { }
if (-not $?) {
    Write-Host "Failed to clone gh-pages branch, attempting to create..." -ForegroundColor Red
    try {
        & git clone -q --depth=1 $cloneUrl . 2>&1 | Out-Null
        & git checkout --orphan "gh-pages" 2>&1 | Out-Null
    } catch { }
}
"Cleaning gh-pages branch..."
try { & git rm -rf . 2>&1 | Out-Null } catch { }

"Staging files..."
Get-ChildItem $stagingDir | Copy-Item -Destination . -Recurse -Force

# "resources.windower.net" | Out-File "CNAME" -Encoding ASCII -Force -NoNewline

& git config core.autocrlf false
& git config user.email "$env:GITHUB_EMAIL"
& git config user.name "$env:GITHUB_NAME"
& git add .
"Committing changes..."
& git commit -q -m "Deploy packages from commit $env:APPVEYOR_REPO_COMMIT"
"Pushing to remote..."
try { & git push -q origin gh-pages 2>&1 | Out-Null } catch { }
if (-not $?) { throw "Failed push to remote" }

""
