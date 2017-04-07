param(
    [Parameter(Mandatory=$true)]
    [string]
    $PackageName,

    [Parameter(Mandatory=$false)]
    [string]
    $Executable
    ,
    [switch]
    $Cleanup
)

if(-not(Get-Command -name Choco -ErrorAction SilentlyContinue))
{
    Write-Verbose "Installing Chocolatey provider..." -Verbose
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
}

Write-Verbose "Installing $PackageName..." -Verbose
choco install -y $PackageName

if($executable)
{
    Write-Verbose "Verifing $Executable is in path..." -Verbose
    $exeSource = $null
    $exeSource = Get-ChildItem -path "$env:ProgramFiles\$Executable" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
    if(!$exeSource)
    {
        Write-Verbose "Falling back to x86 program files..." -Verbose
        $exeSource = Get-ChildItem -path "${env:ProgramFiles(x86)}\$Executable" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
    }
    if(!$exeSource)
    {
        Write-Verbose "Falling back to the root of the drive..." -Verbose
        $exeSource = Get-ChildItem -path "/$Executable" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
    }
    if(!$exeSource)
    {
        throw "$Executable not found"
    }

    $exePath = Split-Path -Path $exeSource
    $newPath = "$env:path;$exePath"
    Write-Verbose "setting path to: $newPath" -Verbose
    [System.Environment]::SetEnvironmentVariable('path',$newPath,[System.EnvironmentVariableTarget]::Machine)
}

if($Cleanup.IsPresent)
{
    Write-Verbose "Cleaning up chocolatey..." -Verbose
    Remove-Item -recurse -force $env:temp\chocolatey -ErrorAction SilentlyContinue
}