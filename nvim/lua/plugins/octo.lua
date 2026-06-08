return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      picker = "snacks",
      enable_builtin = true,
      use_local_fs = true,
      default_merge_method = "squash",
      suppress_missing_scope = { projects_v2 = true },
    },
    keys = {
      { "<leader>O", "", desc = "+octo" },
      { "<leader>Op", "<cmd>Octo pr list<cr>", desc = "PR list" },
      { "<leader>OP", "<cmd>Octo pr search<cr>", desc = "PR search" },
      { "<leader>Oe", "<cmd>Octo pr edit<cr>", desc = "PR edit (title/body)" },
      { "<leader>Or", "<cmd>Octo review start<cr>", desc = "Review start" },
      { "<leader>OR", "<cmd>Octo review resume<cr>", desc = "Review resume" },
      { "<leader>Os", "<cmd>Octo review submit<cr>", desc = "Review submit" },
      { "<leader>Oi", "<cmd>Octo issue list<cr>", desc = "Issue list" },
    },
  },
}
