local BlinkCmp = {}
BlinkCmp.__index = BlinkCmp

function BlinkCmp.new()
  local self = setmetatable({}, BlinkCmp)

  self.name = "saghen/blink.cmp"
  self.version = "1.*"
  self.event = "VeryLazy"

  self.dependencies = {
    "rafamadriz/friendly-snippets",
  }

  return self
end

function BlinkCmp:config()
  require("blink.cmp").setup({
    keymap = {
      preset = "none",

      ["<C-e>"] = { "show", "show_documentation", "hide" },
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

      ["<C-n>"] = { "show", "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },

      accept = {
        auto_brackets = {
          enabled = false,
        },
      },

      menu = {
        border = "rounded",
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 350,
        update_delay_ms = 50,

        window = {
          border = "rounded",
        },
      },
    },

    sources = {
      default = {
        "lsp",
        "snippets",
        "path",
        "buffer",
      },
    },

    signature = {
      enabled = true,

      window = {
        border = "rounded",
        show_documentation = false,
      },
    },
  })

  self:set_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function ()
      self:set_highlights()
    end,
  })
end

function BlinkCmp:set_highlights()
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", {
    fg = "#ffffff",
    bg = "#3b6ea8",
    bold = true,
  })

  vim.api.nvim_set_hl(0, "BlinkCmpMenu", {
    fg = "#d4d4d4",
    bg = "#1e222a",
  })
end

return BlinkCmp
