local lspconfig = require('lspconfig')

local custom_attach = function(client)
  local map = function(mode, lhs, rhs)
    -- vim.api.nvim_buf_set_keymap(0, mode, key, result, { noremap = true, silent = true })
    vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
  end

  local telescope = require('telescope.builtin')

  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', 'gd', telescope.lsp_definitions)
  map('n', 'K', vim.lsp.buf.hover)
  map('n', 'gr', telescope.lsp_references)
  map('n', 'gs', vim.lsp.buf.signature_help)
  map('i',  '<C-s>', vim.lsp.buf.signature_help)
  map('n', 'gi', telescope.lsp_implementations)
  map('n', 'gt', telescope.lsp_type_definitions)
  map('n', '<leader>ls', telescope.lsp_document_symbols)
  map('n', '<leader>lS', telescope.lsp_dynamic_workspace_symbols)
  map('n', '<leader>la', vim.lsp.buf.code_action)
  map('n', '<leader>lr', vim.lsp.buf.rename)
  map('n', '<leader>=', vim.lsp.buf.format)
  map('n', '<leader>li', telescope.lsp_incoming_calls)
  map('n', '<leader>lo', telescope.lsp_outgoing_calls)
  map('n', ']d', vim.diagnostic.goto_next)
  map('n', '[d', vim.diagnostic.goto_prev)
  map('n', 'gS', vim.diagnostic.open_float)
  map('n', '<leader>lL', vim.diagnostic.setloclist)
  map('n', '<leader>ld', function() telescope.diagnostics({ bufnr = 0 }) end)
  map('n', '<leader>lD', telescope.diagnostics)

  illuminate = require('illuminate')
  illuminate.on_attach(client)
  vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
  vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
  map('n', '<a-n>', '<cmd>lua illuminate.next_reference{ wrap=true }<CR>')
  map('n', '<a-p>', '<cmd>lua illuminate.next_reference{ reverse=true, wrap=true }<CR>')
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- `sudo pacman -S pyright`
lspconfig.pyright.setup{ on_attach = custom_attach, capabilities = capabilities }

-- `sudo pacman -S rust-analyzer` + `rustup component add rust-src`
lspconfig.rust_analyzer.setup{ on_attach = custom_attach, capabilities = capabilities }

-- npm install -g vscode-langservers-extracted
lspconfig.cssls.setup{ on_attach = custom_attach, capabilities = capabilities }
lspconfig.html.setup{ on_attach = custom_attach, capabilities = capabilities }
lspconfig.jsonls.setup{ on_attach = custom_attach, capabilities = capabilities }

-- `sudo pacman -S typescript-language-server`
lspconfig.tsserver.setup{ on_attach = custom_attach, capabilities = capabilities }

-- `sudo pacman -S yaml-language-server`
lspconfig.yamlls.setup{ on_attach = custom_attach, capabilities = capabilities }

-- `sudo pacman -S clang`
lspconfig.clangd.setup{ on_attach = custom_attach, capabilities = capabilities }

-- `npm install -g intelephense`
-- https://github.com/bmewburn/intelephense-docs#configuration-options
-- https://github.com/php-stubs/wordpress-stubs
-- https://github.com/php-stubs/wordpress-globals
lspconfig.intelephense.setup{
  settings = {
    intelephense = {
      stubs = {
        "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "csprng",
        "ctype", "curl", "date", "dba", "dom", "enchant", "exif", "fileinfo",
        "filter", "fpm", "ftp", "gd", "hash", "iconv", "imap", "interbase",
        "intl", "json", "ldap", "libxml", "mbstring", "mcrypt", "mssql",
        "mysql", "mysqli", "oci8", "odcb", "openssl", "password", "pcntl",
        "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite",
        "pgsql", "Phar", "posix", "pspell", "readline", "recode", "Reflection",
        "regex", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets",
        "sodium", "SPL", "sqlite3", "standard", "superglobals", "sybase",
        "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "wddx", "xml",
        "xmlreader", "xmlrpc", "xmlwriter", "Zend OPcache", "zip", "zlib",
        "wordpress"
      }
    }
  },
  on_attach = custom_attach,
  capabilities = capabilities
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)
