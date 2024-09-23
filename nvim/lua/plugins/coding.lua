return {
	-- UltiSnips
	{
		"SirVer/ultisnips",
		lazy = true,
		config = function()
			-- Set ultisnip directory manually instead of slowly scanning the entire runtime path
			vim.g.UltiSnipsSnippetDirectories = { vim.env.VIMCONFIG .. "/UltiSnips" }
		end,
	},

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		lazy = true,
		opts = {
			enable_check_bracket_line = true, -- checks if next character is a close pair and it doesn't have an open pair in same line
			check_ts = true, -- treesitter
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
		end,
	},

	-- Autotag
	{
		"windwp/nvim-ts-autotag",
		lazy = true,
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"windwp/nvim-autopairs",
			"lukas-reineke/cmp-under-comparator",
			{
				"quangnguyen30192/cmp-nvim-ultisnips",
				dependencies = "SirVer/ultisnips",
			},
		},
		event = "InsertEnter",
		config = function()
			local pass_one, cmp = pcall(require, "cmp")
			local pass_two, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
			local pass_three, cmp_under = pcall(require, "cmp-under-comparator")
			local pass_four, cmp_ultisnips_mappings = pcall(require, "cmp_nvim_ultisnips.mappings")
			if not (pass_one and pass_two and pass_three and pass_four) then
				return
			end

			cmp.setup({
				sources = {
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "ultisnips" },
				},
				mapping = {
					["<cr>"] = cmp.mapping.confirm({ select = true }),
					["<s-tab>"] = cmp.mapping(function(fallback)
						cmp_ultisnips_mappings.jump_backwards(fallback)
					end, { "i", "s" }),
					["<tab>"] = cmp.mapping(function(fallback)
						cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
					end, { "i", "s" }),
				},
				formatting = {
					format = function(entry, item)
						item.kind = require("core.utils").icons.kinds[item.kind] .. item.kind
						item.menu = ({
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
						})[entry.source.name]

						return item
					end,
				},
				snippet = {
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
					end,
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp_under.under,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				enabled = function()
					-- disable completion in comments
					local context = require("cmp.config.context")
					-- keep command mode completion enabled when cursor is in a comment
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					else
						return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
					end
				end,
			})

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done()) -- add parentheses after selecting function or method item
		end,
	},

	-- VimTeX
	{
		"lervag/vimtex",
		lazy = false,
		keys = {
			{ "<leader>lo", "<cmd>VimtexCompile<cr>", desc = "Vimtex Compile" },
			{
				"<leader>lc",
				"<cmd>VimtexStop<cr><cmd>!rm *.synctex.gz<cr><cmd>VimtexClean<cr>",
				desc = "Vimtex Clean",
			},
			{ "<leader>le", "<cmd>VimtexErrors<cr>", desc = "Vimtex Errors" },
		},
		config = function()
			local pass, wk = pcall(require, "which-key")
			if pass then
				wk.add({
					{ "<leader>l", group = "Latex" },
				})
			end

			local g = vim.g
			local o = vim.o
			g.tex_flavor = "latex"
			g.vimtex_view_method = "zathura"
			g.vimtex_quickfix_mode = 0
			g.vimtex_synctex = 1
			g.tex_conceal = "abdmg"
			o.conceallevel = 2
			o.concealcursor = "nc"
		end,
	},
}
