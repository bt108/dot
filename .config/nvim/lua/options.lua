local global = vim.g
local o = vim.opt

--o.ignorecase = true     -- ignore case in search patterns
o.smartcase = true      -- smart case
o.smartindent = false    -- make indenting smarter again
o.splitbelow = true     -- force all horizontal splits to go below current window
o.splitright = true     -- force all vertical splits to go to the right of current window
o.swapfile = false      -- creates a swapfile
o.undofile = true       -- enable persistent undo
o.expandtab = true      -- convert tabs to spaces
o.shiftwidth = 4        -- the number of spaces inserted for each indentation
o.tabstop = 4           -- insert 2 spaces for a tab
o.cursorline = true     -- highlight the current line
o.number = true         -- set numbered lines
--o.relativenumber = true -- show relative line number
o.signcolumn = "yes"    -- always show the sign column, otherwise it would shift the text each time
o.scrolloff = 3         -- minimal number of screen lines to keep above and below the cursor
o.laststatus = 0        -- disable statusline
o.title = true
-- o.background = 'light'
o.mouse = 'a'
o.hlsearch = false
o.showmode = false
o.ruler = false
o.showcmd = false
o.syntax = "on"
o.encoding = 'utf-8'
o.wildmode = {'longest', 'list', 'full'} -- autocompletion
vim.cmd [[colorscheme gruvbox]]

-- Wrapping settings
o.wrap = true                -- Enable line wrapping
o.linebreak = true           -- Don't break words in the middle
o.breakindent = true         -- Enable break indent
o.showbreak = '→'            -- Change the character to use for the break indicator

 -- Set the list characters
o.listchars = {
 --   eol = '$',
 --   space = '-',
 --   tab = '>#',
    trail = '-'
}

-- Enable list mode
o.list = true

-- Disable automatic commenting on newline
vim.cmd [[
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
]]

-- Save file as sudo on files that require root permission
vim.cmd [[
    cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
]]

-- -- Highlight unchanged lines in diff mode
-- if o.diff:get() then
--     vim.cmd('highlight! link DiffText MatchParen')
-- end
