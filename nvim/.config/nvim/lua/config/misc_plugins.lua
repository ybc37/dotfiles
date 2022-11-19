vim.cmd.colorscheme('gruvbox')
vim.g.lightline = { colorscheme = 'gruvbox' }

-- editorconfig/editorconfig-vim
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }
vim.g.EditorConfig_disable_rules = { 'trim_trailing_whitespace' }

-- norcalli/nvim-colorizer.lua
require('colorizer').setup({
  'css';
  'scss';
})

-- nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true -- init: `gnn`, node_inc: `grn`, scope_inc: `grc`, node_dec: `grm`
  },
  indent = {
    enable = true
  },
  -- JoosepAlviste/nvim-ts-context-commentstring
  context_commentstring = {
    enable = true
  }
})

-- lewis6991/gitsigns.nvim
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true })
  end
})

require('nvim-treesitter.configs').setup({
  context_commentstring = {
    enable = true
  }
})
