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
    config = function() require('alpha').setup(require('alpha.themes.startify').config) end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 3,
      trim_scope = 'outer',
    },
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
          sort_by = 'insert_after_current',
          custom_filter = function(buf) return vim.bo[buf].filetype ~= 'alpha' end,
          get_element_icon = function(element)
            local devicons = require 'nvim-web-devicons'
            local icon, hl = devicons.get_icon_by_filetype(element.filetype, { default = false })
            if not icon and element.path:match '^term://' then
              icon, hl = devicons.get_icon_by_filetype('zsh', { default = false })
            end
            if not icon then
              icon, hl = devicons.get_icon(element.path, nil, { default = true })
            end
            if icon then return icon .. ' ', hl end
          end,
        },
        highlights = {
          separator = { fg = '#434c5e' },
          buffer_selected = {
            bold = true,
            italic = false,
          },
        },
      }
    end,
  },
}
