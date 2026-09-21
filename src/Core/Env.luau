-- Core/Env.luau
-- GameAnalyzer v6.0 IDE Edition — Executor Environment & Capability Matrix

local Env = {}

-- Services
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

-- Executor Identification
Env.ExecutorName = "Unknown Executor"
pcall(function()
    if type(identifyexecutor) == "function" then
        Env.ExecutorName = identifyexecutor()
    elseif type(getexecutorname) == "function" then
        Env.ExecutorName = getexecutorname()
    end
end)

-- Capability detection helper (checks _G, getfenv, getgenv)
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

-- Capability Matrix
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
    getscriptenv         = hasFn("getscriptenv"),
    getscriptclosure     = hasFn("getscriptclosure"),
    setthreadidentity    = hasFn("setthreadidentity"),
    getthreadidentity    = hasFn("getthreadidentity"),
    getupvalues          = hasFn("getupvalues"),
    getconstants         = hasFn("getconstants"),
    getprotos            = hasFn("getprotos"),
}

-- Safe Serializer
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

-- Safe Require with Timeout
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
        local ok, val = pcall(require, module)
        if ok then
            result = val
        else
            err = val
        end
        done = true
    end)
    local t0 = os.clock()
    while not done and (os.clock() - t0) < timeoutSeconds do
        task.wait(0.03)
    end
    if not done then
        pcall(task.cancel, thread)
        return false, "Timeout (> " .. tostring(timeoutSeconds) .. "s)"
    end
    if err then
        return false, tostring(err)
    end
    return true, result
end

-- Safe InvokeServer with Timeout
function Env.safeInvoke(rf, ...)
    local args = {...}
    local result, done, err = nil, false, nil
    local thread = task.spawn(function()
        local ok, val = pcall(function()
            return rf:InvokeServer(table.unpack(args))
        end)
        if ok then
            result = val
        else
            err = val
        end
        done = true
    end)
    local t0 = os.clock()
    while not done and (os.clock() - t0) < 4.0 do
        task.wait(0.03)
    end
    if not done then
        pcall(task.cancel, thread)
        return false, "Timeout"
    end
    if err then return false, tostring(err) end
    return true, result
end

return Env
