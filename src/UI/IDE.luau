-- UI/IDE.luau
-- GameAnalyzer v6.0 IDE Edition — Main IDE Window Layout & Tabs Engine

local Env           = require(script.Parent.Parent.Core.Env)
local Config        = require(script.Parent.Parent.Core.Config)
local Theme         = require(script.Parent.Parent.UI.Theme)
local Components    = require(script.Parent.Parent.UI.Components)
local Scanner       = require(script.Parent.Parent.Services.Scanner)
local RemoteSpy     = require(script.Parent.Parent.Services.RemoteSpy)
local ModuleInspector = require(script.Parent.Parent.Services.ModuleInspector)
local MemoryScanner = require(script.Parent.Parent.Services.MemoryScanner)
local Vulnerability = require(script.Parent.Parent.Services.Vulnerability)
local Exporter      = require(script.Parent.Parent.Services.Exporter)

local IDE = {}
local UserInputService = Env.Services.UserInputService
local TweenService     = Env.Services.TweenService

function IDE.init()
    -- Create ScreenGui inside CoreGui or PlayerGui
    local parentGui = nil
    pcall(function()
        if Env.Services.CoreGui then
            parentGui = Env.Services.CoreGui
        end
    end)
    if not parentGui then
        parentGui = Env.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Remove existing instance if reloading
    if parentGui:FindFirstChild("GameAnalyzerIDE") then
        parentGui.GameAnalyzerIDE:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GameAnalyzerIDE"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Window Container (Main Draggable Frame)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 840, 0, 540)
    mainFrame.Position = UDim2.new(0.5, -420, 0.5, -270)
    mainFrame.BackgroundColor3 = Theme.Colors.BgMain
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    Components.createCorner(mainFrame, Theme.Corners.Window)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.Colors.Border
    mainStroke.Thickness = 1.5
    mainStroke.Parent = mainFrame

    -- Make Draggable by Header
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

    -- Header Bar
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight)
    header.BackgroundColor3 = Theme.Colors.BgHeader
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    Components.createPadding(header, 0, 0, 14, 14)

    -- Header Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "⚡ GameAnalyzer " .. Config.Version .. " — " .. Env.ExecutorName
    titleLabel.Font = Theme.Fonts.Bold
    titleLabel.TextSize = Theme.Sizes.TitleText
    titleLabel.TextColor3 = Theme.Colors.TextPrimary
    titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = header

    -- Minimize & Close Buttons
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 60, 1, 0)
    controlsFrame.Position = UDim2.new(1, -60, 0, 0)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Font = Theme.Fonts.Bold
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Theme.Colors.TextSecondary
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -24, 0.5, -12)
    closeBtn.BackgroundColor3 = Theme.Colors.BgCard
    closeBtn.BorderSizePixel = 0
    Components.createCorner(closeBtn, Theme.Corners.Badge)
    closeBtn.Parent = controlsFrame

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    -- Dragging Logic
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Sidebar Layout
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    sidebar.Position = UDim2.new(0, 0, 0, Theme.Sizes.HeaderHeight)
    sidebar.BackgroundColor3 = Theme.Colors.BgSidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    Components.createPadding(sidebar, 10, 10, 8, 8)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebar

    -- Viewport Container (Tab Content Area)
    local viewport = Instance.new("Frame")
    viewport.Name = "Viewport"
    viewport.Size = UDim2.new(1, -Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    viewport.Position = UDim2.new(0, Theme.Sizes.SidebarWidth, 0, Theme.Sizes.HeaderHeight)
    viewport.BackgroundColor3 = Theme.Colors.BgMain
    viewport.BorderSizePixel = 0
    viewport.Parent = mainFrame

    Components.createPadding(viewport, 12, 12, 14, 14)

    -- Bottom Status Bar
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.StatusBarHeight)
    statusBar.Position = UDim2.new(0, 0, 1, -Theme.Sizes.StatusBarHeight)
    statusBar.BackgroundColor3 = Theme.Colors.BgSidebar
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame

    Components.createPadding(statusBar, 0, 0, 12, 12)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = string.format("PlaceId: %d | Exec: %s | Toggle: [RightControl]", game.PlaceId, Env.ExecutorName)
    statusLabel.Font = Theme.Fonts.Main
    statusLabel.TextSize = Theme.Sizes.BodyText
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.BackgroundTransparency = 1
    statusLabel.Parent = statusBar

    -- Tab System
    local tabs = {
        { Id = "Dashboard", Icon = "📊", Name = "Dashboard" },
        { Id = "Remotes",   Icon = "⚡", Name = "Remotes & Spy" },
        { Id = "Modules",   Icon = "📦", Name = "Modules" },
        { Id = "Explorer",  Icon = "🌳", Name = "Explorer" },
        { Id = "Memory",    Icon = "🧠", Name = "GC & Memory" },
        { Id = "Audit",     Icon = "🛡️", Name = "Security Audit" },
        { Id = "Exporter",  Icon = "💾", Name = "Exporter" },
    }

    local activeTab = nil
    local activeViewFrame = nil
    local tabButtons = {}

    local function switchTab(tabId)
        if activeTab == tabId then return end
        activeTab = tabId

        -- Update button visual states
        for id, btn in pairs(tabButtons) do
            if id == tabId then
                btn.BackgroundColor3 = Theme.Colors.Accent
                btn.TextColor3 = Theme.Colors.TextPrimary
            else
                btn.BackgroundColor3 = Theme.Colors.BgSidebar
                btn.TextColor3 = Theme.Colors.TextSecondary
            end
        end

        -- Clear current view
        if activeViewFrame then
            activeViewFrame:Destroy()
        end

        -- Build new view
        local viewFrame = Instance.new("Frame")
        viewFrame.Size = UDim2.new(1, 0, 1, 0)
        viewFrame.BackgroundTransparency = 1
        viewFrame.Parent = viewport
        activeViewFrame = viewFrame

        if tabId == "Dashboard" then
            IDE.renderDashboard(viewFrame)
        elseif tabId == "Remotes" then
            IDE.renderRemotesView(viewFrame)
        elseif tabId == "Modules" then
            IDE.renderModulesView(viewFrame)
        elseif tabId == "Explorer" then
            IDE.renderExplorerView(viewFrame)
        elseif tabId == "Memory" then
            IDE.renderMemoryView(viewFrame)
        elseif tabId == "Audit" then
            IDE.renderAuditView(viewFrame)
        elseif tabId == "Exporter" then
            IDE.renderExporterView(viewFrame)
        end
    end

    -- Create Tab Buttons in Sidebar
    for _, t in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Text = "  " .. t.Icon .. "  " .. t.Name
        btn.Font = Theme.Fonts.Bold
        btn.TextSize = Theme.Sizes.BodyText
        btn.TextColor3 = Theme.Colors.TextSecondary
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Theme.Colors.BgSidebar
        btn.BorderSizePixel = 0
        btn.Size = UDim2.new(1, 0, 0, 34)

        Components.createCorner(btn, Theme.Corners.Button)
        Components.createPadding(btn, 0, 0, 8, 8)

        btn.MouseButton1Click:Connect(function()
            switchTab(t.Id)
        end)

        tabButtons[t.Id] = btn
        btn.Parent = sidebar
    end

    -- Toggle visibility hotkey
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Config.ToggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    screenGui.Parent = parentGui
    switchTab("Dashboard")
    Components.createNotificationToast(screenGui, "GameAnalyzer v6.0 IDE", "Loaded successfully! Press [RightControl] to toggle GUI.", Theme.Colors.Accent)
