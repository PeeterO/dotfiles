-- scan-once project word completion for blink.cmp: words are harvested
-- into a sorted cache file once per project and served straight off the
-- file with a look(1)-style binary search, so even multi-million-word
-- lists cost nvim no memory
local M = {}

local function dict_file()
    local root = vim.fs.root(vim.fn.getcwd(), '.git')
    if not root or root == vim.env.HOME then return nil end
    local dict = vim.fn.stdpath('cache') .. '/project-words/'
        .. vim.fn.sha256(root):sub(1, 16) .. '.txt'
    return dict, root
end

function M.scan(force)
    local dict, root = dict_file()
    if not dict then return end
    local dir = vim.fn.fnamemodify(dict, ':h')
    vim.fn.mkdir(dir, 'p')
    if not force and vim.fn.getfsize(dict) > 0 then return end
    local tmp = dict .. '.tmp'
    -- a fresh .tmp means another nvim is already scanning
    if os.time() - vim.fn.getftime(tmp) < 600 then return end
    -- LC_ALL=C so sort's order matches lua's byte-wise compares; sort is
    -- memory-bounded with disk-backed temp (/tmp is tmpfs); awk drops
    -- blob-like tokens
    local cmd = string.format(
        [[rg -o --no-filename --hidden -g '!.git' --max-filesize 1M '[A-Za-z_]\w{3,}' %s | awk 'length($0) <= 48' | LC_ALL=C sort -u -S 64M -T %s > %s && mv %s %s]],
        vim.fn.shellescape(root), vim.fn.shellescape(dir),
        vim.fn.shellescape(tmp), vim.fn.shellescape(tmp), vim.fn.shellescape(dict)
    )
    vim.system({ 'sh', '-c', cmd }, {})
end

function M.setup()
    M.scan(false)
    vim.api.nvim_create_user_command('ProjectWordsRefresh',
        function() M.scan(true) end, {})
end

-- offset of the first line >= prefix in a C-sorted file. lo is always a
-- line start, and every line ending before lo compares < prefix
local function bisect(f, size, prefix)
    local lo, hi = 0, size
    while hi - lo > 64 do
        local mid = math.floor((lo + hi) / 2)
        f:seek('set', mid)
        f:read('*l') -- align to the line start after mid
        local pos = f:seek()
        if pos >= hi then
            hi = mid
        else
            local line = f:read('*l')
            if line and line < prefix then
                lo = f:seek()
            else
                hi = pos
            end
        end
    end
    f:seek('set', lo)
    while true do
        local pos = f:seek()
        local line = f:read('*l')
        if not line then return size end
        if line >= prefix then return pos end
    end
end

-- blink.cmp source interface
function M.new()
    return setmetatable({}, { __index = M })
end

function M:get_completions(ctx, callback)
    local items = {}
    local prefix = ctx.line:sub(1, ctx.cursor[2]):match('[%w_]+$')
    local dict = dict_file()
    local f = prefix and dict and io.open(dict, 'rb')
    if f then
        local size = f:seek('end')
        f:seek('set', bisect(f, size, prefix))
        for _ = 1, 300 do
            local line = f:read('*l')
            if not line or line:sub(1, #prefix) ~= prefix then break end
            items[#items + 1] = {
                label = line,
                insertText = line,
                kind = vim.lsp.protocol.CompletionItemKind.Text,
            }
        end
        f:close()
    end
    callback({ is_incomplete_forward = true, is_incomplete_backward = true, items = items })
end

return M
