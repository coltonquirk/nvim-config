return {
	-- VimTeX
	{
		"lervag/vimtex",
		ft = { "tex" },
		config = function()
			-- VimTeX settings
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_complete_enabled = 1

			-- LaTeX autocmds (buffer-local)
			local group = vim.api.nvim_create_augroup("LatexBufferSetup", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "tex",
				callback = function(ev)
					-- use latexindent for formating (:gq / :format)
					vim.bo[ev.buf].formatprg = "latexindent -l -m -"

					-- Format on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = group,
						buffer = ev.buf,
						callback = function()
							vim.b.__view = vim.fn.winsaveview()
							if vim.fn.executable("latexindent") == 1 then
								vim.cmd([[%!latexindent -l -m -]])
							end
						end,
						desc = "Format LaTeX with latexindent on save",
					})

					vim.api.nvim_create_autocmd("BufWritePost", {
						group = group,
						buffer = ev.buf,
						callback = function()
							if vim.b.__view then
								vim.fn.winrestview(vim.b.__view)
							end
						end,
						desc = "Restore cursor position after latexindent formatting",
					})


					-- VimTex keymaps (buffer-local)
					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, {
							buffer = ev.buf,
							silent = true,
							desc = desc,
						})
					end

					map("<leader>lc", "<cmd>VimtexCompile<CR>", "LaTeX: Compile")
					map("<leader>lv", "<cmd>VimtexView<CR>", "LaTeX: View PDF")
					map("<leader>ll", "<cmd>VimtexCompileSS<CR>", "LaTeX: Start/Continue compile")
					map("<leader>lk", "<cmd>VimtexStop<CR>", "LaTeX: Stop compile")
					map("<leader>lq", "<cmd>VimtexClean<CR>", "LaTeX: Clean aux files")

					map("<leader>wc", ":!texcount -inc -brief %<CR>", "Word count (texcount)")
				end,
			})
		end,
	},
}
