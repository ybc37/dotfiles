return {
  'mfussenegger/nvim-dap',
  dependencies = { 'mfussenegger/nvim-dap-python' },
  config = function()
    require('dap-python').setup('python')

    local dap = require('dap')
    local dap_ui_widgets = require('dap.ui.widgets')

    -- yay -S vscode-php-debug
    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { '/usr/lib/node_modules/php-debug/out/phpDebug.js' },
    }

    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-firefox
    dap.adapters.firefox = {
      type = 'executable',
      command = 'node',
      args = {
        os.getenv('HOME') .. '/dev/debug-adapter/vscode-firefox-debug/dist/adapter.bundle.js',
      },
    }

    --

    vim.keymap.set('n', 'g.c', dap.continue)
    vim.keymap.set('n', 'g.o', dap.step_over)
    vim.keymap.set('n', 'g.i', dap.step_into)
    vim.keymap.set('n', 'g.O', dap.step_out)
    vim.keymap.set('n', 'g.C', dap.run_to_cursor)
    vim.keymap.set('n', 'g.b', dap.toggle_breakpoint)
    vim.keymap.set('n', 'g.r', dap.repl.toggle)
    vim.keymap.set({ 'n', 'v' }, 'g.h', dap_ui_widgets.hover)
    vim.keymap.set({ 'n', 'v' }, 'g.p', dap_ui_widgets.preview)

    ---

    local frames = function()
      dap_ui_widgets.centered_float(dap_ui_widgets.frames)
    end

    local scopes = function()
      dap_ui_widgets.centered_float(dap_ui_widgets.scopes)
    end

    local breakpoint_condition = function()
      dap.set_breakpoint(nil, vim.fn.input('Condition: '))
    end

    local breakpoint_message = function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log message: '))
    end

    local commands = {
      { name = 'breakpoint', func = dap.toggle_breakpoint },
      { name = 'breakpoint:message', func = breakpoint_message },
      { name = 'breakpoint:condition', func = breakpoint_condition },
      { name = 'breakpoints:list', func = require('fzf-lua.providers.dap').breakpoints },
      { name = 'breakpoints:clear', func = dap.clear_breakpoints },
      { name = 'frames', func = frames },
      { name = 'scopes', func = scopes },
    }

    vim.keymap.set('n', 'g..', require('utils').select_command_func(commands))
  end,
}
