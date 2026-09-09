-- ~/.config/nvim/init.lua

-- Leader must be first
vim.g.mapleader = " "

-- Core settings
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.typst")

-- Plugins
require("plugins")

