local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

vim.opt.number = true -- Print the line number in front of each line
vim.opt.clipboard = "unnamedplus" -- uses the clipboard register for all operations except yank.
vim.opt.syntax = "on" -- When this option is set, the syntax with this name is loaded.
vim.opt.autoindent = true -- Copy indent from current line when starting a new line.
vim.opt.expandtab = true -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent.
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for.
vim.opt.encoding = "UTF-8" -- Sets the character encoding used inside Vim.
vim.opt.ruler = true -- Show the line and column number of the cursor position, separated by a comma.
vim.opt.wildmenu = true -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
vim.opt.showcmd = true -- Show (partial) command in the last line of the screen. Set this option off if your terminal is slow.
vim.opt.inccommand = "split" -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
vim.opt.splitright = true
vim.opt.splitbelow = true -- When on, splitting a window will put the new window below the current one
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.indentkeys:remove("<:>")
vim.opt.cinkeys:remove("<:>")
vim.opt.mouse = "" 

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
  end,
})

vim.keymap.set('n', '<C-l>', ':nohls<CR><C-l>', { noremap = true, silent = true })
vim.lsp.enable({
  'clangd',
  'dockerls',
  'basedpyright',
  'efm',
  'ruff'
})

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end, { noremap = true, silent = true })

vim.cmd[[set completeopt+=menuone,noselect,popup]]
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})


vim.lsp.config.efm = {
  cmd = { 'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5' },
  filetypes = { 'sh' },
  settings = {
    languages = {
      sh = {
        {
          lintCommand = 'shellcheck -f gcc -x',
          lintSource = 'shellcheck',
          lintFormats = {
            '%f:%l:%c: %trror: %m',
            '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m',
          },
        },
      },
    },
  },
}
