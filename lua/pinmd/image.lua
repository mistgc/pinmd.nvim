local config = require("pinmd.config")
local utils = require("pinmd.utils")

---@class Image
---@field name string
---@field affix string
---@field path string
---@field dir_path string
---@field link_txt string
local Image = {}
Image.__index = Image

---@param image Image
---@return string
local function generate_link_txt(image)
  local link = ""
  local path_cur_buf = vim.api.nvim_buf_get_name(0)
  local link_format = config.get_link_format()

  if config.have_set_specified_folder_in_vault() then
    if link_format == "absolute_path_in_vault" then
      link = config.get_attachment_folder_path() .. utils.get_separator() .. image.name
    else
      local path_cur_buf = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
      link = utils.generate_relative_path(path_cur_buf, image.path)
    end
  else
    link = image.name
  end

  return link
end

---@return Image
function Image:new()
  ---@type Image
  local image = {
    name = config.options.images.name() .. ".png",
    path = "",
    affix = config.options.filetype.default.affix,
    dir_path = config.vault_path,
    link_txt = "",
  }
  local filetype = vim.bo.filetype

  for k, v in pairs(config.options.filetype) do
    if k == filetype then
      image.affix = v.affix
    end
  end

  image.dir_path = vim.fs.normalize(config.vault_path .. utils.get_separator() .. config.get_attachment_folder_path())
  image.path = vim.fs.normalize(image.dir_path .. utils.get_separator() .. image.name)
  image.link_txt = generate_link_txt(image)

  setmetatable(image, self)

  return image
end

return Image
