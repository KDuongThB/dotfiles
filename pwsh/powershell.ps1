# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module syntax-highlighting

# aliases
Set-Alias -Name vim -Value nvim
Set-Alias -Name ls -Value lsd
Set-Alias -Name tf -Value terraform
Set-Alias -Name 'npp' -Value 'C:\Program Files\Notepad++\notepad++.exe'
Set-Alias -Name 'olm' -Value ollama
Set-Alias -Name 'cat' -Value 'bat'
Set-Alias -Name 'ff' -Value 'fastfetch.exe'
Set-Alias -Name 'tfr' -Value 'terraformer'
Set-Alias -Name 'grep' -Value 'rg'

# prompt and fetch
oh-my-posh init pwsh --config "D:\dotfiles\omp\catppuccin.omp.json" | Invoke-Expression
clear
echo ""
fastfetch --config 'examples/9'
echo ""

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Invoke-Expression (& { (zoxide init powershell | Out-String) })
