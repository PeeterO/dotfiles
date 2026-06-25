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
- Install fzf into `~/.fzf` and symlink to `~/.local/bin`
- Install lazygit into `~/.local/bin` (Linux and macOS, x86_64/arm64)
- Install Rust via rustup
- Install `tree-sitter-cli` via cargo
- Install `ripgrep`, `fd`, `less`, and `delta` via system package manager

## Neovim external dependencies

### Usually pre-installed
- `git` — lazy.nvim bootstrap, fzf-lua git commands
- `make`, `cc` — tree-sitter parser compilation
- `curl` — lazy.nvim bootstrap

### Installed by install.sh
- `ripgrep` (`rg`) — live grep search, cmp-rg completion source
- `fd` — file finder (fzf-lua)
- `fzf` — fuzzy finder binary (fzf-lua backend)
- `git-delta` — diff pager
- `tree-sitter-cli` — tree-sitter grammar compilation

### LSP servers (install via Mason or manually)
- `rust_analyzer` — Rust
- `pyright` — Python
- `clangd` — C/C++
- `texlab` — LaTeX
- `robotframework_ls` — Robot Framework

### Other tools
- `lazygit` — Git TUI (mapped to `gl`)
- `ctags` / `universal-ctags` — tag-based completion (`cmp-nvim-tags`)
- LaTeX distribution (`texlive`, etc.) — vimtex, nabla.nvim

### DAP (debugging)
- `OpenDebugAD7` — C/C++/Rust debugger adapter (install via Mason)
- `python` at `/usr/bin/python` — Python DAP

## Managing dotfiles after install

Use the `config` alias as a drop-in for `git`:

```bash
config status
config add ~/.config/nvim/init.lua
config commit -m "update nvim config"
config push
```
