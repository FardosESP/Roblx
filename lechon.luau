--[[
    ════════════════════════════════════════════════════════════════════
    ⚡ GameAnalyzer v6.0 — ULTRA IDE EDITION (Glassmorphism & Gradients)
    ════════════════════════════════════════════════════════════════════
    Diseñado para Potassium & Executors Luau Modernos.
    Interfaz de Usuario Estilo IDE Next-Gen (Gradients, Glass, Neon Glows).
    100% Autocontenido — ¡Cero dependencias!
    ════════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════
-- 1. ENTORNO Y CAPACIDADES (ENV)
-- ═══════════════════════════════════════════════════════════════════
local Env = {}
Env.Services = {
    Players            = game:GetService("Players"),
    ReplicatedStorage  = game:GetService("ReplicatedStorage"),
    ReplicatedFirst    = game:GetService("ReplicatedFirst"),
    StarterGui         = game:GetService("StarterGui"),
    StarterPlayer      = game:GetService("StarterPlayer"),
    Teams              = game:GetService("Teams"),
    Workspace          = game:GetService("Workspace"),
    HttpService        = game:GetService("HttpService"),
    TweenService       = game:GetService("TweenService"),
    UserInputService   = game:GetService("UserInputService"),
    RunService         = game:GetService("RunService"),
    CoreGui            = game:GetService("CoreGui"),
}
Env.LocalPlayer = Env.Services.Players.LocalPlayer

Env.ExecutorName = "Potassium"
pcall(function()
    if type(identifyexecutor) == "function" then Env.ExecutorName = identifyexecutor()
    elseif type(getexecutorname) == "function" then Env.ExecutorName = getexecutorname() end
end)

local function hasFn(name)
    local ok1, t1 = pcall(function() return type(_G[name]) end)
    if ok1 and t1 == "function" then return true end
    if getfenv then
        local ok2, t2 = pcall(function() return type(getfenv(0)[name]) end)
        if ok2 and t2 == "function" then return true end
    end
    if getgenv then
        local ok3, t3 = pcall(function() return type(getgenv()[name]) end)
        if ok3 and t3 == "function" then return true end
    end
    return false
end

Env.CAPS = {
    writefile            = hasFn("writefile"),
    appendfile           = hasFn("appendfile"),
    readfile             = hasFn("readfile"),
    setclipboard         = hasFn("setclipboard"),
    hookmetamethod       = hasFn("hookmetamethod"),
    getrawmetatable      = hasFn("getrawmetatable"),
    setreadonly          = hasFn("setreadonly"),
    getnamecallmethod    = hasFn("getnamecallmethod"),
    newcclosure          = hasFn("newcclosure"),
    decompile            = hasFn("decompile"),
    getgc                = hasFn("getgc"),
    getnilinstances      = hasFn("getnilinstances"),
}

function Env.serialize(v, depth)
    depth = depth or 0
    if depth > 3 then return "..." end
    local t = typeof(v)
    if t == "string"    then return '"' .. string.sub(v, 1, 100) .. '"' end
    if t == "number"    then return tostring(v) end
    if t == "boolean"   then return tostring(v) end
    if t == "nil"       then return "nil" end
    if t == "Vector3"   then return string.format("V3(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z) end
    if t == "Vector2"   then return string.format("V2(%.2f, %.2f)", v.X, v.Y) end
    if t == "CFrame"    then return string.format("CF(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z) end
    if t == "Color3"    then return string.format("RGB(%d, %d, %d)", math.round(v.R*255), math.round(v.G*255), math.round(v.B*255)) end
    if t == "Instance"  then return v:GetFullName() end
    if t == "table" then
        local parts, count = {}, 0
        for k, val in pairs(v) do
            if count >= 8 then table.insert(parts, "..."); break end
            table.insert(parts, tostring(k) .. " = " .. Env.serialize(val, depth + 1))
            count = count + 1
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    end
    return t
end

-- ═══════════════════════════════════════════════════════════════════
-- 2. PALETA DE COLOR Y GLASSMORPHISM (ULTRA MODERN CSS/WEB STYLE)
-- ═══════════════════════════════════════════════════════════════════
local Config = {
    Version = "v6.0 Glass IDE Pro",
    SubFolder = "ReverseKit",
    ToggleKey = Enum.KeyCode.RightControl,
}

Config.Theme = {
    BgWindow      = Color3.fromRGB(15, 17, 23),       -- Deep Glass Dark
    BgSidebar     = Color3.fromRGB(11, 13, 18),       -- Obsidian Sidebar
    BgHeader      = Color3.fromRGB(20, 23, 31),       -- Header Bar
    BgCard        = Color3.fromRGB(24, 28, 38),       -- Card Panel
    BgCardHover   = Color3.fromRGB(34, 40, 54),       -- Hover Accent
    BgCode        = Color3.fromRGB(10, 12, 16),       -- Editor Background

    -- Neon Accent Gradients (Amber / Gold / Cyan / Purple Glows)
    Accent        = Color3.fromRGB(245, 158, 11),     -- Amber Glow #f59e0b
    AccentGradient1 = Color3.fromRGB(245, 158, 11),   -- Gold
    AccentGradient2 = Color3.fromRGB(217, 119, 6),    -- Amber
    PurpleGradient1 = Color3.fromRGB(168, 85, 247),   -- Purple Glow
    PurpleGradient2 = Color3.fromRGB(126, 34, 206),

    Success       = Color3.fromRGB(34, 197, 94),
    Warning       = Color3.fromRGB(245, 158, 11),
    Danger        = Color3.fromRGB(239, 68, 68),
    Info          = Color3.fromRGB(59, 130, 246),
    Cyan          = Color3.fromRGB(6, 182, 212),

    TextPrimary   = Color3.fromRGB(248, 250, 252),
    TextSecondary = Color3.fromRGB(148, 163, 184),
    TextMuted     = Color3.fromRGB(100, 116, 139),
    TextCode      = Color3.fromRGB(226, 232, 240),

    Border        = Color3.fromRGB(45, 55, 72),
    BorderGlow    = Color3.fromRGB(245, 158, 11),
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
    OTHER     = Color3.fromRGB(100, 116, 139),
}

local Theme = {
    Colors = Config.Theme,
    Fonts = { Main = Enum.Font.BuilderSans, Bold = Enum.Font.BuilderSansBold, Code = Enum.Font.Code },
    Sizes = { TitleText = 15, SubText = 13, BodyText = 12, CodeText = 12, BadgeText = 10, SidebarWidth = 210, HeaderHeight = 46, StatusBarHeight = 28 },
    Corners = { Window = UDim.new(0, 12), Card = UDim.new(0, 8), Button = UDim.new(0, 6), Badge = UDim.new(0, 4) },
}

-- ═══════════════════════════════════════════════════════════════════
-- 3. ESCÁNERES Y SERVICIOS
-- ═══════════════════════════════════════════════════════════════════
local Scanner = {}
Scanner.RemoteCategories = {
    DAMAGE    = {"damage","hit","hurt","kill","shoot","attack","combat","bullet","projectile","dealdamage","applydamage","onhit","impact"},
    FARM      = {"collect","pickup","harvest","farm","gather","haul","away","offline","idle","petal","orb","claimreward","claimedrop"},
    ECONOMY   = {"buy","purchase","shop","pay","spend","sell","trade","money","cash","coin","reward","give","transfer","checkout","unlock","unbox"},
    PLAYER    = {"playerdata","syncdata","fetchstate","loadstate","data","profile","sync","character","stats","snapshot"},
    MOVEMENT  = {"teleport","warp","tp","jump","dash","sprint","velocity","moveto","setposition","requestteleport"},
    VEHICLE   = {"vehicle","chassis","drive","engine","race","getvehicle","vehicleevent","vehiclestats"},
    SKIN      = {"skin","cosmetic","equip","loadout","inventory","wear","setcosmetic","equippart"},
    QUEST     = {"quest","mission","objective","complete","finish","daily","challenge","bounty"},
    LOBBY     = {"lobby","mode","round","match","phase","gamestate","startmatch","joinqueue"},
    STAFF     = {"staff","verdict","grantself","grantpet","givemoney","setmoney","wipeprofil","banwave","kickplayer","voldexadmin","apexdashboard"},
    CRAFT     = {"craft","blend","mix","combine","brew","forge","merge","fuse"},
    ANTICHEAT = {"anticheat","exploitdetect","cheatdetect","reportcheat","integrity"},
}

function Scanner.categorizeRemote(instance)
    local fullPath = instance:GetFullName():lower()
    local name     = instance.Name:lower()
    if fullPath:find("voldexadmin", 1, true) or fullPath:find("apexdashboard", 1, true) then return "STAFF" end
    if fullPath:find("integritycheck", 1, true) then return "ANTICHEAT" end
    for cat, patterns in pairs(Scanner.RemoteCategories) do
        for _, pat in ipairs(patterns) do
            if name:find(pat, 1, true) or fullPath:find(pat, 1, true) then return cat end
        end
    end
    return "OTHER"
end

function Scanner.scanRemotes()
    local results = { RemoteEvents = {}, RemoteFunctions = {}, Categorized = {}, TotalCount = 0 }
    for cat, _ in pairs(Scanner.RemoteCategories) do results.Categorized[cat] = {} end
    results.Categorized["OTHER"] = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") or v:IsA("UnreliableRemoteEvent") then
            local category = Scanner.categorizeRemote(v)
            local entry = { Instance = v, Name = v.Name, FullName = v:GetFullName(), ClassName = v.ClassName, Category = category }
            if v:IsA("RemoteEvent") then table.insert(results.RemoteEvents, entry)
            elseif v:IsA("RemoteFunction") then table.insert(results.RemoteFunctions, entry) end
            table.insert(results.Categorized[category], entry)
            results.TotalCount = results.TotalCount + 1
        end
    end
    return results
end

function Scanner.scanModules()
    local modules = {}
    for _, v in ipairs(Env.Services.ReplicatedStorage:GetDescendants()) do
        if v:IsA("ModuleScript") then
            table.insert(modules, { Instance = v, Name = v.Name, FullName = v:GetFullName() })
        end
    end
    return modules
end

function Scanner.scanPlayerData()
    local data = { Leaderstats = {}, Attributes = {}, Character = {} }
    local lp = Env.LocalPlayer
    if not lp then return data end
    local ls = lp:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            local ok, val = pcall(function() return child.Value end)
            table.insert(data.Leaderstats, { Name = child.Name, Value = ok and val or "N/A" })
        end
    end
    for k, v in pairs(lp:GetAttributes()) do
        table.insert(data.Attributes, { Name = k, Value = Env.serialize(v) })
    end
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            data.Character.WalkSpeed = hum.WalkSpeed
            data.Character.JumpPower = hum.JumpPower
            data.Character.Health = hum.Health
            data.Character.MaxHealth = hum.MaxHealth
        end
    end
    return data
end

-- RemoteSpy Service
local RemoteSpy = { Enabled = false, Logs = {}, MaxLogs = 150 }
local rawNamecall = nil

function RemoteSpy.logCall(remote, method, args)
    local entry = { Time = os.date("%H:%M:%S"), Remote = remote, RemoteName = remote.Name, RemotePath = remote:GetFullName(), ClassName = remote.ClassName, Method = method, Args = args, SerializedArgs = Env.serialize(args) }
    table.insert(RemoteSpy.Logs, 1, entry)
    if #RemoteSpy.Logs > RemoteSpy.MaxLogs then table.remove(RemoteSpy.Logs) end
end

function RemoteSpy.start()
    if RemoteSpy.Enabled or not Env.CAPS.hookmetamethod or not Env.CAPS.getnamecallmethod then return false end
    RemoteSpy.Enabled = true
    local grm = getrawmetatable(game)
    if not grm then return false end
    if setreadonly then setreadonly(grm, false) end
    rawNamecall = grm.__namecall
    grm.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if RemoteSpy.Enabled and typeof(self) == "Instance" then
            if (method == "FireServer" or method == "fireServer") and self:IsA("RemoteEvent") then
                RemoteSpy.logCall(self, "FireServer", {...})
            elseif (method == "InvokeServer" or method == "invokeServer") and self:IsA("RemoteFunction") then
                RemoteSpy.logCall(self, "InvokeServer", {...})
            end
        end
        return rawNamecall(self, ...)
    end)
    if setreadonly then setreadonly(grm, true) end
    return true
end

function RemoteSpy.stop()
    if not RemoteSpy.Enabled then return end
    RemoteSpy.Enabled = false
    local grm = getrawmetatable(game)
    if grm and rawNamecall then
        if setreadonly then setreadonly(grm, false) end
        grm.__namecall = rawNamecall
        if setreadonly then setreadonly(grm, true) end
    end
end

-- Decompiler
local ModuleInspector = {}
function ModuleInspector.decompileScript(s)
    if not Env.CAPS.decompile then return "-- [Error]: Función 'decompile' no disponible en este executor." end
    local ok, code = pcall(decompile, s)
    return ok and code or ("-- [Fallo al decompilar]: " .. tostring(code))
end

-- Vulnerability Auditor
local Vulnerability = {}
function Vulnerability.analyze()
    local scan = Scanner.scanRemotes()
    local audit = { Score = 100, RiskLevel = "LOW", Findings = {} }
    local staffCount = #scan.Categorized.STAFF
    local damageCount = #scan.Categorized.DAMAGE
    local economyCount = #scan.Categorized.ECONOMY

    if staffCount > 0 then
        audit.Score = audit.Score - 35
        table.insert(audit.Findings, { Severity = "CRITICAL", Title = "Exposed Admin/Staff Remotes (" .. staffCount .. ")", Description = "Remotos con nombres clave de administración (wipe, ban, grant, setmoney) son accesibles desde el cliente." })
    end
    if damageCount > 0 then
        audit.Score = audit.Score - 20
        table.insert(audit.Findings, { Severity = "HIGH", Title = "Client-Authoritative Damage (" .. damageCount .. ")", Description = "Remotos de combate/hit detectados. Si no hay validación de distancia en el servidor, permite Kill-All." })
    end
    if economyCount > 0 then
        audit.Score = audit.Score - 15
        table.insert(audit.Findings, { Severity = "MEDIUM", Title = "Unvalidated Economy Remotes (" .. economyCount .. ")", Description = "Remotos de compra/tienda detectados. Permite comprar gratis si los precios se reciben en argumentos." })
    end

    if audit.Score <= 45 then audit.RiskLevel = "CRITICAL"
    elseif audit.Score <= 70 then audit.RiskLevel = "HIGH"
    elseif audit.Score <= 85 then audit.RiskLevel = "MEDIUM" end
    return audit
end

-- Exporter
local Exporter = {}
function Exporter.saveFile(filename, content)
    if not Env.CAPS.writefile then return false, "writefile no disponible" end
    if Env.CAPS.makefolder then pcall(makefolder, Config.SubFolder) end
    local path = Config.SubFolder .. "/" .. filename
    local ok, err = pcall(writefile, path, content)
    return ok, ok and path or tostring(err)
end

function Exporter.copyToClipboard(text)
    if Env.CAPS.setclipboard then
        local ok, err = pcall(setclipboard, text)
        return ok, err
    end
    return false, "setclipboard no disponible"
end

-- ═══════════════════════════════════════════════════════════════════
-- 4. COMPONENTES VISUALES GLASSMORPHISM & GRADIENTES (WEB/CSS STYLE)
-- ═══════════════════════════════════════════════════════════════════
local Components = {}

function Components.createCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Theme.Corners.Card
    c.Parent = parent
    return c
end

function Components.createPadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 8); p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft = UDim.new(0, left or 8); p.PaddingRight = UDim.new(0, right or 8)
    p.Parent = parent
    return p
end

function Components.createStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Colors.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Components.createGradient(parent, c1, c2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
    g.Rotation = rotation or 45
    g.Parent = parent
    return g
end

function Components.createGlassCard(parent, size, pos)
    local card = Instance.new("Frame")
    card.Size = size or UDim2.new(1, 0, 0, 100)
    if pos then card.Position = pos end
    card.BackgroundColor3 = Theme.Colors.BgCard
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel = 0
    Components.createCorner(card, Theme.Corners.Card)
    Components.createPadding(card, 12, 12, 16, 16)
    Components.createStroke(card, Theme.Colors.Border, 1, 0.3)
    if parent then card.Parent = parent end
    return card
end

function Components.createBadge(text, color, parent)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = color or Theme.Colors.Accent
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.XY
    Components.createCorner(frame, Theme.Corners.Badge)
    Components.createPadding(frame, 3, 3, 8, 8)
    Components.createStroke(frame, color or Theme.Colors.Accent, 1, 0.4)

    local label = Instance.new("TextLabel")
    label.Text = string.upper(text)
    label.Font = Theme.Fonts.Bold
    label.TextSize = Theme.Sizes.BadgeText
    label.TextColor3 = color or Theme.Colors.TextPrimary
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 0, 0, 12)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Parent = frame
    if parent then frame.Parent = parent end
    return frame
end

function Components.createGradientButton(text, onClick, parent, color1, color2)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Theme.Fonts.Bold
    btn.TextSize = Theme.Sizes.BodyText
    btn.TextColor3 = Theme.Colors.TextPrimary
    btn.BackgroundColor3 = color1 or Theme.Colors.Accent
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 140, 0, 36)
    btn.AutoButtonColor = true
    Components.createCorner(btn, Theme.Corners.Button)
    Components.createPadding(btn, 4, 4, 14, 14)
    Components.createGradient(btn, color1 or Theme.Colors.AccentGradient1, color2 or Theme.Colors.AccentGradient2, 90)
    Components.createStroke(btn, Color3.fromRGB(255, 255, 255), 1, 0.7)

    if onClick then btn.MouseButton1Click:Connect(onClick) end
    if parent then btn.Parent = parent end
    return btn
end

function Components.createMetricCard(parent, title, value, badgeText, badgeColor, icon)
    local card = Components.createGlassCard(parent, UDim2.new(0.318, 0, 0, 105))

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, 22)
    topRow.BackgroundTransparency = 1
    topRow.Parent = card

    local tLabel = Instance.new("TextLabel")
    tLabel.Text = (icon or "") .. "  " .. title
    tLabel.Font = Theme.Fonts.Bold
    tLabel.TextSize = Theme.Sizes.BodyText
    tLabel.TextColor3 = Theme.Colors.TextSecondary
    tLabel.Size = UDim2.new(0.65, 0, 1, 0)
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1
    tLabel.Parent = topRow

    if badgeText then
        local b = Components.createBadge(badgeText, badgeColor or Theme.Colors.Accent, topRow)
        b.Position = UDim2.new(1, -b.AbsoluteSize.X, 0, 0)
    end

    local vLabel = Instance.new("TextLabel")
    vLabel.Text = tostring(value)
    vLabel.Font = Theme.Fonts.Bold
    vLabel.TextSize = 26
    vLabel.TextColor3 = badgeColor or Theme.Colors.TextPrimary
    vLabel.Size = UDim2.new(1, 0, 0, 38)
    vLabel.Position = UDim2.new(0, 0, 0, 30)
    vLabel.TextXAlignment = Enum.TextXAlignment.Left
    vLabel.BackgroundTransparency = 1
    vLabel.Parent = card

    -- Subtle Gradient Glow Line at bottom
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = badgeColor or Theme.Colors.Accent
    line.BorderSizePixel = 0
    Components.createCorner(line, UDim.new(0, 1))
    Components.createGradient(line, badgeColor or Theme.Colors.Accent, Theme.Colors.BgCard, 0)
    line.Parent = card

    return card
