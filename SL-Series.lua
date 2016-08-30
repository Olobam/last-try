local SLSeries = 1.23
local SLPatchnew = nil
if GetGameVersion():sub(3,4) >= "10" then
		SLPatchnew = GetGameVersion():sub(1,4)
	else
		SLPatchnew = GetGameVersion():sub(1,3)
end
local AutoUpdater = true

require 'OpenPredict'

local SLSChamps = {	
	["Vayne"] = true,
	["Soraka"] = true,
	["Blitzcrank"] = true,
	["Kalista"] = true,
	["Velkoz"] = true,
	["Nasus"] = true,
	["Jinx"] = true,
	["Aatrox"] = true,
	["Kindred"] = true,
	["Nocturne"] = true,
	["Sivir"] = true,
	["Vladimir"] = true,
}

if not FileExist(COMMON_PATH.. "Analytics.lua") then
  DownloadFileAsync("https://raw.githubusercontent.com/LoggeL/GoS/master/Analytics.lua", COMMON_PATH .. "Analytics.lua", function() end)
end

if SLSChamps[myHero.charName] then
	require("Analytics")

	Analytics("SL-Series", "SL-Team", true)
end

local Name = GetMyHero()
local ChampName = myHero.charName
local Dmg = {}
local Mode = nil
local SReady = {
	[0] = false,
	[1] = false,
	[2] = false,
	[3] = false,
}

local function GetADHP(unit)
	return GetCurrentHP(unit) + GetDmgShield(unit)
end

local function GetAPHP(unit)
	return GetCurrentHP(unit) + GetDmgShield(unit) + GetMagicShield(unit)
end

local function GetReady()
	for s = 0,3 do 
		if CanUseSpell(myHero,s) == READY then
			SReady[s] = true
		else 
			SReady[s] = false
		end
	end
end 

local t = {_G.MoveToXYZ, _G.AttackUnit, _G.CastSkillShot, _G.CastSkillShot2, _G.CastSkillShot3, _G.HoldPosition, _G.CastSpell, _G.CastTargetSpell}
function Stop(state)
	if state then 
		_G.MoveToXYZ, _G.AttackUnit, _G.CastSkillShot, _G.CastSkillShot2, _G.CastSkillShot3, _G.HoldPosition, _G.CastSpell, _G.CastTargetSpell = function() end, function() end,function() end,function() end,function() end,function() end,function() end,function() end
		BlockF7OrbWalk(true)
		BlockF7Dodge(true)
	else
		_G.MoveToXYZ, _G.AttackUnit, _G.CastSkillShot, _G.CastSkillShot2, _G.CastSkillShot3, _G.HoldPosition, _G.CastSpell, _G.CastTargetSpell = t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8]
		BlockF7OrbWalk(false)
		BlockF7Dodge(false)
	end
end

Callback.Add("Load", function()	
	Update()
	Init()
	if SLSChamps[ChampName] and SLS.Loader.LC:Value() then
		_G[ChampName]() 
		if SLS.Loader.LDraw:Value() then
			Drawings()
		end
	end
	if SLSChamps[ChampName] then
		PrintChat("<font color=\"#fd8b12\"><b>["..SLPatchnew.."] [SL-Series] v.: "..SLSeries.." - <font color=\"#FFFFFF\">" ..ChampName.." <font color=\"#F2EE00\"> Loaded! </b></font>")
	else
		PrintChat("<font color=\"#fd8b12\"><b>["..SLPatchnew.."] [SL-Series] v.: "..SLSeries.." - <font color=\"#FFFFFF\">" ..ChampName.." <font color=\"#F2EE00\"> is not Supported </b></font>")
	end
	if SLS.Loader.LD:Value() then
		DmgDraw()
	end
	if SLS.Loader.LRS:Value() then
		Recommend()
	end
	SLOrb()
end)   
 
class 'Init'

function Init:__init()
	local AntiGapCloser = {}
	local GapCloser = {}
	local MapPositionGOS = {["Vayne"] = true, ["Poppy"] = true, ["Kalista"] = true, ["Kindred"] = true,}
	
	SLS = MenuConfig("SL-Series", "["..SLPatchnew.."][v.:"..SLSeries.."] SL-Series")
	SLS:Menu("Loader", "|SL| Loader")
	L = SLS["Loader"]
	L:Boolean("LC", "Load Champion", true)
	L:Info("0.1", "")
	L:Boolean("LD", "Load DmgDraw", true)
	L:Info("0.2", "")
	L:Boolean("LDraw", "Load Drawings", true)
	L:Info("0.6xc", "")
	L:Boolean("LRS", "Load Recommended Scripts",true)
	L:Info("xxx", "")
	L:Info("0.7.", "You will have to press 2f6")
	L:Info("0.8.", "to apply the changes")
	
	if L.LC:Value() and SLSChamps[ChampName] then
		SLS:Menu(ChampName, "|SL| "..ChampName) 
		BM = SLS[ChampName] 
		
		if AntiGapCloser[ChampName] == true then 
			BM.M:Menu("AGP", "AntiGapCloser") 
		end
		if GapCloser[ChampName] == true then 
			BM.M:Menu("GC", "GapCloser")
		end
	end
	
	if MapPositionGOS[ChampName] == true and FileExist(COMMON_PATH .. "MapPositionGOS.lua") then
		if not _G.MapPosition then
			require('MapPositionGoS')
		end
	end
end

class 'Recommend'

function Recommend:__init()
	self.RecommendedUtility = {
	[1] = {Name = "Radar Hack", 	Link = "https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/RadarHack.lua",		        Author = "Noddy",	File = "RadarHack"},
	[2] = {Name = "Recall Tracker",	Link = "https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/RecallTracker.lua",	        Author = "Noddy",	File = "RecallTracker"},
	[3] = {Name = "GoSEvade",       Link = "https://raw.githubusercontent.com/KeVuong/GoS/master/Evade.lua",                    Author = "MeoBeo",  File = "Evade"},
	}

	SLS:Menu("Re","|SL| Recommended Scripts")
	SLS.Re:Info("xx.x", "Load : ")
	for n,i in pairs(self.RecommendedUtility) do
		SLS.Re:Boolean("S"..n,"- "..i.Name.." ["..i.Author.."]", false)
	end
	SLS.Re:Info("xxx","2x F6 after download")
	
	for n,i in pairs(self.RecommendedUtility) do
		if SLS.Re["S"..n]:Value() and not pcall (require, i.File) then
			DownloadFileAsync(i.Link, SCRIPT_PATH .. i.File..".lua", function() 
				if pcall (require, i.File) then
					print("|SL| Downloaded "..i.Name.." from "..i.Author.." succesfully.") 
				else
					print("Error downloading, please install manually")
				end
			end)
		elseif SLS.Re["S"..n]:Value() and FileExist(SCRIPT_PATH .. i.File .. ".lua") then
			require(i.File)
			print("|SL| Loaded "..i.Name)
		end
	end
end

class 'SLOrb'

function SLOrb:__init()
	SLS:Menu("SO","|SL| OrbSettings")
	SLS.SO:KeyBinding("Combo", "Combo", string.byte(" "), false)
	SLS.SO:KeyBinding("Harass", "Harass", string.byte("C"), false)
	SLS.SO:KeyBinding("LaneClear", "LaneClear", string.byte("V"), false)
	SLS.SO:KeyBinding("LastHit", "LastHit", string.byte("X"), false)
	
	Callback.Add("Tick",function() 
		if 		SLS.SO.Combo:Value() then Mode = "Combo" 
		elseif 	SLS.SO.Harass:Value() then Mode = "Harass" 
		elseif 	SLS.SO.LaneClear:Value() then Mode = "LaneClear" 
		elseif 	SLS.SO.LastHit:Value() then Mode = "LastHit" 
		else Mode = nil 
		end
	end)
	
end
	
---------------------------------------------------------------------------------------------
-------------------------------------CHAMPS--------------------------------------------------
---------------------------------------------------------------------------------------------


