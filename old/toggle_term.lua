-- INFO: version 2.0
-- still followed TJ, but way less AI(A moronic Imicilic clanker) this time

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local toggle_term = function()
  if vim.api.nvim_win_is_valid(state.floating.win) then -- if visible
    vim.api.nvim_win_hide(state.floating.win) -- hide
  else
    state.floating = require('custom.modules.toggle_float').toggle_float { x = 0.8, y = 0.8, buf = state.floating.buf } -- tells it to use the same buffer
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then -- if buftype isn't terminal
      vim.cmd.terminal() -- enter terminal
    end
  end
  vim.cmd 'startinsert'
end

vim.api.nvim_create_user_command('Termtoggle', toggle_term, {})
vim.keymap.set({ 'n', 't' }, '<M-t>', '<CMD>Termtoggle<CR>')
vim.keymap.set({ 'n', 't' }, '<leader>tt', '<CMD>Termtoggle<CR>')

-- TODO: ideas of other options:
--
-- map('n', '<leader>tv', function() require('custom.toggle_term').verti() end, { desc = 'Vertical terminal' })
-- map('n', '<leader>th', function() require('custom.toggle_term').horiz() end, { desc = 'Horizontal terminal' })
-- map({ 'n', 't' }, '<M-t>', function() require('custom.toggle_term').float() end, { desc = 'Toggle Term' })
-- map({ 'n', 't' }, '<C-/>', function() require('custom.toggle_term').horiz() end, { desc = 'Toggle HTerm' })
