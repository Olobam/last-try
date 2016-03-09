local SLSeries = 0.01
local AutoUpdater = true

require 'Inspired'
require 'OpenPredict'	--SpellShield/HG

local SLSChamps = {	
	["Vayne"] = true,
	-- ["Garen"] = true,
	-- ["Soraka"] = true,
	-- ["DrMundo"] = true,
	-- ["Blitzcrank"] = true,
	-- ["Leona"] = true,
	-- ["Ezreal"] = true,
	-- ["Lux"] = true,
	-- ["Rumble"] = true,
	-- ["Swain"] = true,
	-- ["Thresh"] = true,
	-- ["Kalista"] = true,
	-- ["Poppy"] = true,
	-- ["Nami"] = true,
	-- ["Corki"] = true,
	-- ["KogMaw"] = true,
	-- ["Nasus"] = true,
	-- ["Jinx"] = true,
	["Aatrox"] = true,
}

--Variables

local Name = GetMyHero()
local ChampName = myHero.charName
local Dmg = {}
local SReady = {
	[0] = false,
	[1] = false,
	[2] = false,
	[3] = false,
}

--Functions
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

-- Load
Callback.Add("Load", function()	
	Update()
	Init()
	if SLSChamps[ChampName] and SLS.Loader.LC:Value() then
		_G[ChampName]() 
		PrintChat("<font color=\"#fd8b12\"><b>[SL-Series] - <font color=\"#FFFFFF\">" ..ChampName.." <font color=\"#F2EE00\"> Loaded! </b></font>")
	elseif not SLSChamps[ChampName] then  
		PrintChat("<font color=\"#fd8b12\"><b>[SL-Series] - <font color=\"#FFFFFF\">" ..ChampName.." <font color=\"#F2EE00\"> is not Supported </b></font>")
		PrintChat("<font color=\"#fd8b12\"><b>[SL-Series] - <font color=\"#F2EE00\">Utility Loaded </b></font>")
	end
	if SLS.Loader.LSK:Value() then
		SkinChanger()
	end
	if SLS.Loader.LAL:Value() then
		AutoLevel()
	end
	if SLS.Loader.LI:Value() then
		Items()
	end
	if SLS.Loader.LD:Value() then
		DmgDraw()
	end
	if SLS.Loader.LH:Value() then
		Humanizer()
	end
end)    


class 'Init'

function Init:__init()
	local AntiGapCloser = {}
	local GapCloser = {}
	local MapPositionGOS = {["Vayne"] = true, ["Poppy"] = true,}

	SLS = MenuConfig("SL-Series", "SL-Series")
	SLS:Menu("Loader", "|SL| Loader")
	L = SLS["Loader"]
	L:Boolean("LC", "Load Champion", true)
	L:Info("0.1", "")
	L:Boolean("LD", "Load DmgDraw", true)
	L:Info("0.2", "")
	L:Boolean("LSK", "Load SkinChanger", true)
	L:Info("0.3", "")
	L:Boolean("LAL", "Load AutoLevel", true)
	L:Info("0.4", "")
	L:Boolean("LI", "Load Items", true)
	L:Info("0.5", "")
	L:Boolean("LH", "Load Humanizer", true)
	L:Info("0.6", "")
	L:Info("0.7", "You will have to press 2f6")
	L:Info("0.8", "to apply the changes")

	if L.LC:Value() then
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
		require 'MapPositionGOS'
	end
end
	
---------------------------------------------------------------------------------------------
-------------------------------------CHAMPS--------------------------------------------------
---------------------------------------------------------------------------------------------

----/|----------|\----
---/-|--Vayne---|-\---
--/--|----------|--\--

class 'Vayne'

