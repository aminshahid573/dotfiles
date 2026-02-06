require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- Close Neovim if NvimTree is the last window
autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 then
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname:match("NvimTree_") ~= nil then
        vim.cmd("quit")
      end
    end
  end,
})


