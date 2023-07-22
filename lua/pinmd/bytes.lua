local M = {}

---@class ByteStream
---@field data any
local ByteStream = {}
ByteStream.__index = ByteStream

---@class StringStream: ByteStream
---@field offset number
---@field len number
local StringStream = {}
StringStream.__index = StringStream

---@param s string
---@return ByteStream
function ByteStream.from_string(s)
  local ss = StringStream:new(s)
  return ss
end

---@return ByteStream
function ByteStream:new()
    ---@type ByteStream
    local byte_stream = {
      data = {},
    }
    setmetatable(byte_stream, self)

    return byte_stream
end

---@return number
function ByteStream:get()
end

---@param s string
---@return StringStream
function StringStream:new(s)
  local ss = {
    data = s,
    len = s:len(),
    offset = 1
  }
  setmetatable(ss, self)

  return ss
end

---@return number
function StringStream:get()
  local byte = self.data:byte(self.offset)
  self.offset = self.offset + 1

  return byte
end


M.ByteStream = ByteStream
M.StringStream = StringStream

return M
