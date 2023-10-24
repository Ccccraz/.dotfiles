# Proxy
$env:HTTP_PROXY = "http://127.0.0.1:20172"
$env:HTTPS_PROXY = "http://127.0.0.1:20172"
$env:ALL_PROXY = "http://127.0.0.1:20172"

# Promot
Invoke-Expression (&starship init powershell)