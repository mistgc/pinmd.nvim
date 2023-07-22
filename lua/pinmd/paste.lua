local config = require("pinmd.config")
local utils = require("pinmd.utils")

local check_cmd, paste_cmd = utils.get_clip_cmd()

local M = {}

local paste_img_to = function (dist)
  os.execute(string.format(paste_cmd, dist))
end

function M.paste_img()
    local vault_path = config.vault_path
end

return M
