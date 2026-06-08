return {
  {
    "dmmulroy/tsc.nvim",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    cmd = { "TSC", "TSCOpen", "TSCClose", "TSCStop" },
    opts = {
      auto_open_qflist = false,
      auto_close_qflist = false,
      auto_focus_qflist = false,
      auto_start_watch_mode = false,
      use_diagnostics = true,
      use_trouble_qflist = false,
      flags = {
        noEmit = true,
        watch = false,
      },
    },
    config = function(_, opts)
      require("tsc").setup(opts)

      local function open_tsc_picker_after_refresh()
        local started_at = vim.loop.now()
        local current = vim.fn.getqflist({ title = 0, changedtick = 0 })
        local previous_tick = current.changedtick or 0

        vim.cmd("TSC")

        local function try_open()
          local qf = vim.fn.getqflist({ title = 0, changedtick = 0, size = 0 })
          local timed_out = vim.loop.now() - started_at > 10000
          local refreshed = qf.title == "TSC" and (qf.changedtick or 0) ~= previous_tick

          if refreshed or timed_out then
            Snacks.picker.qflist()
            return
          end

          vim.defer_fn(try_open, 150)
        end

        vim.defer_fn(try_open, 150)
      end

      vim.keymap.set("n", "<leader>tt", "<cmd>TSC<cr>", { desc = "Typecheck Project" })
      vim.keymap.set("n", "<leader>tc", open_tsc_picker_after_refresh, { desc = "Typecheck Project Picker" })
      vim.keymap.set("n", "<leader>td", Snacks.picker.diagnostics, { desc = "Typecheck Diagnostics Picker" })
      vim.keymap.set("n", "<leader>tC", "<cmd>TSCOpen<cr>", { desc = "Typecheck Quickfix" })
      vim.keymap.set("n", "<leader>tx", "<cmd>TSCStop<cr>", { desc = "Stop Typecheck" })
    end,
  },
}
