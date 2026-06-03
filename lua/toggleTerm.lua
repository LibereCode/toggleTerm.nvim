-- INFO: version 2.1
-- From my nvim/lua/custom dir

---@class Floating
---@field buf integer
---@field win integer

---@class State
---@field floating Floating

---@class M
---@field state State

local M = {}
M.__index = M

---@return M
M.new = function()
    ---@type M
    local self = setmetatable({}, M)
    self.state = {
        floating = {
            buf = -1,
            win = -1,
        },
    }
    return self
end

---@class toggle_float_opts
---@field x? number -- %width,  between 0.0 and 1.0
---@field y? number -- %height,  between 0.0 and 1.0
---@field border? string -- bordertype

---@class M
---@field toggle_float function<toggle_float_opts?>
---@param opts? toggle_float_opts
--- merging `M.toggle()` and `M.float()`
function M:toggle_float(opts)
    if vim.api.nvim_win_is_valid(self.state.floating.win) then -- if visible
        vim.api.nvim_win_hide(self.state.floating.win) -- hide
    else
        local y, x, border = 0.8, 0.8, "rounded"
        if opts then -- kind of cursed:
            y, x, border = opts.y or y, opts.x or x, opts.border or border
        end

        local buf
        if vim.api.nvim_buf_is_valid(self.state.floating.buf) then
            buf = self.state.floating.buf
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

        self.state.floating = { buf = buf, win = win }

        if vim.bo[self.state.floating.buf].buftype ~= "terminal" then -- if buftype isn't terminal
            vim.cmd.terminal() -- enter terminal
        end

        ---QoL autocmd to close if losing focus
        vim.api.nvim_create_autocmd("WinLeave", {
            group = vim.api.nvim_create_augroup("toggleTerm-float-WinLeave-close", { clear = true }),
            desc = "Automatically close toggleTerm-float window when it looses focus.",
            buf = self.state.floating.buf,
            once = true,
            callback = function(args)
                if vim.api.nvim_buf_is_valid(args.buf) then
                    vim.api.nvim_win_hide(self.state.floating.win)
                else
                    return -- how even?
                end
            end,
        })
    end
    vim.cmd("startinsert")
end

---@class toggle_hor_opts
---@field y? number -- %width,  between 0.0 and 1.0
---@field win? integer -- -1(default) = across all windows OR 0 = just current

---@class M
---@field toggle_hor function<toggle_hor_opts?>
---@param self M
---@param opts? toggle_hor_opts
--- merging `M.toggle()` and `M.horizonstal()`
function M:toggle_hor(opts)
    if vim.api.nvim_win_is_valid(self.state.floating.win) then -- if visible
        vim.api.nvim_win_hide(self.state.floating.win) -- then hide
    else
        local y, winOpt = 0.3, -1
        if opts then -- kind of cursed:
            y = opts.y or y
            winOpt = opts.win or winOpt
        end

        local buf
        if vim.api.nvim_buf_is_valid(self.state.floating.buf) then
            buf = self.state.floating.buf -- use existing term-buf
        else
            buf = vim.api.nvim_create_buf(false, true) -- create a new buf
        end

        local win = vim.api.nvim_open_win(buf, true, {
            height = math.floor(vim.o.lines * y),
            win = winOpt, -- make it open across all windows vertically (0=just current window)
            split = "below",
        })
        self.state.floating = { buf = buf, win = win }

        if vim.bo[self.state.floating.buf].buftype ~= "terminal" then -- if buftype isn't terminal
            vim.cmd.terminal() -- enter terminal
        end
        vim.cmd("startinsert")
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

    local term = M.new()

    local function horizontal()
        term:toggle_hor()
    end
    local function float()
        term:toggle_float()
    end
    -- local test2 = M.new()
    -- local function test_float2()
    --     test2:toggle_float()
    -- end
    vim.api.nvim_create_user_command("TermToggleHor", horizontal, {})
    vim.api.nvim_create_user_command("TermToggleFloat", float, {})
    -- vim.api.nvim_create_user_command("TermToggleFloat2", test_float2, {})
end

return M

-- TODO: ideas of other options:
-- map('n', '<leader>tv', function() require('custom.toggle_term').verti() end, { desc = 'Vertical terminal' })
-- map('n', '<leader>th', function() require('custom.toggle_term').horiz() end, { desc = 'Horizontal terminal' })
-- map({ 'n', 't' }, '<M-t>', function() require('custom.toggle_term').float() end, { desc = 'Toggle Term' })
-- map({ 'n', 't' }, '<C-/>', function() require('custom.toggle_term').horiz() end, { desc = 'Toggle HTerm' })

-- TEST: DEBUG SCRATCH
-- print("Foobar.nvim file `foobar.lua` got HELLA loaded")
