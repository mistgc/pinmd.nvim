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

function M.get_separator()
  local this_os = M.get_os()
  if this_os == "Windows" then
    return "\\"
  else
    return "/"
  end
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

-- https://github.com/ekickx/clipboard-image.nvim/blob/main/lua/clipboard-image/utils.lua
---Check if clipboard contain image data
---See also: [Data URI scheme](https://en.wikipedia.org/wiki/Data_URI_scheme)
---@param content any #clipboard content
function M.is_clipboard_img(content)
  local this_os = M.get_os()
  if this_os == "Linux" and vim.tbl_contains(content, "image/png") then
    return true
  elseif this_os == "Darwin" and string.sub(content[1], 1, 9) == "iVBORw0KG" then -- Magic png number in base64
    return true
  elseif this_os == "Windows" or this_os == "Wsl" and content ~= nil then
    return true
  end
  return false
end

function M.maybe_create_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- https://github.com/ekickx/clipboard-image.nvim/blob/main/lua/clipboard-image/utils.lua
function M.insert_txt(affix, txt)
  local curpos = vim.fn.getcurpos()
  local line_num, line_col = curpos[2], curpos[3]
  local indent = string.rep(" ", line_col)
  local txt_topaste = string.format(affix, txt)

  ---Convert txt_topaste to lines table so it can handle multiline string
  local lines = {}
  for line in txt_topaste:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  for line_index, line in pairs(lines) do
    local current_line_num = line_num + line_index - 1
    local current_line = vim.fn.getline(current_line_num)
    ---Since there's no collumn 0, remove extra space when current line is blank
    if current_line == "" then
      indent = indent:sub(1, -2)
    end

    local pre_txt = current_line:sub(1, line_col)
    local post_txt = current_line:sub(line_col + 1, -1)
    local inserted_txt = pre_txt .. line .. post_txt

    vim.fn.setline(current_line_num, inserted_txt)
    ---Create new line so inserted_txt doesn't replace next lines
    if line_index ~= #lines then
      vim.fn.append(current_line_num, indent)
    end
  end
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
