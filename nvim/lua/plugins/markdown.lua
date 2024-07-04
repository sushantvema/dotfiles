return {
  -- add symbols-outline
  -- {
  --   "ixru/nvim-markdown",
  --   cmd = "",
  --   keys = { { "<leader>nn", "<cmd>NoNeckPain<cr>", desc = "[N]o [N]eckpain" } },
  -- },
  --
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   ft = { "markdown" },
  --   build = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  -- },
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   opts = {},
  -- },
  {
    "MeanderingProgrammer/markdown.nvim",
    as = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    after = { "nvim-treesitter" }, -- Mandatory
    requires = { "nvim-tree/nvim-web-devicons", opt = true }, -- Optional but recommended
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
