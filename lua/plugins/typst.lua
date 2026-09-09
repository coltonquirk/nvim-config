return {
	{
		'chomosuke/typst-preview.nvim',
		lazy = false,
		version = '1.*',
		opts = {
            debug = true,

			-- open_cmd = 'NO_AT_BRIDGE=1 firefox %s -P default --class typst-preview',
			open_cmd = 'zen %s -P default --class typst-preview',
			-- open_cmd = 'typst watch %s; open %s',
			-- open_cmd = 'NO_AT_BRIDGE=1 firefox %s -P typst-preview --class typst-preview',
			-- open_cmd = 'open %s',
            --
			dependencies_bin = {
				tinymist = 'tinymist',
			}
        },
        keys = {
            {"<leader>tp", "<cmd>TypstPreview<CR>", desc = "Typst Preview"},
        },
    },

	{
		'kaarmu/typst.vim',
		ft = 'typst',
		lazy = false,
	}
}
