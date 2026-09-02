vim.opt.encoding = "UTF-8"
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.errorbells = false
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undodir = vim.env.HOME .. "/.vim/undodir"
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300
vim.opt.cmdheight = 2
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.listchars = {
    space = ".",
    tab = ">~",
}

vim.cmd [[
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]
