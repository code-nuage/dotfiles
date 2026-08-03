return {
  "neovim/nvim-lspconfig",
  tag = "v2.5.0",
  config = function()
    local lspconfig = require("lspconfig")

    lspconfig.clangd.setup({
      on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })

    lspconfig.lua_ls.setup({})

    vim.diagnostic.config({
      virtual_text = true,
      signs = false,
      underline = true,
      update_in_insert = false,
    })
  end,
}
