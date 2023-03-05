return {
	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			diagnostics = { -- options for vim.diagnostic.config()
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			},
			autoformat = true, -- format on save
			servers = {
				"lua_ls",
				"tsserver",
			}, -- list of servers
		},
		config = function(_, opts)
			local pass_one, lspconfig = pcall(require, "lspconfig")
			local pass_two, handlers = pcall(require, "plugins.lsp.handlers")
			if not (pass_one and pass_two) then
				return
			end

			-- Override autoformat
			handlers.autoformat = opts.autoformat

			-- Diagnostics
			for name, icon in pairs(require("core.utils").icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config(opts.diagnostics)

			-- Setup LSP servers
			for _, server in pairs(opts.servers) do
				-- Default opts
				local server_opts = {
					on_attach = handlers.on_attach,
					capabilities = handlers.capabilities,
				}
				-- Add LSP-specific opts if available
				local has_custom_opts, custom_opts = pcall(require, "plugins.lsp.settings." .. server)
				if has_custom_opts then
					server_opts = vim.tbl_deep_extend("force", server_opts, custom_opts)
				end

				lspconfig[server].setup(server_opts)
			end
		end,
	},

	-- Formatters
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"williamboman/mason.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		opts = function()
			local pass, null_ls = pcall(require, "null-ls")
			if not pass then
				return
			end

			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics

			return {
				sources = {
					-- Web
					formatting.prettierd,
					-- Lua
					formatting.stylua,
					-- Python
					diagnostics.flake8,
				},
			}
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		cmd = { "NullInstall", "NullUninstall" },
		opts = {
			automatic_installation = true,
		},
	},

	-- Install
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
		},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		cmd = { "LspInstall", "LspUninstall" },
		opts = {
			automatic_installation = true,
		},
	},
}
