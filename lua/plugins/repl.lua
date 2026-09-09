return {
	-- REPL sender (Python + Julia)
	-- TODO: Replace with vim-slime + tmux setup!
	{
		"Vigemus/iron.nvim",
		ft = { "python", "julia" },
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")
			local common = require("iron.fts.common")

			iron.setup({
				config = {
					repl_definition = {
						-- Can also use stock {"python3"}
						python = {
							command = { "ipython", "--no-autoindent" },
							-- IMPORTANT: use the plain `bracketed_paste', not
							-- `bracketed_paste' python.
							format = common.bracketed_paste,
						},
						julia = {
							command = { "julia", "--color=yes"},
							-- Same for Julia
							-- Specifically because julia REPL auto-closes brackets
							-- so without a real bracketed paste brackets get closed twice
							-- `println("Hello, World") -> println("Hello, World"))'
							format = common.bracketed_paste,
						},
					},

					repl_open_cmd = view.bottom(0.3),

					scratch_repl = true,
					ignore_blank_lines = true,
					close_window_on_exit = true,
					highlight = { italic = true },
				},
				keymaps = {
					send_motion = "<leader>ro", -- then a motion/textobj (e.g. ap, ip, }, etc.)
					visual_send = "<leader>rs", -- send a visual selection
					send_line   = "<leader>rl", -- send current line
					send_file   = "<leader>rB", -- send whole buffer
					interrupt   = "<leader>r<BS>",
					exit        = "<leader>rq",
					clear       = "<leader>rc",
				},
			})

			-- Buffer-local helpers for Python/Julia only (avoid global conflicts)
			local grp = vim.api.nvim_create_augroup("IronLocalMaps", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = grp,
				pattern = { "python", "julia" },
				callback = function(ev)
					local bmap = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, noremap = true, desc = desc })
					end
					bmap("n", "<leader>rr", function() iron.repl_for(vim.bo[ev.buf].filetype) end, "REPL: open split")
					bmap("n", "<leader>rw", function() iron.focus_on(vim.bo[ev.buf].filetype) end, "REPL: focus window")
				end,
			})

			-- Make REPL terminals a bit cleaner
			local tgrp = vim.api.nvim_create_augroup("IronTermTweak", { clear = true })
			vim.api.nvim_create_autocmd("TermOpen", {
				group = tgrp,
				pattern = "term://*",
				callback = function()
					vim.opt_local.number = false
					vim.opt_local.relativenumber = false
					vim.opt_local.signcolumn = "no"
					vim.cmd("startinsert")
				end
			})

			-- Exit insert mode / get back to normal Neovim navigation from 
			-- inside the REPL terminal without having to type exit()
			vim.api.nvim_create_autocmd("TermOpen", {
				group = tgrp,
				pattern = "term://*",
				callback = function(ev)
					vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = ev.buf, desc = "Exit terminal mode" })
				end,
			})
		end,
	},
}
