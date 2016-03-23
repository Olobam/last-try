local SLUtility = 0.01
local SLUPatchnew, SLUPatchold = 6.5, 6.4
local AutoUpdater = true


require 'Inspired'


Callback.Add("Load", function()	
	AutoUpdate()
	Initi()
	
	PrintChat("<font color=\"#fd8b12\"><b>["..SLUPatchnew.."-"..SLUPatchold.."] [SL-Utility] v.: "..SLUtility.." - <font color=\"#F2EE00\"> Loaded </b></font>")
	
	if SLU.Load.LSK:Value() then
		SkinChanger()
	end
	if SLU.Load.LAL:Value() then
		AutoLevel()
	end
	if SLU.Load.LH:Value() then
		Humanizer()
	end
	if SLU.Load.LRLI:Value() then 
		Reallifeinfo()
	end
end)


class 'Initi'

function Initi:__init()

	SLU = MenuConfig("SL-Utility", "SL-Utility")
	SLU:Menu("Load", "|SL| Loader")
	SLU.Load:Boolean("LSK", "Load SkinChanger", true)
	SLU.Load:Info("0.3", "")
	SLU.Load:Boolean("LAL", "Load AutoLevel", true)
	SLU.Load:Info("0.4", "")
	SLU.Load:Boolean("LH", "Load Humanizer", true)
	SLU.Load:Info("0.6.", "")
	SLU.Load:Boolean("LRLI", "Load Real life info", true)
	SLU.Load:Info("0.6yc", "")
	SLU.Load:Info("0.7.", "You will have to press 2f6")
	SLU.Load:Info("0.8.", "to apply the changes")
	
end


class 'Humanizer'

function Humanizer:__init()

self.bCount = 0
self.bCount1 = 0
self.lastCommand = 0
self.lastspell = 0

	SLU:SubMenu("Hum", "|SL| Humanizer")
	SLU.Hum:Boolean("Draw", "Draw blocked movements", true)
	SLU.Hum:Boolean("Draw1", "Draw blocked spells", true)
	SLU.Hum:Boolean("enable", "Use Movement Limiter", true)
	SLU.Hum:Boolean("enable1", "Use SpellCast Limiter", true)
	SLU.Hum:Slider("Horizontal", "Horizontal (Drawings)", 0, 0, GetResolution().x, 10)
	SLU.Hum:Slider("Vertical", "Vertical (Drawings)", 0, 0, GetResolution().y, 10)
	SLU.Hum:Info("as-.,", "if your champ stutters you will")
	SLU.Hum:Info("sa-.,", "have to turn off spellcast limiter")
	SLU.Hum:Menu("ML", "Movement Limiter")
	SLU.Hum.ML:Slider("lhit", "Max. Movements in Last Hit", 6, 1, 20, 1)
	SLU.Hum.ML:Slider("lclear", "Max. Movements in Lane Clear", 6, 1, 20, 1)
	SLU.Hum.ML:Slider("harass", "Max. Movements in Harass", 7, 1, 20, 1)
	SLU.Hum.ML:Slider("combo", "Max. Movements in Combo", 8, 1, 20, 1)
	SLU.Hum.ML:Slider("perm", "Persistant Max. Movements", 7, 1, 20, 1)
	SLU.Hum:Menu("SPC", "SpellCast Limiter")
	SLU.Hum.SPC:Slider("blhit", "Max. Spells in LastHit", 1, 1, 8, 1)
	SLU.Hum.SPC:Slider("blclear", "Max. Spells in LaneClear", 1, 1, 8, 1)
	SLU.Hum.SPC:Slider("bharass", "Max. Spells in Harass", 2, 1, 8, 1)
	SLU.Hum.SPC:Slider("bcombo", "Max. Spells in Combo", 3, 1, 8, 1)
	SLU.Hum.SPC:Slider("bperm", "Persistant Max. Spells", 2, 1, 8, 1)
	
 Callback.Add("IssueOrder", function(order) self:IssueOrder(order) end)
 Callback.Add("SpellCast", function(spell) self:SpellCast(spell) end)
 Callback.Add("Draw", function() self:Draw() end)
end

