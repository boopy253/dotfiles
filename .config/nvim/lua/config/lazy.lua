-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- Clone lazy.nvim repository if it doesn't exist
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
    return
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Configure and load lazy.nvim with plugins
require("lazy").setup({
  spec = {
    -- Load all plugin specs from the 'plugins' directory
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.lsp" },
    { import = "plugins.dap" },
    { import = "plugins.lang" },
    { import = "plugins.coding" },
    { import = "plugins.tools" },
  },
  -- Colorschemes for initial install
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- Automatically check for plugin updates
  checker = {
    enabled = true, -- check for plugin updates periodically
  },
  performance = {
    rtp = {
      -- Disable unused built-in plugins for faster startup
      disabled_plugins = {
        "gzip",
        "zipPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "netrwPlugin",
      },
    },
  },
})

-- Automatically trigger plugin updates when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    -- delay execution
    vim.defer_fn(function()
      -- update and don't show update notifications or progress
      require("lazy").update({ show = false })
    end, 1000)
  end,
})
