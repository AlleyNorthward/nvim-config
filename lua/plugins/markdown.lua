local RenderMarkdown = {}
RenderMarkdown.__index = RenderMarkdown

function RenderMarkdown.new()
  local self = setmetatable({}, RenderMarkdown)

  self.name = "MeanderingProgrammer/render-markdown.nvim"
  self.dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  }
  self.ft = { "markdown" }

  return self
end

function RenderMarkdown:mapMarkdown(bufnr)
  self.map(
    { "n", "v", "i" },
    "<C-_>",
    function()
      require("render-markdown").buf_toggle()
    end,
    {
      buffer = bufnr,
      silent = true,
      desc = "Toggle Markdown Render",
    }
  )
end

function RenderMarkdown:config()
  self.map = vim.keymap.set

  require("render-markdown").setup({
    enabled = false,
    file_types = { "markdown" },
  })

  local group = vim.api.nvim_create_augroup("RenderMarkdownKeymap", {
    clear = true,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "markdown",
    callback = function(args)
      self:mapMarkdown(args.buf)
    end,
  })

  local bufnr = vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype == "markdown" then
    self:mapMarkdown(bufnr)
  end
end

return RenderMarkdown
