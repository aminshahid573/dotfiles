return {
  {
    "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
      require "configs.dadbod"
    end,
  },
}

