--[[
    
    AUTHOR iCreative
    Credits to:
    lag free circles writers
    Aroc for ScriptUpdate :)
]]
local AUTOUPDATES = true --CHANGE THIS TO FALSE IF YOU DON'T WANT AUTOUPDATES
local FixItems = true -- CHANGE THIS TRUE OR FALSE IF BOL IS SUPPORTING ITEMS OR NOT
local scriptname = "Dat Butt Irelia"
local author = "iCreative"
local version = 1.020
local champion = "Irelia"
if myHero.charName:lower() ~= champion:lower() then return end
--tracker
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("PCFDFDEGHFE") 

local igniteslot = nil
local Passive = { Damage = function(target) return getDmg("P", target, myHero) end }
local AA = { Range = function(target) 
local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end
return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 - 15 end, Damage = function(target) return getDmg("AD", target, myHero) end }
local Q = { Range = 650, Width = 60, Delay = 0.5, Speed = 2200, LastCastTime = 0, Collision = true, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) + getDmg("AD", target, myHero) end}
local W = { Range = function(target) return AA.Range(target) end, ExtraRange = 500, Width = 315, Delay = 0.5, Speed = math.huge, LastCastTime = 0, Collision = false, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
local E = { Range = 330, Width = 160, Delay = 0.3, Speed = math.huge, LastCastTime = 0, Collision = false, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end}
local R = { Range = 1000, Width = 120, Delay = 0.5, Speed = 1600, LastCastTime = 0, Collision = false, Aoe = true, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Mana = function() return myHero:GetSpellData(_R).mana end, Damage = function(target) return getDmg("R", target, myHero) end}
local Ignite = { Range = 600, IsReady = function() return (igniteslot ~= nil and myHero:CanUseSpell(igniteslot) == READY) end, Damage = function(target) return getDmg("IGNITE", target, myHero) end}
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}
local CastableItems = {
Tiamat      = { Range = 400, Slot = function() return GetInventorySlotItem(3077) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3077) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) end, Damage = function(target) return getDmg("TIAMAT", target, myHero) end},
Hydra       = { Range = 400, Slot = function() return GetInventorySlotItem(3074) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3074) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) end, Damage = function(target) return getDmg("HYDRA", target, myHero) end},
Bork        = { Range = 450, Slot = function() return GetInventorySlotItem(3153) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end, Damage = function(target) return getDmg("RUINEDKING", target, myHero) end},
Bwc         = { Range = 400, Slot = function() return GetInventorySlotItem(3144) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end, Damage = function(target) return getDmg("BWC", target, myHero) end},
Hextech     = { Range = 400, Slot = function() return GetInventorySlotItem(3146) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3146) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY) end, Damage = function(target) return getDmg("HXG", target, myHero) end},
Blackfire   = { Range = 750, Slot = function() return GetInventorySlotItem(3188) end, reqTarget = true, IsReady = function() return (GetInventorySlotItem(3188) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3188)) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", target, myHero) end},
Youmuu      = { Range = 350, Slot = function() return GetInventorySlotItem(3142) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
Randuin     = { Range = 500, Slot = function() return GetInventorySlotItem(3143) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
TwinShadows = { Range = 1000, Slot = function() return GetInventorySlotItem(3023) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3023) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3023)) == READY) end, Damage = function(target) return 0 end},
}

local scriptLoaded = false

