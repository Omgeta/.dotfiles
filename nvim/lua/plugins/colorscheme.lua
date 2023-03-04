local colors = require("core.utils").colors

return {
	-- OneDark
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- load before all other plugins to preserve highlight groups
		opts = {
			-- Main options
			style = "darker", -- Theme style (dark/darker/cool/deep/warm/warmer/light)
			transparent = true, -- Show/hide background

			-- Code styles (none/bold/italic/underline)
			code_style = {
				comments = "none",
				keywords = "bold",
				functions = "bold",
				strings = "none",
				variables = "none",
			},

			-- Lualine options
			lualine = {
				transparent = true, -- Center bar transparency
			},

			-- Plugins
			diagnostics = {
				darker = true, -- darker colours for diagnostics
				undercurl = true, -- use undercurl instead of underline
				background = true, -- use bg color for virtual text
			},

			-- Override colors
			colors = colors,

			-- Override highlights
			highlights = {
				-- Telescope
				TelescopeMatching = { fg = colors.cyan, fmt = "bold" },
				TelescopeNormal = { fg = colors.bg_d, bg = colors.bg_d },
				TelescopeBorder = { fg = colors.bg_d2, bg = colors.bg_d2 },

				TelescopePreviewNormal = { fg = colors.bg_d, bg = colors.bg_d },
				TelescopePreviewTitle = { fg = colors.bg0, bg = colors.green },
				TelescopePreviewBorder = { fg = colors.bg_d, bg = colors.bg_d },

				TelescopeSelection = { bg = colors.bg_d2, fg = colors.white },
				TelescopeSelectionCaret = { bg = colors.white },

				TelescopePromptNormal = { fg = colors.white, bg = colors.bg_d2 },
				TelescopePromptTitle = { fg = colors.bg0, bg = colors.red },
				TelescopePromptBorder = { fg = colors.bg_d2, bg = colors.bg_d2 },
				TelescopePromptPrefix = { fg = colors.red, bg = colors.bg_d2 },

				TelescopeResultsNormal = { fg = colors.white, bg = colors.bg_d },
				TelescopeResultsTitle = { fg = colors.bg_d, bg = colors.bg_d },
				TelescopeResultsBorder = { fg = colors.bg_d, bg = colors.bg_d },

				TelescopeResultsDiffAdd = { fg = colors.green },
				TelescopeResultsDiffChange = { fg = colors.yellow },
				TelescopeResultsDiffDelete = { fg = colors.red },

				-- WhichKey
				FloatBorder = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },

				-- Barbar
				BufferCurrent = { fmt = "bold" },
				BufferCurrentMod = { fg = colors.orange, fmt = "bold,italic" },
				BufferCurrentSign = { fg = colors.purple },

				BufferInactive = { fg = colors.grey, bg = colors.bg0 },
				BufferInactiveMod = { fg = colors.light_grey, bg = colors.bg0, fmt = "italic" },
				BufferInactiveIndex = { fg = colors.grey, bg = colors.bg0 },
				BufferInactiveSign = { fg = colors.bg0, bg = colors.bg0 },
				BufferInactiveTarget = { fg = colors.grey, bg = colors.bg0 },

				BufferTabpageFill = { fg = colors.bg_d, bg = colors.bg_d },

				-- Lualine
				StatusLine = { bg = "NONE" },
				StatusLineNC = { bg = "NONE" },

				-- NvimTree
				NvimTreeWinSeparator = { fg = colors.bg0 },
			},
		},
		config = function(_, opts)
			local pass, onedark = pcall(require, "onedark")
			if not pass then
				return
			end

			onedark.setup(opts)
			vim.cmd([[colorscheme onedark]])
		end,
	},
}
