--[[
    ════════════════════════════════════════════════════════════════════
    ⚡ GameAnalyzer v7.0 — PRO UI FRAMEWORK EDITION
    ════════════════════════════════════════════════════════════════════
    Basado en una arquitectura modular: ThemeManager, AnimationManager,
    Componentes reutilizables, y Glassmorphism / Fluent Design.
    ════════════════════════════════════════════════════════════════════
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- ═══════════════════════════════════════════════════════════════════
-- 1. ENTORNO Y CAPACIDADES (ENV)
-- ═══════════════════════════════════════════════════════════════════
local Env = {
    ExecutorName = "Potassium",
    LocalPlayer = Players.LocalPlayer
}
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
    setclipboard = hasFn("setclipboard")
}

-- ═══════════════════════════════════════════════════════════════════
-- 2. THEME MANAGER
-- ═══════════════════════════════════════════════════════════════════
local ThemeManager = {
    CurrentTheme = "Dark",
    Themes = {
        Dark = {
            Background = Color3.fromRGB(10, 10, 11),
            Sidebar = Color3.fromRGB(15, 15, 17),
            Surface = Color3.fromRGB(20, 20, 23),
            SurfaceHover = Color3.fromRGB(28, 28, 32),
            SurfaceActive = Color3.fromRGB(35, 35, 40),
            Border = Color3.fromRGB(40, 40, 45),
            BorderLight = Color3.fromRGB(60, 60, 70),
            Text = Color3.fromRGB(240, 240, 245),
            TextSecondary = Color3.fromRGB(160, 160, 170),
            TextMuted = Color3.fromRGB(100, 100, 110),
            Accent = Color3.fromRGB(59, 130, 246), -- Blue
            Danger = Color3.fromRGB(239, 68, 68),
            Success = Color3.fromRGB(34, 197, 94),
        }
    },
    Fonts = {
        Title = Enum.Font.GothamBold,
        Body = Enum.Font.Gotham,
        Secondary = Enum.Font.GothamMedium,
        Code = Enum.Font.Code
    }
}
local T = ThemeManager.Themes[ThemeManager.CurrentTheme]
local F = ThemeManager.Fonts

-- ═══════════════════════════════════════════════════════════════════
-- 3. ICON MANAGER (Lucide-like vector assets)
-- ═══════════════════════════════════════════════════════════════════
local IconManager = {
    Icons = {
        Home = "rbxassetid://10723345518",
        Terminal = "rbxassetid://10723351989",
        Folder = "rbxassetid://10723344605",
        Search = "rbxassetid://10723351658",
        Settings = "rbxassetid://10723351786",
        User = "rbxassetid://10734913214",
        Close = "rbxassetid://10747384394",
        Menu = "rbxassetid://10723348639",
        Plus = "rbxassetid://10734900742",
        ChevronRight = "rbxassetid://10723342938",
        ChevronDown = "rbxassetid://10723342337",
        Check = "rbxassetid://10723341852",
        Alert = "rbxassetid://10723336712",
        Eye = "rbxassetid://10723344234"
    }
}

-- ═══════════════════════════════════════════════════════════════════
-- 4. ANIMATION MANAGER
-- ═══════════════════════════════════════════════════════════════════
local AnimationManager = {}
local DefaultInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local FastInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function AnimationManager.HoverEnter(obj, targetColor)
    TweenService:Create(obj, FastInfo, {BackgroundColor3 = targetColor}):Play()
end
function AnimationManager.HoverLeave(obj, targetColor)
    TweenService:Create(obj, FastInfo, {BackgroundColor3 = targetColor}):Play()
end
function AnimationManager.Press(obj)
    TweenService:Create(obj, FastInfo, {Size = UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset - 4, obj.Size.Y.Scale, obj.Size.Y.Offset - 2)}):Play()
end
function AnimationManager.Release(obj, originalSize)
    TweenService:Create(obj, FastInfo, {Size = originalSize}):Play()
