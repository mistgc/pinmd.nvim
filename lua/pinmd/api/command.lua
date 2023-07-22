local paste_img = require("pinmd.paste").paste_img

vim.api.nvim_create_user_command("PinmdPaste", paste_img, {
  desc = "Paste an image from clipboard",
  nargs = 0,
})
