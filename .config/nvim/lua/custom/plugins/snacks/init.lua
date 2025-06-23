return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  import = 'custom.plugins.snacks',
  opts = {
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = {
      enabled = true,
      configure = true,
    },
    scroll = { enable = true },
  },
  keys = {
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'LazyGit',
    },
  },
}
