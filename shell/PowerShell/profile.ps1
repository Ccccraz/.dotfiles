(& $env:MAMBA_EXE 'shell' 'hook' -s 'powershell' -p $env:MAMBA_ROOT_PREFIX) | Out-String | Invoke-Expression
