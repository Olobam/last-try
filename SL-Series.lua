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

-----/|----------|\----
----/-|--Vayne---|-\---
---/--|----------|--\--

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
  for _,target in pairs(GetEnemyHeroes()) do
	if SReady[2] and GetADHP(target) < Dmg[2](target) and ValidTarget(target, self.Spell[2].range) then
		CastTargetSpell(target, 2)
	end
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
	SLS.Hum:Info("xcxsycxcw", "")
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


class 'HitMe'


function HitMe:__init()
	SLS:SubMenu("SB","|SL| Spellblock")
	
	if Name == "Sivir" or "Morgana" then 
		SLS.SB:Boolean("uS","Use Spellshield",true) 
		SLS.SB:Slider("dV","Danger Value",2,1,5,1)
		self.Slot = 2
	elseif Name == "Nocturne" then
		SLS:Boolean("uS","Use Hourglass",true) 
		SLS:Slider("dV","Danger Value",5,1,5,1)
		self.Slot = 1
	elseif GetItemSlot(myHero,3157)>0 or GetItemSlot(myHero,3090)>0 then
		self.Slot = function() return (GetItemSlot(myHero,3157)>0 or GetItemSlot(myHero,3090)>0) end
	end
	
	SLS.SB:Slider("hV","Humanize Value",50,0,100,1)
	SLS.SB:Slider("wM","Width Mulitplicator",1.5,1,5,.1)

	self.multi = 2
	self.fT = .75
	CollP = Vector(0,0,0)
	
	
	Callback.Add("ProcessSpell", function(unit, spellProc) self:Detect(unit, spellProc) end)
	
	self.s = {
	
		["Aatrox"] = {
			[_Q] = { displayname = "Dark Flight", name = "AatroxQ", speed = 450, delay = 0.25, range = 650, width = 285, collision = false, aoe = true, type = "circular" , danger = 3},
			[_E] = { displayname = "Blades of Torment", name = "AatroxE", objname = "AatroxEConeMissile", speed = 1250, delay = 0.25, range = 1075, width = 35, collision = false, aoe = false, type = "linear", danger = 1}
		},
		["Ahri"] = {
			[_Q] = { displayname = "Orb of Deception", name = "AhriOrbofDeception", objname = "AhriOrbMissile", speed = 2500, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Orb Return", name = "AhriOrbReturn", objname = "AhriOrbReturn", speed = 1900, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Charm", name = "AhriSeduce", objname = "AhriSeduceMissile", speed = 1550, delay = 0.25, range = 1000, width = 60, collision = true, aoe = false, type = "linear", danger = 4},
		},
		["Akali"] = {
			[_E] = { displayname = "Crescent Slash", name = "CrescentSlash", speed = math.huge, delay = 0.125, range = 0, width = 325, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Alistar"] = {
			[_Q] = { displayname = "Pulverize", name = "Pulverize", speed = math.huge, delay = 0.25, range = 0, width = 365, collision = false, aoe = true, type = "circular", danger = 4}
		},
		["Amumu"] = {
			[_Q] = { displayname = "Bandage Toss", name = "BandageToss", objname = "SadMummyBandageToss", speed = 725, delay = 0.25, range = 1000, width = 100, collision = true, aoe = false, type = "linear", danger = 4}
		},
		["Anivia"] = {
			[_Q] = { displayname = "Flash Frost", name = "FlashFrostSpell", objname = "FlashFrostSpell", speed = 850, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear", danger = 3},
			[_R] = { displayname = "Glacial Storm", name = "GlacialStorm", speed = math.huge, delay = math.huge, range = 615, width = 350, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Annie"] = {
			[_Q] = { name = "Disintegrate", danger = 2},
			[_W] = { displayname = "Incinerate", name = "Incinerate", speed = math.huge, delay = 0.25, range = 625, width = 250, collision = false, aoe = true, type = "cone", danger = 3},
			[_R] = { displayname = "Tibbers", name = "InfernalGuardian", speed = math.huge, delay = 0.25, range = 600, width = 300, collision = false, aoe = true, type = "circular", ranger = 5}
		},
		["Ashe"] = {
			[_W] = { displayname = "Volley", name = "Volley", objname = "VolleyAttack", speed = 902, delay = 0.25, range = 1200, width = 100, collision = true, aoe = false, type = "cone", danger = 2},
			[_R] = { displayname = "Enchanted Crystal Arrow", name = "EnchantedCrystalArrow", objname = "EnchantedCrystalArrow", speed = 1600, delay = 0.5, range = 25000, width = 100, collision = true, aoe = false, type = "linear", danger = 5}
		},
		["Azir"] = {
			[_Q] = { displayname = "Conquering Sands", name = "AzirQ", speed = 2500, delay = 0.250, range = 880, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "Shifting Sands", name = "AzirE", range = 1100, delay = 0.25, speed = 1200, width = 60, collision = true, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "Emperor's Divide", name = "AzirR", speed = 1300, delay = 0.2, range = 520, width = 600, collision = false, aoe = true, type = "linear", danger = 4}
		},
		["Bard"] = {
			[_Q] = { displayname = "Cosmic Binding", name = "BardQ", objname = "BardQMissile", speed = 1100, delay = 0.25, range = 850, width = 108, collision = true, aoe = false, type = "linear", danger = 3},
			[_R] = { displayname = "Tempered Fate", name = "BardR", objname = "BardR", speed = 2100, delay = 0.5, range = 3400, width = 350, collision = false, aoe = false, type = "circular", danger = 4}
		},
		["Blitzcrank"] = {
			[_Q] = { displayname = "Rocket Grab", name = "RocketGrab", objname = "RocketGrabMissile", speed = 1800, delay = 0.250, range = 900, width = 70, collision = true, type = "linear", danger = 4},
			[_R] = { displayname = "Static Field", name = "StaticField", speed = math.huge, delay = 0.25, range = 0, width = 500, collision = false, aoe = false, type = "circular", danger = 3}
		},
		["Brand"] = {
			[_Q] = { displayname = "Sear", name = "BrandBlaze", objname = "BrandBlazeMissile", speed = 1200, delay = 0.25, range = 1050, width = 80, collision = false, aoe = false, type = "linear", danger = 3},
			[_W] = { displayname = "Pillar of Flame", name = "BrandFissure", speed = math.huge, delay = 0.625, range = 1050, width = 275, collision = false, aoe = false, type = "circular", danger = 2},
			[_E] = { displayname = "Conflagration", name = "Conflagration", range = 625, danger = 1},
			[_R] = { displayname = "Pyroclasm", name = "BrandWildfire", range = 750, danger = 4}
		},
		["Braum"] = {
			[_Q] = { displayname = "Winter's Bite", name = "BraumQ", objname = "BraumQMissile", speed = 1600, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_R] = { displayname = "Glacial Fissure", name = "BraumR", objname = "braumrmissile", speed = 1250, delay = 0.5, range = 1250, width = 0, collision = false, aoe = false, type = "linear", danger = 5}
		},
		["Caitlyn"] = {
			[_Q] = { displayname = "Piltover Peacemaker", name = "CaitlynPiltoverPeacemaker", objname = "CaitlynPiltoverPeacemaker", speed = 2200, delay = 0.625, range = 1300, width = 0, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "90 Caliber Net", name = "CaitlynEntrapment", objname = "CaitlynEntrapmentMissile",speed = 2000, delay = 0.400, range = 1000, width = 80, collision = false, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "Ace in the Hole", name = "CaitlynAceintheHole", danger = 4}
		},
		["Cassiopeia"] = {
			[_Q] = { displayname = "Noxious Blast", name = "CassiopeiaNoxiousBlast", objname = "CassiopeiaNoxiousBlast", speed = math.huge, delay = 0.75, range = 850, width = 100, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { displayname = "Miasma", name = "CassiopeiaMiasma", speed = 2500, delay = 0.5, range = 925, width = 90, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { displayname = "Twin Fang", name = "CassiopeiaTwinFang", range = 700, danger = 2},
			[_R] = { displayname = "Petrifying Gaze", name = "CassiopeiaPetrifyingGaze", objname = "CassiopeiaPetrifyingGaze", speed = math.huge, delay = 0.5, range = 825, width = 410, collision = false, aoe = true, type = "cone", danger = 5}
		},
		["Chogath"] = {
			[_Q] = { displayname = "Rupture", name = "Rupture", objname = "Rupture", speed = math.huge, delay = 0.25, range = 950, width = 300, collision = false, aoe = true, type = "circular", danger = 3},
			[_W] = { displayname = "Feral Scream", name = "FeralScream", speed = math.huge, delay = 0.5, range = 650, width = 275, collision = false, aoe = false, type = "linear", danger = 2},
		},
		["Corki"] = {
			[_Q] = { displayname = "Phosphorus Bomb", name = "PhosphorusBomb", objname = "PhosphorusBombMissile", speed = 700, delay = 0.4, range = 825, width = 250, collision = false, aoe = false, type = "circular", danger = 2},
			[_R] = { displayname = "Missile Barrage", name = "MissileBarrage", objname = "MissileBarrageMissile", speed = 2000, delay = 0.200, range = 1300, width = 60, collision = false, aoe = false, type = "linear",danger = 2},
			[4]  = { displayname = "Missile Barrage Big", name = "MissileBarrageBig", objname = "MissileBarrageMissile2", speed = 2000, delay = 0.200, range = 1500, width = 80, collision = false, aoe = false, type = "linear", danger = 3},
		},
		["Darius"] = {
			[_Q] = { displayname = "Decimate", name = "DariusCleave", objname = "DariusCleave", speed = math.huge, delay = 0.75, range = 450, width = 450, type = "circular", danger = 3},
			[_W] = { displayname = "Crippling Strike", name = "DariusNoxianTacticsONH", range = 275, danger = 2},
			[_E] = { displayname = "Apprehend", name = "DariusAxeGrabCone", objname = "DariusAxeGrabCone", speed = math.huge, delay = 0.32, range = 570, width = 125, danger = 4},
			[_R] = { displayname = "Noxian Guillotine", name = "DariusExecute", range = 460, danger = 4}
		},
		["Diana"] = {
			[_Q] = { displayname = "Crescent Strike", name = "DianaArc", objname = "DianaArcArc", speed = 1500, delay = 0.250, range = 835, width = 130, collision = false, aoe = false, type = "circular", danger = 3},
			[_W] = { displayname = "Pale Cascade", name = "PaleCascade", range = 250, danger = 1},
			[_E] = { displayname = "Moonfall", name = "DianaVortex", speed = math.huge, delay = 0.33, range = 0, width = 395, collision = false, aoe = false, type = "circular", danger = 3},
			[_R] = { displayname = "Lunar Rush", name = "LunarRush", range = 825, danger = 4}
		},
		["DrMundo"] = {
			[_Q] = { displayname = "Infected Cleaver", name = "InfectedCleaverMissile", objname = "InfectedCleaverMissile", speed = 2000, delay = 0.250, range = 1050, width = 75, collision = true, aoe = false, type = "linear", danger = 2}
		},
		["Draven"] = {
			[_E] = { displayname = "Stand Aside", name = "DravenDoubleShot", objname = "DravenDoubleShotMissile", speed = 1400, delay = 0.250, range = 1100, width = 130, collision = false, aoe = false, type = "linear", danger = 3},
			[_R] = { displayname = "Whirling Death", name = "DravenRCast", objname = "DravenR", speed = 2000, delay = 0.5, range = 25000, width = 160, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Ekko"] = {
			[_Q] = { displayname = "Timewinder", name = "EkkoQ", objname = "ekkoqmis", speed = 1050, delay = 0.25, range = 925, width = 140, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Parallel Convergence", name = "EkkoW", objname = "EkkoW", speed = math.huge, delay = 2.5, range = 1600, width = 450, collision = false, aoe = true, type = "circular", danger = 3},
			[_E] = { displayname = "Phase Dive", name = "EkkoE", delay = 0.50, range = 350, danger = 1},
			--[_R] = { displayname = "Chronobreak", name = "EkkoR", objname = "EkkoR", speed = math.huge, delay = 0.5, range = 0, width = 400, collision = false, aoe = true, type = "circular", danger = 5}
		},
		["Elise"] = {
			[_E] = { displayname = "Cocoon", name = "EliseHumanE", objname = "EliseHumanE", speed = 1450, delay = 0.250, range = 975, width = 70, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["Evelynn"] = {
			[_R] = { displayname = "Agony's Embrace", name = "EvelynnR", objname = "EvelynnR", speed = 1300, delay = 0.250, range = 650, width = 350, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Ezreal"] = {
			[_Q] = { displayname = "Mystic Shot", name = "EzrealMysticShot", objname = "EzrealMysticShotMissile", speed = 2000, delay = 0.25, range = 1200, width = 65, collision = true, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Essence Flux", name = "EzrealEssenceFlux", objname = "EzrealEssenceFluxMissile", speed = 1200, delay = 0.25, range = 900, width = 90, collision = false, aoe = false, type = "linear", danger = 1},
			--[_E] = { displayname = "Arcane Shift", name = "EzrealArcaneShift", range = 450},
			[_R] = { displayname = "Trueshot Barrage", name = "EzrealTrueshotBarrage", objname = "EzrealTrueshotBarrage", speed = 2000, delay = 1, range = 25000, width = 180, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Fiddlesticks"] = {
			[_Q] = { displayname = "Terrify", name = "Terrify", speed = math.huge, delay = 0.1, range = 575 , width = 65, collision = false, aoe = false, danger = 2},
		},
		["Fiora"] = {
		},
		["Fizz"] = {
			[_R] = { displayname = "Chum the Waters", name = "FizzMarinerDoom", objname = "FizzMarinerDoomMissile", speed = 1350, delay = 0.250, range = 1150, width = 100, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Galio"] = {
			[_Q] = { displayname = "Resolute Smite", name = "GalioResoluteSmite", objname = "GalioResoluteSmite", speed = 1300, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular", danger = 3},
			[_E] = { displayname = "Righteous Gust", name = "GalioRighteousGust", speed = 1200, delay = 0.25, range = 1000, width = 200, collision = false, aoe = false, type = "linear", danger = 1}
		},
		["Gangplank"] = {
			[_Q] = { displayname = "Parrrley", name = "GangplankQWrapper", range = 900, danger = 2},
			--[_E] = { displayname = "Powder Keg", name = "GangplankE", speed = math.huge, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular", danger = },
			[_R] = { displayname = "Cannon Barrage", name = "GangplankR", speed = math.huge, delay = 0.25, range = 25000, width = 575, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Garen"] = {
			[_Q] = { displayname = "Demacian Justice", name = "GarenR", range = 400, danger = 4},
		},
		["Gnar"] = {
			[_Q] = { displayname = "Boomerang Throw", name = "GnarQ", objname = "gnarqmissile", speed = 1225, delay = 0.125, range = 1200, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Boomerang Throw Return", name = "GnarQReturn", objname = "GnarQMissileReturn", speed = 1225, delay = 0, range = 2500, width = 75, collision = false, aoe = false, type = "linear", danger = 2},
			[-2] = { displayname = "Boulder Toss", name = "GnarBigQ", speed = 2100, delay = 0,5, range = 2500, width = 90, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Wallop", name = "GnarBigW", objname = "GnarBigW", speed = math.huge, delay = 0.6, range = 600, width = 80, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Hop", name = "GnarE", objname = "GnarE", speed = 900, delay = 0, range = 475, width = 150, collision = false, aoe = false, type = "circular", danger = 1},
			[-5] = { displayname = "Crunch", name = "gnarbige", speed = 800, delay = 0, range = 475, width = 100, collision = false, aoe = false, type = "circular", danger = 2},
			[_R] = { displayname = "GNAR!", name = "GnarR", speed = math.huge, delay = 250, range = 500, width = 500, collision = false, aoe = false, type = "circular", danger = 5}
		},
		["Gragas"] = {
			[_Q] = { displayname = "Barrel Roll", name = "GragasQ", objname = "GragasQMissile", speed = 1000, delay = 0.250, range = 1000, width = 300, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { displayname = "Body Slam", name = "GragasE", objname = "GragasE", speed = math.huge, delay = 0.250, range = 600, width = 50, collision = true, aoe = true, type = "circular", danger = 3},
			[_R] = { displayname = "Explosive Cask", name = "GragasR", objname = "GragasRBoom", speed = 1000, delay = 0.250, range = 1050, width = 400, collision = false, aoe = true, type = "circular", danger = 4}
		},
		["Graves"] = {
			[_Q] = { displayname = "End of the Line", name = "GravesQLineSpell", objname = "GravesQLineMis", speed = 1950, delay = 0.265, range = 750, width = 85, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Smoke Screen", name = "GravesSmokeGrenade", speed = 1650, delay = 0.300, range = 700, width = 250, collision = false, aoe = true, type = "circular", danger = 1},
			[_R] = { displayname = "Collateral Damage", name = "GravesChargeShot", objname = "GravesChargeShotShot", speed = 2100, delay = 0.219, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Hecarim"] = {
			[_Q] = { displayname = "Rampage", name = "HecarimRapidSlash", speed = math.huge, delay = 0.250, range = 0, width = 350, collision = false, aoe = true, type = "circular", danger = 2},
			[_R] = { displayname = "Onslaught of Shadows", name = "HecarimUlt", speed = 1900, delay = 0.219, range = 1000, width = 200, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Heimerdinger"] = {
		--	[_Q] = { displayname = "H-28G Evolution Turret", name = "HeimerdingerTurretEnergyBlast", speed = 1650, delay = 0.25, range = 1000, width = 50, collision = false, aoe = false, type = "linear", danger = 0},
		--	[-1] = { displayname = "H-28Q Apex Turret", name = "HeimerdingerTurretBigEnergyBlast", speed = 1650, delay = 0.25, range = 1000, width = 75, collision = false, aoe = false, type = "linear"},
			[_W] = { displayname = "Hextech Micro-Rockets", name = "Heimerdingerwm", objname = "HeimerdingerWAttack2", speed = 1800, delay = 0.25, range = 1500, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "CH-2 Electron Storm Grenade", name = "HeimerdingerE", objname = "HeimerdingerESpell", speed = 1200, delay = 0.25, range = 925, width = 100, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Irelia"] = {
			[_E] = { displayname = "Irelia E", name = "IreliaEquilibriumStrike", danger = 3},
			[_R] = { displayname = "Transcendent Blades", name = "IreliaTranscendentBlades", objname = "IreliaTranscendentBlades", speed = 1700, delay = 0.250, range = 1200, width = 25, collision = false, aoe = false, type = "linear", danger = 1}
		},
		["Janna"] = {
			[_Q] = { displayname = "Howling Gale", name = "HowlingGale", objname = "HowlingGaleSpell", speed = 1500, delay = 0.250, range = 1700, width = 150, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["JarvanIV"] = {
			[_Q] = { displayname = "Dragon Strike", name = "JarvanIVDragonStrike", speed = 1400, delay = 0.25, range = 770, width = 70, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Demacian Standard", name = "JarvanIVDemacianStandard", objname = "JarvanIVDemacianStandard", speed = 1450, delay = 0.25, range = 850, width = 175, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Jax"] = {
			[_E] = { displayname = "Counter Strike", name = "", speed = math.huge, delay = 0.250, range = 0, width = 375, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Jayce"] = {
			[_Q] = { displayname = "Shock Blast", name = "jayceshockblast", objname = "JayceShockBlastMis", speed = 1450, delay = 0.15, range = 1750, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Shock Blast Acceleration", name = "JayceQAccel", objname = "JayceShockBlastWallMis", speed = 2350, delay = 0.15, range = 1300, width = 70, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["Jinx"] = {
			[_W] = { displayname = "Zap!", name = "JinxW", objname = "JinxWMissile", speed = 3000, delay = 0.600, range = 1400, width = 60, collision = true, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Flame Chompers!", name = "JinxE", speed = 887, delay = 0.500, range = 830, width = 0, collision = false, aoe = true, type = "circular", danger = 3},
			[_R] = { displayname = "Super Mega Death Rocket!", name = "JinxR", objname = "JinxR", speed = 1700, delay = 0.600, range = 20000, width = 140, collision = false, aoe = true, type = "linear", danger = 4}
		},
		["Kalista"] = {
			[_Q] = { displayname = "Pierce", name = "KalistaMysticShot", objname = "kalistamysticshotmis", speed = 1700, delay = 0.25, range = 1150, width = 40, collision = true, aoe = false, type = "linear", danger = 2},
		},
		["Karma"] = {
			[_Q] = { displayname = "Inner Flame", name = "KarmaQ", objname = "KarmaQMissile", speed = 1700, delay = 0.25, range = 1050, width = 60, collision = true, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Soulflare", name = "KarmaQMantra", objname = "KarmaQMissileMantra", speed = 1700, delay = 0.25, range = 950, width = 80, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["Karthus"] = {
			[_Q] = { displayname = "Lay Waste", name = "KarthusLayWaste", speed = math.huge, delay = 0.775, range = 875, width = 160, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { displayname = "Wall of Pain", name = "KarthusWallOfPain", speed = math.huge, delay = 0.25, range = 1000, width = 160, collision = false, aoe = true, type = "circular", danger = 1},
			--[_E] = { displayname = "Defile", name = "KarthusDefile", speed = math.huge, delay = 0.25, range = 550, width = 550, collision = false, aoe = true, type = "circular"},
			[_R] = { displayname = "Requiem", name = "KarthusFallenOne", range = math.huge, delay = 3, danger = 5}
		},
		["Kassadin"] = {
			[_E] = { displayname = "ForcePulse", name = "ForcePulse", speed = 2200, delay = 0.25, range = 650, width = 80, collision = false, aoe = false, type = "cone", danger = 3},
			[_R] = { displayname = "Riftwalk", name = "RiftWalk", objname = "RiftWalk", speed = math.huge, delay = 0.5, range = 500, width = 150, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Katarina"] = {
		},
		["Kayle"] = {
		},
		["Kennen"] = {
			[_Q] = { displayname = "Thundering Shuriken", name = "KennenShurikenHurlMissile1", speed = 1700, delay = 0.180, range = 1050, width = 70, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["KhaZix"] = {
			[_W] = { displayname = "Void Spike", name = "KhazixW", objname = "KhazixWMissile", speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[-7] = { displayname = "Evolved Void Spike", name = "khazixwlong", objname = "KhazixWMissile", speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "Leap", name = "KhazixE", objname = "KhazixE", speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular", danger = 1},
			[-5] = { displayname = "Evolved Leap", name = "KhazixE", objname = "KhazixE", speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["KogMaw"] = {
			[_Q] = { displayname = "Caustic Spittle", name = "KogMawQ", objname = "KogMawQ", speed = 1600, delay = 0.25, range = 975, width = 80, type = "linear", danger = 2},
			[_E] = { displayname = "Void Ooze", name = "KogMawVoidOoze", objname = "KogMawVoidOozeMissile", speed = 1200, delay = 0.25, range = 1200, width = 120, collision = false, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "Living Artillery", name = "KogMawLivingArtillery", objname = "KogMawLivingArtillery", speed = math.huge, delay = 1.1, range = 2200, width = 250, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["LeBlanc"] = {
			[_Q] = { displayname = "Sigil of Malice", range = 700, danger = 3},
			[_W] = { displayname = "Distortion", name = "LeblancSlide", objname = "LeblancSlide", speed = 1300, delay = 0.250, range = 600, width = 250, collision = false, aoe = false, type = "circular", danger = 2},
			[_E] = { displayname = "Ethereal Chains", name = "LeblancSoulShackle", objname = "LeblancSoulShackle", speed = 1300, delay = 0.250, range = 950, width = 55, collision = true, aoe = false, type = "linear", danger = 3},
			[_R] = { displayname = "Mimic", range = 700, danger = 3}
		},
		["LeeSin"] = {
			[_Q] = { displayname = "Sonic Wave", name = "BlindMonkQOne", objname = "BlindMonkQOne", speed = 1750, delay = 0.25, range = 1000, width = 70, collision = true, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Tempest", name = "BlindMonkEOne", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = false, type = "circular", danger = 2},
			[_R] = { displayname = "Intervention", name = "Dragon's Rage", speed = 2000, delay = 0.25, range = 375, width = 150, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Leona"] = {
			[_E] = { displayname = "Zenith Blade", name = "LeonaZenithBlade", objname = "LeonaZenithBladeMissile", speed = 2000, delay = 0.250, range = 875, width = 80, collision = false, aoe = false, type = "linear", danger = 3},
			[_R] = { displayname = "Solar Flare", name = "LeonaSolarFlare", objname = "LeonaSolarFlare", speed = 2000, delay = 0.250, range = 1200, width = 300, collision = false, aoe = true, type = "circular", danger = 4}
		},
		["Lissandra"] = {
			[_Q] = { displayname = "Ice Shard", name = "LissandraQ", objname = "LissandraQMissile", speed = 2200, delay = 0.25, range = 700, width = 75, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Ice Shard Shattered", name = "LissandraQShards", objname = "lissandraqshards", speed = 2200, delay = 0.25, range = 700, width = 90, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "Glacial Path", name = "LissandraE", objname = "LissandraEMissile", speed = 850, delay = 0.25, range = 1025, width = 125, collision = false, aoe = false, type = "linear", danger = 2},
		},
		["Lucian"] = {
			[_Q] = { displayname = "Piercing Light", name = "LucianQ", objname = "LucianQ", speed = math.huge, delay = 0.5, range = 1300, width = 65, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Ardent Blaze", name = "LucianW", objname = "lucianwmissile", speed = 800, delay = 0.3, range = 1000, width = 80, collision = true, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "The Culling", name = "LucianRMis", objname = "lucianrmissileoffhand", speed = 2800, delay = 0.5, range = 1400, width = 110, collision = true, aoe = false, type = "linear", danger = 2},
			[-6] = { displayname = "The Culling 2", name = "LucianRMis", objname = "lucianrmissile", speed = 2800, delay = 0.5, range = 1400, width = 110, collision = true, aoe = false, type = "linear", danger = 2}
		},
		["Lulu"] = {
			[_Q] = { displayname = "Glitterlance", name = "LuluQ", objname = "LuluQMissile", speed = 1500, delay = 0.25, range = 950, width = 60, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Glitterlance (Pix)", name = "LuluQPix", objname = "LuluQMissileTwo", speed = 1450, delay = 0.25, range = 950, width = 60, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Lux"] = {
			[_Q] = { displayname = "Light Binding", name = "LuxLightBinding", objname = "LuxLightBindingMis", speed = 1200, delay = 0.25, range = 1300, width = 130, collision = true, type = "linear", danger = 3},
			[_E] = { displayname = "Lucent Singularity", name = "LuxLightStrikeKugel", objname = "LuxLightStrikeKugel", speed = 1300, delay = 0.25, range = 1100, width = 345, collision = false, type = "circular", danger = 4},
			[_R] = { displayname = "Final Spark", name = "LuxMaliceCannon", objname = "LuxMaliceCannon", speed = math.huge, delay = 1, range = 3340, width = 250, collision = false, type = "linear", danger = 4}
		},
		["Malphite"] = {
			[_R] = { displayname = "Unstoppable Force", name = "UFSlash", objname = "UFSlash", speed = 1600, delay = 0.5, range = 900, width = 500, collision = false, aoe = true, type = "circular", danger = 5}
		},
		["Malzahar"] = {
			[_Q] = { name = "AlZaharCalloftheVoid", objname = "AlZaharCalloftheVoid", speed = math.huge, delay = 1, range = 900, width = 100, collision = false, aoe = false, type = "linear", danger = 3},
			[_W] = { name = "AlZaharNullZone", speed = math.huge, delay = 0.5, range = 800, width = 250, collision = false, aoe = false, type = "circular", danger = 1},
		},
		["Maokai"] = {
			[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { name = "", speed = 1500, delay = 0.25, range = 1100, width = 175, collision = false, aoe = false, type = "circular", danger = 2}
		},
		["MissFortune"] = {
			[_E] = { name = "MissFortuneScattershot", speed = math.huge, delay = 3.25, range = 800, width = 400, collision = false, aoe = true, type = "circular", danger = 1},
			[_R] = { name = "MissFortuneBulletTime", speed = math.huge, delay = 0.25, range = 1400, width = 700, collision = false, aoe = true, type = "cone", danger = 2}
		},
		["Mordekaiser"] = {
			[_E] = { name = "", speed = math.huge, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "cone", danger = 3}
		},
		["Morgana"] = {
			[_Q] = { name = "DarkBindingMissile", objname = "DarkBindingMissile", speed = 1200, delay = 0.250, range = 1300, width = 80, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["Nami"] = {
			[_Q] = { name = "NamiQ", objname = "namiqmissile", speed = math.huge, delay = 0.95, range = 1625, width = 150, collision = false, aoe = true, type = "circular", danger = 3},
			[_R] = { name = "NamiR", objname = "NamiRMissile", speed = 850, delay = 0.5, range = 2750, width = 260, collision = false, aoe = true, type = "linear", danger = 4}
		},
		["Nasus"] = {
			[_E] = { name = "", speed = math.huge, delay = 0.25, range = 450, width = 250, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Nautilus"] = {
			[_Q] = { name = "NautilusAnchorDrag", objname = "NautilusAnchorDragMissile", speed = 2000, delay = 0.250, range = 1080, width = 80, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["Nidalee"] = {
			[_Q] = { name = "JavelinToss", objname = "JavelinToss", speed = 1300, delay = 0.25, range = 1500, width = 40, collision = true, type = "linear", danger = 3}
		},
		["Nocturne"] = {
			[_Q] = { name = "NocturneDuskbringer", objname = "NocturneDuskbringer", speed = 1400, delay = 0.250, range = 1125, width = 60, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Olaf"] = {
			[_Q] = { name = "OlafAxeThrowCast", objname = "olafaxethrow", speed = 1600, delay = 0.25, range = 1000, width = 90, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Orianna"] = {
			[_Q] = { name = "OriannasQ", objname = "orianaizuna", speed = 1200, delay = 0, range = 1500, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
				[-1] = { name = "OriannaQend", speed = 1200, delay = 0, range = 1500, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { name = "OrianaDissonanceCommand-", objname = "OrianaDissonanceCommand", speed = math.huge, delay = 0.25, range = 0, width = 255, collision = false, aoe = true, type = "circular", danger = 2},
			[_R] = { name = "OrianaDetonateCommand-", objname = "OrianaDetonateCommand", speed = math.huge, delay = 0.250, range = 0, width = 410, collision = false, aoe = true, type = "circular", danger = 5}
		},
		["Pantheon"] = {
			[_E] = { name = "", speed = math.huge, delay = 0.250, range = 400, width = 100, collision = false, aoe = true, type = "cone", danger = 2},
		},
		["Quinn"] = {
			[_Q] = { name = "QuinnQ", objname = "QuinnQ", speed = 1550, delay = 0.25, range = 1050, width = 80, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["RekSai"] = {
			[_Q] = { name = "reksaiqburrowed", objname = "RekSaiQBurrowedMis", speed = 1550, delay = 0.25, range = 1050, width = 180, collision = true, aoe = false, type = "linear", danger = 1}
		},
		["Renekton"] = {
			[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "", speed = 1225, delay = 0.25, range = 450, width = 150, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Rengar"] = {
			[_W] = { name = "RengarW", speed = math.huge, delay = 0.25, range = 0, width = 490, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { name = "RengarE", objname = "RengarEFinal", speed = 1225, delay = 0.25, range = 1000, width = 80, collision = true, aoe = false, type = "linear", danger = 3},
		},
		["Riven"] = {
			[_Q] = { name = "RivenTriCleave", speed = math.huge, delay = 0.250, range = 310, width = 225, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { name = "RivenMartyr", speed = math.huge, delay = 0.250, range = 0, width = 265, collision = false, aoe = true, type = "circular", danger = 3},
			[_R] = { name = "rivenizunablade", objname = "RivenLightsaberMissile", speed = 2200, delay = 0.5, range = 1100, width = 200, collision = false, aoe = false, type = "cone", ranger = 5}
		},
		["Rumble"] = {
			[_Q] = { name = "RumbleFlameThrower", speed = math.huge, delay = 0.250, range = 600, width = 500, collision = false, aoe = false, type = "cone", danger = 1},
			[_E] = { name = "RumbleGrenade", objname = "RumbleGrenade", speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear", danger = 2},
			[_R] = { name = "RumbleCarpetBombM", objname = "RumbleCarpetBombMissile", speed = 1200, delay = 0.250, range = 1700, width = 90, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Ryze"] = {
			[_Q] = { name = "RyzeQ", objname = "RyzeQ", speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "ryzerq", objname = "ryzerq", speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear", danger = 2}
		},
		["Sejuani"] = {
			[_Q] = { name = "SejuaniArcticAssault", speed = 1600, delay = 0, range = 900, width = 70, collision = true, aoe = false, type = "linear", danger = 3},
			[_R] = { name = "SejuaniGlacialPrisonStart", objname = "sejuaniglacialprison", speed = 1600, delay = 0.25, range = 1200, width = 110, collision = false, aoe = false, type = "linear", danger = 5}
		},
		["Shen"] = {
			[_E] = { name = "ShenShadowDash", objname = "ShenShadowDash", speed = 1200, delay = 0.25, range = 600, width = 40, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Shyvana"] = {
			[_E] = { name = "ShyvanaFireball", objname = "ShyvanaFireballMissile", speed = 1500, delay = 0.250, range = 925, width = 60, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Sivir"] = {
			[_Q] = { name = "SivirQ", objname = "SivirQMissile", speed = 1330, delay = 0.250, range = 1075, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "SivirQReturn", objname = "SivirQMissileReturn", speed = 1330, delay = 0.250, range = 1075, width = 0, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Skarner"] = {
			[_E] = { name = "SkarnerFracture", objname = "SkarnerFractureMissile", speed = 1200, delay = 0.600, range = 350, width = 60, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Sona"] = {
			[_R] = { name = "SonaR", objname = "SonaR", speed = 2400, delay = 0.5, range = 900, width = 160, collision = false, aoe = false, type = "linear", danger = 5}
		},
		["Soraka"] = {
			[_Q] = { name = "SorakaQ", speed = 1000, delay = 0.25, range = 900, width = 260, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "SorakaE", speed = math.huge, delay = 1.75, range = 900, width = 310, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Swain"] = {
			[_W] = { name = "SwainShadowGrasp", objname = "SwainShadowGrasp", speed = math.huge, delay = 0.850, range = 900, width = 125, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Syndra"] = {
			[_Q] = { name = "SyndraQ", objname = "SyndraQ", speed = math.huge, delay = 0.67, range = 790, width = 125, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { name = "syndrawcast", objname = "syndrawcast" ,speed = math.huge, delay = 0.8, range = 925, width = 190, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "SyndraE", objname = "SyndraE", speed = 2500, delay = 0.25, range = 730, width = 45, collision = false, aoe = true, type = "cone", danger = 3},
			[_R] = { danger = 5},
		},
		["Talon"] = {
			[_W] = { name = "TalonRake", objname = "talonrakemissileone", speed = 900, delay = 0.25, range = 600, width = 200, collision = false, aoe = false, type = "cone", danger = 3},
			[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 650, collision = false, aoe = false, type = "circular", danger = 4}
		},
		["Taric"] = {
			[_R] = { name = "TaricHammerSmash", speed = math.huge, delay = 0.25, range = 0, width = 175, collision = false, aoe = false, type = "circular", danger = 3}
		},
		["Teemo"] = {
			[_Q] = { name = "", danger = 3}
		},
		["Thresh"] = {
			[_Q] = { name = "ThreshQ", objname = "ThreshQMissile", speed = 1825, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear", danger = 3},
			[_E] = { name = "ThreshE", objname = "ThreshEMissile1", speed = 2000, delay = 0.25, range = 450, width = 110, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Tristana"] = {
			[_W] = { name = "RocketJump", objname = "RocketJump", speed = 2100, delay = 0.25, range = 900, width = 125, collision = false, aoe = false, type = "circular", danger = 2}
		},
		["Trundle"] = {
		},
		["Tryndamere"] = {
			[_E] = { name = "slashCast", objname = "slashCast", speed = 1500, delay = 0.250, range = 650, width = 160, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["TwistedFate"] = {
			[_Q] = { name = "WildCards", objname = "SealFateMissile", speed = 1500, delay = 0.250, range = 1200, width = 80, collision = false, aoe = false, type = "linear"},
			[_W] = { name = "goldcardpreattack", danger = 3}
		},
		["Twitch"] = {
			[_W] = { name = "TwitchVenomCask", objname = "TwitchVenomCaskMissile", speed = 1750, delay = 0.250, range = 950, width = 275, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Urgot"] = {
			[_Q] = { name = "UrgotHeatseekingLineMissile", objname = "UrgotHeatseekingLineMissile", speed = 1575, delay = 0.175, range = 1000, width = 80, collision = true, aoe = false, type = "linear", danger = 2},
			[_E] = { name = "UrgotPlasmaGrenade", objname = "UrgotPlasmaGrenadeBoom", speed = 1750, delay = 0.25, range = 890, width = 200, collision = false, aoe = true, type = "circular", danger = 3},
			[-9] = { name = "UrgotHeatseekingHomeMissile", speed = 1575, delay = 0.175, range = 1200, width = 80, collision = false, aoe = false, danger = 2},
		},
		["Varus"] = {
			[_Q] = { name = "VarusQMissilee", objname = "VarusQMissile", speed = 1500, delay = 0.5, range = 1475, width = 100, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { name = "VarusE", objname = "VarusE", speed = 1750, delay = 0.25, range = 925, width = 235, collision = false, aoe = true, type = "circular", danger = 2},
			[_R] = { name = "VarusR", objname = "VarusRMissile", speed = 1200, delay = 0.5, range = 800, width = 100, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Vayne"] = {
		},
		["Veigar"] = {
			[_Q] = { name = "VeigarBalefulStrike", objname = "VeigarBalefulStrikeMis", speed = 1200, delay = 0.25, range = 900, width = 70, collision = true, aoe = false, type = "linear"},
			[_W] = { name = "VeigarDarkMatter", speed = math.huge, delay = 1.2, range = 900, width = 225, collision = false, aoe = false, type = "circular"},
			[_E] = { name = "VeigarEvenHorizon", speed = math.huge, delay = 0.75, range = 725, width = 275, collision = false, aoe = false, type = "circular"},
			[_R] = { danger = 5}
		},
		["VelKoz"] = {
			[_Q] = { name = "VelKozQ", objname = "VelkozQMissile", speed = 1300, delay = 0.25, range = 1100, width = 50, collision = true, aoe = false, type = "linear", danger = 3},
			[-1] = { name = "VelkozQSplit", objname = "VelkozQMissileSplit", speed = 2100, delay = 0.25, range = 1100, width = 55, collision = true, aoe = false, type = "linear", danger = 3},
			[_W] = { name = "VelKozW", objname = "VelkozWMissile", speed = 1700, delay = 0.064, range = 1050, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { name = "VelKozE", objname = "VelkozEMissile", speed = 1500, delay = 0.333, range = 850, width = 225, collision = false, aoe = true, type = "circular", danger = 3},
			[_R] = { name = "VelKozR", speed = math.huge, delay = 0.333, range = 1550, width = 50, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Vi"] = {
			[_Q] = { name = "Vi-q", objname = "ViQMissile", speed = 1500, delay = 0.25, range = 715, width = 55, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Viktor"] = {
			[_W] = { name = "ViktorGravitonField", speed = 750, delay = 0.6, range = 700, width = 125, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { name = "Laser", objname = "ViktorDeathRayMissile", speed = 1200, delay = 0.25, range = 1200, width = 0, collision = false, aoe = false, type = "linear", danger = 2},
			[_R] = { name = "ViktorChaosStorm", speed = 1000, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Vladimir"] = {
			[_R] = { name = "VladimirHemoplague", speed = math.huge, delay = 0.25, range = 700, width = 175, collision = false, aoe = true, type = "circular", danger = 4}
		},
		["Xerath"] = {
			[_Q] = { name = "xeratharcanopulse2", objname = "xeratharcanopulse2", speed = math.huge, delay = 1.75, range = 750, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { name = "XerathArcaneBarrage2", objname = "XerathArcaneBarrage2", speed = math.huge, delay = 0.25, range = 1100, width = 100, collision = false, aoe = true, type = "circular", danger = 3},
			[_E] = { name = "XerathMageSpear", objname = "XerathMageSpearMissile", speed = 1600, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear", danger = 4},
			[_R] = { name = "xerathrmissilewrapper", objname = "xerathrmissilewrapper", speed = math.huge, delay = 0.75, range = 3200, width = 245, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["XinZhao"] = {
			[_R] = { name = "XenZhaoParry", speed = math.huge, delay = 0.25, range = 275, width = 375, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Yasuo"] = {
			[_Q] = { name = "yasuoq", objname = "yasuoq", speed = math.huge, delay = 0.25, range = 475, width = 40, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "yasuoq2", objname = "yasuoq2", speed = math.huge, delay = 0.25, range = 475, width = 40, collision = false, aoe = false, type = "linear", danger = 2},
			[-2] = { name = "yasuoq3w", objname = "yasuoq3w", range = 1200, speed = 1200, delay = 0.125, width = 65, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Yorick"] = {
			[_W] = { name = "YorickDecayed", speed = math.huge, delay = 0.25, range = 600, width = 175, collision = false, aoe = true, type = "circular", danger = 2},
		},
		["Zac"] = {
			[_Q] = { name = "ZacQ", objname = "ZacQ", speed = 2500, delay = 0.110, range = 500, width = 110, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Zed"] = {
			[_Q] = { name = "ZedQ", objname = "ZedQMissile", speed = 1700, delay = 0.25, range = 900, width = 50, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { name = "ZedE", speed = math.huge, delay = 0.25, range = 0, width = 300, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Ziggs"] = {
			[_Q] = { name = "ZiggsQ", objname = "ZiggsQSpell", speed = 1750, delay = 0.25, range = 1400, width = 155, collision = true, aoe = false, type = "linear", danger = 3},
			[_W] = { name = "ZiggsW", objname = "ZiggsW", speed = 1800, delay = 0.25, range = 970, width = 275, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "ZiggsE", objname = "ZiggsE", speed = 1750, delay = 0.12, range = 900, width = 350, collision = false, aoe = true, type = "circular", danger = 1},
			[_R] = { name = "ZiggsR", objname = "ZiggsR", speed = 1750, delay = 0.14, range = 5300, width = 525, collision = false, aoe = true, type = "circular", danger = 4}
		},
		["Zilean"] = {
			[_Q] = { name = "ZileanQ", objname = "ZileanQMissile", speed = math.huge, delay = 0.5, range = 900, width = 150, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Zyra"] = {
			[-8] = { name = "zyrapassivedeathmanager", objname = "zyrapassivedeathmanager", speed = 1900, delay = 0.5, range = 1475, width = 70, collision = false, aoe = false, type = "linear", danger = 3},
			[_Q] = { name = "ZyraQFissure", objname = "ZyraQFissure", speed = math.huge, delay = 0.7, range = 800, width = 85, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "ZyraGraspingRoots", objname = "ZyraGraspingRoots", speed = 1150, delay = 0.25, range = 1100, width = 70, collision = false, aoe = false, type = "linear", danger = 3},
			[_R] = { name = "ZyraBrambleZone", speed = math.huge, delay = 1, range = 1100, width = 500, collision=false, aoe = true, type = "circular", danger = 4}
		}
	}
end

function HitMe:Detect(unit, spellProc)
	if Ready(self.Slot) and self.Slot > 0 and self.s[GetObjectName(unit)] and SLS.SB.uS:Value() and GetTeam(unit) == MINION_ENEMY then
		for d,i in pairs(self.s[GetObjectName(unit)]) do
			if (i.name and i.name:lower() == spellProc.name:lower()) or (i.name == "" and d >= 0 and GetCastName(unit,d) == spellProc.name) and i.danger <= SLS.SB.dV:Value() then
				print("Passed: "..i.name.." from "..GetObjectName(unit))
				i.speed = i.speed or math.huge
				i.range = i.range or math.huge
				i.delay = i.delay or 0
				i.width = i.width or 100
				i.radius = i.radius or i.width or math.huge	
				i.collision = i.collision or false
				i.danger = i.danger or 2
				
				self.fT = SLS.SB.hV:Value()
				self.multi = SLS.SB.wM:Value()
				
				if i.range > GetDistance(myHero,spellProc.startPos)*1.5 then return end
				
				--Simple Kappa Linear
				if i.type == "linear" or i.type == "cone" then
					local cPred = GetPrediction(myHero,i)
					local dT = i.delay + GetDistance(spellProc.startPos, cPred.castPos) / i.speed
					print("Delay "..i.delay)
					print("TravelTime "..GetDistance(spellProc.startPos, cPred.castPos) / i.speed)
					
					--Line-Line junction check
					local S1 = Vector(spellProc.startPos)
					local R1 = Vector(spellProc.endPos)
					
					local S2 = Vector(cPred.castPos + ((Vector(spellProc.endPos) - Vector(spellProc.startPos))*.5):perpendicular())
					local R2 = GetOrigin(myHero)
					
					CollP = Vector(VectorIntersection(S1,R1,S2,R2).x,spellProc.startPos.y, VectorIntersection(S1,R1,S2,R2).y)
					DelayAction( function()
						local d = GetDistance(Vector(CollP),cPred.castPos)
						print("Distance "..math.floor(d).." ".. spellProc.name)
						print("Time "..dT*self.fT)
						if (d<i.width*self.multi or GetDistance(myHero,CollP)<i.width*self.multi) --[[and (i.collision or not pI:mCollision(1))]] then
							CastSpell(self.Slot)
						end
					end, dT*self.fT*.001)
				
				--Circular
				elseif i.type == "circular" then
					local cPred = GetCircularAOEPrediction(myHero, i)
					local dT = i.delay + GetDistance(myHero, cPred.castPos) / i.speed
					local R1 = Vector(spellProc.endPos)
					
					DelayAction( function()
						local d = GetDistance(Vector(R1),cPred.castPos)
						print("Distance "..math.floor(d).." ".. spellProc.name)
						if d<i.radius*self.multi or GetDistance(myHero,spellProc.endPos)<i.radius*self.multi then
							CastSpell(self.Slot)
						end
					end, dT*self.fT*.001)
				
				--Targeted and Trash
				elseif spellProc.target and spellProc.target == myHero then
					local dT = i.delay + GetDistance(myHero, spellProc.startPos) / i.speed
					DelayAction( function()
						print(spellProc.name.." Targeted")
						CastSpell(self.Slot)
					end, dT*self.fT*.001)
				else
					print(spellProc.name.." Error")
				end
			end
		end
	end
end

