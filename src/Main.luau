-- Main.luau
-- GameAnalyzer v6.0 IDE Edition — Framework Main Loader

local Env    = require(script.Parent.Core.Env)
local Config = require(script.Parent.Core.Config)
local IDE    = require(script.Parent.UI.IDE)

print("==========================================================")
print(string.format("[GameAnalyzer %s] Initializing for %s...", Config.Version, Env.ExecutorName))
print("==========================================================")

-- Launch UI
local ok, err = pcall(function()
    IDE.init()
end)

if not ok then
    warn("[GameAnalyzer] Error launching IDE UI:", err)
else
    print("[GameAnalyzer] IDE GUI launched successfully! Toggle with [RightControl].")
end