end

function Components.createCodeViewer(codeText, parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Theme.Colors.BgCode
    container.BorderSizePixel = 0
    Components.createCorner(container, Theme.Corners.Card)
    Components.createStroke(container, Theme.Colors.Border, 1, 0.4)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Theme.Colors.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
    scroll.Parent = container

    Components.createPadding(scroll, 12, 12, 14, 14)

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

function Components.createToast(parentGui, title, msg, color)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 330, 0, 68)
    toast.Position = UDim2.new(1, -350, 1, -88)
    toast.BackgroundColor3 = Theme.Colors.BgCard
    toast.BorderSizePixel = 0
    toast.ZIndex = 9999
    Components.createCorner(toast, Theme.Corners.Card)
    Components.createPadding(toast, 12, 12, 16, 16)
    Components.createStroke(toast, color or Theme.Colors.Accent, 1.5)

    local t = Instance.new("TextLabel")
    t.Text = title; t.Font = Theme.Fonts.Bold; t.TextSize = Theme.Sizes.SubText; t.TextColor3 = color or Theme.Colors.Accent; t.Size = UDim2.new(1, 0, 0, 20); t.BackgroundTransparency = 1; t.Parent = toast
    local m = Instance.new("TextLabel")
    m.Text = msg; m.Font = Theme.Fonts.Main; m.TextSize = Theme.Sizes.BodyText; m.TextColor3 = Theme.Colors.TextSecondary; m.Size = UDim2.new(1, 0, 0, 24); m.Position = UDim2.new(0,0,0,24); m.BackgroundTransparency = 1; m.Parent = toast
    toast.Parent = parentGui
    task.delay(3.5, function() toast:Destroy() end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 5. CONSTRUCTOR DE INTERFAZ NEXT-GEN (GLASS LAUNCHER)
-- ═══════════════════════════════════════════════════════════════════
local function launchIDE()
    -- Clean previous instances across CoreGui AND PlayerGui to avoid old cache!
    pcall(function()
        if Env.Services.CoreGui:FindFirstChild("GameAnalyzerIDE") then
            Env.Services.CoreGui.GameAnalyzerIDE:Destroy()
        end
    end)
    pcall(function()
        local lp = Env.Services.Players.LocalPlayer
        if lp and lp:FindFirstChildOfClass("PlayerGui") and lp.PlayerGui:FindFirstChild("GameAnalyzerIDE") then
            lp.PlayerGui.GameAnalyzerIDE:Destroy()
        end
    end)

    local parentGui = nil
    pcall(function() parentGui = Env.Services.CoreGui end)
    if not parentGui or not pcall(function() return parentGui.Name end) then
        local lp = Env.Services.Players.LocalPlayer
        parentGui = lp and lp:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GameAnalyzerIDE"
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = true
    screenGui.DisplayOrder = 9999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main IDE Glass Container Window
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 940, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -470, 0.5, -300)
    mainFrame.BackgroundColor3 = Theme.Colors.BgWindow
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Components.createCorner(mainFrame, Theme.Corners.Window)
    Components.createStroke(mainFrame, Theme.Colors.Border, 1.5, 0.2)

    -- Header / Titlebar with Gradient Banner
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight)
    header.BackgroundColor3 = Theme.Colors.BgHeader
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    Components.createPadding(header, 0, 0, 18, 18)

    local logo = Instance.new("TextLabel")
    logo.Text = "⚡ GAMEANALYZER " .. Config.Version .. " — " .. Env.ExecutorName
    logo.Font = Theme.Fonts.Bold
    logo.TextSize = Theme.Sizes.TitleText
    logo.TextColor3 = Theme.Colors.Accent
    logo.Size = UDim2.new(0.6, 0, 1, 0)
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.BackgroundTransparency = 1
    logo.Parent = header

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Font = Theme.Fonts.Bold
    closeBtn.TextSize = 13
    closeBtn.TextColor3 = Theme.Colors.TextSecondary
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -28, 0.5, -14)
    closeBtn.BackgroundColor3 = Theme.Colors.BgCard
    closeBtn.BorderSizePixel = 0
    Components.createCorner(closeBtn, Theme.Corners.Badge)
    closeBtn.Parent = header
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

    -- Header Dragging
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        end
    end)
    Env.Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    Env.Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Sidebar Pane
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    sidebar.Position = UDim2.new(0, 0, 0, Theme.Sizes.HeaderHeight)
    sidebar.BackgroundColor3 = Theme.Colors.BgSidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    Components.createPadding(sidebar, 14, 14, 12, 12)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebar

    -- Viewport Container
    local viewport = Instance.new("Frame")
    viewport.Size = UDim2.new(1, -Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    viewport.Position = UDim2.new(0, Theme.Sizes.SidebarWidth, 0, Theme.Sizes.HeaderHeight)
    viewport.BackgroundColor3 = Theme.Colors.BgWindow
    viewport.BorderSizePixel = 0
    viewport.Parent = mainFrame
    Components.createPadding(viewport, 16, 16, 18, 18)

    -- Status Bar
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.StatusBarHeight)
    statusBar.Position = UDim2.new(0, 0, 1, -Theme.Sizes.StatusBarHeight)
    statusBar.BackgroundColor3 = Theme.Colors.BgSidebar
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame
    Components.createPadding(statusBar, 0, 0, 16, 16)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = string.format("PlaceId: %d  |  Executor: %s  |  Atajo: [RightControl]", game.PlaceId, Env.ExecutorName)
    statusLabel.Font = Theme.Fonts.Main
    statusLabel.TextSize = Theme.Sizes.BodyText
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.BackgroundTransparency = 1
    statusLabel.Parent = statusBar

    -- Tabs Configuration
    local tabs = {
        { Id = "Dashboard", Icon = "📊", Name = "Dashboard Pro" },
        { Id = "Remotes",   Icon = "⚡", Name = "Remotes & Spy" },
        { Id = "Modules",   Icon = "📦", Name = "Módulos & Code" },
        { Id = "Jugador",   Icon = "👤", Name = "Jugador Stats" },
        { Id = "Audit",     Icon = "🛡️", Name = "Seguridad Audit" },
        { Id = "Exporter",  Icon = "💾", Name = "Exportar Dump" },
    }

    local activeViewFrame = nil
    local tabButtons = {}

    local function loadTab(tabId)
        if activeViewFrame then activeViewFrame:Destroy() end

        for id, btn in pairs(tabButtons) do
            if id == tabId then
                btn.BackgroundColor3 = Theme.Colors.Accent
                btn.TextColor3 = Theme.Colors.TextPrimary
            else
                btn.BackgroundColor3 = Theme.Colors.BgSidebar
                btn.TextColor3 = Theme.Colors.TextSecondary
            end
        end

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = viewport
        activeViewFrame = frame

        if tabId == "Dashboard" then
            local scan = Scanner.scanRemotes()
            local vuln = Vulnerability.analyze()

            -- Metrics Row (Cards with Glassmorphism)
            local metricsFrame = Instance.new("Frame")
            metricsFrame.Size = UDim2.new(1, 0, 0, 105)
            metricsFrame.BackgroundTransparency = 1
            metricsFrame.Parent = frame

            local mLayout = Instance.new("UIListLayout")
            mLayout.FillDirection = Enum.FillDirection.Horizontal
            mLayout.Padding = UDim.new(0, 12)
            mLayout.Parent = metricsFrame

            Components.createMetricCard(metricsFrame, "REMOTOS DETECTADOS", scan.TotalCount, "TOTAL", Theme.Colors.Accent, "⚡")
            Components.createMetricCard(metricsFrame, "REMOTOS DE STAFF", #scan.Categorized.STAFF, #scan.Categorized.STAFF > 0 and "ALERTA" or "OK", #scan.Categorized.STAFF > 0 and Theme.Colors.Danger or Theme.Colors.Success, "🛡️")
            Components.createMetricCard(metricsFrame, "NIVEL DE RIESGO", vuln.RiskLevel, vuln.Score .. "/100", vuln.RiskLevel == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Success, "⚠️")

            -- Place Details Glass Panel
            local detailsPanel = Components.createGlassCard(frame, UDim2.new(1, 0, 1, -120), UDim2.new(0, 0, 0, 120))

            local pTitle = Instance.new("TextLabel")
            pTitle.Text = "📌 Detalles de Sesión & Servidor"
            pTitle.Font = Theme.Fonts.Bold
            pTitle.TextSize = Theme.Sizes.SubText
            pTitle.TextColor3 = Theme.Colors.Accent
            pTitle.Size = UDim2.new(1, 0, 0, 24)
            pTitle.TextXAlignment = Enum.TextXAlignment.Left
            pTitle.BackgroundTransparency = 1
            pTitle.Parent = detailsPanel

            local infoText = string.format([[
  • Nombre del Lugar:  %s
  • Place ID:          %d
  • Game ID:           %d
  • Job ID:            %s
  • Jugadores Activos: %d / %s
  • Creador ID:        %d
  • Executor:          %s]],
                game.Name,
                game.PlaceId,
                game.GameId,
                game.JobId ~= "" and game.JobId or "Servidor Privado / Studio",
                #Env.Services.Players:GetPlayers(),
                tostring(Env.Services.Players.MaxPlayers),
                game.CreatorId,
                Env.ExecutorName
            )

            local pText = Instance.new("TextLabel")
            pText.Text = infoText
            pText.Font = Theme.Fonts.Code
            pText.TextSize = 13
            pText.TextColor3 = Theme.Colors.TextPrimary
            pText.Size = UDim2.new(1, 0, 1, -32)
            pText.Position = UDim2.new(0, 0, 0, 32)
            pText.TextXAlignment = Enum.TextXAlignment.Left
            pText.TextYAlignment = Enum.TextYAlignment.Top
            pText.BackgroundTransparency = 1
            pText.Parent = detailsPanel

        elseif tabId == "Remotes" then
            local scan = Scanner.scanRemotes()

            local actionBar = Instance.new("Frame")
            actionBar.Size = UDim2.new(1, 0, 0, 38)
            actionBar.BackgroundTransparency = 1
            actionBar.Parent = frame

            local spyBtn = Components.createGradientButton(RemoteSpy.Enabled and "⏹ Detener RemoteSpy" or "⚡ Iniciar Live RemoteSpy Hook", function(btn)
                if RemoteSpy.Enabled then
                    RemoteSpy.stop()
                    Components.createToast(screenGui, "RemoteSpy", "Hook desactivado.", Theme.Colors.Warning)
                else
                    local ok = RemoteSpy.start()
                    Components.createToast(screenGui, "RemoteSpy", ok and "Hook activado (__namecall interceptando remotos)!" or "Error al enganchar metamétodo.", ok and Theme.Colors.Success or Theme.Colors.Danger)
                end
            end, actionBar, Theme.Colors.AccentGradient1, Theme.Colors.AccentGradient2)
            spyBtn.Size = UDim2.new(0, 260, 1, 0)

            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(0.48, 0, 1, -48)
            listFrame.Position = UDim2.new(0, 0, 0, 48)
            listFrame.BackgroundTransparency = 1
            listFrame.Parent = frame

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.ScrollBarThickness = 5
            scroll.ScrollBarImageColor3 = Theme.Colors.Accent
            scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.Parent = listFrame

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 6)
            layout.Parent = scroll

            local previewFrame = Instance.new("Frame")
            previewFrame.Size = UDim2.new(0.5, 0, 1, -48)
            previewFrame.Position = UDim2.new(0.5, 0, 0, 48)
            previewFrame.BackgroundColor3 = Theme.Colors.BgCode
            previewFrame.Parent = frame

            local currentCodeBox = Components.createCodeViewer("-- Selecciona un remoto para ver su código ejecutable.", previewFrame)

            for _, r in ipairs(scan.RemoteEvents) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 42)
                card.BackgroundColor3 = Theme.Colors.BgCard
                card.BorderSizePixel = 0
                Components.createCorner(card, Theme.Corners.Badge)
                Components.createStroke(card, Theme.Colors.Border, 1, 0.4)

                local badgeColor = Config.CategoryColors[r.Category] or Theme.Colors.TextMuted
                local badge = Components.createBadge(r.Category, badgeColor, card)
                badge.Position = UDim2.new(0, 8, 0.5, -9)

                local l = Instance.new("TextLabel")
                l.Text = r.Name
                l.Font = Theme.Fonts.Bold
                l.TextSize = 12
                l.TextColor3 = Theme.Colors.TextPrimary
                l.Position = UDim2.new(0, 104, 0, 0)
                l.Size = UDim2.new(0.65, 0, 1, 0)
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.BackgroundTransparency = 1
                l.Parent = card

                local selectBtn = Instance.new("TextButton")
                selectBtn.Size = UDim2.new(1, 0, 1, 0)
                selectBtn.BackgroundTransparency = 1
                selectBtn.Text = ""
                selectBtn.Parent = card

                selectBtn.MouseButton1Click:Connect(function()
                    local snippet = string.format("-- Código de Invocación para: %s\nlocal Remote = %s\nRemote:FireServer()", r.Name, r.FullName)
                    currentCodeBox:Destroy()
                    currentCodeBox = Components.createCodeViewer(snippet, previewFrame)
                    Exporter.copyToClipboard(snippet)
                    Components.createToast(screenGui, "Snippet Generado", "Copiado al portapapeles!", Theme.Colors.Success)
                end)

                card.Parent = scroll
            end

        elseif tabId == "Modules" then
            local mods = Scanner.scanModules()

            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(0.42, 0, 1, 0)
            listFrame.BackgroundTransparency = 1
            listFrame.Parent = frame

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.ScrollBarThickness = 5
            scroll.ScrollBarImageColor3 = Theme.Colors.Accent
            scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.Parent = listFrame

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 5)
            layout.Parent = scroll

            local codePane = Instance.new("Frame")
            codePane.Size = UDim2.new(0.56, 0, 1, 0)
            codePane.Position = UDim2.new(0.44, 0, 0, 0)
            codePane.BackgroundColor3 = Theme.Colors.BgCode
            codePane.Parent = frame

            local codeBox = Components.createCodeViewer("-- Haz clic en un ModuleScript para visualizar su código fuente decompilado.", codePane)

            for _, m in ipairs(mods) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 36)
                card.BackgroundColor3 = Theme.Colors.BgCard
                card.BorderSizePixel = 0
                Components.createCorner(card, Theme.Corners.Badge)
                Components.createStroke(card, Theme.Colors.Border, 1, 0.4)

                local l = Instance.new("TextLabel")
                l.Text = "📦  " .. m.Name
                l.Font = Theme.Fonts.Code
                l.TextSize = 12
                l.TextColor3 = Theme.Colors.TextPrimary
                l.Position = UDim2.new(0, 10, 0, 0)
                l.Size = UDim2.new(0.9, 0, 1, 0)
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.BackgroundTransparency = 1
                l.Parent = card

                local clickBtn = Instance.new("TextButton")
                clickBtn.Size = UDim2.new(1, 0, 1, 0)
                clickBtn.BackgroundTransparency = 1
                clickBtn.Text = ""
                clickBtn.Parent = card

                clickBtn.MouseButton1Click:Connect(function()
                    local code = ModuleInspector.decompileScript(m.Instance)
                    codeBox:Destroy()
                    codeBox = Components.createCodeViewer(code, codePane)
                end)

                card.Parent = scroll
            end

        elseif tabId == "Jugador" then
            local pData = Scanner.scanPlayerData()
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.ScrollBarThickness = 5
            scroll.Parent = frame

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 12)
            layout.Parent = scroll

            local pCard = Components.createGlassCard(scroll, UDim2.new(1, 0, 0, 110))

            local pName = Instance.new("TextLabel")
            pName.Text = "👤 Jugador: " .. (Env.LocalPlayer and Env.LocalPlayer.Name or "LocalPlayer")
            pName.Font = Theme.Fonts.Bold
            pName.TextSize = 16
            pName.TextColor3 = Theme.Colors.Accent
            pName.Size = UDim2.new(1, 0, 0, 24)
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.BackgroundTransparency = 1
            pName.Parent = pCard

            local statsStr = "Sin datos de Humanoid"
            if pData.Character.WalkSpeed then
                statsStr = string.format("WalkSpeed: %.1f   |   JumpPower: %.1f   |   Salud: %.1f / %.1f",
                    pData.Character.WalkSpeed, pData.Character.JumpPower, pData.Character.Health, pData.Character.MaxHealth)
            end

            local pStats = Instance.new("TextLabel")
            pStats.Text = statsStr
            pStats.Font = Theme.Fonts.Code
            pStats.TextSize = 13
            pStats.TextColor3 = Theme.Colors.TextPrimary
            pStats.Size = UDim2.new(1, 0, 0, 24)
            pStats.Position = UDim2.new(0, 0, 0, 32)
            pStats.TextXAlignment = Enum.TextXAlignment.Left
            pStats.BackgroundTransparency = 1
            pStats.Parent = pCard

            local lsTitle = Instance.new("TextLabel")
            lsTitle.Text = "💰 Leaderstats & Currencies"
            lsTitle.Font = Theme.Fonts.Bold
            lsTitle.TextSize = 14
            lsTitle.TextColor3 = Theme.Colors.TextSecondary
            lsTitle.Size = UDim2.new(1, 0, 0, 24)
            lsTitle.TextXAlignment = Enum.TextXAlignment.Left
            lsTitle.BackgroundTransparency = 1
            lsTitle.Parent = scroll

            for _, ls in ipairs(pData.Leaderstats) do
                local cCard = Instance.new("Frame")
                cCard.Size = UDim2.new(1, 0, 0, 40)
                cCard.BackgroundColor3 = Theme.Colors.BgCard
                Components.createCorner(cCard, Theme.Corners.Badge)
                Components.createPadding(cCard, 0, 0, 14, 14)
                Components.createStroke(cCard, Theme.Colors.Border, 1, 0.4)

                local cName = Instance.new("TextLabel")
                cName.Text = ls.Name
                cName.Font = Theme.Fonts.Bold
                cName.TextSize = 13
                cName.TextColor3 = Theme.Colors.TextPrimary
                cName.Size = UDim2.new(0.5, 0, 1, 0)
                cName.TextXAlignment = Enum.TextXAlignment.Left
                cName.BackgroundTransparency = 1
                cName.Parent = cCard

                local cVal = Instance.new("TextLabel")
                cVal.Text = tostring(ls.Value)
                cVal.Font = Theme.Fonts.Code
                cVal.TextSize = 13
                cVal.TextColor3 = Theme.Colors.Success
                cVal.Size = UDim2.new(0.5, 0, 1, 0)
                cVal.Position = UDim2.new(0.5, 0, 0, 0)
                cVal.TextXAlignment = Enum.TextXAlignment.Right
                cVal.BackgroundTransparency = 1
                cVal.Parent = cCard

                cCard.Parent = scroll
            end

        elseif tabId == "Audit" then
            local vuln = Vulnerability.analyze()

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.ScrollBarThickness = 5
            scroll.Parent = frame

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 10)
            layout.Parent = scroll

            local auditCard = Components.createGlassCard(scroll, UDim2.new(1, 0, 0, 70))
            Components.createStroke(auditCard, vuln.RiskLevel == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Success, 1.5)

            local aTitle = Instance.new("TextLabel")
            aTitle.Text = "🛡️ Auditoría de Seguridad Automatizada — Riesgo: " .. vuln.RiskLevel
            aTitle.Font = Theme.Fonts.Bold
            aTitle.TextSize = 15
            aTitle.TextColor3 = vuln.RiskLevel == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Success
            aTitle.Size = UDim2.new(1, 0, 0, 22)
            aTitle.TextXAlignment = Enum.TextXAlignment.Left
            aTitle.BackgroundTransparency = 1
            aTitle.Parent = auditCard

            for _, f in ipairs(vuln.Findings) do
                local fCard = Instance.new("Frame")
                fCard.Size = UDim2.new(1, 0, 0, 78)
                fCard.BackgroundColor3 = Theme.Colors.BgCard
                Components.createCorner(fCard, Theme.Corners.Card)
                Components.createPadding(fCard, 10, 10, 14, 14)
                Components.createStroke(fCard, f.Severity == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Warning, 1, 0.4)

                local fTitle = Instance.new("TextLabel")
                fTitle.Text = "[" .. f.Severity .. "]  " .. f.Title
                fTitle.Font = Theme.Fonts.Bold
                fTitle.TextSize = 13
                fTitle.TextColor3 = f.Severity == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Warning
                fTitle.Size = UDim2.new(1, 0, 0, 20)
                fTitle.TextXAlignment = Enum.TextXAlignment.Left
                fTitle.BackgroundTransparency = 1
                fTitle.Parent = fCard

                local fDesc = Instance.new("TextLabel")
                fDesc.Text = f.Description
                fDesc.Font = Theme.Fonts.Main
                fDesc.TextSize = 12
                fDesc.TextColor3 = Theme.Colors.TextSecondary
                fDesc.Size = UDim2.new(1, 0, 0, 38)
                fDesc.Position = UDim2.new(0, 0, 0, 22)
                fDesc.TextWrapped = true
                fDesc.TextXAlignment = Enum.TextXAlignment.Left
                fDesc.BackgroundTransparency = 1
                fDesc.Parent = fCard

                fCard.Parent = scroll
            end

        elseif tabId == "Exporter" then
            local card = Components.createGlassCard(frame, UDim2.new(0.65, 0, 0.55, 0), UDim2.new(0.175, 0, 0.2, 0))

            local eTitle = Instance.new("TextLabel")
            eTitle.Text = "💾 Exportar Informe de Análisis (.txt)"
            eTitle.Font = Theme.Fonts.Bold
            eTitle.TextSize = 16
            eTitle.TextColor3 = Theme.Colors.Accent
            eTitle.Size = UDim2.new(1, 0, 0, 24)
            eTitle.TextXAlignment = Enum.TextXAlignment.Left
            eTitle.BackgroundTransparency = 1
            eTitle.Parent = card

            local eDesc = Instance.new("TextLabel")
            eDesc.Text = "Guarda el reporte completo estructurado con remotos, categorías y diagnóstico de seguridad en la carpeta /ReverseKit/ de tu executor."
            eDesc.Font = Theme.Fonts.Main
            eDesc.TextSize = 12
            eDesc.TextColor3 = Theme.Colors.TextSecondary
            eDesc.Size = UDim2.new(1, 0, 0, 48)
            eDesc.Position = UDim2.new(0, 0, 0, 32)
            eDesc.TextWrapped = true
            eDesc.TextXAlignment = Enum.TextXAlignment.Left
            eDesc.BackgroundTransparency = 1
            eDesc.Parent = card

            local btn = Components.createGradientButton("💾 Generar y Guardar Dump (.txt)", function()
                local scan = Scanner.scanRemotes()
                local vuln = Vulnerability.analyze()
                local txt = string.format("====================================================\nGameAnalyzer Dump — Place: %d\nTotal Remotes: %d | Riesgo: %s (%d/100)\nFecha: %s\n====================================================\n", game.PlaceId, scan.TotalCount, vuln.RiskLevel, vuln.Score, os.date("%X"))
                for _, r in ipairs(scan.RemoteEvents) do
                    txt = txt .. string.format("[%s] %s\n", r.Category, r.FullName)
                end
                local ok, path = Exporter.saveFile("Place_" .. game.PlaceId .. "_Dump.txt", txt)
                Components.createToast(screenGui, ok and "Guardado Exitoso" or "Error al Guardar", ok and path or tostring(path), ok and Theme.Colors.Success or Theme.Colors.Danger)
            end, card, Theme.Colors.AccentGradient1, Theme.Colors.AccentGradient2)
            btn.Size = UDim2.new(1, 0, 0, 44)
            btn.Position = UDim2.new(0, 0, 1, -44)
        end
    end

    for _, t in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Text = "  " .. t.Icon .. "  " .. t.Name
        btn.Font = Theme.Fonts.Bold
        btn.TextSize = 12
        btn.TextColor3 = Theme.Colors.TextSecondary
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Theme.Colors.BgSidebar
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BorderSizePixel = 0
        Components.createCorner(btn, Theme.Corners.Button)
        Components.createPadding(btn, 0, 0, 12, 12)

        btn.MouseButton1Click:Connect(function() loadTab(t.Id) end)

        tabButtons[t.Id] = btn
        btn.Parent = sidebar
    end

    Env.Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Config.ToggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    screenGui.Parent = parentGui
    loadTab("Dashboard")
    Components.createToast(screenGui, "GameAnalyzer v6.0 IDE Pro", "Cargado con Glassmorphism & Gradients! Presiona [RightControl] para ocultar/mostrar.", Theme.Colors.Accent)
end

print("[GameAnalyzer v6.0 IDE Glass Pro] Iniciando en Potassium...")
local success, err = pcall(launchIDE)
if not success then
    warn("[GameAnalyzer Error de Inicio]:", err)
end