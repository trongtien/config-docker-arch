local key_map = vim.keymap
vim.g.mapleader = " "
vim.g.maplocalleader = "  "

key_map.set("i", "jk", "<Esc>")

-- Save file and quit mode insert
key_map.set({ "n", "i" }, "<leader>ww", "<Esc><Cmd>w<CR>")  -- save, back to normal

-- Show exploer config
key_map.set("n", "<leader>pv", vim.cmd.Ex)

key_map.set("v", "J", ":m '>+1<CR>gv=gv")
key_map.set("v", "K", ":m '<-2<CR>gv=gv")


-- Move file config center view editor
key_map.set("n", "<C-d>", "<C-d>zz")
key_map.set("n", "<C-u>", "<C-u>zz")

-- Setting coppy file
key_map.set({ "n", "v" }, "<leader>y", [["+y]])
key_map.set("n", "<leader>Y", [["+Y]])

-- Change field mulptie
key_map.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- LSP binding
key_map.set("n", "<leader>lr", vim.lsp.buf.rename)
key_map.set({ "n", "v" }, "<leader>F", function()
    -- conform lo formatter ngoai (stylua/ruff), fallback sang LSP neu ft chua config
    require("conform").format({ async = true, lsp_format = "fallback" })
end)
key_map.set("n", "<leader>lR", vim.lsp.buf.references)
key_map.set("n", "<leader>ld", vim.lsp.buf.definition)
key_map.set("n", "<leader>lD", vim.lsp.buf.declaration)
key_map.set("n", "<leader>li", vim.lsp.buf.implementation)
key_map.set("n", "<leader>lt", vim.lsp.buf.type_definition)
key_map.set("n", "<leader>ca", vim.lsp.buf.code_action)
key_map.set("n", "<S-k>", vim.lsp.buf.hover)
key_map.set("n", "<leader>le", vim.diagnostic.open_float)
key_map.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
key_map.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)

-- Trouble
-- Diagnostics
key_map.set("n", "<leader>td", "<Cmd>Trouble diagnostics toggle<CR>")
key_map.set("n", "<leader>tD", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>")
key_map.set("n", "<leader>ts", "<Cmd>Trouble symbols toggle<CR>")
key_map.set("n", "<leader>tq", "<Cmd>Trouble qflist toggle<CR>")

-- Telescope
key_map.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files" })
key_map.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
key_map.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })
key_map.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find git" })
key_map.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find git" })

-- Git stuff
local bufnr = vim.api.nvim_get_current_buf()
local opts = {buffer = bufnr, remap = false}
vim.keymap.set("n", "<leader>gp", function()
    vim.cmd.Git('push')
end, opts)

-- rebase always
vim.keymap.set("n", "<leader>P", function()
    vim.cmd.Git({'pull',  '--rebase'})
end, opts)
key_map.set("n", "<leader>gs", vim.cmd.Git)
key_map.set("n", "gu", "<cmd>diffget //2<CR>")
key_map.set("n", "gh", "<cmd>diffget //3<CR>")
key_map.set("n", "<leader>gp", ":Git push -u origin ", opts);

