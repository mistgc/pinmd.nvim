---@class Config
local M = {}

M.namespace = vim.api.nvim_create_namespace("Pinmd")

---@class Options
M.default_opts = {
    files = {
        link_format = "absolute_path_in_vault",

        location_for_new_attachments = "vault_folder", -- "vault_folder", "specified_folder_in_vault"
        attachment_folder_path = "assets/img/",
    },
    images = {
        ---@return string
        name = function()
            return tostring(os.date("%Y-%m-%d-%H-%M-%S"))
        end,
    },
    filetype = {
        default = {
            affix = "%s",
        },
        markdown = {
            affix = "![](%s)",
        },
        asciidoc = {
            affix = "image::%s[]",
        },
    },
}

---@return boolean
function M.have_set_specified_folder_in_vault()
    if M.options.files.location_for_new_attachments == "specified_folder_in_vault" then
        return true
    else
        return false
    end
end

---@return string
function M.get_link_format()
    return M.options.files.link_format
end

---@return string
function M.get_attachment_folder_path()
    if M.have_set_specified_folder_in_vault() then
        return M.options.files.attachment_folder_path
    else
        return ""
    end
end

---@type Options
M.options = {}

M.vault_path = ""

return M