function Vayne:__init()

	self.Spell = {
	[2] = { delay = 0.25, speed = 2000, width = 1, range = 550 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 5 * GetCastLevel(myHero,0) + 30 + ((GetBaseDamage(myHero) + GetBonusDmg(myHero)) * .5), 0) end,
	[1] = function (unit) return CalcDamage(myHero, unit, 1.5 * GetCastLevel(myHero,1) + 6 * GetMaxHP(unit), 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 35 * GetCastLevel(myHero,2) + 45 + GetBonusDmg(myHero) * .5, 0) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 20 * GetCastLevel(myHero,3) + 30, 0) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Info("1", "")
	BM.C:Boolean("E", "Use E", true)
	BM.C:Slider("a", "accuracy", 30, 1, 50, 5)
	BM.C:Slider("pd", "Push distance", 480, 1, 550, 5)	
	BM.C:Info("2", "")
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	BM.C:Slider("RHP", "myHeroHP ", 75, 1, 100, 5)
	BM.C:Slider("REHP", "EnemyHP ", 65, 1, 100, 5)
	
	BM:Menu("H", "Harass")
	BM.H:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Info("3", "")
	BM.H:Boolean("E", "Use E", true)
	BM.H:Slider("a", "accuracy", 30, 1, 50, 5)
	BM.H:Slider("pd", "Push distance", 480, 1, 550, 5)	
	
	BM:Menu("JC", "JungleClear")
	BM.JC:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Info("4", "")
	BM.JC:Boolean("E", "Use E", true)

	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("ProcessSpellComplete", function(unit, spell) self:AAReset(unit, spell) end)
	
end

function Vayne:Tick()
	if myHero.dead then return end
	
	if (_G.IOW or _G.DAC_Loaded) then
		
		GetReady()
		
		self:KS()
		
		local Mode = nil
		if _G.DAC_Loaded then 
			Mode = DAC:Mode()
		elseif _G.IOW then
			Mode = IOW:Mode()
		end

	    if Mode == "Combo" then
			self:Combo()
		elseif Mode == "Laneclear" then
			self:JungleClear()
		elseif Mode == "Harass" then
			self:Harass()
		else
			return
		end
	end
end

function Vayne:CastE(unit)
	local e = GetPrediction(unit, self.Spell[2])
	local ePos = Vector(e.castPos)
	local c = math.ceil(BM.C.a:Value())
	local cd = math.ceil(BM.C.pd:Value()/c)
	for rekt = 1, c, 1 do
		local PP = Vector(ePos) + Vector(Vector(ePos) - Vector(myHero)):normalized()*(cd*rekt)
			
		if MapPosition:inWall(PP) == true then
			CastTargetSpell(unit, 2)
		end		
	end
end

function Vayne:CastE2(unit)
	local e = GetPrediction(unit, self.Spell[2])
	local ePos = Vector(e.castPos)
	local c = math.ceil(BM.H.a:Value())
	local cd = math.ceil(BM.H.pd:Value()/c)
	for rekt = 1, c, 1 do
		local PP = Vector(ePos) + Vector(Vector(ePos) - Vector(myHero)):normalized()*(cd*rekt)
			
		if MapPosition:inWall(PP) == true then
			CastTargetSpell(unit, 2)
		end		
	end
end

function Vayne:AAReset(unit, spell)
	local ta = spell.target
	if unit == myHero and ta ~= nil and spell.name:lower():find("attack") and SReady[0] then
	  local QPos = Vector(ta) - (Vector(ta) - Vector(myHero)):perpendicular():normalized() * 350
		if IOW:Mode() == "Combo" and BM.C.Q:Value() and ValidTarget(ta, 800) then
			if BM.C.QL:Value() == 1 then
				CastSkillShot(0, QPos)
			elseif BM.C.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif IOW:Mode() == "Harass" and BM.H.Q:Value() and ValidTarget(ta, 800) then
			if BM.H.QL:Value() == 1 then
				CastSkillShot(0, QPos)
			elseif BM.H.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif IOW:Mode() == "LaneClear" and BM.JC.Q:Value() and GetTeam(ta) == MINION_JUNGLE then
			if BM.JC.QL:Value() == 1 then
				CastSkillShot(0, QPos)
			elseif BM.JC.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		end
	end
end

