        Describe "git" {
            $repos = @(
                @{repo = 'travisez13/microsoft.windowsservercore.git'}
                @{repo = 'travisez13/microsoft.windowsservercore.git_and_nuget'}
            )

            it "<repo> should contain git" -TestCases $repos {
                param(
                    [parameter(Mandatory)]
                    [string]$repo
                )

                start-process -Wait -filepath docker -argumentlist @('run', "${repo}:latest", 'git', 'version') -PassThru  -RedirectStandardError Testdrive:\stderr.txt -RedirectStandardOutput testdrive:\stdout.txt 
                Get-Content testdrive:\stderr.txt | should benullorempty
                Get-Content testdrive:\stdout.txt | should belike 'git version *.windows.*'
            }
        }