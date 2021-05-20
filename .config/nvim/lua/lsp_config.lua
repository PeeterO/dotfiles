local api = vim.api
local util = vim.lsp.util
local callbacks = vim.lsp.callbacks
local log = vim.lsp.log

---- open everything in new tab
--local location_callback = function(_, method, result)
    --if result == nil or vim.tbl_isempty(result) then
        --local _ = log.info() and log.info(method, "No location found")
        --return nil
    --end

    ---- create a new tab and save bufnr
    --api.nvim_command("tabnew")
    --local buf = api.nvim_get_current_buf()

    --if vim.tbl_islist(result) then
        --util.jump_to_location(result[1])
        --if #result > 1 then
            --util.set_qflist(util.locations_to_items(result))
            --api.nvim_command("copen")
        --end
    --else
        --local buf = api.nvim_get_current_buf()
    --end

    ---- remove the empty buffer created with tabnew
    --api.nvim_command(buf .. "bd")
--end

--local on_attach = function(client)
    --require "completion".on_attach(client)
--end

local lsp = require "lspconfig"

lsp.clangd.setup {on_attach = on_attach}
lsp.pyright.setup {on_attach = on_attach}

--callbacks["textDocument/declaration"] = location_callback
--callbacks["textDocument/definition"] = location_callback
--callbacks["textDocument/typeDefinition"] = location_callback
--callbacks["textDocument/implementation"] = location_callback

vim.api.nvim_exec(
    [[
command LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients())
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
]],
    true
)

--set completeopt=menuone,noinsert,noselect

vim.api.nvim_set_option('completeopt', 'menuone,noinsert')
