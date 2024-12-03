return {
	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		opts = {
			diagnostics = { -- options for vim.diagnostic.config()
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "?" },
				severity_sort = true,
			},
			autoformat = true, -- format on save
			servers = {
				"lua_ls",
				"ts_ls",
				"pyright",
				"prismals",
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
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local pass_one, null_ls = pcall(require, "null-ls")
			local pass_two, null_ls_utils = pcall(require, "null-ls.utils")
			local pass_three, handlers = pcall(require, "plugins.lsp.handlers")
			if not (pass_one and pass_two and pass_three) then
				return
			end

			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics

			null_ls.setup({
				root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
				sources = {
					-- Web
					formatting.prettierd,
					diagnostics.eslint_d.with({
						condition = function(utils)
							return utils.root_has_file({
								".eslintrc.js",
								".eslintrc.cjs",
								".eslintrc.json",
								".eslintrc.yaml",
							})
						end,
					}),
					-- Lua
					formatting.stylua,
					-- Python
					diagnostics.ruff,
				},
				on_attach = handlers.on_attach,
			})
		end,
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
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"nvimtools/none-ls.nvim",
		},
		cmd = { "NullInstall", "NullUninstall" },
		opts = {
			automatic_installation = true,
		},
	},
}
