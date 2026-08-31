vim.filetype.add {
  extension = {
    launch = 'xml',
  },
}

vim.api.nvim_create_user_command('BufOnlyVisible', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.bufwinnr(buf) == -1 then -- Check if buffer is not visible in any window
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, {})

if vim.fn.exists(':LspInfo') == 0 then
  vim.api.nvim_create_user_command('LspInfo', function()
    vim.cmd 'checkhealth vim.lsp'
  end, { desc = 'Alias to :checkhealth vim.lsp' })
end

if vim.fn.exists(':LspRestart') == 0 then
  vim.api.nvim_create_user_command('LspRestart', function(opts)
    local filter = {}
    if opts.args and opts.args ~= '' then
      filter.name = opts.args
    end
    local clients = vim.lsp.get_clients(filter)
    for _, client in ipairs(clients) do
      local bufs = vim.lsp.get_buffers_by_client_id(client.id)
      client:stop()
      vim.defer_fn(function()
        local new_client = vim.lsp.start(client.config)
        if new_client then
          for _, buf in ipairs(bufs) do
            vim.lsp.buf_attach_client(buf, new_client)
          end
        end
      end, 500)
    end
  end, { nargs = '?', desc = 'Restart LSP clients' })
end
