return {
    {
        {
            "MeanderingProgrammer/treesitter-modules.nvim",
            event = "VeryLazy",
            dependencies = {
                { "nvim-treesitter/nvim-treesitter", branch = 'main', lazy = false },
                { 'hiphish/rainbow-delimiters.nvim'},
                {
                    "nvim-treesitter/nvim-treesitter-context",
                    event = "VeryLazy",
                    ---@type TSContext.UserConfig
                    opts = {
                        multiline_threshold = 3, -- Maximum number of lines to show for a single context
                    },
                },
            },
            ---@module 'treesitter-modules'
            ---@type ts.mod.UserConfig
            opts = {
                auto_install = true,
                ignore_install = {
                    "gitcommit",
                },
                highlight = {
                    enable = true,
                    disable = function(ctx)
                        local bufsize = vim.api.nvim_buf_get_offset(ctx.buf, vim.api.nvim_buf_line_count(ctx.buf))
                        if bufsize > 256 * 1024 then
                            return true
                        end
                    end,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        --init_selection = "<cr>",
                        node_incremental = "<tab>",
                        scope_incremental = "<cr>",
                        node_decremental = "<s-tab>",
                    },
                },
            },
        },
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
            'saadparwaiz1/cmp_luasnip',
            'micangl/cmp-vimtex',
        },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            lsp = vim.lsp
            lsp.config('*', {capabilities = capabilities})
            lsp.enable('rust_analyzer')
            lsp.enable('pyright')
            lsp.enable('clangd')
            lsp.enable('texlab')
            lsp.enable('robotframework_ls')

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
                    {name = "vimtex"},
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

    {'cohama/lexima.vim'},

    {'tpope/vim-surround',
        dependencies = 'tpope/vim-repeat'},

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
                },
                globalstatus = true
            }
        end,
    },

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

    {
        'stevearc/quicker.nvim',
        config = function()
            require("quicker").setup({
                keys = {
                    {
                        ">",
                        function()
                            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                        end,
                        desc = "Expand quickfix context",
                    },
                    {
                        "<",
                        function()
                            require("quicker").collapse()
                        end,
                        desc = "Collapse quickfix context",
                    },
                },
            })
        end,
        event = "FileType qf",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {},
    },

    {'makerj/vim-pdf'},

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

    { 'mfussenegger/nvim-dap',
    dependencies = {{"rcarriga/nvim-dap-ui",
    dependencies = {{"nvim-neotest/nvim-nio"}},
    config = function()
        require("dapui").setup()
    end}},

    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = vim.fn.stdpath('data').. '/mason/bin/OpenDebugAD7',
        }
        dap.configurations.python = {
            {
                type = 'python';
                request = 'launch';
                name = "Launch file";
                program = "${file}";
                pythonPath = function()
                    return '/usr/bin/python'
                end;
            },
        }
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopAtEntry = true,
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.after.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.after.event_exited.dapui_config = function()
            dapui.close()
        end
    end
},

    {
        'williamboman/mason.nvim',
        config = function()
            require("mason").setup()
        end
    },
	{
		"lervag/vimtex",
		lazy = false,     -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here
		end
	},

    {'jbyuki/venn.nvim'},

    {'petertriho/nvim-scrollbar',
        config = function()
            require("scrollbar").setup()
        end
    },

    {
        'Civitasv/cmake-tools.nvim',
        opts = {}, 
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            --{
                --"<leader>xx",
                --"<cmd>Trouble diagnostics toggle<cr>",
                --desc = "Diagnostics (Trouble)",
            --},
            --{
                --"<leader>xX",
                --"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                --desc = "Buffer Diagnostics (Trouble)",
            --},
            --{
                --"<leader>cs",
                --"<cmd>Trouble symbols toggle focus=false<cr>",
                --desc = "Symbols (Trouble)",
            --},
            --{
                --"<leader>cl",
                --"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                --desc = "LSP Definitions / references / ... (Trouble)",
            --},
            --{
                --"<leader>xL",
                --"<cmd>Trouble loclist toggle<cr>",
                --desc = "Location List (Trouble)",
            --},
            --{
                --"<leader>c",
                --"<cmd>Trouble qflist toggle<cr>",
                --desc = "Quickfix List (Trouble)",
            --},
        },
    },
}
