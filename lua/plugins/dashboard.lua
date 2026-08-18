return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "akinsho/toggleterm.nvim",
      "folke/persistence.nvim",
    },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.opts.opts.autostart = false

      local function open_lazygit()
        local term = require("toggleterm.terminal").Terminal:new({
          cmd = "lazygit",
          direction = "float",
        })
        term:toggle()
      end

      local function recent_files()
        local files = {}
        local seen = {}
        local ok, devicons = pcall(require, "nvim-web-devicons")
        for _, path in ipairs(vim.v.oldfiles) do
          local name = vim.fn.fnamemodify(path, ":t")
          if name ~= "" and vim.fn.filereadable(path) == 1 and not seen[name] then
            local icon = ""
            if ok then
              icon = devicons.get_icon(path, nil, { default = false }) or ""
            end
            table.insert(files, { path = path, name = icon .. " " .. name })
            seen[name] = true
          end
          if #files >= 8 then
            break
          end
        end
        return files
      end

      dashboard.section.header.val = {
        "██╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "╚██╗ ██╔╝██╔═══██╗██╔══██╗██╔═══██╗██║   ██║██║████╗ ████║",
        " ╚████╔╝ ██║   ██║██║  ██║██║   ██║██║   ██║██║██╔████╔██║",
        "  ╚██╔╝  ██║   ██║██║  ██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "   ██║   ╚██████╔╝██████╔╝╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "   ╚═╝    ╚═════╝ ╚═════╝  ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.header.opts.position = "center"

      dashboard.section.buttons.val = {
        dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("n", "  New file", "<cmd>ene<CR>"),
        dashboard.button("t", "  Themes", function()
          require("config.theme").pick()
        end),
        dashboard.button("s", "  Recent sessions", function()
          require("config.sessions").pick()
        end),
        dashboard.button("g", "  Git status", open_lazygit),
        dashboard.button("c", "  Edit config", "<cmd>e " .. vim.fn.stdpath("config") .. "/init.lua<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.buttons.opts.spacing = 0
      dashboard.section.buttons.opts.position = "center"

      dashboard.section.mru = {
        type = "group",
        val = {
          {
            type = "text",
            val = "  Recent files",
            opts = { hl = "AlphaHeaderLabel", position = "center" },
          },
          {
            type = "group",
            val = function()
              local buttons = {}
              for _, file in ipairs(recent_files()) do
                table.insert(buttons, {
                  type = "button",
                  val = file.name,
                  on_press = function()
                    vim.cmd("e " .. vim.fn.fnameescape(file.path))
                  end,
                  opts = {
                    hl = "AlphaButtons",
                    keymap = {
                      "n",
                      "<CR>",
                      ":e " .. vim.fn.fnameescape(file.path) .. "<CR>",
                      { noremap = true },
                    },
                  },
                })
              end
              return buttons
            end,
          },
        },
        opts = { position = "center", spacing = 0 },
      }

      dashboard.section.footer.val = function()
        local version = vim.version()
        local plugins = vim.tbl_count(require("lazy").plugins())
        local elapsed = (vim.uv.hrtime() - vim.g.yodovim_start) / 1e6
        return {
          "Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch .. " · " .. plugins .. " plugins",
          "Запуск: " .. string.format("%.0f", elapsed) .. " ms",
        }
      end
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.section.footer.opts.position = "center"

      dashboard.opts.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.mru,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.opts)

      vim.keymap.set("n", "<leader>da", "<cmd>Alpha<CR>", { desc = "Dashboard" })

      vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        callback = function()
          vim.schedule(function()
            local remaining = 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if
                vim.api.nvim_buf_is_valid(buf)
                and vim.bo[buf].buflisted
                and vim.api.nvim_buf_get_name(buf) ~= ""
              then
                remaining = remaining + 1
              end
            end
            if remaining == 0 and vim.bo.filetype ~= "alpha" then
              local empty = vim.api.nvim_get_current_buf()
              require("alpha").start(false)
              if vim.api.nvim_buf_is_valid(empty) and vim.api.nvim_get_current_buf() ~= empty then
                pcall(vim.api.nvim_buf_delete, empty, { force = true })
              end
            end
          end)
        end,
      })

      local function show_dashboard_or_session()
        if vim.fn.argc() ~= 0 then
          return
        end
        local ok, last = pcall(require("persistence").last)
        if ok and last and vim.fn.filereadable(last) == 1 then
          require("persistence").load({ last = true })
        else
          require("alpha").start(false)
        end
      end
      show_dashboard_or_session()
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    config = function(_, opts)
      require("persistence").setup(opts)
      vim.keymap.set("n", "<leader>qs", function()
        require("config.sessions").pick()
      end, { desc = "Sessions" })
    end,
  },
}