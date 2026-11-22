local ColorTheme = {}
ColorTheme.__index = ColorTheme

function ColorTheme.new()
  local self = setmetatable({}, ColorTheme)
  self.colors = {
    gruvbox = "gruvbox",
    tokyo = "tokyonight",
    ocean = "OceanicNext",
    nord = "nord",
    onedark = "onedark",
    nightfox = "nightfox",
    vscode = "vscode"
  }
  self.theme = nil
  return self
end

function ColorTheme:set_theme(key)
  local theme = self.colors[key]

  if not theme then
    return vim.notify("Unknown colorscheme: " .. key, vim.log.levels.ERROR)
  end

  vim.cmd.colorscheme(theme)
  self.theme = key
end

function ColorTheme:get_theme()
  vim.notify(vim.inspect(vim.tbl_keys(self.colors)))
end

local instance = ColorTheme.new()

return instance
