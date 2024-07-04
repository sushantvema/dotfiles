return {
  -- Add mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- List the LSPs, DAPs, linters, and formatters you want to have installed
        "lua-language-server",
        "pyright",
        "typescript-language-server",
        -- Add more tools here
      },
    },
  },
  -- Add configuration for nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        markdown_oxide = {
          setup = function()
            local capabilities =
              require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            capabilities.workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            }
            require("lspconfig").markdown_oxide.setup({
              capabilities = capabilities,
              on_attach = function(client, bufnr)
                -- Your custom on_attach function here
              end,
            })
          end,
        },
        lua_ls = {},
        pyright = {},
      },
    },
  },
}
