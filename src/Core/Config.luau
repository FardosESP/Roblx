-- Core/Config.luau
-- GameAnalyzer v6.0 IDE Edition — Configuration & Theme Engine

local Config = {}

Config.Version = "v6.0 IDE Edition"
Config.SubFolder = "ReverseKit"
Config.ToggleKey = Enum.KeyCode.RightControl

-- Theme: Claude / IDE Modern Dark Palette
Config.Theme = {
    -- Backgrounds
    BgMain        = Color3.fromRGB(24, 24, 27),       -- Dark Charcoal #18181b
    BgSidebar     = Color3.fromRGB(18, 18, 21),       -- Deeper Charcoal #121215
    BgHeader      = Color3.fromRGB(30, 30, 36),       -- Header Bar
    BgCard        = Color3.fromRGB(33, 33, 38),       -- Card / Panel
    BgCardHover   = Color3.fromRGB(42, 42, 49),       -- Hover Card
    BgInput       = Color3.fromRGB(20, 20, 24),       -- Input box
    BgCode        = Color3.fromRGB(15, 15, 18),       -- Code Viewer background

    -- Accents (Claude Warm Amber / Terracotta)
    Accent        = Color3.fromRGB(217, 119, 6),      -- Amber 600 #d97706
    AccentLight   = Color3.fromRGB(245, 158, 11),     -- Amber 500 #f59e0b
    AccentDark    = Color3.fromRGB(180, 83, 9),       -- Amber 700 #b45309
    AccentGlow    = Color3.fromRGB(251, 191, 36),     -- Amber 400

    -- Status & Category Badges
    Success       = Color3.fromRGB(34, 197, 94),      -- Green 500
    Warning       = Color3.fromRGB(234, 179, 8),      -- Yellow 500
    Danger        = Color3.fromRGB(239, 68, 68),      -- Red 500
    Info          = Color3.fromRGB(59, 130, 246),     -- Blue 500
    Purple        = Color3.fromRGB(168, 85, 247),     -- Purple 500

    -- Text
    TextPrimary   = Color3.fromRGB(243, 244, 246),    -- Neutral 100
    TextSecondary = Color3.fromRGB(156, 163, 175),    -- Neutral 400
    TextMuted     = Color3.fromRGB(107, 114, 128),    -- Neutral 500
    TextCode      = Color3.fromRGB(229, 231, 235),    -- Code font light

    -- Borders & Separators
    Border        = Color3.fromRGB(45, 45, 52),
    BorderFocus   = Color3.fromRGB(217, 119, 6),
}

Config.CategoryColors = {
    DAMAGE    = Color3.fromRGB(239, 68, 68),
    ECONOMY   = Color3.fromRGB(34, 197, 94),
    STAFF     = Color3.fromRGB(168, 85, 247),
    MOVEMENT  = Color3.fromRGB(59, 130, 246),
    FARM      = Color3.fromRGB(234, 179, 8),
    VEHICLE   = Color3.fromRGB(249, 115, 22),
    SKIN      = Color3.fromRGB(236, 72, 153),
    QUEST     = Color3.fromRGB(20, 184, 166),
    LOBBY     = Color3.fromRGB(14, 165, 233),
    CRAFT     = Color3.fromRGB(139, 92, 246),
    ANTICHEAT = Color3.fromRGB(225, 29, 72),
    PLAYER    = Color3.fromRGB(100, 116, 139),
    OTHER     = Color3.fromRGB(107, 114, 128),
}

return Config
