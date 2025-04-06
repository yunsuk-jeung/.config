vim.api.nvim_create_user_command('BufOnlyVisible', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.bufwinnr(buf) == -1 then -- Check if buffer is not visible in any window
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, {})
