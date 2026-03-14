vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set


-- Available modes for key mappings:
-- <Space> Normal, Visual, Select and Operator-pending
-- n Normal
-- v Visual and Select
-- s Select
-- x Visual
-- o Operator-pending
-- ! Insert and Command-line
-- i Insert
-- l ":lmap" mappings for Insert, Command-line and Lang-Arg
-- c Command-line
-- t Terminal-Job

local function noremap(modes, lhs, rhs)
    -- If modes is a string, convert it to a table
    if type(modes) == 'string' then
        modes = { modes }
    end

    for _, mode in ipairs(modes) do
        vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
    end
end

---
--- (M)acros
---
noremap('n', '<leader>mdel', [[:%s/\n\{3,}/\r\r/g<CR>]]) -- delete duble empty lines
noremap('n', '<leader>mdtw', [[:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>]]) -- delete trailing white space
noremap('n', '<leader>mdlw', [[:let _s=@/<Bar>:%s/^[\s ]\+//e<Bar>:let @/=_s<Bar><CR>]]) -- delete leading white space matching \s and [U+2006 : SIX-PER-EM SPACE]
noremap('n', '<leader>mddw', [[:let _s=@/<Bar>:%s/\s\{2,\}/ /e<Bar>:let @/=_s<Bar><CR>]]) -- delete/collpase dubble whitespace into sinlge space


-- noremap('n', '<leader>mdn', [[:%s/^([0-9]\+)//g<CR>]]) -- remove numbers e.g. (1)
-- noremap('n', '<leader>msl', [[:%s/ /\r/g<CR>]]) -- replace spaces by newlines

-- noremap('n', '<leader>mwge', [[:%s/\(^[^ ].*\)/\\begin{glossy}\r\1\r\\end{glossy}/g<CR>]]) -- wrap lines with glossy env
-- noremap('n', '<leader>mwgm', [[:%s/\(^[^ \\].*\)/\\gloss{\1}{<++>}{}/g<CR>]]) -- single word lines in macro
-- noremap('v', '<leader>mwgm', [[:s/\(^[^ \\].*\)/\\gloss{\1}{<++>}{}/g<CR>]]) -- single word lines in macro

-- noremap('n', '<leader>miel', [[:%s/\v(^\\begin)/\r\r\1/<CR>]]) -- insert empty line before \begin

-- noremap('n', '<leader>ms;', [[:%s/; /\r/g<CR>]]) -- split ;
-- noremap('n', '<leader>mwe', [[:%s/– \?\(.*$\)/[\1]/g<CR>]]) -- wrap english in []

-- Snippits
map('v', '<leader>q', [[:g/^/ s/^/> / | s/$/  / | s/^>\s\+$// <CR>]], { noremap = true, silent = true })
map('n', '<leader>q', 'V:g/^/ s/^/> / | s/$/  /<CR>', { noremap = true, silent = true })

-- Jump to marker
map('n', ',,', ':keepp /<++><CR>ca<', { noremap = true, silent = true })
map('i', ',,', '<esc>:keepp /<++><CR>ca<', { noremap = true, silent = true })

---
--- Common remaps
---

map('n', 'c', '"_c', { noremap = true, silent = true }) --dont save
map('v', '.', ':normal .<CR>', { noremap = true, silent = true }) -- dot command on visual block
map('n', 'Q', 'gq', { noremap = true, silent = true }) -- hard wrap
--map('n', 'q:', '<Cmd>echo "command window disabled"<CR>') -- I hit it by exident when trying to :q

-- Yank Paste Primary register
map('n', '<leader>y', '"+y', { desc = 'Yank to clipboard'})
map('v', '<leader>y', '"+y', { desc = 'Yank to clipboard'})

map('n', '<leader>Y', '"+y$', { desc = 'Yank until EOL to clipboard'})
map('v', '<leader>Y', '"+y$', { desc = 'Yank until EOL to clipboard'})

map('n', '<leader>p', '"+p', { desc = 'Paste after cursor from clipboard' })
map('v', '<leader>p', '"_d"+P', { desc = 'Paste after cursor from clipboard (no yank)' })

map('n', '<leader>P', '"+P', { desc = 'Paste before cursor from clipboard' })

-- Yank Paste Selection register
-- map('n', '<leader><leader>y', '"*y', { desc = 'Yank to selection clipboard'})
-- map('v', '<leader><leader>y', '"*y', { desc = 'Yank to selection clipboard'})

-- map('n', '<leader><leader>Y', '"*y$', { desc = 'Yank until EOL to selection clipboard'})
-- map('v', '<leader><leader>Y', '"*y$', { desc = 'Yank until EOL to selection clipboard'})

-- map('n', '<leader><leader>p', '"_d"*p', { desc = 'Paste after cursor from selection clipboard (no yank)' })
-- map('v', '<leader><leader>p', '"_d"*P', { desc = 'Paste after cursor from selection clipboard (no yank)' })

-- map('n', '<leader><leader>P', '"_d"*P', { desc = 'Paste before cursor from selection clipboard (no yank)' })

-- Movement
map('n', 'j', 'gj', { noremap = true, silent = true })
map('n', 'gj', 'j', { noremap = true, silent = true })
map('n', 'k', 'gk', { noremap = true, silent = true })
map('n', 'gk', 'k', { noremap = true, silent = true })
map({"n", "x", "o"}, "s", "<Plug>(leap)")
noremap('n', '<c-j>', 'Lzz') -- page down 'scrolloff' as overlap
noremap('n', '<c-k>', 'Hzz') -- page up 'scrolloff' as overlap

-- UI
map('n', '<leader>uf', ':Goyo<CR>', { noremap = true, silent = true }) --focus mode
map('n', '<leader>us', ':setlocal spell! spelllang=en_us<CR>', { noremap = true, silent = true })  -- spell
map("n", "<Leader>uu", "<Cmd>UndotreeToggle<CR>")


-- Vim-serround default mappings
-- cs"<q> change seround original " new <q>
-- cst" same but t to match tag
-- ds" delete seround
-- ysiw] seround word under cursor iw is text object
-- usng { add space while } does not
-- yssb or yss) wraps the entire line (b and B is alternative for ) and } )
-- S<p> in Visual line mode

-- Find
map("n", "<Leader><Leader>", function()
    require("fzf-lua-frecency").frecency({
        cwd = require("oil").get_current_dir(),
        cwd_only = true,
    })
end)
map("n", "<Leader>ff", ":FzfLua files cwd=~/ <CR>")
map("n", "<Leader>fg", "<Cmd>FzfLua git_files<CR>")
map("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>")

-- File manager
map("n", "-", "<Cmd>Oil<CR>")
map("n", "_", "<Cmd>Oil .<CR>")

-- Windows
map("n", "<Leader>ws", "<Cmd>split<CR>")
map("n", "<Leader>wv", "<Cmd>vsplit<CR>")
map("n", "<Leader>wh", "<C-w>h")
map("n", "<Leader>wj", "<C-w>j")
map("n", "<Leader>wk", "<C-w>k")
map("n", "<Leader>wl", "<C-w>l")

-- Buffers
map("n", "<Leader>bd", function()
    require("mini.bufremove").delete()
end)

-- Git
-- map("n", "<Leader>gs", "<Cmd>Git<CR>")
-- map("n", "<Leader>gd", "<Cmd>Git diff<CR>")
-- map("n", "<Leader>gD", "<Cmd>Git diff --staged<CR>")
-- map("n", "<Leader>go", function()
--     require("mini.diff").toggle_overlay()
-- end)
-- map("n", "<Leader>gb", "<Cmd>Git blame<CR>")
-- map("n", "<Leader>gl", "<Cmd>Git log<CR>")
-- map("n", "<Leader>ghb", "<Cmd>silent !gh browse %<CR>")
-- map("n", "<Leader>ghr", "<Cmd>silent !gh repo view --web<CR>")

--- Markdown header

vim.keymap.set("n", "<leader>mh", function()
  local header = current_markdown_header()
  if header then
    vim.notify(header, vim.log.levels.INFO, { title = "Markdown Header" })
  else
    vim.notify("No header found", vim.log.levels.WARN, { title = "Markdown Header" })
  end
end, { desc = "Show current markdown header" })


-- Search and replace
map('n', 'S', ':%s//g<Left><Left>', { noremap = true })
map("n", "<Leader>/", "<Cmd>FzfLua grep_project<CR>")
map("n", "<Leader>?", "<Cmd>FzfLua live_grep<CR>")
map("n", "<Leader>sr", function()
    require("grug-far").open({
        prefills = {
            paths = vim.fn.expand("%"),
        },
    })
end)
map("n", "<Leader>sR", function()
    require("grug-far").grug_far({})
end)
