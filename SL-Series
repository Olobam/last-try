local SL-Series = 0.01

require 'Inspired'

--Vayne:
	self.Dmg = {
	[2] = function () return 35 * GetCastLevel(myHero,2) + 45 + GetBonusDmg(myHero) * .5 end,
	}
--Garen:
	self.Dmg = {
	[0] = function () return 25 * GetCastLevel(myHero,0) + 30 + GetBonusDmg(myHero) * .4 end,
	[3] = function (unit) return 174 * GetCastLevel(myHero,_R) + ((GetMaxHP(unit) - GetCurrentHP(unit)) * (0.219 + 0.067 * GetCastLevel(myHero, _R))) end,
	}
--Soraka
	self.Dmg = {
	[0] = function () return 40 * GetCastLevel(myHero,0) + 70 + GetBonusAP(myHero) * .35 end,
	[2] = function () return 40 * GetCastLevel(myHero,2) + 70 + GetBonusAP(myHero) * .4 end,
	}
--DrMundo
	self.Dmg = {
	[0] = function (unit) return (2.5 * GetCastLevel(myHero,0) + 12.5) * (GetCurrentHP(unit)/25) end,
	}
--Blitzcrank
	self.Dmg = {
	[0] = function () return 55 * GetCastLevel(myHero,0) + 80 + GetBonusAP(myHero) end,
	[3] = function () return 125 * GetCastLevel(myHero,3) + 250 + GetBonusAP(myHero) end,
	}
--Leona
	self.Dmg = {
	[0] = function () return 30 * GetCastLevel(myHero,0) + 40 + GetBonusAP(myHero) * .3 end,
	[2] = function () return 40 * GetCastLevel(myHero,2) + 60 + GetBonusAP(myHero) * .4 end,
	[3] = function () return 100 * GetCastLevel(myHero,3) + 150 + GetBonusAP(myHero) * .8 end,
	}	
--Ezreal
	self.Dmg = {
	[0] = function () return 20 * GetCastLevel(myHero,0) + 35 + GetBonusDmg(myHero) * 1.1 + GetBonusAP(myHero) * .4 end,
	[1] = function () return 45 * GetCastLevel(myHero,1) + 70 + GetBonusDmg(myHero) * 1.1 + GetBonusAP(myHero) * .8 end,
	[2] = function () return 50 * GetCastLevel(myHero,2) + 75 + GetBonusDmg(myHero) * .5  + GetBonusAP(myHero) * .75 end,
	[3] = function () return 150 * GetCastLevel(myHero,3) + 350 + GetBonusDmg(myHero) + GetBonusAP(myHero) * .9 end,
	}
--Lux
	self.Dmg = {
	[-1] = function () return 10 + GetLevel(myHero) + GetBonusAP(myHero) * .2 end,
	[0] = function () return 50 * GetCastLevel(myHero,0) + 60 + GetBonusAP(myHero) * .7 end,
	[2] = function () return 50 * GetCastLevel(myHero,2) + 60 + GetBonusAP(myHero) * .6 end,
	[3] = function () return 100 * GetCastLevel(myHero,3) + 300 + GetBonusAP(myHero) * .75 end,
	}
--Rumble
	self.Dmg = {
	[0] = function () return 5 * GetCastLevel(myHero,0) + 6.25 + GetBonusAP(myHero) * 8.35 end, -- if GetPercentMP(myHero) > 50 then 7.5 * GetCastLevel(myHero,0) + 9.4 + GetBonusAP(myHero) * 12.5 end
	[2] = function () return 25 * GetCastLevel(myHero,2) + 45 + GetBonusAP(myHero) * .4 end, -- if GetPercentMP(myHero) > 50 then 37.5 * GetCastLevel(myHero,2) + 60 + GetBonusAP(myHero) * .6 end
	[3] = function () return 55 * GetCastLevel(myHero,3) + 130 + GetBonusAP(myHero) * .3 end,
	}	
