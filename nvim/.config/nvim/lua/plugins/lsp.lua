return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')

      -- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#peek-definition
      -- https://github.com/neovim/neovim/pull/12368#issue-623656361
      local function preview_location_callback(_, result)
        if result == nil or vim.tbl_isempty(result) then
          return nil
        end
        vim.lsp.util.preview_location(result[1])
      end

      local function peek_definition()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
      end

      local custom_attach = function(_)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
        end

        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gd', vim.lsp.buf.definition)
        map('n', 'gpd', peek_definition)
        map('n', 'K', vim.lsp.buf.hover)
        map('n', 'gr', vim.lsp.buf.references)
        map('n', 'gs', vim.lsp.buf.signature_help)
        map('i', '<C-s>', vim.lsp.buf.signature_help)
        map('n', 'gi', vim.lsp.buf.implementation)
        map('n', 'gt', vim.lsp.buf.type_definition)
        map('n', '<leader>ls', vim.lsp.buf.document_symbol)
        map('n', '<leader>lS', vim.lsp.buf.workspace_symbol)
        map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action)
        map('n', '<leader>lr', vim.lsp.buf.rename)
        map({ 'n', 'v' }, '<leader>=', vim.lsp.buf.format)
        map('n', '<leader>li', vim.lsp.buf.incoming_calls)
        map('n', '<leader>lo', vim.lsp.buf.outgoing_calls)
        map('n', ']d', vim.diagnostic.goto_next)
        map('n', '[d', vim.diagnostic.goto_prev)
        map('n', 'gS', vim.diagnostic.open_float)
        map('n', '<leader>lL', vim.diagnostic.setloclist)
        map('n', '<leader>lQ', vim.diagnostic.setqflist)
        map('n', '<leader>ld', vim.diagnostic.setloclist)
        map('n', '<leader>lD', vim.diagnostic.setqflist)

        local fzf_lua = require('fzf-lua')
        map('n', 'gd', fzf_lua.lsp_definitions)
        map('n', 'gr', fzf_lua.lsp_references)
        map('n', 'gi', fzf_lua.lsp_implementations)
        map('n', 'gt', fzf_lua.lsp_typedefs)
        map('n', '<leader>ls', fzf_lua.lsp_document_symbols)
        map('n', '<leader>lS', fzf_lua.lsp_live_workspace_symbols)
        map({ 'n', 'v' }, '<leader>la', fzf_lua.lsp_code_actions)
        map('n', '<leader>li', fzf_lua.lsp_incoming_calls)
        map('n', '<leader>lo', fzf_lua.lsp_outgoing_calls)
        map('n', '<leader>ld', fzf_lua.diagnostics_document)
        map('n', '<leader>lD', fzf_lua.diagnostics_workspace)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