end
function AnimationManager.FadeIn(obj, info)
    local originalTransparency = obj.BackgroundTransparency
    obj.BackgroundTransparency = 1
    TweenService:Create(obj, info or DefaultInfo, {BackgroundTransparency = originalTransparency}):Play()
    for _, child in ipairs(obj:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            local ot = child.TextTransparency
            child.TextTransparency = 1
            TweenService:Create(child, info or DefaultInfo, {TextTransparency = ot}):Play()
        elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
            local oi = child.ImageTransparency
            child.ImageTransparency = 1
            TweenService:Create(child, info or DefaultInfo, {ImageTransparency = oi}):Play()
        elseif child:IsA("UIStroke") then
            local os = child.Transparency
            child.Transparency = 1
            TweenService:Create(child, info or DefaultInfo, {Transparency = os}):Play()
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- 5. COMPONENT SYSTEM (UI)
-- ═══════════════════════════════════════════════════════════════════
local UI = {}

function UI.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

function UI.Stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Border
    s.Transparency = transparency or 0.6
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function UI.Padding(parent, all)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, all); p.PaddingBottom = UDim.new(0, all)
    p.PaddingLeft = UDim.new(0, all); p.PaddingRight = UDim.new(0, all)
    p.Parent = parent
    return p
end

-- Tooltips
function UI.AddTooltip(target, text)
    local tooltip = Instance.new("Frame")
    tooltip.Size = UDim2.new(0, 0, 0, 24)
    tooltip.AutomaticSize = Enum.AutomaticSize.X
    tooltip.BackgroundColor3 = T.Sidebar
    tooltip.Position = UDim2.new(1, 10, 0.5, -12)
    tooltip.ZIndex = 100
    tooltip.Visible = false
    UI.Corner(tooltip, 6)
    UI.Stroke(tooltip, T.BorderLight, 0.3)
    UI.Padding(tooltip, 4).PaddingLeft = UDim.new(0, 8)
    tooltip.Parent = target
    
    local label = Instance.new("TextLabel")
    label.Text = text; label.Font = F.Secondary; label.TextSize = 11; label.TextColor3 = T.Text; label.BackgroundTransparency = 1; label.Size = UDim2.new(1, 0, 1, 0); label.Parent = tooltip
    
    local enterTime
    target.MouseEnter:Connect(function()
        enterTime = tick()
        task.delay(0.4, function()
            if enterTime and tick() - enterTime >= 0.4 then tooltip.Visible = true; tooltip.BackgroundTransparency = 1; label.TextTransparency = 1; TweenService:Create(tooltip, DefaultInfo, {BackgroundTransparency = 0}):Play(); TweenService:Create(label, DefaultInfo, {TextTransparency = 0}):Play() end
        end)
    end)
    target.MouseLeave:Connect(function() enterTime = nil; tooltip.Visible = false end)
end

-- Reusable Button
function UI.Button(parent, text, iconId, callback)
    local btn = Instance.new("TextButton")
    btn.Text = ""
    btn.BackgroundColor3 = T.Surface
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.AutoButtonColor = false
    btn.Parent = parent
    UI.Corner(btn, 8)
    UI.Stroke(btn, T.Border, 0.5)

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 10)
    layout.Parent = btn

    UI.Padding(btn, 0).PaddingLeft = UDim.new(0, 12)

    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Image = iconId
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.BackgroundTransparency = 1
        icon.ImageColor3 = T.TextSecondary
        icon.Parent = btn
    end

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = F.Secondary
    label.TextSize = 13
    label.TextColor3 = T.Text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -26, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local originalSize = btn.Size
    btn.MouseEnter:Connect(function() AnimationManager.HoverEnter(btn, T.SurfaceHover) end)
    btn.MouseLeave:Connect(function() AnimationManager.HoverLeave(btn, T.Surface) end)
    btn.MouseButton1Down:Connect(function() AnimationManager.Press(btn) end)
    btn.MouseButton1Up:Connect(function() AnimationManager.Release(btn, originalSize) end)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)

    return btn