end

-- Render Tab Views
function IDE.renderDashboard(parent)
    local scanData = Scanner.scanRemotes()
    local vulnData = Vulnerability.analyze()

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 480)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.Colors.Accent
    scroll.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.Parent = scroll

    -- Quick Stats Row
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, 0, 0, 90)
    statsFrame.BackgroundTransparency = 1
    statsFrame.Parent = scroll

    local statsLayout = Instance.new("UIListLayout")
    statsLayout.FillDirection = Enum.FillDirection.Horizontal
    statsLayout.Padding = UDim.new(0, 10)
    statsLayout.Parent = statsFrame

    local function createStatCard(title, value, color)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(0.24, 0, 1, 0)
        card.BackgroundColor3 = Theme.Colors.BgCard
        card.BorderSizePixel = 0
        Components.createCorner(card, Theme.Corners.Card)
        Components.createPadding(card, 10, 10, 12, 12)

        local tLabel = Instance.new("TextLabel")
        tLabel.Text = title
        tLabel.Font = Theme.Fonts.Bold
        tLabel.TextSize = Theme.Sizes.BadgeText
        tLabel.TextColor3 = Theme.Colors.TextMuted
        tLabel.Size = UDim2.new(1, 0, 0, 14)
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.BackgroundTransparency = 1
        tLabel.Parent = card

        local vLabel = Instance.new("TextLabel")
        vLabel.Text = tostring(value)
        vLabel.Font = Theme.Fonts.Bold
        vLabel.TextSize = 22
        vLabel.TextColor3 = color or Theme.Colors.TextPrimary
        vLabel.Size = UDim2.new(1, 0, 0, 36)
        vLabel.Position = UDim2.new(0, 0, 0, 22)
        vLabel.TextXAlignment = Enum.TextXAlignment.Left
        vLabel.BackgroundTransparency = 1
        vLabel.Parent = card

        card.Parent = statsFrame
    end

    createStatCard("TOTAL REMOTES", scanData.TotalCount, Theme.Colors.Accent)
    createStatCard("STAFF REMOTES", #scanData.Categorized.STAFF, Theme.Colors.Purple)
    createStatCard("SECURITY RISK", vulnData.RiskLevel, vulnData.RiskLevel == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Success)
    createStatCard("EXECUTOR", Env.ExecutorName, Theme.Colors.Info)

    -- Meta Card
    local metaCard = Instance.new("Frame")
    metaCard.Size = UDim2.new(1, 0, 0, 180)
    metaCard.BackgroundColor3 = Theme.Colors.BgCard
    metaCard.BorderSizePixel = 0
    Components.createCorner(metaCard, Theme.Corners.Card)
    Components.createPadding(metaCard, 12, 12, 14, 14)
    metaCard.Parent = scroll

    local metaTitle = Instance.new("TextLabel")
    metaTitle.Text = "📌 Place & Session Details"
    metaTitle.Font = Theme.Fonts.Bold
    metaTitle.TextSize = Theme.Sizes.SubText
    metaTitle.TextColor3 = Theme.Colors.Accent
    metaTitle.Size = UDim2.new(1, 0, 0, 20)
    metaTitle.TextXAlignment = Enum.TextXAlignment.Left
    metaTitle.BackgroundTransparency = 1
    metaTitle.Parent = metaCard

    local metaText = string.format([[
• Place ID: %d
• Place Name: %s
• Game ID: %d
• Job ID: %s
• Creator ID: %d
• Players Online: %d / %s]],
        game.PlaceId,
        game.Name,
        game.GameId,
        game.JobId ~= "" and game.JobId or "Single Player / Studio",
        game.CreatorId,
        #Env.Services.Players:GetPlayers(),
        tostring(Env.Services.Players.MaxPlayers)
    )

    local metaLabel = Instance.new("TextLabel")
    metaLabel.Text = metaText
    metaLabel.Font = Theme.Fonts.Code
    metaLabel.TextSize = Theme.Sizes.BodyText
    metaLabel.TextColor3 = Theme.Colors.TextSecondary
    metaLabel.Size = UDim2.new(1, 0, 0, 120)
    metaLabel.Position = UDim2.new(0, 0, 0, 26)
    metaLabel.TextXAlignment = Enum.TextXAlignment.Left
    metaLabel.TextYAlignment = Enum.TextYAlignment.Top
    metaLabel.BackgroundTransparency = 1
    metaLabel.Parent = metaCard
end

function IDE.renderRemotesView(parent)
    local scanResults = Scanner.scanRemotes()

    local topFrame = Instance.new("Frame")
    topFrame.Size = UDim2.new(1, 0, 0, 36)
    topFrame.BackgroundTransparency = 1
    topFrame.Parent = parent

    local spyBtn = Components.createButton("⚡ Toggle RemoteSpy Hook", function()
        if RemoteSpy.Enabled then
            RemoteSpy.stop()
            Components.createNotificationToast(parent.Parent, "RemoteSpy", "Hook disabled.", Theme.Colors.Warning)
        else
            local ok, err = RemoteSpy.start()
            if ok then
                Components.createNotificationToast(parent.Parent, "RemoteSpy", "Hook enabled (__namecall intercepting live calls)!", Theme.Colors.Success)
            else
                Components.createNotificationToast(parent.Parent, "RemoteSpy Error", tostring(err), Theme.Colors.Danger)
            end
        end
    end, topFrame, Theme.Colors.Accent)
    spyBtn.Size = UDim2.new(0, 200, 1, 0)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -44)
    scroll.Position = UDim2.new(0, 0, 0, 44)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroll

    for _, r in ipairs(scanResults.RemoteEvents) do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 38)
        card.BackgroundColor3 = Theme.Colors.BgCard
        card.BorderSizePixel = 0
        Components.createCorner(card, Theme.Corners.Badge)
        Components.createPadding(card, 0, 0, 10, 10)

        local catColor = Config.CategoryColors[r.Category] or Theme.Colors.TextMuted
        Components.createBadge(r.Category, catColor, card).Position = UDim2.new(0, 0, 0.5, -9)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = r.FullName
        nameLabel.Font = Theme.Fonts.Code
        nameLabel.TextSize = Theme.Sizes.BodyText
        nameLabel.TextColor3 = Theme.Colors.TextPrimary
        nameLabel.Size = UDim2.new(0.65, 0, 1, 0)
        nameLabel.Position = UDim2.new(0, 110, 0, 0)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = card

        local copyBtn = Components.createButton("Copy Code", function()
            local snippet = string.format("game:GetService(%q).%s:FireServer()", r.Instance.Parent.Name, r.Name)
            Exporter.copyToClipboard(snippet)
            Components.createNotificationToast(parent.Parent, "Copied Snippet", r.Name, Theme.Colors.Success)
        end, card)
        copyBtn.Size = UDim2.new(0, 90, 0, 24)
        copyBtn.Position = UDim2.new(1, -90, 0.5, -12)

        card.Parent = scroll
    end
