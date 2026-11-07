-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/

-- Events
hl.on("hyprland.start", function()
  hl.notification.create({
      text = "Welcome Home!",
    timeout = 2500,
    icon = "ok"
  })
end)
hl.on("hyprland.shutdown", function()
  hl.notification.create({
      text = "Bye, bye, Hypr :(",
    timeout = 2500,
    -- icon = ""
  })
end)
-- hl.on("window.urgent", function(w)
--   hl.notification.create({
--       text = "",
--     timeout = 2500,
--     icon = "ok"
--   })
-- end)
-- hl.on("window.pin", function(w)
--   hl.notification.create({
--       text = "",
--     timeout = 2500,
--     icon = "ok"
--   })
-- end)
-- hl.on("window.fullscreen", function(w)
--   hl.notification.create({
--       text = "",
--     timeout = 2500,
--     icon = "ok"
--   })
-- end)
hl.on("monitor.removed", function(m)
  hl.notification.create({
    text = "Monitor removed",
    timeout = 2500,
    icon = "ok"
  })
end)
-- hl.on("monitor.layout_changed", function()
--   hl.notification.create({
--       text = "",
--     timeout = 2500,
--     icon = "ok"
--   })
-- end)
hl.on("monitor.added", function()
  hl.notification.create({
    text = "Monitor connected",
    timeout = 2500,
    icon = "ok"
  })
end)
hl.on("config.reloaded", function()
  hl.notification.create({
      text = "Hypr config successfuly reloaded and applied!",
    timeout = 2500,
    icon = "ok"
  })
end)
-- hl.on("screenshare.state", function(active, type, name)
--   hl.notification.create({
--       text = "",
--     timeout = 2500,
--     icon = "ok"
--   })
-- end)