end

-- Toggle
function UI.Toggle(parent, text, defaultState, callback)
    local state = defaultState or false
    local btn = Instance.new("TextButton")
    btn.Text = ""
    btn.BackgroundColor3 = T.Surface
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.AutoButtonColor = false
    btn.Parent = parent
    UI.Corner(btn, 8)
    UI.Stroke(btn, T.Border, 0.5)
    
    local label = Instance.new("TextLabel")
    label.Text = text; label.Font = F.Secondary; label.TextSize = 13; label.TextColor3 = T.Text; label.BackgroundTransparency = 1; label.Size = UDim2.new(1, -60, 1, 0); label.Position = UDim2.new(0, 12, 0, 0); label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = btn
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -48, 0.5, -9)
    toggleBg.BackgroundColor3 = state and T.Accent or T.SurfaceActive
    UI.Corner(toggleBg, 9)
    UI.Stroke(toggleBg, T.BorderLight, 0.5)
    toggleBg.Parent = btn
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, state and 20 or 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.Corner(circle, 7)
    circle.Parent = toggleBg
    
    btn.MouseEnter:Connect(function() AnimationManager.HoverEnter(btn, T.SurfaceHover) end)
    btn.MouseLeave:Connect(function() AnimationManager.HoverLeave(btn, T.Surface) end)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBg, FastInfo, {BackgroundColor3 = state and T.Accent or T.SurfaceActive}):Play()
        TweenService:Create(circle, FastInfo, {Position = UDim2.new(0, state and 20 or 2, 0.5, -7)}):Play()
        if callback then callback(state) end
    end)
    return btn
end

-- Card Component (Info/Stat Card)
function UI.Card(parent, title, desc, iconId)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = T.Surface
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Parent = parent
    UI.Corner(card, 12)
    UI.Stroke(card, T.Border, 0.4)
    local pad = UI.Padding(card, 16)
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = card
    
    local header = Instance.new("Frame")
    header.BackgroundTransparency = 1; header.Size = UDim2.new(1, 0, 0, 20); header.LayoutOrder = 1; header.Parent = card
    
    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Image = iconId; icon.Size = UDim2.new(0, 18, 0, 18); icon.BackgroundTransparency = 1; icon.ImageColor3 = T.TextSecondary; icon.Parent = header
    end
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text = title; titleLbl.Font = F.Title; titleLbl.TextSize = 14; titleLbl.TextColor3 = T.Text; titleLbl.BackgroundTransparency = 1; titleLbl.Size = UDim2.new(1, iconId and -26 or 0, 1, 0); titleLbl.Position = UDim2.new(0, iconId and 24 or 0, 0, 0); titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = header
    
    if desc then
        local descLbl = Instance.new("TextLabel")
        descLbl.Text = desc; descLbl.Font = F.Body; descLbl.TextSize = 12; descLbl.TextColor3 = T.TextSecondary; descLbl.BackgroundTransparency = 1; descLbl.Size = UDim2.new(1, 0, 0, 0); descLbl.AutomaticSize = Enum.AutomaticSize.Y; descLbl.TextXAlignment = Enum.TextXAlignment.Left; descLbl.TextWrapped = true; descLbl.LayoutOrder = 2; descLbl.Parent = card
    end
    
    local content = Instance.new("Frame")
    content.BackgroundTransparency = 1; content.Size = UDim2.new(1, 0, 0, 0); content.AutomaticSize = Enum.AutomaticSize.Y; content.LayoutOrder = 3; content.Parent = card
    
    return card, content
end

