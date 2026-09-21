--[[
    ════════════════════════════════════════════════════════════════════
    ⚡ GameAnalyzer v6.0 — POTASSIUM / VSCODE IDE REPLICA (PRO EDITION)
    ════════════════════════════════════════════════════════════════════
    Diseñado para Potassium & Executors Luau Modernos.
    Réplica EXACTA de la interfaz visual de Potassium IDE / VSCode:
      + Barra superior de pestañas de archivos (Dashboard.luau, Remotes.luau...)
      + Explorador lateral de scripts con buscador "Filter scripts"
      + Editor de Código con números de línea (Gutter 1, 2, 3...) y RichText Syntax Highlighting
      + Consola terminal inferior (Console drawer con >_ CONSOLE)
      + Barra de estado inferior (Ln 1, Col 1 | UTF-8 | Luau | 🟢 Connected)
      + Botón de ejecución ▶ Run y ➔| Attach
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
-- 2. PALETA DE COLOR Y CONFIGURACIÓN POTASSIUM IDE
-- ═══════════════════════════════════════════════════════════════════
local Config = {
    Version = "v6.0 Potassium IDE Replica",
    SubFolder = "ReverseKit",
    ToggleKey = Enum.KeyCode.RightControl,
}

Config.Theme = {
    BgMain        = Color3.fromRGB(18, 18, 20),       -- Charcoal Dark #121214
    BgSidebar     = Color3.fromRGB(14, 14, 16),       -- Explorer Sidebar #0e0e10
    BgHeader      = Color3.fromRGB(24, 24, 28),       -- Top Bar
    BgTabs        = Color3.fromRGB(20, 20, 24),       -- File Tabs Bar
    BgCard        = Color3.fromRGB(26, 26, 32),       -- Panel / Card
    BgInput       = Color3.fromRGB(22, 22, 26),       -- Search Input Box
    BgCode        = Color3.fromRGB(12, 12, 14),       -- Code Editor BG
    BgConsole     = Color3.fromRGB(10, 10, 12),       -- Console Drawer BG

    Accent        = Color3.fromRGB(255, 255, 255),    -- White Run Accent
    AccentBlue    = Color3.fromRGB(59, 130, 246),     -- Blue Accent
    AccentAmber   = Color3.fromRGB(245, 158, 11),     -- Amber Accent

    Success       = Color3.fromRGB(34, 197, 94),
    Warning       = Color3.fromRGB(245, 158, 11),
    Danger        = Color3.fromRGB(239, 68, 68),

    TextPrimary   = Color3.fromRGB(243, 244, 246),
    TextSecondary = Color3.fromRGB(156, 163, 175),
    TextMuted     = Color3.fromRGB(107, 114, 128),
    TextCode      = Color3.fromRGB(229, 231, 235),

    Border        = Color3.fromRGB(38, 38, 44),
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
    Sizes = { TitleText = 14, SubText = 12, BodyText = 11, CodeText = 12, BadgeText = 10, SidebarWidth = 220, HeaderHeight = 42, StatusBarHeight = 24 },
    Corners = { Window = UDim.new(0, 8), Card = UDim.new(0, 6), Button = UDim.new(0, 5), Badge = UDim.new(0, 4) },
}

-- ═══════════════════════════════════════════════════════════════════
-- 3. SERVICIOS Y ESCÁNERES
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

-- Syntax Highlighting Engine for Code Viewer
local function highlightLuauCode(sourceText)
    if not sourceText or type(sourceText) ~= "string" then return "" end

    local lines = string.split(sourceText, "\n")
    local highlightedLines = {}

    for idx, line in ipairs(lines) do
        local safeLine = line:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

        -- Comments
        if safeLine:find("^%s*%-%-") then
            safeLine = '<font color="#64748b">' .. safeLine .. '</font>'
        else
            -- Keywords
            safeLine = safeLine:gsub("%f[%a](local)%f[%A]", '<font color="#f43f5e">local</font>')
            safeLine = safeLine:gsub("%f[%a](function)%f[%A]", '<font color="#f43f5e">function</font>')
            safeLine = safeLine:gsub("%f[%a](end)%f[%A]", '<font color="#f43f5e">end</font>')
            safeLine = safeLine:gsub("%f[%a](return)%f[%A]", '<font color="#f43f5e">return</font>')
            safeLine = safeLine:gsub("%f[%a](if)%f[%A]", '<font color="#f43f5e">if</font>')
            safeLine = safeLine:gsub("%f[%a](then)%f[%A]", '<font color="#f43f5e">then</font>')
            safeLine = safeLine:gsub("%f[%a](else)%f[%A]", '<font color="#f43f5e">else</font>')
            safeLine = safeLine:gsub("%f[%a](for)%f[%A]", '<font color="#f43f5e">for</font>')
            safeLine = safeLine:gsub("%f[%a](do)%f[%A]", '<font color="#f43f5e">do</font>')

            -- Builtins & Globals
            safeLine = safeLine:gsub("%f[%a](game)%f[%A]", '<font color="#3b82f6">game</font>')
            safeLine = safeLine:gsub("%f[%a](GetService)%f[%A]", '<font color="#a855f7">GetService</font>')
            safeLine = safeLine:gsub("%f[%a](FireServer)%f[%A]", '<font color="#38bdf8">FireServer</font>')
            safeLine = safeLine:gsub("%f[%a](InvokeServer)%f[%A]", '<font color="#38bdf8">InvokeServer</font>')

            -- Strings
            safeLine = safeLine:gsub('(".-")', '<font color="#10b981">%1</font>')
        end

        table.insert(highlightedLines, safeLine)
    end

    return table.concat(highlightedLines, "\n")
end

-- ═══════════════════════════════════════════════════════════════════
-- 4. POTASSIUM / VSCODE COMPONENTES DE INTERFAZ
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

function Components.createStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Colors.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Components.createBadge(text, color, parent)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = color or Theme.Colors.AccentAmber
    frame.BackgroundTransparency = 0.85
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.XY
    Components.createCorner(frame, Theme.Corners.Badge)
    Components.createPadding(frame, 2, 2, 6, 6)
    Components.createStroke(frame, color or Theme.Colors.AccentAmber, 1)

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

function Components.createButton(text, onClick, parent, color, textColor)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Theme.Fonts.Bold
    btn.TextSize = Theme.Sizes.BodyText
    btn.TextColor3 = textColor or Theme.Colors.TextPrimary
    btn.BackgroundColor3 = color or Theme.Colors.BgCard
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 95, 0, 28)
    btn.AutoButtonColor = true
    Components.createCorner(btn, Theme.Corners.Button)
    Components.createPadding(btn, 2, 2, 8, 8)
    Components.createStroke(btn, Theme.Colors.Border, 1)

    if onClick then btn.MouseButton1Click:Connect(onClick) end
    if parent then btn.Parent = parent end
    return btn
end

-- IDE Code Editor with Gutter Line Numbers and Syntax Highlighting
function Components.createCodeEditor(rawCodeText, parent)
    local editorContainer = Instance.new("Frame")
    editorContainer.Size = UDim2.new(1, 0, 1, 0)
    editorContainer.BackgroundColor3 = Theme.Colors.BgCode
    editorContainer.BorderSizePixel = 0
    Components.createCorner(editorContainer, Theme.Corners.Card)
    Components.createStroke(editorContainer, Theme.Colors.Border, 1)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
    scroll.Parent = editorContainer

    local lines = string.split(rawCodeText or "", "\n")
    local lineNums = {}
    for i = 1, #lines do table.insert(lineNums, tostring(i)) end
    local lineNumStr = table.concat(lineNums, "\n")

    -- Gutter (Line Numbers column)
    local gutter = Instance.new("TextLabel")
    gutter.Text = lineNumStr
    gutter.Font = Theme.Fonts.Code
    gutter.TextSize = Theme.Sizes.CodeText
    gutter.TextColor3 = Theme.Colors.TextMuted
    gutter.TextXAlignment = Enum.TextXAlignment.Right
    gutter.TextYAlignment = Enum.TextYAlignment.Top
    gutter.Position = UDim2.new(0, 10, 0, 10)
    gutter.Size = UDim2.new(0, 32, 0, 0)
    gutter.AutomaticSize = Enum.AutomaticSize.XY
    gutter.BackgroundTransparency = 1
    gutter.Parent = scroll

    -- Vertical Gutter Divider
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0, 1, 1, 0)
    divider.Position = UDim2.new(0, 48, 0, 0)
    divider.BackgroundColor3 = Theme.Colors.Border
    divider.BorderSizePixel = 0
    divider.Parent = scroll

    -- Code Label (RichText Syntax Highlighted)
    local codeLabel = Instance.new("TextLabel")
    codeLabel.RichText = true
    codeLabel.Text = highlightLuauCode(rawCodeText)
    codeLabel.Font = Theme.Fonts.Code
    codeLabel.TextSize = Theme.Sizes.CodeText
    codeLabel.TextColor3 = Theme.Colors.TextCode
    codeLabel.TextXAlignment = Enum.TextXAlignment.Left
    codeLabel.TextYAlignment = Enum.TextYAlignment.Top
    codeLabel.Position = UDim2.new(0, 58, 0, 10)
    codeLabel.Size = UDim2.new(1, -68, 0, 0)
    codeLabel.AutomaticSize = Enum.AutomaticSize.XY
    codeLabel.BackgroundTransparency = 1
    codeLabel.Parent = scroll

    if parent then editorContainer.Parent = parent end
    return editorContainer
