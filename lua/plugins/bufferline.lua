local BufferLine = {}
BufferLine.__index = BufferLine

function BufferLine.new()
  local self = setmetatable({}, BufferLine)
  self.name = "akinsho/bufferline.nvim"
  self.version = "*"
  self.dependencies = {
    "nvim-tree/nvim-web-devicons",
    "moll/vim-bbye",
  }

  self.keys = {
    { "<C-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
    { "<C-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
    { "<C-w>", "<cmd>Bdelete!<CR>",            desc = "Close Buffer" },
    {
      "<leader>w",
      function()
        self:auto_delete_bufferLine()
      end,
      desc = "Smart Close Buffer"
    },
  }

  return self
end

function BufferLine:config()
  require("bufferline").setup({
    options = {
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d",

      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left",
        },
      },

      diagnostics = "nvim_lsp",

      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " "
              or (e == "warning" and " " or "")
          s = s .. n .. sym
        end
        return s
      end,
    },
  })
end

function BufferLine:auto_delete_bufferLine()
  vim.notify("Quit: esc Continue: <space>")
  local first = true

  while true do
    if first then
      vim.cmd("BufferLinePickClose")
      first = false
    else
      local key = vim.fn.getchar() -- 获取输入
      if key == 27 then
        vim.notify("Exit Success", vim.log.levels.INFO)
        break
      elseif key == 32 then
        vim.cmd("BufferLinePickClose")
      else
        vim.notify("Press Esc to quit of <space> to continue.", vim.log.levels.INFO)
      end
    end
  end
end

return BufferLine
