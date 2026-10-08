return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
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
        "eslint",
        "gopls",
        "svelte",
      }, -- list of servers
    },
    config = function(_, opts)
      local pass_two, handlers = pcall(require, "plugins.lsp.handlers")
      if not pass_two then
        return
      end

      -- Override autoformat
      handlers.autoformat = opts.autoformat

      -- Diagnostics
      local icons = require("core.utils").icons.diagnostics
      vim.diagnostic.config(vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.INFO] = icons.Info,
            [vim.diagnostic.severity.HINT] = icons.Hint,
          },
        },
      }))

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

        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end

      require("mason-lspconfig").setup {
        ensure_installed = opts.servers,
        automatic_enable = opts.servers, -- also enable servers when installation finishes
      }
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

      null_ls.setup {
        root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
        sources = {
          -- Web
          formatting.prettierd,
          -- Lua
          formatting.stylua,
          diagnostics.selene,
          -- Go
          formatting.gofumpt,
          formatting.goimports,
        },
        on_attach = handlers.on_attach,
      }
    end,
  },

  -- Install
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    -- Configured alongside the server list in nvim-lspconfig.
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "nvimtools/none-ls.nvim",
      "mason-org/mason.nvim",
    },
    cmd = { "NullInstall", "NullUninstall" },
    opts = {
      automatic_installation = true,
    },
  },

  -- Lua
  {
    "lopi-py/luau-lsp.nvim",
    ft = "luau",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      local handlers = require "plugins.lsp.handlers"
      return {
        server = { capabilities = handlers.capabilities },
      }
    end,
  },
}
