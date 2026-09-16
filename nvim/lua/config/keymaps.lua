-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function copy_to_clipboard(path)
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Yanked path" })
end

local function current_abs()
  local abs = vim.api.nvim_buf_get_name(0)
  if abs == "" then
    vim.notify("Buffer has no file path", vim.log.levels.WARN)
    return nil
  end
  return vim.fs.normalize(abs)
end

local function current_rel()
  local abs = current_abs()
  if not abs then
    return nil
  end
  local root = vim.fs.normalize(LazyVim.root.get())
  if vim.startswith(abs, root .. "/") then
    return abs:sub(#root + 2)
  end
  return vim.fn.fnamemodify(abs, ":.")
end

vim.keymap.set("n", "<leader>fy", function()
  local path = current_rel()
  if path then
    copy_to_clipboard(path)
  end
end, { desc = "Yank Relative Path" })

vim.keymap.set("n", "<leader>fY", function()
  local path = current_abs()
  if path then
    copy_to_clipboard(path)
  end
end, { desc = "Yank Absolute Path" })
