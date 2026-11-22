local NvimLspconfig = {}
NvimLspconfig.__index = NvimLspconfig

function NvimLspconfig.new()
  local self = setmetatable({}, NvimLspconfig)

  self.name = "neovim/nvim-lspconfig"

  return self
end

return NvimLspconfig
