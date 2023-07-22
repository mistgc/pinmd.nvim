local config = require("pinmd.config")

local M = {}

---@param opts? Options
function M.setup(opts)
  -- get current workspace(vault) path
  config.vault_path = vim.fn.getcwd()
  config.options = vim.tbl_deep_extend("force", {}, config.default_opts, opts or {})

  require("pinmd.api.command")
end

return M
