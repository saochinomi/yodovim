return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "File explorer" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          bind_to_cwd = false,
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
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          vim.schedule(function()
            pcall(function()
              local manager = require("neo-tree.sources.manager")
              local state = manager.get_state("filesystem")
              if state and state.winid and state.winid ~= -1 then
                manager.navigate(state, vim.fn.getcwd())
              end
            end)
          end)
        end,
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local mode_icons = {
        n = { "", "NORMAL" },
        i = { "", "INSERT" },
        v = { "", "VISUAL" },
        V = { "", "V-LINE" },
        ["\22"] = { "", "V-BLOCK" },
        c = { "", "COMMAND" },
        R = { "", "REPLACE" },
        t = { "", "TERMINAL" },
        s = { "", "SELECT" },
        S = { "", "S-LINE" },
        ["\19"] = { "", "S-BLOCK" },
        ["!"] = { "", "EX" },
      }
      local function mode()
        local m = mode_icons[vim.fn.mode()]
        if not m then
          return vim.fn.mode():upper()
        end
        return m[1] .. " " .. m[2]
      end
      local function filetype_with_icon()
        local ft = vim.bo.filetype
        if ft == "" then
          return ""
        end
        local ok, devicons = pcall(require, "nvim-web-devicons")
        local icon = ""
        if ok then
          icon = devicons.get_icon(vim.fn.expand("%:t"), nil, { default = true }) or ""
        end
        return icon
      end
      local function clock()
        return " " .. os.date("%H:%M:%S")
      end
      local function progress()
        local cur = vim.fn.line(".")
        local total = vim.fn.line("$")
        if cur == 1 then
          return ""
        elseif cur == total then
          return ""
        else
          return string.format("%2d%%%%", math.floor(cur / total * 100))
        end
      end
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          refresh = { statusline = 1000 },
        },
        sections = {
          lualine_a = { mode },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
        },
        filetype_with_icon,
      },
          lualine_y = { progress },
          lualine_z = { "location", clock },
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
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        filetypes = {
          "css",
          "html",
          "scss",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "lua",
          "python",
          "json",
          "markdown",
          "svelte",
          "vue",
        },
        user_default_options = {
          tailwind = true,
          names = true,
          rgb_fn = true,
          hsl_fn = true,
        },
      })
      vim.schedule(function()
        pcall(require("colorizer").attach_to_buffer, vim.api.nvim_get_current_buf())
      end)
    end,
  },
}