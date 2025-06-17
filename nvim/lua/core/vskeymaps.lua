local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Normal mode mappings for folding
map('n', 'za', "<Cmd>call VSCodeNotify('editor.toggleFold')<CR>", opts)
map('n', 'zR', "<Cmd>call VSCodeNotify('editor.unfoldAll')<CR>", opts)
map('n', 'zM', "<Cmd>call VSCodeNotify('editor.foldAll')<CR>", opts)
map('n', 'zo', "<Cmd>call VSCodeNotify('editor.unfold')<CR>", opts)
map('n', 'zO', "<Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>", opts)
map('n', 'zc', "<Cmd>call VSCodeNotify('editor.fold')<CR>", opts)
map('n', 'zC', "<Cmd>call VSCodeNotify('editor.foldRecursively')<CR>", opts)

-- Fold level mappings
map('n', 'z1', "<Cmd>call VSCodeNotify('editor.foldLevel1')<CR>", opts)
map('n', 'z2', "<Cmd>call VSCodeNotify('editor.foldLevel2')<CR>", opts)
map('n', 'z3', "<Cmd>call VSCodeNotify('editor.foldLevel3')<CR>", opts)
map('n', 'z4', "<Cmd>call VSCodeNotify('editor.foldLevel4')<CR>", opts)
map('n', 'z5', "<Cmd>call VSCodeNotify('editor.foldLevel5')<CR>", opts)
map('n', 'z6', "<Cmd>call VSCodeNotify('editor.foldLevel6')<CR>", opts)
map('n', 'z7', "<Cmd>call VSCodeNotify('editor.foldLevel7')<CR>", opts)

-- Visual mode mapping
map('x', 'zV', "<Cmd>call VSCodeNotify('editor.foldAllExcept')<CR>", opts)
