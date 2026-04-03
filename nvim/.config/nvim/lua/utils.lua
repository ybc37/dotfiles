local M = {}

function M.set_win_foldexpr(expr)
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = expr
end

function M.select_command(commands)
  vim.ui.select(commands, {
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      choice.func()
    end
  end)
end

function M.select_command_func(commands)
  return function()
    M.select_command(commands)
  end
end

return M
