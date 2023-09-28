return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        vim.opt.showmode = false
        vim.opt.laststatus = 2
    end,
    config = function()
        require('lualine').setup {
            options = {
                section_separators = {left = '', right = ''},
                component_separators = {left = '│', right = '│'},
            },
        }
    end,
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    }
}
