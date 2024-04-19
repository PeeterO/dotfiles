return {
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = { { 'p00f/nvim-ts-rainbow'},
        { 'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require'treesitter-context'.setup{
                max_lines = 3,
                mode = 'topline',
                trim_scope = 'inner'
            }
        end,
    } },
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
                    max_file_lines = 4000, -- Do not enable for files with more than 1000 lines, int
                }
            }
        end
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'neovim/nvim-lspconfig',
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
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            lsp = require'lspconfig'
            lsp.pyright.setup{capabilities = capabilities,}
            lsp.clangd.setup{capabilities = capabilities,}
            lsp.rust_analyzer.setup{capabilities = capabilities,}

            local cmp = require'cmp'
            cmp.setup({
                sources = cmp.config.sources({
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
                        keyword_length = 4
                    },
                    {
                        name = "rg",
                        keyword_length = 4
                    },
                }),
                mapping = {
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"}),
                    ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "s"}),
                    ["\'"] = cmp.mapping.confirm(
                    {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })

        end
    },

    {
        'ray-x/lsp_signature.nvim',
        config = function()
            cfg = {
                always_trigger = true
            }
            require'lsp_signature'.setup(cfg)
        end
    },

    {'ibhagwan/fzf-lua',
    config = function()
        defaults = {
            git_icons = false,
            file_icons = false,
        }
    end
    },

    {
        'windwp/nvim-autopairs',
        config = function()
            require'nvim-autopairs'.setup()
        end
    },

    {'tpope/vim-surround'},

    {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require'nvim-web-devicons'.setup {
                color_icons = true;
                default = true;
            }
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'gruvbox_dark',
                },
                globalstatus = true
            }
        end,
    },

    {'preservim/nerdcommenter'},

    {
        "L3MON4D3/LuaSnip",
        dependencies = {"rafamadriz/friendly-snippets"},
        -- follow latest release.
        tag = "v2.2.0", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        --run = "make install_jsregexp",
        
        config = function()
            require('luasnip').setup()

            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },

    {'jremmen/vim-ripgrep'},

    {'stefandtw/quickfix-reflector.vim'},

    {'makerj/vim-pdf'},

    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            vim.o.background = "dark" -- or "light" for light mode
            vim.cmd([[colorscheme gruvbox]])
        end
    },

    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
             {'ibhagwan/fzf-lua'},
        },
        config = function()
            require('neoclip').setup({
                keys = {
                    fzf = {
                        paste = 'ctrl-b',
                        paste_behind = 'ctrl-y'
                    }
                }
            })
        end,
    },

    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require'nvim-tree'.setup({
                on_attach = on_attach,
            })
        end
    },

    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                 -- defaults, for now
            }
        end
    },

    {
        'junegunn/vim-easy-align',
        config = function()
        
        end
    },

    {
        'gennaro-tedesco/nvim-peekup',
        config = function()
            require('nvim-peekup.config').on_keystroke["delay"] = ''
        end
    },

    {
        'gaborvecsei/memento.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
    },

    {
		'mgnsk/autotabline.nvim',
		config = function()
			require("autotabline").setup()
		end,
    },

    { 'LudoPinelli/comment-box.nvim' },

    { 'akinsho/toggleterm.nvim', config = true },

    { 'jbyuki/nabla.nvim' },

    { 'adelarsq/vim-matchit' },

    { 'mbbill/undotree' },
}