--Swain
	self.Dmg = {
	[0] = function () return 15 * GetCastLevel(myHero,0) + 25 + GetBonusAP(myHero) * .3 end,
	[1] = function () return 40 * GetCastLevel(myHero,2) + 80 + GetBonusAP(myHero) * .7 end, 
	[2] = function () return 34.35 * GetCastLevel(myHero,2) + 46.65 + GetBonusAP(myHero) * (84 + 2.4 * GetCastLevel(myHero,2)) end
	[3] = function () return 20 * GetCastLevel(myHero,3) + 50 + GetBonusAP(myHero) * .2 end,
	}
--Thresh
	self.Dmg = {
	[0] = function () return 40 * GetCastLevel(myHero,0) + 80 + GetBonusAP(myHero) * .5 end,
	[2] = function () return 30 * GetCastLevel(myHero,2) + 65 + GetBonusAP(myHero) * .7 end, 
	[3] = function () return 150 * GetCastLevel(myHero,3) + 250 + GetBonusAP(myHero) end,
	}
--Kalista
	self.Dmg = {
	[0] = function() return 60 * GetCastLevel(myHero,0) + 10 + GetBonusDmg(myHero) end,
	[2] = function(unit) return (10 * GetCastLevel(myHero,2) + 20 + GetBonusDmg(myHero) * .6) * eTrack[GetObjectName(unit)] end, --OnUpdateBuff(function(unit, buff) if unit ~= myHero and buff.Name:lower() == "kalistaexpungemarker" then eTrack[GetObjectName(unit)]=buff.Count end end)																							
																																--if eTrack[GetObjectName(unit)] then calcdamage(myHero,unit,self.Dmg[2](),0)
	}
--Poppy
	self.Dmg = {
	[0] = function () return 25 * GetCastLevel(myHero,0) + 40 + GetBonusDmg(myHero) * .8 end,
	[2] = function () return 20 * GetCastLevel(myHero,2) + 50 + GetBonusDmg(myHero) * .5 end, 
	[3] = function () return 100 * GetCastLevel(myHero,3) + 200 + GetBonusDmg(myHero) * .9 end,
	}
--Nami
	self.Dmg = {
	[0] = function () return 55 * GetCastLevel(myHero,0) + 75 + GetBonusAP(myHero) * .5 end,
	[2] = function () return 40 * GetCastLevel(myHero,2) + 70 + GetBonusAP(myHero) * .5 end, 
	[3] = function () return 100 * GetCastLevel(myHero,3) + 150 + GetBonusAP(myHero) * .6 end,
	}
--Corki
	self.Dmg = {
	[0] = function () return 45 * GetCastLevel(myHero,0) + 70 + GetBonusDmg(myHero) * .5 + GetBonusAP(myHero) * .5 end,
	[1] = function () return 15 * GetCastLevel(myHero,1) + 30 + GetBonusAP(myHero) * .2 end,
	[2] = function () return 6 * GetCastLevel(myHero,2) + 10 + GetBonusDmg(myHero) * .2 end, 
	[3] = function () return 30 * GetCastLevel(myHero,3) + 100 + GetBonusDmg(myHero) *  + GetBonusAP(myHero) * .3 end,
	}
--KogMaw
	self.Dmg = {
	[0] = function () return 50 * GetCastLevel(myHero,0) + 80 + GetBonusAP(myHero) * .5 end,
	[2] = function () return 50 * GetCastLevel(myHero,2) + 60 + GetBonusAP(myHero) * .7 end, 
	[3] = function () return 40 * GetCastLevel(myHero,3) + 70 + GetBonusDmg(myHero) * .65 + GetBonusAP(myHero) * .25 end, --if GetPercentHP(unit) < 50 then CalcDamage(myHero,unit,0,self.Dmg[3]()*2) elseif GetPercentHP(unit) < 25 then CalcDamage(myHero,unit,0,self.Dmg[3]()*3)
	}
