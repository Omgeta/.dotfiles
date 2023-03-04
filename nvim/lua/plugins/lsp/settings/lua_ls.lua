return {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
			hint = { enable = true },
			diagnostics = {
				globals = { "vim" },
			},
			telemetry = { enable = false },
		},
	},
}
