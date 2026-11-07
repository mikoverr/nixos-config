-- https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"
local variables = require("core.variables")

-- Launch base apps
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(variables.terminalApp))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(variables.filesApp))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(variables.browserApp))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(variables.editorApp))

-- Expand Panels
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(variables.launcherPanel))
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd(variables.AIAgentPanel))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(variables.controlPanel))

-- Launch Overlays
-- hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(variables.lockScreenOverlay))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd(variables.logoutOverlay))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(variables.screenshotsOverlay))
-- DEL hl.bind("Print", hl.dsp.exec_cmd("sh -c 'grim - | wl-copy && notify-send \"Screenshot\" \"Display copied to clipboard\"'"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("sh -c 'grim -g \"$(slurp)\" - | wl-copy && notify-send \"Screenshot\" \"Area copied to clipboard\"'"))
-- DEL hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("sh -c 'mkdir -p ~/Pictures/screenshots && grim ~/Pictures/screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png && notify-send \"Screenshot\" \"Display saved to ~/Pictures/screenshots\"'"))
-- DEL hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("sh -c 'mkdir -p ~/Pictures/screenshots && grim -g \"$(slurp)\" ~/Pictures/screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png && notify-send \"Screenshot\" \"Area saved to ~/Pictures/screenshots\"'"))

-- Window controls
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- Move focus
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))
-- Move/resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- Move active window within the grid
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
-- Move active window to another monitor
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ monitor = "d" }))

-- Switch workspaces + Move active window to a workspace
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
-- Special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Layout control
-- hl.bind(mainMod .. " + ", hl.dsp.layout("togglesplit")) -- dwindle only

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