--[[
 __      __                    
 \ \    / /                    
  \ \  / /_ _ _   _ _ __   ___ 
   \ \/ / _` | | | | '_ \ / _ \
    \  / (_| | |_| | | | |  __/
     \/ \__,_|\__, |_| |_|\___|
               __/ |           
              |___/                       
--]]

class 'Vayne'

function Vayne:__init()

	Vayne.Spell = {
	[0] = { range = 300 },
	[1] = { range = 0 },
	[2] = { delay = 0.25, speed = 2000, width = 1, range = 550 },
	[3] = { range = 0 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 5 * GetCastLevel(myHero,0) + 25 + ((GetBaseDamage(myHero) + GetBonusDmg(myHero)) * .5), 0) end,
	[1] = function (unit) return CalcDamage(myHero, unit, (1.5 * GetCastLevel(myHero,1) + 4.5) * (GetMaxHP(unit)/100) , 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 35 * GetCastLevel(myHero,2) + 15 + GetBonusDmg(myHero) * .5, 0) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 20 * GetCastLevel(myHero,3) + 10, 0) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Slider("a", "accuracy", 30, 1, 50, 5)
	BM.C:Slider("pd", "Push distance", 480, 1, 550, 5)	
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	BM.C:Slider("RHP", "myHeroHP ", 75, 1, 100, 5)
	BM.C:Slider("REHP", "EnemyHP ", 65, 1, 100, 5)
	
	BM:Menu("H", "Harass")
	BM.H:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", false)

	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("ProcessSpellComplete", function(unit, spell) self:AAReset(unit, spell) end)
	AntiChannel()
	AntiGapCloser()
	DelayAction( function ()
	if BM["AC"] then BM.AC:Info("ad", "Use Spell(s) : ") BM.AC:Boolean("E","Use E", true) end
	if BM["AGC"] then BM.AGC:Info("ad", "Use Spell(s) : ") BM.AGC:Boolean("E","Use E", true) end
	end,.001)

end

function Vayne:AntiChannel(unit,range)
	if BM.AC.E:Value() and range < Vayne.Spell[2].range and SReady[2] then
		CastTargetSpell(unit,2)
	end
end

function Vayne:AntiGapCloser(unit,range)
	if BM.AGC.E:Value() and range < Vayne.Spell[2].range and SReady[2] then
		CastTargetSpell(unit,2)
	end
end

function Vayne:Tick()
	if myHero.dead then return end
			
	GetReady()
	
	self:KS()
		
	local target = GetCurrentTarget()
	   if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:JungleClear()
		self:LaneClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Vayne:CastE(unit)
	local e = GetPrediction(unit, self.Spell[2])
	local ePos = Vector(e.castPos)
	local c = math.ceil(BM.C.a:Value())
	local cd = math.ceil(BM.C.pd:Value()/c)
	for step = 1, c, 5 do
		local PP = Vector(ePos) + Vector(Vector(ePos) - Vector(myHero)):normalized()*(cd*step)
			
		if MapPosition:inWall(PP) == true then
			CastTargetSpell(unit, 2)
		end		
	end
end

function Vayne:AAReset(unit, spell)
	local ta = spell.target
	if unit == myHero and ta ~= nil and spell.name:lower():find("attack") and SReady[0] then
	  local QPos = Vector(ta) - (Vector(ta) - Vector(myHero)):perpendicular():normalized() * ( GetDistance(myHero,ta) * 1.2 )
	  local QPos2 = Vector(Vector(myHero) - Vector(ta)) + Vector(myHero):normalized() * 75
	  local QPos3 = Vector(ta) + Vector(ta):normalized()
		if Mode == "Combo" and BM.C.Q:Value() and ValidTarget(ta, 825) then
			if BM.C.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.C.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.C.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.C.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif Mode == "Harass" and BM.H.Q:Value() and ValidTarget(ta, 825) then
			if BM.H.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.H.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.H.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.H.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif Mode == "LaneClear" and BM.JC.Q:Value() and GetTeam(ta) == MINION_JUNGLE then
			if BM.JC.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.JC.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.JC.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.JC.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif Mode == "LaneClear" and BM.LC.Q:Value() and GetTeam(ta) == MINION_ENEMY then
			if BM.LC.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.LC.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.LC.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.LC.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		end
	end
end

function Vayne:Combo(target)
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		self:CastE(target)
	end
	if SReady[3] and ValidTarget(target, 800) and BM.C.R:Value() and EnemiesAround(myHero,800) >= BM.C.RE:Value() and GetPercentHP(myHero) < BM.C.RHP:Value() and GetPercentHP(target) < BM.C.REHP:Value() then
		CastSpell(3)
	end
end

function Vayne:Harass(target)
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
		self:CastE(target)
	end
end

function Vayne:JungleClear()
 for _,mob in pairs(minionManager.objects) do
	if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() and GetTeam(mob) == MINION_JUNGLE then
		self:CastE(mob)
	end
 end
end

function Vayne:LaneClear()
 for _,minion in pairs(minionManager.objects) do
	if SReady[2] and ValidTarget(minion, self.Spell[2].range) and BM.LC.E:Value() and GetTeam(minion) == MINION_ENEMY then
		self:CastE(minion)
	end
 end
end

function Vayne:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[2] and GetADHP(target) < Dmg[2](target) and ValidTarget(target, self.Spell[2].range) then
			CastTargetSpell(target, 2)
		end
	end
end


--[[
  ____  _ _ _                           _    
 | __ )| (_) |_ _______ _ __ __ _ _ __ | | __
 |  _ \| | | __|_  / __| '__/ _` | '_ \| |/ /
 | |_) | | | |_ / / (__| | | (_| | | | |   < 
 |____/|_|_|\__/___\___|_|  \__,_|_| |_|_|\_\
                                             
--]]

class 'Blitzcrank'

function Blitzcrank:__init()

	Blitzcrank.Spell = {
	[0] = { delay = 0.25, speed = 1800, width = 70, range = 900 },
	[1] = { range = 0 },
	[2] = { range = 0 },
	[3] = { range = 650 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 0, 55 * GetCastLevel(myHero,0) + 25 + GetBonusAP(myHero)) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, (GetBaseDamage(myHero) + GetBonusDmg(myHero)) * 2, 0) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 0, 125 * GetCastLevel(myHero,3) + 125 + GetBonusAP(myHero)) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("EAR", "R hit enemies >= x ", 2, 1, 5, 1)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)
	BM.LC:Boolean("R", "Use R", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	BM.JC:Boolean("R", "Use R", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable","Enable KS", true)
	BM.KS:Boolean("Q", "Use Q", true)
	BM.KS:Boolean("R", "Use R", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	AntiChannel()
	DelayAction( function ()
	if BM["AC"] then
	BM.AC:Info("ad", "Use Spell(s) : ")
	BM.AC:Boolean("Q","Use Q", true)
	BM.AC:Boolean("R","Use R", true)
	end
	end,.001)
end

function Blitzcrank:Tick()
	if myHero.dead then return end
	
	local target = GetCurrentTarget()
	
	   if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Blitzcrank:AntiChannel(unit,range)
	if BM.AC.Q:Value() and range < 600 and SReady[3] then
		CastSpell(3)
	elseif BM.AC.R:Value() and SReady[0] and range < Blitzcrank.Spell[0].range then
		local Pred = GetPrediction(unit, Blitzcrank.Spell[0])
		if not Pred:mCollision(1) then
			CastSkillShot(0,Pred.castPos)
		end
	end
end

function Blitzcrank:Combo(target)
		if SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.C.Q:Value() then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and not Pred:mCollision(1) and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[1] and ValidTarget(target, 1000) and BM.C.W:Value() and GetDistance(myHero,target) <= 850 and SReady[0] then
			CastSpell(1)
		end
		if SReady[2] and ValidTarget(target, 250) and BM.C.E:Value() then
			CastSpell(2)
		end
		if SReady[3] and ValidTarget(target, GetCastRange(myHero,3)) and EnemiesAround(GetOrigin(myHero), GetCastRange(myHero,3)) >= BM.C.EAR:Value() and BM.C.R:Value() then
			CastSpell(3)
		end
end

function Blitzcrank:Harass(target)
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.H.Q:Value() then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and not Pred:mCollision(1) and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[2] and ValidTarget(target, 300) and BM.H.E:Value() then
			CastSpell(2)
		end 
end

function Blitzcrank:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range) and BM.LC.Q:Value() then
			local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(minion, 300) and BM.LC.E:Value() then
				CastSpell(2)
			end 
			if SReady[3] and ValidTarget(minion, 600) and BM.LC.R:Value() then
				CastSpell(3)
			end
		end
	end
end

function Blitzcrank:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_ENEMY then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
			local Pred = GetPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(mob, 300) and BM.JC.E:Value() then
				CastSpell(2)
			end 
			if SReady[3] and ValidTarget(mob, 600) and BM.JC.R:Value() then
				CastSpell(3)
			end
		end
	end
end

function Blitzcrank:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetAPHP(unit) < Dmg[0](unit) and SReady[0] and ValidTarget(unit, self.Spell[0].range) and BM.KS.Q:Value() then
			local Pred = GetPrediction(unit, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and not Pred:mCollision(1) and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if GetADHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, 300) and BM.KS.E:Value() then
			CastSpell(2)
		end
		if GetAPHP(unit) < Dmg[3](unit) and SReady[3] and ValidTarget(unit, 600) and BM.KS.R:Value() then
			CastSpell(3)
		end
	end
end


--[[
   _____                 _         
  / ____|               | |        
 | (___   ___  _ __ __ _| | ____ _ 
  \___ \ / _ \| '__/ _` | |/ / _` |
  ____) | (_) | | | (_| |   < (_| |
 |_____/ \___/|_|  \__,_|_|\_\__,_|
                                   
--]]


class 'Soraka'

function Soraka:__init()

	Soraka.Spell = {
	[0] = { delay = 0.250, speed = math.huge, width = 235, range = 800 },
	[1] = { range = 550 },
	[2] = { delay = 1.75, speed = math.huge, width = 310, range = 900 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 0, 40 * GetCastLevel(myHero,0) + 30 + GetBonusAP(myHero) * .35 ) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 40 * GetCastLevel(myHero,2) + 30 + GetBonusAP(myHero) * .4 ) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)

	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)

	BM:Menu("AW", "Auto W")
	BM.AW:Boolean("Enable", "Enable Auto W", true)
	BM.AW:Info("5620-", "(myHeroHP) To Heal ally")
	BM.AW:Slider("myHeroHP", "myHeroHP >= X", 5, 1, 100, 10)
	BM.AW:Slider("allyHP", "AllyHP <= X", 85, 1, 100, 10)
	BM.AW:Slider("ATRR", "Ally To Enemy Range", 1500, 500, 3000, 10)	
	
	DelayAction(function()
		for _,i in pairs(GetAllyHeroes()) do
			BM.AW:Boolean("h"..GetObjectName(i), "Heal "..GetObjectName(i))
		end
	end, .001)

	BM:Menu("AR", "Auto R")
	BM.AR:Boolean("Enable", "Enable Auto R", true)
	BM.AR:Info("HealInfo", "(myHeroHP) to Heal me with ult")
	BM.AR:Slider("myHeroHP", "myHeroHP <= X", 8, 1, 100, 10)
	BM.AR:Slider("allyHP", "AllyHP <= X", 8, 1, 100, 10)
    	BM.AR:Slider("ATRR", "Ally To Enemy Range", 1500, 500, 3000, 10)

	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("Q", "Use Q", false)
	BM.KS:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)
	BM.p:Slider("aE", "Adjust E Delay", 1.5, .5, 2, .1)
	
	Callback.Add("Tick", function() self:Tick() end)
	AntiChannel()
	DelayAction( function ()
	if BM["AC"] then BM.AC:Info("ad", "Use Spell(s) : ") BM.AC:Boolean("E","Use E", true) end
	end,.001)
end

function Soraka:AntiChannel(unit,range)
	if SReady[2] and BM.AC.E:Value() and ValidTarget(unit,Soraka.Spell[2].range) then
		CastSkillShot(2,GetOrigin(unit))
	end
end

function Soraka:Tick()
	if myHero.dead then return end
	self.Spell[0].delay = BM.p.aE:Value()
		
	GetReady()
		
	self:KS()
	
	self:AutoW()
		
	self:AutoR()
	
	local Target = GetCurrentTarget()

	if Mode == "Combo" then
		self:Combo(Target)
	elseif Mode == "LaneClear" then
		self:JungleClear()
		self:LaneClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Soraka:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		self.Spell[0].delay = .25 + (GetDistance(myHero,target) / self.Spell[0].range)*.75
		local Pred = GetCircularAOEPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
end

function Soraka:Harass(target)
		if SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.H.Q:Value() then
			self.Spell[0].delay = .25 + (GetDistance(myHero,target) / self.Spell[0].range)*.55
			local Pred = GetCircularAOEPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
		end
		if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
			local Pred = GetCircularAOEPrediction(target, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
	end
end

function Soraka:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetAPHP(unit) < Dmg[0](unit) and SReady[0] and ValidTarget(unit, self.Spell[0].range) and BM.KS.Q:Value() then
			self.Spell[0].delay = .25 + (GetDistance(myHero,target) / self.Spell[0].range)*.55
			local Pred = GetCircularAOEPrediction(unit, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if GetAPHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, self.Spell[2].range) and BM.KS.E:Value() then
			local Pred = GetCircularAOEPrediction(unit, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
	end
end

function Soraka:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range*1.1) and BM.LC.Q:Value() then
				self.Spell[0].delay = .25 + (GetDistance(myHero,minion) / self.Spell[0].range)*.55
				local Pred = GetCircularAOEPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(minion, self.Spell[2].range) and BM.LC.E:Value() then
				local Pred = GetCircularAOEPrediction(minion, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end
end

function Soraka:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range*1.1) and BM.JC.Q:Value() then
				self.Spell[0].delay = .25 + (GetDistance(myHero,mob) / self.Spell[0].range)*.55
				local Pred = GetCircularAOEPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() then
				local Pred = GetCircularAOEPrediction(mob, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end
end

function Soraka:AutoW()
    for _,ally in pairs(GetAllyHeroes()) do
	    if GetDistance(myHero,ally)<GetCastRange(myHero,1) and SReady[1] and GetPercentHP(myHero) >= BM.AW.myHeroHP:Value() and GetPercentHP(ally) <= BM.AW.allyHP:Value() and BM.AW.Enable:Value() and EnemiesAround(GetOrigin(ally), BM.AW.ATRR:Value()) >= 1 and BM.AW["h"..GetObjectName(ally)]:Value() then
		    CastTargetSpell(ally, 1)
		end
	end
end

function Soraka:AutoR()
    for _,ally in pairs(GetAllyHeroes()) do
	    if SReady[3] and not ally.dead and GetPercentHP(ally) <= BM.AR.allyHP:Value() and BM.AR.Enable:Value() and EnemiesAround(GetOrigin(ally), BM.AR.ATRR:Value()) >= 1 then
		    CastSpell(3)
	    elseif SReady[3] and not myHero.dead and GetPercentHP(myHero) <= BM.AR.myHeroHP:Value() and BM.AR.Enable:Value() and EnemiesAround(GetOrigin(myHero), BM.AR.ATRR:Value()) >= 1 then
		    CastSpell(3)
		end
	end
end


class 'Sivir'

function Sivir:__init()
	
	Sivir.Spell = { 
	[0] = { delay = 0.250, speed = 1350, width = 85, range = 1075 },
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 20 * GetCastLevel(myHero,0) + 5 + (.1 * GetCastLevel(myHero,0) + .6) * (GetBonusDmg(myHero) + GetBaseDamage(myHero)), .5*GetBonusAP(myHero)) end,
	[1] = function (unit) return CalcDamage(myHero, unit, ((5 * GetCastLevel(myHero,2) + 45)/100) * GetBonusDmg(myHero), 0) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	BM.C:Slider("RHP", "myHeroHP ", 75, 1, 100, 5)
	BM.C:Slider("REHP", "EnemyHP ", 65, 1, 100, 5)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("W", "Use W", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("W", "Use W", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("ProcessSpellComplete", function(unit,spell) self:AAReset(unit,spell) end)
	HitMe()
end

function Sivir:Tick()
	if myHero.dead then return end
		
	GetReady()
		
	self:KS()
		
	local Target = GetCurrentTarget()
	
	if Mode == "Combo" then
		self:Combo(Target)
	elseif Mode == "LaneClear" then
		self:JungleClear()
		self:LaneClear()
	else
		return
	end
end

function Sivir:AAReset(unit, spell)
	local ta = spell.target
	if unit == myHero and ta ~= nil and spell.name:lower():find("attack") and SReady[1] then
		if Mode == "Combo" and BM.C.W:Value() then
			if ValidTarget(ta, GetRange(myHero)+GetHitBox(myHero)) then
				CastSpell(1)
			end
		elseif Mode == "LaneClear" and BM.LC.W:Value() and GetTeam(ta) == MINION_ENEMY then
			if ValidTarget(ta, GetRange(myHero)+GetHitBox(myHero)) then
				CastSpell(1)
			end
		elseif Mode == "LaneClear" and BM.JC.W:Value() and GetTeam(ta) == MINION_JUNGLE then
			if ValidTarget(ta, GetRange(myHero)+GetHitBox(myHero)) then
				CastSpell(1)
			end
		end
	end
end
				

function Sivir:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		local Pred = GetPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[3] and ValidTarget(target, 800) and BM.C.R:Value() and EnemiesAround(myHero,800) >= BM.C.RE:Value() and GetPercentHP(myHero) < BM.C.RHP:Value() and GetPercentHP(target) < BM.C.REHP:Value() then
		CastSpell(3)
	end
end

function Sivir:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range) and BM.LC.Q:Value() then
				local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
		end
	end
end

function Sivir:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
				local Pred = GetPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
		end
	end
end

function Sivir:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetAPHP(target) < Dmg[0](target) then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
	end
end

function Sivir:HitMe(k,pos,dt,ty)
 DelayAction( function() 
  CastSpell(2)
 end,dt)
end

class 'Nocturne'

function Nocturne:__init()
	Nocturne.Spell = {
	[0] = { delay = 0.250, speed = 1400, width = 120, range = 1125 },
	[2] = { range = 425},
	[3] = { range = function() return 1750 + GetCastLevel(myHero,3)*750 end},
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 45 * GetCastLevel(myHero,0) + 15 + GetBonusDmg(myHero)* .75, 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 45 * GetCastLevel(myHero,2) + 35 + myHero.ap) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 0, 45 * GetCastLevel(myHero,2) + 35 + myHero.ap) end,
	}
	
	self.marker = nil
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:DropDown("RM", "R Mode", 2, {"Off","Keypress","Auto"})
	BM.C:KeyBinding("RK", "R Keypress", string.byte("T"))
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
	
	HitMe()
end

function Nocturne:Tick()
	if myHero.dead then return end
		
	GetReady()
		
	self:KS()
		
	local Target = GetCurrentTarget()
	
	if Mode == "Combo" then
		self:Combo(Target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
	else
		return
	end
end

function Nocturne:KS()
	self.marker = false
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetADHP(target) < Dmg[0](target) then
		local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[3] and ValidTarget(target, self.Spell[3].range()) and GetADHP(target) < Dmg[0](target) + Dmg[3](target) + Dmg[2](target) + myHero.totalDamage*2 then
			self.marker = target
			if BM.C.RM:Value() == 3 or (BM.C.RM:Value() == 2 and BM.C.RK:Value()) then
				CastSpell(3)
				DelayAction(function() CastTargetSpell(target,3) end, .2)			
			end
		end
	end
end

function Nocturne:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		local Pred = GetPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		CastTargetSpell(target,2)
	end
end

function Nocturne:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if SReady[0] and ValidTarget(minion, self.Spell[0].range) then
			if GetTeam(minion) == MINION_ENEMY and BM.LC.Q:Value() then
				local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			elseif GetTeam(minion) == 300 and BM.JC.Q:Value() then
				local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
		end
	end
end

function Nocturne:Draw()
	if self.marker and BM.C.RM:Value() == 2 then
		DrawText(self.marker.charName .. " killable press " .. string.char(BM.C.RK:Key()),40,50,50,GoS.Red)
	end
end

function Nocturne:HitMe(k,pos,dt,ty)
	DelayAction( function() 
		CastSpell(1)
	end,dt)
end

--[[
                _                 
     /\        | |                
    /  \   __ _| |_ _ __ _____  __
   / /\ \ / _` | __| '__/ _ \ \/ /
  / ____ \ (_| | |_| | | (_) >  < 
 /_/    \_\__,_|\__|_|  \___/_/\_\
                                  
--]]

class "Aatrox"

function Aatrox:__init()
	
	Aatrox.Spell = { 
	[0] = { delay = 0.2, range = 650, speed = 1500, radius = 113 },
	[1] = { range = 0 },
	[2] = { delay = 0.1, range = 1000, speed = 1000, width = 150 },
	[3] = { range = 550 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 35 + GetCastLevel(myHero,0)*45 + GetBonusDmg(myHero)*.6, 0) end,
	[1] = function (unit) return CalcDamage(myHero, unit, 25 + GetCastLevel(myHero,1)*35 + GetBonusDmg(myHero), 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 40 + GetCastLevel(myHero,2)*35 + GetBonusDmg(myHero)*.6 + GetBonusAP(myHero)*.6) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 0, 100 + GetCastLevel(myHero,3)*100 + GetBonusAP(myHero)) end,
	}

	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("WE", "Only Toggle if enemy nearby", true)
	BM.C:Slider("WT", "Toggle W at % HP", 45, 5, 90, 5)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear", true)
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)	
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("Q", "Use Q", false)
	BM.KS:Boolean("E", "Use E", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)

	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:Stat(unit,buff) end)
	
	if GotBuff(myHero, "aatroxwpower") == 1 then
		self.W = "dmg"
	else
		self.W = "heal"
	end
end  

function Aatrox:Tick()
	if myHero.dead then return end
	
	GetReady()
		
	self:KS()
		
	local target = GetCurrentTarget()
		
	self:Toggle(target)
		
	if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "LastHit" then
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Aatrox:Toggle(target)
	if SReady[1] and BM.C.W:Value() and (not BM.C.WE:Value() or ValidTarget(target,750)) then
		if GetPercentHP(myHero) < BM.C.WT:Value()+1 and self.W == "dmg" then
			CastSpell(1)
		elseif GetPercentHP(myHero) > BM.C.WT:Value() and self.W == "heal" then
			CastSpell(1)
		end
	end
end

function Aatrox:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.C.Q:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range*1.1) and BM.C.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	if SReady[3] and ValidTarget(target, 550) and BM.C.R:Value() and EnemiesAround(myHero,550) >= BM.C.RE:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
end

function Aatrox:Harass(target)
	if SReady[2] and ValidTarget(target, self.Spell[2].range*1.1) and BM.H.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
end

function Aatrox:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range*1.1) and BM.LC.Q:Value() then
			local Pred = GetCircularAOEPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(minion, self.Spell[2].range*1.1) and BM.LC.E:Value() then
			local Pred = GetPrediction(minion, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end		
end

function Aatrox:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
			local Pred = GetCircularAOEPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[1] and BM.C.W:Value() and ValidTarget(mob,750) then
				if GetPercentHP(myHero) < BM.C.WT:Value()+1 and self.W == "dmg" then
					CastSpell(1)
				elseif GetPercentHP(myHero) > BM.C.WT:Value() and self.W == "heal" then
					CastSpell(1)
				end
			end
			if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() then
			local Pred = GetPrediction(mob, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end		
end

function Aatrox:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetADHP(unit) < Dmg[0](unit) and SReady[0] and ValidTarget(unit, self.Spell[0].range*1.1) and BM.KS.Q:Value() then
			local Pred = GetCircularAOEPrediction(unit, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if GetAPHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, self.Spell[2].range*1.1) and BM.KS.E:Value() then
			local Pred = GetPrediction(unit, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
	end
end

function Aatrox:Stat(unit, buff)
	if unit == myHero and buff.Name:lower() == "aatroxwlife" then
		self.W = "heal"
	elseif unit == myHero and buff.Name:lower() == "aatroxwpower" then
		self.W = "dmg"
	end
end

-- __     __   _ _   _            
-- \ \   / /__| ( ) | | _____ ____
--  \ \ / / _ \ |/  | |/ / _ \_  /
--   \ V /  __/ |   |   < (_) / / 
--    \_/ \___|_|   |_|\_\___/___|

class 'Velkoz'

function Velkoz:__init()
	BM:SubMenu("c", "Combo")
	BM.c:Boolean("Q","Use Q",true)
	BM.c:Boolean("FQ","Force Q Split",true)
	BM.c:Boolean("W","Use W",true)
	BM.c:Boolean("E","Use E",true)
	BM.c:Boolean("R","Use R",true)

	BM:SubMenu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)
	BM.p:Slider("hR", "HitChance R", 20, 0, 100, 1)

	BM:SubMenu("a", "Advanced")
	BM.a:Slider("eQ", "Extra Q", 20 , 10, 50, 2)
	BM.a:Slider("v", "QChecks", 4, 1, 8, 1)
	BM.a:Boolean("D","Developer Debug", false)

	self.ccTrack = {}
  	DelayAction(function ()
  		for _,i in pairs(GetEnemyHeroes()) do 
 			self.ccTrack[GetObjectName(i)] = false
  		end
 	end, .001)
	
	self.DegreeTable={22.5,-22.5,45,-45, 15, -15, 30, -30}
	self.rCast = false
	self.QStart = nil
	self.rTime = 0
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 40 * GetCastLevel(myHero,0) + 40 + GetBonusAP(myHero), 0)*.6 end, 
	[1] = function (unit) return CalcDamage(myHero, unit, 20 * GetCastLevel(myHero,1) + 10 + GetBonusDmg(myHero), 1)*.15 end, 
	[2] = function (unit) return CalcDamage(myHero, unit, 30 * GetCastLevel(myHero,2) - 10 + GetBonusDmg(myHero), 2)*.3 end, 
	[3] = function (unit) return Velkoz:RDmg(unit) end,
	}
	
	self.Spell = {
	[0] = { delay = 0.1, speed = 1300, width = 100, range = 750},
	[-1] ={ delay = 0.1, speed = 1300, width = 100, range = 1000},
	[1] = { delay = 0.1, speed = 1700, width = 100, range = 1050},
	[2] = { delay = 0.1, speed = 1700, range = 850, radius = 200 },
	}
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("ProcessSpellComplete", function(unit,spellProc) self:ProcessSpellComplete(unit,spellProc) end)
	Callback.Add("CreateObj", function(object) self:CreateObj(object) end)
	Callback.Add("UpdateBuff", function(unit,buffProc) self:UpdateBuff(unit,buffProc) end)
	Callback.Add("RemoveBuff", function(unit,buffProc) self:RemoveBuff(unit,buffProc) end)
	Callback.Add("Draw", function() self:Split() end)
	
	AntiChannel()
	AntiGapCloser()
	DelayAction( function ()
	if BM["AC"] then BM.AC:Info("ad", "Use Spell(s) : ") BM.AC:Boolean("E","Use E", true) end
	if BM["AGC"] then BM.AGC:Info("ad", "Use Spell(s) : ") BM.AGC:Boolean("E","Use E", true) end
	end,.001)

end

function Velkoz:AntiChannel(unit,range)
	if BM.AC.E:Value() and range < Velkoz.Spell[2].range and SReady[2] then
		CastSkillShot(_E,unit.pos)
	end
end

function Velkoz:AntiGapCloser(unit,range)
	if BM.AGC.E:Value() and range < Velkoz.Spell[2].range and SReady[2] then
		CastSkillShot(_E,unit.pos)
	end
end


function Velkoz:Tick()
	if myHero.dead or self.rCast then return end
	
	GetReady()
	
	GetReady()
	--self:Split()
		
	local target = GetCurrentTarget()
	
	if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
	--	self:LaneClear()
	--	self:JungleClear()
	elseif Mode == "LastHit" then
	--	self:LastHit()
	elseif Mode == "Harass" then
	--	self:Harass(target)
	else
		return
	end
end


function Velkoz:Combo(unit)
	for _,i in pairs(GetEnemyHeroes()) do
		if SReady[0] and BM.c.Q:Value() and GetCastName(myHero,0)=="VelkozQ" and ValidTarget(i,1400) then
			local direct=GetPrediction(i,self.Spell[0])
			if direct and direct.hitChance>=BM.p.hQ:Value()/100 and not direct:mCollision(1) then
				self.QStart=GetOrigin(myHero)
				CastSkillShot(0,direct.castPos)
			end
			local BVec = Vector(GetOrigin(i)) - Vector(GetOrigin(myHero))
			local dist = math.sqrt(GetDistance(GetOrigin(myHero),GetOrigin(i))^2/2)
			for l=1,BM.a.v:Value() do
				local sideVec=Velkoz:getVec(BVec,self.DegreeTable[l]):normalized()*dist
				local circlespot = sideVec+GetOrigin(myHero)
				local QPred = GetPrediction(i, self.Spell[0], circlespot)
				local QPred2 = GetPrediction(myHero, self.Spell[0], circlespot)
				if not QPred:mCollision(1) and not QPred2:mCollision(1) then
					CastSkillShot(0,circlespot)
					self.QStart=GetOrigin(myHero)
				end
			end
		end	
	end
	
	if BM.c.W:Value() and SReady[1] and ValidTarget(unit,1050) then
		local WPred = GetPrediction(unit, self.Spell[1])
		CastSkillShot(_W,WPred.castPos)
	end
		
	if BM.c.E:Value() and SReady[2]  and ValidTarget(unit,850) then
		local EPred = GetCircularAOEPrediction(unit, self.Spell[2])
		CastSkillShot(_E,EPred.castPos)
	end
	
	if BM.c.R:Value() and ValidTarget(unit,1550*.8) and SReady[3] and EnemiesAround(GetOrigin(myHero),400) == 0 and GetDistance(GetOrigin(myHero),GetOrigin(unit)) then
		if GetADHP(unit) < Velkoz:RDmg(unit) then
			CastSkillShot(3, GetOrigin(unit))
		end
	end
end

function Velkoz:RDmg(unit)
	local RTick = 27.5 + 22.5 * GetCastLevel(myHero,3) + GetBonusAP(myHero) * .1
	local Passive = 25 + 8 * GetLevel(myHero) + myHero.ap * .4
	local ticks = (1550 - GetDistance(GetOrigin(unit),GetOrigin(myHero))) / (GetMoveSpeed(unit)*.8)
	if self.ccTrack and self.ccTrack[GetObjectName(unit)] and self.rTime > GetGameTimer() then ticks = ticks + (self.rTime - GetGameTimer())*4 end
	ticks = math.max(ticks,10)
	return CalcDamage(myHero, unit, 0, RTick * ticks * 4) + Passive * 0.6
end

function Velkoz:Split()
	if SReady[0] and GetCastName(myHero,0)~="VelkozQ" and self.QBall and self.QStart then
		for _,i in pairs(GetEnemyHeroes()) do
			local split=GetPrediction(i, self.Spell[-1], GetOrigin(self.QBall))
			local BVector = Vector((GetOrigin(self.QBall))-Vector(self.QStart))
			local HVector = Vector((GetOrigin(self.QBall))-Vector(split.castPos))
			if BM.a.D:Value() then 
				DrawLine(WorldToScreen(0, self.QStart).x, WorldToScreen(0, self.QStart).y, WorldToScreen(0, self.QBall).x, WorldToScreen(0, self.QBall).y, 3, GoS.White)
				DrawLine(WorldToScreen(0, self.QBall).x, WorldToScreen(0, self.QBall).y, WorldToScreen(0, split.castPos).x, WorldToScreen(0, split.castPos).y, 3, GoS.White)
				DrawText(Velkoz:ScalarProduct(BVector,HVector)^2,30,500,20,GoS.White)
			end
			if ValidTarget(i,1600) and Velkoz:ScalarProduct(BVector,HVector)^2 < BM.a.eQ:Value()*.001 then
				CastSpell(0)
			end
		end
	end
end

function Velkoz:ProcessSpellComplete(unit,spellProc)
	if unit == myHero and spellProc.name:lower() == "velkozq" then
		self.QStart= Vector(spellProc.startPos)+Vector(Vector(spellProc.endPos)-spellProc.startPos):normalized()*5
	end
end

function Velkoz:CreateObj(object)
	if GetObjectBaseName(object)=="Velkoz_Base_Q_mis.troy" and GetDistance(myHero)<10 then
		self.QBall=object
		DelayAction(function() self.QBall=nil end,2)
	end
end

function Velkoz:getVec(base, degr)
	local x,y,z=base:unpack()
	x=x*math.cos(Velkoz:degrad(degr))-z*math.sin(Velkoz:degrad(degr))
	z=z*math.cos(Velkoz:degrad(degr))+x*math.sin(Velkoz:degrad(degr))
	return Vector(x,y,z)
end

function Velkoz:ScalarProduct(v1,v2)
	return (v1.x*v2.x+v1.y*v2.y+v1.z*v2.z)/(v1:len()*v2:len())
end

function Velkoz:degrad(degr)
	degr=(degr/180)*math.pi
	return degr
end

function Velkoz:UpdateBuff(unit,buffProc)
	if unit ~= myHero and (buffProc.Type == 29 or buffProc.Type == 11 or buffProc.Type == 24 or buffProc.Type == 30) then 
		self.ccTrack[GetObjectName(unit)] = true
		self.rTime = buffProc.ExpireTime
	elseif unit == myHero and buffProc.Name:lower() == "velkozr" then
		Stop(true)
		self.rCast = true
	end
end

function Velkoz:RemoveBuff(unit,buffProc)
	if unit ~= myHero and (buffProc.Type == 29 or buffProc.Type == 11 or buffProc.Type == 24 or buffProc.Type == 30) then 
		self.ccTrack[GetObjectName(unit)] = false
	elseif unit == myHero and buffProc.Name:lower() == "velkozr" then
		Stop(false)
		self.rCast = false
	end
end

--      _ _            
--     | (_)_ __ __  __
--  _  | | | '_ \\ \/ /
-- | |_| | | | | |>  < 
--  \___/|_|_| |_/_/\_\
                     

class 'Jinx'

function Jinx:__init()


	self.Spell = {
	[1] = { delay = 0.6, speed = 3000, width = 85, range = 1500},
	[2] = { delay = 1, speed = 887, width = 120, range = 900},
	[3] = { delay = 0.6, speed = 1700, width = 140, range = math.huge}
	}
	
	
	Dmg = {
	[1] = function (unit) return CalcDamage(myHero, unit, 50 * GetCastLevel(myHero,0) - 40 + (GetBonusDmg(myHero)+GetBaseDamage(myHero)) * 1.4, 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 55 * GetCastLevel(myHero,2) + 25 + GetBonusAP(myHero)) end, 
	[3] = function (unit) 
	local dmg = 150 + GetCastLevel(myHero,3)*GetBonusDmg(myHero)+(GetMaxHP(unit)-GetCurrentHP(unit))*(.20+GetCastLevel(myHero,3)*.5)
	return CalcDamage(myHero,unit, math.min(math.max(dmg*.1,dmg*GetDistance(GetOrigin(myHero),GetOrigin(unit))/1650),dmg), 0) end
	}
	
	BM:Menu("C", "Combo")
	BM.C:Menu("Q", "Q")
	BM.C.Q:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.C.Q:Boolean("enable", "Enable Q Combo", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("E", "Use E", true)
	
	BM:Menu("H", "Harass")
	BM.H:Menu("Q", "Q")
	BM.H.Q:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.H.Q:Boolean("enable", "Enable Q Harass", true)
	BM.H:Boolean("W", "Use W", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Menu("Q", "Q")
	BM.LC.Q:DropDown("QL", "Q-Logic", 1, {"Only Minigun", "Only Rockets"})
	BM.LC.Q:Boolean("enable", "Enable Q Laneclear", true)
	BM.LC:Boolean("W", "Use W", false)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Menu("Q", "Q")
	BM.JC.Q:DropDown("QL", "Q-Logic", 1, {"Only Minigun", "Only Rockets"})
	BM.JC.Q:Boolean("enable", "Enable Q Jungleclear", true)
	BM.JC:Boolean("W", "Use W", false)
	
	BM:Menu("LH", "LastHit")
	BM.LH:Boolean("UMinig", "Use only Minigun", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("W", "Use W", true)
	BM.KS:Boolean("E", "Use E", true)
	BM.KS:Boolean("R", "Enable R KS", true)
	BM.KS:Slider("mDTT", "R - max Distance to target", 3000, 675, 20000, 10)
	BM.KS:Slider("DTT", "R - min Distance to target", 1000, 675, 20000, 10)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hW", "HitChance W", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)
	BM.p:Slider("hR", "HitChance R", 50, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
	Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
	
end

function Jinx:UpdateBuff(unit, buff)
	if unit == myHero and buff.Name == "jinxqicon" then
		minigun = true
	end
end

function Jinx:RemoveBuff(unit, buff)
	if unit == myHero and buff.Name == "jinxqicon" then
		minigun = false
	end
end

function Jinx:Tick()
	if myHero.dead then return end
	
	self.RocketRange = 25 * GetCastLevel(myHero,_Q) + 600
	
	
	GetReady()
		
	self:KS()
		
	local target = GetCurrentTarget()
		
	if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "LastHit" then
		self:LastHit()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Jinx:Combo(target)
	
	if BM.C.Q.QL:Value() == 1 and BM.C.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and EnemiesAround(target, 150) > 2 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end
		
	elseif BM.C.Q.QL:Value() == 2 and BM.C.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end		
	end
	
	if SReady[1] and ValidTarget(target, self.Spell[1].range) and BM.C.W:Value() and GetDistance(myHero,target)>100 then
		local Pred = GetPrediction(target, self.Spell[1])
		if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
			CastSkillShot(1,Pred.castPos)
		end
	end
	
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	
end

function Jinx:Harass(target)
	
	if BM.H.Q.QL:Value() == 1 and BM.H.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and EnemiesAround(target, 150) > 2 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end
		
	elseif BM.C.Q.QL:Value() == 2 and BM.H.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end		
	end
	
	if SReady[1] and ValidTarget(target, self.Spell[1].range) and BM.H.W:Value() and GetDistance(myHero,target)>100 then
		local Pred = GetPrediction(target, self.Spell[1])
		if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
			CastSkillShot(1,Pred.castPos)
		end
	end
	
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	
end

function Jinx:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			
			if BM.LC.Q.QL:Value() == 1 and BM.LC.Q.enable:Value() then	
			
				if SReady[0] and ValidTarget(minion, self.RocketRange) and not minigun then
					CastSpell(0)
				end
		
			elseif BM.LC.Q.QL:Value() == 2 and BM.LC.Q.enable:Value() then
	
				if SReady[0] and ValidTarget(minion, self.RocketRange) and minigun then
					CastSpell(0)
				end	
			end
			
			if SReady[1] and ValidTarget(minion, self.Spell[1].range) and BM.LC.W:Value() then
				local Pred = GetPrediction(minion, self.Spell[1])
				if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
					CastSkillShot(1,Pred.castPos)
				end
			end
		end
	end
end

function Jinx:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			
			if BM.JC.Q.QL:Value() == 1 and BM.JC.Q.enable:Value() then	
			
				if SReady[0] and ValidTarget(mob, self.RocketRange) and not minigun then
					CastSpell(0)
				end
		
			elseif BM.JC.Q.QL:Value() == 2 and BM.JC.Q.enable:Value() then
	
				if SReady[0] and ValidTarget(mob, self.RocketRange) and minigun then
					CastSpell(0)
				end	
			end
			
			if SReady[1] and ValidTarget(mob, self.Spell[1].range) and BM.LC.W:Value() then
				local Pred = GetPrediction(mob, self.Spell[1])
				if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
					CastSkillShot(1,Pred.castPos)
				end
			end
		end
	end
end

function Jinx:LastHit()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if BM.LH.UMinig:Value() and ValidTarget(minion, self.RocketRange) and not minigun and SReady[0] then
				CastSpell(0)
			end
		end
	end
end

function Jinx:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetADHP(unit) < Dmg[1](unit) and SReady[1] and ValidTarget(unit, self.Spell[1].range) and BM.KS.W:Value() then
			local Pred = GetPrediction(unit, self.Spell[1])
			if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
				CastSkillShot(1,Pred.castPos)
			end
		end
		if GetAPHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, self.Spell[2].range) and BM.KS.E:Value() then
			local Pred = GetPrediction(unit, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
		if GetADHP(unit) < Dmg[3](unit) and SReady[3] and ValidTarget(unit, BM.KS.mDTT:Value()) and BM.KS.R:Value() and GetDistance(unit) >= BM.KS.DTT:Value() then
			local Pred = GetPrediction(unit, self.Spell[3])
			if Pred.hitChance >= BM.p.hR:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[3].range and not Pred:hCollision(1) then
				CastSkillShot(3,Pred.castPos)
			end
		end
	end
end

 -- _  __     _ _     _        
 --| |/ /__ _| (_)___| |_ __ _ 
 --| ' // _` | | / __| __/ _` |
 --| . \ (_| | | \__ \ || (_| |
 --|_|\_\__,_|_|_|___/\__\__,_|
                             

class 'Kalista'

function Kalista:__init()


	self.eTrack = {}
	self.soul = nil
	
	for _,i in pairs(GetAllyHeroes()) do
		if GotBuff(i, "kalistacoopstrikeally") == 1 then
			soul = i
		end
	end

	
	Kalista.Spell = {
	[-1] = { delay = .3, speed = math.huge, width = 1, range = 1500},
	[0] = { delay = 0.25, speed = 2000, width = 50, range = 1150},
	[1] = { range = 5000 },
	[2] = { range = 1000 },
	[3] = { range = 1500 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 60 * GetCastLevel(myHero,0) - 50 + GetBonusDmg(myHero), 0) end, 
	[2] = function (unit) if not unit then return end return CalcDamage(myHero, unit, (10 * GetCastLevel(myHero,2) + 10 + (GetBonusDmg(myHero)+GetBaseDamage(myHero)) * .6) + ((self.eTrack[GetNetworkID(unit)] or 0)-1) * (({10,14,19,25,32})[GetCastLevel(myHero,2)] + (GetBaseDamage(myHero)+GetBaseDamage(myHero))*({0.2,0.225,0.25,0.275,0.3})[GetCastLevel(myHero,2)]), 0) end,
	}
	
	self.EpicJgl = nil
	self.BigJgl = nil
	self.dragon = nil
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", false)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", false)
	
	BM:Menu("AE", "Auto E")
	BM.AE:Menu("MobOpt", "Mob Option")
	BM.AE.MobOpt:Boolean("UseB", "Use on Big Mobs", true)
	BM.AE.MobOpt:Boolean("UseE", "Use on Epic Mobs", true)
	BM.AE.MobOpt:Boolean("UseM", "Use on Minions", true)
	BM.AE.MobOpt:Boolean("UseMode", "Use only in Laneclear mode",false)
	BM.AE:Slider("xM", "Kill X Minions", 2, 1, 7, 1)	
	BM.AE:Boolean("UseC", "Use on Champs", true)
	BM.AE:Boolean("UseBD", "Use before death", true)
	BM.AE:Boolean("UseL", "Use if leaves range", false)
	BM.AE:Slider("OK", "Over kill", 10, 0, 50, 5)
	BM.AE:Slider("D", "Delay to use E", 10, 0, 50, 5)	
	
	BM:Menu("AR", "Auto R")
	BM.AR:Boolean("enable", "Enable Auto R")
	BM.AR:Slider("allyHP", "allyHP <= X", 5, 1, 100, 5)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	
	BM:Menu("WJ", "WallJump")
	BM.WJ:KeyBinding("J", "Wall Jump", string.byte("G"))
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)

	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("UpdateBuff", function(unit, buff) self:UpdateBuff(unit, buff) end)
	Callback.Add("RemoveBuff", function(unit, buff) self:RemoveBuff(unit, buff) end)
	Callback.Add("ProcessSpellComplete", function(unit, spell) self:AAReset(unit, spell) end)

end

function Kalista:UpdateBuff(unit, buff) 
	if unit ~= myHero and buff.Name:lower() == "kalistaexpungemarker" and (unit.type==Obj_AI_Hero or unit.type==Obj_AI_Minion or unit.type==Obj_AI_Camp) then
		self.eTrack[GetNetworkID(unit)]=buff.Count 
	elseif buff.Name:lower() == "kalistacoopstrikeally" and GetTeam(unit) == MINION_ALLY then
		soul = unit
	end
end

function Kalista:RemoveBuff(unit, buff) 
	if unit ~= myHero and buff.Name:lower() == "kalistaexpungemarker" and (unit.type==Obj_AI_Hero or unit.type==Obj_AI_Minion or unit.type==Obj_AI_Camp) then
		self.eTrack[GetObjectName(unit)]=0 
	elseif buff.Name:lower() == "kalistacoopstrikeally" and GetTeam(unit) == MINION_ALLY then
		soul = nil
	end
end

function Kalista:Tick()
	for _,i in pairs(minionManager.objects) do
		if i.charName:lower():find("sru_dragon") then
			self.dragon = i.charName
		end
	end
	if not self.dragon then
		self.EpicJgl = {["SRU_Baron"]=true, ["TT_Spiderboss"]=true}
		self.BigJgl = {["SRU_Baron"]=true, ["SRU_Red"]=true, ["SRU_Blue"]=true, ["SRU_Krug"]=true, ["SRU_Murkwolf"]=true, ["SRU_Razorbeak"]=true, ["SRU_Gromp"]=true, ["Sru_Crab"]=true, ["TT_Spiderboss"]=true}
	else
		self.EpicJgl = {["SRU_Baron"]=true, [self.dragon]=true,["TT_Spiderboss"]=true}
		self.BigJgl = {["SRU_Baron"]=true, [self.dragon]=true, ["SRU_Red"]=true, ["SRU_Blue"]=true, ["SRU_Krug"]=true, ["SRU_Murkwolf"]=true, ["SRU_Razorbeak"]=true, ["SRU_Gromp"]=true, ["Sru_Crab"]=true, ["TT_Spiderboss"]=true}
	end
	if myHero.dead then return end
	
	GetReady()
	self:KS()
	self:AutoR()
	self:WallJump()
		
	local target = GetCurrentTarget()
	
	if Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	else
		return
	end
end

function Kalista:AutoR()
	if soul and BM.AR.enable:Value() and GetPercentHP(soul) <= BM.AR.allyHP:Value() and EnemiesAround(GetOrigin(soul), 1000) >= 1 then
		CastSpell(3)
	end
end

function Kalista:AAReset(unit, spell)
	local ta = spell.target
	if unit == myHero and ta ~= nil and spell.name:lower():find("attack") and SReady[0] and ValidTarget(ta, self.Spell[0].range) then
		if ((Mode == "Combo" and BM.C.Q:Value()) or (Mode == "Harass" and BM.H.Q:Value()) and GetObjectType(ta) == Obj_AI_Hero) or (Mode == "LaneClear" and ((BM.JC.Q:Value() and (GetObjectType(ta)==Obj_AI_Camp or GetObjectType(ta)==Obj_AI_Minion)) or (BM.LC.Q:Value() and GetObjectType(ta)==Obj_AI_Minion))) then
			local Pred = GetPrediction(ta, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
	end
end

function Kalista:JungleClear()

end

function Kalista:LaneClear()

end

function Kalista:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetADHP(target) < Dmg[0](target) then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[2] and ValidTarget(target, 1000) and BM.AE.UseC:Value() and (GetADHP(target) + BM.AE.OK:Value()) < Dmg[2](target) and self.eTrack[GetNetworkID(target)] > 0 then
			DelayAction(function()
				CastSpell(2)
			end, BM.AE.D:Value()*.01)
		end
		if SReady[2] and ValidTarget(target, 1100) and BM.AE.UseL:Value() and self.eTrack[GetNetworkID(target)] then
			local Pred = GetPrediction(target,self.Spell[-1])
			if GetDistance(Pred.castPos,GetOrigin(myHero))>999 then
				CastSpell(2)
			end
		end
	end
	
	if not BM.AE.MobOpt.UseMode:Value() or Mode == "LaneClear" then
		for _,mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_JUNGLE then
				if SReady[2] and ValidTarget(mob, 750) and Dmg[2](mob) > GetCurrentHP(mob) then
					if BM.AE.MobOpt.UseE:Value() and self.EpicJgl[GetObjectName(mob)] then
						CastSpell(2)
					elseif BM.AE.MobOpt.UseB:Value() and self.BigJgl[GetObjectName(mob)] then
						CastSpell(2)
					end
				end
			end
		end
		
		self.km = 0
		for _,minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if Dmg[2](minion) > GetCurrentHP(minion) and ValidTarget(minion, 1000) and BM.AE.MobOpt.UseM:Value() then
					self.km = self.km + 1
				end
			end
		end
		if self.km >= BM.AE.xM:Value() then
			CastSpell(2)
		end
	end
	if BM.AE.UseBD:Value() and GetPercentHP(myHero)<=2 and SReady[2] then
		CastSpell(2)
	end
end

function Kalista:WallJump()
	if SReady[0] and BM.WJ.J:Value() and GetDistance(GetMousePos(),GetOrigin(myHero))<1500 then
		local mou = GetMousePos()
		local wallEnd = nil
		local wallStart = nil
		if not MapPosition:inWall(mou) then
			--DrawLine(WorldToScreen(0, GetOrigin(myHero)).x, WorldToScreen(0, GetOrigin(myHero)).y, WorldToScreen(0, mou).x, WorldToScreen(0, mou).y, 3, GoS.White)
			local dV = Vector(GetOrigin(myHero))-Vector(mou)
			for i = 1, dV:len(), 5 do
				if MapPosition:inWall(mou+dV:normalized()*i) and not wallEnd then
					wallEnd = Vector(mou+dV:normalized()*i)
				elseif wallEnd and not MapPosition:inWall(Vector(mou+dV:normalized()*i)) then
					wallStart = Vector(mou+dV:normalized()*i)
					DrawCircle(wallStart,50,0,3,GoS.White)
					break
				end
			end
			if wallEnd and wallStart then
				local WS = WorldToScreen(0,wallStart)
				local WE = WorldToScreen(0,wallEnd)
				if Vector(wallEnd-wallStart):len() < 290 then
					DrawLine(WS.x,WS.y,WE.x,WE.y,3,GoS.Green)
					MoveToXYZ(wallStart)
				else
					DrawLine(WS.x,WS.y,WE.x,WE.y,3,GoS.Red)
					DrawCircle(wallEnd,50,0,3,GoS.White)
					DrawCircle(wallStart,50,0,3,GoS.White)
				end
				if GetDistance(GetOrigin(myHero),wallEnd) < 290 then
					CastSkillShot(0,wallEnd)
					DelayAction(function()
						MoveToXYZ(mou)
					end, .001)
				end
			end
		end
	end
end

--  _   _                     
-- | \ | | __ _ ___ _   _ ___ 
-- |  \| |/ _` / __| | | / __|
-- | |\  | (_| \__ \ |_| \__ \
-- |_| \_|\__,_|___/\__,_|___/
--                            


class 'Nasus'

function Nasus:__init()
	
	Dmg = {
		[0] = function (unit) return CalcDamage(myHero, unit, self.qDmg, 0) end,
		[2] = function (unit) return CalcDamage(myHero, unit, 0, 40 * GetCastLevel(myHero,2) + 15 + GetBonusAP(myHero) * .6) end,
		[3] = function (unit) return CalcDamage(myHero, unit, 0, math.min((.02 * GetCastLevel(myHero,3) + .01) * GetMaxHP(unit)),240) end,
	}


	Nasus.Spell = {
		[0] = { delay = 0.3, range = 250},
		[1] = { delay = .2, range = 600 },
		[2] = { delay = .1, speed = math.huge, range = 650, radius = 395},
		[3] = { range = 200 }
	}
	
	BM:SubMenu("c", "Combo")
	BM.c:Boolean("Q", "Use Q", true)
	BM.c:Boolean("QP", "Use HP Pred for Q", true)
	BM.c:Slider("QDM", "Q DMG mod", 0, -10, 10, 1)
	BM.c:Boolean("W", "Use W", true)
	BM.c:Slider("WHP", "Use W at %HP", 20, 1, 100, 1)
	BM.c:Boolean("E", "Use E", true)
	BM.c:Boolean("R", "Use R", true)
	BM.c:Slider("RHP", "Use R at %HP", 20, 1, 100, 1)

	BM:SubMenu("f", "Farm")
	BM.f:DropDown("QM", "Auto Q in" ,1 , {"Always" , "Laneclear", "LastHit"})
	BM.f:Boolean("dQ", "Draw Q on creeps", true)
	
	BM:SubMenu("ks", "Killsteal")
	BM.ks:Boolean("KSQ","Killsteal with Q", true)
	BM.ks:Boolean("KSE","Killsteal with E", true)


--Var
	self.qDmg = 0
	self.Stacks = GetBuffData(myHero, "NasusQStacks").Stacks
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

-- Start
function Nasus:Tick()
	if myHero.dead then return end
	
		
	GetReady()
	self.qDmg = self:getQdmg()
	self:KS()
	self:Farm()
	local target = GetCurrentTarget()


    if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
	--	self:LaneClear()
	--	self:JungleClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Nasus:Draw()
	if myHero.dead or not BM.f.dQ:Value() then return end
	for _, creep in pairs(minionManager.objects) do
		--if Nasus:ValidCreep(creep,1000) then DrawText(math.floor(CalcDamage(myHero,creep,self.qDmg,0)),10,WorldToScreen(0,GetOrigin(creep)).x,WorldToScreen(0,GetOrigin(creep)).y,GoS.White) end
		if Nasus:ValidCreep(creep,1000) and GetCurrentHP(creep)<CalcDamage(myHero,creep,self.qDmg,0) then
			DrawCircle(GetOrigin(creep),50,0,3,GoS.Red)
		end
	end
end



function Nasus:Combo(unit)
	if BM.c.Q:Value() and SReady[0] and ValidTarget(unit, self.Spell[0].range) then
		CastSpell(0)
		AttackUnit(unit)
	end
	if SReady[1] and BM.c.W:Value() and ValidTarget(unit, self.Spell[1].range) and GetPercentHP(unit) < BM.c.WHP:Value() then
		CastTargetSpell(unit,1)
	end		
	if SReady[2] and BM.c.E:Value() and ValidTarget(unit, self.Spell[2].range) then
		local EPred=GetCircularAOEPrediction(unit, self.Spell[2])
		if EPred and EPred.hitChance >= 0.2 then
			CastSkillShot(2,EPred.castPos)
		end
	end				
end

function Nasus:Farm()
	local mod = BM.f.QM:Value()
	if (SReady[0] or CanUseSpell(myHero,0) == 8) and ((mod == 2 and Mode == "LaneClear") or (mod == 3 and Mode == "LastHit") or (mod == 1 and Mode ~= "Combo")) then
		for _, creep in pairs(minionManager.objects) do
			if Nasus:ValidCreep(creep, self.Spell[0].range) and GetCurrentHP(creep)<self.qDmg*2 and ((GetHealthPrediction(creep, GetWindUp(myHero))<CalcDamage(myHero, creep, self.qDmg, 0) and BM.c.QP:Value()) or (GetCurrentHP(creep)<CalcDamage(myHero, creep, self.qDmg, 0) and not BM.c.QP:Value())) then
				CastSpell(0)
				AttackUnit(creep)
				break
			end
		end
	end
end

function Nasus:KS()
	if SReady[3] and BM.c.R:Value() and ValidTarget(unit, 1075) and GetPercentHP(myHero) < BM.c.RHP:Value() then
		CastSpell(3)
	end
	for i,unit in pairs(GetEnemyHeroes()) do
		if BM.ks.KSQ:Value() and Ready(0) and ValidTarget(unit, self.Spell[0].range) and GetCurrentHP(unit)+GetDmgShield(unit)+GetMagicShield(unit) < CalcDamage(myHero, unit, self.qDmg, 0) then
			CastSpell(0)
			AttackUnit(unit)
		end
		if BM.ks.KSE:Value() and Ready(_E) and ValidTarget(unit,self.Spell[2].range) and GetCurrentHP(unit)+GetDmgShield(unit)+GetMagicShield(unit) <  CalcDamage(myHero, unit, 0, 15+40*GetCastLevel(myHero,_E)+GetBonusAP(myHero)*6) then 
			local NasusE=GetCircularAOEPrediction(unit, self.Spell[2])
			if EPred and EPred.hitChance >= .2 then
				CastSkillShot(_E,EPred.castPos)
			end
		end
	end
end

function Nasus:getQdmg()
	local base = 10 + 20*GetCastLevel(myHero,0) + GetBaseDamage(myHero) + GetBuffData(myHero, "NasusQStacks").Stacks + BM.c.QDM:Value()
	if 		(Ready(GetItemSlot(myHero,3078))) and GetItemSlot(myHero,3078)>0 then base = base + GetBaseDamage(myHero)*2 
	elseif 	(Ready(GetItemSlot(myHero,3057))) and GetItemSlot(myHero,3057)>0 then base = base + GetBaseDamage(myHero)
	elseif 	(Ready(GetItemSlot(myHero,3057))) and GetItemSlot(myHero,3025)>0 then base = base + GetBaseDamage(myHero)*1.25 
	end
	return base
end


function Nasus:ValidCreep(creep, range)
	if creep and not IsDead(creep) and GetTeam(creep) ~= MINION_ALLY and IsTargetable(creep) and GetDistance(GetOrigin(myHero), GetOrigin(creep)) < range then
		return true
	else 
		return false
	end
end



-- _  ___           _              _ 
--| |/ (_)_ __   __| |_ __ ___  __| |
--| ' /| | '_ \ / _` | '__/ _ \/ _` |
--| . \| | | | | (_| | | |  __/ (_| |
--|_|\_\_|_| |_|\__,_|_|  \___|\__,_|
--  

class "Kindred"

function Kindred:__init()
	self.Spells = {
	[0] = {range = 500, dash = 340, mana = 35},
	[1] = {range = 800, duration = 8, mana = 40},
	[2] = {range = 500, mana = 70, mana = 70},
	[3] = {range = 400, range2 = 500, mana = 100},
	}
	Dmg = 
	{
	[0] = function(Unit) return CalcDamage(myHero, Unit, 30+30*GetCastLevel(myHero, 0)+(GetBaseDamage(myHero) + GetBonusDmg(myHero))*0.20) end,
	[1] = function(Unit) return CalcDamage(myHero, Unit, 20+5*GetCastLevel(myHero, 1)+0.40*(GetBaseDamage(myHero) + GetBonusDmg(myHero))+0.40*self:PassiveDmg(Unit)) end,
	[2] = function(Unit) 	if GetTeam(Unit) == MINION_JUNGLE then
					return CalcDamage(myHero, Unit, math.max(300,30+30*GetCastLevel(myHero, 2)+(GetBaseDamage(myHero) + GetBonusDmg(myHero))*0.20+GetMaxHP(Unit)*0.05))
				else 
					return CalcDamage(myHero, Unit, 30+30*GetCastLevel(myHero, 2)+(GetBaseDamage(myHero) + GetBonusDmg(myHero))*0.20+GetMaxHP(Unit)*0.05)
				end
		  end,
	}
	self.BaseAS = GetBaseAttackSpeed(myHero)
	self.AAPS = self.BaseAS*GetAttackSpeed(myHero)
	self.WolfAA = self.Spells[1].duration*self.AAPS
	basePos = Vector(0,0,0)
	if GetTeam(myHero) == 100 then
		basePos = Vector(415,182,415)
	else
		basePos = Vector(14302,172,14387.8)
	end
	self.Recalling = false
	self.Farsight = false
	self.Passive = 0
	OnTick(function(myHero) self:Tick() end)
	OnProcessSpellComplete(function(unit, spell) self:OnProcComplete(unit, spell) end)
	OnProcessSpell(function(unit, spell) self:OnProc(unit, spell) end)
	Flash = (GetCastName(myHero, SUMMONER_1):lower():find("summonerflash") and SUMMONER_1 or (GetCastName(myHero, SUMMONER_2):lower():find("summonerflash") and SUMMONER_2 or nil)) -- Ty Platy
	self.target = nil

	BM:Menu("Combo", "Combo")
	BM.Combo:Boolean("Q", "Use Q", true)
	BM.Combo:Boolean("W", "Use W", true)
	BM.Combo:Boolean("E", "Use E", true)
	BM.Combo:Boolean("QE", "Gapcloser", true)

	BM:Menu("JunglerClear", "JunglerClear")
	BM.JunglerClear:Boolean("Q", "Use Q", true)
	BM.JunglerClear:Boolean("W", "Use W", true)
	BM.JunglerClear:Boolean("E", "Use E", true)
	BM.JunglerClear:Slider("MM", "Mana manager", 50, 1, 100)

	BM:Menu("LaneClear", "LaneClear")
	BM.LaneClear:Boolean("Q", "Use Q", true)
	BM.LaneClear:Boolean("W", "Use W", true)
	BM.LaneClear:Boolean("E", "Use E", true)
	BM.LaneClear:Slider("MM", "Mana manager", 50, 1, 100)

	BM:Menu("Misc", "Misc")
	BM.Misc:Boolean("B", "Buy Farsight", true)
	BM.Misc:KeyBinding("FQ", "Flash-Q", string.byte("T"))
	BM.Misc:Key("WP", "Jumps", string.byte("G"))

	BM:Menu("ROptions", "R Options")
	BM.ROptions:Boolean("R", "Use R?", true)
	BM.ROptions:Slider("EA", "Enemies around", 3, 1, 5)
	BM.ROptions:Boolean("RU", "Use R on urself", true)

	BM:Menu("QOptions", "Q Options")
	BM.QOptions:Boolean("QC", "AA reset Combo", true)
	BM.QOptions:Boolean("QL", "AA reset LaneClear", true)
	BM.QOptions:Boolean("QJ", "AA reset JunglerClear", true)
	BM.QOptions:Boolean("C", "Cancel animation?", false)

	DelayAction(function()
		for i, allies in pairs(GetAllyHeroes()) do
			BM.ROptions:Boolean("Pleb"..GetObjectName(allies), "Use R on "..GetObjectName(allies), true)
		end
	end, 0.001)
end

function Kindred:Tick()
	if not IsDead(myHero) then
	
		GetReady()
		self.target = GetCurrentTarget()

		if Mode == "Combo" then
			self:Combo(self.target)
		elseif Mode == "LaneClear" then
			self:LaneClear()
		end

		self:AutoR()
		if BM.Misc.FQ:Value() then
			if SReady[0] and Ready(Flash) and BM.Combo.Q:Value() then  
				CastSkillShot(Flash, GetMousePos()) 
					DelayAction(function() CastSkillShot(0, GetMousePos()) end, 1)					  
			end
		end
		if BM.Misc.WP:Value() then
			if self:WallBetween(GetOrigin(myHero), GetMousePos(),  self.Spells[0].dash) and SReady[0] then
				CastSkillShot(0, GetMousePos())
			end
		end
		self.Passive = GetBuffData(myHero,"kindredmarkofthekindredstackcounter").Stacks
		if BM.Misc.B:Value() then
			if not self.Farsight and GetLevel(myHero) >= 9 and GetDistance(myHero,basePos) < 550 then
				BuyItem(3363)
				self.Farsight = true
			end
		end
	end
end

function Kindred:Combo(Unit)
local AfterQ = GetOrigin(myHero) +(Vector(GetMousePos()) - GetOrigin(myHero)):normalized()*self.Spells[0].dash

	if SReady[2] and SReady[0] and BM.Combo.QE:Value() and GetDistance(Unit) > self.Spells[0].range and GetDistance(AfterQ, Unit) <= 450 then
		CastSkillShot(0, GetMousePos())
			DelayAction(function() CastTargetSpell(Unit, 2) end, 1)
	end
	if SReady[0] and BM.Combo.Q:Value() and ValidTarget(Unit, self.Spells[0].range) and BM.QOptions.QC:Value() == false or (GetDistance(Unit) > self.Spells[0].range and GetDistance(AfterQ, Unit) <= 450)  then
    	CastSkillShot(0, GetMousePos()) 
	end
	if SReady[1] and BM.Combo.W:Value() and ValidTarget(Unit, self.Spells[1].range) then 
		CastSpell(1)
	end
	if SReady[2] and BM.Combo.E:Value() and ValidTarget(Unit, self.Spells[2].range) then 
		CastTargetSpell(Unit, 2)
	end
end

function Kindred:LaneClear()
	local QMana = (self.Spells[0].mana*100)/GetMaxMana(myHero)
	local WMana = (self.Spells[1].mana*100)/GetMaxMana(myHero)
	local EMana = (self.Spells[2].mana*100)/GetMaxMana(myHero)
	for _, mob in pairs(minionManager.objects) do	
		if GetTeam(mob) == MINION_JUNGLE then
			if BM.QOptions.QJ:Value() == false and SReady[0] and BM.JunglerClear.Q:Value() and ValidTarget(mob, self.Spells[0].range) and GetCurrentHP(mob) >= Dmg[0](mob) --[[and (GetPercentMP(myHero)- QMana) >= BM.JunglerClear.MM:Value()]] then 
				CastSkillShot(0, GetMousePos())
			end
			if SReady[1] and ValidTarget(mob, self.Spells[1].range) and IsTargetable(mob) and BM.JunglerClear.W:Value() and (GetPercentMP(myHero)- WMana) >= BM.JunglerClear.MM:Value() and self:TotalHp(self.Spells[1].range, myHero) >= Dmg[1](mob) + ((8/self.AAPS)*CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero)+self:PassiveDmg(mob))) then
   				CastSpell(1)
    		end
    		if SReady[2] and ValidTarget(mob, self.Spells[2].range) and BM.JunglerClear.E:Value() and (GetPercentMP(myHero)- EMana) >= BM.JunglerClear.MM:Value() and GetCurrentHP(mob) >= Dmg[2](mob) + (CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero))*3) then 
   				CastTargetSpell(mob, 2)
   			end
  	 	end
		if GetTeam(mob) == MINION_ENEMY then
			if BM.QOptions.QL:Value() == false and SReady[0] and BM.LaneClear.Q:Value() and (GetPercentMP(myHero)- QMana) >= BM.LaneClear.MM:Value() and ValidTarget(mob, self.Spells[0].range) and GetCurrentHP(mob) >= Dmg[0](mob) then 
				CastSkillShot(0, GetMousePos())
			end
			if SReady[1] and ValidTarget(mob, self.Spells[1].range) and BM.LaneClear.W:Value() and (GetPercentMP(myHero)- WMana) >= BM.LaneClear.MM:Value() and self:TotalHp(self.Spells[1].range, myHero) >= Dmg[1](mob) + ((8/self.AAPS)*CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero)+self:PassiveDmg(mob))) then 
				CastSpell(1)
			end
			if SReady[2] and ValidTarget(mob, self.Spells[2].range) and BM.LaneClear.E:Value() and (GetPercentMP(myHero)- EMana) >= BM.LaneClear.MM:Value() and GetCurrentHP(mob) >= Dmg[2](mob) + (CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero))*3) then 
				CastTargetSpell(mob, 2)
			end
		end
	end
