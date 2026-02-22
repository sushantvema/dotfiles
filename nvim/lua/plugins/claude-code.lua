return {
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      command = vim.fn.expand("~/.config/scripts/claude-nvim") .. " --dangerously-skip-permissions",
      window = {
        position = "vertical",
        split_ratio = 0.4,
      },
      command_variants = {
        continue = "--continue --dangerously-skip-permissions",
      },
      keymaps = {
        toggle = {
          normal = "<leader>ac",
          terminal = "<leader>ac",
          variants = {
            continue = "<leader>aC",
          },
        },
      },
    },
  },
}
