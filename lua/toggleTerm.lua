-- INFO: version 2.1
-- From my nvim/lua/custom dir

local M = {}
M.state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

function M.toggle_float(opts)
    opts = opts or {}
    local x = opts.x or 0.9
    local y = opts.y or 0.9

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- buffer be like
    end

    local win_conf = {
        relative = "editor",
        width = math.floor(vim.o.columns * x),
        height = math.floor(vim.o.lines * y),
        col = math.floor(vim.o.columns * ((1 - x) / 2)),
        row = math.floor(vim.o.lines * ((1 - y) / 2)),
        border = "rounded",
    }
    local win = vim.api.nvim_open_win(buf, true, win_conf)

    return { buf = buf, win = win }
end

function M.toggle_term()
    if vim.api.nvim_win_is_valid(M.state.floating.win) then -- if visible
        vim.api.nvim_win_hide(M.state.floating.win) -- hide
    else
        M.state.floating = M.toggle_float({
            x = 0.8,
            y = 0.8,
            buf = M.state.floating.buf,
        }) -- tells it to use the same buffer
        if vim.bo[M.state.floating.buf].buftype ~= "terminal" then -- if buftype isn't terminal
            vim.cmd.terminal() -- enter terminal
        end
    end
    vim.cmd("startinsert")
end

function M.setup() -- NOTE: the `main()` of plugins
    vim.api.nvim_create_user_command("Termtoggle", M.toggle_term, {})

    vim.keymap.set({ "n", "t" }, "<M-t>", "<CMD>Termtoggle<CR>")
    vim.keymap.set({ "n", "t" }, "<leader>tt", "<CMD>Termtoggle<CR>")
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
