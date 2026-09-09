local augroup = vim.api.nvim_create_augroup("CoreAutocmds", { clear = true })

-- On Insert turn off relative numbers
vim.api.nvim_create_autocmd("InsertEnter", {
	group = augroup,
	callback = function()
		vim.opt.relativenumber = false
	end,
})

-- Turn on relative numbers leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	group = augroup,
	callback = function()
		vim.opt.relativenumber = true
	end,
})

-- Treesitter for specific filetypes
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'lua', 'python', 'julia' }, -- 'tex' },
	callback = function()
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start()
		-- folds, provided by Neovim
		-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo.foldmethod = 'expr'
		-- indentation, provided by nvim-treesitter
		-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.identexpr()"
	end,
})

-- Enable spellcheck on certain language first file types.
vim.api.nvim_create_autocmd("FileType", {
	pattern = {"tex", "typst", "quarto"},
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

-- Auto-pin main.typ whenever a typst buffer attaches to tinymist
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "tinymist" then
			return
		end

		local bufnr = args.buf
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname == "" then
			return
		end

		-- Walk up from current file's directory looking for main.typ
		local dir = vim.fs.dirname(bufname)
		local found = vim.fs.find("main.typ", { path = dir, upward = true })[1]
		
		if found then
			client:exec_cmd({
				title = "pin",
				command = "tinymist.pinMain",
				arguments = { found },
			}, { bufnr = bufnr })
		end
	end,
})

-- Ultisnips for Quarto
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "quarto",
-- 	callback = function()
-- 		vim.fn["UltiSnips$AddFiletypes"]("quarto.tex")
-- 	end,
-- })
