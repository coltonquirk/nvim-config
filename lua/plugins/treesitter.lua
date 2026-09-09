return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- needed to change this to nvim-treesitter.config instead of nvim-treesitter.configs
		require("nvim-treesitter.config").setup({
			ensure_installed = {"lua", "python", "julia", "javascript", "typst"},
			highlight = {
				enable = true,
				disable = { "latex" },
			},
			indent = {
				enable = false,
				disable = { "latex" },
			},
		})
	end
}
