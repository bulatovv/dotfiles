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
                ensure_installed = {},
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
	    init = function()
            local builtin = require('telescope.builtin')
            local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
	        if vim.v.shell_error == 0 then
                vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ cwd = root }) end, { desc = 'Telescope find files'})
	        else
                vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
	        end
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        end
    },
	{
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
	    cmd = "Telescope",
    },
    {
        'mattn/emmet-vim'
    },
    { 'kosayoda/nvim-lightbulb' },
    {
    "rachartier/tiny-code-action.nvim",
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope.nvim"},
        },
        event = "LspAttach",
        config = function()
            require('tiny-code-action').setup()
        end,
        init = function()
            vim.keymap.set("n", "<leader>ca", function()
	            require("tiny-code-action").code_action()
            end, { noremap = true, silent = true })
        end
    },
    { 'samjwill/nvim-unception' },
    { 'neovim/nvim-lspconfig' },
   -- "gpanders/editorconfig.nvim",
    --{
    --    "ray-x/lsp_signature.nvim",
    --    event = "InsertEnter",
    --    init = function()
    --        require("lsp_signature").setup({
    --            hint_enable = true
    --        })
    --    end
    --}
}
