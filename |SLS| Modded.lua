local SLSeries = 0.01

require 'Inspired'
require 'OpenPredict'	--SpellShield/HG

local SLSChamps = {
["Aatrox"] = true
}
	
local Name = GetMyHero()
local ChampName = myHero.charName

Callback.Add("Load", function()	
	Init()
	if SLSChamps[ChampName] and SLS.Loader.LC:Value() then
		_G[ChampName]() 
	elseif not SLSChamps[ChampName] then 
		PrintChat("<font color=\"#81F700\"><b>|SL| " .. ChampName .. " is not supported!</b></font>")
		PrintChat("|SL| Utility Loaded")
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
end)    

class 'Init'

function Init:__init()
	local AntiGapCloser = {}
	local Last = {}
	local Lane = {}
	local Harass = {}
	local Jungle = {}
	local Kill = {}
	local AutoQ = {}
	local AutoW = {} 
	local AutoE = {} 
	local AutoR = {}
	local ManaManager = {}
	local GapCloser = {}
	local MapPositionGOS = {}

	SLS = MenuConfig("SLS", "SLS")
	SLS:Menu("Loader", "|SL| Loader")
	L = SLS["Loader"]
	L:Boolean("LC", "Load Champion", true)
	--L:Boolean("LD", "Load Drawings", true)
	L:Boolean("LSK", "Load SkinChanger", true)
	L:Boolean("LAL", "Load AutoLevel", true)
	L:Boolean("LI", "Load Items", true)
	L:Info("516", "You will have to press 2f6")
	L:Info("546", "to apply the changes")

	if L.LC:Value() then
		SLS:Menu(ChampName, "|SL| "..ChampName) 
		BM = SLS[ChampName] 
		--BM:Menu("C", "Combo")	
		--BM:Menu("M", "Misc")
		if AntiGapCloser[ChampName] == true then BM.M:Menu("AGP", "AntiGapCloser") end
		--if Harass[ChampName] == true then BM:Menu("H", "Harass") end
		--if Last[ChampName] == true then BM:Menu("LH", "LastHit") end
		--if Lane[ChampName] == true then BM:Menu("LC", "LaneClear") end
		--if Jungle[ChampName] == true then BM:Menu("JC", "JungleClear")	end
		--if Kill[ChampName] == true then BM:Menu("KS", "KillSteal") end
		if GapCloser[ChampName] == true then 
			BM.M:Menu("GC", "GapCloser")
		end
	end
	
	if MapPositionGOS[ChampName] and FileExist(COMMON_PATH .. "MapPositionGOS.lua") then
		require 'MapPositionGOS'
	end
end
	
--------------------------------------CHAMPS----------------------------------------------


class "Aatrox"

function Aatrox:__init()
	
	--OpenPred
	self.Spell = { 
	[0] = { delay = 0.2, range = 650, speed = 1500, radius = 113 },
	[2] = { delay = 0.1, range = 1000, speed = 1000, width = 150 }
	}
	
	--SpellDmg
	self.DmgR = {
	[0] = function () return 35 + GetCastLevel(myHero,0)*45 + GetBonusDmg(myHero)*.6 end,
	[1] = function () return 25 + GetCastLevel(myHero,1)*35 + GetBonusDmg(myHero) end,
	[2] = function () return 35 + GetCastLevel(myHero,2)*35 + GetBonusDmg(myHero)*.6 + GetBonusAP(myHero)*.6 end,
	[3] = function () return 100 + GetCastLevel(myHero,3)*100 + GetBonusAP(myHero) end,
	}
	
	--Menu
	BM:SubMenu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Slider("WT", "Toggle W at % HP", 45, 5, 90, 5)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	
	BM:SubMenu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("Q", "Use Q", false)
	BM.KS:Boolean("E", "Use E", true)
	
	BM:SubMenu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)

	--Callbacks
	Callback.Add("Tick", function() self:Tick() end)
	--Callback.Add("Draw", function self:Draw() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:Stat(unit,buff) end)
	
	
	--SpellStatus
	self.SReady = {
	[0] = false,
	[1] = false,
	[2] = false,
	[3] = false,
	}
	
	--Var
	if GotBuff(myHero, "aatroxwpower") == 1 then
		self.W = "dmg"
	else
		self.W = "heal"
	end
end  

