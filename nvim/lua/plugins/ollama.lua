return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "Ollama", "OllamaModel" },
  keys = {
    {
      "<leader>oo",
      ":<c-u>Ollama<CR>",
      desc = "Open Ollama",
    },
  },
  opts = {
    model = "codellama", -- Default model to use
    url = "http://127.0.0.1:11434",
    serve = {
      on_start = false,
      command = "ollama",
      args = { "serve" },
    },
    -- Additional options as needed
  },
}