end

function Kindred:AutoR()
	if BM.ROptions.R:Value() and not self.Recalling and not IsDead(myHero) and SReady[3] then
		for i, allies in pairs(GetAllyHeroes()) do
			if GetPercentHP(allies) <= 20 and BM.ROptions["Pleb"..GetObjectName(allies)] and not IsDead(allies) and GetDistance(allies) <= self.Spells[3].range2 and EnemiesAround(allies, 1500) >= BM.ROptions.EA:Value() then
				CastTargetSpell(myHero, 3)
			end
		end
		if GetPercentHP(myHero) <= 20 and BM.ROptions.RU:Value() and EnemiesAround(myHero, 1500) >= BM.ROptions.EA:Value() then
			CastTargetSpell(myHero, 3)
		end
	end
end

function Kindred:OnProcComplete(unit, spell)
	local QMana = (self.Spells[0].mana*100)/GetMaxMana(myHero)
	if unit == myHero then
		if spell.name:lower():find("attack") then
			if Mode == "LaneClear" then 
				for _, mob in pairs(minionManager.objects) do	
					if BM.QOptions.QL:Value() and ValidTarget(mob, 500) and GetTeam(mob) == MINION_ENEMY and BM.LaneClear.Q:Value() and (GetPercentMP(myHero)- QMana) >= BM.LaneClear.MM:Value() and SReady[0] then
						CastSkillShot(0, GetMousePos())
					end
					if BM.QOptions.QJ:Value() and ValidTarget(mob, 500) and GetTeam(mob) == MINION_JUNGLE and BM.JunglerClear.Q:Value() and (GetPercentMP(myHero)- QMana) >= BM.JunglerClear.MM:Value() and SReady[0] then
						CastSkillShot(0, GetMousePos()) 
					end
				end
			elseif Mode == "Combo" then
				if BM.QOptions.QC:Value() and SReady[0] and BM.Combo.Q:Value() and ValidTarget(self.target, 500) then
    				CastSkillShot(0, GetMousePos()) 
				end
			end
		end
	end
