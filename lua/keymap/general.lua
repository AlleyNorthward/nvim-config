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
  self.map("n", "<leader>t", function()
    self:splitTerminal()
  end, self.opts)
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


function GeneralMap:splitTerminal()
  if self.term_win and vim.api.nvim_win_is_valid(self.term_win) then
    self.term_action = "hide"
    vim.api.nvim_win_hide(self.term_win)
    self.term_action = nil
    return
  end

  local buf = self.term_buf
  local is_new = not buf or not vim.api.nvim_buf_is_valid(buf)

  if is_new then
    buf = vim.api.nvim_create_buf(false, true)
    self.term_buf = buf

    vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
    vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
  end

  local width = math.max(1, math.floor(vim.o.columns / 3))
  local height = math.max(1, math.floor(vim.o.lines / 3))

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = vim.o.columns - width,
    row = 0,
    style = "minimal",
    border = "rounded",
  })

  self.term_win = win

  vim.api.nvim_set_hl(0, "UbuntuTerminal", {
    bg = "#300A24",
  })

  vim.wo[win].winhighlight =
    "Normal:UbuntuTerminal,NormalNC:UbuntuTerminal"

  if is_new then
    local job = vim.fn.jobstart({
      "pwsh.exe",
      "-NoLogo",
    }, {
      term = true,
      env = {
        NVIM_FLOAT_TERM = "1",
      },
    })

    if job <= 0 then
      vim.api.nvim_win_close(win, true)
      self.term_win = nil
      self.term_buf = nil
      return
    end

    self.term_job = job
  end

  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      self.term_win = nil

      if self.term_action == "hide" then
        return
      end

      local old_buf = self.term_buf
      self.term_buf = nil
      self.term_job = nil

      vim.schedule(function()
        if old_buf and vim.api.nvim_buf_is_valid(old_buf) then
          vim.api.nvim_buf_delete(old_buf, { force = true })
        end
      end)
    end,
  })
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
