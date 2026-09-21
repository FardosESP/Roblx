--[[
    ════════════════════════════════════════════════════════════════════
    ⚡ GameAnalyzer v7.0 IDE Edition — Modern UI Framework
    ════════════════════════════════════════════════════════════════════
    Based on ModernRobloxUI + Real IDE Layout (Explorer, Code, Terminal)
    ════════════════════════════════════════════════════════════════════
]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- Environment & Capabilities
----------------------------------------------------------------
local Env = { ExecutorName = "Potassium" }
pcall(function()
    if type(identifyexecutor) == "function" then Env.ExecutorName = identifyexecutor()
    elseif type(getexecutorname) == "function" then Env.ExecutorName = getexecutorname() end
end)

local function hasFn(name)
    local ok, t = pcall(function() return type(getgenv and getgenv()[name] or _G[name]) end)
    return ok and t == "function"
end
Env.CAPS = {
    writefile = hasFn("writefile"), readfile = hasFn("readfile"),
    hookmetamethod = hasFn("hookmetamethod"), getnamecallmethod = hasFn("getnamecallmethod"),
    setclipboard = hasFn("setclipboard"), decompile = hasFn("decompile")
}

local function decompileScript(s)
    if not Env.CAPS.decompile then return "-- [Error]: 'decompile' no disponible en " .. Env.ExecutorName end
    local ok, code = pcall(decompile, s)
    return ok and code or ("-- [Fallo al decompilar]: " .. tostring(code))
end

----------------------------------------------------------------
-- Theme
----------------------------------------------------------------
local Theme = {
    Background = Color3.fromRGB(18, 18, 17),
    Sidebar = Color3.fromRGB(24, 24, 23),
    Surface = Color3.fromRGB(29, 29, 27),
    Surface2 = Color3.fromRGB(34, 34, 32),
    Hover = Color3.fromRGB(42, 42, 39),
    Active = Color3.fromRGB(64, 64, 59),
    Border = Color3.fromRGB(70, 70, 66),
    Text = Color3.fromRGB(238, 238, 233),
    TextSecondary = Color3.fromRGB(169, 169, 162),
    TextMuted = Color3.fromRGB(112, 112, 107),
    Accent = Color3.fromRGB(218, 145, 72),
    Success = Color3.fromRGB(90, 190, 125),
    Danger = Color3.fromRGB(225, 91, 91),
    CodeBg = Color3.fromRGB(14, 14, 13),
    Radius = 12, Fast = 0.14, Normal = 0.22, Slow = 0.36,
}

----------------------------------------------------------------
-- Helpers
----------------------------------------------------------------
local function tween(instance, duration, properties, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local tw = TweenService:Create(instance, info, properties)
    tw:Play()
    return tw
end

local function corner(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or Theme.Radius)
    c.Parent = instance
    return c
end

local function stroke(instance, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Transparency = transparency or 0.35
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = instance
    return s
end

local function padding(instance, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left)
    p.PaddingRight = UDim.new(0, right)
    p.PaddingTop = UDim.new(0, top)
    p.PaddingBottom = UDim.new(0, bottom or top)
    p.Parent = instance
    return p
end

local function label(parent, text, size, color, bold)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = color
    t.TextSize = size
    t.Font = bold and Enum.Font.GothamSemibold or Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = parent
    return t
end

local function iconText(parent, glyph, size)
    local t = label(parent, glyph, size or 17, Theme.TextSecondary, false)
    t.Size = UDim2.fromOffset(22, 22)
    t.TextXAlignment = Enum.TextXAlignment.Center
    return t
end

local function addHover(button, normalColor, hoverColor, pressedColor)
    button.AutoButtonColor = false
    button.MouseEnter:Connect(function() tween(button, Theme.Fast, {BackgroundColor3 = hoverColor}) end)
    button.MouseLeave:Connect(function() tween(button, Theme.Fast, {BackgroundColor3 = normalColor}); tween(button, Theme.Fast, {Size = button.Size}) end)
    button.MouseButton1Down:Connect(function() tween(button, 0.08, {BackgroundColor3 = pressedColor}) end)
    button.MouseButton1Up:Connect(function() tween(button, 0.08, {BackgroundColor3 = hoverColor}) end)
end

local function highlightLuauCode(sourceText)
    if type(sourceText) ~= "string" then return "" end
    local safeLine = sourceText:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    safeLine = safeLine:gsub("%f[%a](local)%f[%A]", '<font color="#da9148">local</font>')
    safeLine = safeLine:gsub("%f[%a](function)%f[%A]", '<font color="#da9148">function</font>')
    safeLine = safeLine:gsub("%f[%a](end)%f[%A]", '<font color="#da9148">end</font>')
    safeLine = safeLine:gsub("%f[%a](return)%f[%A]", '<font color="#da9148">return</font>')
    safeLine = safeLine:gsub("%f[%a](if)%f[%A]", '<font color="#da9148">if</font>')
    safeLine = safeLine:gsub("%f[%a](then)%f[%A]", '<font color="#da9148">then</font>')
    safeLine = safeLine:gsub("%f[%a](else)%f[%A]", '<font color="#da9148">else</font>')
    safeLine = safeLine:gsub("%f[%a](game)%f[%A]", '<font color="#5abe7d">game</font>')
    safeLine = safeLine:gsub('(".-")', '<font color="#e6a95d">%1</font>')
    return safeLine
end

----------------------------------------------------------------
-- Root GUI & Scaling
----------------------------------------------------------------
local old = playerGui:FindFirstChild("GameAnalyzerIDE")
if old then old:Destroy() end
pcall(function() if game:GetService("CoreGui"):FindFirstChild("GameAnalyzerIDE") then game:GetService("CoreGui").GameAnalyzerIDE:Destroy() end end)

local gui = Instance.new("ScreenGui")
gui.Name = "GameAnalyzerIDE"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = playerGui end

local root = Instance.new("Frame")
root.Name = "Root"
root.BackgroundTransparency = 1
root.Size = UDim2.fromScale(1, 1)
root.Parent = gui

local scale = Instance.new("UIScale")
scale.Parent = root
local function updateScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    local factor = math.clamp(math.min(viewport.X / 1440, viewport.Y / 900), 0.72, 1.05)
    scale.Scale = factor
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateScale)
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) end
updateScale()

----------------------------------------------------------------
-- Main Window
----------------------------------------------------------------
local window = Instance.new("Frame")
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromOffset(1280, 720)
window.BackgroundColor3 = Theme.Background
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Parent = root
corner(window, 16)
stroke(window, Theme.Border, 0.1, 1)

----------------------------------------------------------------
-- Top bar
----------------------------------------------------------------
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 48)
top.BackgroundColor3 = Theme.Surface
top.BorderSizePixel = 0
top.Parent = window

