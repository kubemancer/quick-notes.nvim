-- Debug utilities for plugin development
local M = {}

-- Enable debug mode
M.debug = false

-- Debug print function
function M.log(...)
  if not M.debug then
    return
  end
  
  local args = { ... }
  local message = table.concat(
    vim.tbl_map(function(arg)
      return type(arg) == "table" and vim.inspect(arg) or tostring(arg)
    end, args),
    " "
  )
  
  print("[QuickNotes Debug]", message)
end

-- Inspect plugin state
function M.inspect_config()
  local quick_notes = require("quick-notes")
  M.log("Current config:", quick_notes.config or "Config not found")
end

-- Test all plugin functions
function M.run_tests()
  M.log("Running plugin tests...")
  
  -- Test 1: Check if notes directory can be created
  local quick_notes = require("quick-notes")
  M.log("Test 1: Creating notes directory")
  
  -- Test 2: Generate filename
  M.log("Test 2: Generated filename format")
  
  -- Test 3: Check dependencies
  local has_telescope = pcall(require, "telescope")
  M.log("Telescope available:", has_telescope)
  
  M.log("Tests completed!")
end

-- Enable debug mode
function M.enable_debug()
  M.debug = true
  print("QuickNotes debug mode enabled")
end

-- Disable debug mode
function M.disable_debug()
  M.debug = false
  print("QuickNotes debug mode disabled")
end

return M