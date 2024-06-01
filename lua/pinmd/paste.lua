local config = require("pinmd.config")
local utils = require("pinmd.utils")
local Image = require("pinmd.image")

local check_cmd, paste_cmd = utils.get_clip_cmd()

local M = {}

local function paste_img_to(dest)
  os.execute(string.format(paste_cmd, dest))
end

function M.paste_img()
  local content = utils.get_clip_ctnt(check_cmd)
  if utils.is_clipboard_img(content) ~= true then
    utils.error("There is no image data in clipboard")
  else
    ---@type Image
    local img = Image:new() -- create an image object
    utils.maybe_create_dir(img.dir_path)
    paste_img_to(img.path)
    utils.insert_txt(img.affix, img.link_txt)
  end
end

return M
