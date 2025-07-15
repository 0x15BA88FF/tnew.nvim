# 📝 tnew.nvim

A simple Neovim plugin for managing temporary scratch files.

## ✨ Features

- Create a new scratch file
- List all saved temp files
- Delete or move temp files to trash

## ⚡️ Requirements

- Neovim
- Trash utility (optional): `trash-cli` or `gio`

## 📦 Installation

Install the plugin using your preferred package manager:

```lua
-- lazy.nvim
{
  "0x15ba88ff/tnew.nvim",
  config = function()
    require("tnew").setup()
  end,
  cmd = { "Tnew", "TnewClean" }
}

-- packer.nvim
use({
  "0x15ba88ff/tnew.nvim",
  config = function()
    require("tnew").setup()
  end,
  cmd = { "Tnew", "TnewClean" },
})
````

## ⚙️ Configuration

`tnew.nvim` comes with the following defaults:

```lua
{
  dir = vim.fn.stdpath("cache") .. "/tnew", -- Where to store temp files
  filename = "%Y-%m-%d_%H-%M-%S",           -- Format for filenames
  default_ext = "md",                       -- Default file extension
  delete_to_trash = true                    -- Move files to trash instead of deleting permanently
}
```

Configuration is optional — it works out of the box.

## 🚀 Commands

| Command      | Description                                     |
| ------------ | ----------------------------------------------- |
| `:Tnew`      | Open a new temp file with the default extension |
| `:Tnew md`   | Open a new temp file with the `.md` extension   |
| `:TnewList`  | List all temp files                             |
| `:TnewClean` | Delete or move all temp files to trash          |

## 📄 License

Licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
See the [LICENSE](./LICENSE) file for details.
