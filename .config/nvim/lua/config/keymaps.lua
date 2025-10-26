-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "[C]lear [H]ighlights" })

-- Disable arrow keys
vim.keymap.set("n", "<left>", '<cmd>echo "← Hint: h moves left"<CR>', { desc = "[D]isable [L]eft arrow" })
vim.keymap.set("n", "<right>", '<cmd>echo "→ Hint: l moves right"<CR>', { desc = "[D]isable [R]ight arrow" })
vim.keymap.set("n", "<up>", '<cmd>echo "↑ Hint: k moves up"<CR>', { desc = "[D]isable [U]p arrow" })
vim.keymap.set("n", "<down>", '<cmd>echo "↓ Hint: j moves down"<CR>', { desc = "[D]isable [D]own arrow" })

-- Allow continuous indentation in visual mode without exiting visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and maintain visual selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and maintain visual selection" })

-- Make normal mode indentation repeatable without requiring re-entry of commands
vim.keymap.set("n", ">", ">>", { desc = "Indent line right" })
vim.keymap.set("n", "<", "<<", { desc = "Indent line left" })
