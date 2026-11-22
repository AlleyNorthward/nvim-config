local Fzf = {}
Fzf.__index = Fzf

function Fzf.new()
  local self = setmetatable({}, Fzf)

  self.name = "ibhagwan/fzf-lua"
  self.dependencies = {
    "nvim-tree/nvim-web-devicons",
  }

  self.keys = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Grep Word",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Find Buffers",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Recent Files",
    },
  }

  return self
end

function Fzf:config()
  require("fzf-lua").setup({})
end

return Fzf