local visionRange = 1800

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
    local scriptName = "Dat%20Butt%20Irelia"
    if AUTOUPDATES then
        local ToUpdate = {}
        ToUpdate.ScriptName = scriptname
        ToUpdate.Version = version
        ToUpdate.UseHttps = true
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.Host2 = "raw.github.com"
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
function OnLoad()
     local r = _Required()
    r:Add("VPrediction", "lua", "raw.githubusercontent.com/SidaBoL/Scripts/master/Common/VPrediction.lua", true)
    --if VIP_USER then r:Add("Prodiction", "lua", "bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/master/Test/Prodiction/Prodiction.lua", true) end
    --if VIP_USER then r:Add("DivinePred", "luac", "divinetek.rocks/divineprediction/DivinePred.luac", false) end
    --if VIP_USER then r:Add("DivinePred", "lua", "divinetek.rocks/divineprediction/DivinePred.lua", false) end
    r:Check()
    if r:IsDownloading() then return end
    DelayAction(function() CheckUpdate() end, 5)
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
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then igniteslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then igniteslot = SUMMONER_2
    end
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900 ,DAMAGE_PHYSICAL)
    DelayAction(arrangePrioritys,5)PredictionTable = {}
    if FileExist(LIB_PATH.."VPrediction.lua") then VP = VPrediction() table.insert(PredictionTable, "VPrediction") end
    --if VIP_USER and FileExist(LIB_PATH.."Prodiction.lua") then require "Prodiction" table.insert(PredictionTable, "Prodiction") end 
    if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then require "DivinePred" DP = DivinePred() table.insert(PredictionTable, "DivinePred") end
    prediction = Prediction()
    damage = Damage()
    Config = scriptConfig(scriptname.." by "..author, scriptname.."version1.01")
    EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    JungleMinions = minionManager(MINION_JUNGLE, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    DelayAction(OrbLoad, 1)
    LoadMenu()
end

function LoadMenu()

    
    Config:addTS(ts)

    Config:addSubMenu(scriptname.." - Combo Settings", "Combo")
        Config.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("minQRange", "Min. Q Range", SCRIPT_PARAM_SLICE, 250, 0, 650)
        Config.Combo:addParam("useQMinion","Use Q on Minion To GapClose", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useE","Use E", SCRIPT_PARAM_LIST, 2, { "Never", "To Stun", "Smart", "Always"})
        Config.Combo:addParam("useR","Use R", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useRMinion","Use R On Minion To GapClose", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useItems","Use Items", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_LIST, 1, {"Never", "If Killable" , "Always"})
        Config.Combo:addParam("Range", "Max. Range to Combo", SCRIPT_PARAM_SLICE, 800, 150, 1000)

    Config:addSubMenu(scriptname.." - Harass Settings", "Harass")
        Config.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("minQRange", "Min. Q Range", SCRIPT_PARAM_SLICE, 250, 0, 650)
        Config.Harass:addParam("useQMinion","Use Q on Minion To GapClose", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, false)
        Config.Harass:addParam("Mana", "Min. Mana Percent", SCRIPT_PARAM_SLICE, 30, 0, 100)
        Config.Harass:addParam("Range", "Max. Range to Harass", SCRIPT_PARAM_SLICE, 350, 150, 600)

    Config:addSubMenu(scriptname.." - Clear Settings", "Clear")
        Config.Clear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Clear:addParam("maxQRange", "Max. Q Range", SCRIPT_PARAM_SLICE, 450, 0, 650)
        Config.Clear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Config.Clear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        Config.Clear:addParam("Mana", "Min. Mana Percent", SCRIPT_PARAM_SLICE, 30, 0, 100)

    Config:addSubMenu(scriptname.." - LastHit Settings", "LastHit")
        Config.LastHit:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.LastHit:addParam("maxQRange", "Max. Q Range", SCRIPT_PARAM_SLICE, 450, 0, 650)
        Config.LastHit:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
        Config.LastHit:addParam("Mana", "Min. Mana Percent", SCRIPT_PARAM_SLICE, 30, 0, 100)

    Config:addSubMenu(scriptname.." - KillSteal Settings", "KillSteal")
        Config.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
        Config.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(scriptname.." - Auto Settings", "Auto")
        Config.Auto:addSubMenu("Auto QE To Interrupt", "AutoQE")
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            local champion = enemy.charName
            Config.Auto.AutoQE:addParam(champion.."Q", champion.." (Q)", SCRIPT_PARAM_ONOFF, false)
            Config.Auto.AutoQE:addParam(champion.."W", champion.." (W)", SCRIPT_PARAM_ONOFF, false)
            Config.Auto.AutoQE:addParam(champion.."E", champion.." (E)", SCRIPT_PARAM_ONOFF, false)
            Config.Auto.AutoQE:addParam(champion.."R", champion.." (R)", SCRIPT_PARAM_ONOFF, false)
        end
        Config.Auto:addParam("Time",  "Time Limit to Interrupt", SCRIPT_PARAM_SLICE, 2, 0, 8)
        Config.Auto:addParam("AutoE",  "Auto E to Stun", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(scriptname.." - Misc Settings", "Misc")
        Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, PredictionTable)
        if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then Config.Misc:addParam("ExtraTime","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.2, 0, 1, 1) end
         Config.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    Config:addSubMenu(scriptname.." - Drawing Settings", "Draw")
        draw = Draw()
        draw:LoadMenu(Config.Draw)

    Config:addSubMenu(scriptname.." - Key Settings", "Keys")
        Config.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("C"))
        Config.Keys:addParam("Clear", "LaneClear or JungleClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V")) 
        Config.Keys:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X")) 
        Config.Keys:addParam("Flee", "Flee", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("T"))

        Config.Keys.Combo = false
        Config.Keys.Harass = false
        Config.Keys.Clear = false
        Config.Keys.LastHit = false
        Config.Keys.Flee = false

    PrintMessage("Script by "..author..".")
    PrintMessage("Have Fun!.")
    scriptLoaded = true
end

function Checks()
    if Config.Keys.Combo or Config.Keys.Harass or Config.Keys.Clear or Config.Keys.LastHit or Config.Keys.Flee then
        EnemyMinions:update()
        JungleMinions:update()
    end
end


function OnTick()
    if myHero.dead or not scriptLoaded then return end
    ts.target = GetCustomTarget()
    local targetObj = GetTarget()
    if targetObj ~= nil then
        if targetObj.type:lower():find("hero") and targetObj.team ~= myHero.team and GetDistanceSqr(myHero, targetObj) < ts.range * ts.range  then
            ts.target = targetObj
        end
    end
    Checks()

    Auto()

    --KillSteal
        KillSteal()
    if Config.Keys.Flee then Flee() end

    if Config.Keys.Combo then Combo()
    elseif Config.Keys.Harass then Harass()
    elseif Config.Keys.Clear then Clear()
    elseif Config.Keys.LastHit then LastHit()
    end
end

function Auto()
    if Config.Auto.AutoE then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) and enemy.type == myHero.type and enemy.type:lower():find("hero") and enemy.visible and CanStun(enemy) and ValidTarget(enemy, E.Range) then
                CastE(enemy, 2)
            end
        end
    end
