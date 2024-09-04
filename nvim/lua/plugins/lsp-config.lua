return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				-- your configuration comes here
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "ruff" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.pyright.setup({
        enabled = false,
				settings = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							diagnosticSeverityOverrides = {
								-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
								reportUndefinedVariable = "none",
								reportUnusedClass = false,
								reportUnusedFunction = false,
								reportUnusedVariable = false,
								reportUnusedImport = false,
							},
							-- Ignore all files for analysis to exclusively use Ruff for linting
							--ignore = { "*" },
						},
					},
				},
			})
			lspconfig.ruff.setup({})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
