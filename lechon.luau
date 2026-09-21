--[[
    ════════════════════════════════════════════════════════════════════
    ⚡ GameAnalyzer v6.0 — IDE Edition (Universal Roblox Dumper & Spy)
    ════════════════════════════════════════════════════════════════════
    Diseñado para Potassium & Executors Luau Modernos.
    Todo el código está 100% Autocontenido (Single-File) — ¡Cero dependencias!
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

Env.ExecutorName = "Desconocido"
pcall(function()
    if type(identifyexecutor) == "function" then
        Env.ExecutorName = identifyexecutor()
    elseif type(getexecutorname) == "function" then
        Env.ExecutorName = getexecutorname()
    end
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
    isfile               = hasFn("isfile"),
    isfolder             = hasFn("isfolder"),
    makefolder           = hasFn("makefolder"),
    delfile              = hasFn("delfile"),
    listfiles            = hasFn("listfiles"),
    setclipboard         = hasFn("setclipboard"),
    getclipboard         = hasFn("getclipboard"),
    hookmetamethod       = hasFn("hookmetamethod"),
    getrawmetatable      = hasFn("getrawmetatable"),
    setreadonly          = hasFn("setreadonly"),
    getnamecallmethod    = hasFn("getnamecallmethod"),
    newcclosure          = hasFn("newcclosure"),
    getconnections       = hasFn("getconnections"),
    firesignal           = hasFn("firesignal"),
    decompile            = hasFn("decompile"),
    getscriptbytecode    = hasFn("getscriptbytecode"),
    getscripts           = hasFn("getscripts"),
    getloadedmodules     = hasFn("getloadedmodules"),
    getgc                = hasFn("getgc"),
    getinstances         = hasFn("getinstances"),
    getnilinstances      = hasFn("getnilinstances"),
    fireclickdetector    = hasFn("fireclickdetector"),
    fireproximityprompt  = hasFn("fireproximityprompt"),
    request              = hasFn("request") or hasFn("http_request"),
    queue_on_teleport    = hasFn("queue_on_teleport"),
    getcallbackvalue     = hasFn("getcallbackvalue"),
    getcustomasset       = hasFn("getcustomasset"),
    getfunctionhash      = hasFn("getfunctionhash"),
    checkcaller          = hasFn("checkcaller"),
    islclosure           = hasFn("islclosure"),
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
    if t == "EnumItem"  then return tostring(v) end
    if t == "table" then
        local parts, count = {}, 0
        for k, val in pairs(v) do
            if count >= 10 then table.insert(parts, "..."); break end
            table.insert(parts, tostring(k) .. " = " .. Env.serialize(val, depth + 1))
            count = count + 1
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    end
    return t
end

Env.LoadedModulesCache = {}
if Env.CAPS.getloadedmodules then
    pcall(function()
        for _, m in ipairs(getloadedmodules()) do
            Env.LoadedModulesCache[m] = true
        end
    end)
end

function Env.safeRequire(module, timeoutSeconds)
    timeoutSeconds = timeoutSeconds or 3.0
    if Env.LoadedModulesCache[module] then
        local ok, val = pcall(require, module)
        if ok then return true, val end
    end
    local result, done, err = nil, false, nil
    local thread = task.spawn(function()
        local ok, val = pcall(function() return require(module) end)
        if ok then result = val else err = val end
        done = true
    end)
    local t0 = os.clock()
    while not done and (os.clock() - t0) < timeoutSeconds do
        task.wait(0.03)
    end
    if not done then pcall(task.cancel, thread); return false, "Timeout (> " .. tostring(timeoutSeconds) .. "s)" end
    if err then return false, tostring(err) end
    return true, result
end

-- ═══════════════════════════════════════════════════════════════════
-- 2. CONFIGURACIÓN Y TEMA (CLAUDE IDE)
-- ═══════════════════════════════════════════════════════════════════
local Config = {
    Version = "v6.0 IDE Edition",
    SubFolder = "ReverseKit",
    ToggleKey = Enum.KeyCode.RightControl,
}

Config.Theme = {
    BgMain        = Color3.fromRGB(24, 24, 27),
    BgSidebar     = Color3.fromRGB(18, 18, 21),
    BgHeader      = Color3.fromRGB(30, 30, 36),
    BgCard        = Color3.fromRGB(33, 33, 38),
    BgCardHover   = Color3.fromRGB(42, 42, 49),
    BgInput       = Color3.fromRGB(20, 20, 24),
    BgCode        = Color3.fromRGB(15, 15, 18),
    Accent        = Color3.fromRGB(217, 119, 6),      -- Claude Warm Amber #d97706
    AccentLight   = Color3.fromRGB(245, 158, 11),
    Success       = Color3.fromRGB(34, 197, 94),
    Warning       = Color3.fromRGB(234, 179, 8),
    Danger        = Color3.fromRGB(239, 68, 68),
    Info          = Color3.fromRGB(59, 130, 246),
    Purple        = Color3.fromRGB(168, 85, 247),
    TextPrimary   = Color3.fromRGB(243, 244, 246),
    TextSecondary = Color3.fromRGB(156, 163, 175),
    TextMuted     = Color3.fromRGB(107, 114, 128),
    TextCode      = Color3.fromRGB(229, 231, 235),
    Border        = Color3.fromRGB(45, 45, 52),
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

local Theme = {
    Colors = Config.Theme,
    Fonts = { Main = Enum.Font.BuilderSans, Bold = Enum.Font.BuilderSansBold, Code = Enum.Font.Code },
    Sizes = { TitleText = 16, SubText = 13, BodyText = 12, CodeText = 12, BadgeText = 10, SidebarWidth = 190, HeaderHeight = 42, StatusBarHeight = 24 },
    Corners = { Window = UDim.new(0, 10), Card = UDim.new(0, 6), Button = UDim.new(0, 6), Badge = UDim.new(0, 4) },
}

-- ═══════════════════════════════════════════════════════════════════
-- 3. ESCÁNERES Y SERVICIOS
-- ═══════════════════════════════════════════════════════════════════
local Scanner = {}
Scanner.RemoteCategories = {
    DAMAGE    = {"damage","hit","hurt","kill","shoot","attack","combat","bullet","projectile","dealdamage","applydamage","onhit","impact","basicattack","criticalstrike","posture","blaster"},
    FARM      = {"collect","pickup","harvest","farm","gather","haul","away","offline","idle","petal","orb","claimreward","claimedrop","collectcash","coingather","tokencollect"},
    ECONOMY   = {"buy","purchase","shop","pay","spend","sell","trade","money","cash","coin","reward","give","transfer","checkout","unlock","unbox","crate","gacha","spin","market","buynascar","buyhouse","purchasegamepass","claimreward"},
    PLAYER    = {"playerdata","syncdata","fetchstate","loadstate","data","profile","sync","character","stats","snapshot","fetchprofile","getprofile","loadplayer","updateplayer","replicaplayer"},
    MOVEMENT  = {"teleport","warp","tp","jump","dash","sprint","velocity","moveto","setposition","hopserver","requestteleport","teleporttoplace","getdestination","warpportal","tpzone"},
    VEHICLE   = {"vehicle","chassis","drive","engine","race","getvehicle","vehicleevent","vehicleinfo","vehiclestats","vehicletune","vehiclecollision","vehiclereplication","sellcar","getcar","carinfo","racetrack","racefinish","racestart","racequeue","racejoin","raceleave","racepayout","carmeet","heist","atmbust","criminalstreak","stealvehicle"},
    SKIN      = {"skin","cosmetic","equip","loadout","inventory","wear","setcosmetic","equippart","skinchanger","changeskin","playerskin","cosmeticchange","stockskin","equipbest","trailwear","customization","clothinglocker","applycosmetic"},
    QUEST     = {"quest","mission","objective","complete","finish","daily","challenge","bounty","task","onboarding","questline","askclaim","acknowledgequest","pinquest","claimquest","skipquest","foundquest","questclaimed"},
    LOBBY     = {"lobby","mode","round","match","phase","gamestate","roundstate","matchmak","startmatch","joinqueue","leavequeue","requestreturn","createlobby","joinlobby","selectmap","serverselect","carmeetevent","racingqueue","joinrace","leaverace","queuestate","enqueue","dequeue","carmeet","playerready","partydata","rejoingame"},
    STAFF     = {"staff","verdict","grantself","grantpet","grantegg","givemoney","setmoney","wipeprofil","wipeverdict","staffverdict","banwave","kickplayer","spectateuser","queryprofile","adminreq","voldexadmin","apexdashboard","addcash","setcash","hardwipe","wipedata","addcurrency","givegamepass","freezeplayer","remotesfiresrvr","remotesinvokeservr"},
    CRAFT     = {"craft","blend","mix","combine","brew","forge","merge","fuse","mutate","fusery","askfuse","askblend","bloomery","recipe"},
    ANTICHEAT = {"anticheat","exploitdetect","cheatdetect","reportcheat","integrity","integritycheck","cheatremote"},
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
    local results = { RemoteEvents = {}, RemoteFunctions = {}, BindableEvents = {}, UnreliableRemotes = {}, Categorized = {}, TotalCount = 0 }
    for cat, _ in pairs(Scanner.RemoteCategories) do results.Categorized[cat] = {} end
    results.Categorized["OTHER"] = {}
    for _, v in ipairs(game:GetDescendants()) do
        local entry = { Instance = v, Name = v.Name, FullName = v:GetFullName(), ClassName = v.ClassName, Category = "OTHER" }
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") or v:IsA("UnreliableRemoteEvent") then
            entry.Category = Scanner.categorizeRemote(v)
            if v:IsA("RemoteEvent") then table.insert(results.RemoteEvents, entry)
            elseif v:IsA("RemoteFunction") then table.insert(results.RemoteFunctions, entry)
            else table.insert(results.UnreliableRemotes, entry) end
            table.insert(results.Categorized[entry.Category], entry)
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
local RemoteSpy = { Enabled = false, Logs = {}, MaxLogs = 200 }
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
            if (method == "FireServer" or method == "fireServer") and (self:IsA("RemoteEvent") or self:IsA("UnreliableRemoteEvent")) then
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

-- Module Inspector & Decompiler
local ModuleInspector = {}
function ModuleInspector.decompileScript(s)
    if not Env.CAPS.decompile then return "-- El decompilador no está disponible en este executor." end
    local ok, code = pcall(decompile, s)
    return ok and code or ("-- Fallo al decompilar: " .. tostring(code))
end

-- GC & Memory Scanner
local MemoryScanner = {}
function MemoryScanner.scanNilInstances()
    local nilRemotes, nilScripts, total = {}, {}, 0
    if Env.CAPS.getnilinstances then
        pcall(function()
            for _, inst in ipairs(getnilinstances()) do
                total = total + 1
                if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
                    table.insert(nilRemotes, inst:GetFullName())
                elseif inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
                    table.insert(nilScripts, inst:GetFullName())
                end
            end
        end)
    end
    return nilRemotes, nilScripts, total
end

-- Security Audit Service
local Vulnerability = {}
function Vulnerability.analyze()
    local scan = Scanner.scanRemotes()
    local audit = { Score = 100, RiskLevel = "LOW", Findings = {} }
    local staffCount = #scan.Categorized.STAFF
    local damageCount = #scan.Categorized.DAMAGE
    local economyCount = #scan.Categorized.ECONOMY

    if staffCount > 0 then
        audit.Score = audit.Score - 30
        table.insert(audit.Findings, { Severity = "CRITICAL", Title = "Remotos de Staff/Admin Expuestos (" .. staffCount .. ")", Description = "Remotos relacionados con comandos de admin (wipe, ban, grant, setmoney) son invocables por clientes." })
    end
    if damageCount > 0 then
        audit.Score = audit.Score - 20
        table.insert(audit.Findings, { Severity = "HIGH", Title = "Remotos de Daño en Cliente (" .. damageCount .. ")", Description = "Remotos de combate/daño detectados. Verifica que el servidor valide el alcance y el daño." })
    end
    if economyCount > 0 then
        audit.Score = audit.Score - 15
        table.insert(audit.Findings, { Severity = "MEDIUM", Title = "Remotos de Economía (" .. economyCount .. ")", Description = "Remotos de compra/tienda detectados. Si los precios se envían como argumento, podrían comprarse gratis." })
    end

    if audit.Score <= 50 then audit.RiskLevel = "CRITICAL"
    elseif audit.Score <= 75 then audit.RiskLevel = "HIGH"
    elseif audit.Score <= 90 then audit.RiskLevel = "MEDIUM" end
    return audit
end

-- Exporter Service
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
-- 4. COMPONENTES DE INTERFAZ (UI COMPONENTS)
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

function Components.createBadge(text, color, parent)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = color or Theme.Colors.Accent
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.XY
    Components.createCorner(frame, Theme.Corners.Badge)
    Components.createPadding(frame, 2, 2, 6, 6)
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
    if onClick then btn.MouseButton1Click:Connect(onClick) end
    if parent then btn.Parent = parent end
    return btn
end

function Components.createToast(parentGui, title, msg, color)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 300, 0, 60)
    toast.Position = UDim2.new(1, -320, 1, -80)
    toast.BackgroundColor3 = Theme.Colors.BgCard
    toast.BorderSizePixel = 0
    Components.createCorner(toast, Theme.Corners.Card)
    Components.createPadding(toast, 8, 8, 12, 12)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Colors.Accent
    s.Thickness = 1.5; s.Parent = toast
    local t = Instance.new("TextLabel")
    t.Text = title; t.Font = Theme.Fonts.Bold; t.TextSize = Theme.Sizes.SubText; t.TextColor3 = color or Theme.Colors.Accent; t.Size = UDim2.new(1, 0, 0, 18); t.BackgroundTransparency = 1; t.Parent = toast
    local m = Instance.new("TextLabel")
    m.Text = msg; m.Font = Theme.Fonts.Main; m.TextSize = Theme.Sizes.BodyText; m.TextColor3 = Theme.Colors.TextSecondary; m.Size = UDim2.new(1, 0, 0, 24); m.Position = UDim2.new(0,0,0,20); m.BackgroundTransparency = 1; m.Parent = toast
    toast.Parent = parentGui
    task.delay(3.5, function() toast:Destroy() end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 5. CONSTRUCTOR DE INTERFAZ (MAIN IDE LAUNCHER)
-- ═══════════════════════════════════════════════════════════════════
local function launchIDE()
    local parentGui = nil
    pcall(function() if Env.Services.CoreGui then parentGui = Env.Services.CoreGui end end)
    if not parentGui then parentGui = Env.LocalPlayer:WaitForChild("PlayerGui") end

    if parentGui:FindFirstChild("GameAnalyzerIDE") then
        parentGui.GameAnalyzerIDE:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GameAnalyzerIDE"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 840, 0, 540)
    mainFrame.Position = UDim2.new(0.5, -420, 0.5, -270)
    mainFrame.BackgroundColor3 = Theme.Colors.BgMain
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    Components.createCorner(mainFrame, Theme.Corners.Window)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Colors.Border
    stroke.Thickness = 1.5
    stroke.Parent = mainFrame

    mainFrame.Parent = screenGui

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight)
    header.BackgroundColor3 = Theme.Colors.BgHeader
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    Components.createPadding(header, 0, 0, 14, 14)

    local title = Instance.new("TextLabel")
    title.Text = "⚡ GameAnalyzer " .. Config.Version .. " — " .. Env.ExecutorName
    title.Font = Theme.Fonts.Bold
    title.TextSize = Theme.Sizes.TitleText
    title.TextColor3 = Theme.Colors.TextPrimary
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = header

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
    closeBtn.Parent = header
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

    -- Dragging Logic
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

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    sidebar.Position = UDim2.new(0, 0, 0, Theme.Sizes.HeaderHeight)
    sidebar.BackgroundColor3 = Theme.Colors.BgSidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    Components.createPadding(sidebar, 10, 10, 8, 8)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebar

    -- Viewport
    local viewport = Instance.new("Frame")
    viewport.Size = UDim2.new(1, -Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    viewport.Position = UDim2.new(0, Theme.Sizes.SidebarWidth, 0, Theme.Sizes.HeaderHeight)
    viewport.BackgroundColor3 = Theme.Colors.BgMain
    viewport.BorderSizePixel = 0
    viewport.Parent = mainFrame
    Components.createPadding(viewport, 12, 12, 14, 14)

    -- Status Bar
    local statusBar = Instance.new("Frame")
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

    -- Render Tab Views
    local activeViewFrame = nil
    local function loadTab(id)
        if activeViewFrame then activeViewFrame:Destroy() end
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0); frame.BackgroundTransparency = 1; frame.Parent = viewport
        activeViewFrame = frame

        if id == "Dashboard" then
            local scan = Scanner.scanRemotes()
            local vuln = Vulnerability.analyze()
            local lbl = Instance.new("TextLabel")
            lbl.Text = string.format("📊 Dashboard — Game Summary\n\n• Remotos Totales: %d\n• Remotos de Staff: %d\n• Nivel de Riesgo: %s (Puntuación: %d/100)\n• Lugar: %s (PlaceID: %d)\n• Jugadores Online: %d / %s", scan.TotalCount, #scan.Categorized.STAFF, vuln.RiskLevel, vuln.Score, game.Name, game.PlaceId, #Env.Services.Players:GetPlayers(), tostring(Env.Services.Players.MaxPlayers))
            lbl.Font = Theme.Fonts.Main; lbl.TextSize = 14; lbl.TextColor3 = Theme.Colors.TextPrimary; lbl.Size = UDim2.new(1,0,1,0); lbl.TextYAlignment = Enum.TextYAlignment.Top; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.BackgroundTransparency = 1; lbl.Parent = frame
        elseif id == "Remotes" then
            local scan = Scanner.scanRemotes()
            local spyBtn = Components.createButton(RemoteSpy.Enabled and "⏹ Detener RemoteSpy Hook" or "⚡ Iniciar RemoteSpy Hook", function(b)
                if RemoteSpy.Enabled then
                    RemoteSpy.stop()
                    Components.createToast(screenGui, "RemoteSpy", "Hook desactivado.", Theme.Colors.Warning)
                else
                    local ok = RemoteSpy.start()
                    Components.createToast(screenGui, "RemoteSpy", ok and "Hook activado (__namecall intercepte activo)!" or "Hook falló en este executor.", ok and Theme.Colors.Success or Theme.Colors.Danger)
                end
            end, frame, Theme.Colors.Accent)
            spyBtn.Size = UDim2.new(0, 220, 0, 32)

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, -40); scroll.Position = UDim2.new(0, 0, 0, 40); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Parent = frame
            local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 4); layout.Parent = scroll

            for _, r in ipairs(scan.RemoteEvents) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 34); card.BackgroundColor3 = Theme.Colors.BgCard; Components.createCorner(card, Theme.Corners.Badge)
                local b = Components.createBadge(r.Category, Config.CategoryColors[r.Category], card)
                b.Position = UDim2.new(0, 6, 0.5, -9)
                local l = Instance.new("TextLabel")
                l.Text = r.FullName; l.Font = Theme.Fonts.Code; l.TextSize = 11; l.TextColor3 = Theme.Colors.TextPrimary; l.Position = UDim2.new(0, 100, 0, 0); l.Size = UDim2.new(0.65, 0, 1, 0); l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1; l.Parent = card

                local cpBtn = Components.createButton("Copiar Código", function()
                    local snip = string.format("game:GetService(%q).%s:FireServer()", r.Instance.Parent.Name, r.Name)
                    Exporter.copyToClipboard(snip)
                    Components.createToast(screenGui, "Código Copiado", r.Name, Theme.Colors.Success)
                end, card)
                cpBtn.Size = UDim2.new(0, 100, 0, 24)
                cpBtn.Position = UDim2.new(1, -106, 0.5, -12)

                card.Parent = scroll
            end
        elseif id == "Modules" then
            local mods = Scanner.scanModules()
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Parent = frame
            local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 4); layout.Parent = scroll

            for _, m in ipairs(mods) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 34); card.BackgroundColor3 = Theme.Colors.BgCard; Components.createCorner(card, Theme.Corners.Badge)
                local l = Instance.new("TextLabel")
                l.Text = "📦 " .. m.FullName; l.Font = Theme.Fonts.Code; l.TextSize = 11; l.TextColor3 = Theme.Colors.TextPrimary; l.Position = UDim2.new(0, 10, 0, 0); l.Size = UDim2.new(0.7, 0, 1, 0); l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1; l.Parent = card

                local decBtn = Components.createButton("Decompilar", function()
                    local code = ModuleInspector.decompileScript(m.Instance)
                    Exporter.copyToClipboard(code)
                    Components.createToast(screenGui, "Decompilado", "Código copiado al portapapeles!", Theme.Colors.Success)
                end, card)
                decBtn.Size = UDim2.new(0, 95, 0, 24)
                decBtn.Position = UDim2.new(1, -100, 0.5, -12)

                card.Parent = scroll
            end
        elseif id == "Jugador" then
            local pData = Scanner.scanPlayerData()
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Parent = frame
            local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 8); layout.Parent = scroll

            local txt = "👤 Datos del Jugador Local (" .. (Env.LocalPlayer and Env.LocalPlayer.Name or "LocalPlayer") .. ")\n\n"
            txt = txt .. "• Leaderstats:\n"
            for _, ls in ipairs(pData.Leaderstats) do
                txt = txt .. string.format("   - %s = %s\n", ls.Name, tostring(ls.Value))
            end
            if #pData.Leaderstats == 0 then txt = txt .. "   (Sin leaderstats)\n" end

            txt = txt .. "\n• Stats de Humanoid:\n"
            if pData.Character.WalkSpeed then
                txt = txt .. string.format("   - WalkSpeed: %.1f | JumpPower: %.1f | Salud: %.1f / %.1f\n", pData.Character.WalkSpeed, pData.Character.JumpPower, pData.Character.Health, pData.Character.MaxHealth)
            end

            local lbl = Instance.new("TextLabel")
            lbl.Text = txt; lbl.Font = Theme.Fonts.Code; lbl.TextSize = 12; lbl.TextColor3 = Theme.Colors.TextPrimary; lbl.Size = UDim2.new(1,0,1,0); lbl.TextYAlignment = Enum.TextYAlignment.Top; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.BackgroundTransparency = 1; lbl.Parent = scroll
        elseif id == "Audit" then
            local vuln = Vulnerability.analyze()
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Parent = frame
            local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 8); layout.Parent = scroll

            local headerLbl = Instance.new("TextLabel")
            headerLbl.Text = "🛡️ Auditoría de Seguridad — Riesgo: " .. vuln.RiskLevel .. " (Puntuación: " .. vuln.Score .. "/100)"
            headerLbl.Font = Theme.Fonts.Bold; headerLbl.TextSize = 14; headerLbl.TextColor3 = vuln.RiskLevel == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Success; headerLbl.Size = UDim2.new(1,0,0,24); headerLbl.TextXAlignment = Enum.TextXAlignment.Left; headerLbl.BackgroundTransparency = 1; headerLbl.Parent = scroll

            for _, f in ipairs(vuln.Findings) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 70); card.BackgroundColor3 = Theme.Colors.BgCard; Components.createCorner(card, Theme.Corners.Card); Components.createPadding(card, 8, 8, 10, 10)
                local t = Instance.new("TextLabel")
                t.Text = "[" .. f.Severity .. "] " .. f.Title; t.Font = Theme.Fonts.Bold; t.TextSize = 12; t.TextColor3 = f.Severity == "CRITICAL" and Theme.Colors.Danger or Theme.Colors.Warning; t.Size = UDim2.new(1,0,0,18); t.TextXAlignment = Enum.TextXAlignment.Left; t.BackgroundTransparency = 1; t.Parent = card
                local d = Instance.new("TextLabel")
                d.Text = f.Description; d.Font = Theme.Fonts.Main; d.TextSize = 11; d.TextColor3 = Theme.Colors.TextSecondary; d.Size = UDim2.new(1,0,0,34); d.Position = UDim2.new(0,0,0,20); d.TextWrapped = true; d.TextXAlignment = Enum.TextXAlignment.Left; d.BackgroundTransparency = 1; d.Parent = card
                card.Parent = scroll
            end
        elseif id == "Exporter" then
            local btn = Components.createButton("💾 Exportar Volcado Completo (/ReverseKit/)", function()
                local scan = Scanner.scanRemotes()
                local vuln = Vulnerability.analyze()
                local txt = string.format("====================================================\nGameAnalyzer Dump — Place: %d\nTotal Remotes: %d | Riesgo: %s (%d/100)\nFecha: %s\n====================================================\n", game.PlaceId, scan.TotalCount, vuln.RiskLevel, vuln.Score, os.date("%X"))
                for _, r in ipairs(scan.RemoteEvents) do
                    txt = txt .. string.format("[%s] %s\n", r.Category, r.FullName)
                end
                local ok, path = Exporter.saveFile("Place_" .. game.PlaceId .. "_Dump.txt", txt)
                Components.createToast(screenGui, ok and "Guardado Exitoso" or "Error al Guardar", ok and path or tostring(path), ok and Theme.Colors.Success or Theme.Colors.Danger)
            end, frame, Theme.Colors.Accent)
            btn.Size = UDim2.new(0, 280, 0, 42)
            btn.Position = UDim2.new(0.5, -140, 0.4, 0)
        end
    end

    local tabs = {
        { Id = "Dashboard", Icon = "📊", Name = "Dashboard" },
        { Id = "Remotes",   Icon = "⚡", Name = "Remotes & Spy" },
        { Id = "Modules",   Icon = "📦", Name = "Módulos" },
        { Id = "Jugador",   Icon = "👤", Name = "Jugador" },
        { Id = "Audit",     Icon = "🛡️", Name = "Seguridad" },
        { Id = "Exporter",  Icon = "💾", Name = "Exportar" },
    }

    for _, t in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Text = "  " .. t.Icon .. "  " .. t.Name
        btn.Font = Theme.Fonts.Bold; btn.TextSize = 12; btn.TextColor3 = Theme.Colors.TextSecondary; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BackgroundColor3 = Theme.Colors.BgSidebar; btn.Size = UDim2.new(1, 0, 0, 32); Components.createCorner(btn, Theme.Corners.Button)
        btn.MouseButton1Click:Connect(function() loadTab(t.Id) end)
        btn.Parent = sidebar
    end

    Env.Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Config.ToggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    screenGui.Parent = parentGui
    loadTab("Dashboard")
    Components.createToast(screenGui, "GameAnalyzer v6.0 IDE", "Cargado en Potassium! Presiona [RightControl] para ocultar/mostrar.", Theme.Colors.Accent)
end

print("[GameAnalyzer v6.0 IDE] Iniciando en Potassium...")
pcall(launchIDE)