-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.foldmethod = "manual"
vim.diagnostic.enable(false)
vim.opt.spell = false
vim.opt.shell = "/opt/homebrew/bin/bash"
vim.opt.wrap = true
vim.opt.linebreak = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.opt.tabstop = 4 -- render tabs as 4 spaces wide

vim.g.lazyvim_ts_lsp = "vtsls"
