local UserCommand = {}
UserCommand.__index = UserCommand

function UserCommand.new()
  local self = setmetatable({}, UserCommand)
  self.cmd = vim.api.nvim_create_user_command
  return self
end

return UserCommand
