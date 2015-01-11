	if myHero.charName ~= "Zed" then return end
	--if VIP_USER then
		--PrintChat("<font color=\"#FF0000\" >> Authentication Failed ! <</font> ")
	--end
	 
	 local priorityTable = {
 
	AP = {
		"Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "FiddleSticks", "Fizz",  "Heimerdinger", "Karthus",
		"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Nidalee", "Orianna",
		 "Ryze",  "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi", "Velkoz",
	},
	   
		 AD_Carry = {
		"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves",  "KogMaw", "MissFortune", "Quinn", "Shaco", "Sivir",
		"Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed", "Jinx", "Fiora", "Tryndamere", "Lucian", "Yasuo",
 
	},
	   
	Support = {
		 "Janna", "Karma", "Lulu", "Nami", "Sona", "Soraka", "Zilean", "Evelynn", "Gragas", "Morgana", "Rumble", "Khazix", "Riven", "Rengar","Nocturne",
	},
	   
		Bruiser = {
		"Darius", "Elise",  "Gangplank",  "Irelia",  "Jax",  "LeeSin",   "Olaf", "Poppy",
			"Udyr", "Vi", "MonkeyKing", "XinZhao", "Aatrox" , "Sion", "Jayce", "Pantheon", "Thresh",
	},
	   
		Tank_dmg = {
	   "Warwick",  "Nautilus", "Renekton", "Shyvana", "JarvanIV", "Alistar", "Skarner", "Nunu", "Yorick", "Maokai", "Malphite", "Galio", "Trundle", "Blitzcrank", "Braum", "Gnar",
	},
 
	Tank = {
		"Amumu", "Chogath", "DrMundo",  "Hecarim",   "Nasus", "Rammus", "Sejuani", "Shen", "Singed",  "Volibear",
		  "Zac",  "Taric",  "Leona", "Garen",
	},
   
 
}
	 
	local RREADY, QREADY,WREADY, EREADY
	local VP
	local ts
	local Config
	local lastSkin = 0
	local UltTargets = GetEnemyHeroes()
	local version = 3
	local scriptName = "BioZed"
	local Qrange, Qwidth, Qspeed, Qdelay = 900, 45, 902, 0.25
	local QReady, WReady, EReady, RReady = false, false, false, false
	local Ranges = {[_Q] = 900, [_W] = 550, [_E] = 290,[_R] = 625}
	local Zed = {
			Q = {range = 900, speed = 902, delay = 0.25},
	}
	 
	-- Change autoUpdate to false if you wish to not receive auto updates.
	-- Change silentUpdate to true if you wish not to receive any message regarding updates
	--local autoUpdate = false
	--local silentUpdate = false
	 
	  local SOURCELIB_URL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SOURCELIB_PATH = LIB_PATH.."SourceLib.lua"

if FileExist(SOURCELIB_PATH) then
	require("SourceLib")
else
	DOWNLOADING_SOURCELIB = true
	DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() print("Required libraries downloaded successfully, please reload") end)
end

if DOWNLOADING_SOURCELIB then print("Downloading required libraries, please wait...") return end

if AUTOUPDATE then
	SourceUpdater(SCRIPT_NAME, version, "raw.github.com", "/Hellsing/BoL/master/"..SCRIPT_NAME..".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/Hellsing/BoL/master/version/"..SCRIPT_NAME..".version"):CheckUpdate()
end

