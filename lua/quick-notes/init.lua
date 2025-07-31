-- Quick Notes Plugin - Main module
local M = {}

-- Default configuration
local config = {
  notes_dir = vim.fn.expand("~/notes"),
  default_note_name = "quick-note",
  date_format = "%Y-%m-%d_%H-%M-%S",
}

-- Helper function to ensure notes directory exists
local function ensure_notes_dir()
  local notes_dir = config.notes_dir
  if vim.fn.isdirectory(notes_dir) == 0 then
    vim.fn.mkdir(notes_dir, "p")
  end
  return notes_dir
end

-- Generate timestamped filename
local function generate_filename()
  local timestamp = os.date(config.date_format)
  return string.format("%s_%s.md", config.default_note_name, timestamp)
end

-- Create a new quick note
function M.create_note()
  local notes_dir = ensure_notes_dir()
  local filename = generate_filename()
  local filepath = notes_dir .. "/" .. filename
  
  -- Create and open the file
  vim.cmd("edit " .. filepath)
  
  -- Add basic template
  local lines = {
    "# Quick Note - " .. os.date("%Y-%m-%d %H:%M:%S"),
    "",
    "## Notes",
    "",
    "",
  }
  
  -- Set the lines and position cursor
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, {5, 0}) -- Position at empty line
  
  -- Enter insert mode
  vim.cmd("startinsert")
  
  print("Created note: " .. filename)
end

-- List all notes using telescope if available, otherwise use quickfix
function M.list_notes()
  local notes_dir = ensure_notes_dir()
  
  -- Check if telescope is available
  local has_telescope, telescope = pcall(require, "telescope.builtin")
  
  if has_telescope then
    telescope.find_files({
      prompt_title = "Quick Notes",
      cwd = notes_dir,
      search_file = "*.md",
    })
  else
    -- Fallback to basic file listing
    local files = vim.fn.glob(notes_dir .. "/*.md", false, true)
    if #files == 0 then
      print("No notes found in " .. notes_dir)
      return
    end
    
    -- Create quickfix list
    local qf_list = {}
    for _, file in ipairs(files) do
      table.insert(qf_list, { filename = file, text = vim.fn.fnamemodify(file, ":t") })
    end
    
    vim.fn.setqflist(qf_list)
    vim.cmd("copen")
  end
end

-- Search within notes using telescope live_grep or basic grep
function M.search_notes()
  local notes_dir = ensure_notes_dir()
  
  -- Check if telescope is available
  local has_telescope, telescope = pcall(require, "telescope.builtin")
  
  if has_telescope then
    telescope.live_grep({
      prompt_title = "Search Notes",
      cwd = notes_dir,
      additional_args = function()
        return { "--glob", "*.md" }
      end,
    })
  else
    -- Fallback to input and basic grep
    vim.ui.input({ prompt = "Search term: " }, function(input)
      if not input or input == "" then
        return
      end
      
      local cmd = string.format("grep -rn '%s' %s/*.md", input, notes_dir)
      local results = vim.fn.systemlist(cmd)
      
      if #results == 0 then
        print("No matches found for: " .. input)
        return
      end
      
      -- Parse results into quickfix format
      local qf_list = {}
      for _, result in ipairs(results) do
        local filename, lnum, text = result:match("([^:]+):(%d+):(.*)")
        if filename then
          table.insert(qf_list, {
            filename = filename,
            lnum = tonumber(lnum),
            text = text:gsub("^%s+", ""), -- trim leading whitespace
          })
        end
      end
      
      vim.fn.setqflist(qf_list)
      vim.cmd("copen")
    end)
  end
end

-- Setup function called by LazyVim
function M.setup(opts)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", config, opts or {})
  
  -- Create user commands
  vim.api.nvim_create_user_command("QuickNote", M.create_note, {
    desc = "Create a new quick note",
  })
  
  vim.api.nvim_create_user_command("QuickNoteList", M.list_notes, {
    desc = "List all quick notes",
  })
  
  vim.api.nvim_create_user_command("QuickNoteSearch", M.search_notes, {
    desc = "Search within quick notes",
  })
  
  -- Debug commands (only load in development)
  if config.debug then
    local debug = require("quick-notes.debug")
    debug.enable_debug()
    
    vim.api.nvim_create_user_command("QuickNoteDebug", debug.run_tests, {
      desc = "Run QuickNotes debug tests",
    })
    
    vim.api.nvim_create_user_command("QuickNoteInspect", debug.inspect_config, {
      desc = "Inspect QuickNotes configuration",
    })
  end
  
  print("Quick Notes plugin loaded! Notes directory: " .. config.notes_dir)
end

return M