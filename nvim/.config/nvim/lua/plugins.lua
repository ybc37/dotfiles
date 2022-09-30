-- neovim/nvim-lspconfig, misc. lsp config
if vim.g.plugs['nvim-lspconfig'] ~= nil then
  local lspconfig = require 'lspconfig'

  local custom_attach = function(client)
    local map = function(mode, key, result)
      vim.api.nvim_buf_set_keymap(0, mode, key, result, { noremap = true, silent = true })
    end

    map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
    map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
    map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map('n','<leader>ls','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    map('n','<leader>lS','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
    map('n','<leader>la','<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n','<leader>lr','<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    map('n','<leader>li','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
    map('n','<leader>lo','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
    map('n',']d','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    map('n','[d','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    map('n','gS','<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    map('n','<leader>lL','<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

    if vim.g.plugs['vim-illuminate'] ~= nil then
      illuminate = require'illuminate'
      illuminate.on_attach(client)
      vim.api.nvim_command [[ hi def link LspReferenceText CursorLine ]]
      vim.api.nvim_command [[ hi def link LspReferenceWrite CursorLine ]]
      vim.api.nvim_command [[ hi def link LspReferenceRead CursorLine ]]
      map('n', '<a-n>', '<cmd>lua illuminate.next_reference{ wrap=true }<CR>')
      map('n', '<a-p>', '<cmd>lua illuminate.next_reference{ reverse=true, wrap=true }<CR>')
    end
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  if vim.g.plugs['nvim-cmp'] ~= nil then
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  end

  -- `sudo pacman -S pyright`
  lspconfig.pyright.setup{ on_attach = custom_attach, capabilities = capabilities }

  -- `sudo pacman -S rust-analyzer` + `rustup component add rust-src`
  lspconfig.rust_analyzer.setup{ on_attach = custom_attach, capabilities = capabilities }

  -- npm install -g vscode-langservers-extracted
  lspconfig.cssls.setup{ on_attach = custom_attach, capabilities = capabilities }
  lspconfig.html.setup{ on_attach = custom_attach, capabilities = capabilities }
  lspconfig.jsonls.setup{ on_attach = custom_attach, capabilities = capabilities }

  -- `npm install -g typescript-language-server`
  lspconfig.tsserver.setup{ on_attach = custom_attach, capabilities = capabilities }

  -- `npm install -g yaml-language-server`
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
end

-- hrsh7th/nvim-cmp
if vim.g.plugs['nvim-cmp'] ~= nil then
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert{
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-l>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    },

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'path' },
    })
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
      { name = 'cmdline' }
    })
  })
end

-- norcalli/nvim-colorizer.lua
if vim.g.plugs['nvim-colorizer.lua'] ~= nil then
  require 'colorizer'.setup {
    'css';
    'scss';
  }
end

-- nvim-treesitter/nvim-treesitter
if vim.g.plugs['nvim-treesitter'] ~= nil then
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true -- init: `gnn`, node_inc: `grn`, scope_inc: `grc`, node_dec: `grm`
    },
    indent = {
      enable = true
    }
  }
end

-- ojroques/nvim-lspfuzzy
if vim.g.plugs['nvim-lspfuzzy'] ~= nil then
  require('lspfuzzy').setup {}
end
