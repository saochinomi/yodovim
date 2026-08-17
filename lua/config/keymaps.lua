local map = vim.keymap.set

map("n", "<C-s>", "<cmd>write<CR>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>write<CR>", { desc = "Save" })
map("n", "<C-q>", "<cmd>quit<CR>", { desc = "Quit" })
map("n", "<C-n>", "<cmd>ene<CR>", { desc = "New file" })

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
map("n", "<leader>c", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>n", function()
  vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle line numbers" })

map("n", "<leader>h", "<C-w>h", { desc = "Window: left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window: down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window: up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window: right" })
map("n", "<leader>=", "<C-w>=", { desc = "Window: equalize" })
map("n", "<leader>-", "<C-w>s", { desc = "Window: split" })
map("n", "<leader>|", "<C-w>v", { desc = "Window: vsplit" })