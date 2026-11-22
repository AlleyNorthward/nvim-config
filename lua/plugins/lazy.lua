local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

local nvimtree = require("plugins.nvim-tree").new()
local bufferline = require("plugins.bufferline").new()
local lualine = require("plugins.lualine").new()
local treesitter = require("plugins.treesitter").new()
local autopairs= require("plugins.autopairs").new()
local smear = require("plugins.smear-cursor").new()
local vscode = require("plugins.vscode").new()
local fzf = require("plugins.fzf").new()
local lsp = require("plugins.lsp.init")
local mason = lsp.mason.new()
local nvimlspconfig = lsp.nvimconfig.new()
local masonlspconfig = lsp.masonconfig.new()
local blinkcmp = lsp.blinkcmp.new()


require("lazy").setup({
  -- 管理自己
  { "folke/lazy.nvim", version = "*"},
  -- 主题
  { "folke/tokyonight.nvim" },
  { "mhartington/oceanic-next" },
  {
    "ellisonleao/gruvbox.nvim",
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
  { "shaunsingh/nord.nvim" },
  { "ful1e5/onedark.nvim" },
  { "EdenEast/nightfox.nvim" },
  {
    vscode.name,
    lazy = vscode.lazy,
    priority = vscode.priority,
    config = function()
      vscode:config()
    end
  },

  --fzf
    {
      fzf.name,
      dependencies = fzf.dependencies,
      keys = fzf.keys,
      config = function()
        fzf:config()
      end,
    },

  -- tree
  {
    nvimtree.name,
    dependencies = nvimtree.dependencies,
    cmd = nvimtree.cmds,
    keys = {
      nvimtree.keys
    },

    config = function()
      nvimtree:config()
    end
  },

  -- bufferline
  {
    bufferline.name,
    version = bufferline.version,
    dependencies = bufferline.dependencies,
    keys = bufferline.keys,
    config = function()
      bufferline:config()
    end
  },

  -- lualine
  {
    lualine.name,
    dependencies = lualine.dependencies,
    event = lualine.event,
    config = function ()
      lualine:config()
    end
  },

  -- treesitter
  {
    treesitter.name,
    dependencies = treesitter.dependencies,
    branch = treesitter.branch,
    lazy = treesitter.lazy,
    build = treesitter.build,
    config = function()
      treesitter:config()
    end,
  },

  -- autopairs
  {
    autopairs.name,
    event = autopairs.event,
    config = function()
      autopairs:config()
    end
  },

    -- smear cursor
  {
    smear.name,
    config = function()
      smear:config()
    end,
  },

  -- lsp
  -- blink-cmp
  {
    blinkcmp.name,
    version = blinkcmp.version,
    event = blinkcmp.event,
    dependencies = blinkcmp.dependencies,
    config = function()
      blinkcmp:config()
    end,
  },
  -- mason
  {
    mason.name,
    config = function()
      mason:config()
    end
  },
  -- nvim-lspconfig
  {
    nvimlspconfig.name
  },
  -- mason-lspconfig
  {
    masonlspconfig.name,
    dependencies = {
      mason.name,
      nvimlspconfig.name,
    },
    config = function()
      masonlspconfig:config()
    end
  }
})