--Nasus
	self.Dmg = {
	[0] = function () return 20*GetCastLevel(myHero,1) + 30 + GetBaseDamage(myHero) + GetBuffData(myHero,"nasusqstacks").Stacks + 15 end,
	[2] = function () return 40 * GetCastLevel(myHero,2) + 55 + GetBonusAP(myHero) * .6 end, 
	[3] = function (unit) return (1 * GetCastLevel(myHero,3) + 3 + GetBonusAP(myHero) * 0.01) * GetMaxHP(unit) end,
	}
--Jinx
	self.Dmg = {
	[1] = function () return 50 * GetCastLevel(myHero,0) + 10 + GetBonusDmg(myHero) * 1.4 end,
	[2] = function () return 55 * GetCastLevel(myHero,2) + 80 + GetBonusAP(myHero) end, 
	[3] = function () return math.max((50 * GetCastLevel(myHero,3) + 75 + GetBonusDmg(myHero) + (0.05*GetCastLevel(myHero,3)+0.2)) * (GetMaxHP(unit)-GetCurrentHP(unit))) end,
	}	
	
	local Champs = {
	["Vayne"] = true,
	["Garen"] = true,
	["Soraka"] = true,
	["DrMundo"] = true,
	["Blitzcrank"] = true,
	["Leona"] = true,
	["Ezreal"] = true,
	["Lux"] = true,
	["Rumble"] = true,
	["Swain"] = true,
	["Thresh"] = true,
	["Kalista"] = true,
	["Poppy"] = true,
	["Nami"] = true,
	["Corki"] = true,
	["KogMaw"] = true,
	["Nasus"] = true,
	["Jinx"] = true,
	}
	
	local SxcSAIOSkin = { --Credits to Icesythe7
	["Vayne"] = {"Normal", "Vindicator", "Aristocrat", "Dragonslayer", "Heartseeker", "Skt T1", "Arclight", "Chroma Pack: Green", "Chroma Pack: Red", "Chroma Pack: Silver"},	
	["Garen"] = {"Normal", "Sanguine", "Desert Trooper", "Commando", "Dreadknight", "Rugged", "Steel Legion", "Chroma Pack: Garnet", "Chroma Pack: Plum", "Chroma Pack: Ivory", "Rogue Admiral"},
	["Soraka"] = {"Normal", "Dryad", "Divine", "Celestine", "Reaper", "Order of the Banana"},
	["DrMundo"] = {"Normal", "Toxic", "Mr. Mundoverse", "Corporate Mundo", "Mundo Mundo", "Executioner Mundo", "Rageborn Mundo", "TPA Mundo", "Pool Party"},
	["Blitzcrank"] = {"Normal", "Rusty", "Goalkeeper", "Boom Boom", "Piltover Customs", "Definitely Not", "iBlitzcrank", "Riot", "Chroma Pack: Molten", "Chroma Pack: Cobalt", "Chroma Pack: Gunmetal", "Battle Boss"},
	["Leona"] = {"Normal", "Valkyrie", "Defender", "Iron Solari", "Pool Party", "Chroma Pack: Pink", "Chroma Pack: Azure", "Chroma Pack: Lemon", "PROJECT"},
	["Ezreal"] = {"Normal", "Nottingham", "Striker", "Frosted", "Explorer", "Pulsefire", "TPA", "Debonair", "Ace of Spades"},
	["Lux"] = {"Normal", "Sorceress", "Spellthief", "Commando", "Imperial", "Steel Legion", "Star Guardian"},
	["Rumble"] = {"Normal", "Rumble in the Jungle", "Bilgerat", "Super Galaxy"},
	["Swain"] = {"Normal", "Northern Front", "Bilgewater", "Tyrant"},
	["Thresh"] = {"Normal", "Deep Terror", "Championship", "Blood Moon", "SSW"},
	["Kalista"] = {"Normal", "Blood Moon", "Championship"},
	["Poppy"] = {"Normal", "Noxus", "Lollipoppy", "Blacksmith", "Ragdoll", "Battle Regalia", "Scarlet Hammer"},
	["Nami"] = {"Normal", "Koi", "River Spirit", "Urf", "Chroma Pack: Sunbeam", "Chroma Pack: Smoke", "Chroma Pack: Twilight"},
	["Corki"] = {"Normal", "UFO", "Ice Toboggan", "Red Baron", "Hot Rod", "Urfrider", "Dragonwing", "Fnatic"},
	["KogMaw"] = {"Normal", "Caterpillar", "Sonoran", "Monarch", "Reindeer", "Lion Dance", "Deep Sea", "Jurassic", "Battlecast"},
	["Nasus"] = {"Normal", "Galactic", "Pharaoh", "Dreadknight", "Riot K-9", "Infernal", "Archduke", "Chroma Pack: Burn", "Chroma Pack: Blight", "Chroma Pack: Frostbite"},
	["Jinx"] = {"Normal", "Mafia", "Firecracker", "Slayer"},
	}
	
