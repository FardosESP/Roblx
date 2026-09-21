-- Services/ModuleInspector.luau
-- GameAnalyzer v6.0 IDE Edition — Safe Module Inspector & Decompiler Service

local Env    = require(script.Parent.Parent.Core.Env)
local Config = require(script.Parent.Parent.Core.Config)

local ModuleInspector = {}

function ModuleInspector.inspectModule(moduleInstance)
    local result = {
        Module = moduleInstance,
        Name = moduleInstance.Name,
        Path = moduleInstance:GetFullName(),
        Success = false,
        Type = "nil",
        Functions = {},
        Values = {},
        Tables = {},
        RawSource = nil,
        Error = nil,
    }

    -- Decompile source code if capability exists
    if Env.CAPS.decompile then
        pcall(function()
            result.RawSource = decompile(moduleInstance)
        end)
    end

    -- Safe require with 2.5s timeout
    local ok, value = Env.safeRequire(moduleInstance, 2.5)
    if not ok then
        result.Error = tostring(value)
        return result
    end

    result.Success = true
    result.Type = typeof(value)

    if result.Type == "table" then
        for k, v in pairs(value) do
            local vt = typeof(v)
            if vt == "function" then
                table.insert(result.Functions, tostring(k))
            elseif vt == "table" then
                local count = 0
                for _ in pairs(v) do count = count + 1 end
                table.insert(result.Tables, { Name = tostring(k), Count = count, Value = v })
            else
                table.insert(result.Values, { Name = tostring(k), Value = Env.serialize(v), Type = vt })
            end
        end
    end

    return result
end

function ModuleInspector.decompileScript(scriptInstance)
    if not Env.CAPS.decompile then
        return "-- Decompiler capability (decompile) is not supported by your current executor."
    end

    local code = nil
    local ok, err = pcall(function()
        code = decompile(scriptInstance)
    end)

    if ok and type(code) == "string" and #code > 0 then
        return code
    else
        return "-- Failed to decompile script: " .. tostring(err or "Empty output")
    end
end

return ModuleInspector
