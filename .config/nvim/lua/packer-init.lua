require "nvim-tree-on-attach"

return require('packer').startup(function()

    use 'wbthomason/packer.nvim' --self-manage

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = { 'p00f/nvim-ts-rainbow'},
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
        requires = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'quangnguyen30192/cmp-nvim-tags',
            'hrsh7th/cmp-calc',
            'ray-x/cmp-treesitter',
            'uga-rosa/cmp-dictionary',
            'lukas-reineke/cmp-rg',
            'saadparwaiz1/cmp_luasnip'
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                sources = {
                    {name = "nvim_lsp"},
                    {name = "buffer"},
                    {name = "nvim_lua"},
                    {name = "path"},
                    {name = "tags"},
                    {name = "calc"},
                    {name = "treesitter"},
                    {
                        name = "luasnip",
                        option = {show_autosnippets = true}
                    },
                    {
                        name = "dictionary",
                        keyword_length = 2
                    },
                    {
                        name = "rg",
                        keyword_length = 4
                    },
                },
                mapping = {
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"}),
                    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "s"}),
                    ["<CR>"] = cmp.mapping.confirm(
                    {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }),
                }
            })
        end
    }


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

    use({
        "L3MON4D3/LuaSnip",
        requires = {"rafamadriz/friendly-snippets"},
        -- follow latest release.
        tag = "v2.2.0", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        --run = "make install_jsregexp",
        
        config = function()
            require('luasnip').setup()

            require("luasnip.loaders.from_vscode").lazy_load()
        end
    })

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

    use {
		'mgnsk/autotabline.nvim',
		config = function()
			require("autotabline").setup()
		end,
    }

end)
