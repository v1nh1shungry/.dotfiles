Dotfiles.map({
  "<Leader>sL",
  Dotfiles.co.void(function()
    local ret = Dotfiles.co.system({
      "curl",
      "-fsSL",
      "https://spdx.org/licenses/licenses.json",
    })

    if ret.code ~= 0 then
      Snacks.notify.error("Failed to fetch SPDX license list: " .. ret.stderr)
      return
    end

    local json = vim.json.decode(ret.stdout)
    local licenses = json.licenses
    vim.iter(licenses):each(function(l)
      l.preview = {
        text = vim.inspect(l),
        ft = "json",
      }
      l.text = l.licenseId
    end)

    Dotfiles.co.schedule()
    Snacks.picker({
      items = licenses,
      format = function(item)
        return {
          { item.name, "SnacksPickerLabel" },
          { " ", virtual = true },
          { item.text, "SnacksPickerComment" },
          { " ", virtual = true },
          { item.isDeprecatedLicenseId and "deprecated" or "", "DiagnosticWarn" },
        }
      end,
      confirm = function(picker, item)
        picker:close()

        vim.system(
          { "curl", "-fsSL", item.detailsUrl },
          nil,
          vim.schedule_wrap(function(r)
            if r.code ~= 0 then
              Snacks.notify.error(("Failed to fetch %s: %s"):format(item.name, r.stderr))
              return
            end

            local path =
              vim.fs.joinpath(vim.fs.root(0, "LICENSE") or Snacks.git.get_root() or vim.fn.getcwd(), "LICENSE")
            vim.fn.writefile(vim.split(vim.json.decode(r.stdout).licenseText, "\n"), path)

            if vim.api.nvim_buf_get_name(0) == path then vim.cmd("checktime") end
          end)
        )
      end,
      preview = "preview",
      layout = { layout = { title = ("SPDX License List (%s)"):format(json.licenseListVersion) } },
    })
  end),
  desc = "Licenses",
})
