local NvimTree = {}
NvimTree.__index = NvimTree

function NvimTree.new()
  local self = setmetatable({}, NvimTree)
  self.map = vim.keymap.set

  self:init()
  return self
end

function NvimTree:init()
  self.name = "nvim-tree/nvim-tree.lua"
  self.dependencies = {
    "nvim-tree/nvim-web-devicons",
  }
  self.keys = {
    "<A-m>",
    "<cmd>NvimTreeToggle<CR>",
    desc = "Toggle NvimTree",
  }
  self.cmds = {
    "NvimTreeToggle",
    "NvimTreeOpen",
    "NvimTreeFocus",
    "NvimTreeFindFile",
  }
end

function NvimTree:on_tree()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    if vim.api.nvim_buf_get_name(buf):match("NvimTree_") then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end

function NvimTree:open_file()
  self.api.node.open.edit()
  self:on_tree()
end

function NvimTree:open_file_v()
  self.api.node.open.vertical()
  self:on_tree()
end

function NvimTree:mapTree(bufnr)
  self.api.config.mappings.default_on_attach(bufnr)

  local usebuffer = {
    buffer = bufnr,
    noremap = true,
    silent = true,
  }

  self.map("n", "L", "<C-w>l", usebuffer)
  self.map("n", "<a-l>", ":vertical resize +2<cr>", usebuffer)
  self.map("n", "<a-h>", ":vertical resize -2<cr>", usebuffer)

  self.map("n", "o", function()
    self:open_file()
  end, usebuffer)

  self.map("n", "v", function()
    self:open_file_v()
  end, usebuffer)

  self.map("n", "w", self.api.tree.collapse_all, {
    buffer = bufnr,
    desc = "Collapse All Folders",
  })
end

function NvimTree:setup_events()
  local Event = self.api.events.Event

  self.api.events.subscribe(Event.FileRemoved, function()
    vim.schedule(function()
      self.api.tree.reload()
    end)
  end)

  self.api.events.subscribe(Event.FolderRemoved, function()
    vim.schedule(function()
      self.api.tree.reload()
    end)
  end)
end

function NvimTree:config()
  self.api = require("nvim-tree.api")

  require("nvim-tree").setup({
    git = {
      enable = false,
    },

    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },

    filesystem_watchers = {
      ignore_dirs = function(path)
        local root = "c:/users/hp/appdata/local/nvim-lazy"
        path = path:gsub("\\", "/"):lower()

        return path == root or path:sub(1, #root + 1) == root .. "/"
      end,
    },

    filters = {
      dotfiles = true,
      custom = { "node_modules" },
    },

    view = {
      width = 30,
      side = "left",
      number = true,
      relativenumber = true,
      signcolumn = "yes",
    },

    actions = {
      open_file = {
        resize_window = false,
        quit_on_open = false,
      },
    },

    renderer = {
      root_folder_label = false,
    },

    on_attach = function(bufnr)
      self:mapTree(bufnr)
    end,
  })

  self:setup_autocmd()
  self:setup_events()
end

function NvimTree:setup_autocmd()
  local group = vim.api.nvim_create_augroup("NvimTreeAutoClose", {
    clear = true,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
      if vim.fn.winnr("$") == 1
        and vim.bo[args.buf].filetype == "NvimTree"
      then
        vim.cmd("quit")
      end
    end,
  })
end

return NvimTree