end

function Kindred:OnProc(unit, spell)
	if unit == myHero and spell.name == "KindredQ" and BM.QOptions.C:Value() then
		DelayAction(function() CastEmote(EMOTE_DANCE) end, .001)
	end
end

function Kindred:OnUpdate(unit, buff)
	if unit == myHero then
		if buff.Name == "recall" or buff.Name == "OdinRecall" then
			self.Recalling = true
		end
		--[[if buff.Name == "kindredmarkofthekindredstackcounter" then
			self.Passive = self.Passive + buff.Stacks
		end]]
	end
end

function Kindred:OnRemove(unit, buff)
	if unit == myHero and buff.Name == "recall" or buff.Name == "OdinRecall" then
		self.Recalling = false
	end
end

function Kindred:PassiveDmg(unit)
	if self.Passive ~= 0 then
		local PassiveDmg = self.Passive * 1.25
		if GetTeam(unit) == MINION_JUNGLE then
			return CalcDamage(myHero, unit, math.max(75+10*self.Passive, GetCurrentHP(unit)*(PassiveDmg/100)))
		else
			return CalcDamage(myHero, unit, GetCurrentHP(unit)*(PassiveDmg/100))
		end
	else return 0
	end
end

function Kindred:TotalHp(range, pos)
	local hp = 0
	for _, mob in pairs(minionManager.objects) do
		if not IsDead(mob) and IsTargetable(mob) and (GetTeam(mob) == MINION_JUNGLE or GetTeam(mob) == MINION_ENEMY) and GetDistance(mob, pos) <= range then
			hp = hp + GetCurrentHP(mob)
		end
	end
	return hp
