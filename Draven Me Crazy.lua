--[[
    
    AUTHOR iCreative
    Credits to:
    lag free circles writers
    Aroc for ScriptUpdate :)
    Extragoz for getspelltype function
]]
local AUTOUPDATES = true --CHANGE THIS TO FALSE IF YOU DON'T WANT AUTOUPDATES
local FixItems = true -- CHANGE THIS TRUE OR FALSE IF BOL IS SUPPORTING ITEMS OR NOT
local scriptname = "Draven Me Crazy"
local author = "iCreative"
local version = 0.66
local champion = "Draven"
if myHero.charName:lower() ~= champion:lower() then return end

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("TGJHLHHIOHJ") 

local igniteslot = nil
local Passive = { Damage = function(target) return getDmg("P", target, myHero) end }
local AA = { Range = function(target) 
local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end
return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 + 50 end, Damage = function(target) return getDmg("AD", target, myHero) end }
local Q = { Range = 1075, Width = 60, Delay = 0.5, Speed = 1200, LastCastTime = 0, Collision = true, Aoe = false, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("P", target, myHero) end, IsCatching = false, Stacks  = 0}
local W = { Range = 950, Width = 315, Delay = 0.5, Speed = math.huge, LastCastTime = 0, Collision = false, Aoe = false, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return 0 end, HaveMoveSpeed = false, HaveAttackSpeed = false}
local E = { Range = 1050, Width = 130, Delay = 0.25, Speed = 1400, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end}
local R = { Range = 20000, Width = 150, Delay = 0.4, Speed = 2000, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end, Obj = nil}
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
Youmuu      = { Range = 800, Slot = function() return GetInventorySlotItem(3142) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
Randuin     = { Range = 500, Slot = function() return GetInventorySlotItem(3143) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
TwinShadows = { Range = 1000, Slot = function() return GetInventorySlotItem(3023) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3023) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3023)) == READY) end, Damage = function(target) return 0 end},
}

local attack = true
local move = true

local scriptLoaded = false

local VP = nil

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
        local scriptName = "Draven%20Me%20Crazy"
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.UseHttps = true
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/jachicao/BoL/master/version/"..scriptName..".version"
        ToUpdate.ScriptPath = "/jachicao/BoL/master/"..scriptName..".lua"
        ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
        ToUpdate.CallbackUpdate = function(NewVersion, OldVersion) PrintMessage("Updated to "..NewVersion..". Please reload with 2x F9.") end
        ToUpdate.CallbackNoUpdate = function(OldVersion) PrintMessage("No Updates Found.") end
        ToUpdate.CallbackNewVersion = function(NewVersion) PrintMessage("New Version found ("..NewVersion..").") end
        ToUpdate.CallbackError = function(NewVersion) PrintMessage("Error while downloading.") end
        _ScriptUpdate(ToUpdate.Version, ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
    end
end

function LoadVariables()
    interrupt = _Interrupt()
    PredictionTable = {}
    if FileExist(LIB_PATH.."VPrediction.lua") then VP = VPrediction() table.insert(PredictionTable, "VPrediction") end
    --if VIP_USER and FileExist(LIB_PATH.."Prodiction.lua") then require "Prodiction" table.insert(PredictionTable, "Prodiction") end 
    if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then require "DivinePred" DP = DivinePred() table.insert(PredictionTable, "DivinePred") end
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then igniteslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then igniteslot = SUMMONER_2
    end
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
    DelayAction(arrangePrioritys,5)
    DelayAction(function() prediction = Prediction(), 2 end)
    damage = Damage()
    axes = __Axes()
    orbwalker = Orbwalker()
    Config = scriptConfig(scriptname.." by "..author, scriptname.."version1.12")
    EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_HEALTH_ASC)
    JungleMinions = minionManager(MINION_JUNGLE, 900, myHero, MINION_SORT_MAXHEALTH_DEC)

    if FixItems then
    
        ItemNames               = {
        [3303]              = "ArchAngelsDummySpell",
        [3007]              = "ArchAngelsDummySpell",
        [3144]              = "BilgewaterCutlass",
        [3188]              = "ItemBlackfireTorch",
        [3153]              = "ItemSwordOfFeastAndFamine",
        [3405]              = "TrinketSweeperLvl1",
        [3411]              = "TrinketOrbLvl1",
        [3166]              = "TrinketTotemLvl1",
        [3450]              = "OdinTrinketRevive",
        [2041]              = "ItemCrystalFlask",
        [2054]              = "ItemKingPoroSnack",
        [2138]              = "ElixirOfIron",
        [2137]              = "ElixirOfRuin",
        [2139]              = "ElixirOfSorcery",
        [2140]              = "ElixirOfWrath",
        [3184]              = "OdinEntropicClaymore",
        [2050]              = "ItemMiniWard",
        [3401]              = "HealthBomb",
        [3363]              = "TrinketOrbLvl3",
        [3092]              = "ItemGlacialSpikeCast",
        [3460]              = "AscWarp",
        [3361]              = "TrinketTotemLvl3",
        [3362]              = "TrinketTotemLvl4",
        [3159]              = "HextechSweeper",
        [2051]              = "ItemHorn",
        --[2003]            = "RegenerationPotion",
        [3146]              = "HextechGunblade",
        [3187]              = "HextechSweeper",
        [3190]              = "IronStylus",
        [2004]              = "FlaskOfCrystalWater",
        [3139]              = "ItemMercurial",
        [3222]              = "ItemMorellosBane",
        [3042]              = "Muramana",
        [3043]              = "Muramana",
        [3180]              = "OdynsVeil",
        [3056]              = "ItemFaithShaker",
        [2047]              = "OracleExtractSight",
        [3364]              = "TrinketSweeperLvl3",
        [2052]              = "ItemPoroSnack",
        [3140]              = "QuicksilverSash",
        [3143]              = "RanduinsOmen",
        [3074]              = "ItemTiamatCleave",
        [3800]              = "ItemRighteousGlory",
        [2045]              = "ItemGhostWard",
        [3342]              = "TrinketOrbLvl1",
        [3040]              = "ItemSeraphsEmbrace",
        [3048]              = "ItemSeraphsEmbrace",
        [2049]              = "ItemGhostWard",
        [3345]              = "OdinTrinketRevive",
        [2044]              = "SightWard",
        [3341]              = "TrinketSweeperLvl1",
        [3069]              = "shurelyascrest",
        [3599]              = "KalistaPSpellCast",
        [3185]              = "HextechSweeper",
        [3077]              = "ItemTiamatCleave",
        [2009]              = "ItemMiniRegenPotion",
        [2010]              = "ItemMiniRegenPotion",
        [3023]              = "ItemWraithCollar",
        [3290]              = "ItemWraithCollar",
        [2043]              = "VisionWard",
        [3340]              = "TrinketTotemLvl1",
        [3090]              = "ZhonyasHourglass",
        [3154]              = "wrigglelantern",
        [3142]              = "YoumusBlade",
        [3157]              = "ZhonyasHourglass",
        [3512]              = "ItemVoidGate",
        [3131]              = "ItemSoTD",
        [3137]              = "ItemDervishBlade",
        [3352]              = "RelicSpotter",
        [3350]              = "TrinketTotemLvl2",
        }
        
        _G.ITEM_1               = 06
        _G.ITEM_2               = 07
        _G.ITEM_3               = 08
        _G.ITEM_4               = 09
        _G.ITEM_5               = 10
        _G.ITEM_6               = 11
        _G.ITEM_7               = 12
        
        ___GetInventorySlotItem = rawget(_G, "GetInventorySlotItem")
        _G.GetInventorySlotItem = GetSlotItem
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
    DelayAction(OrbLoad, 1)
    LoadMenu()
