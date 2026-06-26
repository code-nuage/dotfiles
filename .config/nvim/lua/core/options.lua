local theme = require("core.os-theme")

-- Line numbers
vim.opt.number, vim.opt.relativenumber = true, true

-- Indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Colorscheme
vim.cmd("colorscheme habamax")

-- Cursor
vim.opt.cursorline = true

if theme == "dark" then
    vim.api.nvim_set_hl(0, "CursorLine", {
        bg = "#38383C",
    })
    vim.api.nvim_set_hl(0, "ColorColumn", {
        bg = "#38383C",
    })
else
    vim.api.nvim_set_hl(0, "CursorLine", {
        bg = "#E5E5E5",
    })
    vim.api.nvim_set_hl(0, "ColorColumn", {
        bg = "#E5E5E5",
    })
end

vim.opt.colorcolumn = "100"

-- Special characters
vim.opt.list = true
vim.opt.listchars:append({
    nbsp = "␣",
    trail = "·",
    precedes = "«",
    extends = "»",
    tab = "> "
})

-- Remove every background color
vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", ctermbg = "none" })
