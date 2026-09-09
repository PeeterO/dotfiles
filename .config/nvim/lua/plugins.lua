return {
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        event = "VeryLazy",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter", branch = 'main', lazy = false, build = ':TSUpdate' },
            {
                "nvim-treesitter/nvim-treesitter-context",
                event = "VeryLazy",
                ---@type TSContext.UserConfig
                opts = {
                    multiline_threshold = 3,
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
                    node_incremental = "\\",
                    -- scope_incremental = "<cr>",
                    node_decremental = "|",
                },
            },
        },
    },

    {
        'saghen/blink.cmp',
        version = '1.*', -- pinned release ships a prebuilt fuzzy matcher binary
        dependencies = {
            'neovim/nvim-lspconfig',
            'L3MON4D3/LuaSnip',
            { 'saghen/blink.compat', version = '2.*', lazy = true, opts = {} },
            -- nvim-cmp sources without a blink equivalent, used via blink.compat
            'hrsh7th/cmp-nvim-lua',
            'quangnguyen30192/cmp-nvim-tags',
            'hrsh7th/cmp-calc',
            'micangl/cmp-vimtex',
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'none',
                ['<C-e>'] = { 'hide', 'fallback' },
                ['<C-j>'] = { 'select_next', 'fallback' },
                ['<C-k>'] = { 'select_prev', 'fallback' },
                ['`'] = { 'select_and_accept', 'fallback' },
            },
            completion = {
                -- only highlight while cycling with <C-j>/<C-k>; inserting the
                -- preview on every selection triggers treesitter + LSP didChange
                list = { selection = { preselect = true, auto_insert = false } },
                -- keep the menu open when backspacing within a word
                trigger = {
                    show_on_backspace = true,
                    show_on_backspace_in_keyword = true,
                },
            },
            snippets = { preset = 'luasnip' },
            sources = {
                default = {
                    'lsp', 'snippets', 'buffer', 'path',
                    'nvim_lua', 'tags', 'calc', 'vimtex',
                    'projwords',
                },
                providers = {
                    -- score_offset ranks lsp and snippets above the word-ish
                    -- sources (default: lsp 0, snippets -4, buffer -3)
                    lsp = { score_offset = 5 },
                    snippets = {
                        score_offset = 8, -- top level adds -3
                        -- keep snippets out of trigger-char menus (e.g. the
                        -- file listing after accepting a directory)
                        should_show_items = function(ctx)
                            return ctx.trigger.initial_kind ~= 'trigger_character'
                        end,
                    },
                    -- async so slow compat sources never block the menu
                    nvim_lua = { name = 'nvim_lua', module = 'blink.compat.source', async = true },
                    tags = { name = 'tags', module = 'blink.compat.source', async = true, score_offset = -2 },
                    calc = { name = 'calc', module = 'blink.compat.source', async = true },
                    vimtex = { name = 'vimtex', module = 'blink.compat.source', async = true },
                    -- own source: project words scanned once into a cache
                    -- file, see lua/projwords.lua
                    projwords = { name = 'projwords', module = 'projwords', min_keyword_length = 4, score_offset = -3 },
                },
            },
        },
        config = function(_, opts)
            require('blink.cmp').setup(opts)
            require('projwords').setup()

            local lsp = vim.lsp
            lsp.config('*', {capabilities = require('blink.cmp').get_lsp_capabilities()})
            lsp.enable('rust_analyzer')
            lsp.enable('pyright')
            lsp.enable('clangd')
            lsp.enable('texlab')
            lsp.enable('robotframework_ls')
            --lsp.enable('anls')
        end
    },

    {
        'ray-x/lsp_signature.nvim',
        config = function()
            local cfg = {
                always_trigger = true
            }
            require'lsp_signature'.setup(cfg)
        end
    },

    {
        'hiphish/rainbow-delimiters.nvim',
        event = 'BufReadPost',
        config = function()
            require('rainbow-delimiters.setup').setup({
                condition = function(bufnr)
                    local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
                    if buftype ~= '' and buftype ~= 'acwrite' then return false end
                    return vim.treesitter.get_parser(bufnr, nil, { error = false }) ~= nil
                end,
            })
            -- Bug in rainbow-delimiters: get_parser returns nil without throwing
            -- in neovim 0.11+, but lib.attach only checks pcall success, not nil.
            local lib = require('rainbow-delimiters.lib')
            local orig = lib.attach
            lib.attach = function(bufnr) pcall(orig, bufnr) end
        end,
    },

    {'ibhagwan/fzf-lua',
    config = function()
        require('fzf-lua').setup({
            git_icons = false,
            file_icons = false,
            git = {
                status = {
                    -- override status to show only tracked files
                    cmd = "git -c color.status=false --no-optional-locks status --porcelain=v1 --untracked-files=no",
                },
            },
        })
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

        dap.adapters.codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
                command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
                args = { '--port', '${port}' },
            },
        }
        dap.configurations.rust = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }

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
    {
	    'Julian/lean.nvim',
	    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

	    dependencies = {
		    'nvim-lua/plenary.nvim',

		    -- optional dependencies:

		    -- a completion engine
		    --    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

		    -- 'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers
		    -- 'andymass/vim-matchup',          -- for enhanced % motion behavior
		    -- 'andrewradev/switch.vim',        -- for switch support
		    -- 'tomtom/tcomment_vim',           -- for commenting
	    },

	    ---@type lean.Config
	    opts = { -- see below for full configuration options
		    mappings = true,
	    }
    }
}
