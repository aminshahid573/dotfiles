return {
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
  },
}

