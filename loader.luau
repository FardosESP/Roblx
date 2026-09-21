--[[
    ════════════════════════════════════════════════════════════════════
    ⚡ GameAnalyzer v6.0 IDE Edition — GitHub Remote Loader
    ════════════════════════════════════════════════════════════════════
    Sustituye 'USERNAME/REPO' con tu usuario y repositorio de GitHub.
    ════════════════════════════════════════════════════════════════════
]]

local REPO_URL = "https://raw.githubusercontent.com/USERNAME/REPO/main/src/"

local function loadRemoteModule(path)
    local url = REPO_URL .. path
    local ok, content = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or not content then
        error("[GameAnalyzer Loader] Error al cargar módulo desde GitHub: " .. path)
    end

    local fn, err = loadstring(content)
    if not fn then
        error("[GameAnalyzer Loader] Error de sintaxis en módulo: " .. path .. " -> " .. tostring(err))
    end

    return fn()
end

print("[GameAnalyzer] Cargando entorno modular desde GitHub...")

-- Carga remota secuencial
local Env = loadRemoteModule("Core/Env.luau")
local Config = loadRemoteModule("Core/Config.luau")

print("[GameAnalyzer] Entorno cargado. Iniciando GUI...")
local Main = loadRemoteModule("Main.luau")
