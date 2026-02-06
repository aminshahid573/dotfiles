require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Trigger completion manually
map("i", "<C-Space>", function()
  require("cmp").complete()
end, { desc = "Trigger completion" })

map("i", "<M-/>", function()
  require("cmp").complete()
end, { desc = "Trigger completion" })

-- Restart LSP (fixes stuck errors after downloading dependencies)
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP Restart" })

-- Dadbod UI Toggle
map("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle Dadbod UI" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- markdown preview

map("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown Preview Start" })
map("n", "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", { desc = "Markdown Preview Stop" })
map("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview Toggle" })
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Render" })
map("n", "<leader>gc", ":TermExec cmd='grpcurl -plaintext localhost:50051 list'<CR>", { desc = "List gRPC services" })

