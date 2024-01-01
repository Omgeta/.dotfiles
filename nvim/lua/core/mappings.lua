-- Files
vim.keymap.set({ "n", "v" }, "<leader>w", "<cmd>w!<cr>", { desc = "Save File" })
vim.keymap.set({ "n", "v" }, "<leader>bd", "<cmd>bd<cr>", { desc = "Close" })
vim.keymap.set({ "n", "v" }, "<leader>q", "<cmd>q!<cr>", { desc = "Exit Editor" })

-- Buffer swapping
vim.keymap.set({ "n", "v" }, "<Tab>", "<cmd>bnext<cr>")
vim.keymap.set({ "n", "v" }, "<S-Tab>", "<cmd>bprev<cr>")

-- Keep cursor in middle
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Half page up
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Half page down
vim.keymap.set("n", "n", "<C-d>zz")
vim.keymap.set("n", "N", "<C-d>zz")

-- Move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Change Windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