local RequireI = Require("SourceLib")
	RequireI:Add("vPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
	RequireI:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
	RequireI:Check()

if RequireI.downloadNeeded == true then return end
 
require 'VPrediction'
require 'SOW'
		 
		 
-- Lib Downloader --
 
 --[[
local REQUIRED_LIBS = {
	["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua",
	["SOW"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua",
	["SourceLib"] = "https://raw.githubusercontent.com/TheRealSource/public/master/common/SourceLib.lua",
	["Selector"] = "http://iuser99.com/scripts/Selector.lua",
}
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
local SELF_NAME = GetCurrentEnv() and GetCurrentEnv().FILE_NAME or ""
 
function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b>Required libraries downloaded successfully, please reload (double F9).</b>")
	end
end
 
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		require(DOWNLOAD_LIB_NAME)
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end
 
if DOWNLOADING_LIBS then print("Downloading required libraries, please wait...") return end
 
 
--require "Prodiction"
  ]]--
		 
function OnLoad()
	UpdateWeb(true, ScriptName, id, HWID)
	Q = Spell(_Q, Ranges[_Q])
	--W
	W = Spell(_W, Ranges[_W])
	--E
	E = Spell(_E, Ranges[_E])
	--R
	DManager = DrawManager()
	
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900 ,DAMAGE_PHYSICAL)
	DelayAction(arrangePrioritys,5) --agregado
	
	ts.name = "AllClass TS"
	VP = VPrediction()
	SOWi = SOW(VP)

	LoadVariables()
	LoadMenu()
	
	Ignite()
	for i=1, heroManager.iCount do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team then
			EnemysInTable = EnemysInTable + 1
			EnemyTable[EnemysInTable] = { hero = champ, Name = champ.charName, p = 0, q = 0, q2 = 0, e = 0, r = 0, IndicatorText = "", IndicatorPos, NotReady = false, Pct = 0}
		end
	end
	PrintFloatText(myHero,11,"LETS RAPE >:D !")
	enemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_HEALTH_ASC)
	qEnergy = {75, 70, 65, 60, 55}
	wEnergy = {40, 35, 30, 25, 20}
	eCost = 50
	qDelay, qWidth, qRange, qSpeed = 0.25, 45, 900, 902
	wDelay, wWidth, wRange, wSpeed = 0.25, 40, 550, 1600
	wSwap = false
	wCast = false
end
	
function LoadVariables()
 
	UseSwap = true
	ChampCount = nil
	wClone, rClone = nil, nil
	--RREADY, (myHero:CanUseSpell(_Q) == READY), (myHero:CanUseSpell(_W) == READY), (myHero:CanUseSpell(_E) == READY) = false, false, false, false
	ignite = nil
	lastW = 0
	delay, qspeed = 235, 1.742
   
	--Helpers
	EnemyTable = {}
	EnemysInTable = 0
	HealthLeft = 0
	PctLeft = 0
	BarPct = 0
	orange = 0xFFFFE303
	green = ARGB(255,0,255,0)
	blue = ARGB(255,0,0,255)
	red = ARGB(255,255,0,0)
	eRange = 280
	Target = nil
	RREADY = nil
	QMana = nil
	WMana = nil
	EMana = nil
	RMana = nil
	MyMana = nil
end

function LoadMenu()
	Config = scriptConfig("BioZed by Lucas and Pyr", "Die")

	--targetselector
   	Config:addTS(ts)

   	--orbwalker
	Config:addSubMenu("BioZed - Orbwalking", "Orbwalking")
	SOWi:LoadToMenu(Config.Orbwalking)

	--combo
	Config:addSubMenu("BioZed - Combo Settings", "Combo")
		Config.Combo:addParam("Fight", "BioCombo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.Combo:addParam("UseQ","Use Q on Combo", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("UseW","Use W on Combo", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("UseE","Use E on Combo", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("UseWCombo","Use W on R Combo", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("UseR","Use R Combo", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("wSwap", "Swap to W to gap closer", SCRIPT_PARAM_ONOFF, true)
		Config.Combo:addParam("rHp","Swap back with ult if hp < %", SCRIPT_PARAM_SLICE, 15, 2, 100, 0)
		Config.Combo:addParam("rSwap", "Swap to R shadow if safer when mark kills", SCRIPT_PARAM_ONOFF, true)
		
   	--harass
	Config:addSubMenu("BioZed - Harass Settings", "harass")
		Config.harass:addParam("harassKey", "Harass Key (C)", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("C"))	
		Config.harass:addParam("fullHarassKey", "Full Harass Key (T)", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("T"))	
		Config.harass:addParam("mode", "True = QWE, False = Q", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("M"))
		Config.harass:addParam("saveforW", "Save Energy for W", SCRIPT_PARAM_ONOFF, true)
	Config.harass:permaShow("mode")

   	--misc
	Config:addSubMenu("BioZed - Misc Settings", "misc")
		Config.misc:addParam("autoIgnite", "Ks Ignite", SCRIPT_PARAM_ONOFF, true)
		Config.misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 2, { "vPrediction", "Prodiction"})
		--EvadeW
		Config.misc:addSubMenu("Evade using W", "AutoW")
		for idx, enemy in ipairs(GetEnemyHeroes()) do
			local spell = "Q"
			local champion = enemy.charName
			Config.misc.AutoW:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, false)
			spell = "W"
			Config.misc.AutoW:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, false)
			spell = "E"
			Config.misc.AutoW:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, false)
			spell = "R"
			Config.misc.AutoW:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, true)
		end
		--EvadeR
		Config.misc:addSubMenu("Evade using R", "AutoR")
		for idx, enemy in ipairs(GetEnemyHeroes()) do
			local spell = "Q"
			local champion = enemy.charName
			Config.misc.AutoR:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, false)
			spell = "W"
			Config.misc.AutoR:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, false)
			spell = "E"
			Config.misc.AutoR:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, false)
			spell = "R"
			Config.misc.AutoR:addParam(champion..spell, champion.." ("..spell..")", SCRIPT_PARAM_ONOFF, true)
		end
		Config.misc:addSubMenu("Skin Changer", "skinChanger")
            Config.misc.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
            Config.misc.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 7)
		
   
	Config:addSubMenu("BioZed - Drawing Setting", "draw")
		Config.draw:addParam("DmgIndic","Kill text", SCRIPT_PARAM_ONOFF, true)
		for spell, range in pairs(Ranges) do
			DManager:CreateCircle(myHero, range, 1, {255, 255, 255, 255}):AddToMenu(Config.draw, SpellToString(spell).." Range", true, true, true)
		end
   
	Config:addSubMenu("BioZed - Farm", "farm")
	Config.farm:addParam("farmKey", "Farm", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	Config.farm:addParam("farmQ", "Farm With Q", SCRIPT_PARAM_ONOFF, false)
	Config.farm:addParam("FarmE", "Farm With E", SCRIPT_PARAM_ONOFF, false)
 
	PrintChat("<font color=\"#FF0000\" >> JOKE ! <</font> ")
	PrintChat("<font color=\"#FF0000\" >> BioZed By Lucas v 3.0 <</font> ")
	PrintChat("<font color=\"#FF0000\" >> Enjoy ! <</font> ")
   
end


function OnTick()
		--[[
		if Config.lmisc.VIP.skin and skinChanged() then
				GenModelPacket("Zed", Config.lmisc.VIP.skin1)
				lastSkin = Config.lmisc.VIP.skin1
		end
		
	if GetGame().isOver then
		UpdateWeb(false, ScriptName, id, HWID)
		-- This is a var where I stop executing what is in my OnTick()
		startUp = false;
	end]]--
	--ts:update()
	tstarget = GetOthersTarget()
	SOWi:ForceTarget(tstarget)
	--tstarget = ts.target
	if ValidTarget(tstarget) and tstarget.type == myHero.type then
		Target = tstarget
	else
		Target = nil
	end
	ts:update()
	GlobalInfos()
	--target the enemy with R
	if getRState == 1 then
		for idx, enemy in ipairs(GetEnemyHeroes()) do
			if TargetHaveBuff("zedulttargetmark", enemy) then
				ts.target = enemy
			end
		end
	end
	--find another target if the target selected is dead by R
	if TargetHaveBuff("zedulttargetmark", ts.target) and isDead then
		local bestTarget = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
		    if GetDistance(enemy) <= ts.range and not enemy.dead and enemy ~= ts.target  then
		        if bestTarget == nil then
		            bestTarget = enemy
		        elseif TS_GetPriority(enemy) < TS_GetPriority(bestTarget) then
		            bestTarget = enemy
		        end
		    end
		end
		if bestTarget ~= nill then ts.target = bestTarget end
	end

	SetCooldowns()

	--AutoIgnite
	if Config.misc.autoIgnite then autoIgnite() end
	--Fight
	if Config.Combo.Fight then Fight() end
	--qharass
	if Config.harass.harassKey then qHarass() end
	--qweharass
	if Config.harass.fullHarassKey then qweHarass() end
	--Farm
	if Config.farm.farmKey then Farm() end
	
	
end

function Farm()
	enemyMinions:update()
	for _, minion in pairs(enemyMinions.objects) do
		if Config.farm.farmQ and isReadyQ() then
			if minion.health <= getDamageQ(minion) then
				if GetDistance(myHero.visionPos, minion) <= Ranges[_Q] then CastSpell(_Q, minion.x, minion.z) end
			end
		end
		if Config.farm.FarmE and isReadyE() then
			if minion.health <= getDamageE(minion) then
				if GetDistance(myHero.visionPos, minion) <= Ranges[_E] then CastSpell(_E) end
			end
		end
	end
end
 
function OnUnload()
	PrintFloatText(myHero,9,"U NO RAPE ?! :,( ")
	UpdateWeb(false, ScriptName, id, HWID)
end
 
function GetOthersTarget()
	ts:update()
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return ts.target
end
		 
		 

		 


		 
function autoIgnite()
	if Config.misc.autoIgnite then
		if isReadyIgnite() then
			local ignitedmg = 0
			for idx, enemy in ipairs(GetEnemyHeroes()) do
				if ValidTarget(enemy) and GetDistance(myHero, enemy) < 600 then
					ignitedmg = getDamageIgnite(enemy)
					if enemy.health <= ignitedmg then
						if not isDead then
							CastSpell(ignite, enemy)
						elseif not enemy==ts.target and isDead then
							CastSpell(ignite, enemy)
						end
					end
				end
			end
		end
	end
end
		 
function Swap()
	if ValidTarget(ts.target) and getWState == 1 and not isReadyQ() and not isDead then 
		if GetDistance(ts.target,myHero) > GetDistance(ts.target, wClone) and GetDistance(ts.target,myHero) > Ranges[_E] then
			CastSpell(_W)
		end
	end
	
	if ValidTarget(ts.target) and getWState == 1 and not isDead and (ts.target.health/ts.target.maxHealth) < 0.5 and GetDistance(ts.target, wClone) < Ranges[_E] and GetDistance(ts.target,myHero) > GetDistance(ts.target, wClone) then 
		CastSpell(_W) 
		if not ts.target.dead then
			myHero:Attack(ts.target)
		end
	end
end
		 --es el ulti el problema,es el w el problema, tirar q con w ya listo
		 
function CountEnemies(point, range)
	local ChampCount = 0
	for idx, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) and GetDistance(enemy,myHero) < 700 then
			if GetDistanceSqr(enemy, point) <= range*range then
				ChampCount = ChampCount + 1
			end
		end
	end
	return ChampCount
