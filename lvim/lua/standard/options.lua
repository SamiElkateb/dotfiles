vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "jdtls",
})
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "tokyonight"
lvim.leader = "space"
vim.opt.relativenumber = true
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true

vim.opt.foldmethod = 'indent' -- syntax / indent
vim.opt.foldlevel = 20
vim.opt.foldclose = 'all'
vim.opt.foldenable = false

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- LSP --
lvim.lsp.installer.setup.ensure_installed = {
  "sumeko_lua",
  "pyright",
  "jsonls",
  "eslint",
  "tsserver",
  "jdtls"
}
