
local opt = vim.opt

-- 行番号の表示.
opt.number = true

-- タブとインデントの設定.
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- 検索設定.
opt.ignorecase = true
opt.smartcase = true

-- システムクリップボードを有効.
opt.clipboard:append("unnamedplus")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndofBuffer", { bg = "none" })
