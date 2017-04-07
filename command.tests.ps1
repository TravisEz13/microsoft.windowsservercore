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

        $powershellArguments = '-command &{if(get-command -name {0}){1}write-output "Exists"{2}else{1}write-output "NotFound"{2}{2}' -f $command,'{','}'
        Write-Verbose -Message "Running powershell in container with: $powershellArguments" -Verbose
        start-process -Wait -filepath docker `
            -argumentlist @(
                'run'
                "${repo}:latest"
                'powershell'
                $powershellArguments
            ) `
            -RedirectStandardError $env:temp\stderr.txt `
            -RedirectStandardOutput $env:temp\stdout.txt `
            -NoNewWindow
        Get-Content testdrive:\stderr.txt | should benullorempty
        Get-Content testdrive:\stdout.txt | should belike 'Exists'
    }
}