function Vayne:Combo()
	local target = nil
	if _G.DAC_Loaded then
		target = DAC:GetTarget() 
	elseif _G.IOW then
		target = GetCurrentTarget()
	else
		return
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		self:CastE(target)
	end
	if SReady[3] and ValidTarget(target, 800) and BM.C.R:Value() and EnemiesAround(myHero,800) >= BM.C.RE:Value() and GetPercentHP(myHero) < BM.C.RHP:Value() and GetPercentHP(target) < BM.C.REHP:Value() then
		CastSpell(3)
	end
end

function Vayne:Harass()
	local target = nil
	if _G.DAC_Loaded then
		target = DAC:GetTarget() 
	elseif _G.IOW then
		target = GetCurrentTarget()
	else
		return
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
		self:CastE2(target)
	end
end

function Vayne:JungleClear()		--E Wall check?
 for _,mob in pairs(minionManager.objects) do
	if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() and GetTeam(mob) == MINION_JUNGLE then
		self:CastE(mob)
	end
 end
end

function Vayne:KS()
	local target = nil
	if _G.DAC_Loaded then
		target = DAC:GetTarget() 
	elseif _G.IOW then
		target = GetCurrentTarget()
	else
		return
	end
	if SReady[2] and GetADHP(target) < Dmg[2](target) and ValidTarget(target, self.Spell[2].range) then
		CastTargetSpell(target, 2)
	end
end


class "Aatrox"

function Aatrox:__init()
	
	--OpenPred
	self.Spell = { 
	[0] = { delay = 0.2, range = 650, speed = 1500, radius = 113 },
	[2] = { delay = 0.1, range = 1000, speed = 1000, width = 150 }
	}
	
	--SpellDmg
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 35 + GetCastLevel(myHero,0)*45 + GetBonusDmg(myHero)*.6, 0) end,
	[1] = function (unit) return CalcDamage(myHero, unit, 25 + GetCastLevel(myHero,1)*35 + GetBonusDmg(myHero), 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 35 + GetCastLevel(myHero,2)*35 + GetBonusDmg(myHero)*.6 + GetBonusAP(myHero)*.6) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 0, 100 + GetCastLevel(myHero,3)*100 + GetBonusAP(myHero)) end,
	}
	
	--Menu
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Slider("WT", "Toggle W at % HP", 45, 5, 90, 5)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("W", "Use W", true)
	BM.H:Slider("WT", "Toggle W at % HP", 45, 5, 90, 5)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("Q", "Use Q", false)
	BM.KS:Boolean("E", "Use E", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)

	--Callbacks
	Callback.Add("Tick", function() self:Tick() end)
	--Callback.Add("Draw", function self:Draw() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:Stat(unit,buff) end)
	
	--Var
	if GotBuff(myHero, "aatroxwpower") == 1 then
		self.W = "dmg"
	else
		self.W = "heal"
	end
end  

function Aatrox:Tick()
	if myHero.dead then return end
	
	if (_G.IOW or _G.DAC_Loaded) then
		GetReady()
		
		self:KS()
		
		local Mode = nil
		if _G.DAC_Loaded then 
			Mode = DAC:Mode()
		elseif _G.IOW then
			Mode = IOW:Mode()
		end

		if Mode == "Combo" then
			self:Combo()
		--[[elseif Mode == "Laneclear" then
			self:LaneClear()
		elseif Mode == "LastHit" then
			self:LastHit()--]]
		elseif Mode == "Harass" then
			self:Harass()
		else
			return
		end
	end
end


function Aatrox:Combo()

	local target = nil
	if _G.DAC_Loaded then
		target = DAC:GetTarget() 
	elseif _G.IOW then
		target = GetCurrentTarget()
	else
		return
	end
	if SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.C.Q:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[1] and BM.C.W:Value() and ValidTarget(target,750) then
		if GetPercentHP(myHero) < BM.C.WT:Value()+1 and self.W == "dmg" then
			CastSpell(1)
		elseif GetPercentHP(myHero) > BM.C.WT:Value() and self.W == "heal" then
			CastSpell(1)
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

