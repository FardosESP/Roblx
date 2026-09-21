-- Services/MemoryScanner.luau
-- GameAnalyzer v6.0 IDE Edition — Deep GC & Nil Instances Scanner

local Env    = require(script.Parent.Parent.Core.Env)
local Config = require(script.Parent.Parent.Core.Config)

local MemoryScanner = {}

function MemoryScanner.scanNilInstances()
    local results = {
        OrphanRemotes = {},
        OrphanScripts = {},
        OtherNilInstances = {},
        Total = 0,
    }

    if not Env.CAPS.getnilinstances then
        return results, "getnilinstances not available"
    end

    pcall(function()
        for _, inst in ipairs(getnilinstances()) do
            results.Total = results.Total + 1
            if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") or inst:IsA("BindableEvent") then
                table.insert(results.OrphanRemotes, {
                    Name = inst.Name,
                    ClassName = inst.ClassName,
                    Instance = inst,
                })
            elseif inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
                table.insert(results.OrphanScripts, {
                    Name = inst.Name,
                    ClassName = inst.ClassName,
                    Instance = inst,
                })
            else
                if #results.OtherNilInstances < 100 then
                    table.insert(results.OtherNilInstances, {
                        Name = inst.Name,
                        ClassName = inst.ClassName,
                    })
                end
            end
        end
    end)

    return results
end

function MemoryScanner.scanGC()
    local results = {
        FunctionsCount = 0,
        TablesCount = 0,
        AntiCheatKeywords = {},
        NetworkTables = {},
        GlobalVars = {},
    }

    if not Env.CAPS.getgc then
        return results, "getgc not available"
    end

    pcall(function()
        local gc = getgc(true)
        for _, item in ipairs(gc) do
            local t = typeof(item)
            if t == "function" then
                results.FunctionsCount = results.FunctionsCount + 1
            elseif t == "table" then
                results.TablesCount = results.TablesCount + 1

                -- Check for suspicious anti-cheat or network tables
                for k, v in pairs(item) do
                    local keyStr = tostring(k):lower()
                    if keyStr:find("anticheat") or keyStr:find("cheat") or keyStr:find("exploit") or keyStr:find("banwave") then
                        table.insert(results.AntiCheatKeywords, { Key = tostring(k), Value = Env.serialize(v) })
                        if #results.AntiCheatKeywords >= 25 then break end
                    end
                end
            end
        end
    end)

    return results
end

return MemoryScanner
