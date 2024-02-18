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
                gopls = {},
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
            capabilities = require('cmp_nvim_lsp').default_capabilities()

            for server, config in pairs(servers) do
                lspconfig[server].setup{
                    capabilities = capabilities
                }
            end

        end
    }
}
