oh-my-posh init pwsh --config "D:\dotfiles\omp\catppucin.omp.json" | Invoke-Expression
clear

echo ""
fastfetch --config "D:\dotfiles\fastfetch\windows"
echo ""

function sudo {
Start-Process pwsh -Verb RunAs
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
