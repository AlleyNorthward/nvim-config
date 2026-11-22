local GeneralMap = {}
GeneralMap.__index = GeneralMap

function GeneralMap.new()
  local self = setmetatable({}, GeneralMap)

  self:initLeader()

  self.map = vim.keymap.set
  self.opts = {
    noremap = true,
    silent = true,
  }

  self:initMap()

  return self
end

function GeneralMap:initLeader()
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
end

function GeneralMap:deleteMap()
  self.map("n", "s", "<Nop>", self.opts)
  self.map("n", "S", "<Nop>", self.opts)
end

function GeneralMap:windowMap()
  self.map("n", "sv", "<Cmd>vsplit<CR>", self.opts)
  self.map("n", "sh", "<Cmd>split<CR>", self.opts)

  self.map("n", "so", "<C-w>c", self.opts)
  self.map("n", "sc", "<C-w>o", self.opts)

  self.map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", self.opts)
  self.map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", self.opts)

  self.map("n", "<A-l>", "<Cmd>vertical resize +10<CR>", self.opts)
  self.map("n", "<A-h>", "<Cmd>vertical resize -10<CR>", self.opts)

  self.map("n", "<A-j>", "<Cmd>resize +2<CR>", self.opts)
  self.map("n", "<A-k>", "<Cmd>resize -2<CR>", self.opts)

  self.map("n", "<C-Down>", "<Cmd>resize +2<CR>", self.opts)
  self.map("n", "<C-Up>", "<Cmd>resize -2<CR>", self.opts)

  self.map("n", "<A-e>", "<C-w>=", self.opts)

  self.map("n", "H", "<C-w>h", self.opts)
  self.map("n", "J", "<C-w>j", self.opts)
  self.map("n", "K", "<C-w>k", self.opts)
  self.map("n", "L", "<C-w>l", self.opts)

  self.map("n", "<C-v>", '"+p', self.opts)
  self.map("i", "<C-v>", '<C-r>+', self.opts)
  self.map("c", "<C-v>", '<C-r>+', self.opts)
  self.map("v", "<C-v>", '"+P', self.opts)
end

function GeneralMap:terminalMap()
  self.map("n", "<leader>t", "<cmd>split | terminal<cr>", self.opts)
  self.map("n", "<leader>vt", "<Cmd>vsplit | terminal<CR>", self.opts)
  self.map("t", "<Esc>", "<C-\\><C-n>", self.opts)
end

function GeneralMap:visualMap()
  self.map("v", "<", "<gv", self.opts)
  self.map("v", ">", ">gv", self.opts)

  self.map("v", "<C-j>", ":move '>+1<CR>gv=gv", self.opts)
  self.map("v", "<C-k>", ":move '<-2<CR>gv=gv", self.opts)
end

function GeneralMap:readMap()
  self.map("n", "<C-u>", "9k", self.opts)
  self.map("n", "<C-d>", "9j", self.opts)
end

function GeneralMap:otherMap()
  self.map("v", "p", '"_dP', self.opts)

  self.map("n", "SY", 'ggVG"+y', self.opts)
  self.map("v", "SY", '"+y', self.opts)
  self.map("n", "SP", '"+p', self.opts)

  self.map("n", "<C-_>", "gcc", { remap = true })
  self.map("i", "<C-_>", function()
    return "<Esc>gcc"
  end, {
    expr = true,
    remap = true,
    silent = true,
  })
  self.map("v", "<C-_>", "gc", { remap = true })

  self.map("n", "<leader><CR>", function()
    self:newLine(12)
  end, self.opts)
end

function GeneralMap:newLine(n)
  local line_count = vim.api.nvim_buf_line_count(0)
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]

  if cur_line ~= line_count then
    return
  end

  local empty_lines = {}

  for i = 1, n do
    empty_lines[i] = ""
  end

  vim.api.nvim_buf_set_lines(0, line_count, line_count, false, empty_lines)
end

function GeneralMap:initMap()
  self:deleteMap()
  self:windowMap()
  self:terminalMap()
  self:visualMap()
  self:readMap()
  self:otherMap()
end

return GeneralMap