end

function LoadMenu()

    
    Config:addTS(ts)

    Config:addSubMenu(champion.." - Combo Settings", "Combo")
        Config.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_LIST, 3, { "Zero Spins", "One Spin", "Two Spins"})
        Config.Combo:addParam("useW","Use W", SCRIPT_PARAM_LIST, 2, { "Never", "If is not in range", "Always"})
        Config.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useR1","Use R if Killable", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useR2","Use R If Enemies >=", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
        Config.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(champion.." - Harass Settings", "Harass")
        Config.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_LIST, 2, { "Zero Spins", "One Spin", "Two Spins"})
        Config.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        
    Config:addSubMenu(champion.." - LaneClear Settings", "LaneClear")
        Config.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 2, { "Zero Spins", "One Spin", "Two Spins"})
        Config.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Config.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        Config.LaneClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    Config:addSubMenu(champion.." - JungleClear Settings", "JungleClear")
        Config.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 2, { "Zero Spins", "One Spin", "Two Spins"})
        Config.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Config.JungleClear:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    Config:addSubMenu(champion.." - LastHit Settings", "LastHit")
        Config.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        Config.LastHit:addParam("Mana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    Config:addSubMenu(champion.." - KillSteal Settings", "KillSteal")
        Config.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(champion.." - Axe Settings", "Axe")
        axes:LoadMenu(Config.Axe)

    Config:addSubMenu(champion.." - Auto Settings", "Auto")
        interrupt:LoadMenu(Config.Auto)

    Config:addSubMenu(champion.." - Misc Settings", "Misc")
        Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then Config.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.2, 0, 1, 1) end
        Config.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        Config.Misc:addParam("rRange","R Range", SCRIPT_PARAM_SLICE, 1500, 300, 4000, 0)
        Config.Misc:addParam("developer", "Developer Mode", SCRIPT_PARAM_ONOFF, false)
        Config.Misc:addParam("ExtraWindUp","Extra WindUpTime", SCRIPT_PARAM_SLICE, 0, -40, 400, 0)

    Config:addSubMenu(champion.." - Drawing Settings", "Draw")
        draw = _Draw()
        draw:LoadMenu(Config.Draw)

    Config:addSubMenu(champion.." - Key Settings", "Keys")
        Config.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        Config.Keys:addParam("LastHit", "Last Hit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        Config.Keys:addParam("Clear", "LaneClear or JungleClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V")) 
        Config.Keys:addParam("Flee", "Flee", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))

        Config.Keys.Combo = false
        Config.Keys.Harass = false
        Config.Keys.LastHit = false
        Config.Keys.Flee = false
        Config.Keys.Clear = false

    PrintMessage("Script by "..author..".")
    PrintMessage("Have Fun!.")
    scriptLoaded = true
end



function OnTick()
    if myHero.dead or not scriptLoaded then return end
    ts.target = GetCustomTarget()
    local targetObj = GetTarget()
    if targetObj ~= nil then
        if targetObj.type:lower():find("hero") and targetObj.team ~= myHero.team and ValidTarget(targetObj, ts.range) then
            ts.target = targetObj
        end
    end
    --KillSteal
        KillSteal()
    --run
    if Config.Keys.Flee then Flee() end

    axes:CheckCatch()

    if Config.Keys.Combo then Combo()
    elseif Config.Keys.Harass then Harass()
    elseif Config.Keys.Clear then Clear()
    elseif Config.Keys.LastHit then LastHit()
    end
end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, Config.Misc.rRange) and enemy.visible and enemy.health/enemy.maxHealth < 0.5 then
            if Config.KillSteal.useQ and Q.Damage(enemy) > enemy.health and not enemy.dead then CastQ(enemy) end
            if Config.KillSteal.useE and E.Damage(enemy) > enemy.health and not enemy.dead then CastE(enemy) end
            if Config.KillSteal.useR and R.Damage(enemy) > enemy.health and not enemy.dead then CastR(enemy) end
            if Config.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead  and ValidTarget(enemy, Ignite.Range) then CastSpell(igniteslot, enemy) end
        end
    end
end

function Flee()
    if orbwalker:CanMove() then myHero:MoveTo(mousePos.x, mousePos.z) end
    if W.IsReady() then CastSpell(_W) end
    if E.IsReady() then 
        local target = nil
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy, E.Range) then
                if target == nil then target = enemy
                elseif GetDistanceSqr(myHero, target) > GetDistanceSqr(myHero, enemy) then target = enemy
                end
            end
        end
        if ValidTarget(target, E.Range) then
            CastE(target)
        end
     end
