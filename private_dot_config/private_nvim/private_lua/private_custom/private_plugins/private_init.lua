--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'clojure-vim/vim-jack-in',
    dependencies = {
      'tpope/vim-dispatch',
      'radenling/vim-dispatch-neovim',
    },
  },
  {
    'Olical/conjure',
    ft = { 'clojure', 'fennel' }, -- etc
    lazy = true,
    init = function()
      -- Set configuration options here
      -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
      -- This is VERY helpful when reporting an issue with the project
      -- vim.g["conjure#debug"] = true
    end,

    -- Optional cmp-conjure integration
    dependencies = { 'PaterJason/cmp-conjure' },
  },
  {
    'PaterJason/cmp-conjure',
    lazy = true,
    config = function()
      local cmp = require 'cmp'
      local config = cmp.get_config()
      table.insert(config.sources, { name = 'conjure' })
      return cmp.setup(config)
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
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
