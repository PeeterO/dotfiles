require "nvim-tree-on-attach"

return require('packer').startup(function()

	use 'wbthomason/packer.nvim' --self-manage

	use {
		'nvim-treesitter/nvim-treesitter',
		requires = { 'p00f/nvim-ts-rainbow', opt = true},
		config = function()
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
					enable = false --is buggy
				},
				rainbow = {
					enable = true,
					extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
					max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
				}
			}
		end
	}

	use {
		'hrsh7th/nvim-cmp',
		config = function()
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
		end
	}

	use 'hrsh7th/cmp-buffer'
	
	use 'hrsh7th/cmp-nvim-lsp'

	use 'hrsh7th/cmp-nvim-lua'

	use 'hrsh7th/cmp-path'

	use {
		'neovim/nvim-lspconfig',
		config = function()
			conf = require'lspconfig'
			conf.pyright.setup{}
			conf.clangd.setup{}
			conf.rls.setup{}
		end
	}

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

	use {
		'windwp/nvim-autopairs',
		config = function()
			require'nvim-autopairs'.setup()
		end
	}

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

	use {
		'norcalli/snippets.nvim',
		config = function()
			require'snippet_conf'
		end
	}

	use 'jremmen/vim-ripgrep'

	use 'stefandtw/quickfix-reflector.vim'

	use 'makerj/vim-pdf'

	use {
		"ellisonleao/gruvbox.nvim",
		config = function()
			vim.o.background = "dark" -- or "light" for light mode
			vim.cmd([[colorscheme gruvbox]])
		end
	}

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
				on_attach = on_attach,
			})
		end
	}

	-- Lua

	use {
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup {
				 -- defaults, for now
			}
		end
	}

	use {
		'junegunn/vim-easy-align',
		config = function()
		
		end
	}
	use {
		'gennaro-tedesco/nvim-peekup',
		config = function()
			require('nvim-peekup.config').on_keystroke["delay"] = ''
		end
	}

	use {
		'gaborvecsei/memento.nvim',
		requires = {
			'nvim-lua/plenary.nvim'
		},
	}

end)
