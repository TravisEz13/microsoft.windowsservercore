param(
    [Parameter(Mandatory=$true)]
    [string]
    $PackageName,
    [Parameter(Mandatory=$true)]
    [string]
    $executable
)

if(-not( Get-PackageProvider -Name Chocolatey -ErrorAction SilentlyContinue))
{
    Write-Verbose "Installing Chocolatey provider..." -Verbose
    Install-PackageProvider -Name Chocolatey
}

Write-Verbose "Installing $PackageName..." -Verbose
Install-Package -Name $PackageName -ProviderName Chocolatey -Force

Write-Verbose "Verifing $Executable is in path..." -Verbose
$exeSource = $null
$exeSource = Get-ChildItem -path "$env:ProgramFiles\$executable" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
if(!$exeSource)
{
    Write-Verbose "Falling back to x86 program files..." -Verbose
    $exeSource = Get-ChildItem -path "${env:ProgramFiles(x86)}\$executable" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
}
if(!$exeSource)
{
    Write-Verbose "Falling back to the root of the drive..." -Verbose
    $exeSource = Get-ChildItem -path "/$executable" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
}
if(!$exeSource)
{
    throw "$executable not found"
}

$exePath = Split-Path -Path $exeSource
$newPath = "$env:path;$exePath"
Write-Verbose "setting path to: $newPath" -Verbose
[System.Environment]::SetEnvironmentVariable('path',$newPath,[System.EnvironmentVariableTarget]::Machine)