local topDivider = Instance.new("Frame")
topDivider.BackgroundColor3 = Theme.Border
topDivider.BackgroundTransparency = 0.55
topDivider.BorderSizePixel = 0
topDivider.Position = UDim2.new(0, 0, 1, -1)
topDivider.Size = UDim2.new(1, 0, 0, 1)
topDivider.Parent = top

local title = label(top, "GameAnalyzer IDE", 14, Theme.Text, true)
title.Position = UDim2.fromOffset(20, 4)
title.Size = UDim2.fromOffset(200, 24)

local subtitle = label(top, Env.ExecutorName .. " Edition", 11, Theme.TextMuted, false)
subtitle.Position = UDim2.fromOffset(20, 24)
subtitle.Size = UDim2.fromOffset(200, 18)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 28)
close.Position = UDim2.new(1, -50, 0, 10)
close.BackgroundTransparency = 1
close.Text = "×"
close.TextSize = 20
close.TextColor3 = Theme.TextSecondary
close.Font = Enum.Font.Gotham
close.Parent = top
addHover(close, Theme.Surface, Theme.Hover, Theme.Active)
close.MouseButton1Click:Connect(function() tween(window, Theme.Normal, {Size = UDim2.fromOffset(1280, 0)}):Play(); task.delay(0.2, function() gui:Destroy() end) end)

local draggingWindow = false
local dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingWindow = true; dragStart = input.Position; startPos = window.Position end
end)
top.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingWindow = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

----------------------------------------------------------------
-- Sidebar (File Explorer)
----------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.new(0, 0, 0, 48)
sidebar.Size = UDim2.new(0, 260, 1, -48)
sidebar.BackgroundColor3 = Theme.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = window

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.BackgroundColor3 = Theme.Border
sidebarDivider.BackgroundTransparency = 0.6
sidebarDivider.BorderSizePixel = 0
sidebarDivider.Parent = sidebar

local expTitle = label(sidebar, "EXPLORER", 11, Theme.TextSecondary, true)
expTitle.Position = UDim2.fromOffset(20, 14)
expTitle.Size = UDim2.new(1, -40, 20)

local fileList = Instance.new("ScrollingFrame")
fileList.Position = UDim2.fromOffset(0, 44)
fileList.Size = UDim2.new(1, 0, 1, -44)
fileList.BackgroundTransparency = 1
fileList.ScrollBarThickness = 2
fileList.ScrollBarImageColor3 = Theme.Border
fileList.Parent = sidebar
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = fileList

