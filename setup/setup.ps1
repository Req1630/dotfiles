Write-Output "setup.ps1"

cd ..\.config

[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", (Get-Location).Path, "User")
