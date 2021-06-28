"""""""""""""""""""""""""" plugin loading """"""""""""""""""""""""""


call plug#begin('~/.config/nvim/plugins')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'p00f/nvim-ts-rainbow'

Plug 'hrsh7th/nvim-compe'

Plug 'neovim/nvim-lspconfig'

Plug 'ray-x/lsp_signature.nvim'

Plug 'junegunn/fzf'

Plug 'junegunn/fzf.vim'

Plug 'windwp/nvim-autopairs'

Plug 'blackCauldron7/surround.nvim'

Plug 'hoob3rt/lualine.nvim'

Plug 'terrortylor/nvim-comment'

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


"nvim-compe 
set completeopt=menuone,noselect
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })


"nvim-lspconfig
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.rls.setup{}
EOF


"lsp-signature
lua <<EOF
require'lsp_signature'.on_attach()
EOF


"Auto-pairs
lua << EOF
require('nvim-autopairs').setup()
EOF


"Surround
lua <<EOF
require"surround".setup{}
EOF


"Lualine
lua <<EOF
require('lualine').setup()
options = {theme = 'gruvbox'}
EOF


"nvim-comment
lua <<EOF
require('nvim_comment').setup()
EOF


"Snippets
lua <<EOF
require('snippets').use_suggested_mappings(true)
EOF
inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>
inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>



"""""""""""""""""""""Ergonomics confs"""""""""""""""""""""""""""

" sets/lets
set number
set updatetime=300
let mapleader = ","

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
