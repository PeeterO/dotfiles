require'packer-init' -- load plugins

--settings
vim.g.mapleader = ','
vim.o.number = true
vim.o.updatetime = 300
vim.o.ttimeout = 300
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.smartindent = true
vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = ''

--mappings
local map = vim.api.nvim_set_keymap 
map('n', '<Leader>d',	"<cmd>lua require('fzf-lua').tags()<CR>",						{noremap = true, desc = "Fuzzy tags"})
map('n', '<Leader>f',	"<cmd>lua require('fzf-lua').blines()<CR>", 					{noremap = true, desc = "Fuzzy lines"})
map('n', '<Leader>g',	"<cmd>lua require('fzf-lua').files()<CR>",						{noremap = true, desc = "Fuzzy files"})
map('n', '<Leader>s',	"<cmd>lua require('fzf-lua').git_stash()<CR>",					{noremap = true, desc = "Fuzzy git stash"})
map('n', '<Leader>r',	"<cmd>lua require('fzf-lua').grep()<CR>",						{noremap = true, desc = "Fuzzy ripgrep"})
map('v', '<Leader>r',	"<cmd>lua require('fzf-lua').grep_visual()<CR>",				{noremap = true, desc = "Fuzzy visual selection ripgrep"})
map('n', '<Leader>y',	"<cmd>lua require('neoclip.fzf')()<CR>",						{noremap = true, desc = "Fuzzy yank history"})
map('n', '<Leader>t',	"<cmd>NvimTreeToggle<CR>",										{noremap = true, desc = "File tree toggle"})
map('n', '<Leader>b',	'<cmd>w<CR> :make -r all<CR>',									{noremap = true, desc = "Run make"})
map('i', '<c-k>', 		"<cmd>lua return require'snippets'.expand_or_advance(1)<CR>", 	{noremap = true, desc = "Snippet continue"})
map('i', '<c-j>', 		"<cmd>lua return require'snippets'.advance_snippet(-1)<CR>", 	{noremap = true, desc = "Snipper reverse"})
map('n', '<Leader>h', 	"<cmd>lua require('fzf-lua').git_bcommits()<CR><CR>",			{noremap = true, desc = "File history"})
map('n', '<Leader>cc', 	"<cmd>CommentToggle<CR>", 										{noremap = true, desc = "Toggle comment"})
map('n', '<Leader>~', 	"<cmd>source $MYVIMRC<CR>",										{noremap = true, desc = "Reload vim conf"})
map('n', '<Leader>p', 	"<cmd>set paste!<CR>",											{noremap = true, desc = "Toggle paste mode"})

map('n', '<Leader>as',	'<C-w>l',														{noremap = true, desc = "Pane navigation"})
map('n', '<Leader>sw',	'<C-w>k',														{noremap = true, desc = "Pane navigation"})
map('n', '<Leader>ws',	'<C-w>j',														{noremap = true, desc = "Pane navigation"})
map('n', '<Leader>sa',	'<C-w>h',														{noremap = true, desc = "Pane navigation"})
map('n', '<Leader>aas', '<C-w>L',														{noremap = true, desc = "Pane navigation"})
map('n', '<Leader>ssw', '<C-w>k',														{noremap = true, desc = "Pane navigation"})
map('n', '<Leader>wws', '<C-w>J',														{noremap = true, desc = "Pane navigation"})
map('n', '<Leader>ssa', '<C-w>h',														{noremap = true, desc = "Pane navigation"})
map('n', '<C-k>',		'#',															{noremap = true, desc = "Find under cursor, up"})
map('n', '<C-j>',		'*',															{noremap = true, desc = "Find under cursor, down"})
map('n', '<space>',		'$',															{noremap = true, desc = "Easy end of line"})
map('n', '<backspace>', '^',															{noremap = true, desc = "Easy beginning of line"})
map('n', '<Tab>',		'%',															{noremap = true, desc = "Easy bracket jump"})
map('v', '<C-k>',		'#',															{noremap = true, desc = "Find under cursor, up"})
map('v', '<C-j>',		'*',															{noremap = true, desc = "Find under cursor, down"})
map('v', '<space>',		'$',															{noremap = true, desc = "Easy end of line"})
map('v', '<backspace>', '^',															{noremap = true, desc = "Easy beginning of line"})
map('v', '<Tab>',		'%',															{noremap = true, desc = "Easy bracket jump"})
map('n', 'q:',			':q',															{noremap = true, desc = "Typo avoidance"})