----------------------------------------------------------------
-- Editor Area (Tabs + Code View + Terminal)
----------------------------------------------------------------
local contentRoot = Instance.new("Frame")
contentRoot.Position = UDim2.new(0, 260, 0, 48)
contentRoot.Size = UDim2.new(1, -260, 1, -48)
contentRoot.BackgroundTransparency = 1
contentRoot.Parent = window

-- Tabs Bar
local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, 0, 0, 36)
tabsBar.BackgroundColor3 = Theme.Surface
tabsBar.BorderSizePixel = 0
tabsBar.Parent = contentRoot
local tabsDivider = Instance.new("Frame")
tabsDivider.BackgroundColor3 = Theme.Border
tabsDivider.BackgroundTransparency = 0.55
tabsDivider.BorderSizePixel = 0
tabsDivider.Position = UDim2.new(0, 0, 1, -1)
tabsDivider.Size = UDim2.new(1, 0, 0, 1)
tabsDivider.Parent = tabsBar
local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabsBar

-- Code Viewer
local codeArea = Instance.new("Frame")
codeArea.Position = UDim2.new(0, 0, 0, 36)
codeArea.Size = UDim2.new(1, 0, 0.7, -36) -- 70% height
codeArea.BackgroundColor3 = Theme.CodeBg
codeArea.BorderSizePixel = 0
codeArea.Parent = contentRoot

local codeScroll = Instance.new("ScrollingFrame")
codeScroll.Size = UDim2.fromScale(1, 1)
codeScroll.BackgroundTransparency = 1
codeScroll.ScrollBarThickness = 5
codeScroll.ScrollBarImageColor3 = Theme.Border
codeScroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
codeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
codeScroll.Parent = codeArea
padding(codeScroll, 10, 10, 10, 10)

local gutter = Instance.new("TextLabel")
gutter.Text = "1"
gutter.Font = Enum.Font.Code
gutter.TextSize = 13
gutter.TextColor3 = Theme.TextMuted
gutter.TextXAlignment = Enum.TextXAlignment.Right
gutter.TextYAlignment = Enum.TextYAlignment.Top
gutter.Position = UDim2.new(0, 0, 0, 0)
gutter.Size = UDim2.new(0, 30, 0, 0)
gutter.AutomaticSize = Enum.AutomaticSize.XY
gutter.BackgroundTransparency = 1
gutter.Parent = codeScroll

local codeLabel = Instance.new("TextLabel")
codeLabel.RichText = true
codeLabel.Text = "-- Welcome to GameAnalyzer IDE\n-- Select a file from the explorer to view its contents."
codeLabel.Font = Enum.Font.Code
codeLabel.TextSize = 13
codeLabel.TextColor3 = Theme.Text
codeLabel.TextXAlignment = Enum.TextXAlignment.Left
codeLabel.TextYAlignment = Enum.TextYAlignment.Top
codeLabel.Position = UDim2.new(0, 44, 0, 0)
codeLabel.Size = UDim2.new(1, -44, 0, 0)
codeLabel.AutomaticSize = Enum.AutomaticSize.XY
codeLabel.BackgroundTransparency = 1
codeLabel.Parent = codeScroll

-- Terminal / Output Panel
local terminalArea = Instance.new("Frame")
terminalArea.Position = UDim2.new(0, 0, 0.7, 0)
terminalArea.Size = UDim2.new(1, 0, 0.3, 0) -- 30% height
terminalArea.BackgroundColor3 = Theme.Background
terminalArea.BorderSizePixel = 0
terminalArea.Parent = contentRoot

local termDivider = Instance.new("Frame")
termDivider.BackgroundColor3 = Theme.Border
termDivider.BackgroundTransparency = 0.55
termDivider.BorderSizePixel = 0
termDivider.Size = UDim2.new(1, 0, 0, 1)
termDivider.Parent = terminalArea

local termHeader = label(terminalArea, "TERMINAL", 10, Theme.TextSecondary, true)
termHeader.Position = UDim2.fromOffset(14, 6)
termHeader.Size = UDim2.new(1, 0, 20)

local termScroll = Instance.new("ScrollingFrame")
termScroll.Position = UDim2.fromOffset(0, 30)
termScroll.Size = UDim2.new(1, 0, 1, -30)
termScroll.BackgroundTransparency = 1
termScroll.ScrollBarThickness = 3
termScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
termScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
termScroll.Parent = terminalArea
local termLayout = Instance.new("UIListLayout")
termLayout.Padding = UDim.new(0, 2)
termLayout.Parent = termScroll
padding(termScroll, 14, 14, 0, 14)

local function logTerminal(msg, color)
    local l = label(termScroll, "> " .. tostring(msg), 12, color or Theme.TextSecondary, false)
    l.Font = Enum.Font.Code
    l.Size = UDim2.new(1, 0, 0, 16)
    l.TextWrapped = true
    l.AutomaticSize = Enum.AutomaticSize.Y
    termScroll.CanvasPosition = Vector2.new(0, 99999)
