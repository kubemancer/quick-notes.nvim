# quick-notes.nvim

A simple and efficient quick notes plugin for Neovim that helps you capture thoughts and ideas without leaving your editor.

## Features

- 📝 **Quick Note Creation**: Create timestamped markdown notes instantly
- 🔍 **Smart Search**: Search within your notes using Telescope (with fallback)
- 📋 **Note Listing**: Browse all notes with fuzzy finding
- 🎯 **LazyVim Integration**: Seamless integration with LazyVim
- 🏥 **Health Checks**: Built-in health check support
- 🐛 **Debug Mode**: Development utilities for troubleshooting

## Installation

### With [lazy.nvim](https://github.com/folke/lazy.nvim) (LazyVim)

```lua
{
  "kubemancer/quick-notes.nvim",
  config = function()
    require("quick-notes").setup({
      notes_dir = vim.fn.expand("~/notes"),
      default_note_name = "quick-note",
      date_format = "%Y-%m-%d_%H-%M-%S",
    })
  end,
  keys = {
    { "<leader>nn", "<cmd>QuickNote<cr>", desc = "Create new quick note" },
    { "<leader>nl", "<cmd>QuickNoteList<cr>", desc = "List quick notes" },
    { "<leader>ns", "<cmd>QuickNoteSearch<cr>", desc = "Search notes" },
  },
  cmd = { "QuickNote", "QuickNoteList", "QuickNoteSearch" },
}
```

### With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "kubemancer/quick-notes.nvim",
  config = function()
    require("quick-notes").setup()
  end
}
```

### With [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'kubemancer/quick-notes.nvim'
```

Then in your `init.lua`:

```lua
require("quick-notes").setup()
```

## Configuration

Default configuration:

```lua
require("quick-notes").setup({
  notes_dir = vim.fn.expand("~/notes"),        -- Directory to store notes
  default_note_name = "quick-note",            -- Default note filename prefix
  date_format = "%Y-%m-%d_%H-%M-%S",          -- Timestamp format
  debug = false,                               -- Enable debug mode
})
```

## Usage

### Commands

- `:QuickNote` - Create a new timestamped note
- `:QuickNoteList` - List all notes (uses Telescope if available)
- `:QuickNoteSearch` - Search within note contents

### Default Keymaps

- `<leader>nn` - Create new quick note
- `<leader>nl` - List quick notes
- `<leader>ns` - Search notes

### Note Template

Each note is created with a basic template:

```markdown
# Quick Note - 2024-01-15 14:30:45

## Notes
```

## Dependencies

### Required

- Neovim >= 0.7.0

### Optional

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Enhanced file listing and search
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Required by Telescope

## Health Check

Run `:checkhealth quick-notes` to verify your installation and configuration.

## Development

Enable debug mode for development:

```lua
require("quick-notes").setup({
  debug = true,
})
```

Debug commands (only available in debug mode):

- `:QuickNoteDebug` - Run plugin tests
- `:QuickNoteInspect` - Inspect current configuration

## License

MIT License
