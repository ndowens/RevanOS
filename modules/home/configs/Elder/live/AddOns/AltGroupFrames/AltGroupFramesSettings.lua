
CALLBACK_MANAGER:RegisterCallback(ALT_GROUP_FRAMES.EVENT.MANAGER_CREATED, function(UnitFramesManager)
    local LAM2 = LibAddonMenu2

    LAM2:RegisterAddonPanel("ALTGF_Settings", {
        type = "panel",
        name = "Alternative Group Frames",
        displayName = "Alternative Group Frames",
        author = "|c943810BulDeZir|r",
        version = string.format('|c00FF00%s|r', 1),
        registerForRefresh = true,
        registerForDefaults = true,
    })

    local optionsData = {
        {
            type = "checkbox",
            name = "Use Character Names",
            default = function() return UnitFramesManager.DEFAULTS['USE_CHARACTER_NAMES'] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.USE_CHARACTER_NAMES end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.USE_CHARACTER_NAMES = newValue
                UnitFramesManager:RefreshData()
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "checkbox",
            name = "Show Class Icons",
            default = function() return UnitFramesManager.DEFAULTS['SHOW_CLASS_ICONS'] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.SHOW_CLASS_ICONS end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.SHOW_CLASS_ICONS = newValue
                UnitFramesManager:RefreshData()
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "checkbox",
            name = "Show Level",
            default = function() return UnitFramesManager.DEFAULTS['SHOW_LEVEL'] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.SHOW_LEVEL end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.SHOW_LEVEL = newValue
                UnitFramesManager:RefreshData()
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "slider",
            name = 'Units per column',
            min = 2,
            max = 12,
            step = 1,
            default = function() return UnitFramesManager.DEFAULTS['FRAMES_PER_COLUMN'] end,
            getFunc = function() return zo_round(UnitFramesManager.SAVEVARS.FRAMES_PER_COLUMN) end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.FRAMES_PER_COLUMN = zo_round(newValue)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "slider",
            name = 'Frame width',
            min = 120,
            max = 280,
            step = 5,
            default = function() return UnitFramesManager.DEFAULTS['UNIT_FRAME_WIDTH'] end,
            getFunc = function() return zo_round(UnitFramesManager.SAVEVARS.UNIT_FRAME_WIDTH) end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.UNIT_FRAME_WIDTH = zo_round(newValue)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "slider",
            name = 'Frame Margin X',
            min = 1,
            max = 8,
            step = 1,
            default = function() return UnitFramesManager.DEFAULTS['UNIT_FRAME_PAD_X'] end,
            getFunc = function() return zo_round(UnitFramesManager.SAVEVARS.UNIT_FRAME_PAD_X) end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.UNIT_FRAME_PAD_X = zo_round(newValue)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "slider",
            name = 'Frame Margin Y',
            min = 0,
            max = 8,
            step = 1,
            default = function() return UnitFramesManager.DEFAULTS['UNIT_FRAME_PAD_Y'] end,
            getFunc = function() return zo_round(UnitFramesManager.SAVEVARS.UNIT_FRAME_PAD_Y) end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.UNIT_FRAME_PAD_Y = zo_round(newValue)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "divider",
        },
        {
            type = "colorpicker",
            name = 'Shield color',
            default = function() return UnitFramesManager.DEFAULTS['SHIELD_COLOR'] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.SHIELD_COLOR:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.SHIELD_COLOR = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "colorpicker",
            name = 'Trauma color',
            default = function() return UnitFramesManager.DEFAULTS['TRAUMA_COLOR'] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.TRAUMA_COLOR:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.TRAUMA_COLOR = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "divider",
        },
        {
            type = "colorpicker",
            name = 'Tank Color Gradient Start',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['LFG_COLORS'][LFG_ROLE_TANK][1] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_TANK][1]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_TANK][1] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "colorpicker",
            name = 'Tank Color Gradient End',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['LFG_COLORS'][LFG_ROLE_TANK][2] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_TANK][2]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_TANK][2] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "divider",
        },
        {
            type = "colorpicker",
            name = 'Healer Color Gradient Start',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['LFG_COLORS'][LFG_ROLE_HEAL][1] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_HEAL][1]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_HEAL][1] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "colorpicker",
            name = 'Healer Color Gradient End',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['LFG_COLORS'][LFG_ROLE_HEAL][2] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_HEAL][2]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_HEAL][2] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "divider",
        },
        {
            type = "colorpicker",
            name = 'DPS Color Gradient Start',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['LFG_COLORS'][LFG_ROLE_DPS][1] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_DPS][1]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_DPS][1] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "colorpicker",
            name = 'DPS Color Gradient End',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['LFG_COLORS'][LFG_ROLE_DPS][2] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_DPS][2]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.LFG_COLORS[LFG_ROLE_DPS][2] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "divider",
        },
        {
            type = "colorpicker",
            name = 'Companion Color Gradient Start',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['COMPANION_COLORS'][1] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.COMPANION_COLORS[1]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.COMPANION_COLORS[1] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "colorpicker",
            name = 'Companion Color Gradient End',
            width = 'half',
            default = function() return UnitFramesManager.DEFAULTS['COMPANION_COLORS'][2] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.COMPANION_COLORS[2]:UnpackRGBA() end,
            setFunc = function(...)
                UnitFramesManager.SAVEVARS.COMPANION_COLORS[2] = ZO_ColorDef:New(...)
                UnitFramesManager:RefreshView(true, true)
            end,
        },
        {
            type = "divider",
        },
        {
            type = "checkbox",
            name = "Show Myself if no group (debug)",
            default = function() return UnitFramesManager.DEFAULTS['SHOW_NOGROUP'] end,
            getFunc = function() return UnitFramesManager.SAVEVARS.SHOW_NOGROUP end,
            setFunc = function(newValue)
                UnitFramesManager.SAVEVARS.SHOW_NOGROUP = newValue
                UnitFramesManager:RefreshData()
                UnitFramesManager:RefreshView(true, true)
            end,
        },
    }
    LAM2:RegisterOptionControls("ALTGF_Settings", optionsData)
end)