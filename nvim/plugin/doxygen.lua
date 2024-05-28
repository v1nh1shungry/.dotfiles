vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx)
  local function handle()
    if not (result and result.contents) then
      return
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not (client and client.name == "clangd") then
      return
    end
    local sections = vim.split(result.contents.value, "---", { plain = true })
    if #sections ~= 3 then
      return
    end

    local docs = vim.split(sections[2], "\n")
    local comments = {}

    local params = {}
    local ret = {}

    for _, line in ipairs(docs) do
      line = vim.trim(line)

      if line == "" then
        goto continue
      end

      local brief = line:match("[\\@]brief (.+)")
      if brief then
        table.insert(comments, 1, brief)
        goto continue
      end

      if not ret.type then
        ret.type = line:match("^→ (.+)")
        if ret.type then
          goto continue
        end
      end
      if not ret.desc then
        ret.desc = line:match("[\\@]return (.+)")
        if ret.desc then
          goto continue
        end
      end

      if line:match("^Parameters:$") then
        goto continue
      end
      local param = line:match("^- `.- (.+)`")
      if param then
        params[param] = line
        goto continue
      end
      local name, desc = line:match("[\\@]param (.-) (.+)")
      if name and desc and params[name] then
        params[name] = params[name] .. " " .. desc
        goto continue
      end

      comments[#comments + 1] = line

      ::continue::
    end

    local new_docs = {}
    if vim.tbl_count(params) ~= 0 then
      local params_section = {}
      for _, desc in pairs(params) do
        params_section[#params_section + 1] = desc
      end
      new_docs[#new_docs + 1] = table.concat(params_section, "\n")
    end
    if ret.type then
      local ret_section = {}
      ret_section[#ret_section + 1] = "Returns " .. ret.type
      if ret.desc then
        ret_section[#ret_section + 1] = ret.desc
      end
      new_docs[#new_docs + 1] = table.concat(ret_section, "\n")
    end
    if #comments ~= 0 then
      local comment_section = {}
      for _, comment in ipairs(comments) do
        comment_section[#comment_section + 1] = comment
      end
      new_docs[#new_docs + 1] = table.concat(comment_section, "\n")
    end

    sections[2] = table.concat(new_docs, "\n---\n")
    result.contents.value = table.concat(sections, "\n---\n")
  end

  handle()
  require("noice.lsp.hover").on_hover(_, result, ctx)
end