end

function getHitQ(vec,enemy,CastPosition)
	local DashPos = obj + Vector(CastPosition.x - vec.x, 0, CastPosition.z - vec.z):normalized()*Ranges[_Q]
	local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(vec), Vector(DashPos), Vector(CastPosition))
	local pointSegment3D = {x=pointSegment.x, y=enemy.y, z=pointSegment.y}
	if isOnSegment and pointSegment3D ~= nil and GetDistance(pointSegment3D, CastPosition) < VP:GetHitBox(enemy) + 50 - 30 then
		return true
	end
	return false
end

function CastQ(target)
	--if Config.lmisc.SSettings.Vpred then
		if ValidTarget(target) and isReadyQ() then
			
			local wDist = 0
			local rDist = 0
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.25, 50, 925, 1700, myHero, false)
			local wCastPosition,  wHitChance,  wPosition = nil,nil,nil
			local rCastPosition,  rHitChance,  rPosition = nil,nil,nil
			if wClone and wClone.valid then 
				wDist = GetDistance(target, wClone) 
				wCastPosition,  wHitChance,  wPosition = VP:GetLineCastPosition(target, 0.25, 50, 925, 1700, wClone, false)
			end
			if rClone and rClone.valid then 
				rDist = GetDistance(target, rClone) 
				rCastPosition,  rHitChance,  rPosition = VP:GetLineCastPosition(target, 0.25, 50, 925, 1700, rClone, false)
			end  
			
			local wBool = false
			local Bool = false
			local rBool = false
			
			if wCastPosition ~= nil and rCastPosition ~= nil then
				local Count = 0
				local wCount = 0
				local rCount = 0
				if HitChance >= 2 then 
					Count = Count + 1
					if getHitQ(wClone, target, CastPosition) then Count = Count + 0.5 end
					if getHitQ(rClone, target, CastPosition) then Count = Count + 0.5 end
				end

				if wHitChance >= 2 then 
					wCount = wCount + 0.5
					if getHitQ(myHero, target, wCastPosition) then wCount = wCount + 1 end
					if getHitQ(rClone, target, wCastPosition) then wCount = wCount + 0.5 end
				end
				if rHitChance >= 2 then 
					rCount = rCount + 0.5
					if getHitQ(myHero, target, rCastPosition) then rCount = rCount + 1 end
					if getHitQ(wClone, target, rCastPosition) then rCount = rCount + 0.5 end
				end

				if Count > wCount and Count > rCount then 
					--CastSpell(_Q, CastPosition.x, CastPosition.z) 
					Bool=true
				elseif wCount > Count and wCount > rCount then 
					--CastSpell(_Q, wCastPosition.x, wCastPosition.z) 
					wBool=true
				elseif rCount > Count and rCount > wCount then 
					--CastSpell(_Q, rCastPosition.x, rCastPosition.z) 
					rBool=true
				else
					--CastSpell(_Q, CastPosition.x, CastPosition.z)
					Bool=true
				end
			

			elseif wCastPosition == nil and rCastPosition ~= nil then
				local Count = 0
				local rCount = 0
				if HitChance >= 2 then 
					Count = Count + 1
					if getHitQ(rClone, target, CastPosition) then Count = Count + 0.5 end
				end

				if rHitChance >= 2 then 
					rCount = rCount + 0.5
					if getHitQ(myHero, target, rCastPosition) then rCount = rCount + 1 end
				end

				if Count > rCount then 
					--CastSpell(_Q, CastPosition.x, CastPosition.z) 
					Bool=true
				elseif rCount > Count then 
					--CastSpell(_Q, rCastPosition.x, rCastPosition.z) 
					rBool=true
				else
					--CastSpell(_Q, CastPosition.x, CastPosition.z)
					Bool=true
				end
			

			elseif wCastPosition ~= nil and rCastPosition == nil then
				local Count = 0
				local wCount = 0
				if HitChance >= 2 then 
					Count = Count + 1
					if getHitQ(wClone, target, CastPosition) then Count = Count + 0.5 end
				end

				if wHitChance >= 2 then 
					wCount = wCount + 0.5
					if getHitQ(myHero, target, wCastPosition) then wCount = wCount + 1 end
				end

				if Count > wCount then 
					--CastSpell(_Q, CastPosition.x, CastPosition.z) 
					Bool=true
				elseif wCount > Count then 
					--CastSpell(_Q, wCastPosition.x, wCastPosition.z) 
					wBool=true
				else
					--CastSpell(_Q, CastPosition.x, CastPosition.z)
					Bool=true
				end
			else
				if GetDistance(target, myHero) < qRange then
					if HitChance >= 2 then
						--CastSpell(_Q, CastPosition.x, CastPosition.z)   
						Bool=true
					end
				end
			end

			if Bool and (GetDistance(target, myHero) < qRange) then 
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			elseif wBool and (GetDistance(target, wClone) < qRange) then 
				CastSpell(_Q, wCastPosition.x, wCastPosition.z)
			elseif rBool and (GetDistance(target, rClone) < qRange) then 
				CastSpell(_Q, rCastPosition.x, rCastPosition.z)
			elseif (GetDistance(target, myHero) < qRange) then	
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
			
			
			
		end
		
	--end
