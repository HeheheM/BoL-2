--[[
    
    AUTHOR iCreative
    Credits to:
    lag free circles writers
    Aroc for ScriptUpdate :)
    GetSpell function from Extragoz
]]
local AUTOUPDATES = true -- CHANGE THIS TO FALSE IF YOU DON'T WANT AUTOUPDATES
local SCRIPTSTATUS = true
local scriptname = "The Ball Is Angry"
local author = "iCreative"
local version = 0.36
local champion = "Orianna"
if myHero.charName:lower() ~= champion:lower() then return end
local igniteslot = nil
local Passive = { Damage = function(target) return getDmg("P", target, myHero) end, IsReady = false}
local AA = { Range = function(target) 
local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end
return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end, Damage = function(target) return getDmg("AD", target, myHero) end }
local Q = { Range = 825, Width = 130, Delay = 0.25, Speed = 1400, Type = "linear", LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end}
local W = { Range = 225, Width = 225, Delay = 0.15, Speed = math.huge, Type = "circular", LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
local E = { Range = 1095, Width = 85, Delay = 0.15, Speed = 1700, Type = "linear", LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end, Missile = nil}
local R = { Range = 370, Width = 370, Delay = 0.3, Speed = math.huge, Type = "circular", LastCastTime = 0, Collision = false, Aoe = true, ControlPressed = false, Sent = 0, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}
local Ignite = { Range = 600, IsReady = function() return (igniteslot ~= nil and myHero:CanUseSpell(igniteslot) == READY) end, Damage = function(target) return getDmg("IGNITE", target, myHero) end}
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}
local CastableItems = {
Tiamat      = { Range = 400, Slot = function() return GetInventorySlotItem(3077) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3077) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) end, Damage = function(target) return getDmg("TIAMAT", target, myHero) end},
Hydra       = { Range = 400, Slot = function() return GetInventorySlotItem(3074) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3074) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) end, Damage = function(target) return getDmg("HYDRA", target, myHero) end},
Bork        = { Range = 450, Slot = function() return GetInventorySlotItem(3153) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end, Damage = function(target) return getDmg("RUINEDKING", target, myHero) end},
Bwc         = { Range = 400, Slot = function() return GetInventorySlotItem(3144) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end, Damage = function(target) return getDmg("BWC", target, myHero) end},
Hextech     = { Range = 400, Slot = function() return GetInventorySlotItem(3146) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3146) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY) end, Damage = function(target) return getDmg("HXG", target, myHero) end},
Blackfire   = { Range = 750, Slot = function() return GetInventorySlotItem(3188) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3188) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3188)) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", target, myHero) end},
Youmuu      = { Range = 350, Slot = function() return GetInventorySlotItem(3142) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
Randuin     = { Range = 500, Slot = function() return GetInventorySlotItem(3143) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
TwinShadows = { Range = 1000, Slot = function() return GetInventorySlotItem(3023) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3023) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3023)) == READY) end, Damage = function(target) return 0 end},
}

local Wards = {
Wriggle         = { Range = 600, Slot = GetInventorySlotItem(3154), IsReady = function() return (GetInventorySlotItem(3154) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3154)) == READY) end },
TrinketTotem1   = { Range = 600, Slot = GetInventorySlotItem(3340), IsReady = function() return (GetInventorySlotItem(3340) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3340)) == READY) end },
TrinketTotem2   = { Range = 600, Slot = GetInventorySlotItem(3350), IsReady = function() return (GetInventorySlotItem(3350) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3350)) == READY) end },
Ruby_SightStone = { Range = 600, Slot = GetInventorySlotItem(2045), IsReady = function() return (GetInventorySlotItem(2045) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2045)) == READY) end },
SightStone      = { Range = 600, Slot = GetInventorySlotItem(2049), IsReady = function() return (GetInventorySlotItem(2049) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2049)) == READY) end },
TrinketTotem3   = { Range = 600, Slot = GetInventorySlotItem(3361), IsReady = function() return (GetInventorySlotItem(3361) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3361)) == READY) end },
TrinketTotem4   = { Range = 600, Slot = GetInventorySlotItem(3362), IsReady = function() return (GetInventorySlotItem(3362) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3362)) == READY) end },
TrinketTotem5   = { Range = 600, Slot = GetInventorySlotItem(3166), IsReady = function() return (GetInventorySlotItem(3166) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3166)) == READY) end },
Stealth         = { Range = 600, Slot = GetInventorySlotItem(2044), IsReady = function() return (GetInventorySlotItem(2044) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2044)) == READY) end },
Vision          = { Range = 600, Slot = GetInventorySlotItem(2043), IsReady = function() return (GetInventorySlotItem(2043) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(2043)) == READY) end },
}

local scriptLoaded = false

local attack = true
local move = true

local OrbLoaded = ""
local Colors = { 
    -- O R G B
    Green =  ARGB(255, 0, 255, 0), 
    Yellow =  ARGB(255, 255, 255, 0),
    Red =  ARGB(255,255,0,0),
    White =  ARGB(255, 255, 255, 255),
    Blue =  ARGB(255,0,0,255),
}

function PrintMessage(message) 
    print("<font color=\"#6699ff\"><b>" .. scriptname .. ":</b></font> <font color=\"#FFFFFF\">" .. message .. "</font>") 
end

function CheckUpdate()
    if AUTOUPDATES then
        local ToUpdate = {}
        ToUpdate.ScriptName = scriptname
        ToUpdate.Version = version
        ToUpdate.UseHttps = true
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.Host2 = "raw.github.com"
        ToUpdate.VersionPath = "/jachicao/BoL/master/version/Orianna.version"
        ToUpdate.ScriptPath = "/jachicao/BoL/master/Orianna.lua"
        ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
        ToUpdate.CallbackUpdate = function(NewVersion, OldVersion) PrintMessage("Updated to "..NewVersion..". Please reload with 2x F9.") end
        ToUpdate.CallbackNoUpdate = function(OldVersion) PrintMessage("No Updates Found.") end
        ToUpdate.CallbackNewVersion = function(NewVersion) PrintMessage("New Version found ("..NewVersion..").") end
        ToUpdate.CallbackError = function(NewVersion) PrintMessage("Error while downloading.") end
        _ScriptUpdate(ToUpdate.Version, ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
    end
end


function OnLoad()
    local r = _Required()
    r:Add("VPrediction", "lua", "raw.githubusercontent.com/SidaBoL/Scripts/master/Common/VPrediction.lua", true)
    --if VIP_USER then r:Add("Prodiction", "lua", "bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/master/Test/Prodiction/Prodiction.lua", true) end
    --if VIP_USER then r:Add("DivinePred", "luac", "divinetek.rocks/divineprediction/DivinePred.luac", false) end
    --if VIP_USER then r:Add("DivinePred", "lua", "divinetek.rocks/divineprediction/DivinePred.lua", false) end
    r:Check()
    if r:IsDownloading() then return end
    DelayAction(function() CheckUpdate() end, 5)
    LoadVariables()
    LoadMenu()
end

function LoadVariables()
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then igniteslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then igniteslot = SUMMONER_2
    end
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, Q.Range + W.Width, DAMAGE_MAGIC)
    DelayAction(arrangePrioritys, 5)
    PredictionTable = {}
    if FileExist(LIB_PATH.."VPrediction.lua") then VP = VPrediction() table.insert(PredictionTable, "VPrediction") end
    --if VIP_USER and FileExist(LIB_PATH.."Prodiction.lua") then require "Prodiction" table.insert(PredictionTable, "Prodiction") end 
    if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then require "DivinePred" DP = DivinePred() table.insert(PredictionTable, "DivinePred") end
    prediction = Prediction()
    damage = Damage()
    initiator = Initiator()
    interrupt = Interrupt()
    ball = BallManager()
    orbwalker = Orbwalker()
    if VIP_USER then HookPackets() end
    Config = scriptConfig(scriptname.." by "..author, scriptname.."version1.00")
    EnemyMinions = minionManager(MINION_ENEMY, Q.Range + W.Width, myHero, MINION_SORT_MAXHEALTH_DEC)
    JungleMinions = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)
    DelayAction(OrbLoad, 1)
end

local PredictionLevel = 0