end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and enemy.visible and enemy.health/enemy.maxHealth < 0.3 and ValidTarget(enemy, ts.range) then
            local q, w, e, r, dmg = damage:getBestCombo(enemy)
            if dmg / damage:getOverkill() >= enemy.health then
                if Config.KillSteal.useQ and q and not enemy.dead and Q.IsReady() then CastQ(enemy) end
                if Config.KillSteal.useE and e and not enemy.dead and E.IsReady() then CastE(enemy) end
                if Config.KillSteal.useR and r and not enemy.dead and R.IsReady() then CastR(enemy) end
                if Config.KillSteal.useE and Config.KillSteal.useQ and Q.Damage(enemy) + E.Damage(enemy) > enemy.health and not enemy.dead and Q.IsReady() and E.IsReady() then CastQ(enemy) CastE(enemy) end
            end
            if Config.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead and ValidTarget(enemy, Ignite.Range) then CastIgnite(enemy, 3) end
        end
    end
end


function Flee()
    myHero:MoveTo(mousePos.x, mousePos.z)
    if E.IsReady() then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) and enemy.type == myHero.type and enemy.type:lower():find("hero") and enemy.visible and CanStun(enemy) and ValidTarget(enemy, E.Range) then
                CastE(enemy, 2)
            end
        end
    end
    if ValidTarget(ts.target) and Q.IsReady() then
        for i, minion in pairs(EnemyMinions.objects) do
            if GetDistanceSqr(ts.target, minion) > GetDistanceSqr(ts.target, myHero) then CastQ(minion) end
        end
    end
end


