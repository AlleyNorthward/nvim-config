local Mason = {}
Mason.__index = Mason

function Mason.new()
  local self = setmetatable({}, Mason)

  self.name = "mason-org/mason.nvim"

  return self
end

function Mason:config()
  require("mason").setup({})
end

return Mason