function LoadMenu()

    
    Config:addTS(ts)

    Config:addSubMenu(champion.." - Combo Settings", "Combo")
        Config.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useW", "Use W If Enemies >= ", SCRIPT_PARAM_SLICE, 1, 0, 5)
        Config.Combo:addParam("useE","Use E For Damage", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useE2","Use E If % Health <=", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
        Config.Combo:addParam("useR","Use R If Killable", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useR2","Use R If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5)
        Config.Combo:addParam("useIgnite","Use Ignite If Killable", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(champion.." - Harass Settings", "Harass")
        Config.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        Config.Harass:addParam("useE","Use E For Damage", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("useE2","Use E If % Health <=", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
        Config.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    Config:addSubMenu(champion.." - LaneClear Settings", "LaneClear")
        Config.LaneClear:addParam("useQ", "Use Q If Hit >= ", SCRIPT_PARAM_SLICE, 3, 0, 10)
        Config.LaneClear:addParam("useW", "Use W If Hit >=", SCRIPT_PARAM_SLICE, 3, 0, 10)
        Config.LaneClear:addParam("useE", "Use E If Hit >=", SCRIPT_PARAM_SLICE, 3, 0, 10)
        Config.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    Config:addSubMenu(champion.." - JungleClear Settings", "JungleClear")
        Config.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(champion.." - LastHit Settings", "LastHit")
        Config.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.LastHit:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Config.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    Config:addSubMenu(champion.." - KillSteal Settings", "KillSteal")
        Config.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        Config.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(champion.." - Auto Settings", "Auto")
        initiator:LoadMenu(Config.Auto)
        interrupt:LoadMenu(Config.Auto)
        Config.Auto:addParam("useW", "Use W If >= ", SCRIPT_PARAM_SLICE, 3, 0, 5)
        Config.Auto:addParam("useR", "Use R If >= ", SCRIPT_PARAM_SLICE, 4, 0, 5)


    Config:addSubMenu(champion.." - Misc Settings", "Misc")
        Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then Config.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.2, 0, 1, 1) end
        Config.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        if VIP_USER then Config.Misc:addParam("BlockR", "Block R If Will Not Hit", SCRIPT_PARAM_ONOFF, true) end
        Config.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(champion.." - Drawing Settings", "Draw")
        draw = Draw()
        draw:LoadMenu(Config.Draw)

    Config:addSubMenu(champion.." - Key Settings", "Keys")
        Config.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        Config.Keys:addParam("HarassToggle", "Harass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
        Config.Keys:addParam("Clear", "LaneClear or JungleClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        Config.Keys:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        Config.Keys:addParam("Run", "Run", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))

        Config.Keys:permaShow("HarassToggle")

        Config.Keys.Combo = false
        Config.Keys.Harass = false
        Config.Keys.Clear = false
        Config.Keys.HarassToggle = false


    PrintMessage("Script by "..author..", Have Fun!.")
    scriptLoaded = true
end


function Checks()
    ts.range = _GetRange()
end

local LastRequest = 0

function Auto()
    if W.IsReady() and Config.Auto.useW > 0 and #ball:ObjectsInArea(W.Range, W.Delay, GetEnemyHeroes()) >= Config.Auto.useW then
        CastSpell(_W)
    end
    if R.IsReady() and Config.Auto.useR > 0 and #ball:ObjectsInArea(R.Range, R.Delay, GetEnemyHeroes()) >= Config.Auto.useR then
        CastSpell(_R)
    end
end

function OnTick()
    if myHero.dead or not scriptLoaded then return end
    ts.target = GetCustomTarget()
    Checks()
    --if not prediction:ValidRequest() then return end
    if Config.KillSteal.useQ or Config.KillSteal.useW or Config.KillSteal.useE or Config.KillSteal.useR or Config.KillSteal.useIgnite then KillSteal() end

    if ValidTarget(ts.target) and (Config.Auto.useW > 0 or Config.Auto.useR > 0) then Auto() end

    if Config.Keys.Combo then Combo()
    elseif Config.Keys.Harass then Harass()
    elseif Config.Keys.Clear then Clear()
    elseif Config.Keys.LastHit then LastHit() end

    if Config.Keys.HarassToggle then Harass() end

    if Config.Keys.Run then Run() end

end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, ts.range) and enemy.visible and enemy.health > 0 and enemy.health/enemy.maxHealth < 0.5 then
            local q, w, e, r, dmg = damage:getBestCombo(enemy)
            if dmg >= enemy.health and enemy.health > 0 then
                if Q.IsReady() and Config.KillSteal.useQ and (q or Q.Damage(enemy) > enemy.health) and not enemy.dead then CastQ(enemy) end
                if W.IsReady() and Config.KillSteal.useW and (w or W.Damage(enemy) > enemy.health) and not enemy.dead then CastW(enemy) end
                if E.IsReady() and Config.KillSteal.useE and (e or E.Damage(enemy) > enemy.health) and not enemy.dead then CastE(enemy) end
                if R.IsReady() and Config.KillSteal.useR and (r or R.Damage(enemy) > enemy.health) and not enemy.dead then CastR(enemy) end
                if (((w or W.Damage(enemy) > enemy.health) and Config.KillSteal.useW) or ((r or R.Damage(enemy) > enemy.health) and Config.KillSteal.useR)) and (Config.KillSteal.useQ or Config.KillSteal.useE) and not enemy.dead then ThrowBallTo(enemy, R.Width) end
            end
            if Config.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and enemy.health > 0 and ValidTarget(enemy, Ignite.Range) then CastSpell(igniteslot, enemy) end
        end
    end
end

function Run()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if E.IsReady() and GetDistanceSqr(Vector(ball.Position.x, 0 , ball.Position.z), Vector(myHero.x, 0 , myHero.z)) > W.Width * W.Width then
        CastE(myHero)
    elseif Q.IsReady() and GetDistanceSqr(Vector(ball.Position.x, 0 , ball.Position.z), Vector(myHero.x, 0 , myHero.z)) > W.Width * W.Width then
        CastSpell(_Q, myHero.x, myHero.z)
    end

    if W.IsReady() and GetDistanceSqr(Vector(ball.Position.x, 0 , ball.Position.z), Vector(myHero.x, 0 , myHero.z)) < W.Width * W.Width then
        CastSpell(_W)
    end
end

function Combo()
    local target = ts.target
    if ValidTarget(target) then
        if Config.Combo.useIgnite and Ignite.IsReady() and ValidTarget(target, Ignite.Range) then 
            local q, w, e, r, dmg = damage:getBestCombo(target)
            if dmg >= target.health and target.health > 0 then
                CastSpell(igniteslot, target)
            end
        end
        if Config.Combo.useE then
            CastE(target)
        end

        if Config.Combo.useE2 > 0 and myHero.health/myHero.maxHealth * 100 <= Config.Combo.useE2 then
            CastE(myHero)
        end

        if Config.Combo.useQ then 
            CastQ(target) 
        end
        if W.IsReady() and Config.Combo.useW > 0 and #ball:ObjectsInArea(W.Range, W.Delay, GetEnemyHeroes()) >= Config.Combo.useW then
            CastSpell(_W)
        end
        if Config.Combo.useR then
            local q, w, e, r, dmg = damage:getBestCombo(target)
            if dmg >= target.health and r then
                CastR(target)
            end
        end
        if R.IsReady() and Config.Combo.useR2 > 0 and Config.Combo.useR2 <= #ball:ObjectsInArea(R.Range, R.Delay, GetEnemyHeroes()) then
            CastSpell(_R)
        end
    end
end

function GetAARange(unit)
    return ValidTarget(unit) and unit.range + unit.boundingRadius + myHero.boundingRadius / 2 or 0
end

function Harass()
    local target = ts.target
    if ValidTarget(target) and myHero.mana/myHero.maxMana * 100 >= Config.Harass.Mana then
        if Config.Harass.useE then CastE(target) end
        if Config.Harass.useE2 > 0 and myHero.health/myHero.maxHealth * 100 <= Config.Harass.useE2 and ValidTarget(target, GetAARange(target)) then CastE(myHero) end
        if Config.Harass.useW then CastW(target) end
        if Config.Harass.useQ then CastQ(target) end
    end
end


local LastFarmRequest = 0

function Clear()
    if myHero.mana/myHero.maxMana * 100 >= Config.LaneClear.Mana then
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            if ValidTarget(minion, Q.Range + W.Width) and os.clock() - LastFarmRequest > 0.2 then 
                if Config.LaneClear.useE > 0 and E.IsReady() then
                    local BestPos, Count = BestHitE(EnemyMinions.objects)
                    if BestPos~=nil and Config.LaneClear.useE <= Count then
                        CastE(BestPos)
                    end
                end

                if Config.LaneClear.useQ > 0 and Q.IsReady() then
                    local BestPos, Count = GetBestLinePosition(Q.Range, Q.Width, EnemyMinions.objects)
                    if BestPos~=nil and Config.LaneClear.useQ <= Count then
                        CastQ(BestPos)
                    end
                end

                if Config.LaneClear.useW > 0 and W.IsReady() then
                    local Count = #ball:ObjectsInArea(W.Range, W.Delay, EnemyMinions.objects)
                    if Config.LaneClear.useW <= Count then 
                        CastSpell(_W)
                    end
                end
                LastFarmRequest = os.clock()
            end
        end
    end

    JungleMinions:update()
    for i, minion in pairs(JungleMinions.objects) do
        if ValidTarget(minion, Q.Range + W.Width) then 
            if Config.JungleClear.useE and E.IsReady() then
                CastE(minion)
            end

            if Config.JungleClear.useQ and Q.IsReady() then
                CastSpell(_Q, minion.x, minion.z)
            end

            if Config.JungleClear.useW and W.IsReady() then
                CastW(minion)
            end
        end
    end
end

function LastHit()
    if myHero.mana/myHero.maxMana * 100 >= Config.LastHit.Mana and os.clock() - LastFarmRequest > 0.05 then
        EnemyMinions:update()
        for i, minion in pairs(EnemyMinions.objects) do
            if ((not ValidTarget(minion, AA.Range(minion))) or (ValidTarget(minion, AA.Range(minion)) and GetDistanceSqr(minion, orbwalker.target) > 50 * 50  and not orbwalker:CanAttack() and orbwalker:CanMove())) and not minion.dead then
                if W.IsReady() and Config.LastHit.useW and not minion.dead then
                    local dmg = W.Damage(minion)
                    local time = W.Delay
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth then
                        CastW(minion)
                    end
                end
                if Q.IsReady() and Config.LastHit.useQ and ValidTarget(minion, Q.Range + Q.Width) and not minion.dead then
                    local dmg = Q.Damage(minion)
                    local time = Q.Delay + GetDistance(Vector(minion.x, 0, minion.z), Vector(ball.Position.x, 0 , ball.Position.z)) / Q.Speed + orbwalker:Latency() - 100/100
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth and predHealth > -40 then
                        CastSpell(_Q, minion.x, minion.z)
                    end
                end
                if E.IsReady() and Config.LastHit.useE and GetDistanceSqr(myHero, ball.Position) > 50 * 50 and GetDistanceSqr(myHero, ball.Position) > GetDistanceSqr(myHero, minion) and not minion.dead then
                    local dmg = E.Damage(minion)
                    local time = E.Delay + GetDistance(Vector(minion.x, 0, minion.z), Vector(ball.Position.x, 0 , ball.Position.z)) / E.Speed + orbwalker:Latency() - 100/100
                    local predHealth, a, b = VP:GetPredictedHealth(minion, time, 0)
                    if dmg > predHealth and predHealth > -40 then
                        local Position = prediction:GetPredictedPos(minion, GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(minion.x, 0 , minion.z))/E.Speed)
                        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(ball.Position.x, 0 , ball.Position.z), Vector(myHero.x, 0 , myHero.z), Vector(Position.x, 0, Position.z))
                        if isOnSegment and GetDistanceSqr(pointSegment, object) < E.Width * E.Width then
                            CastE(myHero)
                        end
                    end
                end
            end
        end
        LastFarmRequest = os.clock()
    end
end

--CastX
function CastQ(target)
    if ValidTarget(target, Q.Range + W.Width / 2) and Q.IsReady() then
        local delay = Q.Delay --+ (GetDistance(p1, p2)/Q.Speed - 1)
        local range = GetDistance(Vector(ball.Position.x, ball.Position.y , ball.Position.z), Vector(target.x, target.y , target.z)) --+ W.Width / 2 --Q.Range
        local CastPosition,  HitChance,  Position = prediction:GetPrediction(target, delay, Q.Width, range, Q.Speed, ball.Position, Q.Type, Q.Collision, Q.Aoe)
        if HitChance >= 2 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
    end
end

function CastW(target)
    if W.IsReady() and ValidTarget(target, Q.Range + W.Width) then
        local Position = prediction:GetPredictedPos(target, W.Delay)
        if GetDistanceSqr(Vector(ball.Position.x, 0, ball.Position.z), Vector(Position.x, 0, Position.z)) <= W.Range * W.Range then 
            CastSpell(_W)
        end
    end
end

function CastE(unit)
    if unit ~= nil then
        if E.IsReady() and unit.valid and unit.team == myHero.team and GetDistanceSqr(myHero, unit) <= E.Range * E.Range then
            CastSpell(_E, unit)
        elseif E.IsReady() and unit.valid and unit.team ~= myHero.team then
            local table = nil
            if unit.type:lower():find("hero") then table = GetEnemyHeroes()
            else 
                EnemyMinions:update()
                if #EnemyMinions.objects > 0 then
                    table = EnemyMinions.objects 
                else
                    JungleMinions:update()
                    if #JungleMinions.objects > 0 then
                        table = JungleMinions.objects
                    end
                end
            end
            if table~= nil then
                local BestPos, BestHit = BestHitE(table)
                if BestHit~=nil and BestHit > 0 and BestPos~=nil and BestPos.team == myHero.team then
                    CastE(BestPos)
                end
            end
        end
    end
end

function CastR(target)
    if R.IsReady() and ValidTarget(target, Q.Range + R.Range) then
        local Position = prediction:GetPredictedPos(target, W.Delay)
        if GetDistanceSqr(Vector(Position.x, 0, Position.z),Vector(ball.Position.x, 0, ball.Position.z)) <= R.Range * R.Range then
            CastSpell(_R)
        end
    end
end

function ThrowBallTo(target, width)
    local EAlly = nil
    if E.IsReady() and GetDistanceSqr(ball.Position, target) > width * width then
        
        local Position = prediction:GetPredictedPos(target, E.Delay + GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(target.x, 0 , target.z))/E.Speed)
        for i = 1, heroManager.iCount do
            local ally = heroManager:GetHero(i)
            if ally.team == player.team and GetDistanceSqr(myHero, ally) <= E.Range * E.Range and GetDistanceSqr(Vector(ball.Position.x, 0 , ball.Position.z), Vector(ally.x, 0 , ally.z)) > 50 * 50  then
                local Position3 = prediction:GetPredictedPos(ally, E.Delay + GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(ally.x, 0 , ally.z))/E.Speed)
                if GetDistanceSqr(Position3, Position) <= width * width then
                    if EAlly == nil then 
                        EAlly = ally
                    else
                        local Position2 = prediction:GetPredictedPos(EAlly, E.Delay + GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(EAlly.x, 0 , EAlly.z))/E.Speed)
                        if GetDistanceSqr(Position, Position2) > GetDistanceSqr(Position, Position3) then 
                            EAlly = ally
                        end
                    end
                end
            end
        end
    end

    if EAlly~=nil and GetDistanceSqr(EAlly, target) <= width * width then
        CastE(EAlly)
    elseif Q.IsReady() then
        CastQ(target)
    end
