-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in  = 5,
        -- gaps_out = 12,
        gaps_out = {
          top = 8,
          bottom = 8,
          left = 10,
          right = 10,
        },

        border_size = 3,

        col = {
            active_border   = { colors = {"rgba(e0e0e0ee)", "rgba(8a8a8aee)"}, angle = 45 },
            inactive_border = "rgba(3c3c3caa)",
        },

        resize_on_border = false,
        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 6,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Spring curves, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("bouncy", { type = "spring", mass = 1, stiffness = 50, dampening = 10 })

-- Bezier curves
hl.curve("smoothOut", { type = "bezier", points = { {0.36, 0}, {0.66, -0.56} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10, bezier = "default" })

hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "default" })

hl.animation({ leaf = "windows",       enabled = true, speed = 5, spring = "bouncy", style = "slide" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 5, spring = "bouncy", style = "slide" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 5, spring = "bouncy" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 5, bezier = "smoothOut", style = "slide" })

hl.animation({ leaf = "workspaces",    enabled = true, speed = 5, spring = "bouncy", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 5, spring = "bouncy", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5, spring = "bouncy", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, spring = "bouncy", style = "slidevert" })

hl.animation({ leaf = "layers",        enabled = true, speed = 5, spring = "bouncy", style = "slide top" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 5, spring = "bouncy", style = "slide top" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 4, bezier = "smoothOut", style = "slide top" })

hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})
