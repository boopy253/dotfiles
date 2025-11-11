return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Get the active lsp client
    local function get_lsp_clients()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then
        return ""
      end

      local client_names = {}
      local unique_names = {}

      for _, client in ipairs(clients) do
        if not unique_names[client.name] then
          table.insert(client_names, client.name)
          unique_names[client.name] = true
        end
      end

      return " " .. table.concat(client_names, ", ")
    end

    -- Get conform configured formatter
    local function get_formatter()
      -- Make sure conform loaded
      if not pcall(require, "conform") then
        return ""
      end

      local formatters = require("conform").get_formatters(0) -- 0 for buffer
      if #formatters == 0 then
        return ""
      end

      local formatter_names = {}
      for _, formatter in ipairs(formatters) do
        table.insert(formatter_names, formatter.name)
      end

      return "󰄬 " .. table.concat(formatter_names, ", ")
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch", icon = "" },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = {
          { get_lsp_clients },
          { get_formatter },
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " " },
          },
          "encoding",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = { "location" },
      },
      extensions = { "neo-tree" },
    })
  end,
}
