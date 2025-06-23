-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  vim.keymap.set('n', '<C-e>', ':Ex<CR>'),
  vim.keymap.set('n', '<C-x>', ':w<CR>:Ex<CR>'),
  vim.keymap.set('i', 'jk', '<C-o>'),
  vim.keymap.set('n', '<C-w>', ':w<CR>'),
}