function Combo()
    local target = ts.target
    if ValidTarget(target, Config.Combo.Range) then

        if Config.Combo.useIgnite > 1 then CastIgnite(target, Config.Combo.useIgnite) end
        if Config.Combo.useItems then UseItems(target) end
        --if TargetHaveBuff("sheen", myHero) then return end

        if ValidTarget(target, Q.Range) and Config.Combo.useQ and GetDistanceSqr(myHero, target) > Config.Combo.minQRange * Config.Combo.minQRange then
            CastQ(target)
        elseif (Config.Combo.useQMinion or Config.Combo.useRMinion) and not ValidTarget(target, Q.Range) and Config.Combo.useQ and GetDistanceSqr(myHero, target) > Config.Combo.minQRange * Config.Combo.minQRange then
            local QMinion = CastQMinion()
            local RMinion = CastRMinion()
            if QMinion ~= nil and ValidTarget(QMinion) and GetDistanceSqr(QMinion, target) < GetDistanceSqr(myHero, target)  and Config.Combo.useQMinion then CastSpell(_Q, QMinion)
            elseif RMinion ~= nil and ValidTarget(RMinion) and Config.Combo.useRMinion and GetDistanceSqr(RMinion, target) < GetDistanceSqr(myHero, target) then
                local CastPosition, HitChance, Position = prediction:GetPrediction(RMinion, R.Delay, R.Width, R.Range, R.Speed, myHero, "linear", R.Collision, R.Aoe)
                CastSpell(_R, CastPosition.x, CastPosition.z)
                DelayAction(function() CastSpell(_Q, RMinion) end, GetDistance(myHero, RMinion)/R.Speed + 0.1) 
            end
        end
        if Config.Combo.useE > 0 then CastE(target, Config.Combo.useE) end
        if Config.Combo.useW then CastW(target) end
        if Config.Combo.useR and myHero.health/myHero.maxHealth < 0.8 then CastR(target) end
    end
end

function Harass()
    local target = ts.target
    if ValidTarget(target, Config.Harass.Range) and 100 * myHero.mana / myHero.maxMana >= Config.Harass.Mana then
        if ValidTarget(target, Q.Range) and Config.Harass.useQ and GetDistanceSqr(myHero, target) > Config.Harass.minQRange * Config.Harass.minQRange then
            CastQ(target)
        elseif Config.Harass.useQMinion and Config.Harass.useQ and GetDistanceSqr(myHero, target) > Config.Harass.minQRange *  Config.Harass.minQRange then
            local QMinion = CastQMinion()
            if QMinion ~= nil and ValidTarget(QMinion) and GetDistanceSqr(QMinion, target) < GetDistanceSqr(myHero, target) then CastSpell(_Q, QMinion) end
        end
        if Config.Harass.useE then CastE(target) end
        if Config.Harass.useW then CastW(target) end
    end
end


function Clear()
    if 100 * myHero.mana / myHero.maxMana >= Config.Clear.Mana  then
        if Config.Clear.useQ or Config.LastHit.useW or Config.LastHit.useE then
            for i, minion in pairs(EnemyMinions.objects) do
                if Config.Clear.useW then CastW(minion) end
                if Config.Clear.useQ and Q.Damage(minion) > minion.health and GetDistanceSqr(myHero, minion) < Config.Clear.maxQRange * Config.Clear.maxQRange then CastQ(minion) end
                if Config.Clear.useE then CastE(minion) end
            end
    
            for i, minion in pairs(JungleMinions.objects) do
                if Config.Clear.useW then CastW(minion) end
                if Config.Clear.useQ and GetDistanceSqr(myHero, minion) < Config.Clear.maxQRange *  Config.Clear.maxQRange then CastQ(minion) end
                if Config.Clear.useE then CastE(minion) end
            end
        end
    end
end

function LastHit()
    if 100 * myHero.mana / myHero.maxMana >= Config.LastHit.Mana then
        if Config.LastHit.useQ or Config.LastHit.useE then
            for i, minion in pairs(EnemyMinions.objects) do
                if Config.LastHit.useQ and Q.Damage(minion) > minion.health and GetDistanceSqr(myHero, minion) < Config.LastHit.maxQRange * Config.LastHit.maxQRange then CastQ(minion) end
                if Config.LastHit.useE and E.Damage(minion) > minion.health then CastE(minion) end
            end
        end
    end
