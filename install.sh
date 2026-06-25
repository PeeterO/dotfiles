#!/usr/bin/env bash
set -e

DOTFILES_REPO="https://github.com/PeeterO/dotfiles.git"
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

# Install fzf fuzzy finder via official install script (platform-independent)
echo "Installing fzf..."
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi
"$HOME/.fzf/install" --bin
ln -sf "$HOME/.fzf/bin/fzf" "$HOME/.local/bin/fzf"
echo "fzf $(fzf --version) installed to ~/.local/bin/fzf"

# Install lazygit from GitHub releases (Linux and macOS, x86_64/arm64)
echo "Installing lazygit..."
_lg_os="$(uname -s)"
_lg_arch="$(uname -m)"
case "$_lg_os" in
    Linux)  _lg_os="Linux" ;;
    Darwin) _lg_os="Darwin" ;;
    *)      _lg_os="" ;;
esac
case "$_lg_arch" in
    x86_64)        _lg_arch="x86_64" ;;
    aarch64|arm64) _lg_arch="arm64" ;;
    armv6l)        _lg_arch="armv6" ;;
    *)             _lg_arch="" ;;
esac
if [ -n "$_lg_os" ] && [ -n "$_lg_arch" ]; then
    _lg_version="$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')"
    _lg_tmp="$(mktemp -d)"
    curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${_lg_version}/lazygit_${_lg_version}_${_lg_os}_${_lg_arch}.tar.gz" \
        | tar -xz -C "$_lg_tmp" lazygit
    mv "$_lg_tmp/lazygit" "$HOME/.local/bin/lazygit"
    chmod +x "$HOME/.local/bin/lazygit"
    rm -rf "$_lg_tmp"
    echo "lazygit $("$HOME/.local/bin/lazygit" --version 2>&1 | head -1) installed to ~/.local/bin/lazygit"
else
    echo "Warning: lazygit not available for ${_lg_os:-unknown}/${_lg_arch:-unknown}, skipping." >&2
fi

# Install system dependencies
echo "Installing system dependencies..."
_sudo=''
command -v sudo &>/dev/null && _sudo='sudo'
if command -v apt-get &>/dev/null; then
    $_sudo apt-get update -qq
    $_sudo apt-get install -y ripgrep fd-find less git-delta
    # Debian/Ubuntu installs fd as fdfind — symlink it
    if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    fi
elif command -v dnf &>/dev/null; then
    $_sudo dnf install -y ripgrep fd-find less git-delta
elif command -v pacman &>/dev/null; then
    $_sudo pacman -S --noconfirm ripgrep fd less git-delta
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
