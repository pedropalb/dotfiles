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
      local opts = { ft = 'haskell', noremap = true, silent = true, buffer = bufnr }

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
    lazy = false,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    keys = {
      { '<leader>sc', ':ChezmoiManaged<CR>', desc = '[S]earch [C]hezmoi managed files' },
    },
    opts = {
      edit = {
        -- Automatically apply file on save. Can be one of: "auto", "confirm" or "never"
        apply_on_save = 'never',
      },
    },
    config = function(_, opts)
      require('nvim-chezmoi').setup(opts)
    end,
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python', --optional
      {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    },
    lazy = true,
    branch = 'regexp', -- This is the regexp branch, use this for the new version
    config = function()
      require('venv-selector').setup {
        auto_refresh = true,
        name = { 'venv', '.venv' },
        dap_enabled = true,
      }
    end,
    keys = {
      { ',v', '<cmd>VenvSelect<cr>' },
    },
    ft = { 'python' },
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = false,
    config = function()
      -- require('telescope').load_extension 'refactoring'
      require('refactoring').setup()
    end,
    -- keys = function()
    --   local telescope = require 'telescope'
    --
    --   return {
    --     {
    --       '<leader>rr',
    --       function()
    --         telescope.extensions.refactoring.refactors()
    --       end,
    --       desc = 'Refactorings',
    --     },
    --   }
    -- end,
  },
  {
    'Pocco81/auto-save.nvim',
    ft = { 'python' },
  },
}
