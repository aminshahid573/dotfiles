require("nvchad.configs.lspconfig").defaults()

local servers = { 
  "gopls",
  "html",
  "cssls",
  "postgres-language-server",
}
vim.lsp.enable(servers)

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      staticcheck = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
    },
  },
})

-- read :h vim.lsp.config for changing options of lsp servers 
