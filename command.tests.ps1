Describe "Verify containers contain expected commands" {
    $repos = @(
        @{
            repo = 'travisez13/microsoft.windowsservercore.git'
            command = 'git.exe'
        }
        @{
            repo = 'travisez13/microsoft.windowsservercore.git'
            command = 'cmake.exe'
        }
        @{
            repo = 'travisez13/microsoft.windowsservercore.git'
            command = 'nuget.exe'
        }
    )

    it "<repo> should contain <command>" -TestCases $repos {
        param(
            [parameter(Mandatory)]
            [string]$repo,
            [parameter(Mandatory)]
            [string]$command
            
        )

        start-process -Wait -filepath docker `
            -argumentlist @(
                'run'
                "${repo}:latest"
                'powershell'
                ('-command &{if(get-command -name {0}){write-output "Exists"}else{write-output "NotFound"}}' -f $command)
            ) `
            -RedirectStandardError $env:temp\stderr.txt `
            -RedirectStandardOutput $env:temp\stdout.txt `
            -NoNewWindow
        Get-Content testdrive:\stderr.txt | should benullorempty
        Get-Content testdrive:\stdout.txt | should belike 'Exists'
    }
}