end


function Combo()
    local target = ts.target
    if ValidTarget(target, ts.range) then
        if Config.Combo.useItems then UseItems(target) end
        if Config.Combo.useE then CastE(target) end
        if Config.Combo.useQ then CastQ(target, Config.Combo.useQ) end
        if Config.Combo.useW > 1 then CastW(target, Config.Combo.useW) end
        if Config.Combo.useR1 then
            local q, w, e, r, dmg = damage:getBestCombo(target)
            if r and dmg >= target.health then CastR(target) end
        end
        if Config.Combo.useR2 > 0 and R.IsReady() then
            local BestCastPosition, BestHitChance, BestCount = nil, nil, 0
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                if R.IsReady() and ValidTarget(enemy, Config.Misc.rRange) then

                    local lastTarget = GetLastRTarget()
                    local CastPosition,  HitChance,  Count = VP:GetLineAOECastPosition(enemy, R.Delay, R.Width, GetDistance(myHero, lastTarget) + 200, R.Speed, myHero)
                    if BestCount == 0 then BestCastPosition = CastPosition BestHitChance = HitChance BestCount = Count
                    elseif BestCount < Count then BestCastPosition = CastPosition BestHitChance = HitChance BestCount = Count end
                    
                end
            end
            if BestCount >= Config.Combo.useR2 and BestCastPosition ~= nil and BestHitChance ~=nil and BestHitChance >= 2 then
                CastSpell(_R, BestCastPosition.x, BestCastPosition.z)
            end
        end
    end
end

function Harass()
    if myHero.mana / myHero.maxMana * 100 >= Config.Harass.Mana then
        if Config.Harass.useQ and Q.IsReady() then 
            EnemyMinions:update() 
            for i, minion in pairs(EnemyMinions.objects) do
                if ValidTarget(minion, AA.Range(minion)) then
                    CastQ(minion, Config.Harass.useQ) 
                end
            end
        end
        local target = ts.target
        if ValidTarget(target) then
            if Config.Harass.useE then CastE(target) end
            if Config.Harass.useQ and Q.IsReady() then CastQ(target, Config.Harass.useQ) end
            if Config.Harass.useW then CastW(target) end
        end
    end
end

function Clear()
    if myHero.mana / myHero.maxMana * 100 >= Config.LaneClear.Mana then
        EnemyMinions:update() 
        for i, minion in pairs(EnemyMinions.objects) do
            if ValidTarget(minion)  and myHero.mana / myHero.maxMana * 100 >= Config.LaneClear.Mana then 
                if Config.LaneClear.useE and E.IsReady() then
                    local BestPos = GetBestLine(E.Range, E.Width, EnemyMinions.objects)
                    if BestPos ~= nil then CastSpell(_E, BestPos.x, BestPos.z) end
                end
    
                if Config.LaneClear.useQ and Q.IsReady() then
                    CastQ(minion, Config.LaneClear.useQ)
                end
    
                if Config.LaneClear.useW and W.IsReady() then
                    CastW(minion)
                end
            end
        end
    end


    if myHero.mana / myHero.maxMana * 100 >= Config.JungleClear.Mana then
        JungleMinions:update()
        for i, minion in pairs(JungleMinions.objects) do
            if ValidTarget(minion)  and myHero.mana / myHero.maxMana * 100 >= Config.JungleClear.Mana then 
                if Config.JungleClear.useE and E.IsReady() then
                    CastSpell(_E, minion.x, minion.z)
                end
                if Config.JungleClear.useQ and Q.IsReady() then
                    CastQ(minion, Config.JungleClear.useQ)
                end
    
                if Config.JungleClear.useW and W.IsReady() then
                    CastW(minion)
                end
            end
        end
    end
end

function LastHit()
    EnemyMinions:update() 
    for i, minion in pairs(EnemyMinions.objects) do
       if ValidTarget(minion, AA.Range(minion)) and Config.LastHit.useQ and Q.IsReady() then
            local predHealth = prediction:GetPredictedHealth(minion, 1)
            if damage:GetDamageToMinion(minion) > predHealth and predHealth > -40 then
                if axes:GetCountAxes() == 0 then
                    CastQ(minion, 2)
                end
            end
        end
        if ValidTarget(minion, E.Range) and Config.LastHit.useE and E.IsReady() then
            local time = E.Delay + GetDistance(minion.pos, myHero.pos) / E.Speed - 0.07
            local predHealth = prediction:GetPredictedHealth(minion, 1, time)
            if E.Damage(minion) > predHealth and predHealth > -40 then
                CastSpell(_E, minion.x, minion.z)
            end
        end
    end
end

--CastX
function CastQ(target, m)
    local mode = m ~= nil and m or 3
    if Q.IsReady() and ValidTarget(target, ts.range) and axes:GetCountAxes() < 2 and orbwalker:CanMove() then
        -- 2 spins
        if mode == 3 then
            CastSpell(_Q)
        -- 1 spins
        elseif mode == 2 then
            if axes:GetCountAxes() < 1 then CastSpell(_Q) end
        -- 0 spins
        elseif mode == 1 then

        end
    end
end

function CastW(target, m)
    local mode = m ~= nil and m or 3
    if W.IsReady() and ValidTarget(target, ts.range) and not W.HaveAttackSpeed then
        if mode == 2 then
            if not ValidTarget(target, AA.Range(target)) then
                CastSpell(_W)
            end
        elseif mode == 3 then
            CastSpell(_W)
        end
    end
end


function CastE(target)
    if E.IsReady() and ValidTarget(target, E.Range) then
        local CastPosition,  HitChance,  Count = prediction:GetPrediction(target, E.Delay, E.Width, E.Range, E.Speed, myHero, "linear", E.Collision, E.Aoe)
        if HitChance >= 2 then
            CastSpell(_E, CastPosition.x, CastPosition.z)
        end
    end
end

