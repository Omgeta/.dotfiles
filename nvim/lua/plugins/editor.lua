local util = require("core.utils")

return {
  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer Toggle" },
      { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "Explorer Focus" },
    },
    opts = {
      filters = {
        dotfiles = false,
      },
      hijack_cursor = true,
      update_cwd = true,
      update_focused_file = {
        enable = true,
        update_cwd = false,
      },
      view = {
        adaptive_size = true,
        side = "left",
        width = 25,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = { resize_window = true },
      },
      renderer = {
        group_empty = true,
        highlight_opened_files = "name",
        root_folder_label = function(path)
          return vim.fn.fnamemodify(path, ":t")
        end,
      },
    },
    config = function(_, opts)
      local pass, nvim_tree = pcall(require, "nvim-tree")
      if not pass then
        return
      end

      nvim_tree.setup(opts)
      local function open_nvim_tree(data)
        require("nvim-tree.api").tree.open()
      end

      vim.api.nvim_create_autocmd("VimEnter", { callback = open_nvim_tree })
    end,
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x", -- release
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      -- Files
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>ff", util.telescope("files", { previewer = false, cwd = false }), desc = "Files (cwd)" },
      { "<leader>fF", util.telescope("files", { previewer = false }), desc = "Files (root)" },
      { "<leader>fr", util.telescope("oldfiles", { previewer = false }), desc = "Recent Files" },
      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      -- Search
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sg", util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sG", util.telescope("live_grep"), desc = "Grep (root)" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Marks" },
      { "<leader>sw", util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
      { "<leader>sW", util.telescope("grep_string"), desc = "Word (root dir)" },
    },
    opts = {
      defaults = {
        winblend = 3,

        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },

        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",

        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        path_display = { "truncate" },
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,

        file_ignore_patterns = {
          "node_modules",
        },

        mappings = {
          n = {
            ["q"] = function(...)
              return require("telescope.actions").close(...)
            end,
          },
        },
      },

      extensions_list = { "fzf", "neoclip" },
    },
    config = function(_, opts)
      local pass, telescope = pcall(require, "telescope")
      if not pass then
        return
      end

      telescope.setup(opts)
      for _, ext in pairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- Mappings
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      win = {
        border = "rounded", -- none, single, double, shadow
        padding = { 2, 2 }, -- extra window padding [top, right, bottom, left]
        zindex = 1000,
        wo = {
          winblend = 0,
        },
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      triggers = {
        { "<leader>", mode = { "n", "v" } },
      },
    },
    config = function(_, opts)
      local pass, wk = pcall(require, "which-key")
      if not pass then
        return
      end

      vim.o.timeout = true
      vim.o.timeoutlen = 300
      wk.setup(opts)
      wk.add({
        { "<leader>", group = "Keybinds" },
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "File" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Search" },
        { "<leader>x", group = "Diagnostics" },
      })
    end,
  },

  -- Diagnostics
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- Clipboard
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = function()
      local function is_whitespace(line)
        return vim.fn.match(line, [[^\s*$]]) ~= -1
      end

      local function all(tbl, check)
        for _, entry in ipairs(tbl) do
          if not check(entry) then
            return false
          end
        end
        return true
      end

      return {
        filter = function(data)
          return not all(data.event.regcontents, is_whitespace)
        end,
        history = 100,
      }
    end,
  },

  -- Tmux Navigation
  {
    "christoomey/vim-tmux-navigator",
  },
}
