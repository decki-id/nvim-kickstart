-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-mini/mini.icons' },
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
      'moll/vim-bbye',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('bufferline').setup {
        options = {
          themable = true,
          close_command = 'Bdelete! %d',
          modified_icon = '•',
          color_icons = true,
          show_buffer_icons = true,
          separator_style = { '|', '|' },
          show_tab_indicators = false,
          indicator = { style = 'none' },
        },
        highlights = {
          separator = { fg = '#434c5e' },
          buffer_selected = {
            bold = true,
            italic = false,
          }
        }
      }
    end,
  }
}