local Name = GetMyHero()
local ChampName = myHero.charName
	
if not SxcSAIOChamps[ChampName] then 
	PrintChat("<font color=\"#81F700\"><b>{SxcSAIO} ::: " .. ChampName .. " is not supported!</b></font>")
end
    
   local AntiGapCloser = {["Vayne"] = true, ["Lux"] = true, ["Thresh"] = true, ["Poppy"] = true, ["Nami"] = true,}
   local Last = {}
   local Lane = {["Vayne"] = true, ["Garen"] = true, ["Soraka"] = true, ["DrMundo"] = true, ["Leona"] = true, ["Ezreal"] = true, ["Lux"] = true, ["Rumble"] = true, ["Swain"] = true, ["Poppy"] = true, ["Corki"] = true, ["KogMaw"] = true, ["Jinx"] = true,}
   local Harass = {["Soraka"] = true, ["DrMundo"] = true, ["Blitzcrank"] = true, ["Leona"] = true, ["Ezreal"] = true, ["Rumble"] = true, ["Swain"] = true, ["Thresh"] = true, ["Kalista"] = true, ["Poppy"] = true, ["Nami"] = true, ["Corki"] = true, ["KogMaw"] = true, ["Nasus"] = true, ["Jinx"] = true,}
   local Jungle = {["Vayne"] = true, ["Garen"] = true, ["Soraka"] = true, ["DrMundo"] = true, ["Leona"] = true, ["Ezreal"] = true, ["Lux"] = true, ["Rumble"] = true, ["Swain"] = true, ["Poppy"] = true, ["Corki"] = true, ["KogMaw"] = true, ["Nasus"] = true, ["Jinx"] = true,}
   local Kill = {["Vayne"] = true, ["Garen"] = true, ["DrMundo"] = true, ["Blitzcrank"] = true, ["Leona"] = true, ["Ezreal"] = true, ["Lux"] = true, ["Rumble"] = true, ["Swain"] = true, ["Thresh"] = true, ["Kalista"] = true, ["Poppy"] = true, ["Nami"] = true, ["Corki"] = true, ["KogMaw"] = true, ["Nasus"] = true, ["Jinx"] = true,}
   local AutoQ = {["Nasus"] = true,}
   local AutoW = {["Soraka"] = true, ["Nami"] = true,} 
   local AutoE = {["Kalista"] = true, ["Nami"] = true,} 
   local AutoR = {["Soraka"] = true, ["Kalista"] = true,}
   local Prediction = {["Soraka"] = true, ["DrMundo"] = true, ["Blitzcrank"] = true, ["Leona"] = true, ["Ezreal"] = true, ["Lux"] = true, ["Rumble"] = true, ["Swain"] = true, ["Thresh"] = true, ["Kalista"] = true, ["Poppy"] = true, ["Nami"] = true, ["Corki"] = true, ["KogMaw"] = true, ["Nasus"] = true, ["Jinx"] = true,}
   local ManaManager = {["Vayne"] = true, ["Ezreal"] = true, ["Lux"] = true, ["Swain"] = true, ["Thresh"] = true, ["Kalista"] = true, ["Poppy"] = true, ["Corki"] = true, ["KogMaw"] = true, ["Nasus"] = true, ["Jinx"] = true,}
   local GapCloser = {}
   local MapPositionGOS = {["Vayne"] = true, ["Poppy"] = true, ["Kalista"] = true,}

	local SxcSAIO = MenuConfig("SxcSAIO", "SxcSAIO") --Scriptlogy
	SxcSAIO:Menu("Loader", "Loader") L = SxcSAIO["Loader"] L:Boolean("LC", "Load Champion", true) L:Boolean("LD", "Load Drawings", true) L:Boolean("LSK", "Load SkinChanger", true) L:Info("516", "You will have to press 2f6") L:Info("546", "to apply the changes")
	if L.LSK:Value() then SxcSAIO:Menu("SC", "SkinChanger") SKCH = SxcSAIO["SC"] SKCH:DropDown('Skins', "Skins for "..ChampName.." -->", 1, SxcSAIOSkin[ChampName]) end
	if L.LD:Value() then SxcSAIO:Menu("D", "Drawings") D = SxcSAIO["D"] D:Boolean("LastHitMarker", "LastHitMarker", true) D:Boolean("DrawQ", "Draw Q", true) D:Boolean("DrawW", "Draw W", true) D:Boolean("DrawE", "Draw E", true) D:Boolean("DrawR", "Draw R", true) D:ColorPick("ColorPick", "Circle color", {255,102,102,102}) end
	SxcSAIO:Info("511a", "") SxcSAIO:Info("512a", "Changelog :::") SxcSAIO:Info("513a", SxcSAIOChangelog1) SxcSAIO:Info("531a", SxcSAIOChangelog2) SxcSAIO:Info("535a", SxcSAIOChangelog3)
  if L.LC:Value() then
	SxcSAIO:Menu(ChampName, ChampName) BM = SxcSAIO[ChampName] 
	BM:Menu("C", "Combo")	
	BM:Menu("M", "Misc")
	BM.M:Menu("AL", "Auto Level") BM.M.AL:DropDown("AL", "Auto Level -->", 1, {"Disabled", "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q"}) BM.M.AL:Slider("ALH", "Auto Level Humanizer", 1500, 0, 3000, 5)
	if AntiGapCloser[ChampName] == true then BM.M:Menu("AGP", "AntiGapCloser") end
	if Harass[ChampName] == true then BM:Menu("H", "Harass") end
	if Last[ChampName] == true then BM:Menu("LH", "LastHit") end
	if Lane[ChampName] == true then BM:Menu("LC", "LaneClear") end
	if Jungle[ChampName] == true then BM:Menu("JC", "JungleClear")	end
	if Kill[ChampName] == true then BM:Menu("KS", "KillSteal") end
	if AutoQ[ChampName] == true then BM:Menu("AQ", "Auto Q") end
	if AutoW[ChampName] == true then BM:Menu("AW", "Auto W") end
	if AutoE[ChampName] == true then BM:Menu("AE", "Auto E") end
	if AutoR[ChampName] == true then BM:Menu("AR", "Auto R") end
	if Prediction[ChampName] == true then BM.M:Menu("P", "Prediction") BM.M.P:Slider("QHC", "Q HitChance", 40, 1, 100, 10) BM.M.P:Slider("WHC", "W HitChance", 40, 1, 100, 10) BM.M.P:Slider("EHC", "E HitChance", 40, 1, 100, 10) BM.M.P:Slider("RHC", "R HitChance", 65, 1, 100, 10) end
	if ManaManager[ChampName] == true then BM.M:Menu("MM", "ManaManager") BM.M.MM:Slider("MQ", "Mana to use Q >= x ", 10, 1, 100, 10) BM.M.MM:Slider("MW", "Mana to use W >= x ", 10, 1, 100, 10) BM.M.MM:Slider("ME", "Mana to use E >= x ", 10, 1, 100, 10) BM.M.MM:Slider("MR", "Mana to use R >= x ", 10, 1, 100, 10) end
	if GapCloser[ChampName] == true then BM.M:Menu("GC", "GapCloser") end
  end
	
