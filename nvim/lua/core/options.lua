-- Shortcuts
local g = vim.g
local opt = vim.opt
local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- Disable built-in plugins
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit",
}
for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-- General
opt.shell = "/bin/bash"
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.updatetime = 50
wo.number = true
wo.relativenumber = true
wo.cursorline = true
g.mapleader = " "
g.maplocalleader = ";"

-- Tab settings
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.ai = true -- Auto-indent
opt.si = true -- Smart-indent

-- Fold
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Search
opt.hlsearch = false
opt.incsearch = true

-- Code completion popup menu
o.wildoptions = "pum"
o.pumblend = 15
o.winblend = 15

-- Ensures at least 8 lines below
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
