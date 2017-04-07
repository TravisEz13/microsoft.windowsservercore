        Describe "nuget" {
            $repos = @(
                @{repo = 'travisez13/microsoft.windowsservercore.git'}
            )

            it "<repo> should contain nuget" -TestCases $repos {
                param(
                    [parameter(Mandatory)]
                    [string]$repo
                )

                start-process -Wait -filepath docker -argumentlist @('run', "${repo}:latest", 'nuget', 'locals','all','-list') -PassThru  -RedirectStandardError Testdrive:\stderr.txt -RedirectStandardOutput testdrive:\stdout.txt 
                Get-Content testdrive:\stderr.txt | should benullorempty
                Get-Content -raw -Path testdrive:\stdout.txt | should belike '*packages-cache*'
            }
        }