local LuaLine = {}
LuaLine.__index = LuaLine

function LuaLine.new()
  local self = setmetatable({}, LuaLine)
  self.name = "nvim-lualine/lualine.nvim"
  self.dependencies = {
    "nvim-tree/nvim-web-devicons",
  }
  self.event = "VeryLazy"
  self.theme = require("colortheme").theme

  return self
end

function LuaLine:config()
  require("lualine").setup({
    options = {
      theme = self.theme,
      component_separators = { left = "|", right = "|" },
      section_separators = { left = " ", right = "" },
    },

    extensions = {
      "nvim-tree",
      "toggleterm",
    },

    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        "filename"
      },
      lualine_x = {
        "filesize",
        {
          "fileformat",
          symbols = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
          },
        },
        "encoding",
        "filetype",
      },
      lualine_y = {},
      lualine_z = {},
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  })
end

return LuaLine
