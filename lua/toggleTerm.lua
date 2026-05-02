-- INFO: version 2.1
-- From my nvim/lua/custom dir

---@class M
---@field M.state table
---@field M.state.floating table -- Contains buf-/winNr
---@field M.state.floating.buf integer
---@field M.state.floating.win integer
local M = {}

M.state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

---@class toggle_float_opts
---@field x number -- %width,  between 0.0 and 1.0
---@field y number -- %height,  between 0.0 and 1.0
---@field buf integer
---@field border string -- bordertype

---@param opts toggle_float_opts
---@return table<integer, integer>
function M.toggle_float(opts)
    opts = opts or {}
    local x = opts.x or 0.9
    local y = opts.y or 0.9

    -- TODO: Understand (and fix?) this part
    local buf
    if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
        buf = M.state.floating.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- buffer be like
    end

    local win_conf = {
        relative = "editor",
        width = math.floor(vim.o.columns * x),
        height = math.floor(vim.o.lines * y),
        col = math.floor(vim.o.columns * ((1 - x) / 2)),
        row = math.floor(vim.o.lines * ((1 - y) / 2)),
        border = opts.border or "double",
    }
    local win = vim.api.nvim_open_win(buf, true, win_conf)

    return { buf = buf, win = win }
end

function M.toggle_term(opts)
    if vim.api.nvim_win_is_valid(M.state.floating.win) then -- if visible
        vim.api.nvim_win_hide(M.state.floating.win) -- hide
    else
        M.state.floating = M.toggle_float({
            x = opts.x or 0.8,
            y = opts.y or 0.8,
            buf = M.state.floating.buf,
            border = opts.border or "rounded",
        }) -- tells it to use the same buffer
        if vim.bo[M.state.floating.buf].buftype ~= "terminal" then -- if buftype isn't terminal
            vim.cmd.terminal() -- enter terminal
        end
    end
    vim.cmd("startinsert")
end

function M.setup() -- empty (for now...)
    -- TODO: Stop `M.setup()` being empty (for now...)

    -- vim.api.nvim_create_user_command("Termtoggle", M.toggle_term, {})

    -- TODO: set keymap in .setup()
end

return M

-- TODO: ideas of other options:
--
-- map('n', '<leader>tv', function() require('custom.toggle_term').verti() end, { desc = 'Vertical terminal' })
-- map('n', '<leader>th', function() require('custom.toggle_term').horiz() end, { desc = 'Horizontal terminal' })
-- map({ 'n', 't' }, '<M-t>', function() require('custom.toggle_term').float() end, { desc = 'Toggle Term' })
-- map({ 'n', 't' }, '<C-/>', function() require('custom.toggle_term').horiz() end, { desc = 'Toggle HTerm' })

-- TEST: DEBUG SCRATCH
-- print("Foobar.nvim file `foobar.lua` got HELLA loaded")
