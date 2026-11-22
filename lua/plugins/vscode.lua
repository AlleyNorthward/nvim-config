local VsCode = {}
VsCode.__index = VsCode

function VsCode.new()
  local self = setmetatable({}, VsCode)

  self.name = "Mofiqul/vscode.nvim"
  self.lazy = false
  self.priority = 1000

  return self
end

function VsCode:config()
  require("vscode").setup({
    style = "dark",
    transparent = false,
    italic_comments = true,
    terminal_colors = true,
  })
end

return VsCode
