local M = {}

M.root_patterns = { ".git", "lua" }

M.colors = {
	black = "#181a1f",
	bg0 = "#282c34",
	bg1 = "#31353f",
	bg2 = "#393f4a",
	bg3 = "#3b3f4c",
	bg_d = "#21252b",
	bg_d2 = "#262a30",
	fg = "#abb2bf",
	grey = "#5c6370",
	light_grey = "#848b98",
	white = "#abb2bf",
	red = "#e55561",
	green = "#8ebd6b",
	purple = "#bf68d9",
	blue = "#4fa6ed",
	yellow = "#e2b86b",
	orange = "#cc9057",
	cyan = "#48b0bd",
}

M.icons = {
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
	},
	kinds = {
		Array = " ",
		Boolean = " ",
		Class = " ",
		Color = " ",
		Constant = "ﲀ ",
		Constructor = "  ",
		Copilot = " ",
		Enum = "練  ",
		EnumMember = " ",
		Event = " ",
		Field = "ﴲ ",
		File = " ",
		Folder = " ",
		Function = " ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = " ",
		Module = " ",
		Namespace = " ",
		Null = "ﳠ ",
		Number = " ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = "襁 ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = "ﳤ ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = " ",
	},
}

M.telescope = function(builtin, opts)
	return function()
		opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {}) -- set default cwd to root unless otherwise specified

		if builtin == "files" then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		end

		require("telescope.builtin")[builtin](opts)
	end
end

M.get_root = function()
	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace and vim.tbl_map(function(ws)
				return vim.uri_to_fname(ws.uri)
			end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
		print(1)
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end

	print(2)
	---@cast root string
	return root
end

return M
