local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta

local function int_type_snippet(bits, unsigned)
  local prefix = unsigned and 'u' or ''
  local trig = (unsigned and 'u' or 'i') .. bits
  local expand = ('%sint%s_t'):format(prefix, bits)
  return s({
    trig = trig,
    name = ('(%s) %s'):format(trig, expand),
    desc = ('Expand to %s'):format(expand),
    snippetType = 'autosnippet',
  }, {
    t(expand),
  })
end

local function line_begin(line_to_cursor, matched_trigger, _)
  if matched_trigger == nil or line_to_cursor == nil then
    return false
  end
  return line_to_cursor:sub(1, -(#matched_trigger + 1)):match('^%s*$')
end

local function all_lines_before_are_comments()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)
  for _, line in ipairs(lines) do
    local match = false
    for _, p in ipairs {
      '^%s*//.*$',
      '^%s*$',
    } do
      if line:match(p) then
        match = true
        break
      end
    end
    if not match then
      return false
    end
  end
  return true
end

local function invoke_after_reparse_buffer(ori_bufnr, match, fun)
  local function reparse_buffer()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.api.nvim_buf_get_lines(ori_bufnr, 0, -1, false)
    local current_line = lines[row]
    local current_line_left = current_line:sub(1, col - #match)
    local current_line_right = current_line:sub(col + 1)
    lines[row] = current_line_left .. current_line_right
    local lang = vim.treesitter.language.get_lang(vim.bo[ori_bufnr].filetype) or vim.bo[ori_bufnr].filetype
    local source = table.concat(lines, '\n')
    local parser = vim.treesitter.get_string_parser(source, lang)
    parser:parse(true)
    return parser, source
  end
  local parser, source = reparse_buffer()
  local ret = { fun(parser, source) }
  parser:destroy()
  return unpack(ret)
end

local function make_type_matcher(types)
  if type(types) == 'string' then
    return { [types] = 1 }
  end
  if type(types) == 'table' then
    if vim.islist(types) then
      local new_types = {}
      for _, v in ipairs(types) do
        new_types[v] = 1
      end
      return new_types
    end
  end
  return types
end

local function find_first_parent(node, types)
  local matcher = make_type_matcher(types)
  local function find_parent_impl(root)
    if root == nil then
      return nil
    end
    if matcher[root:type()] == 1 then
      return root
    end
    return find_parent_impl(root:parent())
  end
  return find_parent_impl(node)
end

local function inject_class_name(_, line_to_cursor, match, captures)
  if not line_begin(line_to_cursor, match, captures) then
    return nil
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  return invoke_after_reparse_buffer(buf, match, function(parser, source)
    local pos = { row - 1, col - #match }
    local node = parser:named_node_for_range {
      pos[1],
      pos[2],
      pos[1],
      pos[2],
    }
    if node == nil then
      return nil
    end
    local class_node = find_first_parent(node, {
      'struct_specifier',
      'class_specifier',
    })
    if class_node == nil then
      return nil
    end
    local name_nodes = class_node:field('name')
    if name_nodes == nil or #name_nodes == 0 then
      return nil
    end
    local name_node = name_nodes[1]
    local ret = {
      trigger = match,
      captures = captures,
      env_override = {
        CLASS_NAME = vim.treesitter.get_node_text(name_node, source),
      },
    }
    return ret
  end)
end

local function constructor_snippet(trig, name, template)
  return s({
    trig = trig,
    name = ('(%s) %s'):format(trig, name),
    snippetType = 'autosnippet',
    resolveExpandParams = inject_class_name,
  }, {
    d(1, function(_, parent)
      local env = parent.env
      return sn(nil, fmta(template, { cls = t(env.CLASS_NAME) }))
    end),
  })
end

return {
  int_type_snippet(8, false),
  int_type_snippet(16, false),
  int_type_snippet(32, false),
  int_type_snippet(64, false),
  int_type_snippet(8, true),
  int_type_snippet(16, true),
  int_type_snippet(32, true),
  int_type_snippet(64, true),

  s({
    trig = '#<',
    name = '#include <>',
    desc = 'System include',
    snippetType = 'autosnippet',
    condition = line_begin,
  }, {
    t('#include <'),
    i(1),
    t('>'),
  }),

  s({
    trig = '#"',
    name = '#include ""',
    desc = 'Local include',
    snippetType = 'autosnippet',
    condition = line_begin,
  }, {
    t('#include "'),
    i(1),
    -- t('"'),
  }),

  s({
    trig = 'once',
    name = '(once) #pragma once',
    desc = 'Expands to #pragma once',
    snippetType = 'autosnippet',
    condition = function(line_to_cursor, matched_trigger, _)
      return line_begin(line_to_cursor, matched_trigger, _) and all_lines_before_are_comments()
    end,
  }, {
    t('#pragma once'),
  }),

  constructor_snippet(
    'ctor!',
    'Default constructor',
    [[
    <cls>() = default;
    ]]
  ),
  constructor_snippet(
    'dtor!',
    'Default destructor',
    [[
    ~<cls>() = default;
    ]]
  ),
  constructor_snippet(
    'cc!',
    'Copy constructor',
    [[
    <cls>(const <cls>& rhs) = default;
    ]]
  ),
  constructor_snippet(
    'mv!',
    'Move constructor',
    [[
    <cls>(<cls>&& rhs) = default;
    ]]
  ),
  constructor_snippet(
    'ncc!',
    'No copy constructor',
    [[
    <cls>(const <cls>&) = delete;
    ]]
  ),
  constructor_snippet(
    'nmv!',
    'No move constructor',
    [[
    <cls>(<cls>&&) = delete;
    ]]
  ),
  constructor_snippet(
    'ncm!',
    'No copy and move constructor',
    [[
    <cls>(const <cls>&) = delete;
    <cls>(<cls>&&) = delete;
    ]]
  ),

  s(
    {
      trig = 'struct',
      name = 'struct',
      desc = 'struct',
      snippetType = 'autosnippet',
      condition = line_begin,
    },
    fmta(
      [[
      struct <> {
        <>
      };
      ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    {
      trig = 'class',
      name = 'class',
      desc = 'class',
      snippetType = 'autosnippet',
      condition = line_begin,
    },
    fmta(
      [[
      class <> {
        <>
      };
      ]],
      {
        i(1),
        i(0),
      }
    )
  ),

  s(
    {
      trig = 'main',
      name = 'main function',
      desc = 'main function',
      snippetType = 'autosnippet',
      condition = line_begin,
    },
    fmta(
      [[
      int main(int argc, char *argv[]) {
        <>
      }
      ]],
      { i(0) }
    )
  ),
}