end


--CastX

function CastIgnite(target, m)
    local mode = m or 3
    if ValidTarget(target, Ignite.Range) and Ignite.IsReady() then
        if mode > 1 then
            if mode == 2 then
                local dmg, mana = damage:getComboDamage(target, Q.IsReady(), W.IsReady(), E.IsReady(), R.IsReady())
                if dmg > target.health and myHero.mana > mana then
                    CastSpell(igniteslot, target)
                end
            elseif mode == 3 then
                CastSpell(igniteslot, target)
            end
        end
    end
end

function CastQ(target)
    if Q.IsReady() and myHero.mana >= Q.Mana() and ValidTarget(target, Q.Range) then
        CastSpell(_Q, target)
    end 
end

function CastW(target)
    if W.IsReady() and myHero.mana >= W.Mana() and ValidTarget(target, AA.Range(target)) then
        CastSpell(_W)
    end
end


function CastE(target, mod)
    local mode = mod or 4
    if E.IsReady() and myHero.mana >= E.Mana() and ValidTarget(target, E.Range) then
        if mode == 2 then
            if CanStun(target) then CastSpell(_E, target) end
        elseif mode == 3 then
            if CanStun(target) then 
                CastSpell(_E, target)
            elseif GetDistanceSqr(myHero, target) > (AA.Range(target) + (E.Range - AA.Range(target))/3) * (AA.Range(target) + (E.Range - AA.Range(target))/3) and GetDistanceSqr(myHero, target) <= E.Range * E.Range then
                CastSpell(_E, target)
            end
        elseif mode == 4 then
            CastSpell(_E, target)
        end
    end
end

function CastR(target)
    if R.IsReady() then
        if ValidTarget(target, R.Range) then
            local CastPosition, HitChance, Count, Positions = prediction:GetPrediction(target, R.Delay, R.Width, R.Range, R.Speed, myHero, "linear", R.Collision, R.Aoe)
            if CastPosition~=nil then
                CastSpell(_R, CastPosition.x, CastPosition.z)
            end
        end
    end
end

function CastQMinion()
    if Q.IsReady() then
        for i, minion in pairs(EnemyMinions.objects) do
            if not minion.dead and ValidTarget(minion, Q.Range) and minion.valid and minion.health < Q.Damage(minion) then
                return minion
            end
        end
    end
    return nil
end

function CastRMinion()
    if R.IsReady() then
        for i, minion in pairs(EnemyMinions.objects) do
            if not minion.dead and ValidTarget(minion, Q.Range) and minion.valid and minion.health > R.Damage(minion) and minion.health < Q.Damage(minion) + R.Damage(minion) then
                return minion
            end
        end
    end
    return nil
end

function getChampionPriority(i, team, range)
    for idx, champion in ipairs(team) do
        if i == 1 and priorityTable.p1[champion.charName] ~= nil then return champion
        elseif i == 2 and priorityTable.p2[champion.charName] ~= nil then return champion
        elseif i == 3 and priorityTable.p3[champion.charName] ~= nil then return champion
        elseif i == 4 and priorityTable.p4[champion.charName] ~= nil then return champion
        elseif i == 5 and priorityTable.p5[champion.charName] ~= nil then return champion
        end
    end
end

function getPriorityChampion(champion)
    if priorityTable.p1[champion.charName] ~= nil then
        return 1
    elseif priorityTable.p2[champion.charName] ~= nil then
        return 2
    elseif priorityTable.p3[champion.charName] ~= nil then
        return 3
    elseif priorityTable.p4[champion.charName] ~= nil then
        return 4
    elseif priorityTable.p5[champion.charName] ~= nil then
        return 5
    end
    return 5
end

function getBestPriorityChampion(source, team, range)
    local bestPriority = nil
    local bestChampion = nil
    for idx, champion in ipairs(team) do
        if champion.valid and champion.visible then
            if GetDistanceSqr(source, champion) <= range * range then
                local priority = getPriorityChampion(champion)
                if bestPriority == nil then
                    bestPriority = priority
                    bestChampion = champion
                elseif priority < bestPriority then
                    bestPriority = priority
                    bestChampion = champion
                end
            end
        end
    end
    return bestChampion
