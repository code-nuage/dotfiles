-- Create floating window
local function create_floating_window()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })

  return buf, win
end

-- Open terminal in floating window
local function open()
  local buf, _ = create_floating_window()

  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  vim.fn.termopen(vim.o.shell)

  -- Enter insert mode automatically
  vim.cmd("startinsert")
end

vim.keymap.set("n", "\\t", function()
    open()
end, { noremap = true, silent = true })