end
		 
		 
		 
		 
function CastE()
	if ValidTarget(ts.target) and isReadyE() then
		if GetDistance(ts.target, myHero) < eRange and isReadyE() then
			CastSpell(_E, myHero)
		end
		if getWState > 0 and GetDistance(ts.target, wClone) < eRange and isReadyE() then
			CastSpell(_E, myHero)
		end
		if getRState > 0  and GetDistance(ts.target, rClone) < eRange and isReadyE() then
			CastSpell(_E, myHero)
		end
	end
end
function CastW() 
	if ValidTarget(ts.target) and myHero:GetSpellData(_W).name:lower() ~= "zedw2" and (myHero:CanUseSpell(_W) == READY)  and myHero.mana>WMana and ((GetDistance(ts.target) < 700) or (GetDistance(ts.target) > 125 and not (myHero:CanUseSpell(_R) == READY))) and not isDead then
		local DashPos = nil

		local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.25, 50, 925, 1700, myHero, false)
		
		if rClone ~= nil and 550+GetDistance(ts.target, myHero)<900 then
			DashPos = myHero + Vector(myHero.x-rClone.x, 0,  myHero.z-rClone.z):normalized()*550
		elseif rClone ~= nil and 550+GetDistance(ts.target, myHero)>900 then
			DashPos = myHero + Vector(rClone.x - myHero.x, 0, rClone.z - myHero.z):normalized()*550
		else
			DashPos = myHero + Vector(CastPosition.x - myHero.x, 0, CastPosition.z - myHero.z):normalized()*550
		end
		CastSpell(_W, DashPos.x, DashPos.z)
	end
