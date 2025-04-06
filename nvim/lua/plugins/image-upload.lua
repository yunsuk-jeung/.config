return {
  {
    'yunsuk-jeung/image-paste.nvim',
    config = function() -- Function to read a specific key from a .env file
      local function read_env_var(key, filename)
        filename = filename or vim.fn.stdpath 'config' .. '/.env'
        local file = io.open(filename, 'r')
        if not file then
          error('Could not open .env file: ' .. filename)
        end

        for line in file:lines() do
          local env_key, value = line:match '([^=]+)=([^=]+)'
          if env_key == key then
            file:close()
            return value
          end
        end

        file:close()
        error('Key "' .. key .. '" not found in .env file')
      end

      -- Read IMGUR_CLIENT_ID from the .env file
      local imgur_client_id = read_env_var 'IMGUR_CLIENT_ID'

      require('image-paste').setup { imgur_client_id = imgur_client_id }
      vim.keymap.set('n', '<leader>pi', function()
        require('image-paste').paste_image()
      end, { noremap = true, silent = true, desc = 'Paste Image' })
    end,
  },
}
