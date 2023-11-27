local utils = require("core.utils")
local icons = utils.icons

return {
	-- Icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Dashboard
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			-- Helper function
			local function button(sc, txt, keybind)
				local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

				local opts = {
					position = "center",
					text = txt,
					shortcut = sc,
					cursor = 5,
					width = 36,
					align_shortcut = "right",
					hl = "AlphaButtons",
				}

				if keybind then
					opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
				end

				return {
					type = "button",
					val = txt,
					on_press = function()
						local key = vim.api.nvim_replace_termcodes(sc_, true, false, true) or ""
						vim.api.nvim_feedkeys(key, "normal", false)
					end,
					opts = opts,
				}
			end

			-- Dynamic header padding
			local fn = vim.fn
			local marginTopPercent = 0.25
			local headerPadding = fn.max({ 2, fn.floor(fn.winheight(0) * marginTopPercent) })

			return {
				layout = {
					-- Header top padding
					{ type = "padding", val = headerPadding },

					-- Header image
					{
						type = "text",
						val = {
							"⠀⠀⠀⠀⠀⣀⣤⣶⣿⠟⠛⠛⠛⠛⠻⢿⣶⣦⣄⠀⠀⠀⠀⠀",
							"⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣦⠀⠀⠀",
							"⠀⠀⣴⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣷⠀⠀",
							"⠀⢰⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣇⠀",
							"⠀⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀",
							"⠀⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⡿⠀",
							"⠀⠀⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⠃⠀",
							"⠀⠀⠘⢿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡿⠋⠀⠀",
							"⠀⠀⠀⠀⠙⠿⣿⣦⣄⠀⠀⠀⠀⠀⠀⣀⣴⣿⡿⠏⠀⠀⠀⠀",
							"⢸⣄⡀⠀⠀⠀⠀⠙⣿⡇⠀⠀⠀⠀⢸⣿⠋⠁⠀⠀⠀⠀⣠⡇",
							"⢸⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⡇",
						},
						opts = {
							position = "center",
							hl = "AlphaHeader",
						},
					},

					-- Header bottom padding
					{ type = "padding", val = 2 },

					-- Buttons
					{
						type = "group",
						val = {
							button("f", "  Find File  ", "<cmd>Telescope find_files<CR>"),
							button("r", "  Find Recent File  ", "<cmd>Telescope oldfiles<CR>"),
							button("g", "󰀬  Search Text  ", "<cmd>Telescope live_grep<CR>"),
							button("m", "  Bookmarks  ", "<cmd>Telescope marks<CR>"),
							button("s", "  Settings", "<cmd>e $VIMCONFIG/init.lua | :cd %:p:h<CR>"),
						},
						opts = {
							spacing = 1,
						},
					},
				},
			}
		end,
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		opts = function()
			local diff = {
				"diff",
				colored = false,
				symbols = icons.git,
				cond = function()
					return vim.fn.winwidth(0) > 80
				end,
			}

			local diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
				colored = true,
				update_in_insert = false,
				always_visible = false,
			}

			return {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						"NvimTree",
						"alpha",
						"lazy",
						"help",
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},

				sections = {
					lualine_a = {
						{ "mode", separator = { left = "" } },
					},
					lualine_b = { "branch", diff, "filename" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = { diagnostics, "filetype" },
					lualine_z = {
						{ "location", separator = { right = "" } },
					},
				},

				inactive_sections = {
					lualine_a = { { "filename" } },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { { "location" } },
				},
			}
		end,
	},

	-- -- Tabline
	--{
	--"romgrk/barbar.nvim",
	--dependencies = {
	--	"nvim-tree/nvim-web-devicons",
	--},
	--event = { "BufReadPre", "BufNewFile" },
	--keys = {
	--	{ "<S-tab>", "<cmd>BufferPrev<cr>", desc = "Previous Buffer" },
	--	{ "<tab>", "<cmd>BufferNext<cr>", desc = "Next Buffer" },
	--	{ "<leader>b[", "<cmd>BufferPrev<cr>", desc = "Previous" },
	--	{ "<leader>b]", "<cmd>BufferNext<cr>", desc = "Next" },
	--	{ "<leader>b,", "<cmd>BufferMovePrev<cr>", desc = "Move Backwards" },
	--	{ "<leader>b.", "<cmd>BufferMoveNext<cr>", desc = "Move Forwards" },
	--	{ "<leader>b1", "<cmd>BufferGoto 1<cr>", desc = "1" },
	--	{ "<leader>b2", "<cmd>BufferGoto 2<cr>", desc = "2" },
	--	{ "<leader>b3", "<cmd>BufferGoto 3<cr>", desc = "3" },
	--	{ "<leader>b4", "<cmd>BufferGoto 4<cr>", desc = "4" },
	--	{ "<leader>b5", "<cmd>BufferGoto 5<cr>", desc = "5" },
	--	{ "<leader>b6", "<cmd>BufferGoto 6<cr>", desc = "6" },
	--	{ "<leader>b7", "<cmd>BufferGoto 7<cr>", desc = "7" },
	--	{ "<leader>b8", "<cmd>BufferGoto 8<cr>", desc = "8" },
	--	{ "<leader>b9", "<cmd>BufferGoto 9<cr>", desc = "9" },
	--	{ "<leader>b$", "<cmd>BufferLast<cr>", desc = "Last" },
	--	{ "<leader>bc", "<cmd>BufferClose<cr>", desc = "Close" },
	--},
	--opts = {
	--	icons = {
	--		diagnostics = {
	--			[vim.diagnostic.severity.ERROR] = { enabled = true, icon = icons.diagnostics.Error },
	--			[vim.diagnostic.severity.WARN] = { enabled = true, icon = icons.diagnostics.Warn },
	--			[vim.diagnostic.severity.INFO] = { enabled = false, icon = icons.diagnostics.Info },
	--			[vim.diagnostic.severity.HINT] = { enabled = false, icon = icons.diagnostics.Hint },
	--		},
	--	},
	--},
	-- config = function(_, opts)
	--	local pass, barbar = pcall(require, "bufferline")
	--	if not pass then
	--		return
	--	end

	--	-- Offset
	--	local nvim_tree_events = require("nvim-tree.events")
	--	local bufferline_api = require("bufferline.api")

	--	local function get_tree_size()
	--		return require("nvim-tree.view").View.width
	--	end

	--	nvim_tree_events.subscribe("TreeOpen", function()
	--		bufferline_api.set_offset(get_tree_size() + 1)
	--	end)
	--
	--	nvim_tree_events.subscribe("Resize", function()
	--		bufferline_api.set_offset(get_tree_size() + 1)
	--	end)
	--
	--	nvim_tree_events.subscribe("TreeClose", function()
	--		bufferline_api.set_offset(0)
	--	end)
	--
	--	barbar.setup(opts)
	--end,
	--},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = {
				char = "▏",
			},
			exclude = {
				filetypes = { "help", "alpha", "NvimTree", "lazy" },
			},
		},
	},
}
