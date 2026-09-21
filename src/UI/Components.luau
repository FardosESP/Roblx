-- UI/Components.luau
-- GameAnalyzer v6.0 IDE Edition — Component Library

local Env    = require(script.Parent.Parent.Core.Env)
local Config = require(script.Parent.Parent.Core.Config)
local Theme  = require(script.Parent.Parent.UI.Theme)

local Components = {}
local TweenService = Env.Services.TweenService

function Components.createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or Theme.Corners.Card
    corner.Parent = parent
    return corner
end

function Components.createPadding(parent, top, bottom, left, right)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, top or 8)
    pad.PaddingBottom = UDim.new(0, bottom or 8)
    pad.PaddingLeft   = UDim.new(0, left or 8)
    pad.PaddingRight  = UDim.new(0, right or 8)
    pad.Parent = parent
    return pad
end

function Components.createBadge(text, color, parent)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = color or Theme.Colors.Accent
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.XY

    Components.createCorner(frame, Theme.Corners.Badge)
    Components.createPadding(frame, 2, 2, 6, 6)

    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Colors.Accent
    stroke.Transparency = 0.5
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Theme.Fonts.Bold
    label.TextSize = Theme.Sizes.BadgeText
    label.TextColor3 = color or Theme.Colors.TextPrimary
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 0, 0, 14)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Parent = frame

    if parent then frame.Parent = parent end
    return frame
end

function Components.createButton(text, onClick, parent, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Theme.Fonts.Bold
    btn.TextSize = Theme.Sizes.BodyText
    btn.TextColor3 = Theme.Colors.TextPrimary
    btn.BackgroundColor3 = color or Theme.Colors.BgCard
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 100, 0, 32)

    Components.createCorner(btn, Theme.Corners.Button)
    Components.createPadding(btn, 4, 4, 10, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Colors.Border
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.Colors.BgCardHover }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = color or Theme.Colors.BgCard }):Play()
    end)

    if onClick then
        btn.MouseButton1Click:Connect(onClick)
    end

    if parent then btn.Parent = parent end
    return btn
end

function Components.createCodeViewer(codeText, parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Theme.Colors.BgCode
    container.BorderSizePixel = 0
    Components.createCorner(container, Theme.Corners.Card)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.Colors.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
    scroll.Parent = container

    Components.createPadding(scroll, 8, 8, 10, 10)

    local label = Instance.new("TextLabel")
    label.Text = codeText or ""
    label.Font = Theme.Fonts.Code
    label.TextSize = Theme.Sizes.CodeText
    label.TextColor3 = Theme.Colors.TextCode
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.BackgroundTransparency = 1
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.Parent = scroll

    if parent then container.Parent = parent end
    return container
end

function Components.createNotificationToast(parentGui, title, message, color)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 300, 0, 60)
    toast.Position = UDim2.new(1, 20, 1, -80)
    toast.BackgroundColor3 = Theme.Colors.BgCard
    toast.BorderSizePixel = 0
    toast.ZIndex = 100

    Components.createCorner(toast, Theme.Corners.Card)
    Components.createPadding(toast, 8, 8, 12, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Colors.Accent
    stroke.Thickness = 1.5
    stroke.Parent = toast

    local tLabel = Instance.new("TextLabel")
    tLabel.Text = title
    tLabel.Font = Theme.Fonts.Bold
    tLabel.TextSize = Theme.Sizes.SubText
    tLabel.TextColor3 = color or Theme.Colors.Accent
    tLabel.Size = UDim2.new(1, 0, 0, 18)
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1
    tLabel.Parent = toast

    local mLabel = Instance.new("TextLabel")
    mLabel.Text = message
    mLabel.Font = Theme.Fonts.Main
    mLabel.TextSize = Theme.Sizes.BodyText
    mLabel.TextColor3 = Theme.Colors.TextSecondary
    mLabel.Size = UDim2.new(1, 0, 0, 24)
    mLabel.Position = UDim2.new(0, 0, 0, 20)
    mLabel.TextXAlignment = Enum.TextXAlignment.Left
    mLabel.BackgroundTransparency = 1
    mLabel.Parent = toast

    toast.Parent = parentGui

    -- Animate in
    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -80)
    }):Play()

    -- Animate out after 3.5s
    task.delay(3.5, function()
        local tw = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 1, -80)
        })
        tw:Play()
        tw.Completed:Connect(function() toast:Destroy() end)
    end)
end

return Components