end


function _GetDistanceSqr(p1, p2)
    p2 = p2 or player
    if p1 and p1.networkID and (p1.networkID ~= 0) and p1.visionPos then p1 = p1.visionPos end
    if p2 and p2.networkID and (p2.networkID ~= 0) and p2.visionPos then p2 = p2.visionPos end
    return GetDistanceSqr(p1, p2)
    
end

function CountObjectsNearPos(pos, range, radius, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local r = radius --+ VP:GetHitBox(object) / 3
        if _GetDistanceSqr(pos, object) <= r * r then
            n = n + 1
        end
    end
    return n
end

function GetBestCircularFarmPosition(range, radius, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local hit = CountObjectsNearPos(object.visionPos or object, range, radius, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = object--Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function HitE(StartPos, EndPos, width, objects)
    local n = 0
    --StartPos = Vector(StartPos.x, 0, StartPos.z)
    for i, object in ipairs(objects) do
        local Position = prediction:GetPredictedPos(object, E.Delay + GetDistance(Vector(StartPos.x, 0 , StartPos.z), Vector(object.x, 0 , object.z))/E.Speed)
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
        local w = width --+ VP:GetHitBox(object) / 3
        if isOnSegment and GetDistanceSqr(pointSegment, object) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
            n = n + 1
        end
    end
    return n
end

function BestHitE(objects)
    local tab = {}
    local BestAlly = nil 
    local BestHit = 0
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team == player.team then
            --print(GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(hero.x, 0 , hero.z)))
            if GetDistanceSqr(myHero, hero) < E.Range * E.Range and GetDistanceSqr(Vector(ball.Position.x, 0 , ball.Position.z), Vector(hero.x, 0 , hero.z)) > 50 * 50 then
                local Position = prediction:GetPredictedPos(hero, E.Delay + GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(hero.x, 0 , hero.z))/E.Speed)
                local hit = HitE(ball.Position, Position, E.Width, objects)
                if hit > BestHit then
                    BestHit = hit
                    BestAlly = hero--Vector(hero)
                    if BestHit == #objects then
                       break
                    end
                end
            end
        end
    end
    return BestAlly, BestHit
end

function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    StartPos = Vector(StartPos.x, 0, StartPos.z)
    for i, object in ipairs(objects) do
        local Position = prediction:GetPredictedPos(object, GetDistance(Vector(StartPos.x, 0 , StartPos.z), Vector(object.x, 0 , object.z))/Q.Speed)
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, Position)
        local w = width --+ VP:GetHitBox(object) / 3
        if isOnSegment and GetDistanceSqr(pointSegment, Position) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, Position) then
            n = n + 1
        end
    end
    return n
end

function GetBestLinePosition(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        if ValidTarget(object, Q.Range) then
            local Position = prediction:GetPredictedPos(object, GetDistance(Vector(ball.Position.x, 0 , ball.Position.z), Vector(object.x, 0 , object.z))/Q.Speed)
            local hit = CountObjectsOnLineSegment(ball.Position, Position, width, objects) + 1
            if hit > BestHit then
                BestHit = hit
                BestPos = object--Vector(object)
                if BestHit == #objects then
                   break
                end
            end
        end
    end
    return BestPos, BestHit
end

function OnProcessSpell(unit, spell)
    if myHero.dead or unit == nil or not scriptLoaded then return end
    if not unit.isMe then return end
    --print("OnProcessSpell: "..spell.name)
    if spell.name:lower():find("oriana") and spell.name:lower():find("izuna") and spell.name:lower():find("command") then  Q.LastCastTime = os.clock()
    elseif spell.name:lower():find("oriana") and spell.name:lower():find("dissonance") and spell.name:lower():find("command") then W.LastCastTime = os.clock()
    elseif spell.name:lower():find("oriana") and spell.name:lower():find("redact") and spell.name:lower():find("command") then E.LastCastTime = os.clock()
    elseif spell.name:lower():find("oriana") and spell.name:lower():find("detonate") and spell.name:lower():find("command") then R.LastCastTime = os.clock()
    end
end

function OnDraw()
    if myHero.dead or Config == nil or not scriptLoaded then return end
end

function _GetVector2D(vec)
    return WorldToScreen(D3DXVECTOR3(vec.x, vec.y, vec.z))
end

function UseItems(unit)
    if unit ~= nil then
        for _, item in pairs(CastableItems) do
            if item.IsReady() and GetDistanceSqr(myHero, unit) < item.Range * item.Range then
                if item.reqTarget then
                    CastSpell(item.Slot(), unit)
                else
                    CastSpell(item.Slot())
                end
            end
        end
    end
end

function GetPriority(enemy)
    local int = TS_GetPriority(enemy)
    if int == 2 then
        return 1.5
    elseif int == 3 then
        return 1.75
    elseif int == 4 then
        return 2
    elseif int == 5 then
        return 2.5
    else
        return 1
    end
end

function _GetRange()
    local range = Q.Range + W.Width
    return range
end

function _GetTarget()
    local bestTarget = nil
    local range = _GetRange()
    if ValidTarget(GetTarget(), range) then
        if GetTarget().type:lower():find("hero") or GetTarget().type:lower():find("minion") then
            return GetTarget() 
        end
    end
    for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, range) then
            if bestTarget == nil then
                bestTarget = enemy
            else
                local q, w, e, r, dmgEnemy = damage:getBestCombo(enemy)
                local q, w, e, r, dmgBest = damage:getBestCombo(bestTarget)
                local percentageEnemy = (enemy.health - dmgEnemy) / enemy.maxHealth
                local percentageBest = (bestTarget.health - dmgBest) / bestTarget.maxHealth

                if percentageEnemy * GetPriority(enemy) < percentageBest * GetPriority(bestTarget) then
                    bestTarget = enemy
                end
            end
        end
    end
    return bestTarget
end

function GetCustomTarget()
    ts:update()
    return ts.target--_GetTarget() --ts.target
end

function OrbLoad()
    if _G.Reborn_Initialised then
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Combo", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Harass", AutoCarry.MODE_MIXEDMODE)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Clear", AutoCarry.MODE_LANECLEAR)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "LastHit", AutoCarry.MODE_LASTHIT)
        _G.AutoCarry.MyHero:AttacksEnabled(true)
    elseif _G.Reborn_Loaded then
        DelayAction(OrbLoad, 1)
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
        require 'SxOrbWalk'
        Sx = SxOrbWalk()
        Sx:LoadToMenu()
        Sx:RegisterHotKey("harass",  Config.Keys, "Harass")
        Sx:RegisterHotKey("fight",  Config.Keys, "Combo")
        Sx:RegisterHotKey("laneclear",  Config.Keys, "Clear")
        Sx:RegisterHotKey("lasthit",  Config.Keys, "LastHit")
        Sx:EnableAttacks()
    else
        print("You will need an orbwalker")
    end
