return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = function()
    local harpoon = require 'harpoon'
    local keys = {
      {
        '<leader>m',
        function()
          harpoon:list():add()
        end,
        desc = 'Harpoon file',
      },
      {
        '<leader>e',
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'view harpooned files',
      },
    }
    return keys
  end,
}
