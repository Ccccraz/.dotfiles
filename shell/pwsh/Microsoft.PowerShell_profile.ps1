# keymap
Set-PSReadLineKeyHandler -Chord Ctrl+UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function AcceptNextSuggestionWord

# Promot
Invoke-Expression (&starship init powershell)

Set-Alias -Name get -Value aria2c