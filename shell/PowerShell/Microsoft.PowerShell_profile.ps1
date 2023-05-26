# Proxy
$env:HTTP_PROXY = "http://127.0.0.1:20172"
$env:HTTPS_PROXY = "http://127.0.0.1:20172"
$env:ALL_PROXY = "http://127.0.0.1:20172"

# Env
micromamba activate dev

# Alias
Set-Alias mamba micromamba

# Promot
Invoke-Expression (&starship init powershell)