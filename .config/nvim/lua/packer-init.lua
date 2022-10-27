return require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	use 'nvim-treesitter/nvim-treesitter'

	use 'p00f/nvim-ts-rainbow'

	use 'hrsh7th/nvim-cmp'

	use 'hrsh7th/cmp-buffer'
	
	use 'hrsh7th/cmp-nvim-lsp'

	use 'hrsh7th/cmp-nvim-lua'

	use 'hrsh7th/cmp-path'

	use 'neovim/nvim-lspconfig'

	use {
		'ray-x/lsp_signature.nvim',
		config = function()
			cfg = {
				always_trigger = true
			}
			require'lsp_signature'.setup(cfg)
		end
	}

	use 'ibhagwan/fzf-lua'

	use 'windwp/nvim-autopairs'

	use 'tpope/vim-surround'

	use {
		'kyazdani42/nvim-web-devicons',
		config = function()
			require'nvim-web-devicons'.setup {
				color_icons = true;
				default = true;
			}
		end,
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = false,
					theme = 'gruvbox_dark',
				},
				globalstatus = true
			}
		end,
	}

	use 'preservim/nerdcommenter'

	use 'norcalli/snippets.nvim'

	use 'jremmen/vim-ripgrep'

	use 'stefandtw/quickfix-reflector.vim'

	use 'makerj/vim-pdf'

	use "ellisonleao/gruvbox.nvim"

	use {
		"AckslD/nvim-neoclip.lua",
		requires = {
			 {'ibhagwan/fzf-lua'},
		},
		config = function()
			require('neoclip').setup()
		end,
	}

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			require'nvim-tree'.setup({
				view = {
					mappings = {
						list = {
							{key = "u", action = "dir_up"}
						}
					}
				}
			})
		end
	}

	use {
		'sindrets/diffview.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			local actions = require("diffview.actions")
			require'diffview'.setup({
				keymaps = {
					file_history_panel = {
						["q"] = ":tabclose<CR>",
					},
					view = {
						["q"] = ":tabclose<CR>",
					}
				}
			})
		end
	}

end)
