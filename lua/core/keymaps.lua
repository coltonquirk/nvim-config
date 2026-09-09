local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Window left"  })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Window right" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Window up"    })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Window down"  })
