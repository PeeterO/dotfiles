# dotfiles

Personal dotfiles managed via a bare git repository (Atlassian method).

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/PeeterO/dotfiles/master/install.sh)
```

This will:

- Clone the repo as a bare repo into `~/.cfg`
- Check out dotfiles into `$HOME` (backs up conflicts to `~/.cfg-backup/`)
- Add a `config` alias to `~/.config/fish/config.fish`
- Install latest Neovim into `~/.local/bin`
- Install Rust via rustup
- Install `tree-sitter-cli` via cargo
- Install `ripgrep`, `fd`, `less`, and `delta` via system package manager

## Managing dotfiles after install

Use the `config` alias as a drop-in for `git`:

```bash
config status
config add ~/.config/nvim/init.lua
config commit -m "update nvim config"
config push
```