function CastR(target)
    if R.IsReady() and ValidTarget(target, Config.Misc.rRange) then
        local CastPosition,  HitChance,  Count = prediction:GetPrediction(target, R.Delay, R.Width, GetDistance(myHero, target) + 200, R.Speed, myHero, "linear", R.Collision, R.Aoe)
        if HitChance >= 2 then
            CastSpell(_R, CastPosition.x, CastPosition.z)
        end
    end
end

function getPercentageTeam(source, team, range) -- GetAllyHeroes() or GetEnemyHeroes()
    local count = 0
    if team == GetAllyHeroes() then count = 1 end
    for idx, champion in ipairs(team) do
        if champion.valid and champion.visible then
            if GetDistanceSqr(source, champion) <= range * range then
                count = count + champion.health/champion.maxHealth
            end
        end
    end
    return count
end


function OnProcessSpell(unit, spell)
    if myHero.dead or unit == nil or not scriptLoaded then return end
    if not unit.isMe then
    end
    if not unit.isMe then return end
    if spell.name:lower() == "dravenspinning" then Q.LastCastTime = os.clock()
    elseif spell.name:lower() == "dravendoubleshot" then E.LastCastTime = os.clock()
    elseif spell.name:lower():find("fury") then 
        W.LastCastTime = os.clock()
        W.HaveMoveSpeed = true
        W.HaveAttackSpeed = true
    elseif spell.name:lower() == "dravenrcast" then R.LastCastTime = os.clock()
    end
end

function RecvPacket(p)
    -- body
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

function GetCustomTarget()
    --if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    --if _G.Reborn_Initialised then return _G.AutoCarry.Crosshair:GetTarget() end
    ts:update()
    return ts.target
end


