local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")

local result = handle:read("*a")
handle:close()

return result:match("default") and "light" or "dark"
