--!strict
return {
  -- Common functions
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Colorizer
  {
    "catgoose/nvim-colorizer.lua",
    name = "colorizer", -- keep the new checkout separate from the old plugin
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup()
    end,
  },
}