-- Window System
function UI.Window(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "GameAnalyzerUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9999
    
    pcall(function()
        if CoreGui:FindFirstChild(gui.Name) then CoreGui[gui.Name]:Destroy() end
        local lp = Players.LocalPlayer
        if lp and lp:FindFirstChildOfClass("PlayerGui") and lp.PlayerGui:FindFirstChild(gui.Name) then lp.PlayerGui[gui.Name]:Destroy() end
        
        local parent = CoreGui
        if not pcall(function() return parent.Name end) then parent = lp:FindFirstChildOfClass("PlayerGui") end
        gui.Parent = parent
    end)
    
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Size = UDim2.new(0, 850, 0, 550)
    shadow.Position = UDim2.new(0.5, -425, 0.5, -275)
    shadow.BackgroundTransparency = 1
    shadow.Parent = gui
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(1, -60, 1, -60)
    main.Position = UDim2.new(0, 30, 0, 30)
    main.BackgroundColor3 = T.Background
    main.BackgroundTransparency = 0.1 -- Glass effect
    main.ClipsDescendants = true
    main.Parent = shadow
    UI.Corner(main, 12)
    UI.Stroke(main, T.BorderLight, 0.5)
    
    -- TopBar
    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1, 0, 0, 44)
    topbar.BackgroundTransparency = 1
    topbar.Parent = main
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text = title or "APP NAME"
    titleLbl.Font = F.Title; titleLbl.TextSize = 14; titleLbl.TextColor3 = T.Text; titleLbl.BackgroundTransparency = 1; titleLbl.Size = UDim2.new(1, 0, 1, 0); titleLbl.Position = UDim2.new(0, 16, 0, 0); titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = topbar
    
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Image = IconManager.Icons.Close; closeBtn.Size = UDim2.new(0, 16, 0, 16); closeBtn.Position = UDim2.new(1, -30, 0.5, -8); closeBtn.BackgroundTransparency = 1; closeBtn.ImageColor3 = T.TextSecondary; closeBtn.Parent = topbar
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, FastInfo, {ImageColor3 = T.Danger}):Play() end)
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, FastInfo, {ImageColor3 = T.TextSecondary}):Play() end)
    
    -- Draggable Logic
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = shadow.Position end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 200, 1, -44)
    sidebar.Position = UDim2.new(0, 0, 0, 44)
    sidebar.BackgroundColor3 = T.Sidebar
    sidebar.BackgroundTransparency = 0.3
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    
    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 4)
    sideLayout.Parent = sidebar
    UI.Padding(sidebar, 12)
    
    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -200, 1, -44)
    contentArea.Position = UDim2.new(0, 200, 0, 44)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main
    UI.Padding(contentArea, 16)
    
    AnimationManager.FadeIn(shadow)
    
    local self = {
        Tabs = {}, ActiveTab = nil,
        Container = contentArea,
        Sidebar = sidebar
    }
    
    function self:AddTab(name, iconId)
        local tabData = { Name = name, Frames = {} }
        
        -- Sidebar Button
        local sbtn = Instance.new("TextButton")
        sbtn.Text = ""; sbtn.Size = UDim2.new(1, 0, 0, 34); sbtn.BackgroundColor3 = T.Sidebar; sbtn.BackgroundTransparency = 1; sbtn.AutoButtonColor = false; sbtn.Parent = self.Sidebar; UI.Corner(sbtn, 6)
        
        if iconId then
            local img = Instance.new("ImageLabel"); img.Image = iconId; img.Size = UDim2.new(0, 16, 0, 16); img.Position = UDim2.new(0, 12, 0.5, -8); img.BackgroundTransparency = 1; img.ImageColor3 = T.TextSecondary; img.Parent = sbtn
            tabData.IconImg = img
        end
        local lbl = Instance.new("TextLabel"); lbl.Text = name; lbl.Font = F.Secondary; lbl.TextSize = 13; lbl.TextColor3 = T.TextSecondary; lbl.Size = UDim2.new(1, -40, 1, 0); lbl.Position = UDim2.new(0, 36, 0, 0); lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = sbtn
        tabData.Label = lbl
        
        -- Page Frame
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = T.BorderLight; page.Visible = false; page.Parent = self.Container
        local pl = Instance.new("UIListLayout"); pl.Padding = UDim.new(0, 12); pl.Parent = page
        
        -- Title Header
        local head = Instance.new("TextLabel"); head.Text = name; head.Font = F.Title; head.TextSize = 20; head.TextColor3 = T.Text; head.Size = UDim2.new(1, 0, 0, 40); head.BackgroundTransparency = 1; head.TextXAlignment = Enum.TextXAlignment.Left; head.Parent = page
        
        tabData.Page = page
        
        sbtn.MouseEnter:Connect(function() if self.ActiveTab ~= tabData then AnimationManager.HoverEnter(sbtn, T.Surface) end end)
        sbtn.MouseLeave:Connect(function() if self.ActiveTab ~= tabData then TweenService:Create(sbtn, FastInfo, {BackgroundTransparency = 1, BackgroundColor3 = T.Sidebar}):Play() end end)
        sbtn.MouseButton1Click:Connect(function() self:SelectTab(tabData) end)
        
        table.insert(self.Tabs, tabData)
        if not self.ActiveTab then self:SelectTab(tabData) end
        
        return page
    end
    
    function self:SelectTab(tabData)
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Label, FastInfo, {TextColor3 = T.TextSecondary}):Play()
            if t.IconImg then TweenService:Create(t.IconImg, FastInfo, {ImageColor3 = T.TextSecondary}):Play() end
            t.Label.Parent.BackgroundTransparency = 1
        end
        tabData.Page.Visible = true
        AnimationManager.FadeIn(tabData.Page, FastInfo)
        TweenService:Create(tabData.Label, FastInfo, {TextColor3 = T.Text}):Play()
        if tabData.IconImg then TweenService:Create(tabData.IconImg, FastInfo, {ImageColor3 = T.Text}):Play() end
        TweenService:Create(tabData.Label.Parent, FastInfo, {BackgroundTransparency = 0, BackgroundColor3 = T.SurfaceActive}):Play()
        self.ActiveTab = tabData
    end
    
    return self
