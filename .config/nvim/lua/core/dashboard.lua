local function show_dashboard()
  if vim.fn.argc() > 0 or vim.fn.line2byte("$") ~= -1 then
    return
  end

  local ascii = {
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⡿⣽⣻⣞⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⢿⣿⡿⣿⣿⣾⣯⢷⣂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣴⣾⣿⣿⣟⣾⣿⡿⣟⣿⣿⣾⣿⣟⣿⣿⣿⣿⣽⢣⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⣿⣿⣿⣿⣿⣿⢿⡿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣯⠻⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡶⣯⢻⢏⣿⣳⣾⣿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣏⢷⣺⣝⡾⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣯⣾⣷⣿⣿⣿⣿⣿⢿⡻⣟⡻⢿⢿⡛⣝⣶⣿⣾⣿⣻⢿⣿⣿⣾⡝⡶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⣿⣿⣿⢿⣽⣿⣿⣿⣿⣿⣿⣿⣹⣾⣯⣷⣿⣿⣞⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⡵⣩⠞⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⣽⡿⣟⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⢿⣯⢿⣱⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣘⢮⣟⣿⣽⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣟⢯⢞⣯⢖⠠⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠹⣾⡹⣞⣿⣽⣻⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡽⣟⣯⢟⣾⡹⢎⡗⣎⠒⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣌⢳⡽⣹⡞⣧⡟⣷⢫⣷⣻⢭⣻⡽⢯⣿⢿⣯⢿⣿⣟⡿⣿⢯⣟⣿⢾⡽⢯⢿⣹⢮⡟⡾⢡⣋⠼⡐⠂⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⠳⡌⣝⢲⡝⣯⢳⡞⣵⢫⣗⡻⣝⢾⣛⢾⣛⠾⣭⢻⡭⣟⢾⡹⢧⠻⣝⢮⡝⡾⠼⣍⠳⢌⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠘⢌⠣⠞⡰⢣⠚⡌⢧⡘⡱⢊⠞⢨⠓⡌⠳⣡⠓⡜⢌⠲⡉⢏⡱⢎⠲⡙⡜⠣⠎⠑⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠈⠈⠀⠀⠀⠁⠈⠀⠀⠀⠁⠀⠀⠀⠈⠀⠁⠈⠀⠈⠁⠈⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  }

  local buttons = {
    { key = "e", label = "New file", cmd = "enew" },
    { key = "r", label = "Recent files", cmd = "Telescope oldfiles" },
    { key = "q", label = "Quit", cmd = "qa" },
  }

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local win_width = vim.api.nvim_win_get_width(win)
  local win_height = vim.api.nvim_win_get_height(win)

  local function center(line)
    local pad = math.floor((win_width - vim.fn.strdisplaywidth(line)) / 2)
    return string.rep(" ", math.max(pad, 0)) .. line
  end

  local lines = {}
  for _, l in ipairs(ascii) do
    table.insert(lines, center(l))
  end
  table.insert(lines, "")
  local button_start_line = #lines
  for _, b in ipairs(buttons) do
    table.insert(lines, center(b.key .. ". " .. b.label))
  end

  local content_height = #lines
  local free_space = math.max(win_height - content_height, 0)
  local top_pad = math.floor(free_space / 2)
  local bottom_pad = free_space - top_pad
  for _ = 1, top_pad do
    table.insert(lines, 1, "")
  end
  for _ = 1, bottom_pad do
    table.insert(lines, "")
  end
  button_start_line = button_start_line + top_pad

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "dashboard"

  -- sauvegarde des options de fenêtre AVANT de les modifier
  local win_opts = { "number", "relativenumber", "cursorline", "signcolumn" }
  local saved = {}
  for _, opt in ipairs(win_opts) do
    saved[opt] = vim.api.nvim_get_option_value(opt, { win = win })
  end

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].cursorline = false
  vim.wo[win].signcolumn = "no"

  -- restauration dès qu'on quitte ce buffer précis
  vim.api.nvim_create_autocmd({ "BufWipeout", "BufLeave" }, {
    buffer = buf,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        for _, opt in ipairs(win_opts) do
          vim.api.nvim_set_option_value(opt, saved[opt], { win = win })
        end
      end
    end,
  })

  for _, b in ipairs(buttons) do
    vim.keymap.set("n", b.key, "<cmd>" .. b.cmd .. "<CR>", { buffer = buf, silent = true, nowait = true })
  end

  vim.api.nvim_win_set_cursor(win, { button_start_line + 1, 0 })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = show_dashboard,
})