end

function CountEnemiesNear(source, range)
    local Count = 0
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
            if GetDistanceSqr(enemy, source) <= range * range then
                Count = Count + 1
            end
        end
    end
    return Count
end
 

function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end
    end
end
function arrangePrioritys()
     local priorityOrder = {
                [1] = {1,1,1,1,1},
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,2,3},
        [4] = {1,1,2,3,4},
        [5] = {1,2,3,4,5},
    }
    local enemies = #GetEnemyHeroes()
    for i, enemy in ipairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.p1, enemy, priorityOrder[enemies][1])
        SetPriority(priorityTable.p2, enemy, priorityOrder[enemies][2])
        SetPriority(priorityTable.p3,  enemy, priorityOrder[enemies][3])
        SetPriority(priorityTable.p4,  enemy, priorityOrder[enemies][4])
        SetPriority(priorityTable.p5,  enemy, priorityOrder[enemies][5])
    end
end



class "BallManager"
function BallManager:__init()
    self.Position = myHero
    self.DataUpdated = false
    self.RPacket = InitialPacket
    self.TimeLimit = 0.1
    AddCreateObjCallback(function(obj) self:OnCreateObj(obj) end)
    AddDeleteObjCallback(function(obj) self:OnDeleteObj(obj) end)
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    AddTickCallback(function() if not self.Position.valid then self.Position = myHero end end)
    AddCastSpellCallback(function(iSpell, startPos, endPos, targetUnit) self:OnCastSpell(iSpell,startPos,endPos,targetUnit) end)
    AddSendPacketCallback(function(p) self:OnSendPacket(p) end)
end

function BallManager:OnCreateObj(obj)
    --if obj.name:lower():find("orianna") or obj.name:lower():find("ball") or GetDistance(ball.Position, obj) < 300 then print("Created "..obj.name.." "..GetDistance(myHero, obj)) end
    
    if obj.name:lower():find("orianna") and obj.name:lower():find("yomu") and obj.name:lower():find("ring") and obj.name:lower():find("green") then
        self.Position = obj
    elseif obj.name:lower():find("orianna") and obj.name:lower():find("ball") and obj.name:lower():find("flash") then
        self.Position = myHero
    --elseif obj.name:lower():find("orianna") and obj.name:lower():find("izuna") and obj.name:lower():find("nova") then
        --self.Position = myHero
    elseif obj.name:lower():find("linemissile") and os.clock() - Q.LastCastTime < 0.5 and GetDistanceSqr(self.Position, obj) < 100 * 100 then
        self.Position = obj
    elseif obj.name:lower():find("linemissile") and os.clock() - E.LastCastTime < 0.5 and GetDistanceSqr(self.Position, obj) < 100 * 100 then
        self.Position = obj
    elseif obj.name:lower():find("base_e") and obj.name:lower():find("protectshield") then
        --self.Position = obj
    end
end

function BallManager:OnDeleteObj(obj)
    --if obj.name:lower():find("orianna") or obj.name:lower():find("ball") or GetDistance(ball.Position, obj) < 300 then print("Deleted "..obj.name.." "..GetDistance(ball.Position, obj)) end
    
    if obj.name:lower():find("orianna") and obj.name:lower():find("yomu") and obj.name:lower():find("ring") and obj.name:lower():find("green") and GetDistanceSqr(myHero, obj) < 150 * 150 then
        self.Position = myHero
    end
end

function BallManager:OnCastSpell(iSpell, startPos, endPos, targetUnit)
    if iSpell == _R and #self:ObjectsInArea(R.Range, R.Delay, GetEnemyHeroes()) == 0  then
        R.Sent = os.clock()
    end
end

function BallManager:OnProcessSpell(unit, spell)
    if unit and spell and unit.isMe and spell.name:lower():find("orianaizunacommand") then
        --DelayAction(function(pos) self.Position = Vector(pos) end, GetDistance(spell.endPos, self.Position) / Q.Speed - GetLatency()/1000 - 0.7, {Vector(spell.endPos)})
    elseif unit and spell and unit.isMe and spell.name:lower():find("orianaredactcommand") then
        --self.Position = spell.target
        DelayAction(function(pos) self.Position = pos end, E.Delay + GetDistance(spell.endPos, self.Position) / E.Speed, {spell.target})
    end
end

function BallManager:ObjectsInArea(range, delay, array)
    local objects2 = {}
    local delay = delay or 0
    if array ~= nil then
        for i, object in ipairs(array) do
            if ValidTarget(object, Q.Range * 2.5) then
                local Position = prediction:GetPredictedPos(object, delay)
                if GetDistanceSqr(Vector(self.Position.x, 0, self.Position.z), Vector(Position.x, 0, Position.z)) <= range * range then
                    table.insert(objects2, object)
                end
            end
        end
    end
    return objects2
end

function BallManager:OnSendPacket(p)
    if Config == nil or not scriptLoaded then return end
    p.pos = 2
    if Config.Misc.BlockR and os.clock() -  R.Sent < self.TimeLimit and R.Sent > 0 and R.IsReady() then
        if myHero.networkID == p:DecodeF() then
            Packet(p):block()
        end
    end
end

class "Initiator"
function Initiator:__init()
    self.Menu = nil
    self.GAPCLOSERLIST = {
        ["Aatrox"]          = "Q",
        ["Akali"]           = "R",
        ["Alistar"]         = "W",
        ["Amumu"]           = "Q",
        ["Corki"]           = "W",
        ["Diana"]           = "R",
        ["Elise"]           = "Q",
        ["Elise"]           = "E",
        ["Fiddlesticks"]    = "R",
        ["Fiora"]           = "Q",
        ["Fizz"]            = "Q",
        ["Gnar"]            = "E",
        ["Gragas"]          = "E",
        ["Graves"]          = "E",
        ["Hecarim"]         = "R",
        ["Irelia"]          = "Q",
        ["JarvanIV"]        = "Q",
        ["JarvanIV"]        = "R",
        ["Jax"]             = "Q",
        ["Jayce"]           = "Q",
        ["Katarina"]        = "E",
        ["Kassadin"]        = "R",
        ["Kennen"]          = "E",
        ["KhaZix"]          = "E",
        ["Lissandra"]       = "E",
        ["LeBlanc"]         = "W",
        ["LeBlanc"]         = "R",
        ["LeeSin"]          = "Q",
        ["Leona"]           = "E",
        ["Lucian"]          = "E",
        ["Malphite"]        = "R",
        ["MasterYi"]        = "Q",
        ["MonkeyKing"]      = "E",
        ["Nocturne"]        = "R",
        ["Olaf"]            = "R",
        ["Pantheon"]        = "W",
        ["Pantheon"]        = "R",
        ["Poppy"]           = "E",
        ["RekSai"]          = "E",
        ["Renekton"]        = "E",
        ["Riven"]           = "Q",
        ["Riven"]           = "E",
        ["Rengar"]          = "R",
        ["Sejuani"]         = "Q",
        ["Sion"]            = "R",
        ["Shen"]            = "E",
        ["Shyvana"]         = "R",
        ["Talon"]           = "E",
        ["Thresh"]          = "Q",
        ["Tristana"]        = "W",
        ["Tryndamere"]      = "E",
        ["Udyr"]            = "E",
        ["Volibear"]        = "Q",
        ["Vi"]              = "Q",
        ["Vi"]              = "R",
        ["XinZhao"]         = "E",
        ["Yasuo"]           = "E",
        ["Zac"]             = "E",
        ["Ziggs"]           = "W",
    }
end

function Initiator:CheckInitiator()
    if #GetAllyHeroes() > 0 then
        for idx, ally in ipairs(GetAllyHeroes()) do
            for champ, spell in pairs(self.GAPCLOSERLIST) do
                if ally.charName == champ then
                    self.Menu.UseE[ally.charName..spell] = true
                end
            end
        end
    end
end

function Initiator:LoadMenu(m)
    self.Menu = m
    if self.Menu ~= nil then
        if #GetAllyHeroes() > 0 then
            self.Menu:addSubMenu("Use E To Initiate", "UseE")
                for idx, ally in ipairs(GetAllyHeroes()) do
                    local champion = ally.charName
                    self.Menu.UseE:addParam(champion.."Q", champion.." (Q)", SCRIPT_PARAM_ONOFF, false)
                    self.Menu.UseE:addParam(champion.."W", champion.." (W)", SCRIPT_PARAM_ONOFF, false)
                    self.Menu.UseE:addParam(champion.."E", champion.." (E)", SCRIPT_PARAM_ONOFF, false)
                    self.Menu.UseE:addParam(champion.."R", champion.." (R)", SCRIPT_PARAM_ONOFF, false)
                end
            self.Menu:addParam("Time",  "Time Limit to Initiate", SCRIPT_PARAM_SLICE, 3, 0, 8, 0)
            self:CheckInitiator()
            AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
        end
    end
end

function Initiator:OnProcessSpell(unit, spell)
    if self.Menu == nil or spell == nil or unit == nil or not unit.valid or myHero.dead then return end
    if not unit.isMe then
        if unit.type == myHero.type and unit.team == myHero.team and GetDistanceSqr(myHero, unit) <= (E.Range + 500) * (E.Range + 500) then
            local spelltype, casttype = getSpellType(unit, spell.name)
            if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
                if self.Menu.UseE[unit.charName..spelltype] then 
                    self:ForceE(unit, os.clock())
                end
            end
        end
    end
end

function Initiator:ForceE(unit, time)
   if os.clock() - time > self.Menu.Time then return end
    --print("castingE")
    if E.IsReady() and GetDistanceSqr(myHero, unit) <= (E.Range) * (E.Range) and ValidTarget(ts.target) then
        CastE(unit)
    end
    if GetDistanceSqr(myHero, unit) <= (E.Range + 500) * (E.Range + 500) then
        DelayAction(function(unit, time) self:ForceE(unit, time) end, 0.1, {unit, time})
    end
end

