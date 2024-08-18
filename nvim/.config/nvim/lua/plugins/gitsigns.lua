return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signcolumn = false,
        numhl = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          local function next_hunk()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end

          local function prev_hunk()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end

          map('n', ']c', next_hunk, { expr = true })
          map('n', '[c', prev_hunk, { expr = true })

          -- Actions
          map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function()
            gs.blame_line({ full = true })
          end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true })
        end,
      })
    end,
  },
}
