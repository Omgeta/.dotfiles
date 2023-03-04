return {
	-- Common functions
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- Colorizer
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
}
