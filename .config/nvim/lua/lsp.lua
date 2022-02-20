local lspconfig = require "lspconfig"
local coq = require "coq"

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    }
)

local servers = {'pylsp', 'clangd', 'html', 'cssls'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
    }
    lspconfig[lsp].setup(coq.lsp_ensure_capabilities())
end

lspconfig.efm.setup {
    on_attach = on_attach,
    cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
    filetypes = { 'python', 'sh'},
    init_options = {
        documentFormatting = true, 
        --hover = true, 
        --documentSymbol = true,
        --codeAction = true,
        --completion = true
    },
    settings = {
        languages = {
            python = {
                --[[{
                    lintCommand = "pylint --output-format text --score no --msg-template {path}:{line}:{column}:{C}:{msg} ${INPUT}",
                    lintStdin = true,
                    lintFormats = {'%f:%l:%c:%t:%m'},
                }]]--
                --[[{
                    lintCommand =  'flake8 ${INPUT} -',
                    lintStdin =  true,
                    lintFormats = {'%f:%l:%c: %m'}
                }]]--,
            },
            sh = {
                {
                    lintCommand = "shellcheck -f gcc -x",
                    lintSource = "shellcheck",
                    lintFormats = {"%f:%l:%c: %trror: %m",
                                   "%f:%l:%c: %tarning: %m",
                                   "%f:%l:%c: %tote: %m"}
                }
            },
        }
    }
}
