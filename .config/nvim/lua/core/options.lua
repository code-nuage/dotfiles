-- Line numbers
vim.opt.number, vim.opt.relativenumber = true, true

-- Indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Finder
vim.opt.path = "**"

-- Colorscheme
vim.cmd("colorscheme desert")

-- Cursor
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = "#38383C",
})
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

-- Let treesitter do its job
vim.opt.syntax = "off"

-- Remove every background color
vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", ctermbg = "none" })
