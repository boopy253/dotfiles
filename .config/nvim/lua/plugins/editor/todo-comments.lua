-- Highlight todo, notes, etc in comments
return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "[S]earch [T]ODOS" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous TODO Comment",
      },
    },
  },
}