end

----------------------------------------------------------------
-- Logic: Tabs & Explorer
----------------------------------------------------------------
local openTabs = {}
local activeTab = nil

local function updateCodeView(content)
    local lines = string.split(content, "\n")
    local lineNums = {}
    for i = 1, #lines do table.insert(lineNums, tostring(i)) end
    gutter.Text = table.concat(lineNums, "\n")
    codeLabel.Text = highlightLuauCode(content)
end

local function selectTab(tabData)
    for _, t in ipairs(openTabs) do
        tween(t.Btn, Theme.Fast, {BackgroundColor3 = Theme.Surface})
        t.Lbl.TextColor3 = Theme.TextSecondary
    end
    activeTab = tabData
    tween(tabData.Btn, Theme.Fast, {BackgroundColor3 = Theme.Hover})
    tabData.Lbl.TextColor3 = Theme.Accent
    updateCodeView(tabData.Content)
end

local function openFileTab(name, content)
    for _, t in ipairs(openTabs) do
        if t.Name == name then
            selectTab(t)
            return
        end
    end

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.fromOffset(120, 36)
    tabBtn.BackgroundColor3 = Theme.Surface
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = ""
    tabBtn.Parent = tabsBar
    
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0, 1, 1, 0)
    divider.Position = UDim2.new(1, -1, 0, 0)
    divider.BackgroundColor3 = Theme.Border
    divider.BorderSizePixel = 0
    divider.Parent = tabBtn

    local lbl = label(tabBtn, name, 12, Theme.TextSecondary, false)
    lbl.Position = UDim2.fromOffset(14, 0)
    lbl.Size = UDim2.new(1, -34, 1, 0)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(16, 16)
    closeBtn.Position = UDim2.new(1, -22, 0.5, -8)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.Parent = tabBtn
    
    local tabData = { Name = name, Content = content, Btn = tabBtn, Lbl = lbl }
    table.insert(openTabs, tabData)
    
    tabBtn.MouseButton1Click:Connect(function() selectTab(tabData) end)
    closeBtn.MouseButton1Click:Connect(function()
        for i, t in ipairs(openTabs) do
            if t == tabData then
                table.remove(openTabs, i)
                tabBtn:Destroy()
                if activeTab == tabData then
                    if #openTabs > 0 then selectTab(openTabs[#openTabs]) else updateCodeView("-- No file open") activeTab = nil end
                end
                break
            end
        end
    end)
    
    selectTab(tabData)
end

local function createExplorerItem(name, icon, typeStr, instanceRef)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Theme.Sidebar
    b.BorderSizePixel = 0
    b.Text = ""
    b.Parent = fileList

    local i = label(b, icon, 14, Theme.Accent, false)
    i.Position = UDim2.fromOffset(16, 0)
    i.Size = UDim2.fromOffset(20, 28)

    local l = label(b, name, 12, Theme.Text, false)
    l.Position = UDim2.fromOffset(42, 0)
    l.Size = UDim2.new(1, -50, 1, 0)

    addHover(b, Theme.Sidebar, Theme.Hover, Theme.Active)
    
    b.MouseButton1Click:Connect(function()
        logTerminal("Opening " .. name .. "...")
        local content = "-- File: " .. name .. "\n-- Type: " .. typeStr .. "\n\n"
        if instanceRef:IsA("ModuleScript") or instanceRef:IsA("LocalScript") then
            local source = decompileScript(instanceRef)
            content = content .. source
        else
            content = content .. "-- Cannot decompile non-script instances."
        end
        openFileTab(name, content)
    end)
end

----------------------------------------------------------------
-- Scanners & Initialization
----------------------------------------------------------------
local function runScanners()
    logTerminal("Scanning ReplicatedStorage for Modules...", Theme.Success)
    local count = 0
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("ModuleScript") then
            createExplorerItem(v.Name .. ".luau", "📄", "ModuleScript", v)
            count = count + 1
        end
        if count > 50 then break end -- Limit for performance demo
    end
    logTerminal("Found " .. tostring(count) .. " modules.", Theme.TextSecondary)
end

----------------------------------------------------------------
-- Initial Animation
----------------------------------------------------------------
window.Size = UDim2.fromOffset(1200, 660)
window.BackgroundTransparency = 0.05
tween(window, Theme.Slow, { Size = UDim2.fromOffset(1280, 720), BackgroundTransparency = 0 })

logTerminal("GameAnalyzer IDE v7.0 loaded successfully.", Theme.Success)
logTerminal("Environment: " .. Env.ExecutorName)
runScanners()