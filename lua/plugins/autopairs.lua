local AutoPairs = {}
AutoPairs.__index = AutoPairs

function AutoPairs.new()
  local self = setmetatable({}, AutoPairs)

  self.name = "windwp/nvim-autopairs"
  self.event = "InsertEnter"

  return self
end

function AutoPairs:config()
  require("nvim-autopairs").setup({
    map_cr = true,
    map_bs = true,
    enable_check_bracket_line = true,
    enable_moveright = true,
  })
end

return AutoPairs
