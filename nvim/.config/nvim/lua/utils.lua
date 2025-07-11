local M = {}

function M.set_win_foldexpr(expr)
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = expr
end

return M
