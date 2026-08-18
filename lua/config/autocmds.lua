local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "help", "man" },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function()
    local name = vim.fn.expand("%")
    if name ~= "" and vim.fn.isdirectory(name) == 1 then
      local dir = vim.fn.fnamemodify(name, ":p")
      local old = vim.api.nvim_get_current_buf()
      vim.cmd("enew")
      vim.schedule(function()
        require("neo-tree.command").execute({ action = "show", dir = dir })
        pcall(vim.api.nvim_buf_delete, old, { force = true })
      end)
    end
  end,
})