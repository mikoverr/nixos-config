-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("GTK_THEME", "Graphite-Dark")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

hl.env("XCURSOR_THEME", "material_light_cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "material_light_cursors")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("KDE_DEBUG", "1") -- no KDE errors in Hyprland

hl.env("XDG_DATA_DIRS", "/etc/profiles/per-user/alek/share:/run/current-system/sw/share:/usr/share")
