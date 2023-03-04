local M = {}

-- Format
M.autoformat = true

local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

M.format = function(bufnr)
	if not M.autoformat then
		return
	end

	local ft = vim.bo[bufnr].filetype
	local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			if have_nls then
				return client.name == "null-ls"
			end
			return client.name ~= "null-ls"
		end,
	})
end

-- Keymaps
M.lsp_keymap = function(bufnr)
	local map = vim.keymap.set
	map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { buffer = bufnr, desc = "Definition" })
	map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Declaration" })
	map("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr, desc = "Reference" })
	map("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr, desc = "Implementation" })
	map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { buffer = bufnr, desc = "Type Definition" })
	map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous Diagnostic" })
	map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
	map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
	map("n", "gK", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
	map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
	map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
	map("n", "<leader>cf", function()
		M.format(bufnr)
	end, { buffer = bufnr, desc = "Format Document" })
end

-- LSP On Attach
M.on_attach = function(client, bufnr)
	M.lsp_keymap(bufnr)

	-- don't format if client disabled it
	if
		client.config
		and client.config.capabilities
		and client.config.capabilities.documentFormattingProvider == false
	then
		return
	end

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				M.format(bufnr)
			end,
		})
	end
end

-- LSP Capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharacterSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}
local pass, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if pass then
	M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
end

return M
