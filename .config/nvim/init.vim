"""""""""""""""""""""""""" plugin loading """"""""""""""""""""""""""


call plug#begin('~/.config/nvim/plugins')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'p00f/nvim-ts-rainbow'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'

Plug 'neovim/nvim-lspconfig'

Plug 'ray-x/lsp_signature.nvim'

Plug 'junegunn/fzf'

Plug 'junegunn/fzf.vim'

Plug 'windwp/nvim-autopairs'

Plug 'tpope/vim-surround'

Plug 'hoob3rt/lualine.nvim'

Plug 'preservim/nerdcommenter'

Plug 'norcalli/snippets.nvim'

Plug 'jremmen/vim-ripgrep'

Plug 'stefandtw/quickfix-reflector.vim'

Plug 'makerj/vim-pdf'

call plug#end()


"""""""""""""""""""Plugin setups/confs"""""""""""""""""""""""""""""""""

"Treesitter
lua <<EOF
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
    enable = true
  }
}
EOF

"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()


"TS-rainbow
lua <<EOF
require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true,
    --extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  }
}
EOF


"fzf
command! -bang -nargs=* Rgf call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)


"nvim-lspconfig
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.rls.setup{}
EOF

lua << EOF
local cmp = require "cmp"
cmp.setup(
	{
	sources = {
		{name = "nvim_lsp"},
		{name = "buffer"},
		{name = "nvim_lua"},
		{name = "path"}
	},
	mapping = {
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"}),
		["<CR>"] = cmp.mapping.confirm(
		{
		behavior = cmp.ConfirmBehavior.Replace,
		select = true
		}
		)
	}
	}
)
EOF

"lsp-signature
lua <<EOF
require'lsp_signature'.on_attach()
EOF


"Auto-pairs
lua << EOF
require('nvim-autopairs').setup()
EOF


"Lualine
lua <<EOF
require('lualine').setup()
options = {theme = 'gruvbox'}
EOF



"Snippets
lua <<EOF
require('snippet_conf')
EOF

inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>
inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>



"""""""""""""""""""""Ergonomics confs"""""""""""""""""""""""""""

" sets/lets
let mapleader = ","
set number
set updatetime=300
set smartindent
set noexpandtab
set tabstop=4
set shiftwidth=4

" mappings
nnoremap <Leader>d  :Tags<CR>
nnoremap <Leader>f  :BLines<CR>
nnoremap <Leader>g  :Files<CR>
nnoremap <Leader>r  :Rgf<CR>
nnoremap <Leader>b  :w<CR> :make -r all<CR>
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>as  <C-w>l
nnoremap <Leader>sw  <C-w>k
nnoremap <Leader>ws  <C-w>j
nnoremap <Leader>sa  <C-w>h
nnoremap <Leader>aas  <C-w>L
nnoremap <Leader>ssw  <C-w>K
nnoremap <Leader>wws  <C-w>J
nnoremap <Leader>ssa  <C-w>H
nnoremap <C-k> #
nnoremap <C-j> *
noremap <space> $
noremap <backspace> ^
noremap <Tab> %
noremap <S-CR> <CR>
noremap <C-up> :cp<CR>
noremap <C-down> :cn<CR>
noremap <Leader>cc :CommentToggle<CR>
nnoremap <Leader>ma :set mouse=a<CR>
nnoremap <Leader>mm :set mouse=""<CR>
