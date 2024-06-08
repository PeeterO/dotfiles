local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = require'packer-init'

require "nvim-tree-on-attach"

require("lazy").setup(plugins, opts)


--settings
vim.g.mapleader   = ','
vim.o.number      = true
vim.o.updatetime  = 300
vim.o.ttimeout    = true
vim.o.ttimeoutlen = 300
vim.o.timeout     = true
vim.o.timeoutlen  = 300
vim.o.smartindent = true
vim.o.tabstop     = 4
vim.o.expandtab   = true
vim.o.shiftwidth  = 4
vim.o.mouse       = ''
vim.o.clipboard   = unnamedplus

--mappings
local fzf = require('fzf-lua')
local map = vim.keymap.set 
local lazygit = require('toggleterm.terminal').Terminal:new({ cmd = "lazygit", hidden = true, direction="float"})

map({ "n" }, '<Leader>f', fzf.blines,                                    { silent = true, noremap = true, desc = "Fuzzy lines"})
map({ 'n' }, '<Leader>d', fzf.tags,                                      { silent = true, noremap = true, desc = "Fuzzy tags"})
map({ 'n' }, '<Leader>g', fzf.files,                                     { silent = true, noremap = true, desc = "Fuzzy files"})
map({ 'n' }, '<Leader>s', fzf.git_stash,                                 { silent = true, noremap = true, desc = "Fuzzy git stash"})
map({ 'n' }, '<Leader>r', fzf.grep,                                      { silent = true, noremap = true, desc = "Fuzzy ripgrep"})
map({ 'v' }, '<Leader>r', fzf.grep_visual,                               { silent = true, noremap = true, desc = "Fuzzy visual selection ripgrep"})
map({ 'n' }, '<Leader>x', fzf.commands,                                  { silent = true, noremap = true, desc = "Fuzzy neovim commands"})
map({ 'n' }, '<Leader>z', fzf.builtin,                                   { silent = true, noremap = true, desc = "Fuzzy commands"})
map({ 'n' }, '<Leader>h', fzf.git_bcommits,                              { silent = true, noremap = true, desc = "File history"})
map({ 'n' }, '<Leader>l', fzf.lsp_workspace_diagnostics,                 { silent = true, noremap = true, desc = "Lsp diagnostics"})
map({ 'n' }, 'gs',        fzf.lsp_document_symbols,                      { silent = true, noremap = true, desc = "Lsp symbols"})
map({ 'n' }, '<Leader>y', require('neoclip.fzf'),                        { silent = true, noremap = true, desc = "Fuzzy yank history"})
map({ 'n' }, 'gm',        require('memento').toggle,                     { silent = true, noremap = true, desc = "Previous files"})
map({ 'i' }, '<C-n>',     function() require('luasnip').jump(1) end,     { silent = true, noremap = true, desc = "Snippet advance"})
map({ 'i' }, '<C-p>',     function() require('luasnip').jump(-1) end,    { silent = true, noremap = true, desc = "Snippet back"})
map({ 'n' }, '<Leader>t', require('nvim-tree.api').tree.toggle,          { silent = true, noremap = true, desc = "File tree toggle"})
map({ 'n' }, '<Leader>e', vim.diagnostic.open_float,                     { silent = true, noremap = true, desc = "File tree toggle"})
map({ 'n' }, '<leader>u',  vim.cmd.UndotreeToggle,                       { silent = true, noremap = true, desc = "Undo tree toggle"})
map({ 'n' }, 'gl',  function() lazygit:toggle() end,                     { noremap = true, desc = "Toggle Lazygit term"})

map({ 'n', 'v' }, '<Leader>as',  '<C-w>l',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, '<Leader>sw',  '<C-w>k',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, '<Leader>ws',  '<C-w>j',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, '<Leader>sa',  '<C-w>h',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, '<Leader>aas', '<C-w>L',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, '<Leader>ssw', '<C-w>k',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, '<Leader>wws', '<C-w>J',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, '<Leader>ssa', '<C-w>h',                               { noremap = true, desc = "Pane navigation"})
map({ 'n', 'v' }, 'ga',          "<Plug>(EasyAlign)",                    { noremap = true, desc = "Align"})
map({ 'n', 'v' }, '<C-k>',       '#',                                    { noremap = true, desc = "Find under cursor, up"})
map({ 'n', 'v' }, '<C-j>',       '*',                                    { noremap = true, desc = "Find under cursor, down"})
map({ 'n', 'v' }, '<space>',     '$',                                    { noremap = true, desc = "Easy end of line"})
map({ 'n', 'v' }, '<backspace>', '^',                                    { noremap = true, desc = "Easy beginning of line"})
map({ 'n', 'v' }, '<Tab>',       '%',                                    { noremap = true, desc = "Easy bracket jump"})
map({ 'n'}, '<Leader>.',  "<cmd>ToggleTerm direction direction=tab<CR>", { noremap = true, desc = "Toggle float term"})
map({ 'v' }, '<Leader>.',  "<cmd>ToggleTermSendVisualLines<CR>",         { noremap = true, desc = "Toggle float term"})

map('n', 'q:',          ':q',                                            { noremap = true, desc = "Typo avoidance"})
map('n', '<Leader>~',   "<cmd>source $MYVIMRC<CR>",                      { noremap = true, desc = "Reload vim conf"})
map('n', '<Leader>p',   "<cmd>set paste!<CR>",                           { noremap = true, desc = "Toggle paste mode"})
map('n', '<Leader>q',   ":copen<CR>",                                    { noremap = true, desc = "Quickfix open"})
map('t', '<Leader><Leader>',  "<C-\\><C-n>",                             { noremap = true, desc = "Exit terminal insert"})

map('n', '<M-1>',  "1gt",                                                { noremap = true, desc = "Tab1"})
map('n', '<M-2>',  "2gt",                                                { noremap = true, desc = "Tab2"})
map('n', '<M-3>',  "3gt",                                                { noremap = true, desc = "Tab3"})
map('n', '<M-4>',  "4gt",                                                { noremap = true, desc = "Tab4"})
map('n', '<M-5>',  "5gt",                                                { noremap = true, desc = "Tab5"})
map('n', '<M-6>',  "6gt",                                                { noremap = true, desc = "Tab6"})
map('n', '<M-7>',  "7gt",                                                { noremap = true, desc = "Tab7"})
map('n', '<M-8>',  "8gt",                                                { noremap = true, desc = "Tab8"})


