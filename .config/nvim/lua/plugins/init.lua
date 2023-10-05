return {
    {
        "gruvbox-community/gruvbox",
        lazy = false,
	    priority = 1000,
	    init = function()
	        vim.opt.termguicolors = true
	    end,
	    config = function()
      	    vim.cmd([[colorscheme gruvbox]])
    	end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
	    build = ":TSUpdate",
	    event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync" },
        init = function()
            vim.filetype.add({
                pattern = {
                    ['.*%.blade%.php'] = 'blade',
                },
            })
        end,
        config = function()
            local configs = require('nvim-treesitter.configs')

            configs.setup {
                ensure_installed = { "blade", "php", "html", "phpdoc", "javascript", "css" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            }

            local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            parser_config.blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    files = {"src/parser.c"},
                    branch = "main",
                },
                filetype = "blade"
            }
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
    },
    {
	    "L3MON4D3/LuaSnip",
	    version = "2.*",
	    build = "make install_jsregexp",
        event = "InsertEnter",
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
	        {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
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
            }
        }

    },
    {
        "github/copilot.vim",
	    init = function()
            vim.g.copilot_node_command = "~/.nvm/versions/node/v17.0.1/bin/node"
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
    -- "gpanders/editorconfig.nvim",
}