function Humanizer:moveEvery()
	if IOW:Mode() == "Combo" then
		return 1 / SLU.Hum.ML.combo:Value()
	elseif IOW:Mode() == "LastHit" then
		return 1 / SLU.Hum.ML.lhit:Value()
	elseif IOW:Mode() == "Harass" then
		return 1 / SLU.Hum.ML.harass:Value()
	elseif IOW:Mode() == "LaneClear" then
		return 1 / SLU.Hum.ML.lclear:Value()
	else
		return 1 / SLU.Hum.ML.perm:Value()
	end
end

function Humanizer:Spells()
	if IOW:Mode() == "Combo" then
		return 1 / SLU.Hum.SPC.bcombo:Value()
	elseif IOW:Mode() == "LastHit" then
		return 1 / SLU.Hum.SPC.blhit:Value()
	elseif IOW:Mode() == "Harass" then
		return 1 / SLU.Hum.SPC.bharass:Value()
	elseif IOW:Mode() == "LaneClear" then
		return 1 / SLU.Hum.SPC.blclear:Value()
	else
		return 1 / SLU.Hum.SPC.bperm:Value()
	end
end

function Humanizer:IssueOrder(order)
	if order.flag == 2 and SLU.Hum.enable:Value() and IOW:Mode() ~= nil then
		if os.clock() - self.lastCommand < self:moveEvery() then
		  BlockOrder()
		  self.bCount = self.bCount + 1
		else
		  self.lastCommand = os.clock()
		end
	end
end

function Humanizer:SpellCast(spell)
	if SLU.Hum.enable1:Value() and IOW:Mode() ~= nil then
		if os.clock() - self.lastspell < self:Spells() then
		  BlockCast()
		  self.bCount1 = self.bCount1 + 1
		else
		  self.lastspell = os.clock()
		end
	end
end

function Humanizer:Draw()
	if SLU.Hum.Draw:Value() then
  		DrawText("Blocked Movements : "..tostring(self.bCount),25,SLU.Hum.Horizontal:Value(),SLU.Hum.Vertical:Value(),ARGB(255,159,242,12))
	end
	if SLU.Hum.Draw1:Value() then
  		DrawText("Blocked Spells : "..tostring(self.bCount1),25,SLU.Hum.Horizontal:Value(),SLU.Hum.Vertical:Value()+20,ARGB(255,159,242,12))
	end
end


class 'Reallifeinfo'

function Reallifeinfo:__init()
	SLU:Menu("Date", "|SL| Real life info")
	SLU.Date:Menu("DDA", "Draw Date")
	SLU.Date.DDA:Boolean("DrawDate", "Draw Current Date", true)
	SLU.Date.DDA:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLU.Date.DDA:Slider("Vertical", "Vertical (Drawings)", 60, 0, GetResolution().y, 10)
	SLU.Date.DDA:ColorPick("ColorPick", "Color Pick - Date", {255,226,255,18})
	SLU.Date:Menu("DD", "Draw Day")
	SLU.Date.DD:Boolean("DrawDay", "Draw Current Day", true)
	SLU.Date.DD:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLU.Date.DD:Slider("Vertical", "Vertical (Drawings)", 80, 0, GetResolution().y, 10)
	SLU.Date.DD:ColorPick("ColorPick", "Color Pick - Day", {255,226,255,18})
	SLU.Date:Menu("DM", "Draw Month")
	SLU.Date.DM:Boolean("DrawMonth", "Draw Current Month", true)
	SLU.Date.DM:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLU.Date.DM:Slider("Vertical", "Vertical (Drawings)", 100, 0, GetResolution().y, 10)
	SLU.Date.DM:ColorPick("ColorPick", "Color Pick - Month", {255,226,255,18})
	SLU.Date:Menu("DY", "Draw Year")
	SLU.Date.DY:Boolean("DrawYear", "Draw Current Year", true)
	SLU.Date.DY:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLU.Date.DY:Slider("Vertical", "Vertical (Drawings)", 120, 0, GetResolution().y, 10)
	SLU.Date.DY:ColorPick("ColorPick", "Color Pick - Year", {255,226,255,18})
	
	Callback.Add("Draw", function() self:EnableDraw() end)
end

