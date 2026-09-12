vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 
opt.shiftwidth = 2 
opt.expandtab = true 
opt.autoindent = true 

opt.wrap = false 


opt.ignorecase = true 
opt.smartcase = true 

opt.cursorline = true



-- (have to use iterm2 or a...
opt.termguicolors = true
opt.background = "dark" --
opt.signcolumn = "yes" -- s...


opt.clipboard:append("unnamedplus")


-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
