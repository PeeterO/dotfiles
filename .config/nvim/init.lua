require'packer-init' -- load plugins

--settings
vim.g.mapleader = ','
vim.o.number = true
vim.o.updatetime = 300
--vim.o.smartintent = true
vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse =

--mappings
vim.api.nvim_set_keymap('n', '<Leader>d', "<cmd>lua require('fzf-lua').tags()<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>f', "<cmd>lua require('fzf-lua').blines()<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>g', "<cmd>lua require('fzf-lua').files()<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>r', "<cmd>lua require('fzf-lua').grep()<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>y', "<cmd>lua require('neoclip.fzf')()<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>t', ":NvimTreeToggle<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>b', ':w<CR> :make -r all<CR>', {noremap = true})
vim.api.nvim_set_keymap('i', '<c-k>', "<cmd>lua return require'snippets'.expand_or_advance(1)<CR>", {noremap = true})
vim.api.nvim_set_keymap('i', '<c-j>', "<cmd>lua return require'snippets'.advance_snippet(-1)<CR>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>h', ":DiffviewFileHistory %<CR>", {noremap = true})

vim.api.nvim_set_keymap('n', '<Leader>as', '<C-w>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>sw', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>ws', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>sa', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>aas', '<C-w>L', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>ssw', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>wws', '<C-w>J', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>ssa', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '#', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-j>', '*', {noremap = true})
vim.api.nvim_set_keymap('n', '<space>', '$', {noremap = true})
vim.api.nvim_set_keymap('n', '<backspace>', '^', {noremap = true})
vim.api.nvim_set_keymap('n', '<Tab>', '%', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-k>', '#', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-j>', '*', {noremap = true})
vim.api.nvim_set_keymap('v', '<space>', '$', {noremap = true})
vim.api.nvim_set_keymap('v', '<backspace>', '^', {noremap = true})
vim.api.nvim_set_keymap('v', '<Tab>', '%', {noremap = true})
vim.api.nvim_set_keymap('n', 'S-CR', '<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'C-up', 'cp<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'C-down', 'cn<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>cc', ':CommentToggle<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'q:', ':q', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>~', ':source $MYVIMRC<CR>', {noremap = true})
