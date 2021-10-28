vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    }
)

local servers = {'pylsp', 'clangd'}
for _, lsp in ipairs(servers) do
    require'lspconfig'[lsp].setup {
        on_attach = require'completion'.on_attach,
    }
end

require "lspconfig".efm.setup {
    on_attach = on_attach,
    cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
    filetypes = { 'python' },
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
        }
    }
}