end
		 
function Fight()
	if Config.Combo.wSwap then Swap() end
	if (myHero:CanUseSpell(_Q) == READY) and (myHero:CanUseSpell(_E) == READY) and (myHero:CanUseSpell(_W) == READY) and (myHero:CanUseSpell(_R) == READY) then
		ts.range = 1200
	else
		ts.range = 900
	end
	
	if myHero:GetSpellData(_R).name == "ZedR2" and ((myHero.health / myHero.maxHealth * 100) <= Config.Combo.SwapUlt) then
		CastSpell(_R)
	end
	
	
	if ValidTarget(ts.target) then
			CastItems(ts.target)
			myHero:Attack(ts.target)
			if (myHero:CanUseSpell(_R) == READY) and rClone ~= nil and Config.Combo.rSwap then
					if isDead then
					
						if CountEnemies(myHero, 250) > CountEnemies(rClone, 250) then
							--PrintChat("DEAD")
							UseSwap = false
							CastSpell(_R)
							DelayAction(function() UseSwap = true end, 5)
						end
					end
					if getDamage("E", ts.target, myHero) > ts.target.health and (myHero:CanUseSpell(_E) == READY) then
							UseSwap = false
							CastSpell(_R)
							DelayAction(function() UseSwap = true end, 5)
							CastE() 
					end
					
					if getDamage("Q", ts.target, myHero)/2 > ts.target.health and (myHero:CanUseSpell(_Q) == READY) then
							UseSwap = false
							CastSpell(_R)
							DelayAction(function() UseSwap = true end, 5)
							CastQ() 
					end
					
				end
			if not (TargetHaveBuff("JudicatorIntervention", ts.target) or TargetHaveBuff("Undying Rage", ts.target)) then
					if (myHero:CanUseSpell(_R) == READY) and MyMana > (QMana + EMana) then CastR(ts.target) end
					if not (myHero:CanUseSpell(_R) == READY) or rClone ~= nil then
						
						if not (Config.Combo.NoWWhenUlt and ((myHero:GetSpellData(_R).name == "ZedR2") or (rClone ~= nil and rClone.valid))) then
							CastW()
						end
						
						
						if (not (myHero:CanUseSpell(_W) == READY) or wClone ~= nil or Config.Combo.NoWWhenUlt or wUsed) and (not (myHero:CanUseSpell(_R) == READY) or rClone ~= nil) then
							CastE() 
							CastQ() 
						end
					end
			end
			   
				
			   
				--[[
				if ValidTarget(ts.target) then
					local UltDmg = (getDamage("AD", ts.target, myHero) + ((.15*(myHero:GetSpellData(_R).level)+.5)*((getDamage("Q", ts.target, myHero, 3)*2) + (getDamage("E", ts.target, myHero, 1)))))
					if UltDmg >= ts.target.health then
						if GetDistance(ts.target, myHero) < 1125 and GetDistance(ts.target, myHero) > 750 then
							local DashPos = myHero + Vector(ts.target.x - myHero.x, 0, ts.target.z - myHero.z):normalized()*550
							if (myHero:CanUseSpell(_Q) == READY) and (myHero:CanUseSpell(_E) == READY) and RREADY and not wClone and not rClone and  then
								--PrintChat("Gapclose")
								if myHero:GetSpellData(_W).name == "ZedShadowDash" then CastSpell(_W, DashPos.x, DashPos.z) end
							end
							if wClone and wClone.valid and not rClone then
								CastSpell(_W, myHero)
								CastSpell(_R, ts.target)
							end
						   
						end
					end
				end
				]]--
			end
end
		 

		 
		 
function qweHarass() 
	ts.range = 1500
	myHero:MoveTo(mousePos.x, mousePos.z)
	if ts.target then
		if myHero.mana>myHero:GetSpellData(_Q).mana+myHero:GetSpellData(_W).mana+myHero:GetSpellData(_E).mana and myHero:CanUseSpell(_Q) == READY and myHero:CanUseSpell(_W) == READY and myHero:CanUseSpell(_E) == READY then
			CastW()
			CastE()
			CastQ()
		elseif myHero.mana>myHero:GetSpellData(_Q).mana+myHero:GetSpellData(_W).mana and myHero:CanUseSpell(_Q) == READY  and myHero:CanUseSpell(_W) == READY then
			CastW()
			CastQ()
		else
			CastE()
			CastQ()
		end

		if ValidTarget(ts.target) and wClone and wClone.valid and not isDead and (ts.target.health/ts.target.maxHealth) < 0.5 and myHero:GetSpellData(_W).name:lower() == "zedw2" and GetDistance(ts.target, wClone) < eRange and (myHero:CanUseSpell(_W) == READY) and GetDistance(ts.target,myHero) > GetDistance(ts.target, wClone) then 
			CastSpell(_W) 
			if not ts.target.dead then
				myHero:Attack(ts.target)
			end
		end
	end

			--[[
			if (myHero:CanUseSpell(_Q) == READY) and (myHero:CanUseSpell(_W) == READY) and GetDistance(ts.target, myHero) < 1450 and (MyMana > QMana+WMana+EMana) then
				if myHero:GetSpellData(_W).name ~= "zedw2" and GetTickCount() > lastW + 1000 then
					CastSpell(_W, ts.target.x, ts.target.z)
					if wUsed then CastSpell(_E) end
				end
			end
			if wUsed then
				CastQ()
			end
			if not (myHero:CanUseSpell(_W) == READY) then
				CastQ()
			end
			CastE()
			if GetDistance(ts.target, myHero) < 1450 and GetDistance(ts.target, myHero) > 900 then
				local DashPos = myHero + Vector(ts.target.x - myHero.x, 0, ts.target.z - myHero.z):normalized()*550
				if (myHero:CanUseSpell(_Q) == READY) and (myHero:CanUseSpell(_W) == READY) and (MyMana > QMana+WMana) then
					--PrintChat("Gapclose")
					if myHero:GetSpellData(_W).name == "ZedShadowDash" then CastSpell(_W, DashPos.x, DashPos.z) end
				end
				if wClone and wClone.valid then
					CastQClone()
				end

			   
			end
			]]--
			

	

