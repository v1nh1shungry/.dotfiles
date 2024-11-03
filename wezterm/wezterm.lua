local wezterm = require("wezterm")

local function maximize()
  for _, window in ipairs(wezterm.mux.all_windows()) do
    window:gui_window():maximize()
  end
end

wezterm.on("gui-startup", maximize)
wezterm.on("gui-attached", maximize)

return {
  audible_bell = "Disabled",
  color_scheme = "Tokyo Night Storm",
  default_prog = { "tmux" },
  disable_default_key_bindings = true,
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font Mono",
    "Noto Sans CJK SC",
  }),
  font_size = 14,
  front_end = "WebGpu",
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
    { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("DefaultDomain") },
    { key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
    { key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
    { key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
  },
  ssh_domains = {
    {
      name = "scutech",
      remote_address = "172.28.2.205",
      username = "scutech",
      multiplexing = "None",
      default_prog = { "tmux", "new", "-A", "-s", "0" },
    },
  },
}
