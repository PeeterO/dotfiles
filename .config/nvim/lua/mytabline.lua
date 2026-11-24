-- Minimal tabline in the style of nvim-tabline ("1:[name] [+]"), except that
-- tabpages holding only toggleterm terminals are not listed. Numbers are the
-- real tabpage numbers so they keep matching the <M-N> -> Ngt maps.
local M = {}

local function is_toggleterm_tab(tab)
    local bufs = vim.fn.tabpagebuflist(tab)
    for _, b in ipairs(bufs) do
        if vim.bo[b].filetype ~= 'toggleterm' then return false end
    end
    return #bufs > 0
end

function M.render()
    local cur = vim.fn.tabpagenr()
    local s = ''
    for tab = 1, vim.fn.tabpagenr('$') do
        if not is_toggleterm_tab(tab) then
            local buf = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
            local name = vim.fn.fnamemodify(vim.fn.bufname(buf), ':t')
            if name == '' then name = 'No Name' end
            s = s .. '%' .. tab .. 'T'
                .. (tab == cur and '%#TabLineSel#' or '%#TabLine#')
                .. ' ' .. tab .. ':[' .. name .. ']'
                .. (vim.bo[buf].modified and ' [+]' or '') .. ' '
        end
    end
    return s .. '%#TabLineFill#%T'
end

function M.setup()
    _G.mytabline = M.render
    vim.o.tabline = '%!v:lua.mytabline()'
end

return M