end

-- ═══════════════════════════════════════════════════════════════════
-- 6. APLICACIÓN PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════
local function Launch()
    local win = UI.Window("GameAnalyzer 7.0 Pro")
    
    -- Home Tab
    local homePage = win:AddTab("Dashboard", IconManager.Icons.Home)
    local homeCard, hcContent = UI.Card(homePage, "Welcome to GameAnalyzer", "Professional Roblox Analysis Framework.")
    UI.Button(hcContent, "Scan Environment", IconManager.Icons.Search, function() print("Scanning...") end)
    UI.Button(hcContent, "Run Diagnostics", IconManager.Icons.Terminal, function() print("Diag...") end)
    
    -- Remotes Tab
    local remotesPage = win:AddTab("Remote Spy", IconManager.Icons.Alert)
    local rsCard, rsContent = UI.Card(remotesPage, "Network Auditor", "Intercept and log RemoteEvents and RemoteFunctions.")
    UI.Toggle(rsContent, "Enable RemoteSpy", false, function(state) print("Spy: ", state) end)
    UI.Toggle(rsContent, "Block Telemetry", true, function(state) print("Block: ", state) end)
    
    -- Scripts Explorer
    local scriptsPage = win:AddTab("Explorer", IconManager.Icons.Folder)
    local seCard, seContent = UI.Card(scriptsPage, "Environment Scripts", "View LocalScripts and ModuleScripts.")
    UI.Button(seContent, "Dump Modules", IconManager.Icons.Search, function() print("Dumping...") end)
    
    -- Settings
    local settingsPage = win:AddTab("Settings", IconManager.Icons.Settings)
    local stCard, stContent = UI.Card(settingsPage, "Preferences", "Customize the framework behavior.")
    UI.Toggle(stContent, "Auto-Save Logs", true)
    UI.Toggle(stContent, "Dark Mode", true)
end

Launch()