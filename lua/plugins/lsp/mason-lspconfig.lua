local MasonLspconfig = {}
MasonLspconfig.__index = MasonLspconfig

function MasonLspconfig.new()
  local self = setmetatable({}, MasonLspconfig)

  self.name = "mason-org/mason-lspconfig.nvim"
  self.ensure_installed = {
    "pyright",
    "lua_ls",
    "clangd",
    "jdtls",
    "ts_ls",
    "cmake"
  }
  self.automatic_enable = true
  return self
end

function MasonLspconfig:config()
  require("mason-lspconfig").setup({
    ensure_installed = self.ensure_installed,
    automatic_enable = self.automatic_enable,
  })
end

return MasonLspconfig
