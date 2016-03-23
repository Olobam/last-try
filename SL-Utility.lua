local SLUtility = 0.01
local SLUPatchnew, SLUPatchold = 6.5, 6.4
local AutoUpdater = true

Callback.Add("Load", function()	
	Update()
	Init()
	
	PrintChat("<font color=\"#fd8b12\"><b>["..SLUPatchnew.."-"..SLUPatchold.."] [SL-Utility] v.: "..SLUtility.." - <font color=\"#F2EE00\"> Loaded </b></font>")
	
	if SLS.Loader.LSK:Value() then
		SkinChanger()
	end
	if SLS.Loader.LAL:Value() then
		AutoLevel()
	end
	if SLS.Loader.LH:Value() then
		Humanizer()
	end
	if SLS.Loader.LRLI:Value() then 
		Reallifeinfo()
	end
end)

function Init:__init()

	SLS = MenuConfig("SL-Utility", "SL-Utility")
	SLS:Menu("Loader", "|SL| Loader")
	L = SLS["Loader"]
	L:Info("0.1xy", "")
	L:Boolean("LSK", "Load SkinChanger", true)
	L:Info("0.3", "")
	L:Boolean("LAL", "Load AutoLevel", true)
	L:Info("0.4", "")
	L:Boolean("LH", "Load Humanizer", true)
	L:Info("0.6.", "")
	L:Boolean("LRLI", "Load Real life info", true)
	L:Info("0.6yc", "")
	L:Info("0.7.", "You will have to press 2f6")
	L:Info("0.8.", "to apply the changes")
end

class 'Humanizer'

function Humanizer:__init()

self.bCount = 0
self.bCount1 = 0
self.lastCommand = 0
self.lastspell = 0

	SLS:SubMenu("Hum", "|SL| Humanizer")
	SLS.Hum:Boolean("Draw", "Draw blocked movements", true)
	SLS.Hum:Boolean("Draw1", "Draw blocked spells", true)
	SLS.Hum:Boolean("enable", "Use Movement Limiter", true)
	SLS.Hum:Boolean("enable1", "Use SpellCast Limiter", true)
	SLS.Hum:Slider("Horizontal", "Horizontal (Drawings)", 0, 0, GetResolution().x, 10)
	SLS.Hum:Slider("Vertical", "Vertical (Drawings)", 0, 0, GetResolution().y, 10)
	SLS.Hum:Info("as-.,", "if your champ stutters you will")
	SLS.Hum:Info("sa-.,", "have to turn off spellcast limiter")
	SLS.Hum:Menu("ML", "Movement Limiter")
	SLS.Hum.ML:Slider("lhit", "Max. Movements in Last Hit", 6, 1, 20, 1)
	SLS.Hum.ML:Slider("lclear", "Max. Movements in Lane Clear", 6, 1, 20, 1)
	SLS.Hum.ML:Slider("harass", "Max. Movements in Harass", 7, 1, 20, 1)
	SLS.Hum.ML:Slider("combo", "Max. Movements in Combo", 8, 1, 20, 1)
	SLS.Hum.ML:Slider("perm", "Persistant Max. Movements", 7, 1, 20, 1)
	SLS.Hum:Menu("SPC", "SpellCast Limiter")
	SLS.Hum.SPC:Slider("blhit", "Max. Spells in LastHit", 1, 1, 8, 1)
	SLS.Hum.SPC:Slider("blclear", "Max. Spells in LaneClear", 1, 1, 8, 1)
	SLS.Hum.SPC:Slider("bharass", "Max. Spells in Harass", 2, 1, 8, 1)
	SLS.Hum.SPC:Slider("bcombo", "Max. Spells in Combo", 3, 1, 8, 1)
	SLS.Hum.SPC:Slider("bperm", "Persistant Max. Spells", 2, 1, 8, 1)
	
 Callback.Add("IssueOrder", function(order) self:IssueOrder(order) end)
 Callback.Add("SpellCast", function(spell) self:SpellCast(spell) end)
 Callback.Add("Draw", function() self:Draw() end)
end

function Humanizer:moveEvery()
	if IOW:Mode() == "Combo" then
		return 1 / SLS.Hum.ML.combo:Value()
	elseif IOW:Mode() == "LastHit" then
		return 1 / SLS.Hum.ML.lhit:Value()
	elseif IOW:Mode() == "Harass" then
		return 1 / SLS.Hum.ML.harass:Value()
	elseif IOW:Mode() == "LaneClear" then
		return 1 / SLS.Hum.ML.lclear:Value()
	else
		return 1 / SLS.Hum.ML.perm:Value()
	end
end

function Humanizer:Spells()
	if IOW:Mode() == "Combo" then
		return 1 / SLS.Hum.SPC.bcombo:Value()
	elseif IOW:Mode() == "LastHit" then
		return 1 / SLS.Hum.SPC.blhit:Value()
	elseif IOW:Mode() == "Harass" then
		return 1 / SLS.Hum.SPC.bharass:Value()
	elseif IOW:Mode() == "LaneClear" then
		return 1 / SLS.Hum.SPC.blclear:Value()
	else
		return 1 / SLS.Hum.SPC.bperm:Value()
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

function Humanizer:SpellCast(spell)
	if SLS.Hum.enable1:Value() and IOW:Mode() ~= nil then
		if os.clock() - self.lastspell < self:Spells() then
		  BlockCast()
		  self.bCount1 = self.bCount1 + 1
		else
		  self.lastspell = os.clock()
		end
	end
end