function Aatrox:Harass()
	local target = nil
	if _G.DAC_Loaded then
		target = DAC:GetTarget() 
	elseif _G.IOW then
		target = GetCurrentTarget()
	else
		return
	end
	
	if SReady[2] and ValidTarget(target, self.Spell[2].range*1.1) and BM.H.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	if SReady[1] and BM.H.W:Value() and ValidTarget(target,750) then
		if GetPercentHP(myHero) < BM.H.WT:Value()+1 and self.W == "dmg" then
			CastSpell(1)
		elseif GetPercentHP(myHero) > BM.H.WT:Value() and self.W == "heal" then
			CastSpell(1)
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
	
	
	
	
	
	
	
	
---------------------------------------------------------------------------------------------
-------------------------------------UTILITY-------------------------------------------------
---------------------------------------------------------------------------------------------
--Humanizer
class 'Humanizer'

function Humanizer:__init()

self.bCount = 0
self.lastCommand = 0

	SLS:SubMenu("Hum", "|SL| Humanizer")
	SLS.Hum:Boolean("Draw", "Draw blocked movements", true)
	SLS.Hum:Boolean("enable", "Use Movement Limiter", true)
	SLS.Hum:Slider("lhit", "Last Hit", 6, 1, 20, 1)
	SLS.Hum:Slider("lclear", "Lane Clear", 6, 1, 20, 1)
	SLS.Hum:Slider("harass", "Harass", 7, 1, 20, 1)
	SLS.Hum:Slider("combo", "Combo", 8, 1, 20, 1)
	SLS.Hum:Slider("perm", "Persistant", 7, 1, 20, 1)
	
 Callback.Add("IssueOrder", function(order) self:IssueOrder(order) end)
 Callback.Add("Draw", function() self:Draw() end)
end

function Humanizer:moveEvery()
	if IOW:Mode() == "Combo" then
		return 1 / SLS.Hum.combo:Value()
	elseif IOW:Mode() == "LastHit" then
		return 1 / SLS.Hum.lhit:Value()
	elseif IOW:Mode() == "Harass" then
		return 1 / SLS.Hum.harass:Value()
	elseif IOW:Mode() == "LaneClear" then
		return 1 / SLS.Hum.lclear:Value()
	else
		return 1 / SLS.Hum.perm:Value()
	end
end

function Humanizer:IssueOrder(order)
	if order.flag == 2 and SLS.Hum.enable:Value() and IOW:Mode() ~= nil then
		if os.clock() - self.lastCommand < self:moveEvery() then
		  BlockOrder()
		  self.bCount = self.bCount + 1
		else
		  self.lastCommand = os.clock()
		end
	end
end

function Humanizer:Draw()
	if SLS.Hum.Draw:Value() then
  		DrawText("Blocked Movements : "..tostring(self.bCount),25,50,60,ARGB(255,159,242,12))
	end
end


--AutoLevel
class 'AutoLevel'

function AutoLevel:__init()
	SLS:SubMenu("AL", "|SL| Auto Level")
	SLS.AL:Boolean("aL", "Use AutoLvl", true)
	SLS.AL:DropDown("aLS", "AutoLvL", 1, {"Disabled","Q-W-E","Q-E-W","W-Q-E","W-E-Q","E-Q-W","E-W-Q"})
	SLS.AL:Slider("sL", "Start AutoLvl with LvL x", 4, 1, 18, 1)
	SLS.AL:Boolean("hL", "Humanize LvLUP", true)
	
	--AutoLvl
	self.lTable={
	[1] = {_Q,_W,_E,_Q,_Q,_R,_Q,_W,_Q,_W,_R,_W,_W,_E,_E,_R,_E,_E},
	[2] = {_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W},
	[3] = {_W,_Q,_E,_W,_W,_R,_W,_Q,_W,_Q,_R,_Q,_Q,_E,_E,_R,_E,_E},
	[4] = {_W,_E,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_E,_E,_Q,_Q,_R,_Q,_Q},
	[5] = {_E,_Q,_W,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W},
	[6] = {_E,_W,_Q,_E,_E,_R,_E,_W,_E,_W,_R,_W,_W,_Q,_Q,_R,_Q,_Q},
	}
	
	Callback.Add("Tick", function() self:Do() end)
end

