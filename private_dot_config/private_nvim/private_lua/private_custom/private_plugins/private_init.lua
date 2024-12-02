-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
    keys = function()
      local ht = require 'haskell-tools'
      local bufnr = vim.api.nvim_get_current_buf()
      local opts = { noremap = true, silent = true, buffer = bufnr }

      return {
        {
          '<leader>tr',
          function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
          end,
          opts,
          desc = '[T]oggle [R]epl',
        },
      }
    end,
  },
  {
    'andre-kotake/nvim-chezmoi',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    opts = {
      -- Your custom config
    },
    config = function(_, opts)
      require('nvim-chezmoi').setup(opts)
    end,
  },
}
