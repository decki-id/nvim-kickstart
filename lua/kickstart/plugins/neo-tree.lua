-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    filesystem = {
      bind_to_cwd = false,
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<cr>'] = function(state)
            local node = state.tree:get_node()
            if not node then return end
            if node.type ~= 'file' then
              require('neo-tree.sources.filesystem.commands').open(state)
              return
            end
            local path = node.path
            if not path then return end
            -- Find a normal (non-terminal, non-neo-tree) window first
            local target_win = nil
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype ~= 'terminal' and vim.bo[buf].filetype ~= 'neo-tree' then
                target_win = win
                break
              end
            end
            -- Fall back to a terminal window (file will replace terminal view)
            if not target_win then
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == 'terminal' then
                  target_win = win
                  break
                end
              end
            end
            if target_win then vim.api.nvim_set_current_win(target_win) end
            vim.cmd('edit ' .. vim.fn.fnameescape(path))
          end,
        },
      },
    },
  },
}
