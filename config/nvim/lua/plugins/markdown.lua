return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_port = "7070"
      vim.g.mkdp_echo_preview_url = 1
    end,
  },
}
