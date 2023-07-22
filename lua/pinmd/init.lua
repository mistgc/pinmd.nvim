local config = require("pinmd.config")

local M = {}

---@param opts? Options
function M.setup(opts)
    config.options = vim.tbl_deep_extend("force", {}, config.default_opts, opts or {})
end

-- get current workspace(vault) path
config.vault_path = vim.fn.getcwd()

return M