if MapPositionGOS[ChampName] == true and FileExist(COMMON_PATH .. "MapPositionGOS.lua") then
require 'MapPositionGOS'
end
 
if Prediction[ChampName] == true and FileExist(COMMON_PATH .. "OpenPredict.lua") then
require 'OpenPredict'
elseif ChampName == "Vayne" and FileExist(COMMON_PATH .. "OpenPredict.lua") then
require 'OpenPredict'
end

class 'AutoLevel'

function AutoLevel:__init()
self:Load()
end

function AutoLevel:Load()
OnTick(function() self:Tick() end)
end

function AutoLevel:Tick()
	if BM.M.AL.AL:Value() == 2 then SxcSAIOLevel = {_Q,_W,_E,_Q,_Q,_R,_Q,_W,_Q,_W,_R,_W,_W,_E,_E,_R,_E,_E}
	elseif BM.M.AL.AL:Value() == 3 then SxcSAIOLevel = {_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
	elseif BM.M.AL.AL:Value() == 4 then SxcSAIOLevel = {_W,_Q,_E,_W,_W,_R,_W,_Q,_W,_Q,_R,_Q,_Q,_E,_E,_R,_E,_E}
	elseif BM.M.AL.AL:Value() == 5 then SxcSAIOLevel = {_W,_E,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_E,_E,_Q,_Q,_R,_Q,_Q}
	elseif BM.M.AL.AL:Value() == 6 then SxcSAIOLevel = {_E,_Q,_W,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W}
	elseif BM.M.AL.AL:Value() == 7 then SxcSAIOLevel = {_E,_W,_Q,_E,_E,_R,_E,_W,_E,_W,_R,_W,_W,_Q,_Q,_R,_Q,_Q}
	end
  DelayAction(function() 
		if BM.M.AL.AL:Value() ~= 1 then LevelSpell(SxcSAIOLevel[GetLevel(myHero)]) end
		end, math.random(1,BM.M.AL.ALH:Value()))        
end

class 'Drawings'

function Drawings:__init()
self:Load()
end

function Drawings:Load()
OnDraw(function() self:Draw() end)
OnCreateObj(function(Object) self:CreateObj(Object) end)
OnDeleteObj(function(Object) self:DeleteObj(Object) end)
end


if L.LD:Value() and ChampName == "Thresh" then D:Boolean("DS", "Draw Souls", true) end


function Drawings:CreateObj(Object)
	if GetObjectBaseName(Object) == "Thresh_Base_soul.troy" and ChampName == "Thresh" then
		table.insert(souls, Object)	
	end
end


function Drawings:DeleteObj(Object)
  myHer0 = GetOrigin(myHero)
	if GetObjectBaseName(Object) == "Thresh_Base_soul.troy" and ChampName == "Thresh" then
		table.remove(souls, 1)
	end
end

souls = {}
function Drawings:Draw() 
if L.LD:Value() then
   for _, minion in pairs(minionManager.objects) do
    if GetTeam(minion) == (MINION_ENEMY) or (MINION_JUNGLE) then
	 if _G.IOW and IOW:Mode() ~= "Harass" and IOW:Mode() ~= "Combo" and ValidTarget(minion, GetRange(myHero)) and not IsDead(minion) and D.LastHitMarker:Value() and GetCurrentHP(minion) < CalcDamage(myHero, minion, GetBaseDamage(myHero), GetBonusDmg(myHero), 0) then DrawCircle(GetOrigin(minion), GetHitBox(minion), 2, 40, ARGB(255, 255, 255, 255)) end
	 end
	 if _G.DAC_Loaded and DAC:Mode() ~= "Harass" and DAC:Mode() ~= "Combo" and ValidTarget(minion, GetRange(myHero)) and not IsDead(minion) and D.LastHitMarker:Value() and GetCurrentHP(minion) < CalcDamage(myHero, minion, GetBaseDamage(myHero), GetBonusDmg(myHero), 0) then DrawCircle(GetOrigin(minion), GetHitBox(minion), 2, 40, ARGB(255, 255, 255, 255)) end
	 end
	if _G.PW then end
  for _, s in pairs(souls) do
	if s ~= nil then
		if ChampName == "Thresh" and D.DS:Value() and IsObjectAlive(s) then DrawCircle(GetOrigin(s), GetHitBox(s), 2, 40, ARGB(255, 255, 255, 255)) end
	end
  end
	if IsReady(_Q) and D.DrawQ:Value() then DrawCircle(GetOrigin(myHero), GetCastRange(myHero,_Q), 1, 40, D.ColorPick:Value()) end
	if IsReady(_W) and D.DrawW:Value() then DrawCircle(GetOrigin(myHero), GetCastRange(myHero,_W), 1, 40, D.ColorPick:Value()) end
	if IsReady(_E) and D.DrawE:Value() then DrawCircle(GetOrigin(myHero), GetCastRange(myHero,_E), 1, 40, D.ColorPick:Value()) end
	if IsReady(_R) and D.DrawR:Value() then DrawCircle(GetOrigin(myHero), GetCastRange(myHero,_R), 1, 40, D.ColorPick:Value()) end
end
end

class 'SkinChanger'

function SkinChanger:__init()
self:Load()
end

function SkinChanger:Load()
OnDraw(function() self:Draw() end)
end

function SkinChanger:Draw()
if L.LSK:Value() then
 if SKCH.Skins:Value() ~= 1 then HeroSkinChanger(Name, SKCH.Skins:Value() - 1)
  elseif SKCH.Skins:Value() == 1 then HeroSkinChanger(Name, 0) end
end
end

if SxcSAIOChamps[ChampName] == true and SxcSAIO.Loader.LC:Value() then
  _G[ChampName]() 
end
if SxcSAIOChamps[ChampName] == true and SxcSAIO.Loader.LD:Value() then
	Drawings()
end
if SxcSAIOChamps[ChampName] == true and SxcSAIO.Loader.LSK:Value() then
	SkinChanger()
end
if SxcSAIOChamps[ChampName] == true then
	AutoLevel()
end

class 'Update'

function Update:__init()
	self.webV = "Error"

	function AutoUpdate(data)
		if tonumber(data) > version then
			self.webV = data
			PrintChat("|?| New update found! Version: " .. data)
			PrintChat("Downloading update, please wait...")
			DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Series.lua", SCRIPT_PATH .. "SL-Series.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
			Callback.Add("Draw", function() self:Box() end)
			Callback.Add("WndMsg", function(key,msg) self:Click(key,msg) end)
		end
	end

	GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Series.version", AutoUpdate)
end

function Update:Box()
	FillRect(0,0,360,85,GoS.Red)
	if GetCursorPos().x < 350 and GetCursorPos().y < 75 then
		FillRect(0,0,350,75,GoS.White)
	else
		FillRect(0,0,350,75,GoS.Black)
	end
	DrawText("|?| Update to v"..self.webV, 40, 10, 10, GoS.Green)
end

function Update:Click(key,msg)
	if key == 513 and GetCursorPos().x < 350 and GetCursorPos().y < 75 then
		DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Series.lua", SCRIPT_PATH .. "SL-Series.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
		print("DL")
	end
end

Update()
