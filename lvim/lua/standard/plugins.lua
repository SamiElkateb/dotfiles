lvim.plugins = {
  { "folke/tokyonight.nvim" },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
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
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   commit = "87bdf2b216f3346abb099704c9bb45e5eb9df43a",
  --   ft = "java"
  -- }
}