end

function Kindred:WallBetween(p1, p2, distance) --p1 and p2 are Vectors3d

	local Check = p1 + (Vector(p2) - p1):normalized()*distance/2
	local Checkdistance = p1 +(Vector(p2) - p1):normalized()*distance
	
	if MapPosition:inWall(Check) and not MapPosition:inWall(Checkdistance) then
		return true
	end
end


class 'Vladimir'

function Vladimir:__init()
	
	Vladimir.Spell = {
	[0] = { range = 600 },
	[1] = { range = 150 },
	[2] = { range = 600 },
	[3] = { delay = 0.25, speed = math.huge, range = 700, radius = 175},
	}
	
	Dmg = {
	[0] = function(unit) return CalcDamage(myHero, unit, 0, 15 * GetCastLevel(myHero,0) + 60 + GetBonusAP(myHero) * .55)*(GetCurrentMana(myHero)<2 and 1 or 2) end,
	[2] = function(unit) return CalcDamage(myHero, unit, 0, 15 * GetCastLevel(myHero,2) + 15 + GetBonusAP(myHero) * 0.35 + GetMaxHP(myHero)*.025) end,
	[3] = function(unit) return CalcDamage(myHero, unit, 0, 100 * GetCastLevel(myHero,3) + 50 + GetBonusAP(myHero) * .7) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Boolean("REA", "Use if R will hit > x enemies", 2, 1, 5, 1)
	BM.C:Boolean("DP", "Draw exact Passive", true)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	BM.KS:Boolean("E", "Use E", true)
	BM.KS:Boolean("R", "Use R", false)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hR", "HitChance R", 40, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
	Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
	HitMe()
	
	self.ECharge = nil
	self.AA = AttackUnit
end

function Vladimir:HitMe(k,pos,dt,ty)
 DelayAction( function() 
  CastSpell(1)
 end,dt)
end

function Vladimir:Draw()
	if not myHero.dead and BM.C.DP:Value() then 
		DrawText(math.round(GetCurrentMana(myHero),2),20,myHero.pos2D.x,myHero.pos2D.y,GoS.White)
	end
end

function Vladimir:Tick()
	if myHero.dead then return end

	GetReady()
	
	self:KS()
	
	local target = GetCurrentTarget()

	if self.ECharge and GetGameTimer() - self.ECharge > 1 then
		CastSkillShot2(2,myHero.pos)
	end

    if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Vladimir:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		CastTargetSpell(target,0)
	end
	if (SReady[2] or (self.ECharge and GetGameTimer() - self.ECharge < 1)) and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		CastSkillShot(2,myHero.pos)
	end
	if SReady[3] and ValidTarget(target, self.Spell[3].range) and BM.C.R:Value() and EnemiesAround(GetOrigin(target), self.Spell[3].radius) >= BM.C.REA:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[3])
		if Pred.hitChance >= BM.p.hR:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[3].range then
			CastSkillShot(3,Pred.castPos)
		end
	end
end

function Vladimir:Harass(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.H.Q:Value() then
		CastTargetSpell(target,0)
	end
	if (SReady[2] or (self.ECharge and GetGameTimer() - self.ECharge < 1)) and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
		CastSkillShot(2,myHero.pos)
	end
end

function Vladimir:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range) and BM.LC.Q:Value() then
				CastTargetSpell(minion,0)
			end
			if (SReady[2] or (self.ECharge and GetGameTimer() - self.ECharge < 1)) and ValidTarget(minion, self.Spell[2].range) and BM.LC.E:Value() then
				CastSkillShot(2,myHero.pos)
			end
		end
	end
end

function Vladimir:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
				CastTargetSpell(mob,0)
			end
			if (SReady[2] or (self.ECharge and GetGameTimer() - self.ECharge < 1)) and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() then
				CastSkillShot(2,myHero.pos)
			end
		end
	end
end

function Vladimir:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetAPHP(target) < Dmg[0](target) then
			CastTargetSpell(target,0)
		end
		if (SReady[2] or (self.ECharge and GetGameTimer() - self.ECharge < 1)) and ValidTarget(target, self.Spell[2].range) and BM.KS.E:Value() and GetAPHP(target) < Dmg[2](target) then
			CastSkillShot(2,myHero.pos)
		end
		if SReady[3] and ValidTarget(target, self.Spell[3].range) and BM.KS.R:Value() and GetAPHP(target) < Dmg[3](target) then
			local Pred = GetCircularAOEPrediction(target, self.Spell[3])
			if Pred.hitChance >= BM.p.hR:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[3].range then
				CastSkillShot(3,Pred.castPos)
			end
		end
	end
end

function Vladimir:UpdateBuff(unit,buff)
	if unit.isMe and buff.Name == "VladimirE" then 
		self.ECharge = GetGameTimer()
		AttackUnit = function () end
	elseif unit.isMe and buff.Name == "VladimirSanguinePool" then
		AttackUnit = function () end
	end
end

function Vladimir:RemoveBuff(unit,buff)
	if unit.isMe and buff.Name == "VladimirE" then 
		self.ECharge = nil
		AttackUnit = self.AA
	elseif unit.isMe and buff.Name == "VladimirSanguinePool" then
		AttackUnit = self.AA
	end
end

---------------------------------------------------------------------------------------------
-------------------------------------UTILITY-------------------------------------------------
---------------------------------------------------------------------------------------------

--DamageDraw (Paint.lua)
class 'DmgDraw'

function DmgDraw:__init()

	self.dmgSpell = {}
	self.spellName= {"Q","W","E","R"} 
	self.dC = { {200,255,255,0}, {200,0,255,0}, {200,255,0,0}, {200,0,0,255} }
	self.aa = {}
	self.dCheck = {}
	self.dX = {}
	self.Own = nil

	SLS:SubMenu("D","|SL| Draw Damage")
	SLS.D:Boolean("dAA","Count AA to kill", true)
	SLS.D:Boolean("dAAc","Consider Crit", true)
	SLS.D:Slider("dR","Draw Range", 1500, 500, 3000, 100)
	
	if SLSChamps[ChampName] then
		self.Own = true
		for i=1,4,1 do
			if Dmg[i-1] then
				SLS.D:Boolean(self.spellName[i], "Draw "..self.spellName[i], true)
				SLS.D:ColorPick(self.spellName[i].."c", "Color for "..self.spellName[i], self.dC[i])
			end
		end
	else
		self.Own = false
		require('DamageLib')
		PrintChat("<font color=\"#fd8b12\"><b>[SL-Series] - <font color=\"#F2EE00\">DamageLib loaded</b></font>")
		for i=1,4,1 do
			if getdmg(self.spellName[i],myHero,myHero,1,3)~=0 then
				SLS.D:Boolean(self.spellName[i], "Draw "..self.spellName[i], true)
				SLS.D:ColorPick(self.spellName[i].."c", "Color for "..self.spellName[i], self.dC[i])
			end
		end
	end

	DelayAction( function()
		for _,champ in pairs(GetEnemyHeroes()) do
			self.dmgSpell[GetObjectName(champ)]={0, 0, 0, 0}
			self.dX[GetObjectName(champ)] = {{0,0}, {0,0}, {0,0}, {0,0}}
		end
		Callback.Add("Tick", function() self:Set() end)
		Callback.Add("Draw", function() self:Draw() end)
	end, .001)
end

function DmgDraw:Set()
	for _,champ in pairs(GetEnemyHeroes()) do
		self.dCheck[GetObjectName(champ)]={false,false,false,false}
		local last = GetPercentHP(champ)*1.04
		local lock = false
			GetReady()
		for i=1,4,1 do
			if SLS.D[self.spellName[i]] and SLS.D[self.spellName[i]]:Value() and (SReady[i-1] or CanUseSpell(myHero,i-1) == 8) and GetDistance(GetOrigin(myHero),GetOrigin(champ)) < SLS.D.dR:Value() then
				if self.Own then
					self.dmgSpell[GetObjectName(champ)][i] = Dmg[i-1](champ)
				else
					self.dmgSpell[GetObjectName(champ)][i] = getdmg(self.spellName[i],champ,myHero,GetCastLevel(myHero,i-1))
				end
				self.dCheck[GetObjectName(champ)][i]=true
			else 
				self.dmgSpell[GetObjectName(champ)][i] = 0
				self.dCheck[GetObjectName(champ)][i]=false
			end
			self.dX[GetObjectName(champ)][i][2] = self.dmgSpell[GetObjectName(champ)][i]/(GetMaxHP(champ)+GetDmgShield(champ))*104
			self.dX[GetObjectName(champ)][i][1] = last - self.dX[GetObjectName(champ)][i][2]
			last = last - self.dX[GetObjectName(champ)][i][2]
			if lock then
				self.dX[GetObjectName(champ)][i][1] = 0 
				self.dX[GetObjectName(champ)][i][2] = 0
			end
			if self.dX[GetObjectName(champ)][i][1]<=0 and not lock then
				self.dX[GetObjectName(champ)][i][1] = 0 
				self.dX[GetObjectName(champ)][i][2] = last + self.dX[GetObjectName(champ)][i][2]
				lock = true
			end
		end
		if SLS.D.dAA:Value() and SLS.D.dAAc:Value() then 
			self.aa[GetObjectName(champ)] = math.ceil(GetCurrentHP(champ)/(CalcDamage(myHero, champ, GetBaseDamage(myHero)+GetBonusDmg(myHero),0)*(GetCritChance(myHero)+1)))
		elseif SLS.D.dAA:Value() and not SLS.D.dAAc:Value() then 
			self.aa[GetObjectName(champ)] = math.ceil(GetCurrentHP(champ)/(CalcDamage(myHero, champ, GetBaseDamage(myHero)+GetBonusDmg(myHero),0)))
		end
	end
end

function DmgDraw:Draw()
	for _,champ in pairs(GetEnemyHeroes()) do
		
		local bar = GetHPBarPos(champ)
		if bar.x ~= 0 and bar.y ~= 0 then
			for i=4,1,-1 do
				if self.dCheck[GetObjectName(champ)] and self.dCheck[GetObjectName(champ)][i] then
					FillRect(bar.x+self.dX[GetObjectName(champ)][i][1],bar.y,self.dX[GetObjectName(champ)][i][2],9,SLS.D[self.spellName[i].."c"]:Value())
					FillRect(bar.x+self.dX[GetObjectName(champ)][i][1],bar.y-1,2,11,GoS.Black)
				end
			end
			if SLS.D.dAA:Value() and bar.x ~= 0 and bar.y ~= 0 and self.aa[GetObjectName(champ)] then 
				DrawText(self.aa[GetObjectName(champ)].." AA", 15, bar.x + 75, bar.y + 25, GoS.White)
			end
		end
	end
end

class 'Drawings'