end

function canUseSkills()
	if getWState() ~= 0 or !Config.harass.saveforW then return true end
	else
		return (myHero.mana>getManaW()+getManaQ())
	end
end

function qHarass()
	ts.range = 1500
	if ts.target and canUseSkills() then
		CastQ()
		CastE()
	end
end
		 
function CastR(target)
	if ValidTarget(target) and getRState == 0 then
		if GetDistance(target) <= Ranges[_R] and target.health>getDamageQ(target)+getDamageE(target) then
			CastSpell(_R, target)
		end
end

		 
function GlobalInfos()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	QMana = myHero:GetSpellData(_Q).mana
	WMana = myHero:GetSpellData(_W).mana
	EMana = myHero:GetSpellData(_E).mana
	RMana = myHero:GetSpellData(_R).mana
	MyMana = myHero.mana
 
   
	iReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end
 
function OnCreateObj(obj)
	if obj.valid and obj.name:find("Zed_Clone_idle.troy") then
		if wClone == nil then
			wClone = obj
		elseif rClone == nil then
			rClone = obj
		end
	end
end
 
function OnDeleteObj(obj)
	if obj.valid and wClone and obj == wClone then
		wClone = nil
	elseif obj.valid and rClone and obj == rClone then
		rClone = nil
	end
end
 
function Ignite()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then ignite = SUMMONER_2
	end
end
 
function SetCooldowns()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	iReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end
		 
		 
function CastItems(target)
	if not ValidTarget(target) then
		return
	else
		local slot = nil
		local Ready = nil
		if GetDistance(target) <=480 then
			
			--CastItem(3144, target) --Bilgewater Cutlass
			slot = GetInventorySlotItem(3144)
			Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			if Ready then CastSpell(slot,target) end
			--CastItem(3153, target) --Blade Of The Ruined King
			slot = GetInventorySlotItem(3153)
			Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			if Ready then CastSpell(slot,target) end
		end
		if GetDistance(target) <=400 then
			--CastItem(3146, target) --Hextech Gunblade
			slot = GetInventorySlotItem(3146)
			Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			if Ready then CastSpell(slot,target) end
		end
		if GetDistance(target) <= 300 then
			CastItem(3184, target) --Entropy
			--CastItem(3143, target) --Randuin's Omen
			slot = GetInventorySlotItem(3143)
			Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			if Ready then CastSpell(slot) end
			--CastItem(3074, target) --Ravenous Hydra
			slot = GetInventorySlotItem(3074)
			Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			if Ready then CastSpell(slot) end
			--CastItem(3077, target) --Tiamat
			slot = GetInventorySlotItem(3077)
			Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			if Ready then CastSpell(slot) end
			--CastItem(3142, target) --Youmuu's Ghostblade
			--slot = GetInventorySlotItem(3142)
			--Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			--if Ready then CastSpell(slot) end
		end
		if GetDistance(ts.target) <= 1000 then
			--CastItem(3023, target) --Twin Shadows
			slot = GetInventorySlotItem(3023)
			Ready = (slot ~= nil and myHero:CanUseSpell(slot) == READY)
			if Ready then CastSpell(slot,target) end
		end
	end
end
 
function GrabTarget()
		
			ts.range = MaxRange()
			ts:update()
			return ts.target
end
	   
		
function MaxRange()
		if (myHero:CanUseSpell(_Q) == READY) then
			return Zed.Q["range"]
		end
		return myHero.range + 50
end

function GetHPBarPos(enemy)
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
function DrawLineHPBar(damage, line, text, unit)
	local thedmg = 0
	if damage >= unit.maxHealth then
		thedmg = unit.maxHealth-1
	else
		thedmg=damage
	end
	thedmg = math.round(thedmg)
	local StartPos, EndPos = GetHPBarPos(unit)
	local Real_X = StartPos.x+24
	local Offs_X = (Real_X + ((unit.health-thedmg)/unit.maxHealth) * (EndPos.x - StartPos.x - 2))
	if Offs_X < Real_X then Offs_X = Real_X end	
	local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth)) ---   255 * 0.5
	if mytrans >= 255 then mytrans=254 end
	local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
	if my_bluepart >= 255 then my_bluepart=254 end

	DrawLine(Offs_X-150, StartPos.y-(30+(line*15)), Offs_X-150, StartPos.y-2, 2, ARGB(mytrans, 255,my_bluepart,0))
	DrawText(tostring(text),15,Offs_X-148,StartPos.y-(30+(line*15)),ARGB(mytrans, 255,my_bluepart,0))
