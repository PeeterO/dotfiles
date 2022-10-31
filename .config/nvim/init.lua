require'packer-init'

require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		custom_captures = {
			-- Highlight the @foo.bar capture group with the "Identifier" highlight group.
			-- ["foo.bar"] = "Identifier",
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = false
	},
	rainbow = {
		enable = true,
		extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
		max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
	}
}

local cmp = require'cmp'
cmp.setup(
	{
		sources = {
			{name = "nvim_lsp"},
			{name = "buffer"},
			{name = "nvim_lua"},
			{name = "path"}
		},
		mapping = {
			['<C-e>'] = cmp.mapping.abort(),
			["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"}),
			["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "s"}),
			["<CR>"] = cmp.mapping.confirm(
				{
					behavior = cmp.ConfirmBehavior.Replace,
					select = true
				}
			),
		}
	}
)


require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.rls.setup{}
require'nvim-autopairs'.setup()
require'snippet_conf'

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.g.mapleader = ','
vim.o.number = true
vim.o.updatetime = 300
--vim.o.smartintent = true
vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse =


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
