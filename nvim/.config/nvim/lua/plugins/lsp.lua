return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local custom_attach = function(_)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
        end

        map('n', 'gs', vim.lsp.buf.signature_help)
        map('n', '<leader>gO', vim.lsp.buf.workspace_symbol)
        map({ 'n', 'v' }, '<leader>=', vim.lsp.buf.format)
        map('n', 'gS', vim.diagnostic.open_float)

        local fzf_lua = require('fzf-lua')
        map('n', 'gd', fzf_lua.lsp_definitions)
        map('n', 'gD', fzf_lua.lsp_declarations)
        map('n', 'grr', fzf_lua.lsp_references)
        map('n', 'gri', fzf_lua.lsp_implementations)
        map('n', 'grt', fzf_lua.lsp_typedefs)
        map('n', 'gO', fzf_lua.lsp_document_symbols)
        map('n', '<leader>gO', fzf_lua.lsp_live_workspace_symbols)
        map({ 'n', 'v' }, 'gra', fzf_lua.lsp_code_actions)
        map('n', 'grI', fzf_lua.lsp_incoming_calls)
        map('n', 'grO', fzf_lua.lsp_outgoing_calls)
        map('n', 'grd', fzf_lua.diagnostics_document)
        map('n', 'grD', fzf_lua.diagnostics_workspace)
      end

      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- `sudo pacman -S pyright`
      lspconfig.pyright.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- `sudo pacman -S ruff`
      lspconfig.ruff.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- `sudo pacman -S rust-analyzer` + `rustup component add rust-src`
      lspconfig.rust_analyzer.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- sudo pacman -S vscode-css-languageserver
      lspconfig.cssls.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- sudo pacman -S vscode-html-languageserver
      lspconfig.html.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- sudo pacman -S vscode-json-languageserver
      lspconfig.jsonls.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- sudo pacman -S eslint-language-server
      lspconfig.eslint.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- `sudo pacman -S typescript-language-server`
      lspconfig.ts_ls.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- `sudo pacman -S yaml-language-server`
      lspconfig.yamlls.setup({
        on_attach = custom_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      })

      -- `sudo pacman -S clang`
      lspconfig.clangd.setup({ on_attach = custom_attach, capabilities = capabilities })

      -- `yay -S nodejs-intelephense`
      -- https://github.com/bmewburn/intelephense-docs#configuration-options
      -- https://github.com/php-stubs/wordpress-stubs
      -- https://github.com/php-stubs/wordpress-globals
      lspconfig.intelephense.setup({
        settings = {
          intelephense = {
            -- stylua: ignore
            stubs = {
              'apache', 'bcmath', 'bz2', 'calendar', 'com_dotnet', 'Core', 'csprng',
              'ctype', 'curl', 'date', 'dba', 'dom', 'enchant', 'exif', 'fileinfo',
              'filter', 'fpm', 'ftp', 'gd', 'hash', 'iconv', 'imap', 'interbase',
              'intl', 'json', 'ldap', 'libxml', 'mbstring', 'mcrypt', 'mssql',
              'mysql', 'mysqli', 'oci8', 'odcb', 'openssl', 'password', 'pcntl',
              'pcre', 'PDO', 'pdo_ibm', 'pdo_mysql', 'pdo_pgsql', 'pdo_sqlite',
              'pgsql', 'Phar', 'posix', 'pspell', 'readline', 'recode', 'Reflection',
              'regex', 'session', 'shmop', 'SimpleXML', 'snmp', 'soap', 'sockets',
              'sodium', 'SPL', 'sqlite3', 'standard', 'superglobals', 'sybase',
              'sysvmsg', 'sysvsem', 'sysvshm', 'tidy', 'tokenizer', 'wddx', 'xml',
              'xmlreader', 'xmlrpc', 'xmlwriter', 'Zend OPcache', 'zip', 'zlib',
              'wordpress',
            },
          },
        },
        on_attach = custom_attach,
        capabilities = capabilities,
      })

      -- `yay -S efm-langserver`
      -- lua: `sudo pacman -S luacheck stylua`
      -- python: `sudo pacman -S flake8 python-black`
      -- css: `sudo pacman -S stylelint`, `sudo pacman -S --asdeps stylelint-config-standard`
      -- sh: `sudo pacman -S shellcheck shfmt`
      -- misc: `sudo pacman -S prettier`
      -- fish: inluded in fish

      local luacheck = require('efmls-configs.linters.luacheck')
      local stylua = require('efmls-configs.formatters.stylua')
      local prettier = require('efmls-configs.formatters.prettier')
      local stylelint = require('efmls-configs.linters.stylelint')
      local shellcheck = require('efmls-configs.linters.shellcheck')
      local shfmt = require('efmls-configs.formatters.shfmt')
      local fish = require('efmls-configs.linters.fish')
      local fish_indent = require('efmls-configs.formatters.fish_indent')

      local languages = {
        lua = { luacheck, stylua },
        javascript = { prettier },
        javascriptreact = { prettier },
        typescript = { prettier },
        typescriptreact = { prettier },
        html = { prettier },
        css = { stylelint, prettier },
        scss = { stylelint, prettier },
        sh = { shellcheck, shfmt },
        fish = { fish, fish_indent },
        json = { prettier },
        jsonc = { prettier },
        yaml = { prettier },
      }

      local efmls_config = {
        filetypes = vim.tbl_keys(languages),
        settings = {
          rootMarkers = { '.git/' },
          languages = languages,
        },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
        },
      }

      lspconfig.efm.setup(vim.tbl_extend('force', efmls_config, {
        on_attach = custom_attach,
        capabilities = capabilities,
      }))

      vim.diagnostic.config({
        update_in_insert = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '● ',
            [vim.diagnostic.severity.WARN] = '● ',
            [vim.diagnostic.severity.INFO] = '● ',
            [vim.diagnostic.severity.HINT] = '● ',
          },
        },
      })
    end,
  },
}
