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
    if name ~= "" and vim.fn.isdirectory(name) == 1 and not vim.g.opening_folder then
      vim.g.opening_folder = true
      local dir = vim.fn.fnamemodify(name, ":p")
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if
          vim.api.nvim_buf_is_valid(buf)
          and (vim.bo[buf].filetype == "alpha" or vim.b[buf].yodo_alpha)
        then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end
      vim.cmd("enew")
      vim.schedule(function()
        require("neo-tree.command").execute({ action = "show", dir = dir })
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if
            vim.api.nvim_buf_is_valid(buf)
            and vim.fn.fnamemodify(vim.fn.bufname(buf), ":p") == dir
          then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
        vim.g.opening_folder = nil
      end)
    end
  end,
})