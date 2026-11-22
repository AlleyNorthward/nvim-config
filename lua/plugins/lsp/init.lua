local keymaps = require("plugins.lsp.keymaps").new()
keymaps:setup()

return {
  mason = require("plugins.lsp.mason"),
  nvimconfig = require("plugins.lsp.nvim-lspconfig"),
  masonconfig = require("plugins.lsp.mason-lspconfig"),
  blinkcmp = require("plugins.lsp.blink-cmp")
}
