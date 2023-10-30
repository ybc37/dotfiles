return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
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
    end,
  },
}
