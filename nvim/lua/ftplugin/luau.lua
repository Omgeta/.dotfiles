vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.luau",
  callback = function()
    vim.bo.filetype = "luau"
  end,
})
