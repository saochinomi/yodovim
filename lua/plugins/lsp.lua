return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ruff",
        "mypy",
        "clang-format",
        "stylua",
        "typescript-language-server",
        "gopls",
        "intelephense",
        "ruby-lsp",
        "bashls",
        "html-lsp",
        "css-lsp",
        "jsonls",
        "yamlls",
        "sqls",
        "prettier",
        "gofmt",
        "shfmt",
        "shellcheck",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = bufnr, desc = "Diagnostics" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      end

      local function capabilities()
        local ok, blink = pcall(require, "blink.cmp")
        if ok then
          return blink.get_lsp_capabilities()
        end
        return vim.lsp.protocol.make_client_capabilities()
      end

      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "clangd", "lua_ls" },
        handlers = {
          function(server)
            require("lspconfig")[server].setup({
              on_attach = on_attach,
              capabilities = capabilities(),
            })
          end,
        },
      })

      vim.diagnostic.config({
        virtual_text = { prefix = "● " },
        signs = true,
        update_in_insert = false,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("blink.cmp").setup({
        keymap = {
          preset = "default",
          ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "fallback" },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        signature = { enabled = true },
        snippets = { preset = "luasnip" },
        completion = {
          documentation = { auto_show = true },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        python = { "mypy" },
      }
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        php = { "prettier" },
        go = { "gofmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_format = "fallback",
      },
    },
  },
  }