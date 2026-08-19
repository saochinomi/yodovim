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
      local function theme_color(hl)
        local c = vim.api.nvim_get_hl(0, { name = hl }).fg
        if type(c) == "number" then
          return string.format("#%06x", c)
        end
        return c or "#ffffff"
      end
      local function panel_fg(hl)
        if vim.g.colors_name == "wildcharm" then
          return "#000000"
        end
        return theme_color(hl)
      end
      local mode_colors = {
        n = "DiagnosticError",
        i = "HealthSuccess",
        v = "DiagnosticInfo",
        V = "DiagnosticInfo",
        ["\22"] = "DiagnosticInfo",
        c = "WarningMsg",
        R = "DiagnosticWarn",
        t = "DiagnosticInfo",
        s = "DiagnosticInfo",
        S = "DiagnosticInfo",
        ["\19"] = "DiagnosticInfo",
        ["!"] = "DiagnosticError",
      }
      local function mode_color()
        return { fg = panel_fg(mode_colors[vim.fn.mode()] or "DiagnosticInfo") }
      end
      local function bar()
        return "▊"
      end
      local function lsp_name()
        local buf_ft = vim.bo.filetype
        if buf_ft == "" then
          return ""
        end
        for _, client in ipairs(vim.lsp.get_clients()) do
          local fts = client.config.filetypes
          if fts and vim.fn.index(fts, buf_ft) ~= -1 then
            return " " .. client.name
          end
        end
        return ""
      end
      local function lualine_theme()
        if vim.g.colors_name ~= "wildcharm" then
          return "auto"
        end
        local st = { fg = "#000000", bg = "#ADADAD" }
        local theme = {}
        for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "terminal", "select", "inactive" }) do
          theme[mode] = { a = st, b = st, c = st, x = st, y = st, z = st }
        end
        return theme
      end
      require("lualine").setup({
        options = {
          theme = lualine_theme,
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          refresh = { statusline = 1000 },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { bar, color = function() return { fg = panel_fg("Title") } end },
            { mode, color = mode_color },
            filetype_with_icon,
            { "filename", path = 1 },
            "location",
            progress,
            {
              "diagnostics",
              symbols = { error = "  ", warn = "  ", info = "  ", hint = "  " },
            },
            { function() return "%=" end },
            { lsp_name, color = function()
              if vim.g.colors_name == "wildcharm" then
                return { fg = "#000000", gui = "bold" }
              end
              return { gui = "bold" }
            end },
          },
          lualine_x = {
            "branch",
            "diff",
            { clock, color = function() return { fg = panel_fg("Comment") } end },
            { bar, color = function() return { fg = panel_fg("Title") } end },
          },
          lualine_y = {},
          lualine_z = {},
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
          css = { names = true },
          html = { names = true },
          scss = { names = true },
          javascript = {},
          typescript = {},
          javascriptreact = {},
          typescriptreact = {},
          lua = {},
          python = {},
          json = {},
          markdown = {},
          svelte = {},
          vue = {},
        },
        user_default_options = {
          tailwind = true,
          names = false,
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