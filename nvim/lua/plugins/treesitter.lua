return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- List of languages to install
      ensure_installed = {
        "bash",
        "c",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "lua",
        "luau",
        "vim",
        "prisma",
        "rust",
      },

      highlight = {
        enable = true,
        disable = function(lang, buf) -- Disable highlighting when filesize is too large
          local max_fs = 100 * 1024 -- 100kB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if (ok and stats and stats.size > max_fs) or lang == "latex" then
            return true
          end
        end,
      },
      autopairs = { enable = true },
      autotag = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      local pass, tsconfig = pcall(require, "nvim-treesitter.configs")
      if not pass then
        return
      end
      tsconfig.setup(opts)
    end,
  },
}
