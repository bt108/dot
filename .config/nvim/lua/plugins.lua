local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
    -- {{{ UI
    {
        "https://github.com/ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
    },
    {
        "https://github.com/lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        config = function()
            require("ibl").setup({
                indent = {
                    char = "▏",
                    tab_char = "→",
                },
                scope = {
                    enabled = false,
                },
            })
        end,
    },
    -- }}}

    -- {{{ Search
    {
        "https://github.com/ibhagwan/fzf-lua",
        dependencies = {
            "https://github.com/elanmed/fzf-lua-frecency.nvim",
        },
        event = "VeryLazy",
        config = function()
            require("fzf-lua").setup({
                "max-perf",
                winopts = {
                    height = 0.5,
                    width = 1,
                    row = 1,
                },
            })
            require("fzf-lua").register_ui_select()
            require("fzf-lua-frecency").setup({
                display_score = false,
            })
        end,
    },

    { "https://github.com/MagicDuck/grug-far.nvim", lazy = true },
    -- }}}

    -- {{{ Completions
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },
    
      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',
    
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'super-tab' },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },
    
        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },
    
        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    
        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    --- }}}
    
    -- {{{ File manager
    {
        "https://github.com/stevearc/oil.nvim",
        cmd = "Oil",
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, _)
                        return name == ".."
                    end,
                },
            })
        end,
    },
    -- }}}

    -- {{{ Git
    { "https://github.com/jreybert/vimagit"},

    {
        "https://github.com/nvim-mini/mini.diff",
        event = "VeryLazy",
        config = function()
            require("mini.diff").setup({})
        end,
    },
    -- }}}

    -- {{{ Motions
    {
        "https://codeberg.org/andyg/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("leap").opts.safe_labels = ""
            vim.api.nvim_set_hl(0, "LeapLabel", { fg = "black", bold = true })
        end,
    },

    -- }}}

    -- {{{ Miscellaneous
    { "https://github.com/farmergreg/vim-lastplace", event = "BufReadPost" },
    { "https://github.com/tpope/vim-commentary" },
    { "https://github.com/junegunn/goyo.vim" },
    { "https://github.com/tpope/vim-surround" },
    { "https://github.com/nvim-mini/mini.bufremove", lazy = true },
    { "https://github.com/mbbill/undotree", event = "VeryLazy" },

    {
        "https://github.com/tpope/vim-sleuth",
        event = "VeryLazy",
        config = function()
            vim.cmd("silent Sleuth")
        end,
    },
    -- }}}
})
