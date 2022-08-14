local keymap = lvim.keys.normal_mode
keymap["<C-s>"] = ":w<cr>"

-- Telescope --
keymap["<C-p>"] = "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>"

-- Dap --

keymap["<leader>dv"] = ":DapSidebarToggle<cr>"
