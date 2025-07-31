-- Health check for Quick Notes plugin
local M = {}

function M.check()
  vim.health.start("Quick Notes")
  
  -- Check if plugin is properly loaded
  local ok, quick_notes = pcall(require, "quick-notes")
  if ok then
    vim.health.ok("Quick Notes plugin loaded successfully")
  else
    vim.health.error("Quick Notes plugin failed to load: " .. tostring(quick_notes))
    return
  end
  
  -- Check notes directory
  local notes_dir = vim.fn.expand("~/notes")
  if vim.fn.isdirectory(notes_dir) == 1 then
    vim.health.ok("Notes directory exists: " .. notes_dir)
  else
    vim.health.warn("Notes directory does not exist: " .. notes_dir .. " (will be created on first use)")
  end
  
  -- Check for telescope
  local has_telescope = pcall(require, "telescope")
  if has_telescope then
    vim.health.ok("Telescope.nvim found - enhanced search available")
  else
    vim.health.warn("Telescope.nvim not found - using fallback search")
  end
  
  -- Check existing notes
  local notes_count = #vim.fn.glob(notes_dir .. "/*.md", false, true)
  if notes_count > 0 then
    vim.health.info(string.format("Found %d existing notes", notes_count))
  else
    vim.health.info("No existing notes found")
  end
end

return M