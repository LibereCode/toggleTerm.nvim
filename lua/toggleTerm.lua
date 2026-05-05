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
---@field x? number -- %width,  between 0.0 and 1.0
---@field y? number -- %height,  between 0.0 and 1.0
---@field border? string -- bordertype

---@param opts toggle_float_opts
--- merging `M.toggle()` and `M.float()`
M.toggle_float = function(opts)
    if vim.api.nvim_win_is_valid(M.state.floating.win) then -- if visible
        vim.api.nvim_win_hide(M.state.floating.win) -- hide
    else
        local y, x, border = 0.8, 0.8, "rounded"
        if opts then -- kind of cursed:
            y, x, border = opts.y or y, opts.x or x, opts.border or border
        end

        local buf
        if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
            buf = M.state.floating.buf
        else
            buf = vim.api.nvim_create_buf(false, true) -- buffer be like
        end

        local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = math.floor(vim.o.columns * x),
            height = math.floor(vim.o.lines * y),
            col = math.floor(vim.o.columns * ((1 - x) / 2)),
            row = math.floor(vim.o.lines * ((1 - y) / 2)),
            border = border or "double",
        })

        M.state.floating = { buf = buf, win = win }

        if vim.bo[M.state.floating.buf].buftype ~= "terminal" then -- if buftype isn't terminal
            vim.cmd.terminal() -- enter terminal
        end
    end
    vim.cmd("startinsert")
end

---@class toggle_hor_opts
---@field y? number -- %width,  between 0.0 and 1.0
---@field win? integer -- -1(default) = across all windows OR 0 = just current

---@param opts? toggle_hor_opts
--- merging `M.toggle()` and `M.horizonstal()`
M.toggle_hor = function(opts)
    if vim.api.nvim_win_is_valid(M.state.floating.win) then -- if visible
        vim.api.nvim_win_hide(M.state.floating.win) -- then hide
    else
        local y, winOpt = 0.3, -1
        if opts then -- kind of cursed:
            y = opts.y or y
            winOpt = opts.win or winOpt
        end

        local buf
        if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
            buf = M.state.floating.buf -- use existing term-buf
        else
            buf = vim.api.nvim_create_buf(false, true) -- create a new buf
        end

        local win = vim.api.nvim_open_win(buf, true, {
            height = math.floor(vim.o.lines * y),
            win = winOpt, -- make it open across all windows vertically (0=just current window)
            split = "below",
        })
        M.state.floating = { buf = buf, win = win }

        if vim.bo[M.state.floating.buf].buftype ~= "terminal" then -- if buftype isn't terminal
            vim.cmd.terminal() -- enter terminal
            vim.cmd("startinsert")
        end
    end
end

--DONE:
--1. [x] toggle_float()
--2. [x] toggle_horizontal()
--TODO: MERGE MERGE(/split) FUNCTIONS INTO:
--Then add a third
--3. toggle_vertical()

function M.setup() -- empty (for now...)
    -- TODO: Stop `M.setup()` being empty (for now...)

    vim.api.nvim_create_user_command("TermToggleHor", M.toggle_hor, {})
    vim.api.nvim_create_user_command("TermToggleFloat", M.toggle_float, {})
end

return M

-- TODO: ideas of other options:
-- map('n', '<leader>tv', function() require('custom.toggle_term').verti() end, { desc = 'Vertical terminal' })
-- map('n', '<leader>th', function() require('custom.toggle_term').horiz() end, { desc = 'Horizontal terminal' })
-- map({ 'n', 't' }, '<M-t>', function() require('custom.toggle_term').float() end, { desc = 'Toggle Term' })
-- map({ 'n', 't' }, '<C-/>', function() require('custom.toggle_term').horiz() end, { desc = 'Toggle HTerm' })

-- TEST: DEBUG SCRATCH
-- print("Foobar.nvim file `foobar.lua` got HELLA loaded")