function Humanizer:Draw()
	if SLS.Hum.Draw:Value() then
  		DrawText("Blocked Movements : "..tostring(self.bCount),25,SLS.Hum.Horizontal:Value(),SLS.Hum.Vertical:Value(),ARGB(255,159,242,12))
	end
	if SLS.Hum.Draw1:Value() then
  		DrawText("Blocked Spells : "..tostring(self.bCount1),25,SLS.Hum.Horizontal:Value(),SLS.Hum.Vertical:Value()+20,ARGB(255,159,242,12))
	end
end

class 'Reallifeinfo'

function Reallifeinfo:__init()
	SLS:Menu("Date", "|SL| Real life info")
	SLS.Date:Menu("DDA", "Draw Date")
	SLS.Date.DDA:Boolean("DrawDate", "Draw Current Date", true)
	SLS.Date.DDA:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLS.Date.DDA:Slider("Vertical", "Vertical (Drawings)", 60, 0, GetResolution().y, 10)
	SLS.Date.DDA:ColorPick("ColorPick", "Color Pick - Date", {255,226,255,18})
	SLS.Date:Menu("DD", "Draw Day")
	SLS.Date.DD:Boolean("DrawDay", "Draw Current Day", true)
	SLS.Date.DD:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLS.Date.DD:Slider("Vertical", "Vertical (Drawings)", 80, 0, GetResolution().y, 10)
	SLS.Date.DD:ColorPick("ColorPick", "Color Pick - Day", {255,226,255,18})
	SLS.Date:Menu("DM", "Draw Month")
	SLS.Date.DM:Boolean("DrawMonth", "Draw Current Month", true)
	SLS.Date.DM:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLS.Date.DM:Slider("Vertical", "Vertical (Drawings)", 100, 0, GetResolution().y, 10)
	SLS.Date.DM:ColorPick("ColorPick", "Color Pick - Month", {255,226,255,18})
	SLS.Date:Menu("DY", "Draw Year")
	SLS.Date.DY:Boolean("DrawYear", "Draw Current Year", true)
	SLS.Date.DY:Slider("Horizontal", "Horizontal (Drawings)", GetResolution().x*.9, 0, GetResolution().x, 10)
	SLS.Date.DY:Slider("Vertical", "Vertical (Drawings)", 120, 0, GetResolution().y, 10)
	SLS.Date.DY:ColorPick("ColorPick", "Color Pick - Year", {255,226,255,18})
	
	Callback.Add("Draw", function() self:EnableDraw() end)
end

function Reallifeinfo:EnableDraw()
	if SLS.Date.DD.DrawDay:Value() then
		DrawText("Current Day     : "..os.date("%A"), 15, SLS.Date.DD.Horizontal:Value(), SLS.Date.DD.Vertical:Value(), SLS.Date.DD.ColorPick:Value())
	end
	if SLS.Date.DDA.DrawDate:Value() then
		DrawText("Current Date    : "..os.date("%x", os.time()), 15, SLS.Date.DDA.Horizontal:Value(), SLS.Date.DDA.Vertical:Value(), SLS.Date.DDA.ColorPick:Value())
	end
	if SLS.Date.DM.DrawMonth:Value() then
		DrawText("Current Month : "..os.date("%B"), 15, SLS.Date.DM.Horizontal:Value(), SLS.Date.DM.Vertical:Value(), SLS.Date.DM.ColorPick:Value())
	end
	if SLS.Date.DY.DrawYear:Value() then
		DrawText("Current Year   : "..os.date("%Y"), 15, SLS.Date.DY.Horizontal:Value(), SLS.Date.DY.Vertical:Value(), SLS.Date.DY.ColorPick:Value())
	end
end


class 'AutoLevel'

function AutoLevel:__init()
	SLS:SubMenu("AL", "|SL| Auto Level")
	SLS.AL:Boolean("aL", "Use AutoLvl", false)
	SLS.AL:DropDown("aLS", "AutoLvL", 1, {"Q-W-E","Q-E-W","W-Q-E","W-E-Q","E-Q-W","E-W-Q"})
	SLS.AL:Slider("sL", "Start AutoLvl with LvL x", 4, 1, 18, 1)
	SLS.AL:Boolean("hL", "Humanize LvLUP", true)
	SLS.AL:Slider("hT", "Humanize min delay", .5, 0, 1, .1)
	SLS.AL:Slider("hF", "Humanize time frame", .2, 0, .5, .1)
	
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
		if SLS.AL.hL:Value() then
			DelayAction(function() LevelSpell(self.lTable[SLS.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]) end, math.random(SLS.AL.hT:Value(),SLS.AL.hT:Value()+SLS.AL.hF:Value()))
		else
			LevelSpell(self.lTable[SLS.AL.aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1])
		end
	end
end

class 'SkinChanger'

function SkinChanger:__init()

	SLS:SubMenu("S", "|SL| Skin")
	SLS.S:Boolean("uS", "Use Skin", true)
	SLS.S:Slider("sV", "Skin Number", 0, 0, 15, 1)
	
	local cSkin = 0
	
	Callback.Add("Tick", function() self:Change() end)
end

function SkinChanger:Change()
	if SLS.S.uS:Value() and SLS.S.sV:Value() ~= cSkin then
		HeroSkinChanger(myHero,SLS.S.sV:Value()) 
		cSkin = SLS.S.sV:Value()
	elseif not SLS.S.uS:Value() and cSkin ~= 0 then
		HeroSkinChanger(myHero,0)
		cSkin = 0 
	end
end

class 'Update'

function Update:__init()
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
		DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Utility.lua", SCRIPT_PATH .. "SL-Utility.lua", function() self.State = "Update Complete" PrintChat("<font color=\"#fd8b12\"><b>[SL-Utility] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return	end)
	elseif key == 513 and cur.x > 370 and cur.x < 400 and cur.y > 7 and cur.y < 60 then
		Callback.Del("Draw", function() self:Box() end)
		self.Do = false
	end
end
