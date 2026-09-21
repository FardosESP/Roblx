-- UI/Theme.luau
-- GameAnalyzer v6.0 IDE Edition — UI Styling & Design Tokens

local Config = require(script.Parent.Parent.Core.Config)

local Theme = {}

Theme.Colors = Config.Theme
Theme.CategoryColors = Config.CategoryColors

Theme.Fonts = {
    Main = Enum.Font.BuilderSans,
    Bold = Enum.Font.BuilderSansBold,
    Code = Enum.Font.Code,
}

Theme.Sizes = {
    TitleText    = 16,
    SubText      = 13,
    BodyText     = 12,
    CodeText     = 12,
    BadgeText    = 10,
    SidebarWidth = 190,
    HeaderHeight = 42,
    StatusBarHeight = 24,
}

Theme.Corners = {
    Window    = UDim.new(0, 10),
    Card      = UDim.new(0, 6),
    Button    = UDim.new(0, 6),
    Badge     = UDim.new(0, 4),
    Input     = UDim.new(0, 6),
}

return Theme
