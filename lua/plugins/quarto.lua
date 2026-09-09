return {
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto" },
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
			"jmbuhr/cmp-pandoc-references",
		},
		keys = {
			{"<leader>qp", "<cmd>QuartoPreview<CR>", desc = "Quarto Preview"},
		},
	},
}