class("Interrupt")
function Interrupt:__init()
    self.Menu = nil
    self.INTERRUPTIBLE_SPELLS = {
        ["Katarina"]                    = "R",
        ["MasterYi"]                    = "W",
        ["Fiddlesticks"]                = "R",
        ["Galio"]                       = "R",
        ["MissFortune"]                 = "R",
        ["VelKoz"]                      = "R",
        ["Warwick"]                     = "R",
        ["Nunu"]                        = "R",
        ["Shen"]                        = "R",
        ["Karthus"]                     = "R",
        ["Malzahar"]                    = "R",
        ["Pantheon"]                    = "R",
    }
end

function Interrupt:CheckInterruptible()
    if #GetEnemyHeroes() > 0 then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if self.INTERRUPTIBLE_SPELLS[enemy.charName]~=nil then
                local spell = self.INTERRUPTIBLE_SPELLS[enemy.charName]
                self.Menu.UseR[enemy.charName..spell] = true
            end
        end
    end
end

function Interrupt:LoadMenu(m)
    self.Menu = m
    if self.Menu ~= nil then
        if #GetEnemyHeroes() > 0 then
            self.Menu:addSubMenu("Use R To Interrupt", "UseR")
                for idx, enemy in ipairs(GetEnemyHeroes()) do
                    local champion = enemy.charName
                    self.Menu.UseR:addParam(champion.."Q", champion.." (Q)", SCRIPT_PARAM_ONOFF, false)
                    self.Menu.UseR:addParam(champion.."W", champion.." (W)", SCRIPT_PARAM_ONOFF, false)
                    self.Menu.UseR:addParam(champion.."E", champion.." (E)", SCRIPT_PARAM_ONOFF, false)
                    self.Menu.UseR:addParam(champion.."R", champion.." (R)", SCRIPT_PARAM_ONOFF, false)
                end
            self:CheckInterruptible()
            self.Menu:addParam("Time",  "Time Limit to Interrupt", SCRIPT_PARAM_SLICE, 3, 0, 8, 0)
            AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
        end
    end
end

function Interrupt:OnProcessSpell(unit, spell)
    if self.Menu == nil or spell == nil or unit == nil or not unit.valid or myHero.dead then return end
    if not unit.isMe then
        if unit.type == myHero.type and unit.team ~= myHero.team and ValidTarget(unit, Q.Range + R.Width) then
            local spelltype, casttype = getSpellType(unit, spell.name)
            if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
                if self.Menu.UseR[unit.charName..spelltype] then 
                    self:ForceR(unit, os.clock())
                end
            end
        end
    end
end

function Interrupt:ForceR(target, time)
   if not ValidTarget(target) or os.clock() - time > self.Menu.Time then return end
    if R.IsReady() and GetDistanceSqr(target, ball.Position) <= R.Range * R.Range then
        CastR(target)
    elseif Q.IsReady() and GetDistanceSqr(target, ball.Position) <= (Q.Range + R.Width) * (Q.Range + R.Width) then
        ThrowBallTo(target, R.Width)
    end
    if ValidTarget(target, Q.Range + R.Width) then
        DelayAction(function(target, time) self:ForceR(target, time) end, 0.1, {target, time})
    end
end

class "Prediction"
function Prediction:__init()
    self.delay = 0.07
    self.LastRequest = 0
    self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
end

function Prediction:ValidRequest()
    if os.clock() - self.LastRequest < self:TimeRequest() then
        return false
    else
        self.LastRequest = os.clock()
        return true
    end
end

function Prediction:GetPredictionType()
    local int = Config.Misc.predictionType or 1
    return PredictionTable[int] ~= nil and tostring(PredictionTable[int]) or "VPrediction"
end


function Prediction:TimeRequest()
    if self:GetPredictionType() == "VPrediction" then
        return 0.06
    elseif self:GetPredictionType() == "Prodiction" then
        return 0.06
    elseif self:GetPredictionType() == "DivinePred" then
        return Config.Misc.ExtraTime or 0.2
    end
end

function Prediction:GetPrediction(target, delay, width, range, speed, source, skillshotType, collision, aoe)
    if ValidTarget(target) and self:ValidRequest() then
        local skillshotType = skillshotType or "circular"
        local aoe = aoe or false
        local collision = collision or false
        local source = source~=nil and source or myHero
        -- VPrediction
        if self:GetPredictionType() == "VPrediction" or not target.type:lower():find("hero") then
            if skillshotType == "linear" then
                if aoe then
                    return VP:GetLineAOECastPosition(target, delay, width, range, speed, source)
                else
                    return VP:GetLineCastPosition(target, delay, width, range, speed, source, collision)
                end
            elseif skillshotType == "circular" then
                if aoe then
                    return VP:GetCircularAOECastPosition(target, delay, width, range, speed, source)
                else
                    return VP:GetCircularCastPosition(target, delay, width, range, speed, source, collision)
                end
             elseif skillshotType == "cone" then
                if aoe then
                    return VP:GetConeAOECastPosition(target, delay, width, range, speed, source)
                else
                    return VP:GetLineCastPosition(target, delay, width, range, speed, source, collision)
                end
            end
        -- Prodiction
        elseif self:GetPredictionType() == "Prodiction" then
            local aoe = false -- temp fix for prodiction
            if aoe then
                if skillshotType == "linear" then
                    local pos, info, objects = Prodiction.GetLineAOEPrediction(target, range, speed, delay, width, source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                elseif skillshotType == "circular" then
                    local pos, info, objects = Prodiction.GetCircularAOEPrediction(target, range, speed, delay, width, source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                 elseif skillshotType == "cone" then
                    local pos, info, objects = Prodiction.GetConeAOEPrediction(target, range, speed, delay, width, source)
                    local hitChance = collision and info.mCollision() and -1 or info.hitchance
                    return pos, hitChance, #objects
                end
            else
                local pos, info = Prodiction.GetPrediction(target, range, speed, delay, width, source)
                local hitChance = collision and info.mCollision() and -1 or info.hitchance
                return pos, hitChance, info.pos
            end
        elseif self:GetPredictionType() == "DivinePred" then
            local asd = nil
            local col = collision and 0 or math.huge
            if skillshotType == "linear" then
                asd = LineSS(speed, range, width, delay * 1000, col)
            elseif skillshotType == "circular" then
                asd = CircleSS(speed, range, width, delay * 1000, col)
            elseif skillshotType == "cone" then
                asd = ConeSS(speed, range, width, delay * 1000, col)
            end
            local state, pos, perc = nil, Vector(target), nil
            if asd~=nil then
                local unit = DPTarget(target)
                local i = 0
                --for i = 0, 1, 1 do
                    local hitchance = 2 - i
                    state, pos, perc = DP:predict(unit, asd, hitchance, Vector(source))
                    if state == SkillShot.STATUS.SUCCESS_HIT then 
                        return pos, hitchance, perc
                    end
                --end
            end

            return pos, -1, aoe and 1 or pos
        end
    end
    return Vector(target), -1, Vector(target)
end

function Prediction:GetPredictedPos(unit, delay, speed, from, collision)
    if self:GetPredictionType() == "Prodiction" then 
        return Prodiction.GetPredictionTime(unit, delay)
    else
        return VP:GetPredictedPos(unit, delay, speed, from, collision)

    end
end

class "Damage"
function Damage:__init()
    --q, w, e , r, dmg, clock
    self.PredictedDamage = {}
    self.RefreshTime = 0.4
end

function Damage:getBestCombo(target)
    if not ValidTarget(target) then return false, false, false, false, 0 end
    local q = {false}
    local w = {false}
    local e = {false}
    local r = {false}
    local damagetable = self.PredictedDamage[target.networkID]
    if damagetable ~= nil then
        local time = damagetable[6]
        if os.clock() - time <= self.RefreshTime  then 
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5] 
        else
            if Q.IsReady() then q = {false, true} end
            if W.IsReady() then w = {false, true} end
            if E.IsReady() then e = {false, true} end
            if R.IsReady() then r = {false, true} end
            local bestdmg = 0
            local best = {false, false, false, false}
            local dmg, mana = self:getComboDamage(target, Q.IsReady(), W.IsReady(), E.IsReady(), R.IsReady())
            if dmg > target.health then
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = self:getComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                                if d > target.health and myHero.mana > m then 
                                    if bestdmg == 0 then bestdmg = d best = {q[qCount], w[wCount], e[eCount], r[rCount]}
                                    elseif d < bestdmg then bestdmg = d best = {q[qCount], w[wCount], e[eCount], r[rCount]} end
                                end
                            end
                        end
                    end
                end
                --return best[1], best[2], best[3], best[4], bestdmg
                damagetable[1] = best[1]
                damagetable[2] = best[2]
                damagetable[3] = best[3]
                damagetable[4] = best[4]
                damagetable[5] = bestdmg
                damagetable[6] = os.clock()
            else
                local table2 = {false,false,false,false}
                local bestdmg, mana = self:getComboDamage(target, false, false, false, false)
                for qCount = 1, #q do
                    for wCount = 1, #w do
                        for eCount = 1, #e do
                            for rCount = 1, #r do
                                local d, m = self:getComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                                if d > bestdmg and myHero.mana > m then 
                                    table2 = {q[qCount],w[wCount],e[eCount],r[rCount]}
                                    bestdmg = d
                                end
                            end
                        end
                    end
                end
                --return table2[1],table2[2],table2[3],table2[4], bestdmg
                damagetable[1] = table2[1]
                damagetable[2] = table2[2]
                damagetable[3] = table2[3]
                damagetable[4] = table2[4]
                damagetable[5] = bestdmg
                damagetable[6] = os.clock()
            end
            return damagetable[1], damagetable[2], damagetable[3], damagetable[4], damagetable[5]
        end
    else
        self.PredictedDamage[target.networkID] = {false, false, false, false, 0, os.clock() - self.RefreshTime * 2}
        return self:getBestCombo(target)
    end
end

function Damage:getComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if target ~= nil and target.valid then
        if q then
            comboDamage = comboDamage + Q.Damage(target)
            currentManaWasted = currentManaWasted + Q.Mana()
        end
        if w then
            comboDamage = comboDamage + W.Damage(target)
            currentManaWasted = currentManaWasted + W.Mana()
        end
        if e then
            comboDamage = comboDamage + E.Damage(target)
            currentManaWasted = currentManaWasted + E.Mana()
        end
        if r then
            comboDamage = comboDamage + R.Damage(target)
            currentManaWasted = currentManaWasted + R.Mana()
        end
        comboDamage = comboDamage + AA.Damage(target)
        for _, item in pairs(CastableItems) do
            if item.IsReady() then
                comboDamage = comboDamage + item.Damage(target)
            end
        end
    end
    comboDamage = comboDamage * self:getOverkill()
    return comboDamage, currentManaWasted
end

function Damage:getDamageToMinion(minion)
    return VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0)
