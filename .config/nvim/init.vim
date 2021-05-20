" plugins
call plug#begin('~/.config/nvim/plugins')

Plug 'junegunn/vim-easy-align'

Plug 'junegunn/fzf'

Plug 'junegunn/fzf.vim'

"Plug 'jiangmiao/auto-pairs'

Plug 'cohama/lexima.vim'

Plug 'luochen1990/rainbow'

Plug 'tpope/vim-sensible'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-fugitive'

Plug 'itchyny/lightline.vim'

Plug 'neovim/nvim-lspconfig'

"Plug 'nvim-lua/completion-nvim'

"Plug 'nvim-lua/diagnostic-nvim'	

Plug 'preservim/nerdcommenter'

Plug 'preservim/nerdtree'

"Plug 'jremmen/vim-ripgrep'

Plug 'stefandtw/quickfix-reflector.vim'

Plug 'makerj/vim-pdf'

Plug 'https://github.com/vim-syntastic/syntastic'

Plug 'hrsh7th/nvim-compe'

Plug 'hrsh7th/vim-vsnip'

"Plug 'prabirshrestha/vim-lsp'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'SirVer/ultisnips'

Plug 'norcalli/snippets.nvim'



call plug#end()

lua require("lsp_config")


let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true
let g:compe.snippetSupport=v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true

" NOTE: Order is important. You can't lazy loading lexima.vim.
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

set completeopt=menuone,noselect



" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


lua require'snippets'.use_suggested_mappings()

" This variant will set up the mappings only for the *CURRENT* buffer.
lua require'snippets'.use_suggested_mappings(true)

" There are only two keybindings specified by the suggested keymappings, which is <C-k> and <C-j>
" They are exactly equivalent to:

" <c-k> will either expand the current snippet at the word or try to jump to
" the next position for the snippet.
inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>

" <c-j> will jump backwards to the previous field.
" If you jump before the first field, it will cancel the snippet.
inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>


" mappings
let mapleader = ","
nnoremap <Leader>d  :Tags<CR>
nnoremap <Leader>f  :Lines<CR>
nnoremap <Leader>g  :Files<CR>
nnoremap <Leader>r  :Rg<CR>
nnoremap <Leader>b  :w<CR> :make -r all<CR>
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>w  :wa<CR>
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

" sets/lets
let g:rainbow_active = 1
set number
set updatetime=300