function Drawings:__init()
	if not SLSChamps[ChampName] then return end
	self.SNames={"Q","W","E","R"}
	self.Check={false,false,false,false}
	SLS:SubMenu("Dr", "|SL| Drawings")
	SLS.Dr:Boolean("UD", "Use Drawings", false)
	SLS.Dr:ColorPick("CP", "Circle color", {255,102,102,102})
	SLS.Dr:DropDown("DQM", "Draw Quality", 1, {"High", "Medium", "Low"})
	SLS.Dr:Slider("DWi", "Circle witdth", 1, 1, 5, 1)
	for i=0,3 do
		if _G[ChampName].Spell and _G[ChampName].Spell[i] and _G[ChampName].Spell[i].range then
			local range = _G[ChampName].Spell[i].range
		else
			local range = nil
		end
		if range and range < 3000 and range > 200 then
			SLS.Dr:Boolean("D"..self.SNames[i+1], "Draw "..self.SNames[i+1], true)
		end
	end
	Callback.Add("Tick", function() self:CheckS() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Drawings:CheckS()
	for l=0,3 do 
		if SLS.Dr.UD:Value() and _G[ChampName].Spell and _G[ChampName].Spell[l] and SReady[l] and SLS.Dr["D"..self.SNames[l+1]]:Value() then 
			self.Check[l+1] = true
		else 
			self.Check[l+1] = false
		end
	end
end

function Drawings:Draw()
	local org = GetOrigin(myHero)
	for l=0,3 do
		if self.Check[l+1] then
			DrawCircle(org, _G[ChampName].Spell[l].range, SLS.Dr.DWi:Value(), SLS.Dr.DQM:Value(), SLS.Dr.CP:Value())
		end
	end
end


--Updater
class 'Update'

function Update:__init()
	if not AutoUpdater then return end
	self.webV = "Error"
	self.Stat = "Error"
	self.Do = true

	function AutoUpdate(data)
		if tonumber(data) > SLSeries then
			self.webV = data
			self.State = "|SL| Update to v"..self.webV
			Callback.Add("Draw", function() self:Box() end)
			Callback.Add("WndMsg", function(key,msg) self:Click(key,msg) end)
		end
	end

	GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Series.version", AutoUpdate)
end

function Update:Box()
	if not self.Do then return end
	local cur = GetCursorPos()
	FillRect(0,0,360,85,GoS.Red)
	if cur.x < 350 and cur.y < 75 then
		FillRect(0,0,350,75,GoS.White)
	else
		FillRect(0,0,350,75,GoS.Black)
	end
	
	DrawText(self.State, 40, 10, 10, GoS.Green)
	
	FillRect(360,10,50,60,GoS.Red)
	FillRect(365,15,40,50,GoS.White)
	if cur.x < 370 or cur.x > 400 or cur.y<7 or cur.y > 60 then
		DrawText("X", 60, 370,7, GoS.Black)
	else
		DrawText("X", 60, 370,7, GoS.Red)
	end
	
end

function Update:Click(key,msg)
	local cur = GetCursorPos()
	if key == 513 and cur.x < 350 and cur.y < 75 then
		self.State = "Downloading..."
		DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Series.lua", SCRIPT_PATH .. "SL-Series.lua", function() self.State = "Update Complete" PrintChat("<font color=\"#fd8b12\"><b>[SL-Series] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return	end)
	elseif key == 513 and cur.x > 370 and cur.x < 400 and cur.y > 7 and cur.y < 60 then
		Callback.Del("Draw", function() self:Box() end)
		self.Do = false
	end
end


class 'HitMe'

function HitMe:__init()
 
     self.str = {[-4] = "R2", [-3] = "P", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
 
    SLS:SubMenu("SB","|SL| Spellblock")
  
	
self.s = {
	["AatroxQ"]={charName="Aatrox",slot=0,type="Circle",delay=0.6,range=650,radius=250,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0.225,displayname="Dark Flight",mcollision=false},
	["AatroxE"]={charName="Aatrox",slot=2,type="Line",delay=0.25,range=1075,radius=35,speed=1250,addHitbox=true,danger=3,dangerous=false,proj="AatroxEConeMissile",killTime=0,displayname="Blade of Torment",mcollision=false},
	["AhriOrbofDeception"]={charName="Ahri",slot=0,type="Line",delay=0.25,range=1000,radius=100,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="AhriOrbMissile",killTime=0,displayname="Orb of Deception",mcollision=false},
	["AhriOrbReturn"]={charName="Ahri",slot=0,type="Line",delay=0.25,range=1000,radius=100,speed=915,addHitbox=true,danger=2,dangerous=false,proj="AhriOrbReturn",killTime=0,displayname="Orb of Deception2",mcollision=false},
	["AhriSeduce"]={charName="Ahri",slot=2,type="Line",delay=0.25,range=1000,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="AhriSeduceMissile",killTime=0,displayname="Charm",mcollision=true},
	["BandageToss"]={charName="Amumu",slot=0,type="Line",delay=0.25,range=1000,radius=90,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="SadMummyBandageToss",killTime=0,displayname="Bandage Toss",mcollision=true},
	["CurseoftheSadMummy"]={charName="Amumu",slot=3,type="Circle",delay=0.25,range=0,radius=550,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=1.25,displayname="Curse of the Sad Mummy",mcollision=false},
	["FlashFrost"]={charName="Anivia",slot=0,type="Line",delay=0.25,range=1200,radius=110,speed=850,addHitbox=true,danger=3,dangerous=true,proj="FlashFrostSpell",killTime=0,displayname="Flash Frost",mcollision=false},
	["Incinerate"]={charName="Annie",slot=1,type="Cone",delay=0.25,range=825,radius=80,speed=math.huge,addHitbox=false,danger=2,dangerous=false,proj="nil",killTime=0,displayname="",mcollision=false},
	["InfernalGuardian"]={charName="Annie",slot=3,type="Circle",delay=0.25,range=600,radius=251,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="nil",killTime=0.3,displayname="",mcollision=false},
	["Volley"]={charName="Ashe",slot=1,type="Sevenway",delay=0.25,range=1200,radius=60,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="VolleyAttack",killTime=0,displayname="",mcollision=false},
	["EnchantedCrystalArrow"]={charName="Ashe",slot=3,type="Line",delay=0.2,range=20000,radius=130,speed=1600,addHitbox=true,danger=5,dangerous=true,proj="EnchantedCrystalArrow",killTime=0,displayname="Enchanted Arrow",mcollision=false},
	["AurelionSolQ"]={charName="AurelionSol",slot=0,type="Line",delay=0.25,range=1500,radius=180,speed=850,addHitbox=true,danger=2,dangerous=false,proj="AurelionSolQMissile",killTime=0,displayname="AurelionSolQ",mcollision=false},
	["AurelionSolR"]={charName="AurelionSol",slot=3,type="Line",delay=0.3,range=1420,radius=120,speed=4500,addHitbox=true,danger=3,dangerous=true,proj="AurelionSolRBeamMissile",killTime=0,displayname="AurelionSolR",mcollision=false},
	["BardQ"]={charName="Bard",slot=0,type="Line",delay=0.25,range=850,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="BardQMissile",killTime=0,displayname="BardQ",mcollision=true},
	["BardR"]={charName="Bard",slot=3,type="Circle",delay=0.5,range=3400,radius=350,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="BardR",killTime=1,displayname="BardR",mcollision=false},
	["RocketGrab"]={charName="Blitzcrank",slot=0,type="Line",delay=0.25,range=1050,radius=70,speed=1800,addHitbox=true,danger=4,dangerous=true,proj="RocketGrabMissile",killTime=0,displayname="Rocket Grab",mcollision=true},
	["StaticField"]={charName="Blitzcrank",slot=3,type="Circle",delay=0.25,range=0,radius=600,speed=math.huge,addHitbox=false,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Static Field",mcollision=false},
	["BrandQ"]={charName="Brand",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="BrandQMissile",killTime=0,displayname="Sear",mcollision=true},
	["BrandW"]={charName="Brand",slot=1,type="Circle",delay=0.85,range=900,radius=240,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.275,displayname="Pillar of Flame"}, -- doesnt work
	["BraumQ"]={charName="Braum",slot=0,type="Line",delay=0.25,range=1000,radius=60,speed=1700,addHitbox=true,danger=3,dangerous=true,proj="BraumQMissile",killTime=0,displayname="Winter's Bite",mcollision=true},
	["BraumRWrapper"]={charName="Braum",slot=3,type="Line",delay=0.5,range=1250,radius=115,speed=1400,addHitbox=true,danger=4,dangerous=true,proj="braumrmissile",killTime=0,displayname="Glacial Fissure",mcollision=false},
	["CaitlynPiltoverPeacemaker"]={charName="Caitlyn",slot=0,type="Line",delay=0.625,range=1300,radius=90,speed=1800,addHitbox=true,danger=2,dangerous=false,proj="CaitlynPiltoverPeacemaker",killTime=0,displayname="Piltover Peacemaker",mcollision=false},
	["CaitlynEntrapment"]={charName="Caitlyn",slot=2,type="Line",delay=0.4,range=1000,radius=70,speed=1600,addHitbox=true,danger=1,dangerous=false,proj="CaitlynEntrapmentMissile",killTime=0,displayname="90 Caliber Net",mcollision=true},
	["CassiopeiaNoxiousBlast"]={charName="Cassiopeia",slot=0,type="Circle",delay=0.75,range=850,radius=150,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="CassiopeiaNoxiousBlast",killTime=0.2,displayname="Noxious Blast",mcollision=false},
	["CassiopeiaPetrifyingGaze"]={charName="Cassiopeia",slot=3,type="Cone",delay=0.6,range=825,radius=80,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="CassiopeiaPetrifyingGaze",killTime=0,displayname="Petrifying Gaze",mcollision=false},
	["Rupture"]={charName="Chogath",slot=0,type="Circle",delay=1.2,range=950,radius=250,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="Rupture",killTime=0.8,displayname="Rupture",mcollision=false},
	["PhosphorusBomb"]={charName="Corki",slot=0,type="Circle",delay=0.3,range=825,radius=250,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="PhosphorusBombMissile",killTime=0.35,displayname="Phosphorus Bomb",mcollision=false},
	["MissileBarrage"]={charName="Corki",slot=3,type="Line",delay=0.2,range=1300,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="MissileBarrageMissile",killTime=0,displayname="Missile Barrage",mcollision=true},
	["MissileBarrage2"]={charName="Corki",slot=3,type="Line",delay=0.2,range=1500,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="MissileBarrageMissile2",killTime=0,displayname="Missile Barrage big",mcollision=true},
	["DariusCleave"]={charName="Darius",slot=0,type="Circle",delay=0.75,range=0,radius=425 - 50,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="DariusCleave",killTime=0,displayname="Cleave",mcollision=false},
	["DariusAxeGrabCone"]={charName="Darius",slot=2,type="Cone",delay=0.25,range=550,radius=80,speed=math.huge,addHitbox=false,danger=3,dangerous=true,proj="DariusAxeGrabCone",killTime=0,displayname="Apprehend",mcollision=false},
	["DianaArc"]={charName="Diana",slot=0,type="Circle",delay=0.25,range=835,radius=195,speed=1400,addHitbox=true,danger=3,dangerous=true,proj="DianaArcArc",killTime=0,displayname="",mcollision=false},
	["DianaArcArc"]={charName="Diana",slot=0,type="Arc",delay=0.25,range=835,radius=195,speed=1400,addHitbox=true,danger=3,dangerous=true,proj="DianaArcArc",killTime=0,displayname="",mcollision=false},
	["InfectedCleaverMissileCast"]={charName="DrMundo",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=2000,addHitbox=true,danger=3,dangerous=false,proj="InfectedCleaverMissile",killTime=0,displayname="Infected Cleaver",mcollision=true},
	["DravenDoubleShot"]={charName="Draven",slot=2,type="Line",delay=0.25,range=1100,radius=130,speed=1400,addHitbox=true,danger=3,dangerous=true,proj="DravenDoubleShotMissile",killTime=0,displayname="Stand Aside",mcollision=false},
	["DravenRCast"]={charName="Draven",slot=3,type="Line",delay=0.5,range=25000,radius=160,speed=2000,addHitbox=true,danger=5,dangerous=true,proj="DravenR",killTime=0,displayname="Whirling Death",mcollision=false},
	["EkkoQ"]={charName="Ekko",slot=0,type="Line",delay=0.25,range=925,radius=60,speed=1650,addHitbox=true,danger=4,dangerous=true,proj="ekkoqmis",killTime=0,displayname="Timewinder",mcollision=false},
	["EkkoW"]={charName="Ekko",slot=1,type="Circle",delay=3.75,range=1600,radius=375,speed=1650,addHitbox=false,danger=3,dangerous=false,proj="EkkoW",killTime=1.2,displayname="Parallel Convergence",mcollision=false},
	["EkkoR"]={charName="Ekko",slot=3,type="Circle",delay=0.25,range=1600,radius=375,speed=1650,addHitbox=true,danger=3,dangerous=false,proj="EkkoR",killTime=0.2,displayname="Chronobreak",mcollision=false},
	["EliseHumanE"]={charName="Elise",slot=2,type="Line",delay=0.25,range=925,radius=55,speed=1600,addHitbox=true,danger=4,dangerous=true,proj="EliseHumanE",killTime=0,displayname="Cocoon",mcollision=true},
	["EvelynnR"]={charName="Evelynn",slot=3,type="Circle",delay=0.25,range=650,radius=350,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="EvelynnR",killTime=0.2,displayname="Agony's Embrace"},
	["EzrealMysticShot"]={charName="Ezreal",slot=0,type="Line",delay=0.25,range=1300,radius=50,speed=1975,addHitbox=true,danger=2,dangerous=false,proj="EzrealMysticShotMissile",killTime=0.25,displayname="Mystic Shot",mcollision=true},
	["EzrealEssenceFlux"]={charName="Ezreal",slot=1,type="Line",delay=0.25,range=1000,radius=80,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="EzrealEssenceFluxMissile",killTime=0,displayname="Essence Flux",mcollision=false},
	["EzrealTrueshotBarrage"]={charName="Ezreal",slot=3,type="Line",delay=1,range=20000,radius=150,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="EzrealTrueshotBarrage",killTime=0,displayname="Trueshot Barrage",mcollision=false},
	["FioraW"]={charName="Fiora",slot=1,type="Line",delay=0.5,range=800,radius=70,speed=3200,addHitbox=true,danger=2,dangerous=false,proj="FioraWMissile",killTime=0,displayname="Riposte",mcollision=false},
	["FizzMarinerDoom"]={charName="Fizz",slot=3,type="Line",delay=0.25,range=1150,radius=120,speed=1350,addHitbox=true,danger=5,dangerous=true,proj="FizzMarinerDoomMissile",killTime=0,displayname="Chum the Waters",mcollision=false},
	["GalioResoluteSmite"]={charName="Galio",slot=0,type="Circle",delay=0.25,range=900,radius=200,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="GalioResoluteSmite",killTime=0.2,displayname="Resolute Smite",mcollision=false},
	["GalioRighteousGust"]={charName="Galio",slot=2,type="Line",delay=0.25,range=1000,radius=120,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="GalioRighteousGust",killTime=0,displayname="Righteous Ghost",mcollision=false},
	["GalioIdolOfDurand"]={charName="Galio",slot=3,type="Circle",delay=0.25,range=0,radius=550,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=1,displayname="Idol of Durand",mcollision=false},
	["GnarQ"]={charName="Gnar",slot=0,type="Line",delay=0.25,range=1200,radius=60,speed=1225,addHitbox=true,danger=2,dangerous=false,proj="gnarqmissile",killTime=0,displayname="Boomerang Throw",mcollision=false},
	["GnarQReturn"]={charName="Gnar",slot=0,type="Line",delay=0,range=1200,radius=75,speed=1225,addHitbox=true,danger=2,dangerous=false,proj="GnarQMissileReturn",killTime=0,displayname="Boomerang Throw2",mcollision=false},
	["GnarBigQ"]={charName="Gnar",slot=0,type="Line",delay=0.5,range=1150,radius=90,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="GnarBigQMissile",killTime=0,displayname="Boulder Toss",mcollision=true},
	["GnarBigW"]={charName="Gnar",slot=1,type="Line",delay=0.6,range=600,radius=80,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="GnarBigW",killTime=0,displayname="Wallop",mcollision=false},
	["GnarE"]={charName="Gnar",slot=2,type="Circle",delay=0,range=473,radius=150,speed=903,addHitbox=true,danger=2,dangerous=false,proj="GnarE",killTime=0.2,displayname="GnarE",mcollision=false},
	["GnarBigE"]={charName="Gnar",slot=2,type="Circle",delay=0.25,range=475,radius=200,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="GnarBigE",killTime=0.2,displayname="GnarBigE",mcollision=false},
	["GnarR"]={charName="Gnar",slot=3,type="Circle",delay=0.25,range=0,radius=500,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=0.3,displayname="GnarUlt",mcollision=false},
	["GragasQ"]={charName="Gragas",slot=0,type="Circle",delay=0.25,range=1100,radius=275,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="GragasQMissile",killTime=2.5,displayname="Barrel Roll",mcollision=false,killName="GragasQToggle"},
	["GragasE"]={charName="Gragas",slot=2,type="Line",delay=0,range=950,radius=200,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="GragasE",killTime=0,displayname="Body Slam",mcollision=true},
	["GragasR"]={charName="Gragas",slot=3,type="Circle",delay=0.25,range=1050,radius=375,speed=1800,addHitbox=true,danger=5,dangerous=true,proj="GragasRBoom",killTime=0.3,displayname="Explosive Cask",mcollision=false},
	["GravesQLineSpell"]={charName="Graves",slot=0,type="Line",delay=0.2,range=750,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="GravesQLineMis",killTime=0,displayname="Buckshot",mcollision=false},
	["GravesChargeShot"]={charName="Graves",slot=3,type="Line",delay=0.2,range=1000,radius=100,speed=2100,addHitbox=true,danger=5,dangerous=true,proj="GravesChargeShotShot",killTime=0,displayname="Collateral Damage",mcollision=false},
	["HeimerdingerW"]={charName="Heimerdinger",slot=1,type="Line",delay=0.25,range=1500,radius=70,speed=1800,addHitbox=true,danger=2,dangerous=false,proj="HeimerdingerWAttack2",killTime=0,displayname="HeimerdingerUltW",mcollision=true},
	["HeimerdingerE"]={charName="Heimerdinger",slot=2,type="Circle",delay=0.25,range=925,radius=100,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="heimerdingerespell",killTime=0.3,displayname="HeimerdingerE",mcollision=false},
	["IllaoiQ"]={charName="Illaoi",slot=0,type="Line",delay=0.75,range=750,radius=160,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="illaoiemis",killTime=0,displayname="",mcollision=false},
	["IllaoiE"]={charName="Illaoi",slot=2,type="Line",delay=0.25,range=1100,radius=50,speed=1900,addHitbox=true,danger=3,dangerous=true,proj="illaoiemis",killTime=0,displayname="",mcollision=true},
	["IllaoiR"]={charName="Illaoi",slot=3,type="Circle",delay=0.5,range=0,radius=450,speed=math.huge,addHitbox=false,danger=3,dangerous=true,proj="nil",killTime=0.2,displayname="",mcollision=false},
	["IreliaTranscendentBlades"]={charName="Irelia",slot=3,type="Line",delay=0,range=1200,radius=65,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="IreliaTranscendentBlades",killTime=0,displayname="Transcendent Blades",mcollision=false},
	["HowlingGale"]={charName="Janna",slot=0,type="Line",delay=0.25,range=1700,radius=120,speed=900,addHitbox=true,danger=2,dangerous=false,proj="HowlingGaleSpell",killTime=0,displayname="HowlingGale",mcollision=false},
	["JarvanIVDragonStrike"]={charName="JarvanIV",slot=0,type="Line",delay=0.6,range=770,radius=70,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="nil",killTime=0,displayname="DragonStrike",mcollision=false},
	["JarvanIVEQ"]={charName="JarvanIV",slot=0,type="Line",delay=0.25,range=880,radius=70,speed=1450,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0,displayname="DragonStrike2",mcollision=false},
	["JarvanIVDemacianStandard"]={charName="JarvanIV",slot=2,type="Circle",delay=0.5,range=860,radius=175,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="JarvanIVDemacianStandard",killTime=1.5,displayname="Demacian Standard",mcollision=false},
	["jayceshockblast"]={charName="Jayce",slot=0,type="Line",delay=0.25,range=1300,radius=70,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="JayceShockBlastMis",killTime=0,displayname="ShockBlast",mcollision=true},
	["JayceQAccel"]={charName="Jayce",slot=0,type="Line",delay=0.25,range=1300,radius=70,speed=2350,addHitbox=true,danger=2,dangerous=false,proj="JayceShockBlastWallMis",killTime=0,displayname="ShockBlastCharged",mcollision=true},
	["JhinW"]={charName="Jhin",slot=1,type="Line",delay=0.75,range=2550,radius=40,speed=5000,addHitbox=true,danger=3,dangerous=true,proj="JhinWMissile",killTime=0,displayname="",mcollision=false},
	["JhinRShot"]={charName="Jhin",slot=3,type="Line",delay=0.25,range=3500,radius=80,speed=5000,addHitbox=true,danger=3,dangerous=true,proj="JhinRShotMis",killTime=0,displayname="JhinR",mcollision=false},
	["JinxW"]={charName="Jinx",slot=1,type="Line",delay=0.6,range=1400,radius=60,speed=3300,addHitbox=true,danger=3,dangerous=true,proj="JinxWMissile",killTime=0,displayname="Zap",mcollision=true},
	["JinxR"]={charName="Jinx",slot=3,type="Line",delay=0.6,range=20000,radius=140,speed=1700,addHitbox=true,danger=5,dangerous=true,proj="JinxR",killTime=0,displayname="",mcollision=false},
	["KalistaMysticShot"]={charName="Kalista",slot=0,type="Line",delay=0.25,range=1200,radius=40,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="kalistamysticshotmis",killTime=0,displayname="MysticShot",mcollision=true},
	["KarmaQ"]={charName="Karma",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KarmaQMissile",killTime=0,displayname="",mcollision=true},
	["KarmaQMantra"]={charName="Karma",slot=0,type="Line",delay=0.25,range=950,radius=80,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KarmaQMissileMantra",killTime=0,displayname="",mcollision=true},
	["KarthusLayWasteA2"]={charName="Karthus",slot=0,type="Circle",delay=0.625,range=875,radius=160,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Lay Waste",mcollision=false},
	["RiftWalk"]={charName="Kassadin",slot=3,type="Circle",delay=0.25,range=450,radius=270,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="RiftWalk",killTime=0.3,displayname="",mcollision=false},
	["KennenShurikenHurlMissile1"]={charName="Kennen",slot=0,type="Line",delay=0.18,range=1050,radius=50,speed=1650,addHitbox=true,danger=2,dangerous=false,proj="KennenShurikenHurlMissile1",killTime=0,displayname="Thundering Shuriken",mcollision=true},
	["KhazixW"]={charName="Khazix",slot=1,type="Line",delay=0.25,range=1025,radius=70,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KhazixWMissile",killTime=0,displayname="",mcollision=true},
	["KhazixE"]={charName="Khazix",slot=2,type="Circle",delay=0.25,range=600,radius=300,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="KhazixE",killTime=0.2,displayname="",mcollision=false},
	["KogMawQ"]={charName="Kogmaw",slot=0,type="Line",delay=0.25,range=975,radius=70,speed=1650,addHitbox=true,danger=2,dangerous=false,proj="KogMawQ",killTime=0,displayname="",mcollision=true},
	["KogMawVoidOoze"]={charName="Kogmaw",slot=2,type="Line",delay=0.25,range=1200,radius=120,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="KogMawVoidOozeMissile",killTime=0,displayname="Void Ooze",mcollision=false},
	["KogMawLivingArtillery"]={charName="Kogmaw",slot=3,type="Circle",delay=1.2,range=1800,radius=225,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="KogMawLivingArtillery",killTime=0.5,displayname="LivingArtillery",mcollision=false},
	["LeblancSlide"]={charName="Leblanc",slot=1,type="Circle",delay=0,range=600,radius=220,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LeblancSlide",killTime=0.2,displayname="Slide",mcollision=false},
	["LeblancSlideM"]={charName="Leblanc",slot=3,type="Circle",delay=0,range=600,radius=220,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LeblancSlideM",killTime=0.2,displayname="Slide R",mcollision=false},
	["LeblancSoulShackle"]={charName="Leblanc",slot=2,type="Line",delay=0,range=950,radius=70,speed=1750,addHitbox=true,danger=3,dangerous=true,proj="LeblancSoulShackle",killTime=0,displayname="Ethereal Chains R",mcollision=true},
	["LeblancSoulShackleM"]={charName="Leblanc",slot=3,type="Line",delay=0,range=950,radius=70,speed=1750,addHitbox=true,danger=3,dangerous=true,proj="LeblancSoulShackleM",killTime=0,displayname="Ethereal Chains",mcollision=true},
	["BlindMonkQOne"]={charName="LeeSin",slot=0,type="Line",delay=0.1,range=1000,radius=65,speed=1800,addHitbox=true,danger=3,dangerous=true,proj="BlindMonkQOne",killTime=0,displayname="Sonic Wave",mcollision=true},
	["LeonaZenithBlade"]={charName="Leona",slot=2,type="Line",delay=0.25,range=875,radius=70,speed=1750,addHitbox=true,danger=3,dangerous=true,proj="LeonaZenithBladeMissile",killTime=0,displayname="Zenith Blade",mcollision=false},
	["LeonaSolarFlare"]={charName="Leona",slot=3,type="Circle",delay=1,range=1200,radius=300,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="LeonaSolarFlare",killTime=0.5,displayname="Solar Flare",mcollision=false},
	["LissandraQ"]={charName="Lissandra",slot=0,type="Line",delay=0.25,range=700,radius=75,speed=2200,addHitbox=true,danger=2,dangerous=false,proj="LissandraQMissile",killTime=0,displayname="Ice Shard",mcollision=false},
	["LissandraQShards"]={charName="Lissandra",slot=0,type="Line",delay=0.25,range=700,radius=90,speed=2200,addHitbox=true,danger=2,dangerous=false,proj="lissandraqshards",killTime=0,displayname="Ice Shard2",mcollision=false},
	["LissandraE"]={charName="Lissandra",slot=2,type="Line",delay=0.25,range=1025,radius=125,speed=850,addHitbox=true,danger=2,dangerous=false,proj="LissandraEMissile",killTime=0,displayname="",mcollision=false},
	["LucianQ"]={charName="Lucian",slot=0,type="Line",delay=0.5,range=800,radius=65,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="LucianQ",killTime=0,displayname="",mcollision=false},
	["LucianW"]={charName="Lucian",slot=1,type="Line",delay=0.2,range=1000,radius=55,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="lucianwmissile",killTime=0,displayname="",mcollision=true},
	["LucianRMis"]={charName="Lucian",slot=3,type="Line",delay=0.5,range=1400,radius=110,speed=2800,addHitbox=true,danger=2,dangerous=false,proj="lucianrmissileoffhand",killTime=0,displayname="LucianR",mcollision=true},
	["LuluQ"]={charName="Lulu",slot=0,type="Line",delay=0.25,range=950,radius=60,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LuluQMissile",killTime=0,displayname="",mcollision=false},
	["LuluQPix"]={charName="Lulu",slot=0,type="Line",delay=0.25,range=950,radius=60,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LuluQMissileTwo",killTime=0,displayname="",mcollision=false},
	["LuxLightBinding"]={charName="Lux",slot=0,type="Line",delay=0.225,range=1300,radius=70,speed=1200,addHitbox=true,danger=3,dangerous=true,proj="LuxLightBindingMis",killTime=0,displayname="Light Binding",mcollision=true},
	["LuxLightStrikeKugel"]={charName="Lux",slot=2,type="Circle",delay=0.25,range=1100,radius=275,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="LuxLightStrikeKugel",killTime=5.25,displayname="LightStrikeKugel",mcollision=false,killName="LuxLightstrikeToggle"},
	["LuxMaliceCannon"]={charName="Lux",slot=3,type="Line",delay=1,range=3500,radius=190,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="LuxMaliceCannon",killTime=0,displayname="Malice Cannon",mcollision=false},
	["UFSlash"]={charName="Malphite",slot=3,type="Circle",delay=0,range=1000,radius=270,speed=1500,addHitbox=true,danger=5,dangerous=true,proj="UFSlash",killTime=0.4,displayname="",mcollision=false},
	["MalzaharQ"]={charName="Malzahar",slot=0,type="Line",delay=0.75,range=900,radius=85,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="MalzaharQ",killTime=0,displayname="",mcollision=false},
	["DarkBindingMissile"]={charName="Morgana",slot=0,type="Line",delay=0.2,range=1300,radius=80,speed=1200,addHitbox=true,danger=3,dangerous=true,proj="DarkBindingMissile",killTime=0,displayname="Dark Binding",mcollision=true},
	["NamiQ"]={charName="Nami",slot=0,type="Circle",delay=0.95,range=1625,radius=150,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="namiqmissile",killTime=0.35,displayname="",mcollision=false},
	["NamiR"]={charName="Nami",slot=3,type="Line",delay=1,range=2750,radius=260,speed=850,addHitbox=true,danger=2,dangerous=false,proj="NamiRMissile",killTime=0,displayname="",mcollision=false},
	["NautilusAnchorDrag"]={charName="Nautilus",slot=0,type="Line",delay=0.25,range=1080,radius=90,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="NautilusAnchorDragMissile",killTime=0,displayname="Anchor Drag",mcollision=true},
	["NocturneDuskbringer"]={charName="Nocturne",slot=0,type="Line",delay=0.25,range=1125,radius=60,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="NocturneDuskbringer",killTime=0,displayname="Duskbringer",mcollision=false},
	["JavelinToss"]={charName="Nidalee",slot=0,type="Line",delay=0.25,range=1500,radius=40,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="JavelinToss",killTime=0,displayname="JavelinToss",mcollision=true},
	["OlafAxeThrowCast"]={charName="Olaf",slot=0,type="Line",delay=0.25,range=1000,radius=105,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="olafaxethrow",killTime=0,displayname="Axe Throw",mcollision=false},
	["OriannasQ"]={charName="Orianna",slot=0,type="Line",delay=0,range=1500,radius=80,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="orianaizuna",killTime=0,displayname="",mcollision=false},
	["OriannaQend"]={charName="Orianna",slot=0,type="Circle",delay=0,range=1500,radius=90,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.1,displayname="",mcollision=false},
	["OrianaDissonanceCommand-"]={charName="Orianna",slot=1,type="Circle",delay=0.25,range=0,radius=255,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="OrianaDissonanceCommand-",killTime=0.3,displayname="",mcollision=false},
	["OriannasE"]={charName="Orianna",slot=2,type="Line",delay=0,range=1500,radius=85,speed=1850,addHitbox=true,danger=2,dangerous=false,proj="orianaredact",killTime=0,displayname="",mcollision=false},
	["OrianaDetonateCommand-"]={charName="Orianna",slot=3,type="Circle",delay=0.7,range=0,radius=410,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="OrianaDetonateCommand-",killTime=0.5,displayname="",mcollision=false},
	["QuinnQ"]={charName="Quinn",slot=0,type="Line",delay=0,range=1050,radius=60,speed=1550,addHitbox=true,danger=2,dangerous=false,proj="QuinnQ",killTime=0,displayname="",mcollision=true},
	["PoppyQ"]={charName="Poppy",slot=0,type="Line",delay=0.5,range=430,radius=100,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="PoppyQ",killTime=0,displayname="",mcollision=false},
	["PoppyRSpell"]={charName="Poppy",slot=3,type="Line",delay=0.3,range=1200,radius=100,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="PoppyRMissile",killTime=0,displayname="PoppyR",mcollision=false},
	["RengarE"]={charName="Rengar",slot=2,type="Line",delay=0.25,range=1000,radius=70,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="RengarEFinal",killTime=0,displayname="",mcollision=true},
	["reksaiqburrowed"]={charName="RekSai",slot=0,type="Line",delay=0.5,range=1050,radius=60,speed=1550,addHitbox=true,danger=3,dangerous=false,proj="RekSaiQBurrowedMis",killTime=0,displayname="RekSaiQ",mcollision=true},
	["RivenIzunaBlade"]={charName="Riven",slot=3,type="Line",delay=0.25,range=1100,radius=125,speed=1600,addHitbox=false,danger=5,dangerous=true,proj="RivenLightsaberMissile",killTime=0,displayname="WindSlash",mcollision=false},
	["RumbleGrenade"]={charName="Rumble",slot=2,type="Line",delay=0.25,range=850,radius=60,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="RumbleGrenade",killTime=0,displayname="Grenade",mcollision=true},
	["RumbleCarpetBombM"]={charName="Rumble",slot=3,type="Line",delay=0.4,range=1700,radius=200,speed=1600,addHitbox=true,danger=4,dangerous=false,proj="RumbleCarpetBombMissile",killTime=0,displayname="Carpet Bomb",mcollision=false}, --doesnt work
	["RyzeQ"]={charName="Ryze",slot=0,type="Line",delay=0,range=900,radius=50,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="RyzeQ",killTime=0,displayname="",mcollision=true},
	["ryzerq"]={charName="Ryze",slot=0,type="Line",delay=0,range=900,radius=50,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ryzerq",killTime=0,displayname="RyzeQ R",mcollision=true},
	["SejuaniArcticAssault"]={charName="Sejuani",slot=0,type="Line",delay=0,range=900,radius=70,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0,displayname="ArcticAssault",mcollision=true},
	["SejuaniGlacialPrisonStart"]={charName="Sejuani",slot=3,type="Line",delay=0.25,range=1200,radius=110,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="sejuaniglacialprison",killTime=0,displayname="GlacialPrisonStart",mcollision=false},
	["SionE"]={charName="Sion",slot=2,type="Line",delay=0.25,range=800,radius=80,speed=1800,addHitbox=true,danger=3,dangerous=true,proj="SionEMissile",killTime=0,displayname="",mcollision=false},
	["SionR"]={charName="Sion",slot=3,type="Line",delay=0.5,range=20000,radius=120,speed=1000,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0,displayname="",mcollision=false},
	["SorakaQ"]={charName="Soraka",slot=0,type="Circle",delay=0.5,range=950,radius=300,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.25,displayname="",mcollision=false},
	["SorakaE"]={charName="Soraka",slot=2,type="Circle",delay=0.25,range=925,radius=275,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=1,displayname="",mcollision=false},
	["ShenE"]={charName="Shen",slot=2,type="Line",delay=0,range=650,radius=50,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="ShenE",killTime=0,displayname="Shadow Dash",mcollision=false},
	["ShyvanaFireball"]={charName="Shyvana",slot=2,type="Line",delay=0.25,range=925,radius=60,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ShyvanaFireballMissile",killTime=0,displayname="Fireball",mcollision=false},
	["ShyvanaTransformCast"]={charName="Shyvana",slot=3,type="Line",delay=0.25,range=750,radius=150,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="ShyvanaTransformCast",killTime=0,displayname="Transform Cast",mcollision=false},
	["shyvanafireballdragon2"]={charName="Shyvana",slot=3,type="Line",delay=0.25,range=925,radius=70,speed=2000,addHitbox=true,danger=3,dangerous=false,proj="ShyvanaFireballDragonFxMissile",killTime=0,displayname="Fireball Dragon",mcollision=false},
	["SivirQReturn"]={charName="Sivir",slot=0,type="Line",delay=0,range=1075,radius=100,speed=1350,addHitbox=true,danger=2,dangerous=false,proj="SivirQMissileReturn",killTime=0,displayname="SivirQ2",mcollision=false},
	["SivirQ"]={charName="Sivir",slot=0,type="Line",delay=0.25,range=1075,radius=90,speed=1350,addHitbox=true,danger=2,dangerous=false,proj="SivirQMissile",killTime=0,displayname="SivirQ",mcollision=false},
	["SkarnerFracture"]={charName="Skarner",slot=2,type="Line",delay=0.35,range=350,radius=70,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="SkarnerFractureMissile",killTime=0,displayname="Fracture",mcollision=false},
	["SonaR"]={charName="Sona",slot=3,type="Line",delay=0.25,range=900,radius=140,speed=2400,addHitbox=true,danger=5,dangerous=true,proj="SonaR",killTime=0,displayname="Crescendo",mcollision=false},
	["SwainShadowGrasp"]={charName="Swain",slot=1,type="Circle",delay=1.1,range=900,radius=180,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="SwainShadowGrasp",killTime=0.5,displayname="Shadow Grasp",mcollision=false},
	["SyndraQ"]={charName="Syndra",slot=0,type="Circle",delay=0.6,range=800,radius=150,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="SyndraQ",killTime=0.2,displayname="",mcollision=false},
	["syndrawcast"]={charName="Syndra",slot=1,type="Circle",delay=0.25,range=950,radius=210,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="syndrawcast",killTime=0.2,displayname="SyndraW",mcollision=false},
	["syndrae5"]={charName="Syndra",slot=2,type="Line",delay=0,range=950,radius=100,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="syndrae5",killTime=0,displayname="SyndraE",mcollision=false},
	["SyndraE"]={charName="Syndra",slot=2,type="Line",delay=0,range=950,radius=100,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="SyndraE",killTime=0,displayname="SyndraE2",mcollision=false},
	["TalonRake"]={charName="Talon",slot=1,type="Threeway",delay=0.25,range=800,radius=80,speed=2300,addHitbox=true,danger=2,dangerous=true,proj="talonrakemissileone",killTime=0,displayname="Rake",mcollision=false},
	["TalonRakeReturn"]={charName="Talon",slot=1,type="Threeway",delay=0.25,range=800,radius=80,speed=1850,addHitbox=true,danger=2,dangerous=true,proj="talonrakemissiletwo",killTime=0,displayname="Rake2",mcollision=false},
	["TahmKenchQ"]={charName="TahmKench",slot=0,type="Line",delay=0.25,range=951,radius=90,speed=2800,addHitbox=true,danger=3,dangerous=true,proj="tahmkenchqmissile",killTime=0,displayname="Tongue Slash",mcollision=true},
	["TaricE"]={charName="Taric",slot=2,type="Line",delay=1,range=750,radius=100,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="TaricE",killTime=0,displayname="",mcollision=false},
	["ThreshQ"]={charName="Thresh",slot=0,type="Line",delay=0.5,range=1050,radius=70,speed=1900,addHitbox=true,danger=3,dangerous=true,proj="ThreshQMissile",killTime=0,displayname="",mcollision=true},
	["ThreshEFlay"]={charName="Thresh",slot=2,type="Line",delay=0.125,range=500,radius=110,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="ThreshEMissile1",killTime=0,displayname="Flay",mcollision=false},
	["RocketJump"]={charName="Tristana",slot=1,type="Circle",delay=0.5,range=900,radius=270,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="RocketJump",killTime=0.3,displayname="",mcollision=false},
	["slashCast"]={charName="Tryndamere",slot=2,type="Line",delay=0,range=660,radius=93,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="slashCast",killTime=0,displayname="",mcollision=false},
	["WildCards"]={charName="TwistedFate",slot=0,type="Threeway",delay=0.25,range=1450,radius=40,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="SealFateMissile",killTime=0,displayname="",mcollision=false},
	["TwitchVenomCask"]={charName="Twitch",slot=1,type="Circle",delay=0.25,range=900,radius=275,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="TwitchVenomCaskMissile",killTime=0.3,displayname="Venom Cask",mcollision=false},
	["UrgotHeatseekingLineMissile"]={charName="Urgot",slot=0,type="Line",delay=0.125,range=1000,radius=60,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="UrgotHeatseekingLineMissile",killTime=0,displayname="Heatseeking Line",mcollision=true},
	["UrgotPlasmaGrenade"]={charName="Urgot",slot=2,type="Circle",delay=0.25,range=1100,radius=210,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="UrgotPlasmaGrenadeBoom",killTime=0.3,displayname="PlasmaGrenade",mcollision=false},
	["VarusQMissile"]={charName="Varus",slot=0,type="Line",delay=0.25,range=1475,radius=70,speed=1900,addHitbox=true,danger=2,dangerous=false,proj="VarusQMissile",killTime=0,displayname="VarusQ",mcollision=false},
	["VarusE"]={charName="Varus",slot=2,type="Circle",delay=1,range=925,radius=235,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="VarusE",killTime=1.5,displayname="",mcollision=false},
	["VarusR"]={charName="Varus",slot=3,type="Line",delay=0.25,range=800,radius=120,speed=1950,addHitbox=true,danger=3,dangerous=true,proj="VarusRMissile",killTime=0,displayname="",mcollision=false},
	["VeigarBalefulStrike"]={charName="Veigar",slot=0,type="Line",delay=0.25,range=900,radius=70,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="VeigarBalefulStrikeMis",killTime=0,displayname="BalefulStrike",mcollision=false},
	["VeigarDarkMatter"]={charName="Veigar",slot=1,type="Circle",delay=1.35,range=900,radius=225,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.5,displayname="DarkMatter",mcollision=false},
	["VeigarEventHorizon"]={charName="Veigar",slot=2,type="Ring",delay=0.5,range=700,radius=80,speed=math.huge,addHitbox=false,danger=3,dangerous=true,proj="nil",killTime=3.5,displayname="EventHorizon",mcollision=false},
	["VelkozQ"]={charName="Velkoz",slot=0,type="Line",delay=0.25,range=1100,radius=50,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="VelkozQMissile",killTime=0,displayname="",mcollision=true},
	["VelkozQSplit"]={charName="Velkoz",slot=0,type="Line",delay=0.25,range=1100,radius=55,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="VelkozQMissileSplit",killTime=0,displayname="",mcollision=true},
	["VelkozW"]={charName="Velkoz",slot=1,type="Line",delay=0.25,range=1050,radius=88,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="VelkozWMissile",killTime=0,displayname="",mcollision=false},
	["VelkozE"]={charName="Velkoz",slot=2,type="Circle",delay=0.5,range=800,radius=225,speed=1500,addHitbox=false,danger=2,dangerous=false,proj="VelkozEMissile",killTime=0.5,displayname="",mcollision=false},
	["Vi-q"]={charName="Vi",slot=0,type="Line",delay=0.25,range=715,radius=90,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="ViQMissile",killTime=0,displayname="Vi-Q",mcollision=false},
	["VladimirR"] = {charName = "Vladimir",slot=3,type="Circle",delay=0.25,range=700,radius=175,speed=math.huge,addHitbox=true,danger=4,dangerous=true,proj="nil",killTime=0,displayname = "Hemoplague",mcollision=false},
	["Laser"]={charName="Viktor",slot=2,type="Line",delay=0.25,range=1200,radius=80,speed=1050,addHitbox=true,danger=2,dangerous=false,proj="ViktorDeathRayMissile",killTime=0,displayname="",mcollision=false},
	["xeratharcanopulse2"]={charName="Xerath",slot=0,type="Line",delay=0.6,range=1600,radius=95,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="xeratharcanopulse2",killTime=0,displayname="Arcanopulse",mcollision=false},
	["XerathArcaneBarrage2"]={charName="Xerath",slot=1,type="Circle",delay=0.7,range=1000,radius=200,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="XerathArcaneBarrage2",killTime=0.3,displayname="ArcaneBarrage",mcollision=false},
	["XerathMageSpear"]={charName="Xerath",slot=2,type="Line",delay=0.2,range=1050,radius=60,speed=1400,addHitbox=true,danger=2,dangerous=true,proj="XerathMageSpearMissile",killTime=0,displayname="MageSpear",mcollision=true},
	["xerathrmissilewrapper"]={charName="Xerath",slot=3,type="Circle",delay=0.7,range=5600,radius=130,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="xerathrmissilewrapper",killTime=0.4,displayname="XerathLocusPulse",mcollision=false},
	["yasuoqw"]={charName="Yasuo",slot=0,type="Line",delay=0.4,range=550,radius=20,speed=math.huge,addHitbox=true,danger=2,dangerous=true,proj="yasuoq",killTime=0,displayname="Steel Tempest 1",mcollision=false},
	["yasuoq2"]={charName="Yasuo",slot=0,type="Line",delay=0.4,range=550,radius=20,speed=math.huge,addHitbox=true,danger=2,dangerous=true,proj="yasuoq2",killTime=0,displayname="Steel Tempest 2",mcollision=false},
	["yasuoq3"]={charName="Yasuo",slot=0,type="Line",delay=0.5,range=1200,radius=90,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="yasuoq3w",killTime=0,displayname="Steel Tempest 3",mcollision=false},
	["ZacQ"]={charName="Zac",slot=0,type="Line",delay=0.5,range=550,radius=120,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZacQ",killTime=0,displayname="",mcollision=false},
	["ZedQ"]={charName="Zed",slot=0,type="Line",delay=0.25,range=925,radius=50,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ZedQMissile",killTime=0,displayname="",mcollision=false},
	["ZiggsQ"]={charName="Ziggs",slot=0,type="Line",delay=0.5,range=1100,radius=100,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsQSpell",killTime=0.2,displayname="",mcollision=true},
	["ZiggsW"]={charName="Ziggs",slot=1,type="Circle",delay=0.25,range=1000,radius=275,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsW",killTime=3,displayname="",mcollision=false,killName="ZiggsWToggle"},
	["ZiggsE"]={charName="Ziggs",slot=2,type="Circle",delay=0.5,range=900,radius=235,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsE",killTime=3.25,displayname="",mcollision=false},
	["ZiggsR"]={charName="Ziggs",slot=3,type="Circle",delay=0,range=5300,radius=500,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZiggsR",killTime=1.25,displayname="",mcollision=false},
	["ZileanQ"]={charName="Zilean",slot=0,type="Circle",delay=0.3,range=900,radius=210,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="ZileanQMissile",killTime=1.5,displayname="",mcollision=false},
	["ZyraQ"]={charName="Zyra",slot=0,type="Rectangle",delay=0.25,range=800,radius=140,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZyraQ",killTime=0.3,displayname="",mcollision=false},
	["ZyraE"]={charName="Zyra",slot=2,type="Line",delay=0.25,range=1100,radius=70,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="ZyraE",killTime=0,displayname="Grasping Roots",mcollision=false},
	["ZyraRSplash"]={charName="Zyra",slot=3,type="Circle",delay=0.7,range=700,radius=550,speed=math.huge,addHitbox=true,danger=4,dangerous=false,proj="ZyraRSplash",killTime=1,displayname="Splash",mcollision=false},
}
	
	SLS.SB:Menu("Spells", "Spells")
	SLS.SB:Boolean("uS","Enable",true)
	SLS.SB:Slider("dV","Danger Value",2,1,5,1)
	SLS.SB:Slider("hV","Humanize Value",50,0,100,1)
	SLS.SB:Boolean("EC","Enable Collision", true)
	SLS.SB:KeyBinding("DoD", "DodgeOnlyDangerous", string.byte(" "))
	SLS.SB:KeyBinding("DoD2", "DodgeOnlyDangerous2", string.byte("V"))
	self.object = {}
	self.DoD = false
	self.fT = .75
	self.dt = nil
	self.endposs = nil
    DelayAction(function()
		for l,k in pairs(GetEnemyHeroes()) do
			for _,i in pairs(self.s) do
				if not self.s[_] then return end
				if i.charName == k.charName then
					if i.displayname == "" then i.displayname = _ end
					if i.danger == 0 then i.danger = 1 end
					if not SLS.SB.Spells[_] then SLS.SB.Spells:Menu(_,""..k.charName.." | "..(self.str[i.slot] or "?").." - "..i.displayname) end
						SLS.SB.Spells[_]:Boolean("Dodge".._, "Enable Dodge", true)
						SLS.SB.Spells[_]:Boolean("IsD".._,"Dangerous", i.dangerous or false)		
						SLS.SB.Spells[_]:Info("Empty12".._, "")
						SLS.SB.Spells[_]:Slider("radius".._,"Radius",(i.radius or 150), ((i.radius-50) or 50),((i.radius+100) or 250), 5)
						SLS.SB.Spells[_]:Slider("d".._,"Danger",(i.danger or 1), 1, 5, 1)	
				end
			end
		end
    end, .001)
	Callback.Add("Tick", function() self:Ti() end)
	Callback.Add("ProcessSpell", function(unit, spellProc) self:Detect(unit,spellProc) end)
	Callback.Add("CreateObj", function(obj) self:CreateObj(obj) end)
	Callback.Add("DeleteObj", function(obj) self:DeleteObj(obj) end)
end

function HitMe:Ti()
	if not SLS.SB.uS:Value() then return end
	for _,i in pairs(self.object) do
		if i.o and i.spell.type == "linear" and GetDistance(myHero,i.o) >= 3000 then return end
		if i.p and i.spell.type == "circular" and GetDistance(myHero,i.p.endPos) >= 3000 then return end
		i.spell.speed = i.spell.speed or math.huge
		i.spell.range = i.spell.range or math.huge
		i.spell.proj = i.spell.proj or _
		i.spell.delay = i.spell.delay or 0
		i.spell.radius = i.spell.radius or 100	
		i.spell.mcollision = i.spell.mcollision or false
		i.spell.danger = i.spell.danger or 2
		i.spell.type = i.spell.type or nil
		self.fT = SLS.SB.hV:Value()
		self.YasuoWall = {}
		self:MinionCollision()
		self:WallCollision()
		if SLS.SB.DoD:Value() or SLS.SB.DoD2:Value() then
				self.DoD = true
			else
				self.DoD = false
		end
		for kk,k in pairs(GetEnemyHeroes()) do
			if i.o then
				i.p = {}
				i.p.startPos = Vector(i.o.startPos)
				i.p.endPos = Vector(i.o.endPos)
			end	
			if i.o and not i.o.valid and _ ~= "LuxMaliceCannon" then
				self.object[_] = nil
			end
			if i.p then
				self.dT = i.spell.delay + GetDistance(myHero,i.p.startPos) / i.spell.speed
				self.endposs = Vector(i.p.startPos)+Vector(Vector(i.p.endPos)-i.p.startPos):normalized()*(i.spell.range+i.spell.radius)
			end
			if ((not self.DoD and SLS.SB.dV:Value() <= SLS.SB.Spells[_]["d".._]:Value()) or (self.DoD and SLS.SB.Spells[_]["IsD".._]:Value())) then
				if (i.spell.type == "Line" or i.spell.type == "Cone" or i.spell.type == "Rectangle") and i.p then
						i.p.startPos = Vector(i.p.startPos)
						i.p.endPos = Vector(i.p.endPos)
					if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
						local v3 = Vector(myHero.pos)
						local v4 = Vector(i.p.startPos-i.p.endPos):perpendicular()
						local jp = Vector(VectorIntersection(i.p.startPos,i.p.endPos,v3,v4).x,myHero.pos.y,VectorIntersection(i.p.startPos,i.p.endPos,v3,v4).y)
						i.jp = jp
						if i.coll then return end
						if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius then
							_G[ChampName]:HitMe(k,i.p,self.dT*self.fT*.001,i.type)
						end
					end
				elseif i.spell.type == "Circle" then
					if GetDistance(i.p.endPos) < i.spell.range + myHero.boundingRadius then
						_G[ChampName]:HitMe(k,i.p,self.dT*self.fT*.001,i.type)
					end
				end
			end
		end
	end
end

function HitMe:MinionCollision()
	for _,i in pairs(self.object) do
		if i.spell.type == "Line" and i.spell.mcollision and i.p and SLS.SB.EC:Value() then
			local vI = nil 
			local helperVec = nil
			local cDist = math.huge 			
			local cCreep = {}
			endpos = Vector(i.p.endPos)
			start = Vector(i.p.startPos)
			for m,p in pairs(minionManager.objects) do
				if p and p.alive and p.team ~= MINION_ENEMY and GetDistance(p.pos,start) < i.spell.range then
					helperVec = Vector(endpos - start):perpendicular()
					vI = Vector(VectorIntersection(endpos,start,p.pos,helperVec).x,myHero.pos.y,VectorIntersection(endpos,start,p.pos,helperVec).y)
					if (i.spell.radius and GetDistance(vI,p.pos) < i.spell.radius) or (i.spell.width and GetDistance(vI,p.pos) < i.spell.width) then
						if GetDistance(vI,start) < cDist then
							cDist = GetDistance(start,vI)
						end
					end
				end								
			end
			if cDist < i.spell.range then
				i.p.endPos = vI  
					if not i.coll then
						i.coll = true
					end
			end
		end
	end
end

function HitMe:WallCollision()
	for _,i in pairs(self.object) do
		if i.spell.type == "Line" and i.spell.mcollision and i.p and SLS.SB.EC:Value() then
			local vI = nil 
			local helperVec = nil
			local cDist = math.huge 			
			local cWall = {}
			endpos = Vector(i.p.endPos)
			start = Vector(i.p.startPos)
			if self.YasuoWall then
				for m,p in pairs(self.YasuoWall) do
					if p.obj.spellOwner.team == myHero.team and p.obj and GetDistance(p.obj.pos,start) < i.spell.range then
						helperVec = Vector(endpos - start):perpendicular()
						vI = Vector(VectorIntersection(endpos,start,p.obj.pos,helperVec).x,myHero.pos.y,VectorIntersection(endpos,start,p.obj.pos,helperVec).y)
						if (i.spell.radius and GetDistance(vI,p.obj.pos) < i.spell.radius) or (i.spell.width and GetDistance(vI,p.obj.pos) < i.spell.width) then
							if GetDistance(vI,start) < cDist then
								cDist = GetDistance(start,vI)
							end
						end
					end								
				end
				if cDist < i.spell.range then
					i.p.endPos = vI  
						if not i.coll then
							i.coll = true
						end
				end
			end
		end
	end
end

function HitMe:CreateObj(obj)
	if obj and obj.isSpell and obj.spellOwner.isHero and obj.spellOwner.team == MINION_ENEMY then
		for _,l in pairs(self.s) do
			if obj.spellName:lower():find("attack") then return end
			if self.s[obj.spellName] and SLS.SB.Spells[obj.spellName] and SLS.SB.dV:Value() <= SLS.SB.Spells[obj.spellName]["d"..obj.spellName]:Value() and (l.proj == obj.spellName or _ == obj.spellName or obj.spellName:lower():find(_:lower()) or obj.spellName:lower():find(l.proj:lower())) then
				if not self.object[obj.spellName] then self.object[obj.spellName] = {} end
				self.object[obj.spellName].o = obj
				self.object[obj.spellName].caster = obj.spellOwner.charName
				self.object[obj.spellName].startTime = os.clock()
				self.object[obj.spellName].spell = l
				self.object[obj.spellName].coll = false
			end
		end
	end
	if (obj.spellName == "YasuoWMovingWallR" or obj.spellName == "YasuoWMovingWallL" or obj.spellName == "YasuoWMovingWallMisVis") and obj and obj.isSpell and obj.spellOwner.isHero and obj.spellOwner.team == myHero.team then
		if not self.YasuoWall[obj.spellName] then self.YasuoWall[obj.spellName] = {} end
		self.YasuoWall[obj.spellName].obj = obj
	end
end

function HitMe:Detect(unit,spellProc)
	if unit and unit.isHero and unit.team == MINION_ENEMY then
		for _,l in pairs(self.s) do
			if self.s[spellProc.name] and SLS.SB.Spells[spellProc.name] and SLS.SB.dV:Value() <= SLS.SB.Spells[spellProc.name]["d"..spellProc.name]:Value() and (l.proj == spellProc.name or _ == spellProc.name or spellProc.name:lower():find(_:lower()) or spellProc.name:lower():find(l.proj:lower())) then
				if not self.object[spellProc.name] then self.object[spellProc.name] = {} end
				self.object[spellProc.name].p = spellProc
				self.object[spellProc.name].spell = l
				self.object[spellProc.name].caster = unit
				self.object[spellProc.name].startTime = os.clock()
				self.object[spellProc.name].coll = false
				DelayAction(function() self.object[spellProc.name] = nil end, l.delay*.001 + 1.3*GetDistance(myHero.pos,spellProc.startPos)/l.speed)				
			end
		end
		for _,l in pairs(self.s) do
			if spellProc.target and spellProc.target == myHero and not spellProc.name:lower():find("attack") then
				_G[ChampName]:HitMe(unit,spellProc,((l.delay or 0) + GetDistance(myHero,spellProc.startPos) / (l.speed or math.huge))*SLS.SB.hV:Value()*.001,l.type)
			end
		end
	end
end

function HitMe:DeleteObj(obj)
	if obj and obj.isSpell and self.object[obj.spellName] then
			self.object[obj.spellName] = nil
	end	
	if (obj.spellName == "YasuoWMovingWallR" or obj.spellName == "YasuoWMovingWallL" or obj.spellName == "YasuoWMovingWallMisVis") and obj and obj.isSpell and obj.spellOwner.isHero and obj.spellOwner.team == MINION_ALLY then
		self.YasuoWall[obj.spellName] = nil
	end
end

class 'AntiChannel'

function AntiChannel:__init()
	self.CSpell = {
    ["CaitlynAceintheHole"]         = {charName = "Caitlyn"		,slot="R"},
    ["Crowstorm"]                   = {charName = "FiddleSticks",slot="R"},
    ["Drain"]                       = {charName = "FiddleSticks",slot="W"},
    ["GalioIdolOfDurand"]           = {charName = "Galio"		,slot="R"},
    ["ReapTheWhirlwind"]            = {charName = "Janna"		,slot="R"},
	["JhinR"]						= {charName = "Jhin"		,slot="R"},
    ["KarthusFallenOne"]            = {charName = "Karthus"     ,slot="R"},
    ["KatarinaR"]                   = {charName = "Katarina"    ,slot="R"},
    ["LucianR"]                     = {charName = "Lucian"		,slot="R"},
    ["AlZaharNetherGrasp"]          = {charName = "Malzahar"	,slot="R"},
    ["MissFortuneBulletTime"]       = {charName = "MissFortune"	,slot="R"},
    ["AbsoluteZero"]                = {charName = "Nunu"		,slot="R"},                       
    ["PantheonRJump"]               = {charName = "Pantheon"	,slot="R"},
    ["ShenStandUnited"]             = {charName = "Shen"		,slot="R"},
    ["Destiny"]                     = {charName = "TwistedFate"	,slot="R"},
    ["UrgotSwap2"]                  = {charName = "Urgot"		,slot="R"},
    ["VarusQ"]                      = {charName = "Varus"		,slot="Q"},
    ["VelkozR"]                     = {charName = "Velkoz"		,slot="R"},
    ["InfiniteDuress"]              = {charName = "Warwick"		,slot="R"},
    ["XerathLocusOfPower2"]         = {charName = "Xerath"		,slot="R"},
	}
	
	DelayAction(function ()
		for k,i in pairs(GetEnemyHeroes()) do
			for _,n in pairs(self.CSpell) do
				if i.charName == n.charName then
					if not BM["AC"] then
						BM:Menu("AC","AntiChannel")
						BM.AC:Info("as", "Stop Channels for : ")
						Callback.Add("ProcessSpell", function(unit,spellProc) self:CheckAC(unit,spellProc) end)
					end
					if not BM.AC[_] then
						BM.AC:Boolean(_,n.charName.." | "..n.slot, true)
					end
				end
			end
		end
	end, .001)
end

function AntiChannel:CheckAC(unit,spellProc)
	if GetTeam(unit) == MINION_ENEMY and self.CSpell[spellProc.name] and BM.AC[spellProc.name]:Value() then
		_G[ChampName]:AntiChannel(unit,GetDistance(myHero,unit))
	end
end

class 'AntiGapCloser'

function AntiGapCloser:__init()
	self.GSpells = {
    ["AkaliShadowDance"]            = {charName = "Akali",		slot="R"		},
    ["Headbutt"]                    = {charName = "Alistar",	slot="Q"		},
    ["DianaTeleport"]               = {charName = "Diana",		slot="R"		},
    ["FizzPiercingStrike"]          = {charName = "Fizz",		slot="Q"		},
    ["IreliaGatotsu"]               = {charName = "Irelia",		slot="Q"		},
    ["JaxLeapStrike"]               = {charName = "Jax",		slot="Q"		},
    ["JayceToTheSkies"]             = {charName = "Jayce",		slot="Q"		},
    ["blindmonkqtwo"]               = {charName = "LeeSin",		slot="Q"		},
    ["MonkeyKingNimbus"]            = {charName = "MonkeyKing",	slot="E"		},
    ["Pantheon_LeapBash"]           = {charName = "Pantheon",	slot="W"		},
    ["PoppyHeroicCharge"]           = {charName = "Poppy",		slot="E"		},
    ["QuinnE"]                      = {charName = "Quinn",		slot="E"		},
    ["RengarLeap"]                  = {charName = "Rengar",		slot="Passive"	},
    ["XenZhaoSweep"]                = {charName = "XinZhao",	slot="E"		},
    ["AatroxQ"]                     = {charName = "Aatrox",		slot="Q"		},
    ["GragasE"]                     = {charName = "Gragas",		slot="E"		},
    ["GravesMove"]                  = {charName = "Graves",		slot="E"		},
    ["JarvanIVDragonStrike"]        = {charName = "JarvanIV",	slot="Q"		},
    ["JarvanIVCataclysm"]           = {charName = "JarvanIV",	slot="R"		},
    ["KhazixE"]                     = {charName = "Khazix",		slot="E"		},
    ["khazixelong"]                 = {charName = "Khazix",		slot="E"		},
    ["LeblancSlide"]                = {charName = "Leblanc",	slot="W"		},
    ["LeblancSlideM"]               = {charName = "Leblanc",	slot="W"		},
    ["LeonaZenithBlade"]            = {charName = "Leona",		slot="E"		},
    ["RenektonSliceAndDice"]        = {charName = "Renekton",	slot="E"		},
    ["SejuaniArcticAssault"]        = {charName = "Sejuani",	slot="E"		},
    ["ShenShadowDash"]              = {charName = "Shen",		slot="E"		},
    ["RocketJump"]                  = {charName = "Tristana",	slot="W"		},
    ["slashCast"]                   = {charName = "Tryndamere",	slot="E"		},
	}
	
	DelayAction(function ()
		for k,i in pairs(GetEnemyHeroes()) do
			for _,n in pairs(self.GSpells) do
				if i.charName == n.charName then
					if not BM["AGC"] then
						BM:Menu("AGC","AntiGapCloser")
						BM.AGC:Info("as", "AntiGapCloser for : ")
						Callback.Add("ProcessSpell", function(unit,spellProc) self:CheckAGC(unit,spellProc) end)
					end
					if not BM.AGC[_] then
						BM.AGC:Boolean(_,n.charName.." | "..n.slot, true)
					end
				end
			end
		end
	end, .001)
end

function AntiGapCloser:CheckAGC(unit,spellProc)
	if unit.team == MINION_ENEMY and self.GSpells[spellProc.name] and BM.AGC[spellProc.name]:Value() then
		_G[ChampName]:AntiGapCloser(unit,GetDistance(myHero,unit))
	end
end
