return require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'gruvbox-community/gruvbox'


	use 'nvim-treesitter/nvim-treesitter'

	use 'p00f/nvim-ts-rainbow'

	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-nvim-lua'
	use 'hrsh7th/cmp-path'

	use 'neovim/nvim-lspconfig'

	use 'ray-x/lsp_signature.nvim'

	use 'ibhagwan/fzf-lua'

	use 'windwp/nvim-autopairs'

	use 'tpope/vim-surround'

	use 'hoob3rt/lualine.nvim'

	use 'preservim/nerdcommenter'

	use 'norcalli/snippets.nvim'

	use 'jremmen/vim-ripgrep'

	use 'stefandtw/quickfix-reflector.vim'

	use 'makerj/vim-pdf'

	use {
		"AckslD/nvim-neoclip.lua",
		requires = {
			-- you'll need at least one of these
			-- {'nvim-telescope/telescope.nvim'},
			 {'ibhagwan/fzf-lua'},
		},
		config = function()
			require('neoclip').setup()
		end,
	}

end)
