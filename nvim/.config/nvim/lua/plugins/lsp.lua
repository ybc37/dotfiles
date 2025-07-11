return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lsp_attach = function(args)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
        end

        map('n', 'gs', vim.lsp.buf.signature_help)
        map('n', '<leader>gO', vim.lsp.buf.workspace_symbol)
        map({ 'n', 'v' }, '<leader>=', vim.lsp.buf.format)

        map('n', '<C-w>D', function()
          if vim.diagnostic.config().virtual_lines then
            vim.diagnostic.config({ virtual_lines = false })
          else
            vim.diagnostic.config({ virtual_lines = { current_line = true } })
          end
        end)

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

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method('textDocument/foldingRange') then
          require('utils').set_win_foldexpr('v:lua.vim.treesitter.foldexpr()')
        end
      end

      vim.api.nvim_create_autocmd('LspAttach', { callback = lsp_attach })

      -- `sudo pacman -S pyright`
      vim.lsp.enable('pyright')

      -- `sudo pacman -S ruff`
      vim.lsp.enable('ruff')

      -- `sudo pacman -S rust-analyzer` + `rustup component add rust-src`
      vim.lsp.enable('rust_analyzer')

      -- sudo pacman -S vscode-css-languageserver
      vim.lsp.enable('cssls')

      -- sudo pacman -S vscode-html-languageserver
      vim.lsp.enable('html')

      -- sudo pacman -S vscode-json-languageserver
      vim.lsp.enable('jsonls')

      -- sudo pacman -S eslint-language-server
      vim.lsp.enable('eslint')

      -- `sudo pacman -S typescript-language-server`
      vim.lsp.enable('ts_ls')

      -- `sudo pacman -S yaml-language-server`
      vim.lsp.enable('yamlls')

      -- `sudo pacman -S clang`
      vim.lsp.enable('clang')

      -- sudo pacman -S arduino-language-server
      vim.lsp.enable('arduino_language_server')

      -- `yay -S nodejs-intelephense`
      vim.lsp.enable('intelephense')

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

      vim.lsp.config('efm', efmls_config)
      vim.lsp.enable('efm')

      vim.diagnostic.config({
        update_in_insert = true,
        severity_sort = true,
        jump = {
          float = true,
        },
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
