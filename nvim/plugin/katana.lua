local CHARACTERS = {
  ["あ"] = "a",
  ["い"] = "i",
  ["う"] = "u",
  ["え"] = "e",
  ["お"] = "o",
  ["か"] = "ka",
  ["き"] = "ki",
  ["く"] = "ku",
  ["け"] = "ke",
  ["こ"] = "ko",
  ["さ"] = "sa",
  ["し"] = "shi",
  ["す"] = "su",
  ["せ"] = "se",
  ["そ"] = "so",
  ["た"] = "ta",
  ["ち"] = "chi",
  ["つ"] = "tsu",
  ["て"] = "te",
  ["と"] = "to",
  ["な"] = "na",
  ["に"] = "ni",
  ["ぬ"] = "nu",
  ["ね"] = "ne",
  ["の"] = "no",
  ["は"] = "ha",
  ["ひ"] = "hi",
  ["ふ"] = "fu",
  ["へ"] = "he",
  ["ほ"] = "ho",
  ["ま"] = "ma",
  ["み"] = "mi",
  ["む"] = "mu",
  ["め"] = "me",
  ["も"] = "mo",
  ["や"] = "ya",
  ["ゆ"] = "yu",
  ["よ"] = "yo",
  ["ら"] = "ra",
  ["り"] = "ri",
  ["る"] = "ru",
  ["れ"] = "re",
  ["ろ"] = "ro",
  ["わ"] = "wa",
  ["を"] = "wo",
  ["ん"] = "n",
  ["が"] = "ga",
  ["ぎ"] = "gi",
  ["ぐ"] = "gu",
  ["げ"] = "ge",
  ["ご"] = "go",
  ["ざ"] = "za",
  ["じ"] = "ji",
  ["ず"] = "zu",
  ["ぜ"] = "ze",
  ["ぞ"] = "zo",
  ["だ"] = "da",
  ["ぢ"] = "ji",
  ["づ"] = "zu",
  ["で"] = "de",
  ["ど"] = "do",
  ["ば"] = "ba",
  ["び"] = "bi",
  ["ぶ"] = "bu",
  ["べ"] = "be",
  ["ぼ"] = "bo",
  ["ぱ"] = "pa",
  ["ぴ"] = "pi",
  ["ぷ"] = "pu",
  ["ぺ"] = "pe",
  ["ぽ"] = "po",
}

local COUNT = 10
local AUGROUP = Dotfiles.augroup("katana")
local NS_ID = Dotfiles.ns("katana")

---@return string[]
local function generate_quiz()
  local t = vim.tbl_keys(CHARACTERS)
  for i = 1, COUNT do
    local j = math.random(i, #t)
    t[i], t[j] = t[j], t[i]
  end
  return vim.list_slice(t, 1, COUNT)
end

local function create()
  local quiz = generate_quiz()

  ---@param buf integer
  local function render(buf)
    vim.bo[buf].modifiable = true

    local lines = {}
    for _ = 1, COUNT do
      table.insert(lines, "")
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.api.nvim_buf_clear_namespace(buf, NS_ID, 0, -1)
    for i, q in ipairs(quiz) do
      vim.api.nvim_buf_set_extmark(buf, NS_ID, i - 1, 0, {
        virt_text = { { q .. " ", "Bold" } },
        virt_text_pos = "inline",
        right_gravity = false,
      })
    end
  end

  Snacks.win({
    b = {
      completion = false,
    },
    bo = {
      ft = "katana",
    },
    border = "rounded",
    enter = true,
    fixbuf = true,
    height = COUNT,
    keys = {
      ["i_<CR>"] = {
        "<CR>",
        function(self)
          local index = vim.api.nvim_win_get_cursor(self.win)[1]
          local line = vim.api.nvim_get_current_line()
          local answer = CHARACTERS[quiz[index]]
          local virt_text = answer == vim.trim(line):lower() and " ✅" or (answer .. " ❌")
          vim.api.nvim_buf_set_extmark(self.buf, Dotfiles.ns("katana"), index - 1, -1, {
            virt_text = { { virt_text, "Comment" } },
            virt_text_pos = "right_align",
          })

          if index < #quiz then
            vim.api.nvim_win_set_cursor(self.win, { index + 1, 0 })
          else
            vim.cmd("stopinsert")
          end
        end,
        mode = "i",
      },
      ["<CR>"] = function(self)
        quiz = generate_quiz()
        render(self.buf)
        vim.api.nvim_win_set_cursor(self.win, { 1, 0 })
        vim.cmd("startinsert")
      end,
    },
    minimal = true,
    on_buf = function(self)
      vim.api.nvim_create_autocmd("InsertLeave", {
        buffer = self.buf --[[@as integer]],
        command = "setlocal nomodifiable",
        desc = "Forbid modification after leaving insert mode",
        group = AUGROUP,
      })
      render(self.buf --[[@as integer]])
    end,
    on_win = function(self)
      vim.opt.backspace:remove("eol")
      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function() vim.opt.backspace:append("eol") end,
        desc = "Avoid backspace over line",
        group = AUGROUP,
        pattern = tostring(self.win),
      })

      vim.api.nvim_win_set_cursor(self.win --[[@as integer]], { 1, 0 })
      vim.cmd("startinsert")
    end,
    position = "float",
    title = " Kana Quiz 🥷",
    title_pos = "center",
    width = 0.4,
    wo = {
      cursorline = true,
    },
  })
end

vim.api.nvim_create_user_command("Katana", create, { desc = "Kana Quiz" })
