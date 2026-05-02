# README toggleTerm

This is a ~plugin.nvim~ version of my previous _"pseudo-plugin"_:
`toggle_term.lua`

Cleaned it up a little (and merged the tiny '_modules_')

> [!NOTE]
> This is the primary `dev`elopment branch and will probably be very chaotic.
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
        opts = function()
            -- set keymap
            vim.keymap.set({ 'n', 't' }, '<M-t>', function()
                require('toggleTerm').toggle_term({ border = 'single' })
            end, { desc = 'toggleTerm' })
        end,
    },
    -- ... other plugins
}
```

> [!ATTENTION]
> This plugin only loads when called with `require('toggleTerm')...`
> So **DO NOT** _lazy-load_ !!

### vim.pack

```lua init.lua
-- This is the builtin package manager for nvim. see `:h vim.pack`
vim.pack.add({
    -- ... other plugins
    'https://github.com/LibereCode/toggleTerm.nvim',
    -- ... other plugins
})

-- set keymap
vim.keymap.set({ 'n', 't' }, '<M-t>', function()
    require('toggleTerm').toggle_term({ x = 0.7, y = 0.95 })
end, { desc = 'toggleTerm' })

-- No `require('toggleTerm').setup()` is needed... yet
-- (because this plugin is in its infantcy, and hasen't come to that yet...)
```

### keymap

Possible values for **_opts_** in `toggle_term(opts)`:

- `x = number` (0 <= _number_ <= 1) _# the width_
- `y = number` (0 <= _number_ <= 1) _# the height_
- `border = string` (_string_ mentioned in `:help winborder`)

## TODO

- [ ] Fix **type annotation**, so that you get hints about **_opts_** in `toggle_term(opts)`
- [ ] Do (maybe?) a `setup()` function
- [ ] Make `:help` docs
