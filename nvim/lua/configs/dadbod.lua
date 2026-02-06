vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_navigation = 1

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    require("cmp").setup.buffer {
      sources = {
        { name = "vim-dadbod-completion" },
      },
    }
  end,
})

