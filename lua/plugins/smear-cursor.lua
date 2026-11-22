local SmearCursor = {}
SmearCursor.__index = SmearCursor

function SmearCursor.new()
  local self = setmetatable({}, SmearCursor)

  self.name = "sphamba/smear-cursor.nvim"

  return self
end

function SmearCursor:config()
  require("smear_cursor").setup({
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    smear_insert_mode = true,
  })
end

return SmearCursor