end	



function Calculations()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	QMana = myHero:GetSpellData(_Q).mana
	WMana = myHero:GetSpellData(_W).mana
	EMana = myHero:GetSpellData(_E).mana
	RMana = myHero:GetSpellData(_R).mana

	TemSlot = GetInventorySlotItem(3153)
	BOTRKREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Blade Of The Ruined King
   
	TemSlot = GetInventorySlotItem(3144)
	BCREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Bilgewater Cutlass
   
	TemSlot = GetInventorySlotItem(3074)
	HYDRAREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Ravenous Hydra
   
	TemSlot = GetInventorySlotItem(3077)
	TIAMATREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Tiamat

	iReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	MyMana = myHero.mana
	local currLine = 1
	for i=1, EnemysInTable do
	   
		local enemy = EnemyTable[i].hero
		if ValidTarget(enemy) and enemy.visible then
			caaDmg = getDmg("AD",enemy,myHero)
			cqDmg = getDmg("Q", enemy, myHero)
			ceDmg = getDmg("E", enemy, myHero)
		   
			UltExtraDmg = 0
			cItemDmg = 0

			if BCREADY then
				cItemDmg = cItemDmg + getDmg("BWC", enemy, myHero)
			end
			if BOTRKREADY then
				cItemDmg = cItemDmg + getDmg("RUINEDKING", enemy, myHero, 2)
			end
			if HYDRAREADY then
				cItemDmg = cItemDmg + getDmg("HYDRA", enemy, myHero)
			end
			if TIAMATREADY then
				cItemDmg = cItemDmg + getDmg("TIAMAT", enemy, myHero)
			end
		   
		   
			EnemyTable[i].q = cqDmg
		   
			EnemyTable[i].q2 = EnemyTable[i].q + (cqDmg / 2)
		   
			EnemyTable[i].e = ceDmg
			if RREADY then
				UltExtraDmg = myHero.totalDamage
				if (myHero:CanUseSpell(_W) == READY) then
					UltExtraDmg = UltExtraDmg + (.15*myHero:GetSpellData(_R).level+5) * (EnemyTable[i].q2 + EnemyTable[i].e + EnemyTable[i].p + caaDmg)
				else
					UltExtraDmg = UltExtraDmg + (.15*myHero:GetSpellData(_R).level+5) * (EnemyTable[i].q + EnemyTable[i].e + EnemyTable[i].p + caaDmg)
				end
				UltExtraDmg = myHero:CalcDamage(enemy, UltExtraDmg)
			end
			EnemyTable[i].r = UltExtraDmg
		   
			local temp = 0
		   	local tem = cItemDmg + caaDmg+getDamageP(enemy)
			
			if not QREADY and not WREADY and not EREADY and not RREADY then
				temp = tem
				DrawLineHPBar(temp, currLine, "AA "..temp , enemy)
				currLine = currLine + 1
			end	
			
			if QREADY and not WREADY and not EREADY and not RREADY then
				temp = tem+EnemyTable[i].q 
				DrawLineHPBar(temp, currLine, "Q "..temp , enemy)
				currLine = currLine + 1
			end	
			if EREADY and not QREADY and not WREADY and not RREADY then
				temp = tem+EnemyTable[i].e 
				DrawLineHPBar(temp, currLine, "E "..temp , enemy)
				currLine = currLine + 1
			end			
			if QREADY and WREADY and not EREADY and not RREADY then
				temp=tem+EnemyTable[i].q2
				DrawLineHPBar(temp, currLine, "Q+W: "..temp, enemy)
				currLine = currLine + 1
			end
			if QREADY and EREADY and not WREADY and not RREADY then
				temp = tem+EnemyTable[i].q+EnemyTable[i].e
				DrawLineHPBar(temp, currLine, "Q+E: "..temp, enemy)
				currLine = currLine + 1
			end
			if QREADY and WREADY and EREADY and not RREADY then
				temp = tem+EnemyTable[i].q2+EnemyTable[i].e
				DrawLineHPBar(temp, currLine, "Q+W+E: "..temp, enemy)
				currLine = currLine + 1
			end
			
			if QREADY and not WREADY and EREADY and RREADY then
				temp = tem+EnemyTable[i].q+EnemyTable[i].e + EnemyTable[i].r
				DrawLineHPBar(temp, currLine, "Q+W+E+R: "..temp, enemy)
				currLine = currLine + 1
			end
			
			if QREADY and WREADY and EREADY and RREADY then
				temp = tem+EnemyTable[i].q2+EnemyTable[i].e + EnemyTable[i].r
				DrawLineHPBar(temp, currLine, "Q+W+E+R: "..temp, enemy)
				currLine = currLine + 1
			end
		end
	end
end
--CallBacks--
 
function findBestTarget()
    local bestTarget = nil
    local currentTarget = nil
    for i, currentTarget in ipairs(GetEnemyHeroes()) do
        if GetDistance(currentTarget) <= Ranges[_R] and not currentTarget.dead then
            if bestTarget == nil then
                bestTarget = currentTarget
            elseif TS_GetPriority(currentTarget) < TS_GetPriority(bestTarget) then
                bestTarget = currentTarget
            end
        end
    end
    return bestTarget
end

