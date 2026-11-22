local AutoCommand = {}
AutoCommand.__index = AutoCommand

function AutoCommand.new()
  local self = setmetatable({}, AutoCommand)
  self.cmd = vim.api.nvim_create_autocmd
  self.hl = vim.api.nvim_set_hl

  return self
end

function AutoCommand:textYankPast()
  self.hl(0,'YankColor',
    {
      fg = '#000000',
      bg = '#77ffff',
    }
  )

  self.cmd('TextYankPost',
    {
      desc = 'yanking时高亮显示',
      group = vim.api.nvim_create_augroup('autocommand-highlight-yank', { clear = true }),
      callback = function()
        vim.hl.on_yank({
          higroup = 'YankColor',
          timeout = 150,
        })
      end,
    }
  )
end

function AutoCommand:closeAutoComment()
  self.cmd("FileType",
    {
      pattern = "*",
      callback = function()
        vim.opt_local.formatoptions = vim.opt_local.formatoptions - { "c", "r", "o" }
      end,
    }
  )
end

return AutoCommand
