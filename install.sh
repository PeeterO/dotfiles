#!/usr/bin/env bash
set -e

DOTFILES_REPO="git@github.com:PeeterO/dotfiles.git"
BARE_DIR="$HOME/.cfg"

if [ -d "$BARE_DIR" ]; then
    echo "Error: $BARE_DIR already exists. Aborting." >&2
    exit 1
fi

git clone --bare "$DOTFILES_REPO" "$BARE_DIR"

config() {
    git --git-dir="$BARE_DIR" --work-tree="$HOME" "$@"
}

config config --local core.sparseCheckout true
cat > "$BARE_DIR/info/sparse-checkout" << 'EOF'
/*
!/install.sh
!/README.md
EOF

config checkout 2>/dev/null || {
    echo "Backing up pre-existing dotfiles to ~/.cfg-backup"
    mkdir -p "$HOME/.cfg-backup"
    config checkout 2>&1 \
        | grep -E "^\s+\." \
        | awk '{print $1}' \
        | xargs -I{} sh -c 'mkdir -p "$HOME/.cfg-backup/$(dirname "{}")" && mv "$HOME/{}" "$HOME/.cfg-backup/{}"'
    config checkout
}

config config --local status.showUntrackedFiles no

FISH_CONFIG="$HOME/.config/fish/config.fish"
ALIAS_LINE="alias config='git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'"

if [ -f "$FISH_CONFIG" ] && grep -qF "alias config=" "$FISH_CONFIG"; then
    echo "Fish alias already present in $FISH_CONFIG, skipping."
else
    mkdir -p "$(dirname "$FISH_CONFIG")"
    echo "" >> "$FISH_CONFIG"
    echo "$ALIAS_LINE" >> "$FISH_CONFIG"
    echo "Added config alias to $FISH_CONFIG"
fi

echo "Dotfiles installed."

# Basic shell aliases
add_alias() {
    local file="$1" line="$2"
    grep -qF "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

BASHRC="$HOME/.bashrc"
add_alias "$BASHRC" "alias ll='ls -lhF'"
add_alias "$BASHRC" "alias la='ls -lAhF'"

add_alias "$FISH_CONFIG" "alias ll='ls -lhF'"
add_alias "$FISH_CONFIG" "alias la='ls -lAhF'"

echo "Added ll and la aliases to bash and fish configs."

# Install latest neovim from GitHub releases into ~/.local/bin
echo "Installing latest neovim..."
NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
NVIM_TMP="$(mktemp -d)"
trap 'rm -rf "$NVIM_TMP"' EXIT

curl -fsSL "$NVIM_URL" | tar -xz -C "$NVIM_TMP" --strip-components=1

mkdir -p "$HOME/.local/bin"
cp "$NVIM_TMP/bin/nvim" "$HOME/.local/bin/nvim"
chmod +x "$HOME/.local/bin/nvim"

echo "Neovim $("$HOME/.local/bin/nvim" --version | head -1) installed to ~/.local/bin/nvim"

# Install system dependencies
echo "Installing system dependencies..."
if command -v apt-get &>/dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y ripgrep fd-find less git-delta
    # Debian/Ubuntu installs fd as fdfind — symlink it
    if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    fi
elif command -v dnf &>/dev/null; then
    sudo dnf install -y ripgrep fd-find less git-delta
elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm ripgrep fd less git-delta
else
    echo "Warning: no supported package manager found (apt/dnf/pacman). Install ripgrep, fd, less, and delta manually." >&2
fi

# Install Rust via rustup
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Install tree-sitter-cli via cargo
echo "Installing tree-sitter-cli..."
cargo install tree-sitter-cli
