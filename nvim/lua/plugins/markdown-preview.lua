return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- Use npm so the Node preview server gets tslib and friends.
    -- The Lua mkdp#util#install() form often no-ops under lazy.nvim
    -- (plugin not loaded yet), leaving app/node_modules empty.
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_theme = "light"
    end,
  },
}
