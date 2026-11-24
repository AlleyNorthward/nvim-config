local Rainbow = {}
Rainbow.__index = Rainbow

function Rainbow.new()
  local self = setmetatable({}, Rainbow)
  self:init()
  return self
end

function Rainbow:init()
  self.name = "HiPhish/rainbow-delimiters.nvim"
  self.dependencies = {
    "nvim-treesitter/nvim-treesitter",
  }
  self.event = { "BufReadPost", "BufNewFile" }
end

function Rainbow:config()
  require("rainbow-delimiters.setup").setup({
    strategy = {
      [""] = "rainbow-delimiters.strategy.global",
      vim = "rainbow-delimiters.strategy.local",
    },
    query = {
      [""] = "rainbow-delimiters",
      lua = "rainbow-blocks",
      javascript = "rainbow-delimiters",
      typescript = "rainbow-delimiters",
      python = "rainbow-delimiters",
    },
    priority = {
      [""] = 110,
      lua = 210,
    },
    highlight = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    },
  })
end

return Rainbow
