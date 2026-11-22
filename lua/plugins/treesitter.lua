local TreeSitter = {}
TreeSitter.__index = TreeSitter

function TreeSitter.new()
  local self = setmetatable({}, TreeSitter)
  self.name = "nvim-treesitter/nvim-treesitter"
  self.branch = "main"
  self.lazy = false
  self.build = ":TSUpdate"
  self.dependencies = {
    "neovim-treesitter/treesitter-parser-registry",
  }

  self.languages = {
    "json",
    "html",
    "css",
    "vim",
    "lua",
    "javascript",
    "python",
    "cpp",
    "c",
    "java",
    "cmake",
    "typescript",
    "tsx"
  }

  return self
end

function TreeSitter:config()
  require("nvim-treesitter").install(self.languages)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = self.languages,
    callback = function()
      vim.treesitter.start()

      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = "expr"
    end,
  })
end

return TreeSitter