end

function IDE.renderModulesView(parent)
    local modules = Scanner.scanModules()
    local codeViewerContainer = Instance.new("Frame")
    codeViewerContainer.Size = UDim2.new(1, 0, 1, 0)
    codeViewerContainer.BackgroundTransparency = 1
    codeViewerContainer.Parent = parent

    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(0.38, 0, 1, 0)
    listScroll.BackgroundTransparency = 1
    listScroll.ScrollBarThickness = 4
    listScroll.Parent = codeViewerContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = listScroll

    local viewerFrame = Instance.new("Frame")
    viewerFrame.Size = UDim2.new(0.6, 0, 1, 0)
    viewerFrame.Position = UDim2.new(0.4, 0, 0, 0)
    viewerFrame.BackgroundColor3 = Theme.Colors.BgCode
    viewerFrame.Parent = codeViewerContainer

    local codeBox = Components.createCodeViewer("-- Select a ModuleScript to inspect or decompile source code.", viewerFrame)

    for _, m in ipairs(modules) do
        local btn = Instance.new("TextButton")
        btn.Text = "  📦 " .. m.Name
        btn.Font = Theme.Fonts.Code
        btn.TextSize = Theme.Sizes.BodyText
        btn.TextColor3 = Theme.Colors.TextSecondary
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Theme.Colors.BgCard
        btn.Size = UDim2.new(1, 0, 0, 30)
        Components.createCorner(btn, Theme.Corners.Badge)

        btn.MouseButton1Click:Connect(function()
            local code = ModuleInspector.decompileScript(m.Instance)
            codeBox:Destroy()
            codeBox = Components.createCodeViewer(code, viewerFrame)
        end)

        btn.Parent = listScroll
    end
