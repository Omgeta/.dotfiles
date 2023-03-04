-- Files
vim.keymap.set({ "n", "v" }, "<leader>w", "<cmd>w!<cr>", { desc = "Save File" })
vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>bd<cr>", { desc = "Close Buffer" })
vim.keymap.set({ "n", "v" }, "<leader>q", "<cmd>q!<cr>", { desc = "Exit Editor" })

-- Keep cursor in middle
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Half page up
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Half page down
vim.keymap.set("n", "n", "<C-d>zz")
vim.keymap.set("n", "N", "<C-d>zz")

-- Move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
