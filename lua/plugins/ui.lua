return{
	-- Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,

				integrations = {
					lsp_trouble = true,
					treesitter = true,
				},
				auto_integrations = true,
			})
			vim.cmd.colorscheme("catppuccin")
		end
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
		config = function()
			require("lualine").setup({
				options = {
					theme = require("catppuccin.utils.lualine"), -- catppuccin")
				}
			})
		end
	},

	-- File Explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({})
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "File Explorer" })
		end
	},

	-- Telescope
	{
		"nvim-lua/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local t = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", t.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", t.find_files, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fb", t.find_files, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", t.find_files, { desc = "Help" })

		end
	},

	-- Quality of Life
	{ "tpope/vim-commentary" },
	{ "tpope/vim-surround" },
	{ "windwp/nvim-autopairs", config = true },

	-- Which key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				-- keep defaults
			})
			-- Properly name the top-level leader groups
			wk.add({
				{ "<leader>f", group = "Find"},
				{ "<leader>g", group = "Git"},
				{ "<leader>h", group = "Hunk"},
				{ "<leader>l", group = "LaTeX"},
				{ "<leader>r", group = "REPL"},
			})
		end,
	},

	-- Mini icons
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			-- Keep defaults
		},
		init = function()
			-- This makes mini.icons act like web-devicons for compatibility
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,

		config = function()
			require("mini.icons").setup()
		end,

	},

	-- Nice terminal management everywhere
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<C-\\>", "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
		},
		config = function()
			require("toggleterm").setup({
				direction = "float",
				persist_size = true,
				shade_terminals = true,
			})

			-- quick <Esc> to normal-mode in terminals
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "term://*",
				callback = function()
					vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]],
					{ buffer = 0, silent = true, desc = "Terminal: normal mode" })
				end,
			})
		end,
	},
}