end

function Damage:getOverkill()
    return (100 + Config.Misc.overkill)/100
end

class "Draw"
function Draw:__init()
    self.Menu = nil
end
function Draw:LoadMenu(menu)
    self.Menu = menu
    self.Menu:addSubMenu("Q", "Q")
    self.Menu.Q:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Q:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.Q:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("W", "W")
    self.Menu.W:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
    self.Menu.W:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.W:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("E", "E")
    self.Menu.E:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
    self.Menu.E:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.E:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("R", "R")
    self.Menu.R:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
    self.Menu.R:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.R:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("Ball Position", "BallPosition")
    self.Menu.BallPosition:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
    self.Menu.BallPosition:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 0, 0, 255 })
    self.Menu.BallPosition:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addParam("dmgCalc","Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Target","Red Circle on Target", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Quality", "Quality of Circles", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
    AddDrawCallback(function() self:OnDraw() end)
end

function Draw:OnDraw()
    if myHero.dead or self.Menu == nil then return end
    if self.Menu.dmgCalc then self:DrawPredictedDamage() end
    if self.Menu.Target and ts.target ~= nil and ValidTarget(ts.target) then
        self:DrawCircle2(ts.target.x, ts.target.y, ts.target.z, VP:GetHitBox(ts.target)*1.5, Colors.Red, 3)
    end
    if self.Menu.Q.Enable and Q.IsReady() then
        local color = self.Menu.Q.Color
        local width = self.Menu.Q.Width
        local range =           Q.Range
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.W.Enable and W.IsReady() then
        local color = self.Menu.W.Color
        local width = self.Menu.W.Width
        local range =           W.Range
        self:DrawCircle2(ball.Position.x, ball.Position.y, ball.Position.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.E.Enable and E.IsReady() then
        local color = self.Menu.E.Color
        local width = self.Menu.E.Width
        local range =           E.Range
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.R.Enable and R.IsReady() then
        local color = self.Menu.R.Color
        local width = self.Menu.R.Width
        local range =           R.Range
        self:DrawCircle2(ball.Position.x, ball.Position.y, ball.Position.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.BallPosition.Enable then
        local color = self.Menu.BallPosition.Color
        local width = self.Menu.BallPosition.Width
        local range =           Q.Width
        self:DrawCircle2(ball.Position.x, ball.Position.y, ball.Position.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

end

function Draw:DrawPredictedDamage() 
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
        if ValidTarget(enemy) and enemy.visible and OnScreen(p.x, p.y) then
            local q,w,e,r, dmg = damage:getBestCombo(enemy)
            if dmg >= enemy.health then
                self:DrawLineHPBar(dmg, "KILLABLE", enemy, true)
            else
                local spells = ""
                if q then spells = "Q" end
                if w then spells = spells .. "W" end
                if e then spells = spells .. "E" end
                if r then spells = spells .. "R" end
                self:DrawLineHPBar(dmg, spells, enemy, true)
            end
        end
    end
end

function Draw:GetHPBarPos(enemy)
    enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
    local BarPosOffsetX = -50
    local BarPosOffsetY = 46
    local CorrectionY = 39
    local StartHpPos = 31 
    barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
    barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)
    local StartPos = Vector(barPos.x , barPos.y, 0)
    local EndPos = Vector(barPos.x + 108 , barPos.y , 0)    
    return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function Draw:DrawLineHPBar(damage, text, unit, enemyteam)
    if unit.dead or not unit.visible then return end
    local p = WorldToScreen(D3DXVECTOR3(unit.x, unit.y, unit.z))
    if not OnScreen(p.x, p.y) then return end
    local thedmg = 0
    local line = 2
    local linePosA  = {x = 0, y = 0 }
    local linePosB  = {x = 0, y = 0 }
    local TextPos   = {x = 0, y = 0 }
    
    
    if damage >= unit.maxHealth then
        thedmg = unit.maxHealth - 1
    else
        thedmg = damage
    end
    
    thedmg = math.round(thedmg)
    
    local StartPos, EndPos = self:GetHPBarPos(unit)
    local Real_X = StartPos.x + 24
    local Offs_X = (Real_X + ((unit.health - thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
    if Offs_X < Real_X then Offs_X = Real_X end 
    local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth))
    if mytrans >= 255 then mytrans=254 end
    local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
    if my_bluepart >= 255 then my_bluepart=254 end

    
    if enemyteam then
        linePosA.x = Offs_X-150
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-150
        linePosB.y = (StartPos.y-10)
        TextPos.x = Offs_X-148
        TextPos.y = (StartPos.y-(30+(line*15)))
    else
        linePosA.x = Offs_X-125
        linePosA.y = (StartPos.y-(30+(line*15)))    
        linePosB.x = Offs_X-125
        linePosB.y = (StartPos.y-15)
    
        TextPos.x = Offs_X-122
        TextPos.y = (StartPos.y-(30+(line*15)))
    end

    DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(mytrans, 255, my_bluepart, 0))
    DrawText(tostring(thedmg).." "..tostring(text), 15, TextPos.x, TextPos.y , ARGB(mytrans, 255, my_bluepart, 0))
end

-- Barasia, vadash, viceversa
function Draw:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
  quality = math.max(8,self:round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end
function Draw:round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function Draw:DrawCircle2(x, y, z, radius, color, width)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        self:DrawCircleNextLvl(x, y, z, radius, width, color, 75 + 2000 * (100 - self.Menu.Quality)/100) 
    end
end



class "Orbwalker"
function Orbwalker:__init()
    --self.isAttacking = false
    self.bufferAA = false 
    --self.nextAA = 0
    self.baseWindUpTime = 3
    self.baseAnimationTime = 0.665
    self.dataUpdated = false
    self.Menu = nil
    self.target = nil
    self.AfterAttackCallbacks = {}
    self.ResetAttackTimer = {}
    self.AA = {LastTime = 0, LastTarget = nil, isAttacking = false}
    --self.Move = {LastTime = 0, LastVector = nil, Delay = 0}
    self.Attacks = { "caitlynheadshotmissile", "frostarrow", "garenslash2", "kennenmegaproc", "lucianpassiveattack", "masteryidoublestrike", "quinnwenhanced", "renektonexecute", "renektonsuperexecute", "rengarnewpassivebuffdash", "trundleq", "xenzhaothrust", "xenzhaothrust2", "xenzhaothrust3"}
    self.noAttacks = {"jarvanivcataclysmattack", "monkeykingdoubleattack", "shyvanadoubleattack", "shyvanadoubleattackdragon", "zyragraspingplantattack", "zyragraspingplantattack2", "zyragraspingplantattackfire", "zyragraspingplantattack2fire"}
    self.AttackResetTable = 
        {
            ["vayne"] = _Q,
            ["darius"] = _W,
            ["fiora"] = _E,
            ["gangplank"] = _Q,
            ["jax"] = _W,
            ["leona"] = _Q,
            ["mordekaiser"] = _Q,
            ["nasus"] = _Q,
            ["nautilus"] = _W,
            ["nidalee"] = _Q,
            ["poppy"] = _Q,
            ["riven"] = _Q,
            ["renekton"] = _W,
            ["rengar"] = _Q,
            ["shyvana"] = _Q,
            ["sivir"] = _W,
            ["talon"] = _Q,
            ["trundle"] = _Q,
            ["vi"] = _E,
            ["volibear"] = _Q,
            ["xinzhao"] = _Q,
            ["monkeyking"] = _Q,
            ["yorick"] = _Q,
            ["cassiopeia"] = _E,
            ["garen"] = _Q,
            ["khazix"] = _Q,
            ["gnar"] = _E
    }

    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
end

function Orbwalker:OnProcessSpell(unit, spell)
    if unit~= nil and unit.valid and not myHero.dead and unit.isMe then
        if self:IsAutoAttack(spell.name:lower()) then
            if not self.dataUpdated then
                self.baseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
                self.baseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
                self.dataUpdated = true
            end
            self.target = spell.target
            self.AA.isAttacking = true
            self.AA.LastTime = os.clock() - self:Latency()
            DelayAction(
                function() 
                    self:TriggerAfterAttackCallback(spell)
                    self.AA.isAttacking = false
                end
            , self:WindUpTime() - self:Latency() * 2)
        elseif self:IsResetSpell(spell.name) or spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            DelayAction(function()
                self:ResetAA()
                end, spell.windUpTime - self:Latency() * 2)
        end
    end
end

function Orbwalker:CanAttack()
    if os.clock() >= self.AA.LastTime then
        return os.clock() - self.AA.LastTime >= self:AnimationTime() - self:Latency()
    end
    return false
end

function Orbwalker:CanMove()
    if os.clock() >= self.AA.LastTime then
        return os.clock() - self.AA.LastTime >= self:WindUpTime() - self.Latency() and not self.bufferAA and not self.AA.isAttacking and not _G.evade
    end
   return false
end

function Orbwalker:Latency()
    return GetLatency() / 2000
end

function Orbwalker:ExtraWindUp()
    return self.Menu ~= nil and self.Menu.Misc.ExtraWindUp / 1000 or 90/1000
end

function Orbwalker:WindUpTime()
    return (1 / (myHero.attackSpeed * self.baseWindUpTime)) + self:ExtraWindUp()
end

function Orbwalker:AnimationTime()
    return 1 / (myHero.attackSpeed * self.baseAnimationTime)
end

function Orbwalker:IsAutoAttack(name)
    local name = name:lower()
    return (name:find("attack") and self.Attacks[name] == nil) or self.Attacks[name]~=nil
end

function Orbwalker:IsResetSpell(SpellName)
    local SpellID
    if SpellName:lower() == myHero:GetSpellData(_Q).name:lower() then
        SpellID = _Q
    elseif SpellName:lower() == myHero:GetSpellData(_W).name:lower() then
        SpellID = _W
    elseif SpellName:lower() == myHero:GetSpellData(_E).name:lower() then
        SpellID = _E
    elseif SpellName:lower() == myHero:GetSpellData(_R).name:lower() then
        SpellID = _R
    end

    if SpellID then
        return self.AttackResetTable[myHero.charName:lower()] == SpellID 
    end
    return false
end

function Orbwalker:RegisterAfterAttackCallback(func)
    table.insert(self.AfterAttackCallbacks, func)
end

function Orbwalker:TriggerAfterAttackCallback(spell)
    for i, func in ipairs(self.AfterAttackCallbacks) do
        func(spell)
    end
end



function Orbwalker:ResetAA()
    self.AA.isAttacking = false
    self.AA.LastTime = 0
    --self.nextAA = 0
end

--CREDIT TO EXTRAGOZ
local spellsFile = LIB_PATH.."missedspells.txt"
local spellslist = {}
local textlist = ""
local spellexists = false
local spelltype = "Unknown"
 
function writeConfigsspells()
        local file = io.open(spellsFile, "w")
        if file then
                textlist = "return {"
                for i=1,#spellslist do
                        textlist = textlist.."'"..spellslist[i].."', "
                end
                textlist = textlist.."}"
                if spellslist[1] ~=nil then
                        file:write(textlist)
                        file:close()
                end
        end
end
if FileExist(spellsFile) then spellslist = dofile(spellsFile) end
 
local Others = {"Recall","recall","OdinCaptureChannel","LanternWAlly","varusemissiledummy","khazixqevo","khazixwevo","khazixeevo","khazixrevo","braumedummyvoezreal","braumedummyvonami","braumedummyvocaitlyn","braumedummyvoriven","braumedummyvodraven","braumedummyvoashe","azirdummyspell"}
local Items = {"RegenerationPotion","FlaskOfCrystalWater","ItemCrystalFlask","ItemMiniRegenPotion","PotionOfBrilliance","PotionOfElusiveness","PotionOfGiantStrength","OracleElixirSight","OracleExtractSight","VisionWard","SightWard","sightward","ItemGhostWard","ItemMiniWard","ElixirOfRage","ElixirOfIllumination","wrigglelantern","DeathfireGrasp","HextechGunblade","shurelyascrest","IronStylus","ZhonyasHourglass","YoumusBlade","randuinsomen","RanduinsOmen","Mourning","OdinEntropicClaymore","BilgewaterCutlass","QuicksilverSash","HextechSweeper","ItemGlacialSpike","ItemMercurial","ItemWraithCollar","ItemSoTD","ItemMorellosBane","ItemPromote","ItemTiamatCleave","Muramana","ItemSeraphsEmbrace","ItemSwordOfFeastAndFamine","ItemFaithShaker","OdynsVeil","ItemHorn","ItemPoroSnack","ItemBlackfireTorch","HealthBomb","ItemDervishBlade","TrinketTotemLvl1","TrinketTotemLvl2","TrinketTotemLvl3","TrinketTotemLvl3B","TrinketSweeperLvl1","TrinketSweeperLvl2","TrinketSweeperLvl3","TrinketOrbLvl1","TrinketOrbLvl2","TrinketOrbLvl3","OdinTrinketRevive","RelicMinorSpotter","RelicSpotter","RelicGreaterLantern","RelicLantern","RelicSmallLantern","ItemFeralFlare","trinketorblvl2","trinketsweeperlvl2","trinkettotemlvl2","SpiritLantern","RelicGreaterSpotter"}
local MSpells = {"JayceStaticField","JayceToTheSkies","JayceThunderingBlow","Takedown","Pounce","Swipe","EliseSpiderQCast","EliseSpiderW","EliseSpiderEInitial","elisespidere","elisespideredescent","gnarbigq","gnarbigw","gnarbige","GnarBigQMissile"}
local PSpells = {"CaitlynHeadshotMissile","RumbleOverheatAttack","JarvanIVMartialCadenceAttack","ShenKiAttack","MasterYiDoubleStrike","sonaqattackupgrade","sonawattackupgrade","sonaeattackupgrade","NocturneUmbraBladesAttack","NautilusRavageStrikeAttack","ZiggsPassiveAttack","QuinnWEnhanced","LucianPassiveAttack","SkarnerPassiveAttack","KarthusDeathDefiedBuff","AzirTowerClick","azirtowerclick","azirtowerclickchannel"}
 
local QSpells = {"TrundleQ","LeonaShieldOfDaybreakAttack","XenZhaoThrust","NautilusAnchorDragMissile","RocketGrabMissile","VayneTumbleAttack","VayneTumbleUltAttack","NidaleeTakedownAttack","ShyvanaDoubleAttackHit","ShyvanaDoubleAttackHitDragon","frostarrow","FrostArrow","MonkeyKingQAttack","MaokaiTrunkLineMissile","FlashFrostSpell","xeratharcanopulsedamage","xeratharcanopulsedamageextended","xeratharcanopulsedarkiron","xeratharcanopulsediextended","SpiralBladeMissile","EzrealMysticShotMissile","EzrealMysticShotPulseMissile","jayceshockblast","BrandBlazeMissile","UdyrTigerAttack","TalonNoxianDiplomacyAttack","LuluQMissile","GarenSlash2","VolibearQAttack","dravenspinningattack","karmaheavenlywavec","ZiggsQSpell","UrgotHeatseekingHomeMissile","UrgotHeatseekingLineMissile","JavelinToss","RivenTriCleave","namiqmissile","NasusQAttack","BlindMonkQOne","ThreshQInternal","threshqinternal","QuinnQMissile","LissandraQMissile","EliseHumanQ","GarenQAttack","JinxQAttack","JinxQAttack2","yasuoq","xeratharcanopulse2","VelkozQMissile","KogMawQMis","BraumQMissile","KarthusLayWasteA1","KarthusLayWasteA2","KarthusLayWasteA3","karthuslaywastea3","karthuslaywastea2","karthuslaywastedeada1","MaokaiSapling2Boom","gnarqmissile","GnarBigQMissile","viktorqbuff"}
local WSpells = {"KogMawBioArcaneBarrageAttack","SivirWAttack","TwitchVenomCaskMissile","gravessmokegrenadeboom","mordekaisercreepingdeath","DrainChannel","jaycehypercharge","redcardpreattack","goldcardpreattack","bluecardpreattack","RenektonExecute","RenektonSuperExecute","EzrealEssenceFluxMissile","DariusNoxianTacticsONHAttack","UdyrTurtleAttack","talonrakemissileone","LuluWTwo","ObduracyAttack","KennenMegaProc","NautilusWideswingAttack","NautilusBackswingAttack","XerathLocusOfPower","yoricksummondecayed","Bushwhack","karmaspiritbondc","SejuaniBasicAttackW","AatroxWONHAttackLife","AatroxWONHAttackPower","JinxWMissile","GragasWAttack","braumwdummyspell","syndrawcast","SorakaWParticleMissile"}
local ESpells = {"KogMawVoidOozeMissile","ToxicShotAttack","LeonaZenithBladeMissile","PowerFistAttack","VayneCondemnMissile","ShyvanaFireballMissile","maokaisapling2boom","VarusEMissile","CaitlynEntrapmentMissile","jayceaccelerationgate","syndrae5","JudicatorRighteousFuryAttack","UdyrBearAttack","RumbleGrenadeMissile","Slash","hecarimrampattack","ziggse2","UrgotPlasmaGrenadeBoom","SkarnerFractureMissile","YorickSummonRavenous","BlindMonkEOne","EliseHumanE","PrimalSurge","Swipe","ViEAttack","LissandraEMissile","yasuodummyspell","XerathMageSpearMissile","RengarEFinal","RengarEFinalMAX","KarthusDefileSoundDummy2"}
local RSpells = {"Pantheon_GrandSkyfall_Fall","LuxMaliceCannonMis","infiniteduresschannel","JarvanIVCataclysmAttack","jarvanivcataclysmattack","VayneUltAttack","RumbleCarpetBombDummy","ShyvanaTransformLeap","jaycepassiverangedattack", "jaycepassivemeleeattack","jaycestancegth","MissileBarrageMissile","SprayandPrayAttack","jaxrelentlessattack","syndrarcasttime","InfernalGuardian","UdyrPhoenixAttack","FioraDanceStrike","xeratharcanebarragedi","NamiRMissile","HallucinateFull","QuinnRFinale","lissandrarenemy","SejuaniGlacialPrisonCast","yasuordummyspell","xerathlocuspulse","tempyasuormissile","PantheonRFall"}
 
local casttype2 = {"blindmonkqtwo","blindmonkwtwo","blindmonketwo","infernalguardianguide","KennenMegaProc","sonawattackupgrade","redcardpreattack","fizzjumptwo","fizzjumpbuffer","gragasbarrelrolltoggle","LeblancSlideM","luxlightstriketoggle","UrgotHeatseekingHomeMissile","xeratharcanopulseextended","xeratharcanopulsedamageextended","XenZhaoThrust3","ziggswtoggle","khazixwlong","khazixelong","renektondice","SejuaniNorthernWinds","shyvanafireballdragon2","shyvanaimmolatedragon","ShyvanaDoubleAttackHitDragon","talonshadowassaulttoggle","viktorchaosstormguide","zedw2","ZedR2","khazixqlong","AatroxWONHAttackLife","viktorqbuff"}
local casttype3 = {"sonaeattackupgrade","bluecardpreattack","LeblancSoulShackleM","UdyrPhoenixStance","RenektonSuperExecute"}
local casttype4 = {"FrostShot","PowerFist","DariusNoxianTacticsONH","EliseR","JaxEmpowerTwo","JaxRelentlessAssault","JayceStanceHtG","jaycestancegth","jaycehypercharge","JudicatorRighteousFury","kennenlrcancel","KogMawBioArcaneBarrage","LissandraE","MordekaiserMaceOfSpades","mordekaisercotgguide","NasusQ","Takedown","NocturneParanoia","QuinnR","RengarQ","HallucinateFull","DeathsCaressFull","SivirW","ThreshQInternal","threshqinternal","PickACard","goldcardlock","redcardlock","bluecardlock","FullAutomatic","VayneTumble","MonkeyKingDoubleAttack","YorickSpectral","ViE","VorpalSpikes","FizzSeastonePassive","GarenSlash3","HecarimRamp","leblancslidereturn","leblancslidereturnm","Obduracy","UdyrTigerStance","UdyrTurtleStance","UdyrBearStance","UrgotHeatseekingMissile","XenZhaoComboTarget","dravenspinning","dravenrdoublecast","FioraDance","LeonaShieldOfDaybreak","MaokaiDrain3","NautilusPiercingGaze","RenektonPreExecute","RivenFengShuiEngine","ShyvanaDoubleAttack","shyvanadoubleattackdragon","SyndraW","TalonNoxianDiplomacy","TalonCutthroat","talonrakemissileone","TrundleTrollSmash","VolibearQ","AatroxW","aatroxw2","AatroxWONHAttackLife","JinxQ","GarenQ","yasuoq","XerathArcanopulseChargeUp","XerathLocusOfPower2","xerathlocuspulse","velkozqsplitactivate","NetherBlade","GragasQToggle","GragasW","SionW","sionpassivespeed"}
local casttype5 = {"VarusQ","ZacE","ViQ","SionQ"}
local casttype6 = {"VelkozQMissile","KogMawQMis","RengarEFinal","RengarEFinalMAX","BraumQMissile","KarthusDefileSoundDummy2","gnarqmissile","GnarBigQMissile","SorakaWParticleMissile"}
--,"PoppyDevastatingBlow"--,"Deceive" -- ,"EliseRSpider"
function getSpellType(unit, spellName)
        spelltype = "Unknown"
        casttype = 1
        if unit ~= nil and unit.type == "AIHeroClient" then
                if spellName == nil or unit:GetSpellData(_Q).name == nil or unit:GetSpellData(_W).name == nil or unit:GetSpellData(_E).name == nil or unit:GetSpellData(_R).name == nil then
                        return "Error name nil", casttype
                end
                if spellName:find("SionBasicAttackPassive") or spellName:find("zyrapassive") then
                        spelltype = "P"
                elseif (spellName:find("BasicAttack") and spellName ~= "SejuaniBasicAttackW") or spellName:find("basicattack") or spellName:find("JayceRangedAttack") or spellName == "SonaQAttack" or spellName == "SonaWAttack" or spellName == "SonaEAttack" or spellName == "ObduracyAttack" or spellName == "GnarBigAttackTower" then
                        spelltype = "BAttack"
                elseif spellName:find("CritAttack") or spellName:find("critattack") then
                        spelltype = "CAttack"
                elseif unit:GetSpellData(_Q).name:find(spellName) then
                        spelltype = "Q"
                elseif unit:GetSpellData(_W).name:find(spellName) then
                        spelltype = "W"
                elseif unit:GetSpellData(_E).name:find(spellName) then
                        spelltype = "E"
                elseif unit:GetSpellData(_R).name:find(spellName) then
                        spelltype = "R"
                elseif spellName:find("Summoner") or spellName:find("summoner") or spellName == "teleportcancel" then
                        spelltype = "Summoner"
                else
                        if spelltype == "Unknown" then
                                for i=1,#Others do
                                        if spellName:find(Others[i]) then
                                                spelltype = "Other"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#Items do
                                        if spellName:find(Items[i]) then
                                                spelltype = "Item"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#PSpells do
                                        if spellName:find(PSpells[i]) then
                                                spelltype = "P"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#QSpells do
                                        if spellName:find(QSpells[i]) then
                                                spelltype = "Q"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#WSpells do
                                        if spellName:find(WSpells[i]) then
                                                spelltype = "W"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#ESpells do
                                        if spellName:find(ESpells[i]) then
                                                spelltype = "E"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#RSpells do
                                        if spellName:find(RSpells[i]) then
                                                spelltype = "R"
                                        end
                                end
                        end
                end
                for i=1,#MSpells do
                        if spellName == MSpells[i] then
                                spelltype = spelltype.."M"
                        end
                end
                local spellexists = spelltype ~= "Unknown"
                if #spellslist > 0 and not spellexists then
                        for i=1,#spellslist do
                                if spellName == spellslist[i] then
                                        spellexists = true
                                end
                        end
                end
                if not spellexists then
                        table.insert(spellslist, spellName)
                        --writeConfigsspells()
                       -- PrintChat("Skill Detector - Unknown spell: "..spellName)
                end
        end
        for i=1,#casttype2 do
                if spellName == casttype2[i] then casttype = 2 end
        end
        for i=1,#casttype3 do
                if spellName == casttype3[i] then casttype = 3 end
        end
        for i=1,#casttype4 do
                if spellName == casttype4[i] then casttype = 4 end
        end
        for i=1,#casttype5 do
                if spellName == casttype5[i] then casttype = 5 end
        end
        for i=1,#casttype6 do
                if spellName == casttype6[i] then casttype = 6 end
        end
 
        return spelltype, casttype
end

if SCRIPTSTATUS then
    assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("XKNLQOKQQLP") 
end



class "_ScriptUpdate"
function _ScriptUpdate:__init(LocalVersion,UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion,CallbackError)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SavePath
    self.CallbackUpdate = CallbackUpdate
    self.CallbackNoUpdate = CallbackNoUpdate
    self.CallbackNewVersion = CallbackNewVersion
    self.CallbackError = CallbackError
    --AddDrawCallback(function() self:OnDraw() end)
    self:CreateSocket(self.VersionPath)
    self.DownloadStatus = 'Connect to Server for VersionInfo'
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function _ScriptUpdate:print(str)
    print('<font color="#FFFFFF">'..os.clock()..': '..str)
end

function _ScriptUpdate:OnDraw()
    if self.DownloadStatus ~= 'Downloading Script (100%)' then
        DrawText('Download Status: '..(self.DownloadStatus or 'Unknown'),50,10,50,ARGB(0xFF,0xFF,0xFF,0xFF))
    end
end

function _ScriptUpdate:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.Socket = self.LuaSocket.tcp()
    if not self.Socket then
        print('Socket Error')
    else
        self.Socket:settimeout(0, 'b')
        self.Socket:settimeout(99999999, 't')
        self.Socket:connect('sx-bol.eu', 80)
        self.Url = url
        self.Started = false
        self.LastPrint = ""
        self.File = ""
    end
end

function _ScriptUpdate:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function _ScriptUpdate:GetOnlineVersion()
    if self.GotScriptVersion then return end

    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading VersionInfo (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</s'..'ize>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading VersionInfo ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading VersionInfo (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.File:find('<scr'..'ipt>')
        local ContentEnd, _ = self.File:find('</sc'..'ript>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            self.OnlineVersion = (Base64Decode(self.File:sub(ContentStart + 1,ContentEnd-1)))
            self.OnlineVersion = tonumber(self.OnlineVersion)
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self:CreateSocket(self.ScriptPath)
                self.DownloadStatus = 'Connect to Server for ScriptDownload'
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        end
        self.GotScriptVersion = true
    end
end

function _ScriptUpdate:DownloadUpdate()
    if self.GotScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading Script (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
        local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
            local newf = newf:gsub('\r','')
            if newf:len() ~= self.Size then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
                return
            end
            local newf = Base64Decode(newf)
            if type(load(newf)) ~= 'function' then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
            else
                local f = io.open(self.SavePath,"w+b")
                f:write(newf)
                f:close()
                if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                    self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
                end
            end
        end
        self.GotScriptUpdate = true
    end
end


class "_Required"
function _Required:__init()
    self.requirements = {}
    self.downloading = {}
    return self
end

function _Required:Add(name, ext, url, UseHttps)
    --self.requirements[name] = url
    table.insert(self.requirements, {name, ext, url, UseHttps})
end

function _Required:Check()
    for i, tab in pairs(self.requirements) do
        local name, ext, url, UseHttps = tab[1], tab[2], tab[3], tab[4]
        if FileExist(LIB_PATH..name.."."..ext) then
            --require(name)
        else
            PrintMessage("Downloading ".. name.. ". Please wait...")
            local d = _Downloader(LIB_PATH..name.."."..ext, url, UseHttps)
            table.insert(self.downloading, d)
        end
    end
    
    if #self.downloading > 0 then
        for i = 1, #self.downloading, 1 do 
            local d = self.downloading[i]
            AddTickCallback(function() d:Download() end)
        end
        self:CheckDownloads()
    else
        for i, tab in pairs(self.requirements) do
            local name, ext, url, UseHttps = tab[1], tab[2], tab[3], tab[4]
            if FileExist(LIB_PATH..name.."."..ext) and ext == "lua" then
                require(name)
            end
        end
    end
end

function _Required:CheckDownloads()
    if #self.downloading == 0 then 
        PrintMessage("Required libraries downloaded. Please reload with 2x F9.")
    else
        for i = 1, #self.downloading, 1 do
            local d = self.downloading[i]
            if d.GotScriptUpdate then
                table.remove(self.downloading, i)
                break
            end
        end
        DelayAction(function() self:CheckDownloads() end, 2) 
    end 
end

function _Required:IsDownloading()
    return self.downloading ~= nil and #self.downloading > 0 or false
end


class "_Downloader"
function _Downloader:__init(path, url, UseHttps)
    self.SavePath = path
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(url)..'&rand='..math.random(99999999)
    self:CreateSocket(self.ScriptPath)
    self.DownloadStatus = 'Connect to Server'
end

function _Downloader:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.Socket = self.LuaSocket.tcp()
    if not self.Socket then
        print('Socket Error')
    else
        self.Socket:settimeout(0, 'b')
        self.Socket:settimeout(99999999, 't')
        self.Socket:connect('sx-bol.eu', 80)
        self.Url = url
        self.Started = false
        self.LastPrint = ""
        self.File = ""
    end
end

function _Downloader:Download()
    if self.GotScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading Script ('..math.round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading Script (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
        local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
            local newf = newf:gsub('\r','')
            if newf:len() ~= self.Size then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
                return
            end
            local newf = Base64Decode(newf)
            if type(load(newf)) ~= 'function' then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
            else
                local f = io.open(self.SavePath,"w+b")
                f:write(newf)
                f:close()
                if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                    self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
                end
            end
        end
        self.GotScriptUpdate = true
    end
end

function _Downloader:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end