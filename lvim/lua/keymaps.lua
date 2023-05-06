local keymap = lvim.keys.normal_mode
local insert_keymap = lvim.keys.insert_mode
local which_keymap = lvim.builtin.which_key.mappings

which_keymap["P"] = {
  "<cmd>lua require'telescope'.extensions.project.project{}<CR>", "Projects"
}

keymap["<C-s>"] = ":w<cr>"
insert_keymap["kj"] = "<Esc>"

-- Telescope --
keymap["<C-p>"] = "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>"

-- Dap --
which_keymap['d'] = {
  name = 'Debug',
  v = {':DapSidebarToggle<cr>', "Sidebar Toggle"}
}
-- keymap["<leader>dv"] = ":DapSidebarToggle<cr>"

-- Buffer --
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

