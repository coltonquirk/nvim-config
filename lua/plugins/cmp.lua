return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",

	dependencies = {
		-- Completion sources
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"jc-doyle/cmp-pandoc-references",

		-- Snippets
		"SirVer/ultisnips",
		"quangnguyen30192/cmp-nvim-ultisnips",

		-- LaTeX / symbols
		"kdheepak/cmp-latex-symbols",
		"micangl/cmp-vimtex",
	},

	init = function()
		vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
	end,

	config = function()
		-- Core requires
		local cmp = require("cmp")

		-- nvim-cmp global setup
        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["UltiSnips#Anon"](args.body)
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),

                ["<TAB>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes("<C-r>=UltiSnips#JumpForwards()<CR>", true, false, true),
                            "", true
                        )
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-TAB>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes("<C-r>=UltiSnips#JumpBackwards()<CR>", true, false, true),
                            "", true
                        )
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "ultisnips" },
                { name = "path" },
                { name = "buffer" },
            }),
        })


		-- LaTeX-specific completion
		cmp.setup.filetype("tex", {
			sources = cmp.config.sources({
				{ name = "vimtex" },
				{ name = "latex_symbols" },
				-- { name = "luasnips" },
				{ name = "ultisnips" },
				{ name = "buffer" },
				{ name = "path" },
			})
		})

		-- Quarto completion
		cmp.setup.filetype({ "quarto", "markdown" }, {
			sources = cmp.config.sources({
				{ name = "cmp-pandoc-references" },
				{ name = "buffer" },
				{ name = "path" },
			})
		})

		-- Julia-specific completion
		cmp.setup.filetype("julia", {
			sources = cmp.config.sources({
				{ name = "latex_symbols" },
				{ name = "nvim_lsp" },
				{ name = "ultisnips" },
				{ name = "path" },
				{ name = "buffer" },
			})
		})
	end,
}
