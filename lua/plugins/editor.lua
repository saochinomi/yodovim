return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>s", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>p", "<cmd>Telescope commands<CR>", desc = "Command palette" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
            width = 0.85,
          },
          prompt_prefix = "> ",
          selection_caret = "> ",
          file_ignore_patterns = {
            "^.git/",
            "^node_modules/",
            "^build/",
            "^dist/",
            "^.venv/",
            "^__pycache__/",
          },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>ghp", function() require("gitsigns").preview_hunk() end, desc = "Git: preview hunk" },
      { "<leader>ghb", function() require("gitsigns").blame_line() end, desc = "Git: blame line" },
      { "<leader>ghs", function() require("gitsigns").stage_hunk() end, desc = "Git: stage hunk" },
      { "<leader>ghr", function() require("gitsigns").reset_hunk() end, desc = "Git: reset hunk" },
      { "<leader>ghd", function() require("gitsigns").diffthis() end, desc = "Git: diff this" },
    },
    config = function()
      require("gitsigns").setup({})
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
    config = function()
      require("flash").setup({})
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({ delay = 120 })
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}