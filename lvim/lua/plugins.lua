-- core --

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true

-- 
lvim.plugins = {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  {
    "ggandor/lightspeed.nvim",
    commit = "977ca1acdf8659ae0f7ac566d7fe06770661c9ce",
    event = "BufRead"
  },
  {
    "christoomey/vim-tmux-navigator"
  },
  {
    "ThePrimeagen/harpoon"
  }
}