function Aatrox:SpellCheck()	--SpellCheck
	for s = 0,3 do 
		if CanUseSpell(myHero,s) == READY then
			self.SReady[s] = true
		else 
			self.SReady[s] = false
		end
	end
end

function Aatrox:Tick()
	if myHero.dead then return end
	
	if (_G.IOW or _G.DAC_Loaded) then
		
		self:SpellCheck()
		
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
			self:LastHit()
		elseif Mode == "Harass" then
			self:Harass()--]]
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
	if self.SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.C.Q:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if self.SReady[1] and BM.C.W:Value() and ValidTarget(target,400) then
		if GetPercentHP(myHero) < BM.C.WT:Value()+1 and self.W == "dmg" then
			CastSpell(1)
		elseif GetPercentHP(myHero) > BM.C.WT:Value()+	1 and self.W == "heal" then
			CastSpell(1)
		end
	end
	if self.SReady[2] and ValidTarget(target, self.Spell[2].range*1.1) and BM.C.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	if self.SReady[3] and ValidTarget(target, 550) and BM.C.R:Value() and EnemiesAround(myHero,550) >= BM.C.RE:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
end

function Aatrox:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetCurrentHP(unit) + GetDmgShield(unit) < CalcDamage(myHero,unit, self.DmgR[0](), 0) and self.SReady[0] and ValidTarget(unit, self.Spell[0].range*1.1) and BM.KS.Q:Value() then
			local Pred = GetCircularAOEPrediction(unit, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if GetCurrentHP(unit) + GetDmgShield(unit) < CalcDamage(myHero,unit, 0, self.DmgR[2]()) and self.SReady[2] and ValidTarget(unit, self.Spell[2].range*1.1) and BM.KS.E:Value() then
			local Pred = GetPrediction(unit, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
	end
end

function Aatrox:Stat(unit, buff)
	if unit == myHero and buff.Name:lower() == "self.aatroxwlife" then
		self.W = "heal"
	elseif unit == myHero and buff.Name:lower() == "self.aatroxwpower" then
		self.W = "dmg"
	end
end
	
	
	
	
	
	
	
	
	
-------------------------------------UTILITY-------------------------------------------------
	
--AutoLevel
class 'AutoLevel'

function AutoLevel:__init()
	SLS:SubMenu("AL", "|SL| Auto Level")
	SLS.AL:Boolean("aL", "Use AutoLvl", true)
	SLS.AL:DropDown("aLS", "AutoLvL", 1, {"Q-W-E","Q-E-W","W-Q-E","W-E-Q","E-Q-W","E-W-Q"})
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
		if BM.AL.hL:Value() then
			DelayAction(function() LevelSpell(self.lTable[SLS.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(.5,.8))
		else
			LevelSpell(self.lTable[SLS.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
		end
	end
end



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
	
	
	self.AD = {3144,3153,3142}
	self.AA = {3077,3074,3748}
	self.AP = {3146,3092,3290}
	self.DE = {3040,3048}
	self.ADE = {3401,3222,3190}
	self.CC = {3139,3140,3137}
	self.TA = {3143,3800}
	self.Banner = 3060
	--self.HG = soon
	
	Callback.Add("Tick", function() self:Use() end)
	Callback.Add("ProcessSpellAttack", function(Object,spellProc) self:AAReset(Object,spellProc) end)
	
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



--Updater
class 'Update'

function Update:__init()

	self.webV = "Error"
	self.Stat = "Error"
	self.Do = true

	function AutoUpdate(data)
		if tonumber(data) > version then
			self.webV = data
			self.State = "|SL| Update to v"..self.webV
			Callback.Add("Draw", function() self:Box() end)
			Callback.Add("WndMsg", function(key,msg) self:Click(key,msg) end)
		end
	end

	GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SLSeries/master/SLSeries.version", AutoUpdate)
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
		DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SLSeries/master/SLSeries.lua", SCRIPT_PATH .. "SLSeries.lua", function() self.State = "Update Complete" PrintChat("Reload the Script with 2x F6") return	end)
		DelayAction(function() self.State = "Update Complete" PrintChat("Reload the Script with 2x F6") Callback.Del("WndMsg", function(key,msg) end) end,1)
	elseif key == 513 and cur.x > 370 and cur.x < 400 and cur.y > 7 and cur.y < 60 then
		Callback.Del("Draw", function() self:Box() end)
		self.Do = false
	end
end
