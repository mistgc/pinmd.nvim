local M = {}

local packages = {
    x11 = { name = "xclip", binary = "xclip" },
    tty = { name = "xclip", binary = "xclip" },
    wayland = { name = "wl_clipboard", binary = "wl-paste" },
    darwin = { name = "pngpaste", binary = "pngpaste" },
    windows = { name = "powershell", binary = "powershell.exe" },
    wsl = { name = "powershell", binary = "powershell.exe" }
}

return M
