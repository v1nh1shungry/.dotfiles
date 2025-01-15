-- Credit: https://github.com/mikavilpas/blink-ripgrep.nvim

---@module "blink.cmp"

---@class blink.cmp.Source
---
---@field context integer
---@field max_file_size string
---@field hl_group string
---@field min_keyword_length integer
---
---@field job vim.SystemObj
local M = {
  context = 3,
  max_file_size = "1G",
  max_item_count = 1024,
  hl_group = "Search",
  min_keyword_length = 5,
}

local word_pattern
do
  -- match an ascii character as well as unicode continuation bytes.
  -- Technically, unicode continuation bytes need to be applied in order to
  -- construct valid utf-8 characters, but right now we trust that the user
  -- only types valid utf-8 in their project.
  local char = vim.lpeg.R("az", "AZ", "09", "\128\255")

  local non_starting_word_character = vim.lpeg.P(1) - char
  local word_character = char + vim.lpeg.P("_") + vim.lpeg.P("-")
  local non_middle_word_character = vim.lpeg.P(1) - word_character

  word_pattern =
    vim.lpeg.Ct((non_starting_word_character ^ 0 * vim.lpeg.C(word_character ^ 1) * non_middle_word_character ^ 0) ^ 0)
end

local NS = vim.F.npcall(function()
  return require("blink.cmp.config").appearance.highlight_ns
end) or 0

---@param text_before_cursor string "The text of the entire line before the cursor"
---@return string
local function match_prefix(text_before_cursor)
  local matches = vim.lpeg.match(word_pattern, text_before_cursor)
  local last_match = matches and matches[#matches]
  return last_match or ""
end

---@param context blink.cmp.Context
---@return string
local function get_prefix(context)
  local line = context.line
  local col = context.cursor[2]
  local text = line:sub(1, col)
  local prefix = match_prefix(text)
  return prefix
end

function M.new(opts)
  return setmetatable(opts or {}, { __index = M })
end

---@param context blink.cmp.Context
---@param resolve fun(response?: blink.cmp.CompletionResponse)
---@return fun(): nil
function M:get_completions(context, resolve)
  local prefix = get_prefix(context)
  if string.len(prefix) < self.min_keyword_length then
    resolve()
    return function() end
  end

  local total = 0
  local files = {}
  -- NOTE: a json string may be split into two parts for two `stdout` call
  local last_line = ""

  M.job = vim.system(
    {
      "rg",
      "--no-config",
      "--json",
      "--context",
      tostring(self.context),
      "--word-regexp",
      "--max-filesize",
      self.max_file_size,
      "--smart-case",
      "--",
      prefix .. "[\\w_-]+",
    },
    {
      cwd = vim.uv.cwd(),
      text = true,
      stdout = vim.schedule_wrap(function(_, data)
        if not data or data == "" then
          return
        end

        local lines = vim.split(data, "\n", { trimempty = true })
        for _, line in ipairs(lines) do
          local json = vim.F.npcall(vim.json.decode, line)
          if not json then
            json = vim.F.npcall(vim.json.decode, last_line .. line)
          end

          if json then
            if json.type == "begin" then
              ---@type string
              local filename = json.data.path.text
              local ext = vim.fn.fnamemodify(filename, ":e")
              local ft = vim.filetype.match({ filename = filename })
              local lang = ft or vim.treesitter.language.get_lang(ext) or ext
              files[filename] = {
                lang = lang,
                lines = {},
                matches = {},
              }
            elseif json.type == "context" then
              files[json.data.path.text].lines[json.data.line_number] = json.data.lines.text
            elseif json.type == "match" then
              local file = files[json.data.path.text]
              file.lines[json.data.line_number] = json.data.lines.text

              local text = json.data.submatches[1].match.text
              table.insert(file.matches, {
                start_col = json.data.submatches[1].start,
                end_col = json.data.submatches[1]["end"],
                match = text,
                line_number = json.data.line_number,
                context_preview = {},
              })
            elseif json.type == "end" then
              local file = files[json.data.path.text]
              for _, match in ipairs(file.matches) do
                local start_line = math.max(1, match.line_number - self.context)
                local end_line = match.line_number + self.context
                for i = start_line, end_line do
                  local l = file.lines[i]
                  if l then
                    table.insert(match.context_preview, { text = l:gsub("%s*$", ""), line_number = i })
                  end
                end
              end
              file.lines = {}

              total = total + #file.matches
              if total >= self.max_item_count then
                self.job:kill(9)
              end
            end
          else
            last_line = line
          end
        end
      end),
    },
    vim.schedule_wrap(function(res)
      if res.code ~= 0 then
        resolve()
        return
      end

      local kind = require("blink.cmp.types").CompletionItemKind.Text
      local items = {}
      for filename, file in pairs(files) do
        for _, match in ipairs(file.matches) do
          if #match.context_preview == 0 or items[match.match] then
            break
          end

          items[match.match] = {
            documentation = {
              kind = "markdown",
              value = vim.iter(match.context_preview):fold("", function(acc, v)
                return acc .. v.text .. "\n"
              end),
              ---@param opts blink.cmp.SourceRenderDocumentationOpts
              render = function(opts)
                local bufnr = opts.window:get_buf()

                local text = {
                  vim.fs.relpath(vim.uv.cwd(), filename),
                  string.rep(
                    "-",
                    vim.iter(match.context_preview):fold(0, function(acc, v)
                      return math.max(acc, string.len(v.text))
                    end)
                  ),
                }
                vim.list_extend(
                  text,
                  vim
                    .iter(match.context_preview)
                    :map(function(v)
                      return v.text
                    end)
                    :totable()
                )
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)

                local parser_installed = pcall(vim.treesitter.get_parser, nil, file.lang, {})
                if parser_installed then
                  require("blink.cmp.lib.window.docs").highlight_with_treesitter(bufnr, file.lang, 2, #text)
                end

                local line_in_doc
                for i, data in ipairs(match.context_preview) do
                  if data.line_number == match.line_number then
                    line_in_doc = i
                    break
                  end
                end

                vim.api.nvim_buf_set_extmark(bufnr, NS, line_in_doc + 1, match.start_col, {
                  end_col = match.end_col,
                  hl_group = M.hl_group,
                })
              end,
            },
            source_id = "blink.rg",
            kind = kind,
            label = match.match,
            labelDetails = { description = "(rg)" },
            insertText = match.match,
          }
        end
      end

      resolve({
        is_incomplete_backward = false,
        is_incomplete_forward = false,
        items = vim.tbl_values(items),
        context = context,
      })
    end)
  )

  return function()
    M.job:kill(9)
  end
end

return M
