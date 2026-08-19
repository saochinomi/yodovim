local M = {}

function M.pick()
  local session_dir = vim.fn.expand(require("persistence.config").options.dir)
  if vim.fn.isdirectory(session_dir) == 0 then
    vim.notify("No sessions yet", vim.log.levels.INFO)
    return
  end
  local sessions = vim.fn.glob(session_dir .. "/*.vim", false, true)
  if #sessions == 0 then
    vim.notify("No sessions yet", vim.log.levels.INFO)
    return
  end
  local results = {}
  for _, file in ipairs(sessions) do
    table.insert(results, {
      file = file,
      dir = vim.fn.fnamemodify(file, ":t:r"),
    })
  end
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local telescope_config = require("telescope.config").values

  local function load_selected(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    require("persistence").load({ session = selection.value })
  end

  pickers.new({}, {
    prompt_title = "Sessions",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return { value = entry.file, display = entry.dir, ordinal = entry.dir }
      end,
    }),
    sorter = telescope_config.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        load_selected(prompt_bufnr)
      end)
      map("n", "<CR>", function()
        load_selected(prompt_bufnr)
      end)
      return true
    end,
  }):find()
end

return M