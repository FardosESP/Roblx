-- Services/Exporter.luau
-- GameAnalyzer v6.0 IDE Edition — Export Engine & File Saver

local Env    = require(script.Parent.Parent.Core.Env)
local Config = require(script.Parent.Parent.Core.Config)

local Exporter = {}

function Exporter.ensureFolder()
    if Env.CAPS.makefolder then
        pcall(makefolder, Config.SubFolder)
    end
end

function Exporter.saveFile(filename, content)
    if not Env.CAPS.writefile then
        return false, "writefile capability is not supported on this executor."
    end

    Exporter.ensureFolder()
    local path = Config.SubFolder .. "/" .. filename

    local ok, err = pcall(writefile, path, content)
    if ok then
        return true, path
    else
        return false, tostring(err)
    end
end

function Exporter.copyToClipboard(text)
    if Env.CAPS.setclipboard then
        local ok, err = pcall(setclipboard, text)
        return ok, err
    end
    return false, "setclipboard not available"
end

function Exporter.generateTextDump(scanData, vulnData)
    local lines = {}
    local function add(s) table.insert(lines, s or "") end

    add("================================================================")
    add("  GameAnalyzer " .. Config.Version .. " — Full Place Analysis Report")
    add("================================================================")
    add("Date/Time:       " .. os.date("%Y-%m-%d %H:%M:%S"))
    add("Executor:        " .. Env.ExecutorName)
    add("Place ID:        " .. tostring(game.PlaceId))
    add("Place Name:      " .. tostring(game.Name))
    add("Game ID:         " .. tostring(game.GameId))
    add("Job ID:          " .. tostring(game.JobId))
    add("Creator ID:      " .. tostring(game.CreatorId))
    add("Players:         " .. #Env.Services.Players:GetPlayers() .. "/" .. tostring(Env.Services.Players.MaxPlayers))
    add("")

    add("================================================================")
    add("  1. SECURITY AUDIT SUMMARY")
    add("================================================================")
    add("Overall Risk Level: " .. vulnData.RiskLevel)
    add("Security Score:     " .. vulnData.Score .. "/100")
    add("")
    add("Findings:")
    for idx, finding in ipairs(vulnData.Findings) do
        add(string.format("  [%d] [%s] %s", idx, finding.Severity, finding.Title))
        add("      " .. finding.Description)
        add("      Impact: " .. finding.Impact)
        add("")
    end

    add("================================================================")
    add("  2. REMOTES SUMMARY (Total: " .. scanData.TotalCount .. ")")
    add("================================================================")
    for cat, remotes in pairs(scanData.Categorized) do
        if #remotes > 0 then
            add(string.format("  [%s] (%d remotes)", cat, #remotes))
            for _, r in ipairs(remotes) do
                add("    - [" .. r.ClassName .. "] " .. r.FullName)
            end
            add("")
        end
    end

    return table.concat(lines, "\n")
end

return Exporter
