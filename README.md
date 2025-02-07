# dotfiles
my dotfiles for quick Linux and Windows setup

# Arch btw setup
## Packages I need
### yay

```
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# run once
yay -Y --gendb
yay -Syu --devel
```
### then install everything else
```
yay -Syuu

yay -S zsh oh-my-posh lsd fzf ripgrep bat delta tlrc fastfetch
```

# Ubuntu setup
## Packages
```
sudo apt update && sudo apt upgrade
```
### Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
### brew install everything (cuz apt sucks)
```
brew install oh-my-posh lsd fzf ripgrep bat delta tlrc fastfetch
```

# zsh setup
because zsh = best sh
### installation
```
yay -S zsh # for arch btw
```
or
```
sudo apt install zsh # for debuntu
```
### oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
#### zsh plugins: syntax-highlighting, autosuggestions, completions and fzf-tab
```
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```

### Then just copy the damn thing
```
cd $HOME
git clone https://github.com/kduongthb/dotfiles.git
cp dotfiles/.zshrc ~/.zshrc
```
remember to comment out homebrew integration if you use Arch, btw.
# Manually setup things if you want
## fzf integrations 

### Shell integration for zsh
```
eval "$(fzf --zsh --preview "bat --color=always --style=numbers --line-range=:500 {}")"
```

### Styling options
put this into ```.zshrc``` (if you don't copy the file from repo)
```
# Styling options
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
```

## oh-my-posh prompt
put this at the end of ```.zshrc``` i guess
```
eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/KDuongThB/dotfiles/refs/heads/master/omp/catppuccin.omp.json')"
```