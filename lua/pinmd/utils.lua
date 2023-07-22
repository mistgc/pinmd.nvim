---@class Utils
local M = {}

-- https://github.com/ekickx/clipboard-image.nvim/blob/main/lua/clipboard-image/utils.lua
---@return string
function M.get_os()
    if vim.fn.has("win32") == 1 then
        return "Windows"
    end

    local this_os = tostring(io.popen("uname"):read())
    if this_os == "Linux" and vim.fn.readfile("/proc/version")[1]:lower():match("microsoft") then
        this_os = "Wsl"
    end
    return this_os
end

-- https://github.com/ekickx/clipboard-image.nvim/blob/main/lua/clipboard-image/utils.lua
---@return string
function M.get_clip_cmd()
    local cmd_check, cmd_paste = "", ""
    local this_os = M.get_os()
    if this_os == "Linux" then
        local display_server = os.getenv("XDG_SESSION_TYPE")
        if display_server == "x11" or display_server == "tty" then
            cmd_check = "xclip -selection clipboard -o -t TARGETS"
            cmd_paste = "xclip -selection clipboard -t image/png -o > '%s'"
        elseif display_server == "wayland" then
            cmd_check = "wl-paste --list-types"
            cmd_paste = "wl-paste --no-newline --type image/png > '%s'"
        end
    elseif this_os == "Darwin" then
        cmd_check = "pngpaste -b 2>&1"
        cmd_paste = "pngpaste '%s'"
    elseif this_os == "Windows" or this_os == "Wsl" then
        cmd_check = "Get-Clipboard -Format Image"
        cmd_paste = "$content = " .. cmd_check .. ";$content.Save('%s', 'png')"
        cmd_check = 'powershell.exe "' .. cmd_check .. '"'
        cmd_paste = 'powershell.exe "' .. cmd_paste .. '"'
    end
    return cmd_check, cmd_paste
end

---@param cmd string
---@return table
function M.get_clip_ctnt(cmd)
  local res = {}
  local output = io.popen(cmd)

  if output == nil then
    M.error("Get content of clipboard failed.")
    return res
  end

  for line in output:lines() do
      table.insert(res, line)
  end

  return res
end

---@param msg string
function M.warn(msg)
    vim.notify(msg, vim.log.levels.WARN, { title = "Pinmd" })
end

---@param msg string
function M.error(msg)
    vim.notify(msg, vim.log.levels.ERROR, { title = "Pinmd" })
end

return M
