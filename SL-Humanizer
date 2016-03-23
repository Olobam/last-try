local ver = "0.1"
local SLS = MenuConfig("SL-Humanizer", "SL-Humanizer")

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

function Humanizer:Movement()
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
		if os.clock() - self.lastCommand < self:Movement() then
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

Humanizer()


function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
       PrintChat("<font color=\"#fd8b12\"><b>[SL-Humanizer] - <font color=\"#F2EE00\">New version found !" ..data.. "</b></font>")
	   PrintChat("<font color=\"#fd8b12\"><b>[SL-Humanizer] - <font color=\"#F2EE00\">Downloading update, please wait...</b></font>")
        DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Humanizer.lua", SCRIPT_PATH .. "SL-Humanizer.lua", function() PrintChat("<font color=\"#fd8b12\"><b>[SL-Humanizer] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return end)
    else
       PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Humanizer.version", AutoUpdate)
