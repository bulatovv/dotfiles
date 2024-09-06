return {
    {
        'Rigellute/shades-of-purple.vim',
        lazy = false,
	    priority = 1000,
	    init = function()
	        vim.opt.termguicolors = true
	    end,
	    config = function()
      	    vim.cmd([[colorscheme shades_of_purple]])
            vim.cmd([[hi MatchParen cterm=bold ctermbg=NONE ctermfg=NONE gui=bold guibg=NONE guifg=NONE]])
    	end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
	    build = ":TSUpdate",
	    event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync" },
        config = function()
            local configs = require('nvim-treesitter.configs')

            configs.setup {
                ensure_installed = { "php", "phpdoc", "html", "javascript", "css", "go", "gomod", "gosum" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },
    {
        "airblade/vim-gitgutter",
	    event = { "BufReadPost", "BufNewFile" }
    },
    { 
        "nvim-telescope/telescope.nvim",
	    branch = "0.1.x",
	    cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim"
        },
        config = function()
            telescope = require("telescope")
	        telescope.load_extension("fzf")
            telescope.setup {
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    }
                }
            }
        end,
    },
	{
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
	    cmd = "Telescope",
    },
    {
        "github/copilot.vim",
	    init = function()
            vim.g.copilot_proxy = vim.env.HTTPPROXY
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_filetypes = {
                markdown = true,
            }
	    end,
	    event = "VeryLazy"
    },
    { 
        "iamcco/markdown-preview.nvim",
	    init = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_port = 9999
            vim.g.mkdp_theme = "light"
            vim.g.mkdp_page_title = "${name}"
	    end,
	    build = function() 
	        vim.fn['mkdp#util#install']()
        end,
	    ft = { 'markdown' } 
    },
    {
	    "L3MON4D3/LuaSnip",
	    -- follow latest release.
	    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	    -- install jsregexp (optional!).
	    build = "make install_jsregexp"
    },
    {
        "danirod/phel.vim",
    },
    {
        'bulatovv/vim-liquidsoap',
        init = function()
            vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
                pattern = "*.liq",
                callback = function()
                    vim.bo.filetype = "liquidsoap"
                end,
            })
        end
    },
    {
        'mattn/emmet-vim'
    }
   -- "gpanders/editorconfig.nvim",
}
