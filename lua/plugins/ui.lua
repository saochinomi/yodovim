return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = { enabled = true },
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
        window = { width = 32 },
        default_component_configs = {
          indent = { with_expanders = true },
        },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "File explorer" })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          offsets = {
            { filetype = "neo-tree", text = "Explorer", padding = 1 },
          },
          show_close_icon = false,
          separator_style = "thin",
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-`>", "<cmd>ToggleTerm<CR>", mode = { "n", "i" }, desc = "Toggle terminal" },
      { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      {
        "<leader>gg",
        function()
          local term = require("toggleterm.terminal").Terminal:new({
            cmd = "lazygit",
            direction = "float",
          })
          term:toggle()
        end,
        desc = "Lazygit",
      },
    },
    config = function()
      require("toggleterm").setup({
        size = 15,
        direction = "horizontal",
        open_mapping = false,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>s", group = "Search" },
        { "<leader>g", group = "Git" },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
    },
  },
}