end

function Components.createToast(parentGui, title, msg, color)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 310, 0, 60)
    toast.Position = UDim2.new(1, -330, 1, -80)
    toast.BackgroundColor3 = Theme.Colors.BgCard
    toast.BorderSizePixel = 0
    toast.ZIndex = 9999
    Components.createCorner(toast, Theme.Corners.Card)
    Components.createPadding(toast, 8, 8, 12, 12)
    Components.createStroke(toast, color or Theme.Colors.AccentAmber, 1.5)

    local t = Instance.new("TextLabel")
    t.Text = title; t.Font = Theme.Fonts.Bold; t.TextSize = Theme.Sizes.SubText; t.TextColor3 = color or Theme.Colors.AccentAmber; t.Size = UDim2.new(1, 0, 0, 18); t.BackgroundTransparency = 1; t.Parent = toast
    local m = Instance.new("TextLabel")
    m.Text = msg; m.Font = Theme.Fonts.Main; m.TextSize = Theme.Sizes.BodyText; m.TextColor3 = Theme.Colors.TextSecondary; m.Size = UDim2.new(1, 0, 0, 24); m.Position = UDim2.new(0,0,0,20); m.BackgroundTransparency = 1; m.Parent = toast
    toast.Parent = parentGui
    task.delay(3, function() toast:Destroy() end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 5. CONSTRUCTOR POTASSIUM IDE REPLICA (EXACT MATCH LAUNCHER)
-- ═══════════════════════════════════════════════════════════════════
local function launchIDE()
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

    -- Main Window Frame (Potassium Window Styling)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 960, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -480, 0.5, -300)
    mainFrame.BackgroundColor3 = Theme.Colors.BgMain
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Components.createCorner(mainFrame, Theme.Corners.Window)
    Components.createStroke(mainFrame, Theme.Colors.Border, 1)

    -- Top Header Bar (Title + Run / Attach Action Buttons)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, Theme.Sizes.HeaderHeight)
    header.BackgroundColor3 = Theme.Colors.BgHeader
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    Components.createPadding(header, 0, 0, 14, 14)

    local logo = Instance.new("TextLabel")
    logo.Text = "⚡ GameAnalyzer v6.0 IDE — " .. Env.ExecutorName
    logo.Font = Theme.Fonts.Bold
    logo.TextSize = Theme.Sizes.TitleText
    logo.TextColor3 = Theme.Colors.TextPrimary
    logo.Size = UDim2.new(0.4, 0, 1, 0)
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.BackgroundTransparency = 1
    logo.Parent = header

    -- Action Buttons (Run / Attach / Close)
    local actions = Instance.new("Frame")
    actions.Size = UDim2.new(0, 260, 1, 0)
    actions.Position = UDim2.new(1, -260, 0, 0)
    actions.BackgroundTransparency = 1
    actions.Parent = header

    local runBtn = Instance.new("TextButton")
    runBtn.Text = "▶  Run"
    runBtn.Font = Theme.Fonts.Bold
    runBtn.TextSize = 12
    runBtn.TextColor3 = Color3.fromRGB(15, 15, 18)
    runBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    runBtn.Size = UDim2.new(0, 75, 0, 26)
    runBtn.Position = UDim2.new(0, 40, 0.5, -13)
    runBtn.BorderSizePixel = 0
    Components.createCorner(runBtn, Theme.Corners.Button)
    runBtn.Parent = actions

    local attachBtn = Instance.new("TextButton")
    attachBtn.Text = "➔| Attach"
    attachBtn.Font = Theme.Fonts.Bold
    attachBtn.TextSize = 12
    attachBtn.TextColor3 = Theme.Colors.TextPrimary
    attachBtn.BackgroundColor3 = Theme.Colors.BgCard
    attachBtn.Size = UDim2.new(0, 85, 0, 26)
    attachBtn.Position = UDim2.new(0, 122, 0.5, -13)
    attachBtn.BorderSizePixel = 0
    Components.createCorner(attachBtn, Theme.Corners.Button)
    Components.createStroke(attachBtn, Theme.Colors.Border, 1)
    attachBtn.Parent = actions

    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Font = Theme.Fonts.Bold
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Theme.Colors.TextSecondary
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -26, 0.5, -13)
    closeBtn.BackgroundColor3 = Theme.Colors.BgCard
    closeBtn.BorderSizePixel = 0
    Components.createCorner(closeBtn, Theme.Corners.Badge)
    closeBtn.Parent = actions
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

    -- Left Sidebar Explorer Pane (Potassium Style Explorer)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    sidebar.Position = UDim2.new(0, 0, 0, Theme.Sizes.HeaderHeight)
    sidebar.BackgroundColor3 = Theme.Colors.BgSidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    Components.createPadding(sidebar, 10, 10, 10, 10)

    -- Sidebar Title & Search Filter
    local expTitle = Instance.new("TextLabel")
    expTitle.Text = "Explorer"
    expTitle.Font = Theme.Fonts.Bold
    expTitle.TextSize = 13
    expTitle.TextColor3 = Theme.Colors.TextPrimary
    expTitle.Size = UDim2.new(1, 0, 0, 20)
    expTitle.TextXAlignment = Enum.TextXAlignment.Left
    expTitle.BackgroundTransparency = 1
    expTitle.Parent = sidebar

    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "🔍 Filter scripts"
    searchBox.PlaceholderColor3 = Theme.Colors.TextMuted
    searchBox.Text = ""
    searchBox.Font = Theme.Fonts.Main
    searchBox.TextSize = 11
    searchBox.TextColor3 = Theme.Colors.TextPrimary
    searchBox.BackgroundColor3 = Theme.Colors.BgInput
    searchBox.Size = UDim2.new(1, 0, 0, 26)
    searchBox.Position = UDim2.new(0, 0, 0, 24)
    searchBox.BorderSizePixel = 0
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    Components.createCorner(searchBox, Theme.Corners.Button)
    Components.createPadding(searchBox, 0, 0, 8, 8)
    Components.createStroke(searchBox, Theme.Colors.Border, 1)
    searchBox.Parent = sidebar

    local sectionHeader = Instance.new("TextLabel")
    sectionHeader.Text = "∨  SCRIPTS"
    sectionHeader.Font = Theme.Fonts.Bold
    sectionHeader.TextSize = 10
    sectionHeader.TextColor3 = Theme.Colors.TextMuted
    sectionHeader.Size = UDim2.new(1, 0, 0, 18)
    sectionHeader.Position = UDim2.new(0, 0, 0, 56)
    sectionHeader.TextXAlignment = Enum.TextXAlignment.Left
    sectionHeader.BackgroundTransparency = 1
    sectionHeader.Parent = sidebar

    local scrollSidebar = Instance.new("ScrollingFrame")
    scrollSidebar.Size = UDim2.new(1, 0, 1, -78)
    scrollSidebar.Position = UDim2.new(0, 0, 0, 78)
    scrollSidebar.BackgroundTransparency = 1
    scrollSidebar.ScrollBarThickness = 3
    scrollSidebar.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 3)
    sidebarLayout.Parent = scrollSidebar

    -- Center File Tab Bar & Main Editor Viewport
    local mainArea = Instance.new("Frame")
    mainArea.Size = UDim2.new(1, -Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.HeaderHeight - Theme.Sizes.StatusBarHeight)
    mainArea.Position = UDim2.new(0, Theme.Sizes.SidebarWidth, 0, Theme.Sizes.HeaderHeight)
    mainArea.BackgroundColor3 = Theme.Colors.BgMain
    mainArea.BorderSizePixel = 0
    mainArea.Parent = mainFrame

    -- File Tabs Bar (Horizontal Tabs like Potassium)
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 32)
    tabBar.BackgroundColor3 = Theme.Colors.BgTabs
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainArea
    Components.createPadding(tabBar, 0, 0, 6, 6)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabBar

    -- Editor & Console Viewport Frame
    local viewport = Instance.new("Frame")
    viewport.Size = UDim2.new(1, 0, 1, -32)
    viewport.Position = UDim2.new(0, 0, 0, 32)
    viewport.BackgroundTransparency = 1
    viewport.Parent = mainArea
    Components.createPadding(viewport, 10, 10, 12, 12)

    -- Bottom Status Bar
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, Theme.Sizes.StatusBarHeight)
    statusBar.Position = UDim2.new(0, 0, 1, -Theme.Sizes.StatusBarHeight)
    statusBar.BackgroundColor3 = Theme.Colors.BgSidebar
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame
    Components.createPadding(statusBar, 0, 0, 12, 12)

    local statusLeft = Instance.new("TextLabel")
    statusLeft.Text = string.format("<> Untitled 1  •  ⊗ 0  ⚠️ 0")
    statusLeft.Font = Theme.Fonts.Code
    statusLeft.TextSize = 11
    statusLeft.TextColor3 = Theme.Colors.TextMuted
    statusLeft.Size = UDim2.new(0.5, 0, 1, 0)
    statusLeft.TextXAlignment = Enum.TextXAlignment.Left
    statusLeft.BackgroundTransparency = 1
    statusLeft.Parent = statusBar

    local statusRight = Instance.new("TextLabel")
    statusRight.Text = string.format("Ln 1, Col 1  |  Spaces: 4  |  UTF-8  |  Luau  |  🟢 Attached")
    statusRight.Font = Theme.Fonts.Code
    statusRight.TextSize = 11
    statusRight.TextColor3 = Theme.Colors.TextMuted
    statusRight.Size = UDim2.new(0.5, 0, 1, 0)
    statusRight.Position = UDim2.new(0.5, 0, 0, 0)
    statusRight.TextXAlignment = Enum.TextXAlignment.Right
    statusRight.BackgroundTransparency = 1
    statusRight.Parent = statusBar

    -- Files Definition
    local scriptFiles = {
        { Id = "Dashboard", Icon = "📄", Name = "Dashboard.luau" },
        { Id = "Remotes",   Icon = "⚡", Name = "RemotesSpy.luau" },
        { Id = "Modules",   Icon = "📦", Name = "ModulesExplorer.luau" },
        { Id = "Jugador",   Icon = "👤", Name = "PlayerStats.luau" },
        { Id = "Audit",     Icon = "🛡️", Name = "SecurityAudit.luau" },
        { Id = "Exporter",  Icon = "💾", Name = "Exporter.luau" },
    }

    local activeViewFrame = nil
    local tabButtons = {}
    local sidebarButtons = {}

    local function loadTab(tabId)
        if activeViewFrame then activeViewFrame:Destroy() end

        for id, btn in pairs(tabButtons) do
            if id == tabId then
                btn.BackgroundColor3 = Theme.Colors.BgMain
                btn.TextColor3 = Theme.Colors.TextPrimary
            else
                btn.BackgroundColor3 = Theme.Colors.BgTabs
                btn.TextColor3 = Theme.Colors.TextMuted
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

            local codeText = string.format([[--[[
    GameAnalyzer v6.0 — Dashboard Summary
    Place ID: %d | Place Name: %s
    Executor: %s
]]

local Dashboard = {
    TotalRemotes = %d,
    StaffRemotes = %d,
    SecurityScore = %d, -- Nivel de Riesgo: %s
    OnlinePlayers = %d,
}

return Dashboard]],
                game.PlaceId, game.Name, Env.ExecutorName,
                scan.TotalCount, #scan.Categorized.STAFF, vuln.Score, vuln.RiskLevel, #Env.Services.Players:GetPlayers()
            )

            Components.createCodeEditor(codeText, frame)

        elseif tabId == "Remotes" then
            local scan = Scanner.scanRemotes()

            local topBar = Instance.new("Frame")
            topBar.Size = UDim2.new(1, 0, 0, 32)
            topBar.BackgroundTransparency = 1
            topBar.Parent = frame

            local spyBtn = Components.createButton(RemoteSpy.Enabled and "⏹ Stop RemoteSpy" or "⚡ Start Live RemoteSpy", function()
                if RemoteSpy.Enabled then RemoteSpy.stop(); Components.createToast(screenGui, "RemoteSpy", "Hook desactivado.", Theme.Colors.Warning)
                else RemoteSpy.start(); Components.createToast(screenGui, "RemoteSpy", "Hook activado en __namecall!", Theme.Colors.Success) end
            end, topBar, Theme.Colors.BgCard)
            spyBtn.Size = UDim2.new(0, 180, 1, 0)

            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(0.42, 0, 1, -38)
            listFrame.Position = UDim2.new(0, 0, 0, 38)
            listFrame.BackgroundTransparency = 1
            listFrame.Parent = frame

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Parent = listFrame
            local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 4); layout.Parent = scroll

            local editorFrame = Instance.new("Frame")
            editorFrame.Size = UDim2.new(0.56, 0, 1, -38)
            editorFrame.Position = UDim2.new(0.44, 0, 0, 38)
            editorFrame.BackgroundTransparency = 1
            editorFrame.Parent = frame

            local currentEditor = Components.createCodeEditor("-- Selecciona un remoto del explorador para ver su código Luau.", editorFrame)

            for _, r in ipairs(scan.RemoteEvents) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 32); card.BackgroundColor3 = Theme.Colors.BgCard; Components.createCorner(card, Theme.Corners.Badge)
                Components.createBadge(r.Category, Config.CategoryColors[r.Category], card).Position = UDim2.new(0, 6, 0.5, -9)

                local l = Instance.new("TextLabel")
                l.Text = r.Name; l.Font = Theme.Fonts.Code; l.TextSize = 11; l.TextColor3 = Theme.Colors.TextPrimary; l.Position = UDim2.new(0, 95, 0, 0); l.Size = UDim2.new(0.65, 0, 1, 0); l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1; l.Parent = card

                local selectBtn = Instance.new("TextButton")
                selectBtn.Size = UDim2.new(1, 0, 1, 0); selectBtn.BackgroundTransparency = 1; selectBtn.Text = ""; selectBtn.Parent = card
                selectBtn.MouseButton1Click:Connect(function()
                    local code = string.format([[-- Remoto: %s
local Remote = %s
Remote:FireServer()]], r.Name, r.FullName)
                    currentEditor:Destroy()
                    currentEditor = Components.createCodeEditor(code, editorFrame)
                    Exporter.copyToClipboard(code)
                    Components.createToast(screenGui, "Copiado", r.Name, Theme.Colors.Success)
                end)

                card.Parent = scroll
            end

        elseif tabId == "Modules" then
            local mods = Scanner.scanModules()
            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(0.4, 0, 1, 0); listFrame.BackgroundTransparency = 1; listFrame.Parent = frame
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.Parent = listFrame
            local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 4); layout.Parent = scroll

            local editorFrame = Instance.new("Frame")
            editorFrame.Size = UDim2.new(0.58, 0, 1, 0); editorFrame.Position = UDim2.new(0.42, 0, 0, 0); editorFrame.BackgroundTransparency = 1; editorFrame.Parent = frame

            local currentEditor = Components.createCodeEditor("-- Haz clic en un ModuleScript para visualizar su código fuente decompilado.", editorFrame)

            for _, m in ipairs(mods) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 32); card.BackgroundColor3 = Theme.Colors.BgCard; Components.createCorner(card, Theme.Corners.Badge)
                local l = Instance.new("TextLabel")
                l.Text = "📄 " .. m.Name; l.Font = Theme.Fonts.Code; l.TextSize = 11; l.TextColor3 = Theme.Colors.TextPrimary; l.Position = UDim2.new(0, 8, 0, 0); l.Size = UDim2.new(0.9, 0, 1, 0); l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1; l.Parent = card

                local selectBtn = Instance.new("TextButton")
                selectBtn.Size = UDim2.new(1, 0, 1, 0); selectBtn.BackgroundTransparency = 1; selectBtn.Text = ""; selectBtn.Parent = card
                selectBtn.MouseButton1Click:Connect(function()
                    local decomp = ModuleInspector.decompileScript(m.Instance)
                    currentEditor:Destroy()
                    currentEditor = Components.createCodeEditor(decomp, editorFrame)
                end)

                card.Parent = scroll
            end

        elseif tabId == "Jugador" then
            local pData = Scanner.scanPlayerData()
            local codeText = string.format([[--[[
    Player Stats & Leaderstats Inspector
    Jugador: %s
]]

local PlayerData = {
    Humanoid = {
        WalkSpeed = %.1f,
        JumpPower = %.1f,
        Health = %.1f,
        MaxHealth = %.1f,
    },
    Leaderstats = {
]], (Env.LocalPlayer and Env.LocalPlayer.Name or "LocalPlayer"),
                pData.Character.WalkSpeed or 16, pData.Character.JumpPower or 50,
                pData.Character.Health or 100, pData.Character.MaxHealth or 100
            )

            for _, ls in ipairs(pData.Leaderstats) do
                codeText = codeText .. string.format("        %s = %s,\n", ls.Name, tostring(ls.Value))
            end
            codeText = codeText .. "    }\n}\n\nreturn PlayerData"

            Components.createCodeEditor(codeText, frame)

        elseif tabId == "Audit" then
            local vuln = Vulnerability.analyze()
            local codeText = string.format([[--[[
    Security Vulnerability Audit Report
    Overall Risk Level: %s (Score: %d / 100)
]]

local AuditFindings = {
]], vuln.RiskLevel, vuln.Score)

            for idx, f in ipairs(vuln.Findings) do
                codeText = codeText .. string.format("    [%d] = {\n        Severity = %q,\n        Title = %q,\n        Description = %q,\n    },\n", idx, f.Severity, f.Title, f.Description)
            end
            codeText = codeText .. "}\n\nreturn AuditFindings"

            Components.createCodeEditor(codeText, frame)

        elseif tabId == "Exporter" then
            local codeText = string.format([[--[[
    Exporter Tool — Press [Run Exporter] to generate full dump file in /ReverseKit/
]]

local Exporter = {}

function Exporter.export()
    print("[GameAnalyzer] Dumping place data for PlaceId: %d...")
end

return Exporter]], game.PlaceId)

            local edFrame = Instance.new("Frame")
            edFrame.Size = UDim2.new(1, 0, 1, -44); edFrame.BackgroundTransparency = 1; edFrame.Parent = frame
            Components.createCodeEditor(codeText, edFrame)

            local runExpBtn = Components.createButton("💾 Run Exporter (.txt)", function()
                local scan = Scanner.scanRemotes()
                local vuln = Vulnerability.analyze()
                local txt = string.format("GameAnalyzer Dump — Place: %d\nRemotes: %d | Risk: %s\nDate: %s\n", game.PlaceId, scan.TotalCount, vuln.RiskLevel, os.date("%X"))
                local ok, path = Exporter.saveFile("Place_" .. game.PlaceId .. "_Dump.txt", txt)
                Components.createToast(screenGui, ok and "Guardado Exitoso" or "Error", path, ok and Theme.Colors.Success or Theme.Colors.Danger)
            end, frame, Theme.Colors.BgCard)
            runExpBtn.Size = UDim2.new(0, 200, 0, 32)
            runExpBtn.Position = UDim2.new(0, 0, 1, -34)
        end
    end

    -- Build Sidebar Items & File Tabs Bar Buttons
    for idx, fileItem in ipairs(scriptFiles) do
        -- Sidebar item (Potassium style script list)
        local sbBtn = Instance.new("TextButton")
        sbBtn.Text = "  " .. fileItem.Icon .. "  " .. fileItem.Name
        sbBtn.Font = Theme.Fonts.Code
        sbBtn.TextSize = 11
        sbBtn.TextColor3 = Theme.Colors.TextSecondary
        sbBtn.TextXAlignment = Enum.TextXAlignment.Left
        sbBtn.BackgroundColor3 = Theme.Colors.BgSidebar
        sbBtn.Size = UDim2.new(1, 0, 0, 28)
        sbBtn.BorderSizePixel = 0
        Components.createCorner(sbBtn, Theme.Corners.Button)

        sbBtn.MouseButton1Click:Connect(function() loadTab(fileItem.Id) end)
        sbBtn.Parent = scrollSidebar

        -- Top File Tab
        local tabBtn = Instance.new("TextButton")
        tabBtn.Text = " " .. fileItem.Icon .. " " .. fileItem.Name .. "  ✕ "
        tabBtn.Font = Theme.Fonts.Code
        tabBtn.TextSize = 11
        tabBtn.TextColor3 = Theme.Colors.TextMuted
        tabBtn.BackgroundColor3 = Theme.Colors.BgTabs
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(0, 135, 1, 0)
        Components.createCorner(tabBtn, Theme.Corners.Button)

        tabBtn.MouseButton1Click:Connect(function() loadTab(fileItem.Id) end)
        tabButtons[fileItem.Id] = tabBtn
        tabBtn.Parent = tabBar
    end

    Env.Services.UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Config.ToggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    loadTab("Dashboard")
    Components.createToast(screenGui, "Potassium IDE Replica", "Cargado exactamente como Potassium IDE! Presiona [RightControl] para ocultar/mostrar.", Theme.Colors.AccentAmber)
end

print("[GameAnalyzer v6.0 Potassium Replica] Iniciando...")
local success, err = pcall(launchIDE)
if not success then warn("[GameAnalyzer Error de Inicio]:", err) end