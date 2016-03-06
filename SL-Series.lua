local SL-Series = 0.01

require 'Inspired'
	
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
	
	local SLSkin = { --Credits to Icesythe7
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

	local SL = MenuConfig("SL-Series", "SL-Series")
	SL:Menu("Loader", "|SL| Loader") L = SL["Loader"] L:Boolean("LC", "|SL| Load Champion", true) L:Boolean("LD", "|SL| Load Drawings", true) L:Boolean("LSK", "|SL| Load SkinChanger", true) L:Info("516", "You will have to press 2f6") L:Info("546", "to apply the changes")
	if L.LSK:Value() then SL:Menu("SC", "|SL| SkinChanger") SKCH = SL["SC"] SKCH:DropDown('Skins', "|SL| Skins for "..ChampName.." -->", 1, SLSkin[ChampName]) end
	if L.LD:Value() then SL:Menu("D", "|SL| Drawings") D = SL["D"] D:Boolean("LastHitMarker", "|SL| LastHitMarker", true) D:Boolean("DrawQ", "|SL| Draw Q", true) D:Boolean("DrawW", "|SL| Draw W", true) D:Boolean("DrawE", "|SL| Draw E", true) D:Boolean("DrawR", "|SL| Draw R", true) D:ColorPick("ColorPick", "|SL| Circle color", {255,102,102,102}) end
	SL:Info("511a", "") SL:Info("512a", "Changelog :::") SL:Info("513a", SxcSAIOChangelog1) SL:Info("531a", SxcSAIOChangelog2) SL:Info("535a", SxcSAIOChangelog3)
  if L.LC:Value() then
	SL:Menu(ChampName, ChampName) BM = SL[ChampName] 
	BM:Menu("C", "|SL| Combo")	
	BM:Menu("M", "|SL| Misc")
	BM.M:Menu("AL", "|SL| Auto Level") BM.M.AL:DropDown("AL", "|SL| Auto Level -->", 1, {"Disabled", "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q"}) BM.M.AL:Slider("ALH", "|SL| Auto Level Humanizer", 1500, 0, 3000, 5)
	if AntiGapCloser[ChampName] == true then BM.M:Menu("AGP", "|SL| AntiGapCloser") end
	if Harass[ChampName] == true then BM:Menu("H", "|SL| Harass") end
	if Last[ChampName] == true then BM:Menu("LH", "|SL| LastHit") end
	if Lane[ChampName] == true then BM:Menu("LC", "|SL| LaneClear") end
	if Jungle[ChampName] == true then BM:Menu("JC", "|SL| JungleClear")	end
	if Kill[ChampName] == true then BM:Menu("KS", "|SL| KillSteal") end
	if AutoQ[ChampName] == true then BM:Menu("AQ", "|SL| Auto Q") end
	if AutoW[ChampName] == true then BM:Menu("AW", "|SL| Auto W") end
	if AutoE[ChampName] == true then BM:Menu("AE", "|SL| Auto E") end
	if AutoR[ChampName] == true then BM:Menu("AR", "|SL| Auto R") end
	if Prediction[ChampName] == true then BM.M:Menu("P", "|SL| Prediction") BM.M.P:Slider("QHC", "|SL| Q HitChance", 40, 1, 100, 10) BM.M.P:Slider("WHC", "|SL| W HitChance", 40, 1, 100, 10) BM.M.P:Slider("EHC", "|SL| E HitChance", 40, 1, 100, 10) BM.M.P:Slider("RHC", "|SL| R HitChance", 65, 1, 100, 10) end
	if ManaManager[ChampName] == true then BM.M:Menu("MM", "|SL| ManaManager") BM.M.MM:Slider("MQ", "|SL| Mana to use Q >= x ", 10, 1, 100, 10) BM.M.MM:Slider("MW", "|SL| Mana to use W >= x ", 10, 1, 100, 10) BM.M.MM:Slider("ME", "|SL| Mana to use E >= x ", 10, 1, 100, 10) BM.M.MM:Slider("MR", "|SL| Mana to use R >= x ", 10, 1, 100, 10) end
	if GapCloser[ChampName] == true then BM.M:Menu("GC", "|SL| GapCloser") end
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
	self.Stat = "Error"
	self.Do = true

	function AutoUpdate(data)
		if tonumber(data) > SL-Series then
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
		DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Series.lua", SCRIPT_PATH .. "SL-Series.lua", function() self.State = "Update Complete" PrintChat("Reload the Script with 2x F6") return	end)
		DelayAction(function() self.State = "Update Complete" PrintChat("Reload the Script with 2x F6") Callback.Del("WndMsg", function(key,msg) end) end,1)
	elseif key == 513 and cur.x > 370 and cur.x < 400 and cur.y > 7 and cur.y < 60 then
		Callback.Del("Draw", function() self:Box() end)
		self.Do = false
	end
end
