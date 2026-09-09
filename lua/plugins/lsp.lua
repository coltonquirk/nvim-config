return {
	"neovim/nvim-lspconfig",

	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
	},

	config = function()
		-- Capabilities and keymaps
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(_, bufnr)
			local map = function(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
			end
			
			map("K", vim.lsp.buf.hover, "Hover")
			map("gd", vim.lsp.buf.definition, "Go to definition")
			map("gr", vim.lsp.buf.references, "References")
			map("gi", vim.lsp.buf.implementation, "Implementation")
			map("<leader>rn", vim.lsp.buf.rename, "Rename")
			map("<leader>ca", vim.lsp.buf.code_action, "Code action")
			map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
			map("]d", vim.diagnostic.goto_next, "Next diagnostic")
		end

		-- Mason
		require("mason-lspconfig").setup({
			ensure_installed = {
				"basedpyright",
				"ruff",
				"julials",
                "tinymist",
			},
			automatic_installation = true,
		})

		-- Python: BasedPyright
		vim.lsp.config("basedpyright", {
			capabilities = capabilities,
			on_attach,
			settings = {
				basedpyright = {
					analysis = {
						autoImportCompletions = true,
					},
				},
			},
		})
		vim.lsp.enable("basedpyright")

		-- Python: Ruff (linting)
		vim.lsp.config("ruff", {
			capabilities = capabilities,
			on_attach = on_attach,
		})
		vim.lsp.enable("ruff")

		-- Julia: LanguageServer.jl
		local julia = "julia"
		
		vim.lsp.config("julials", {
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = {
				julia,
				"--startup-file=no",
				"--history-file=no",
				"-e",
				[[
					using LanguageServer, Pkg, SymbolServer;
					runserver() = begin
						depot = get(ENV, "JULIA_DEPOT_PATH", "")
						project = Base.current_project(pwd())
						project = project == nothing ? Base.load_path_expand(LOAD_PATH[2]) : project
						server = LanguageServer.LanguageServerInstance(stdin, stdout, project, depot, nothing, nothing)
						server.runlinter = true
						run(server)
					end;
					runserver();
				]],
			},
			root_dir = require("lspconfig.util").root_pattern(
				"Project.toml",
				".git",
				"."
			),
		})
		vim.lsp.enable("julials")

		-- Typst: tinymist
		vim.lsp.config("tinymist", {
			settings = {
				formatterMode = "typstyle",
				exportPdf = "onType",
			},
			on_attach = function(client, bufnr)
				vim.keymap.set("n", "<leader>tP", function()
					client:exec_cmd({
						title = "pin",
						command = "tinymist.pinMain",
						arguments = { vim.api.nvim_buf_get_name(0) },
					}, { bufnr = bufnr })
				end, { desc = "[T]inymist [P]in", noremap = true })

				vim.keymap.set("n", "<leader>tU", function()
					client:exec_cmd({
						title = "unpin",
						command = "tinymist.pinMain", -- TODO: Should this be someing like tinymist.unpinMain? Or does pinMain just toggle?
						arguments = { vim.v.null },
					}, { bufnr = bufnr })
				end, { desc = "[T]inymist [U]npin", noremap = true })
			end,
		})

		-- Diagnostics UI
		vim.diagnostic.config({
			virtual_text = { spacing = 2, prefix = "●" }, -- TODO add warning symbol
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}