function AutoLevel:Do()
	if SLS.AL.aL:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= SLS.AL.sL:Value() then
		if SLS.AL.hL:Value() and not SLS.AL.aLS:Value() == 1 then
			DelayAction(function() LevelSpell(self.lTable[SLS.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(1,3000))
		else
			LevelSpell(self.lTable[SLS.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
		end
	end
end



--SkinChanger
class 'SkinChanger'

function SkinChanger:__init()

	SLS:SubMenu("S", "|SL| Skin")
	SLS.S:Boolean("uS", "Use Skin", false)
	SLS.S:Slider("sV", "Skin Number", 0, 0, 10, 1)
	
	local cSkin = 0
	
	Callback.Add("Tick", function() self:Change() end)
end

function SkinChanger:Change()
	if SLS.S.uS:Value() and SLS.S.sV:Value() ~= cSkin then
		HeroSkinChanger(myHero,SLS.S.sV:Value()) 
		cSkin = SLS.S.sV:Value()
	end
end



--Items
class 'Items'

function Items:__init()

	SLS:SubMenu("I", "|SL| Items")
	SLS.I:Boolean("uI", "Use Items", true)
	SLS.I:Boolean("uAD", "Use AD Items", true)
	SLS.I:Boolean("uAA", "Use AA Reset Items", true)
	SLS.I:Boolean("uAP", "Use AP Items", true)
	SLS.I:Boolean("uTA", "Use Tank Items", true)
	SLS.I:Boolean("uDE", "Use Defensive Items (self)", true)
	SLS.I:Slider("uDEP", "Use Defensive a % HP (self)", 20, 5, 90, 5)
	SLS.I:Boolean("uADE", "Use Defensive Items (allies)", true)
	SLS.I:Slider("uADEP", "Use Defensive a % HP (allies)", 20, 5, 90, 5)
	SLS.I:Boolean("uCIS", "Use Cleanse Items (self)", true)
	SLS.I:Boolean("uCIA", "Use Cleanse Items (allies)", true)
	
	
	self.AD = {3144,3153,3142}
	self.AA = {3077,3074,3748}
	self.AP = {3146,3092,3290}
	self.DE = {3040,3048}
	self.ADE = {3401,3222,3190}
	self.CC = {3139,3140,3137}
	self.TA = {3143,3800}
	self.Banner = 3060
	--self.HG = soon
	self.CCType = { 5, 8, 11, 21, 22, 24 }
	
	Callback.Add("Tick", function() self:Use() end)
	Callback.Add("ProcessSpellAttack", function(Object,spellProc) self:AAReset(Object,spellProc) end)
	Callback.Add("UpdateBuff", function(unit, buff) self:UpdateBuff(unit, buff) end)
	Callback.Add("RemoveBuff" ,function(unit, buff) self:RemoveBuff(unit, buff) end)
	
end


function Items:Use()

	if not SLS.I.uI then return end
	
	local target = nil
	if _G.DAC_Loaded then
		target = DAC:GetTarget() 
	elseif _G.IOW then
		target = GetCurrentTarget()
	else
		return
	end
	
	if ValidTarget(target,550) and SLS.I.uAD:Value() then
		for i = 1,#self.AD do
			local l = GetItemSlot(myHero,self.AD[i])
			if l>0 and CanUseSpell(myHero,l) == READY then
				CastTargetSpell(target,l)
			end
		end
	end
	
	if ValidTarget(target,500) and SLS.I.uTA:Value() then
		for i = 1,#self.TA do
			local l = GetItemSlot(myHero,self.TA[i])
			if l>0 and CanUseSpell(myHero,l) == READY then
				CastSpell(target,l)
			end
		end
	end
	
	if ValidTarget(target,700) and SLS.I.uAP:Value() then
		for i = 1,#self.AP do
			local l = GetItemSlot(myHero,self.AP[i])
			if l>0 and CanUseSpell(myHero,l) == READY then
				CastTargetSpell(target,l)
			end
		end
	end
	
	if GetPercentHP(myHero) < SLS.I.uDEP:Value() and SLS.I.uDE:Value() and EnemiesAround(myHero,800) > 0 then
		for i = 1,#self.DE do
			local l = GetItemSlot(myHero,self.DE[i])
			if l>0 and CanUseSpell(myHero,l) == READY then
				CastSpell(l)
			end
		end
	end
	
	if SLS.I.uDEP:Value() then
		for _,n in pairs(GetAllyHeroes()) do
			if GetPercentHP(n) <= SLS.I.uADEP:Value() and EnemiesAround(n,800) > 0 then 
				for i = 1,#self.ADE do
					local l = GetItemSlot(myHero,self.ADE[i])
					if l>0 and CanUseSpell(myHero,l) == READY then
						CastSpell(l)
					end
				end
			end
		end
	end
	
	if GetPercentHP(myHero) < SLS.I.uDEP:Value() and CC and SLS.I.uDE:Value() and EnemiesAround(myHero,800) > 0 then
		for i = 1,#self.CC do
			local l = GetItemSlot(myHero,self.CC[i])
			if l>0 and CanUseSpell(myHero,l) == READY and CC then
				CastSpell(l)
			end
		end
	end
	
    for _,n in pairs(GetAllyHeroes()) do
	    if GetPercentHP(n) <= SLS.I.uADEP:Value() and GetDistance(n,myHero) < 550 and aCC and SLS.I.uDE:Value() and EnemiesAround(n,800) > 0 then
			local l = GetItemSlot(myHero,3222)
			if l>0 and CanUseSpell(myHero,l) == READY and aCC then
				CastTargetSpell(n,l)
			end
	    end
    end		
end

function Items:AAReset(Object,spellProc)
	local ta = spellProc.target
	if SLS.I.uAA:Value() and Object == myHero and GetObjectType(ta) == Obj_AI_Hero and GetTeam(ta) == MINION_ENEMY then
		for i = 1,#self.AA do
			local l = GetItemSlot(myHero,self.AA[i])
			if l>0 and CanUseSpell(myHero,l) == READY then
				CastSpell(l)
			end 
		end
	end
end


function Items:UpdateBuff(unit, buff)
	if unit == myHero and SLS.I.uCIS:Value() then
		for i = 1, #self.CCType do
			if buff.Type == self.CCType[i] then
				CC = true
			elseif buff.Name == "zedultexecute" then
				CC = true
			elseif buff.Name == "summonerexhaust" then
				CC = true
			end
		end
	end
	if SLS.I.uCIA:Value() then
		for _, ally in pairs(GetAllyHeroes()) do
			if unit == ally then
				for i = 1, #self.CCType do
					if buff.Type == self.CCType[i] then
						aCC = true
					elseif buff.Name == "zedultexecute" then
						aCC = true
					elseif buff.Name == "summonerexhaust" then
						aCC = true
					end
				end
			end
		end
	end
end

function Items:RemoveBuff(unit, buff)
	if unit == myHero and SLS.I.uCIS:Value() then
		for i = 1, #self.CCType do
			if buff.Type == self.CCType[i] then
				CC = false
			elseif buff.Name == "zedultexecute" then
				CC = false
			elseif buff.Name == "summonerexhaust" then
				CC = false
			end
		end
	end
	if SLS.I.uCIA:Value() then
		for _, ally in pairs(GetAllyHeroes()) do
			if unit == ally then
				for i = 1, #self.CCType do
					if buff.Type == self.CCType[i] then
						aCC = false
					elseif buff.Name == "zedultexecute" then
						aCC = false
					elseif buff.Name == "summonerexhaust" then
						aCC = false
					end
				end
			end
		end
	end
end


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
	end, 0.001)
end

function DmgDraw:Set()
	for _,champ in pairs(GetEnemyHeroes()) do
		self.dCheck[GetObjectName(champ)]={false,false,false,false}
		local last = GetPercentHP(champ)*1.04
		local lock = false
		for i=1,4,1 do
			if SLS.D[self.spellName[i]] and SLS.D[self.spellName[i]]:Value() and Ready(i-1) and GetDistance(GetOrigin(myHero),GetOrigin(champ)) < SLS.D.dR:Value() then
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
