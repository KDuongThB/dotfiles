#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

REPO_URL="https://github.com/KDuongThB/dotfiles"
CLONE_DIR="$HOME/src/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Starting advanced dotfiles installation..."

# 1. Install System Dependencies needed for Brew and compiling
echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y build-essential curl git procps file zsh

# 2. Install Homebrew (Linuxbrew) if not already installed
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    # Run the official Homebrew installer non-interactively
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Dynamically evaluate brew for the current script execution session
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "🍺 Homebrew is already installed."
fi

# 3. Install Ricing & CLI tools via Homebrew
echo "🛒 Installing CLI tools via Brew..."
brew install oh-my-posh zoxide lsd bat fzf

# Set up standard FZF shell completions and key bindings
echo "⚙️ Configuring FZF integrations..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# 4. Clone the dotfiles repository
if [ -d "$CLONE_DIR" ]; then
    echo "🔄 Repository already exists, pulling latest changes..."
    cd "$CLONE_DIR" && git pull
else
    echo "📥 Cloning dotfiles from $REPO_URL..."
    git clone "$REPO_URL" "$CLONE_DIR"
fi

# 5. Backup existing configuration structures
echo "🗄️ Preparing backup directory at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

# Helper function to safely symlink configs
link_config() {
    local source_target="$1"
    local dest_target="$2"

    if [ -e "$source_target" ]; then
        if [ -e "$dest_target" ] || [ -L "$dest_target" ]; then
            echo "⚠️ Moving existing $dest_target to backup..."
            mv "$dest_target" "$BACKUP_DIR/"
        fi
        echo "🔗 Linking $dest_target -> $source_target"
        ln -s "$source_target" "$dest_target"
    else
        echo "ℹ️ Skipping $source_target (not found in repository)"
    fi
}

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🦁 Oh My Zsh not found. Installing framework..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh framework is already present."
fi

# 6. Apply Symlinks
echo "🛠️ Creating symlinks..."
link_config "$CLONE_DIR/.zshrc" "$HOME/.zshrc"

# 6. Apply Symlinks (Map repository files to target system locations)
echo "🛠️ Creating symlinks..."
link_config "$CLONE_DIR/.zshrc" "$HOME/.zshrc"
link_config "$CLONE_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_config "$CLONE_DIR/nvim" "$HOME/.config/nvim"
link_config "$CLONE_DIR/fastfetch" "$HOME/.config/fastfetch"
link_config "$CLONE_DIR/tmux" "$HOME/.config/tmux"

# 7. Scan .zshrc and auto-clone specified ZSH plugins/modules
echo "🔍 Parsing .zshrc for custom plugin modules..."
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom/plugins"
# If not using oh-my-zsh, fallback to a clean internal structure like ~/.zsh/plugins
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    ZSH_CUSTOM_DIR="$HOME/.zsh"
fi

# Search your .zshrc for cloned plugin/theme GitHub URLs or references
# This pattern matches common git clone lines or plugin arrays inside dotfiles
if [ -f "$HOME/.zshrc" ]; then
    # Clone common plugins explicitly if they are named/expected in standard dotfiles rices
    declare -A modules=(
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
    )

    for plugin in "${!modules[@]}"; do
        # Check if the plugin is explicitly mentioned in your .zshrc text
        if grep -q "$plugin" "$HOME/.zshrc"; then
            TARGET_PATH="$ZSH_CUSTOM_DIR/$plugin"
            if [ ! -d "$TARGET_PATH" ]; then
                echo "📥 Cloning ZSH module: $plugin..."
                mkdir -p "$(dirname "$TARGET_PATH")"
                git clone "${modules[$plugin]}" "$TARGET_PATH"
            else
                echo "✅ ZSH module $plugin already exists."
            fi
        fi
    done
fi

# 8. Set up Shell Profile hooks for user environment continuity
BREW_ENV_BLOCK='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
if [ -f "$HOME/.zshrc" ] && ! grep -q "brew shellenv" "$HOME/.zshrc"; then
    echo "📝 Adding Homebrew environment setups to the top of your .zshrc..."
    echo -e "$BREW_ENV_BLOCK\n$(cat "$HOME/.zshrc")" > "$HOME/.zshrc"
fi

# 9. Change Default Shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Switching your default system shell to Zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

echo "✨ System successfully riched! Please log out and back in, or run 'zsh' to launch your custom setup."
