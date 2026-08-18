return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        color_icons = true,
        override = {
          conf = { icon = "", color = "#9aa5ce", name = "Conf" },
          cfg = { icon = "", color = "#9aa5ce", name = "Cfg" },
          ini = { icon = "", color = "#9aa5ce", name = "Ini" },
          service = { icon = "", color = "#7dcfff", name = "Service" },
          socket = { icon = "", color = "#7dcfff", name = "Socket" },
          timer = { icon = "", color = "#7dcfff", name = "Timer" },
          target = { icon = "", color = "#7dcfff", name = "Target" },
          mount = { icon = "", color = "#7dcfff", name = "Mount" },
          desktop = { icon = "", color = "#bb9af7", name = "Desktop" },
          env = { icon = "", color = "#ff9e64", name = "Env" },
          log = { icon = "󰌱", color = "#e0af68", name = "Log" },
          lock = { icon = "", color = "#bb9af7", name = "Lock" },
          key = { icon = "", color = "#bb9af7", name = "Key" },
          pem = { icon = "", color = "#bb9af7", name = "Pem" },
          crt = { icon = "", color = "#bb9af7", name = "Crt" },
          iso = { icon = "", color = "#ff9e64", name = "Iso" },
          deb = { icon = "", color = "#ff9e64", name = "Deb" },
          rpm = { icon = "", color = "#ff9e64", name = "Rpm" },
          appimage = { icon = "", color = "#ff9e64", name = "Appimage" },
          tar = { icon = "", color = "#e0af68", name = "Tar" },
          gz = { icon = "", color = "#e0af68", name = "Gz" },
          xz = { icon = "", color = "#e0af68", name = "Xz" },
          makefile = { icon = "", color = "#9aa5ce", name = "Makefile" },
          dockerfile = { icon = "󰡨", color = "#7aa2f7", name = "Dockerfile" },
          editorconfig = { icon = "", color = "#9aa5ce", name = "Editorconfig" },
        },
      })
      require("nvim-web-devicons").set_up_highlights(true)
    end,
  },
}