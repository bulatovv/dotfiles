return {
    {
    	"neovim/nvim-lspconfig",
    	event = { "BufReadPre", "BufNewFile" },
    	config = function()
    	    servers = {
                clangd = {},
                dockerls = {},
                pyright = {},
                arduino_language_server = {},
                eslint = {},
                svelte = {},
                tsserver = {},
                phpactor = {
                    init_options = {
                        ["worse_reflection.stub_dir"] = '%application_root%/_ide_helper.php',
                    }
                },
                efm = {
                    cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
                    filetypes = {'sh'},
                    settings = {
                        sh = {
                            {
                                lintCommand = "shellcheck -f gcc -x",
                                lintSource = "shellcheck",
                                lintFormats = {
                                    "%f:%l:%c: %trror: %m",
                                    "%f:%l:%c: %tarning: %m",
                                    "%f:%l:%c: %tote: %m"
                                }
                            }
                        }
                    }
                }
            }

            
            lspconfig = require('lspconfig')

            for server, config in pairs(servers) do
                lspconfig[server].setup(config)
            end
        end
    }
}
