-- https://github.com/neovim/neovim/blob/master/.luacheckrc
-- https://github.com/mpeterv/luacheck/blob/master/.luacheckrc
-- https://luacheck.readthedocs.io/en/stable/cli.html

std = "lua51+luacheckrc"
cache = true

read_globals = {
  "vim",
}

globals = {
  "vim.opt",
  "vim.opt_local",
  "vim.g",
  "vim.wo",
}
