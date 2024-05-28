vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx)
  if result and result.contents then
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client and client.name == "clangd" then
      local contents = {}

      local params = {}
      local ret = {}
      local last_param_linenr

      for _, line in ipairs(vim.split(result.contents.value, "\n")) do
        local brief = line:match("[\\@]brief (.+)")
        if brief then
          contents[#contents + 1] = brief
          contents[#contents + 1] = ""
          goto continue
        end

        local param_name = line:match("^- `.+ (.+)`")
        if param_name then
          contents[#contents + 1] = line
          params[param_name] = #contents
          last_param_linenr = #contents
          goto continue
        end

        local param, desc = line:match("[\\@]param (.-) (.+)")
        if param and desc then
          for name, linenr in pairs(params) do
            if name == param then
              contents[linenr] = contents[linenr] .. " " .. desc
              goto continue
            end
          end
        end

        if not ret.desc then
          ret.desc = line:match("[\\@]return (.+)")
          if ret.desc then
            goto continue
          end
        end

        if line:match("^→") then
          contents[#contents + 1] = vim.trim(line)
          ret.linenr = #contents
          goto continue
        end

        contents[#contents + 1] = line

        ::continue::
      end

      if ret.linenr then
        contents[ret.linenr] = contents[ret.linenr] .. "\n" .. (ret.desc and (ret.desc .. "\n") or "") .. "---"
      end

      if last_param_linenr then
        contents[last_param_linenr + 1] = "---"
      end

      result.contents.value = table.concat(contents, "\n")
    end
  end
  require("noice.lsp.hover").on_hover(_, result, ctx)
end
