require'packer-init' -- load plugins

--settings
vim.g.mapleader = ','
vim.o.number = true
vim.o.updatetime = 300
vim.o.timeoulen = 300
vim.o.ttimeout = 300
vim.o.smartindent = true
vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = ''

--mappings
local map = vim.api.nvim_set_keymap 
map('n', '<Leader>d',	"<cmd>lua require('fzf-lua').tags()<CR>",						{noremap = true})
map('n', '<Leader>f',	"<cmd>lua require('fzf-lua').blines()<CR>", 					{noremap = true})
map('n', '<Leader>g',	"<cmd>lua require('fzf-lua').files()<CR>",						{noremap = true})
map('n', '<Leader>r',	"<cmd>lua require('fzf-lua').grep()<CR>",						{noremap = true})
map('n', '<Leader>y',	"<cmd>lua require('neoclip.fzf')()<CR>",						{noremap = true})
map('n', '<Leader>t',	"<cmd>NvimTreeToggle<CR>",										{noremap = true})
map('n', '<Leader>b',	'<cmd>w<CR> :make -r all<CR>',									{noremap = true})
map('i', '<c-k>', 		"<cmd>lua return require'snippets'.expand_or_advance(1)<CR>", 	{noremap = true})
map('i', '<c-j>', 		"<cmd>lua return require'snippets'.advance_snippet(-1)<CR>", 	{noremap = true})
map('n', '<Leader>h', 	"<cmd>DiffviewFileHistory %<CR>",								{noremap = true})
map('n', '<Leader>cc', 	"<cmd>CommentToggle<CR>", 										{noremap = true})
map('n', '<Leader>~', 	"<cmd>source $MYVIMRC<CR>",										{noremap = true})
map('n', '<Leader>p', 	"<cmd>set paste!<CR>",											{noremap = true})

map('n', '<Leader>as',	'<C-w>l',														{noremap = true})
map('n', '<Leader>sw',	'<C-w>k',														{noremap = true})
map('n', '<Leader>ws',	'<C-w>j',														{noremap = true})
map('n', '<Leader>sa',	'<C-w>h',														{noremap = true})
map('n', '<Leader>aas', '<C-w>L',														{noremap = true})
map('n', '<Leader>ssw', '<C-w>k',														{noremap = true})
map('n', '<Leader>wws', '<C-w>J',														{noremap = true})
map('n', '<Leader>ssa', '<C-w>h',														{noremap = true})
map('n', '<C-k>',		'#',															{noremap = true})
map('n', '<C-j>',		'*',															{noremap = true})
map('n', '<space>',		'$',															{noremap = true})
map('n', '<backspace>', '^',															{noremap = true})
map('n', '<Tab>',		'%',															{noremap = true})
map('v', '<C-k>',		'#',															{noremap = true})
map('v', '<C-j>',		'*',															{noremap = true})
map('v', '<space>',		'$',															{noremap = true})
map('v', '<backspace>', '^',															{noremap = true})
map('v', '<Tab>',		'%',															{noremap = true})
map('n', 'q:',			':q',															{noremap = true})
