--[[
    ════════════════════════════════════════════════════════════════════
    ⚡ GameAnalyzer v6.0 IDE Edition — Anti-Cache GitHub Remote Loader
    ════════════════════════════════════════════════════════════════════
    Evita la caché de Roblox HttpGet mediante query timestamp (?t=os.time())
    ════════════════════════════════════════════════════════════════════
]]

local GITHUB_RAW_URL = "https://raw.githubusercontent.com/FardosESP/Roblx/main/lechon.luau?t=" .. tostring(os.time())

print("[GameAnalyzer Anti-Cache] Descargando la versión más reciente desde GitHub...")

local ok, scriptContent = pcall(function()
    return game:HttpGet(GITHUB_RAW_URL)
end)

if not ok or not scriptContent or #scriptContent == 0 then
    error("[GameAnalyzer Loader Error] No se pudo descargar desde GitHub.")
end

local fn, err = loadstring(scriptContent)
if not fn then
    error("[GameAnalyzer Syntax Error] " .. tostring(err))
end

print("[GameAnalyzer Loader] Ejecución iniciada.")
fn()