function GetSlotItem(id, unit)
    if FixItems then
        unit        = unit or myHero
    
        if (not ItemNames[id]) then
            return ___GetInventorySlotItem(id, unit)
        end
    
        local name  = ItemNames[id]
        
        for slot = ITEM_1, ITEM_7 do
            local item = unit:GetSpellData(slot).name
            if ((#item > 0) and (item:lower() == name:lower())) then
                return slot
            end
        end
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

function CountObjectsOnLineSegment(startPos, endPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(startPos, endPos, object)
        if isOnSegment and GetDistanceSqr(pointSegment, object) <= width * width then
            n = n + 1
        end
    end

    return n
end

function GetBestLine(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local endPos = Vector(myHero.visionPos) + range * (Vector(object) - Vector(myHero.visionPos)):normalized()
        local hit = CountObjectsOnLineSegment(myHero.visionPos, endPos, width, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function GetLastRTarget()
    local last = nil
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, Config.Misc.rRange) and enemy.visible then
            if last == nil then last = enemy
            elseif GetDistanceSqr(myHero, last) < GetDistanceSqr(myHero, enemy) then last = enemy end
        end
    end
    return last
end

function OnCreateObj(obj)
    --if obj and obj.name:lower():find("draven") then print("Created: "..obj.name) end
    if obj ~= nil and obj.valid and obj.name and GetDistanceSqr(myHero, obj) < 100 * 100 and obj.name:lower():find("linemissile") and os.clock() - R.LastCastTime < 0.5 then
        R.Obj = obj
    end
end

function OnDeleteObj(obj)
    --if obj and obj.name:lower():find("draven")  then print("Deleted: "..obj.name) end
    if obj ~= nil and obj.valid and obj.name and GetDistanceSqr(myHero, obj) < 100 * 100 and R.Obj ~= nil then
        if GetDistanceSqr(obj, R.Obj) < 50 * 50 then R.Obj = nil end
    elseif obj and obj.valid and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("_w")and obj.name:lower():find("_buf") then
        if obj.name:lower():find("move") then
            W.HaveMoveSpeed = false
        elseif obj.name:lower():find("attack") then
            W.HaveAttackSpeed = false
        end
    end
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

local OrbLoaded = ""

function OrbLoad()
    if _G.Reborn_Initialised then
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Combo", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Harass", AutoCarry.MODE_MIXEDMODE)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Clear", AutoCarry.MODE_LANECLEAR)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "LastHit", AutoCarry.MODE_LASTHIT)
        _G.AutoCarry.MyHero:AttacksEnabled(true)
        OrbLoaded = "SAC"
    elseif _G.Reborn_Loaded then
        DelayAction(OrbLoad, 1)
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
        require 'SxOrbWalk'
        Sx = SxOrbWalk()
        --Config:addSubMenu(scriptname.." - Orbwalking", "Orbwalking")
        Sx:LoadToMenu()
        Sx:RegisterHotKey("harass",  Config.Keys, "Harass")
        Sx:RegisterHotKey("fight",  Config.Keys, "Combo")
        Sx:RegisterHotKey("laneclear",  Config.Keys, "Clear")
        Sx:RegisterHotKey("lasthit",  Config.Keys, "LastHit")
        Sx:EnableAttacks()
        OrbLoaded = "SxOrb"
    else
    end
end

function Latency()
    return 0.06
end

function DisableMovement()
    if move then
        if Config.Misc.developer then PrintMessage("Disabling Movement") end
        if OrbLoaded == "SAC" then
            _G.AutoCarry.MyHero:MovementEnabled(false)
            move = false
        elseif OrbLoaded == "SxOrb" then
            SxOrb:DisableMove()
            move = false
        end
    end
end

function EnableMovement()
    if not move then
        if Config.Misc.developer then PrintMessage("Enabling Movement") end
        if OrbLoaded == "SAC" then
            _G.AutoCarry.MyHero:MovementEnabled(true)
            move = true
        elseif OrbLoaded == "SxOrb" then
            Sx:EnableMove()
            move = true
        end
    end
end

function DisableAttacks()
    if attack then
        if OrbLoaded == "SAC" then
            if Config.Misc.developer then PrintMessage("Disabling Attacks") end
            _G.AutoCarry.MyHero:AttacksEnabled(false)
            attack = false
        elseif OrbLoaded == "SxOrb" then
            if Config.Misc.developer then PrintMessage("Disabling Attacks") end
            Sx:DisableAttacks()
            attack = false
        end
    end
end

function EnableAttacks()
    if not attack then
        if OrbLoaded == "SAC" then
         if Config.Misc.developer then PrintMessage("Enabling Attacks") end
            _G.AutoCarry.MyHero:AttacksEnabled(true)
            attack = true
        elseif OrbLoaded == "SxOrb" then
            if Config.Misc.developer then PrintMessage("Enabling Attacks") end
            Sx:EnableAttacks()
            attack = true
        end
    end
end

function IsKeyPressed()
    return Config.Keys.Combo or Config.Keys.Harass or Config.Keys.Clear or Config.Keys.LastHit
end

function GetAARange(unit)
    return ValidTarget(unit) and unit.range + unit.boundingRadius + myHero.boundingRadius / 2 or 0
end

class "__Axes"

function __Axes:__init()
    self.AxesAvailables = {}
    self.CurrentAxes = 0
    self.Stack = 0
    self.AxeRadius = 100
    self.LimitTime = 1.2
    self.Menu = nil
    self.lastCheck = 0
end

function __Axes:LoadMenu(m)
    self.Menu = m
    if self.Menu ~= nil then
        self.Menu:addParam("Catch", "Catch Axes (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("Z"))
        self.Menu:addParam("CatchMode", "Catch Condition", SCRIPT_PARAM_LIST, 1, {"When Orbwalking", "AutoCatch"})
        self.Menu:addParam("OrbwalkMode",  "Catch Mode", SCRIPT_PARAM_LIST, 2, {"Mouse In Radius", "MyHero In Radius"})
        self.Menu:addParam("AABetween", "Use AA between Catching", SCRIPT_PARAM_ONOFF, false)
        self.Menu:addParam("UseW", "Use W to Catch (Smart)", SCRIPT_PARAM_ONOFF, false)
        self.Menu:addParam("Turret", "Dont Catch Under Turret", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addParam("DelayCatch", "% of Delay to Catch", SCRIPT_PARAM_SLICE, 100, 0, 100)
        self.Menu:addSubMenu("Catch Radius", "CatchRadius")
        self.Menu.CatchRadius:addParam("Combo", "Combo Radius", SCRIPT_PARAM_SLICE, 250, 150, 600, 0)
        self.Menu.CatchRadius:addParam("Harass", "Harass Radius", SCRIPT_PARAM_SLICE, 350, 150, 600, 0)
        self.Menu.CatchRadius:addParam("Clear", "Clear Radius", SCRIPT_PARAM_SLICE, 400, 150, 800, 0)
        self.Menu.CatchRadius:addParam("LastHit", "LastHit Radius", SCRIPT_PARAM_SLICE, 400, 150, 800, 0)
        self.Menu:addParam("DrawRadius", "Draw Catch Radius", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addSubMenu("Draw Catch Radius", "Draw")
        self.Menu.Draw:addParam("Enable","Enable", SCRIPT_PARAM_ONOFF, true)
        self.Menu.Draw:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 0, 0, 255 })
        self.Menu.Draw:addParam("Width","Width", SCRIPT_PARAM_SLICE, 2, 1, 5)
        self.Menu:permaShow("Catch")
        self.Menu:permaShow("CatchMode")
        self.Menu:permaShow("OrbwalkMode")
        --self.Menu:permaShow("DelayCatch")
        AddDrawCallback(function() self:OnDraw() end)
        AddCreateObjCallback(function(obj) self:OnCreateObj(obj) end)
        AddDeleteObjCallback(function(obj) self:OnDeleteObj(obj) end)
    end
end

function __Axes:OnDraw()
    if self.Menu ~= nil and not myHero.dead then
        if Config.Misc.developer then 
            local pos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
            --local string = "CanAttack: "..tostring(attack).." CanMove: "..tostring(move)
            local string = "Stacks: "..self:GetCountAxes()
            DrawText(string, 16, pos.x, pos.y,  Colors.White)
        end


        if self.Menu.Draw.Enable then
            if #self.AxesAvailables > 0 then
                for i = 1, #self.AxesAvailables, 1 do
                    local axe, time = self.AxesAvailables[i][1], self.AxesAvailables[i][2]
                    if axe~= nil and axe.valid then
                        local color = self.Menu.Draw.Color
                        local width = self.Menu.Draw.Width
                        draw:DrawCircle2(axe.x, axe.y, axe.z, self:GetRadius(), ARGB(color[1], color[2], color[3], color[4]), width)
                    end
                end
            end
        end
    end
end

function __Axes:GetCountAxes()
    return #self.AxesAvailables + self.CurrentAxes
end

function __Axes:GetDelayCatch()
    return (self.Menu~=nil and (self.Menu.DelayCatch / 100)) or 1
end

function __Axes:GetRadius()
    if Config.Keys.Combo then
        return self.Menu.CatchRadius.Combo
    elseif Config.Keys.Harass then
        return self.Menu.CatchRadius.Harass
    elseif Config.Keys.Clear then
        return self.Menu.CatchRadius.Clear
    elseif Config.Keys.LastHit then
        return self.Menu.CatchRadius.LastHit
    elseif self.Menu~=nil then
        return self.Menu.CatchRadius.Clear
    end
end

function __Axes:InTurret(obj)
    local offset = VP:GetHitBox(myHero) / 2
    if obj ~= nil and obj.valid and self.Menu ~= nil and self.Menu.Turret then
        if GetTurrets() ~= nil then
            for name, turret in pairs(GetTurrets()) do
                if turret ~= nil and turret.valid and GetDistanceSqr(obj, turret) <= (turret.range + offset) * (turret.range + offset) then
                    if turret.team ~= myHero.team then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function __Axes:GetBonusSpeed()
    return myHero:GetSpellData(_W).level > 0 and (100 + 35 + myHero:GetSpellData(_W).level * 5)/100 or 1
end

function __Axes:GetSource()
    return self.Menu.OrbwalkMode == 1 and Vector(mousePos) or Vector(myHero)
end

function __Axes:InRadius(axe)
    return axe ~= nil and axe.valid and GetDistanceSqr(self:GetSource(), axe) < self:GetRadius() * self:GetRadius()
end

function __Axes:InAxeRadius(axe)
    local AxeRadius = 1 / 1 * self.AxeRadius
    return axe ~= nil and axe.valid and GetDistanceSqr(myHero.pos, axe) < AxeRadius * AxeRadius
end

function __Axes:GetSortedList()
    local SortedList = {}
    if #self.AxesAvailables > 0  then
        for i = 1, #self.AxesAvailables, 1 do
            local axe, time = self.AxesAvailables[i][1], self.AxesAvailables[i][2]
            if axe ~= nil and axe.valid and self:InRadius(axe) then
                if #SortedList == 0 then table.insert(SortedList, 1, {axe, time})
                else
                    local axe2, time2 = self.AxesAvailables[#SortedList][1], self.AxesAvailables[#SortedList][2]
                    local timeLeft = self.LimitTime - (os.clock() - time)
                    local timeLeft2 = self.LimitTime - (os.clock() - time2)
                    if timeLeft > timeLeft2 then
                        table.insert(SortedList, #SortedList + 1, {axe, time})
                    else
                        table.insert(SortedList, #SortedList, {axe, time})
                    end
                end
            end
        end
    end
    return SortedList
end


function __Axes:CheckCatch()
    local List = self.AxesAvailables--self:GetSortedList()
    if #List > 0 then
        if self.Menu~=nil and self.Menu.Catch and (( self.Menu.CatchMode == 1 and IsKeyPressed()) or self.Menu.CatchMode == 2 ) then
            --for i = 1, #List, 1 do
            local i = 1
                local axe, time = List[i][1], List[i][2]
                if axe ~= nil and axe.valid and os.clock() - time <= self.LimitTime and self:InRadius(axe) and not self:InTurret(axe) then
                    local timeLeft = self.LimitTime - (os.clock() - time)
                    local multiplier = 1
                    local AxeRadius = 1 / 1 * self.AxeRadius / multiplier
                    local AxeCatchPositionFromHero  = Vector(axe) + Vector(Vector(myHero) - Vector(axe)):normalized() * math.min(AxeRadius, GetDistance(myHero, axe))
                    local AxeCatchPositionFromMouse = Vector(axe) + Vector(Vector(mousePos) - Vector(axe)):normalized() * math.min(AxeRadius, GetDistance(mousePos, axe))
                    local OrbwalkPosition = Vector(myHero) + Vector(Vector(mousePos) - Vector(axe)):normalized() * AxeRadius * multiplier
                    local CanMove = false
                    local CanAttack = false
                    local time = timeLeft - ((GetDistance(myHero, AxeCatchPositionFromHero)) / myHero.ms) - (orbwalker:WindUpTime() - orbwalker:ExtraWindUp() + orbwalker:Latency() + AA.Range(ts.target) / prediction.ProjectileSpeed - 100/1000)
                    --Is in AxeRange
                    --cannot orbwalk
                    if self:InAxeRadius(axe) then
                        CanAttack = true
                    --Can Attack Meanwhile
                    elseif self.Menu.AABetween and time >= 0 and orbwalker:CanAttack(0) and orbwalker:CanAttack(time) then --+ orbwalker:WindUpTime() -
                        CanAttack = true
                        orbwalker.bufferAA = true
                        DelayAction(function()
                            orbwalker.bufferAA = false
                        end, orbwalker:Latency() * 2)
                        if Config.Misc.developer then print("Can Attack Meanwhile") end
                    elseif orbwalker:AnimationTime() * 1 + (GetDistance(myHero, AxeCatchPositionFromHero)) / myHero.ms < timeLeft then --+ orbwalker:WindUpTime()
                        CanAttack = true
                        if Config.Misc.developer then print("Can Attack Meanwhile2") end
                    else
                        CanAttack = false
                    end
                    if GetDistance(myHero, AxeCatchPositionFromHero) + GetDistance(myHero, OrbwalkPosition) > myHero.ms * timeLeft * self:GetDelayCatch() then
                        CanMove = false
                        --can catch without W and self:GetCountAxes() > 1
                        if not self:InAxeRadius(axe) and GetDistanceSqr(myHero, AxeCatchPositionFromHero) > (myHero.ms * timeLeft * 1.5) * (myHero.ms * timeLeft * 1.5) and GetDistanceSqr(myHero, AxeCatchPositionFromHero) < (myHero.ms * timeLeft * self:GetBonusSpeed()) * (myHero.ms * timeLeft * self:GetBonusSpeed()) then
                            if self.Menu.UseW and W.IsReady() then
                                CastSpell(_W)
                            end
                        end
                    --can orbwalk
                    else
                        CanMove = true
                    end

                    if CanAttack then
                        EnableAttacks()
                    else
                        DisableAttacks()
                    end
                    if CanMove then
                        EnableMovement()
                    else
                        DisableMovement()
                        if not self:InAxeRadius(axe) and orbwalker:CanMove() then
                            if Config.Misc.developer then PrintMessage("Moving to Axe") end
                            myHero:MoveTo(axe.x, axe.z) 
                        end
                    end
                    self.lastCheck = os.clock()
                end
                if os.clock() - time > self.LimitTime + 0.2 then
                    self:RemoveAxe(axe)
                end
            --end
            
        else
            EnableAttacks()
            EnableMovement()
        end
    else
        EnableAttacks()
        EnableMovement()
    end
end



function __Axes:RemoveAxe(obj)
    if #self.AxesAvailables > 0 then
        for i = 1, #self.AxesAvailables, 1 do
            local axe, time = self.AxesAvailables[i][1], self.AxesAvailables[i][2]
            if axe ~= nil and GetDistanceSqr(axe, obj) < 30 * 30 and axe.name == obj.name then
                table.remove(self.AxesAvailables, i)
                break
            end
        end
    end
end

function __Axes:OnCreateObj(obj)
    if self.Menu == nil then return end
    --if obj and obj.name and obj.name:lower():find("draven") then print("Created: "..obj.name) end
    --if obj and obj.team and obj.team ~= myHero.team then return end
    if obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_reticle.troy") and GetDistanceSqr(myHero, obj) <= (self.LimitTime * myHero.ms) * (self.LimitTime * myHero.ms) then
        --table.insert(self.AxesAvailables, {obj, os.clock()})
        --DelayAction(funcftion(i) table.remove(self.AxesAvailables, i) end, self.LimitTime + 0.05, {#self.AxesAvailable + 1} )
        --DelayAction(function() self:RemoveAxe(obj) end, self.LimitTime + 0.2)
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_reticle_self.troy") and GetDistanceSqr(myHero, obj) <= (self.LimitTime * myHero.ms) * (self.LimitTime * myHero.ms) then
        table.insert(self.AxesAvailables, {obj, os.clock()})
        --DelayAction(function(i) table.remove(self.AxesAvailables, i) end, self.LimitTime + 0.05, {#self.AxesAvailable + 1} )
        DelayAction(function() self:RemoveAxe(obj) end, self.LimitTime + 0.2)
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_buf.troy") then
        self.CurrentAxes = self.CurrentAxes + 1
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_tar.troy") then
        --self.CurrentAxes = self.CurrentAxes + 1
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("reticlecatchsuccess.troy") then
        --print(GetDistance(myHero, obj))
        self:RemoveAxe(obj)
    end
end

function __Axes:OnDeleteObj(obj)
    if self.Menu == nil then return end
    --if obj and obj.name and obj.name:lower():find("draven") then print("Deleted: "..obj.name) end
    --if obj and obj.team and obj.team ~= myHero.team then return end
    if obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_reticle.troy") then
        self:RemoveAxe(obj)
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_reticle_self.troy") then
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_buf.troy") then  
        if self.CurrentAxes > 0 then self.CurrentAxes = self.CurrentAxes - 1 end
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("q_tar.troy") then  
        --if self.CurrentAxes > 0 then self.CurrentAxes = self.CurrentAxes - 1 end
    elseif obj and obj.name and obj.name:lower():find("draven") and obj.name:lower():find("reticlecatchsuccess.troy") then
    end
end

class "_Interrupt"
function _Interrupt:__init()
    self.Menu = nil
    self.INTERRUPTIBLE_SPELLS = {
        ["KatarinaR"]                          = { charName = "Katarina",     DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["Meditate"]                           = { charName = "MasterYi",     DangerLevel = 1, MaxDuration = 2.5, CanMove = false },
        ["Drain"]                              = { charName = "FiddleSticks", DangerLevel = 3, MaxDuration = 2.5, CanMove = false },
        ["Crowstorm"]                          = { charName = "FiddleSticks", DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["GalioIdolOfDurand"]                  = { charName = "Galio",        DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["MissFortuneBulletTime"]              = { charName = "MissFortune",  DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["VelkozR"]                            = { charName = "Velkoz",       DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["InfiniteDuress"]                     = { charName = "Warwick",      DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["AbsoluteZero"]                       = { charName = "Nunu",         DangerLevel = 4, MaxDuration = 2.5, CanMove = false },
        ["ShenStandUnited"]                    = { charName = "Shen",         DangerLevel = 3, MaxDuration = 2.5, CanMove = false },
        ["FallenOne"]                          = { charName = "Karthus",      DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["AlZaharNetherGrasp"]                 = { charName = "Malzahar",     DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
        ["Pantheon_GrandSkyfall_Jump"]         = { charName = "Pantheon",     DangerLevel = 5, MaxDuration = 2.5, CanMove = false },
    }
    self.GAPCLOSER_SPELLS = {
        ["AatroxQ"]              = "Aatrox",
        ["AkaliShadowDance"]     = "Akali",
        ["Headbutt"]             = "Alistar",
        ["FioraQ"]               = "Fiora",
        ["DianaTeleport"]        = "Diana",
        ["EliseSpiderQCast"]     = "Elise",
        ["FizzPiercingStrike"]   = "Fizz",
        ["GragasE"]              = "Gragas",
        ["HecarimUlt"]           = "Hecarim",
        ["JarvanIVDragonStrike"] = "JarvanIV",
        ["IreliaGatotsu"]        = "Irelia",
        ["JaxLeapStrike"]        = "Jax",
        ["KhazixE"]              = "Khazix",
        ["khazixelong"]          = "Khazix",
        ["LeblancSlide"]         = "LeBlanc",
        ["LeblancSlideM"]        = "LeBlanc",
        ["BlindMonkQTwo"]        = "LeeSin",
        ["LeonaZenithBlade"]     = "Leona",
        ["UFSlash"]              = "Malphite",
        ["Pantheon_LeapBash"]    = "Pantheon",
        ["PoppyHeroicCharge"]    = "Poppy",
        ["RenektonSliceAndDice"] = "Renekton",
        ["RivenTriCleave"]       = "Riven",
        ["SejuaniArcticAssault"] = "Sejuani",
        ["slashCast"]            = "Tryndamere",
        ["ViQ"]                  = "Vi",
        ["MonkeyKingNimbus"]     = "MonkeyKing",
        ["XenZhaoSweep"]         = "XinZhao",
        ["YasuoDashWrapper"]     = "Yasuo"
    }

end

function _Interrupt:LoadMenu(m)
    self.Menu = m
    if self.Menu ~= nil then
        self.Menu:addSubMenu("Use E To Interrupt", "UseE")
        if #GetEnemyHeroes() > 0 then
            for idx, enemy in ipairs(GetEnemyHeroes()) do
                local champion = enemy.charName
                self.Menu.UseE:addParam(champion.."Q", champion.." (Q)", SCRIPT_PARAM_ONOFF, false)
                self.Menu.UseE:addParam(champion.."W", champion.." (W)", SCRIPT_PARAM_ONOFF, false)
                self.Menu.UseE:addParam(champion.."E", champion.." (E)", SCRIPT_PARAM_ONOFF, false)
                self.Menu.UseE:addParam(champion.."R", champion.." (R)", SCRIPT_PARAM_ONOFF, false)
            end
        end
        self.Menu:addParam("Time",  "Time Limit to Interrupt", SCRIPT_PARAM_SLICE, 3, 0, 8, 0)
        AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
    end
end

function _Interrupt:OnProcessSpell(unit, spell)
    if self.Menu == nil or spell == nil or unit == nil or not unit.valid or myHero.dead then return end
    if not unit.isMe then
        if unit.type == myHero.type and unit.team ~= myHero.team and ValidTarget(unit, E.Range + 500) then
            local spelltype, casttype = getSpellType(unit, spell.name)
            if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
                if self.Menu.UseE[unit.charName..spelltype] then 
                    self:ForceE(unit, os.clock())
                end
            end
        end
    end
end

function _Interrupt:ForceE(target, time)
   if not ValidTarget(target) or os.clock() - time > self.Menu.Time then return end
    --print("castingE")
    if E.IsReady() and ValidTarget(target, E.Range + 500) then
        CastE(target)
    end
    if ValidTarget(target, E.Range + 500) then
        DelayAction(function(target, time) self:ForceE(target, time) end, 0.1, {target, time})
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
        if spell.name:lower():find("attack") then
            --if not self.dataUpdated then
                self.baseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
                self.baseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
                self.dataUpdated = true
            --end
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

function Orbwalker:CanAttack(ExtraTime)
    return os.clock() - self.AA.LastTime >= self:AnimationTime() - self:Latency() + ExtraTime~=nil and ExtraTime or 0
end

function Orbwalker:CanMove()
    return os.clock() - self.AA.LastTime >= self:WindUpTime() - self.Latency() and not self.bufferAA and not self.AA.isAttacking and not self:Evade()
end

function Orbwalker:Latency()
    return GetLatency() / 2000
end

function Orbwalker:Evade()
    return _G.evade or _G.Evade
end


function Orbwalker:ExtraWindUp()
    return Config.Misc.ExtraWindUp / 1000
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
                    state, pos, perc = DP:predict(unit, asd, hitchance)
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

--farm and more
function Prediction:GetTimeMinion(minion, mode)
    local time = 0
    --lasthit
    if mode == 1 then
        --time = Classes.Orbwalker:WindUpTime() - Classes.Orbwalker:ExtraWindUp() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - self.delay
        time = orbwalker:WindUpTime() - orbwalker:ExtraWindUp() + orbwalker:Latency() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - 100/1000
    --laneclear
    elseif mode == 2 then
        time = orbwalker:AnimationTime() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - self.delay
        --time = Classes.Orbwalker:AnimationTime()
        time = time * 2
    end
    return math.max(time, 0)
end

function Prediction:GetPredictedHealth(minion, mode, t)
    local health = minion.health
    local time = t ~=nil and t or self:GetTimeMinion(minion, mode)
    if mode == 1 then
        local predHealth, maxdamage, count = VP:GetPredictedHealth(minion, time, 0)
        health = predHealth
    elseif mode == 2 then
        local predHealth, maxdamage, count = VP:GetPredictedHealth2(minion, time)
        health = predHealth
    end
    return health
    -- body
end

class "Damage"
function Damage:__init()
    --q, w, e , r, dmg, clock
    self.PredictedDamage = {}
    self.RefreshTime = 0.3
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
            currentManaWasted = currentManaWasted + W.Mana()
            comboDamage = comboDamage + AA.Damage(target) * 2
        end
        if e then
            comboDamage = comboDamage + E.Damage(target)
            currentManaWasted = currentManaWasted + E.Mana()
        end
        if r then
            comboDamage = comboDamage + R.Damage(target)
            currentManaWasted = currentManaWasted + R.Mana()
        end
        comboDamage = comboDamage + AA.Damage(target) * 2
        for _, item in pairs(CastableItems) do
            if item.IsReady() then
                comboDamage = comboDamage + item.Damage(target)
            end
        end
    end
    comboDamage = comboDamage * self:getOverkill()
    return comboDamage, currentManaWasted
end

function Damage:GetDamageToMinion(minion)
    local axedmg = axes:GetCountAxes() > 0 and Q.Damage(minion) or 0
    return VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + axedmg
end

function Damage:getOverkill()
    return (100 + Config.Misc.overkill)/100
end

class "_Draw"
function _Draw:__init()
    self.Menu = nil
end
function _Draw:LoadMenu(menu)
    self.Menu = menu
    self.Menu:addSubMenu("E", "E")
    self.Menu.E:addParam("Range","Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.E:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.E:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addSubMenu("R", "R")
    self.Menu.R:addParam("Range","Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.R:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.R:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
    self.Menu:addParam("dmgCalc","Damage Prediction Bar", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Target","Red Circle on Target", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Quality", "Quality of Circles", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
    AddDrawCallback(function() self:OnDraw() end)
end

function _Draw:OnDraw()
    if myHero.dead or self.Menu == nil then return end
    if self.Menu.dmgCalc then self:DrawPredictedDamage() end
    if self.Menu.Target and ts.target ~= nil and ValidTarget(ts.target) then
        self:DrawCircle2(ts.target.x, ts.target.y, ts.target.z, VP:GetHitBox(ts.target)*1.5, Colors.Red, 3)
    end


    if self.Menu.E.Range and E.IsReady() then
        local color = self.Menu.E.Color
        local width = self.Menu.E.Width
        local range =           E.Range
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.R.Range and R.IsReady() then
        local color = self.Menu.R.Color
        local width = self.Menu.R.Width
        local range =           Config.Misc.rRange
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end
end

function _Draw:DrawPredictedDamage() 
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


function _Draw:GetHPBarPos(enemy)
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

function _Draw:DrawLineHPBar(damage, text, unit, enemyteam)
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
function _Draw:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
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
function _Draw:round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function _Draw:DrawCircle2(x, y, z, radius, color, width)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        self:DrawCircleNextLvl(x, y, z, radius, width, color, (75 + 2000 * (100 - self.Menu.Quality)/100)) 
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