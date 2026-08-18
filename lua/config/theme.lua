local M = {}

local themes = {
  { "yodovim", "Yodovim (черно-белая)" },
  { "tokyonight", "TokyoNight" },
  { "gruvbox", "Gruvbox" },
  { "nord", "Nord" },
  { "dracula", "Dracula" },
  { "everforest", "Everforest" },
  { "nightfox", "Nightfox" },
  { "kanagawa", "Kanagawa" },
  { "onedark", "One Dark" },
  { "habamax", "Habamax" },
  { "retrobox", "Retrobox" },
  { "slate", "Slate" },
  { "torte", "Torte" },
  { "zellner", "Zellner" },
  { "wildcharm", "Wildcharm" },
  { "koehler", "Koehler" },
  { "pablo", "Pablo" },
  { "peachpuff", "Peachpuff" },
  { "evening", "Evening" },
}

local function state_file()
  return vim.fn.stdpath("state") .. "/yodovim/theme"
end

function M.load()
  local name = "tokyonight"
  local ok, lines = pcall(vim.fn.readfile, state_file())
  if ok and lines and #lines > 0 then
    for _, t in ipairs(themes) do
      if t[1] == lines[1] then
        name = lines[1]
        break
      end
    end
  end
  local applied = pcall(vim.cmd.colorscheme, name)
  if not applied then
    vim.cmd.colorscheme("yodovim")
  end
end

function M.apply(name)
  local ok = pcall(vim.cmd.colorscheme, name)
  if ok then
    vim.fn.mkdir(vim.fn.fnamemodify(state_file(), ":h"), "p")
    pcall(vim.fn.writefile, { name }, state_file())
  end
end

function M.pick()
  local current = vim.g.colors_name
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  local picker = require("telescope.pickers").new({}, {
    prompt_title = "Themes",
    finder = require("telescope.finders").new_table({
      results = themes,
      entry_maker = function(t)
        local mark = (current == t[1] or (current and current:find(t[1], 1, true) == 1)) and "" or "  "
        return {
          value = t[1],
          display = mark .. t[2],
          ordinal = t[2],
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      local function apply_selected(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry then
          M.apply(entry.value)
        end
      end
      map("i", "<CR>", apply_selected)
      map("n", "<CR>", apply_selected)
      return true
    end,
  })
  picker:find()
end

return M