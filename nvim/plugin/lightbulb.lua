-- Modified from https://github.com/kosayoda/nvim-lightbulb {{{
local LIGHTBULB_AUGROUP = Dotfiles.augroup("lsp.lightbulb")
local NS_ID = Dotfiles.ns("lsp.lightbulb")

Dotfiles.lsp.on_attach(function(client, bufnr)
  local function clear_lightbulb()
    vim.api.nvim_buf_clear_namespace(bufnr, NS_ID, 0, -1)
  end

  if client:supports_method("textDocument/codeAction") then
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        if vim.bo[bufnr].buftype ~= "" then
          return
        end

        clear_lightbulb()

        if vim.b[bufnr].lightbulb_cancel then
          pcall(vim.b[bufnr].lightbulb_cancel)
          vim.b[bufnr].lightbulb_cancel = nil
        end

        local params = vim.lsp.util.make_range_params(0, "utf-8") ---@type table
        params.context = {
          diagnostics = vim.lsp.diagnostic.from(
            vim.diagnostic.get(bufnr, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
          ),
        }

        vim.b[bufnr].lightbulb_cancel = vim.F.npcall(
          vim.lsp.buf_request_all,
          bufnr,
          "textDocument/codeAction",
          params,
          function(res)
            local has_action = false
            for _, r in pairs(res) do
              if r.result and not vim.tbl_isempty(r.result) then
                has_action = true
                break
              end
            end

            if not has_action then
              return
            end

            vim.api.nvim_buf_set_extmark(bufnr, NS_ID, params.range.start.line, params.range.start.character + 1, {
              strict = false,
              virt_text = { { "💡" } },
              virt_text_pos = "eol",
            })
          end
        )
      end,
      group = LIGHTBULB_AUGROUP,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
      buffer = bufnr,
      callback = clear_lightbulb,
      group = LIGHTBULB_AUGROUP,
    })
  end
end)
-- }}}
