Write-Verbose "Cleaning up..." -Verbose
Remove-Item -recurse -force $env:temp\chocolatey -ErrorAction SilentlyContinue
remove-item -Recurse "$env:ProgramData\chocolatey\lib"  -ErrorAction SilentlyContinue
