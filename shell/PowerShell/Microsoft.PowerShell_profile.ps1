# Proxy
$env:HTTP_PROXY = "http://127.0.0.1:20172"
$env:HTTPS_PROXY = "http://127.0.0.1:20172"

# keymap
Set-PSReadLineKeyHandler -Chord Ctrl+UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function AcceptNextSuggestionWord

# Promot
Invoke-Expression (&starship init powershell)

Set-Alias -Name get -Value aria2c
Set-Alias -Name mamba -Value micromamba