end

function getNearestChampion(source, team, range)
    local nearest = nil
    for idx, champion in ipairs(team) do
        if champion.valid and champion.visible then
            if GetDistanceSqr(source, champion) <= range *  range then
                if nearest == nil then
                    nearest = champion
                elseif GetDistanceSqr(source, champion) < GetDistanceSqr(source, nearest) then
                    nearest = champion
                end
            end
        end
    end
    return nearest
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

function ForceQE(target, time)
   if not ValidTarget(target) or os.clock() - time > Config.Auto.Time then return end
    if E.IsReady() and ValidTarget(target, E.Range) then
        CastE(target, 2)
    elseif Q.IsReady() and ValidTarget(target, Q.Range) and CanStun(target) then
        CastQ(target)
    end
    if E.IsReady() and ValidTarget(target, Q.Range + 500) then
        DelayAction(function(target, time) ForceQE(target, time) end, 0.1, {target, time})
    end
end

function OnProcessSpell(unit, spell)
    if myHero.dead or unit == nil or not scriptLoaded then return end
    if not unit.isMe then
        if unit.type == myHero.type and unit.type:lower():find("hero") and unit.team ~= myHero.team and ValidTarget(unit, Q.Range + 500) then
            local spelltype, casttype = getSpellType(unit, spell.name)
            if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
                if Config.Auto.AutoQE[unit.charName..spelltype] then 
                    ForceQE(unit, os.clock())
                end
            end
        end
    end
    if not unit.isMe then return end
    if spell.name:lower() == "ireliagatotsu" then Q.LastCastTime = os.clock()
    elseif spell.name:lower() == "ireliahitenstyle" then E.LastCastTime = os.clock()
    elseif spell.name:lower() == "ireliaequilibriumstrike" then W.LastCastTime = os.clock()
    elseif spell.name:lower() == "ireliatranscendentblades" then R.LastCastTime = os.clock()
    end
end

function RecvPacket(p)
    -- body
end

function OnCreateObj(obj)
    --if GetDistance(myHero, obj) < 700 then print("Created: "..obj.name) end
    -- body
end

function OnDeleteObj(obj)
    --if GetDistance(myHero, obj) < 700 then print("Deleted: "..obj.name) end
    -- body
end

function CanStun(target)
    return ValidTarget(target) and target.health/target.maxHealth*100 > myHero.health/myHero.maxHealth*100
end


function UseItems(unit)
    if unit ~= nil then
        for _, item in pairs(CastableItems) do
            if item.IsReady() and ValidTarget(target, item.Range) then
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
    ts:update()
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return ts.target
end


function OrbLoad()
    if _G.AutoCarry then
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Combo", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Harass", AutoCarry.MODE_MIXEDMODE)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Clear", AutoCarry.MODE_LANECLEAR)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "LastHit", AutoCarry.MODE_LASTHIT)
        _G.AutoCarry.MyHero:AttacksEnabled(true)
    elseif _G.Reborn_Loaded then
        DelayAction(OrbLoad, 1)
    elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
        require 'SxOrbWalk'
        --SxOrb = SxOrbWalk()
        Config:addSubMenu(scriptname.." - Orbwalking", "Orbwalking")
        SxOrb:LoadToMenu(Config.Orbwalking)
        SxOrb:RegisterHotKey("harass",  Config.Keys, "Harass")
        SxOrb:RegisterHotKey("fight",  Config.Keys, "Combo")
        SxOrb:RegisterHotKey("laneclear",  Config.Keys, "Clear")
        SxOrb:RegisterHotKey("lasthit",  Config.Keys, "LastHit")
        SxOrb:EnableAttacks()
    elseif FileExist(LIB_PATH .. "SOW.lua") then
        require 'SOW'
        SOWi = SOW(VP)
        Config:addSubMenu(scriptname.." - Orbwalking", "Orbwalking")
        SOWi:LoadToMenu(Config.Orbwalking)
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