function Reallifeinfo:EnableDraw()
	if SLU.Date.DD.DrawDay:Value() then
		DrawText("Current Day     : "..os.date("%A"), 15, SLU.Date.DD.Horizontal:Value(), SLU.Date.DD.Vertical:Value(), SLU.Date.DD.ColorPick:Value())
	end
	if SLU.Date.DDA.DrawDate:Value() then
		DrawText("Current Date    : "..os.date("%x", os.time()), 15, SLU.Date.DDA.Horizontal:Value(), SLU.Date.DDA.Vertical:Value(), SLU.Date.DDA.ColorPick:Value())
	end
	if SLU.Date.DM.DrawMonth:Value() then
		DrawText("Current Month : "..os.date("%B"), 15, SLU.Date.DM.Horizontal:Value(), SLU.Date.DM.Vertical:Value(), SLU.Date.DM.ColorPick:Value())
	end
	if SLU.Date.DY.DrawYear:Value() then
		DrawText("Current Year   : "..os.date("%Y"), 15, SLU.Date.DY.Horizontal:Value(), SLU.Date.DY.Vertical:Value(), SLU.Date.DY.ColorPick:Value())
	end
end


class 'AutoLevel'

function AutoLevel:__init()
	SLU:SubMenu("AL", "|SL| Auto Level")
	SLU.AL:Boolean("aL", "Use AutoLvl", false)
	SLU.AL:DropDown("aLS", "AutoLvL", 1, {"Q-W-E","Q-E-W","W-Q-E","W-E-Q","E-Q-W","E-W-Q"})
	SLU.AL:Slider("sL", "Start AutoLvl with LvL x", 4, 1, 18, 1)
	SLU.AL:Boolean("hL", "Humanize LvLUP", true)
	SLU.AL:Slider("hT", "Humanize min delay", .5, 0, 1, .1)
	SLU.AL:Slider("hF", "Humanize time frame", .2, 0, .5, .1)
	
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
	if SLU.AL.aL:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= SLU.AL.sL:Value() then
		if SLU.AL.hL:Value() then
			DelayAction(function() LevelSpell(self.lTable[SLU.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(SLU.AL.hT:Value(),SLU.AL.hT:Value()+SLU.AL.hF:Value()))
		else
			LevelSpell(self.lTable[SLU.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
		end
	end
end


class 'SkinChanger'

function SkinChanger:__init()

	SLU:SubMenu("S", "|SL| Skin")
	SLU.S:Boolean("uS", "Use Skin", true)
	SLU.S:Slider("sV", "Skin Number", 0, 0, 15, 1)
	
	local cSkin = 0
	
	Callback.Add("Tick", function() self:Change() end)
end

function SkinChanger:Change()
	if SLU.S.uS:Value() and SLU.S.sV:Value() ~= cSkin then
		HeroSkinChanger(myHero,SLU.S.sV:Value()) 
		cSkin = SLU.S.sV:Value()
	elseif not SLU.S.uS:Value() and cSkin ~= 0 then
		HeroSkinChanger(myHero,0)
		cSkin = 0 
	end
end


class 'AutoUpdate'

function AutoUpdate:__init()
	if not AutoUpdater then return end
	self.webV = "Error"
	self.Stat = "Error"
	self.Do = true

	function AutoUpdate(data)
		if tonumber(data) > SLUtility then
			self.webV = data
			self.State = "|SL-Utility| Update to v"..self.webV
			Callback.Add("Draw", function() self:Box() end)
			Callback.Add("WndMsg", function(key,msg) self:Click(key,msg) end)
		end
	end

	GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Utility.version", AutoUpdate)
end

function AutoUpdate:Box()
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

function AutoUpdate:Click(key,msg)
	local cur = GetCursorPos()
	if key == 513 and cur.x < 350 and cur.y < 75 then
		self.State = "Downloading..."
		DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Utility.lua", SCRIPT_PATH .. "SL-Utility.lua", function() self.State = "Update Complete" PrintChat("<font color=\"#fd8b12\"><b>[SL-Utility] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return	end)
	elseif key == 513 and cur.x > 370 and cur.x < 400 and cur.y > 7 and cur.y < 60 then
		Callback.Del("Draw", function() self:Box() end)
		self.Do = false
	end
end
