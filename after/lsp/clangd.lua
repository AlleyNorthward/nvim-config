local function find_compilers()
  local compilers = {}

  for _, name in ipairs({ "gcc", "g++" }) do
    local path = vim.fn.exepath(name)

    if path ~= "" then
      table.insert(compilers, path)
    end
  end

  return compilers
end

local function build_cmd()
  local cmd = {
    "clangd",
    "--header-insertion=never",
    "--background-index",
    "--clang-tidy",
    "--all-scopes-completion",
    "--completion-style=detailed",
    "--function-arg-placeholders=0",
    "--pch-storage=memory",
  }

  local compilers = find_compilers()

  if #compilers > 0 then
    table.insert(cmd, "--query-driver=" .. table.concat(compilers, ","))
  end

  return cmd
end

local function switch_source_header(bufnr, client)
  local method_name = "textDocument/switchSourceHeader"

  if not client or not client:supports_method(method_name) then
    return vim.notify(
      "Method " .. method_name .. " is not supported",
      vim.log.levels.WARN
    )
  end

  local params = vim.lsp.util.make_text_document_params(bufnr)

  client:request(method_name, params, function(err, result)
    if err then
      return vim.notify(tostring(err), vim.log.levels.ERROR)
    end

    if not result then
      return vim.notify("Corresponding file cannot be determined")
    end

    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info(bufnr, client)
  local method_name = "textDocument/symbolInfo"

  if not client or not client:supports_method(method_name) then
    return vim.notify("Clangd client not found", vim.log.levels.ERROR)
  end

  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

  client:request(method_name, params, function(err, result)
    if err or not result or not result[1] then
      return
    end

    local container = "container: " .. result[1].containerName
    local name = "name: " .. result[1].name

    vim.lsp.util.open_floating_preview({ name, container }, "", {
      height = 2,
      width = math.max(#name, #container),
      focusable = false,
      focus = false,
      title = "Symbol Info",
      border = "rounded",
    })
  end, bufnr)
end

local group = vim.api.nvim_create_augroup("ClangdCommands", {
  clear = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client or client.name ~= "clangd" then
      return
    end

    local bufnr = args.buf

    vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
      switch_source_header(bufnr, client)
    end, {
      desc = "Switch between source/header",
    })

    vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
      symbol_info(bufnr, client)
    end, {
      desc = "Show symbol info",
    })
  end,
})

return {
  cmd = build_cmd(),
}
