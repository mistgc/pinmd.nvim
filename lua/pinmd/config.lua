---@class Config
local M = {}

M.namespace = vim.api.nvim_create_namespace("Pinmd")

---@class Options
M.default_opts = {
    files = {
        link_format = "absolute_path_in_vault", -- "relative_path_to_file", "absolute_path_in_vault"

        location_for_new_attachments = "vault_folder", -- "vault_folder", "specified_folder_in_vault"
        attachment_folder_path = ""
    }
}

---@type Options
M.options = {}

---@return string
M.get_link_format = function ()
    return M.options.files.link_format
end

---@return string
M.get_location_for_new_attachments = function ()
    return M.options.files.location_for_new_attachments
end

---@return string
M.get_attachment_folder_path = function ()
    return M.options.files.attachment_folder_path
end

M.vault_path = ""

return M