function OnCreateObj(obj)
	if obj.valid and obj.name:find("Zed_Clone_idle.troy") then
		if wUsed and wClone == nil then
			wClone = obj
		elseif rClone == nil then
			rClone = obj
		end
	end
	if obj.valid and obj.name:find("Zed_Base_R_buf_tell.troy") then
		isDead = true
		PrintFloatText(myHero,9,"Dead By Mark")
		DelayAction(function() isDead = false end, 3)
		PrintAlert("TARGET DEAD!!!", 4, 255, 0, 0)
		PrintAlert("TARGET DEAD!!!", 4, 255, 0, 0)
		PrintAlert("TARGET DEAD!!!", 4, 255, 0, 0)
	end
end
 
function OnDeleteObj(obj)
	if obj.valid and wClone and obj == wClone then
		wUsed = false
		wClone = nil
	elseif obj.valid and rClone and obj == rClone then
		rClone = nil
	end
	if obj.valid and obj.name:find("Zed_Base_R_buf_tell.troy") then
		isDead = false
	end
end
-- Cast X states
function getRState()
	--can cast R to target
	if myHero:CanUseSpell(_R) == READY and myHero:GetSpellData(_R).name:lower() ~= "zedr2" then 
		return 0
	--can swap to R
	elseif myHero:CanUseSpell(_R) == READY and myHero:GetSpellData(_R).name:lower() == "zedr2" and rClone and rClone.valid  then 
		return 1
	--already use swap
	elseif !(myHero:CanUseSpell(_R) == READY) and rClone and rClone.valid  then 
		return 2
	else
		return -1
	end
end

function getWState()
	--can cast R to target
	if myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name:lower() ~= "zedw2" then 
		return 0
	--can swap to R
	elseif myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name:lower() == "zedw2" and wClone and wClone.valid then 
		return 1
	--already use swap
	elseif !(myHero:CanUseSpell(_W) == READY) and wClone and wClone.valid then 
		return -1
	else
		return -1
	end
end

function isReadyIgnite()
	local bool = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	return bool
end

function isReadyQ()
	local bool = myHero:CanUseSpell(_Q) == READY
	return bool
end

function isReadyE()
	local bool = myHero:CanUseSpell(_E) == READY
	return bool
end

function OnProcessSpell(unit, spell)
	if unit.isMe and spell.name == "ZedShadowDash" then
		wUsed = true
		lastW = GetTickCount()
		wCast = true
	end
	
	if unit ~= nil and unit.type == "obj_AI_Hero" then
		if unit.team ~= myHero.team and GetDistance(unit) <= Ranges[_R] then
			local spelltype, casttype = getSpellType(unit, spell.name)
			if spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" then
				if Config.misc.AutoR[unit.charName..spelltype] then

				end
			end
		end
	end
		--if spell.name:lower():find("dazzle") then
				--CastR()
				--PrintChat("Dodged?")
		--end
end
 
 
function OnAnimation(unit, animationName)
	if unit.isMe and lastAnimation ~= animationName then lastAnimation = animationName end
end
		 

		 
function OnDraw() 
	if Config.draw.DmgIndic then
		Calculations()
	end
end

function OnBugsplat()
		UpdateWeb(false, ScriptName, id, HWID)
end
		 
-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 53
ScriptName = "BioZed"
 
-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()


function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
 
function arrangePrioritys()
		local priorityOrder = {
				[1] = {1,1,1,1,1,1},
		[2] = {1,1,2,2,2,2},
		[3] = {1,1,2,2,3,3},
		[4] = {1,1,2,3,4,4},
		[5] = {1,1,2,3,4,5},
	}
		local enemies = #GetEnemyHeroes()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, priorityOrder[enemies][1])
		SetPriority(priorityTable.AP,       enemy, priorityOrder[enemies][2])
		SetPriority(priorityTable.Support,  enemy, priorityOrder[enemies][3])
		SetPriority(priorityTable.Bruiser,  enemy, priorityOrder[enemies][4])
				SetPriority(priorityTable.Tank_dmg,  enemy, priorityOrder[enemies][5])
		SetPriority(priorityTable.Tank,     enemy, priorityOrder[enemies][6])
	end
end
-- DAMAGE CALCULATIONS
function getDamageP(target)
	local dmg = 0
	if target.health/target.maxHealth <= 0.5 then dmg = ((myHero:GetSpellData(_R).level-1)*2+6)*target.maxHealth/100 end
	return dmg
end
function getDamageAA(target)
	local dmg = getDmg("AD", target, myHero)
	return dmg
end
function getDamageQ(target)
  local dmg = getDmg("Q", target, myHero)
  return QDmg
end
function getDamageW(target)
	local dmg = getDmg("W", target, myHero)
	return dmg
end
function getDamageE(target)
	local dmg = getDmg("E", target, myHero)
	return dmg
end
function getDamageR(target)
	local dmg = getDmg("R", target, myHero)
	return dmg
end
function getDamageIgnite(target)
	local dmg = getDmg("IGNITE", target, myHero)
	return dmg
end
function getManaQ() 
	local mana = myHero:GetSpellData(_Q).mana
	return mana
end
function getManaW() 
	local mana = myHero:GetSpellData(_W).mana
	return mana
end
function getManaE() 
	local mana = myHero:GetSpellData(_E).mana
	return mana
end
function getManaR() 
	local mana = myHero:GetSpellData(_R).mana
	return mana
end

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
                        writeConfigsspells()
                        PrintChat("Skill Detector - Unknown spell: "..spellName)
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
