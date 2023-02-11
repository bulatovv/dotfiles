local lspconfig = require "lspconfig"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
    }
)

local servers = {'pylsp', 'clangd', 'tailwindcss', 'phpactor', 'dockerls', 'tsserver'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end


lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    enabled = false,
                    --ignore = {'E128', 'E131'}
                }
            }
        }
    }
}


lspconfig.efm.setup {
    on_attach = on_attach,
    cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
    filetypes = {'sh'},
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

local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
