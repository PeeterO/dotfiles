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
vim.o.ttimeout    = 300
vim.o.timeout     = true
vim.o.timeoutlen  = 300
vim.o.smartindent = true
vim.o.tabstop     = 4
vim.o.expandtab   = true
vim.o.shiftwidth  = 4
vim.o.mouse       = ''

--mappings
fzf = require('fzf-lua')
local map = vim.keymap.set 
map({ "n" }, '<Leader>f', function() fzf.blines() end,                           { silent = true, noremap = true, desc = "Fuzzy lines"})
map({ 'n' }, '<Leader>d', function() fzf.tags() end,                             { silent = true, noremap = true, desc = "Fuzzy tags"})
map({ 'n' }, '<Leader>g', function() fzf.files() end,                            { silent = true, noremap = true, desc = "Fuzzy files"})
map({ 'n' }, '<Leader>s', function() fzf.git_stash() end,                        { silent = true, noremap = true, desc = "Fuzzy git stash"})
map({ 'n' }, '<Leader>r', function() fzf.grep() end,                             { silent = true, noremap = true, desc = "Fuzzy ripgrep"})
map({ 'v' }, '<Leader>r', function() fzf.grep_visual() end,                      { silent = true, noremap = true, desc = "Fuzzy visual selection ripgrep"})
map({ 'n' }, '<Leader>x', function() fzf.commands() end,                         { silent = true, noremap = true, desc = "Fuzzy neovim commands"})
map({ 'n' }, '<Leader>z', function() fzf.builtin() end,                          { silent = true, noremap = true, desc = "Fuzzy commands"})
map({ 'n' }, '<Leader>h', function() fzf.git_bcommits() end,                     { silent = true, noremap = true, desc = "File history"})
map({ 'n' }, '<Leader>y', function() require('neoclip.fzf')() end,               { silent = true, noremap = true, desc = "Fuzzy yank history"})
map({ 'n' }, 'gm',        function() require('memento').toggle() end,            { silent = true, noremap = true, desc = "Previous files"})
map({ 'i' }, '<C-n>',     function() require('luasnip').jump(1) end,             { silent = true, noremap = true, desc = "Snippet advance"})
map({ 'i' }, '<C-p>',     function() require('luasnip').jump(-1) end,            { silent = true, noremap = true, desc = "Snippet back"})
map({ 'n' }, '<Leader>t', function() require('nvim-tree.api').tree.toggle() end, { silent = true, noremap = true, desc = "File tree toggle"})

--vim.keymap.set({"i", "s"}, "<C-E>", function()
    --if ls.choice_active() then
        --ls.change_choice(1)
    --end
--end, {silent = true})

map = vim.api.nvim_set_keymap 
map('n', '<Leader>~',   "<cmd>source $MYVIMRC<CR>",                              { noremap = true, desc = "Reload vim conf"})
map('n', '<Leader>p',   "<cmd>set paste!<CR>",                                   { noremap = true, desc = "Toggle paste mode"})
map('n', 'ga',          "<Plug>(EasyAlign)",                                     { noremap = true, desc = "Align"})
map('v', 'ga',          "<Plug>(EasyAlign)",                                     { noremap = true, desc = "Align"})
map('n', '<Leader>as',  '<C-w>l',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<Leader>sw',  '<C-w>k',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<Leader>ws',  '<C-w>j',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<Leader>sa',  '<C-w>h',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<Leader>aas', '<C-w>L',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<Leader>ssw', '<C-w>k',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<Leader>wws', '<C-w>J',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<Leader>ssa', '<C-w>h',                                                { noremap = true, desc = "Pane navigation"})
map('n', '<C-k>',       '#',                                                     { noremap = true, desc = "Find under cursor, up"})
map('n', '<C-j>',       '*',                                                     { noremap = true, desc = "Find under cursor, down"})
map('n', '<space>',     '$',                                                     { noremap = true, desc = "Easy end of line"})
map('n', '<backspace>', '^',                                                     { noremap = true, desc = "Easy beginning of line"})
map('n', '<Tab>',       '%',                                                     { noremap = true, desc = "Easy bracket jump"})
map('v', '<C-k>',       '#',                                                     { noremap = true, desc = "Find under cursor, up"})
map('v', '<C-j>',       '*',                                                     { noremap = true, desc = "Find under cursor, down"})
map('v', '<space>',     '$',                                                     { noremap = true, desc = "Easy end of line"})
map('v', '<backspace>', '^',                                                     { noremap = true, desc = "Easy beginning of line"})
map('v', '<Tab>',       '%',                                                     { noremap = true, desc = "Easy bracket jump"})
map('n', 'q:',          ':q',                                                    { noremap = true, desc = "Typo avoidance"})
