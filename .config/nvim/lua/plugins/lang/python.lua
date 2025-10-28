return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      -- optional: you can also use fzf-lua, snacks, mini-pick instead.
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    -- Load when opening Python files
    ft = "python",
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
    opts = {
      search = {},
      options = {},
    },
  },
}
