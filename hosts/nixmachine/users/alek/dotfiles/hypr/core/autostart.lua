-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local variables = require("core.variables")

hl.on("hyprland.start", function()
  -- Base apps
  hl.exec_cmd(variables.terminalApp)
  hl.exec_cmd(variables.filesApp)
  hl.exec_cmd(variables.browserApp)
  hl.exec_cmd(variables.editorApp)
  hl.exec_cmd(variables.proxyApp)


  -- Services
  hl.exec_cmd("waybar")
  hl.exec_cmd("dunst")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("systemctl --user start hyprland-polkit-agent || /run/current-system/sw/libexec/polkit-kde-authentication-agent-1")
  -- hl.exec_cmd("${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1")

  -- Common apps
  hl.exec_cmd(variables.proxyApp)
  hl.exec_cmd(variables.equalizerApp)
end)