end

function IDE.renderExplorerView(parent)
    local label = Instance.new("TextLabel")
    label.Text = "🌳 Instance Explorer View ready for hierarchy browsing."
    label.Font = Theme.Fonts.Main
    label.TextSize = Theme.Sizes.SubText
    label.TextColor3 = Theme.Colors.TextMuted
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Parent = parent
end

function IDE.renderMemoryView(parent)
    local nilData = MemoryScanner.scanNilInstances()
    local gcData  = MemoryScanner.scanGC()

    local label = Instance.new("TextLabel")
    label.Text = string.format("🧠 GC Functions: %d | GC Tables: %d | Nil Instances: %d", gcData.FunctionsCount, gcData.TablesCount, nilData.Total)
    label.Font = Theme.Fonts.Code
    label.TextSize = Theme.Sizes.SubText
    label.TextColor3 = Theme.Colors.Accent
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Parent = parent
end

function IDE.renderAuditView(parent)
    local vuln = Vulnerability.analyze()
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = scroll

    for idx, f in ipairs(vuln.Findings) do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 84)
        card.BackgroundColor3 = Theme.Colors.BgCard
        Components.createCorner(card, Theme.Corners.Card)
        Components.createPadding(card, 8, 8, 12, 12)

        local tLabel = Instance.new("TextLabel")
        tLabel.Text = "[" .. f.Severity .. "] " .. f.Title
        tLabel.Font = Theme.Fonts.Bold
        tLabel.TextSize = Theme.Sizes.SubText
        tLabel.TextColor3 = f.Severity == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Warning
        tLabel.Size = UDim2.new(1, 0, 0, 18)
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.BackgroundTransparency = 1
        tLabel.Parent = card

        local dLabel = Instance.new("TextLabel")
        dLabel.Text = f.Description
        dLabel.Font = Theme.Fonts.Main
        dLabel.TextSize = Theme.Sizes.BodyText
        dLabel.TextColor3 = Theme.Colors.TextSecondary
        dLabel.Size = UDim2.new(1, 0, 0, 40)
        dLabel.Position = UDim2.new(0, 0, 0, 22)
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.TextWrapped = true
        dLabel.BackgroundTransparency = 1
        dLabel.Parent = card

        card.Parent = scroll
    end
end

function IDE.renderExporterView(parent)
    local saveBtn = Components.createButton("💾 Save Dump to File (/ReverseKit)", function()
        local scan = Scanner.scanRemotes()
        local vuln = Vulnerability.analyze()
        local txt  = Exporter.generateTextDump(scan, vuln)
        local ok, path = Exporter.saveFile("Place_" .. game.PlaceId .. "_Dump.txt", txt)

        if ok then
            Components.createNotificationToast(parent.Parent, "Dump Saved", path, Theme.Colors.Success)
        else
            Components.createNotificationToast(parent.Parent, "Error Saving", path, Theme.Colors.Danger)
        end
    end, parent, Theme.Colors.Accent)
    saveBtn.Size = UDim2.new(0, 260, 0, 42)
    saveBtn.Position = UDim2.new(0.5, -130, 0.4, 0)
end

return IDE
