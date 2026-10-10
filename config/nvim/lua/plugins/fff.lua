-- fff: file + grep picker backing LazyVim.pick for those commands.
-- Everything else (buffers, diagnostics, keymaps, ...) keeps using Snacks.
return {
  {
    "dmtrKovalenko/fff",
    lazy = false, -- the plugin lazy-initialises itself
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    opts = {},
    config = function(_, opts)
      require("fff").setup(opts)
      -- Runs after the snacks_picker extra registered, so its keymaps
      -- (<leader>ff, <leader>sg, ...) stay and dispatch here.
      ---@type LazyPicker
      local picker = {
        name = "fff",
        commands = {
          files = "files",
          live_grep = "grep",
          oldfiles = "recent",
        },
        ---@param command string
        ---@param pick_opts? lazyvim.util.pick.Opts
        open = function(command, pick_opts)
          pick_opts = pick_opts or {}
          if command == "files" then
            require("fff").find_files({ cwd = pick_opts.cwd })
          elseif command == "grep" then
            require("fff").live_grep({ cwd = pick_opts.cwd })
          elseif command == "grep_word" then
            require("fff").live_grep_under_cursor({ cwd = pick_opts.cwd })
          else
            return Snacks.picker.pick(command, pick_opts)
          end
        end,
      }
      local function activate()
        LazyVim.pick.picker = picker
      end
      activate()
      -- Re-assert after startup in case snacks (priority 1000) loads after us.
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = activate,
      })
    end,
  },
}
