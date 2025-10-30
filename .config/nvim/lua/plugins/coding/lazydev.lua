-- Lua development support for Neovim configuration
-- Provides completion and type information for Neovim Lua API
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Dynamically loads luvit type definitions when vim.uv is referenced
        -- vim.uv provides access to libuv functionality for async operations
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
