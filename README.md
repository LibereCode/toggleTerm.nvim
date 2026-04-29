# README toggleTerm

~This is a test-plugin, loosely following
[TJ's youtube guide](https://www.fuck-you.lol/hihi)~

This is a ~plugin.nvim~ version of my previous _"pseudo-plugin"_:
`toggle_term.lua`

Cleaned it up a little (and merged the tiny '_modules_')

## USE

First add it to you favorite plugin-manager

### lazy.nvim

```lua init.lua
-- Together with other files --
return {
    -- ... other plugins
    { 'LibereCode/toggleTerm.nvim' },
    -- ... other plugins
}

-------------------------------------

-- Standalone file --
return { 'LibereCode/toggleTerm.nvim' },
```

### vim.pack

```lua init.lua
-- This is the builtin package manager for nvim. see `:h vim.pack`
vim.pack.add({
    -- ... other plugins
    'https://github.com/LibereCode/toggleTerm.nvim',
    -- ... other plugins
})

-- No `require('toggleTerm').setup()` is needed... yet
-- (because this plugin is in its infantcy, and hasen't come to that yet...)
```
