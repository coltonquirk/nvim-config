local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then 
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- if not vim.loop.fs_stat(lazypath) then
-- 	vim.fn.system({
-- 		"git", "clone", "--filter=bob:none",
-- 		"https://github.com/folke/lazy.nvim.git",
-- 		"--branch=stable",
-- 		lazypath,
-- 	})
-- end
-- vim.opt.rtp:prepend(lazypath)

-- Ultisnips setup
-- TODO: Change to LuaSnips
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", "vim-snippets/UltiSnips" }
vim.g.UltiSnipsExpandTrigger = "<Tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<Tab>"
vim.g.UltiSnipsBackwardTrigger = "<S-Tab>"

-- Typst
vim.g.typst_pdf_viewer = "zathura"

require("lazy").setup({
	require("plugins.ui"),
	require("plugins.treesitter"),
	require("plugins.cmp"), --TODO: Add cmp-pandoc-references
	require("plugins.lsp"),
	require("plugins.latex"),
	require("plugins.git"),
	require("plugins.repl"), -- TODO: remove/change to vim-slime
	require("plugins.fortran"),
	-- require("plugins.ultisnips"), -- should be included in cmp
	require("plugins.quarto"),
	require("plugins.typst"),
	require("plugins.harpoon"),
	require("plugins.zotcite")
})

