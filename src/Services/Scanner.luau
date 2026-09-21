-- Services/Scanner.luau
-- GameAnalyzer v6.0 IDE Edition — Hierarchy & Remote Categorization Engine

local Env    = require(script.Parent.Parent.Core.Env)
local Config = require(script.Parent.Parent.Core.Config)

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

    if fullPath:find("voldexadmin", 1, true) or fullPath:find("apexdashboard", 1, true) or fullPath:find("staffconsole", 1, true) then
        return "STAFF"
    end
    if fullPath:find("integritycheck", 1, true) then
        return "ANTICHEAT"
    end

    for cat, patterns in pairs(Scanner.RemoteCategories) do
        for _, pat in ipairs(patterns) do
            if name:find(pat, 1, true) or fullPath:find(pat, 1, true) then
                return cat
            end
        end
    end

    return "OTHER"
end

function Scanner.scanRemotes()
    local results = {
        RemoteEvents = {},
        RemoteFunctions = {},
        BindableEvents = {},
        BindableFunctions = {},
        UnreliableRemotes = {},
        Categorized = {},
        TotalCount = 0,
    }

    for cat, _ in pairs(Scanner.RemoteCategories) do
        results.Categorized[cat] = {}
    end
    results.Categorized["OTHER"] = {}

    local descendants = game:GetDescendants()
    for _, v in ipairs(descendants) do
        local entry = {
            Instance = v,
            Name = v.Name,
            FullName = v:GetFullName(),
            ClassName = v.ClassName,
            Category = "OTHER",
        }

        if v:IsA("RemoteEvent") then
            entry.Category = Scanner.categorizeRemote(v)
            table.insert(results.RemoteEvents, entry)
            table.insert(results.Categorized[entry.Category], entry)
            results.TotalCount = results.TotalCount + 1
        elseif v:IsA("RemoteFunction") then
            entry.Category = Scanner.categorizeRemote(v)
            table.insert(results.RemoteFunctions, entry)
            table.insert(results.Categorized[entry.Category], entry)
            results.TotalCount = results.TotalCount + 1
        elseif v:IsA("UnreliableRemoteEvent") then
            entry.Category = Scanner.categorizeRemote(v)
            table.insert(results.UnreliableRemotes, entry)
            table.insert(results.Categorized[entry.Category], entry)
            results.TotalCount = results.TotalCount + 1
        elseif v:IsA("BindableEvent") then
            table.insert(results.BindableEvents, entry)
        elseif v:IsA("BindableFunction") then
            table.insert(results.BindableFunctions, entry)
        end
    end

    return results
end

function Scanner.scanModules()
    local modules = {}
    local rs = Env.Services.ReplicatedStorage

    for _, v in ipairs(rs:GetDescendants()) do
        if v:IsA("ModuleScript") then
            table.insert(modules, {
                Instance = v,
                Name = v.Name,
                FullName = v:GetFullName(),
                ParentName = v.Parent and v.Parent.Name or "None",
            })
        end
    end

    return modules
end

function Scanner.scanPlayerData()
    local data = {
        Leaderstats = {},
        Attributes = {},
        Character = {},
        Currencies = {},
    }

    local lp = Env.LocalPlayer
    if not lp then return data end

    -- Leaderstats
    local ls = lp:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            table.insert(data.Leaderstats, {
                Name = child.Name,
                ClassName = child.ClassName,
                Value = pcall(function() return child.Value end) and child.Value or nil,
            })
        end
    end

    -- Player Attributes
    for k, v in pairs(lp:GetAttributes()) do
        table.insert(data.Attributes, { Name = k, Value = Env.serialize(v) })
    end

    -- Character
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            data.Character.WalkSpeed = hum.WalkSpeed
            data.Character.JumpPower = hum.JumpPower
            data.Character.Health    = hum.Health
            data.Character.MaxHealth = hum.MaxHealth
        end
    end

    return data
end

return Scanner
