-- ~/.config/nvim/lua/plugins/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = false, -- 🚫 disables default marksman setup
    },
  },
}