--CREDITS TO FEEZ
function isFacing(source, target, lineLength)
    local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
    local sourcePos = Vector(source.x, source.z)
    sourceVector = (sourceVector-sourcePos):normalized()
    sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
    return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
end

--CREDITS TO EXTRAGOZ
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
function Prediction:getTimeMinion(minion, mode)
    local time = 0
    --lasthit
    if mode == 1 then
        time = iOrb:WindUpTime() + GetDistance(myHero, minion) / self.ProjectileSpeed - self.delay
    --laneclear
    elseif mode == 2 then
        time = iOrb:AnimationTime() + GetDistance(myHero, minion) / self.ProjectileSpeed - self.delay
        time = time * 2
    end
    return time
end

function Prediction:getPredictedHealth(minion, mode)
    local output = 0
    --lasthit
    if mode == 1 then
        local time = self:getTimeMinion(minion, mode)
        local predHealth, maxdamage, count = VP:GetPredictedHealth(minion, time, 0.07)
        output = predHealth
    --laneclear
    elseif mode == 2 then
        local time = self:getTimeMinion(minion, mode)
        local predHealth, maxdamage, count = VP:GetPredictedHealth2(minion, time)
        output = predHealth
    end
    return output
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
            comboDamage = comboDamage + W.Damage(target)
            currentManaWasted = currentManaWasted + W.Mana()
            comboDamage = comboDamage + AA.Damage(target)
        end
        if e then
            comboDamage = comboDamage + E.Damage(target)
            currentManaWasted = currentManaWasted + E.Mana()
             if CanStun(target) then comboDamage = comboDamage + AA.Damage(target) * 2 end
        end
        if r and os.clock() - R.LastCastTime > 15 then
            comboDamage = comboDamage + R.Damage(target) * 4
            currentManaWasted = currentManaWasted + R.Mana()
        end
        comboDamage = comboDamage + AA.Damage(target)
        for name, item in pairs(CastableItems) do
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



class("Draw")
function Draw:__init()
    self.Menu = nil
end
function Draw:LoadMenu(menu)
    self.Menu = menu
    self.Menu:addSubMenu("Q", "Q")
    self.Menu.Q:addParam("Range","Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Q:addParam("Color","Color", SCRIPT_PARAM_COLOR, { 255, 255, 255, 255 })
    self.Menu.Q:addParam("Width","Width", SCRIPT_PARAM_SLICE, 1, 1, 5)
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
    self.Menu:addParam("Stunnable","Text on Stunnable", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Quality", "Quality of Circles", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
    AddDrawCallback(function() self:OnDraw() end)
end

function Draw:OnDraw()
    if myHero.dead or self.Menu == nil then return end
    if self.Menu.dmgCalc then self:DrawPredictedDamage() end
    if self.Menu.Target and ts.target ~= nil and ValidTarget(ts.target) then
        self:DrawCircle2(ts.target.x, ts.target.y, ts.target.z, VP:GetHitBox(ts.target)*1.5, Colors.Red, 3)
    end

    if self.Menu.Q.Range and Q.IsReady() then
        local color = self.Menu.Q.Color
        local width = self.Menu.Q.Width
        local range =           Q.Range
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
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
        local range =           R.Range
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, range, ARGB(color[1], color[2], color[3], color[4]), width)
    end

    if self.Menu.Stunnable and E.IsReady() and myHero.mana >= E.Mana() then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
            if ValidTarget(enemy) and enemy.visible and OnScreen(p.x, p.y) and CanStun(enemy) then
                local pos = WorldToScreen(D3DXVECTOR3(enemy.x , enemy.y, enemy.z))
                DrawText("Stunnable", 20, pos.x, pos.y,  ARGB(255,255,255,255))
            end
        end
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
        if self.GotScriptVersion or not self.Socket then return end

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
    if self.GotScriptUpdate or not self.Socket then return end
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
            local newf = Base64Decode(newf)
            local f = io.open(self.SavePath,"w+b")
            f:write(newf)
            f:close()
            if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
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
    if self.GotScriptUpdate or not self.Socket then return end
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
            local newf = Base64Decode(newf)
            local f = io.open(self.SavePath,"w+b")
            f:write(newf)
            f:close()
            if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
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