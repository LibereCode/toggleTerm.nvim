# README `toggleTerm`

This is a ~plugin.nvim~ version of my previous _"pseudo-plugin"_:
`toggle_term.lua`

Cleaned it up a little (and merged the tiny '_modules_')

> [!NOTE]
> This is the primary (`dev`)development branch and will probably be very chaotic.
> Please just use `main` branch instead.

## USE

First add it to you favorite plugin-manager

### lazy.nvim

```lua init.lua
-- Together with other files -- if standalone file, just remove on set fo `{}`
return {
    -- ... other plugins
    {
        'LibereCode/toggleTerm.nvim',
        opts = function(_, opts)
            -- create terminal(s) and set keymap (examples:)
            local map, tTerm = vim.keymap.set, require('toggleTerm')
            local terminal = tTerm.new()

            map({ 'n', 't' }, '<M-t>', function()
                terminal:toggle_float({ border = 'single' })
            end, { desc = 'toggle floating term' })
            map({ 'n', 't' }, '<M-t>', function()
                terminal:toggle_hor({ y = 0.4 })
            end, { desc = 'togHor' })

            -- can also create other terminal instances by just
            -- running `local newVar = tTerm.new()` again
        end,
    },
    -- ... other plugins
}
```

### vim.pack

```lua init.lua
-- This is the builtin package manager for nvim. see `:h vim.pack`
vim.pack.add({
    -- ... other plugins
    'https://github.com/LibereCode/toggleTerm.nvim',
    -- ... other plugins
})

local tTerm = require('toggleTerm')
tTerm.setup(function())
    terminal = tTerm.new()
end)

-- set keymap
vim.keymap.set({ 'n', 't' }, '<M-t>', function()
    terminal:toggle_float({ x = 0.7, y = 0.95 })
end, { desc = 'toggle floating terminal and make this desc shorter.' })

```

### keymap

Possible values for **_opts_** in `toggle_[float|hor](opts)`:

- `x = number` (0 <= _number_ <= 1) _# the width_
- `y = number` (0 <= _number_ <= 1) _# the height_
- `border = string` (_string_ mentioned in `:help winborder`)

## TODO

- [ ] Fix **type annotation**, so that you get hints about **_opts_** in `toggle_term(opts)`
- [ ] Do (maybe?) a `setup()` function
- [ ] Make `:help` docs
