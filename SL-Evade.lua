local SLEAutoUpdate = true
local Stage, SLEvadeVer = "Alpha", "0.01"
local SLEPatchnew = nil
if GetGameVersion():sub(3,4) >= "10" then
		SLEPatchnew = GetGameVersion():sub(1,4)
	else
		SLEPatchnew = GetGameVersion():sub(1,3)
end

local t = {_G.HoldPosition, _G.AttackUnit}
local function DisableHoldPosition(boolean)
	if boolean then
		_G.HoldPosition, _G.AttackUnit = function() end, function() end
	else
		_G.HoldPosition, _G.AttackUnit = t[1], t[2]
	end
end

local function dArrow(s, e, w, c)--startpos,endpos,width,color
	DrawLine3D(s.x,s.y,s.z,e.x,e.y,e.z,w,c)
	local s2 = e-((s-e):normalized()*75):perpendicular()+(s-e):normalized()*75
	DrawLine3D(s2.x,s2.y,s2.z,e.x,e.y,e.z,w,c)
	local s3 = e-((s-e):normalized()*75):perpendicular2()+(s-e):normalized()*75
	DrawLine3D(s3.x,s3.y,s3.z,e.x,e.y,e.z,w,c)
end

Callback.Add("Load", function()	
	EMenu = Menu("SL-Evade", "["..SLEPatchnew.."][v.:"..SLEvadeVer.."] SL-Evade")
	SLEAutoUpdater()
	SLEvade()
	require 'MapPositionGOS'
	PrintChat("<font color=\"#fd8b12\"><b>["..SLEPatchnew.."] [SL-Evade] v.: ["..Stage.." - "..SLEvadeVer.."] - <font color=\"#F2EE00\"> Loaded! </b></font>")
end)


class 'SLEvade'


function SLEvade:__init()

	self.obj = {}
	self.str = {[-1]="P",[0]="Q",[1]="W",[2]="E",[3]="R"}
	self.Flash = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerflash") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerflash") and SUMMONER_2 or nil))
	self.DodgeOnlyDangerous = false -- Dodge Only Dangerous
	self.patha = nil -- wallcheck line
	self.patha2 = nil -- wallcheck line2
	self.pathb = nil -- wallcheck circ
	self.pathb2 = nil -- wallcheck circ2
	self.asd = false -- blockinput
	self.mposs = nil -- self.mousepos circ
	self.ues = false --self.usingevadespells
	self.ut = false --self.usingitems
	self.usp = false --self.usingsummonerspells
	self.mposs2 = nil -- self.mousepos line
	self.opos = nil --simulated obj pos
	self.endposs = nil --endpos
	self.mV = nil -- wp
	--collision creep [local]
	--vector intersection [local]
	--helperVector [local]
	--creep distance [local]
	--closest creep [local]
	
	self.D = { --Dash items
	[3152] = {Name = "Hextech Protobelt", State = false}
	}
	
	self.SI = {	--Stasis
	[3157] = {Name = "Hourglass", State = false},
	[3090] = {Name = "Wooglets", State = false},
	}
	EMenu:Slider("d","Danger",2,1,4,1)
	EMenu:SubMenu("Spells", "Spell Settings")
	EMenu:SubMenu("EvadeSpells", "EvadeSpell Settings")
	EMenu:SubMenu("invulnerable", "Invulnerable Settings")
	EMenu:SubMenu("Draws", "Drawing Settings")
	EMenu:SubMenu("Advanced", "Dodge Settings")
	EMenu.Advanced:Slider("ew", "Extra Spell Width", 30, 0, 100, 5)
	EMenu.Advanced:Boolean("EMC", "Enable Minion Collision", true)
	EMenu.Draws:Boolean("DSPath", "Draw SkillShot Path", true)
	EMenu.Draws:Boolean("DSEW", "Draw SkillShot Extra Width", true)
	EMenu.Draws:Boolean("DSPos", "Draw SkillShot Position", true)
	EMenu.Draws:Boolean("DEPos", "Draw Evade Position", true)
	EMenu.Draws:Boolean("DevOpt", "Draw for Devs", false)
	EMenu.Draws:Slider("SQ", "SkillShot Quality", 5, 1, 35, 5)
	EMenu.Draws:Info("asd", "lower = higher Quality")
	EMenu:SubMenu("Keys", "Key Settings")
	EMenu.Keys:KeyBinding("DD", "Disable Dodging", string.byte("K"), true)
	EMenu.Keys:KeyBinding("DDraws", "Disable Drawings", string.byte("J"), true)
	EMenu.Keys:KeyBinding("DoD", "Dodge only Dangerous", string.byte(" "))
	EMenu.Keys:KeyBinding("DoD2", "Dodge only Dangerous 2", string.byte("V"))
	
	DelayAction(function()
		for _,i in pairs(self.Spells) do
			for l,k in pairs(GetEnemyHeroes()) do
				if not self.Spells[_] then return end
				if i.charName == k.charName then
					if i.displayname == "" then i.displayname = _ end
					if not EMenu.Spells[_] then EMenu.Spells:Menu(_,""..i.charName.." | "..(self.str[i.slot] or "?").." - "..i.displayname) end
						EMenu.Spells[_]:Boolean("Dodge".._, "Enable Dodge", true)
						EMenu.Spells[_]:Boolean("Draw".._, "Enable Draw", true)
						EMenu.Spells[_]:Boolean("Dashes".._, "Enable Dashes", true)
						EMenu.Spells[_]:Info("Empty12".._, "")			
						EMenu.Spells[_]:Slider("radius".._,"Radius",(i.radius or 150), ((i.radius-50) or 50),((i.radius+100) or 250), 5)
						EMenu.Spells[_]:Slider("d".._,"Danger",(i.danger or 1), 1, 5, 1)
						EMenu.Spells[_]:Info("Empty123".._, "")
						EMenu.Spells[_]:Boolean("IsD".._,"Dangerous", i.dangerous or false)		
				end
			end
		end
		if self.EvadeSpells[GetObjectName(myHero)] then
			for i = 0,3 do
				if self.EvadeSpells[GetObjectName(myHero)][i] and self.EvadeSpells[GetObjectName(myHero)][i].name and self.EvadeSpells[GetObjectName(myHero)][i].spellKey then
				if not EMenu.EvadeSpells[self.EvadeSpells[GetObjectName(myHero)][i].name] then EMenu.EvadeSpells:Menu(self.EvadeSpells[GetObjectName(myHero)][i].name,""..myHero.charName.." | "..(self.str[i] or "?").." - "..self.EvadeSpells[GetObjectName(myHero)][i].name) end
					EMenu.EvadeSpells[self.EvadeSpells[GetObjectName(myHero)][i].name]:Boolean("Dodge"..self.EvadeSpells[GetObjectName(myHero)][i].name, "Enable Dodge", true)
					EMenu.EvadeSpells[self.EvadeSpells[GetObjectName(myHero)][i].name]:Slider("d"..self.EvadeSpells[GetObjectName(myHero)][i].name,"Danger",(self.EvadeSpells[GetObjectName(myHero)][i].dl or 1), 1, 5, 1)						
				end	
			end
		end
		if self.Flash then
			EMenu.EvadeSpells:Menu("Flash",""..myHero.charName.." | Summoner - Flash")
			EMenu.EvadeSpells.Flash:Boolean("DodgeFlash", "Enable Dodge", true)
			EMenu.EvadeSpells.Flash:Slider("dFlash","Danger", 5, 1, 5, 1)
		end
	end,.001)
	
	Callback.Add("Tick", function() self:Tickp() end)
	Callback.Add("ProcessSpell", function(unit, spellProc) self:Detection(unit,spellProc) end)
	Callback.Add("CreateObj", function(obj) self:CreateObject(obj) end)
	Callback.Add("DeleteObj", function(obj) self:DeleteObject(obj) end)
	Callback.Add("Draw", function() self:Drawp() end)
	Callback.Add("ProcessWaypoint", function(unit,wp) self:prwp(unit,wp) end)

self.Spells = {
	["AatroxQ"]={charName="Aatrox",slot=0,type="Circle",delay=0.6,range=650,radius=250,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0.225,displayname="Dark Flight",mcollision=false},
	["AatroxE"]={charName="Aatrox",slot=2,type="Line",delay=0.25,range=1075,radius=35,speed=1250,addHitbox=true,danger=3,dangerous=false,proj="AatroxEConeMissile",killTime=0,displayname="Blade of Torment",mcollision=false},
	["AhriOrbofDeception"]={charName="Ahri",slot=0,type="Line",delay=0.25,range=880,radius=100,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="AhriOrbMissile",killTime=0,displayname="Orb of Deception",mcollision=false},
	["AhriOrbReturn"]={charName="Ahri",slot=0,type="Line",delay=0.25,range=0.25+0.36,radius=100,speed=915,addHitbox=true,danger=2,dangerous=false,proj="AhriOrbReturn",killTime=0,displayname="Orb of Deception2",mcollision=false},
	["AhriSeduce"]={charName="Ahri",slot=2,type="Line",delay=0.25,range=975,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="AhriSeduceMissile",killTime=0,displayname="Charm",mcollision=true},
	["BandageToss"]={charName="Amumu",slot=0,type="Line",delay=0.25,range=1100,radius=90,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="SadMummyBandageToss",killTime=0,displayname="Bandage Toss",mcollision=true},
	["CurseoftheSadMummy"]={charName="Amumu",slot=3,type="Circle",delay=0.25,range=0,radius=550,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=1.25,displayname="Curse of the Sad Mummy",mcollision=false},
	["FlashFrost"]={charName="Anivia",slot=0,type="Line",delay=0.25,range=1100,radius=110,speed=850,addHitbox=true,danger=3,dangerous=true,proj="FlashFrostSpell",killTime=0,displayname="Flash Frost",mcollision=false},
	["Incinerate"]={charName="Annie",slot=1,type="Cone",delay=0.25,range=825,radius=80,speed=math.huge,addHitbox=false,danger=2,dangerous=false,proj="nil",killTime=0,displayname="",mcollision=false},
	["InfernalGuardian"]={charName="Annie",slot=3,type="Circle",delay=0.25,range=600,radius=251,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="nil",killTime=0.3,displayname="",mcollision=false},
	["Volley"]={charName="Ashe",slot=1,type="Line",delay=0.25,range=1250,radius=60,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="VolleyAttack",killTime=0,displayname="",mcollision=false},
	["EnchantedCrystalArrow"]={charName="Ashe",slot=3,type="Line",delay=0.25,range=20000,radius=130,speed=1600,addHitbox=true,danger=5,dangerous=true,proj="EnchantedCrystalArrow",killTime=0,displayname="Enchanted Arrow",mcollision=false},
	["AurelionSolQ"]={charName="AurelionSol",slot=0,type="Line",delay=0.25,range=1500,radius=180,speed=850,addHitbox=true,danger=2,dangerous=false,proj="AurelionSolQMissile",killTime=0,displayname="AurelionSolQ",mcollision=false},
	["AurelionSolR"]={charName="AurelionSol",slot=3,type="Line",delay=0.3,range=1420,radius=120,speed=4500,addHitbox=true,danger=3,dangerous=true,proj="AurelionSolRBeamMissile",killTime=0,displayname="AurelionSolR",mcollision=false},
	["BardQ"]={charName="Bard",slot=0,type="Line",delay=0.25,range=950,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="BardQMissile",killTime=0,displayname="BardQ",mcollision=true},
	["BardR"]={charName="Bard",slot=3,type="Circle",delay=0.5,range=3400,radius=350,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="BardR",killTime=1,displayname="BardR",mcollision=false},
	["RocketGrab"]={charName="Blitzcrank",slot=0,type="Line",delay=0.25,range=1050,radius=70,speed=1800,addHitbox=true,danger=4,dangerous=true,proj="RocketGrabMissile",killTime=0,displayname="Rocket Grab",mcollision=true},
	["StaticField"]={charName="Blitzcrank",slot=3,type="Circle",delay=0.25,range=0,radius=600,speed=math.huge,addHitbox=false,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Static Field",mcollision=false},
	["BrandQ"]={charName="Brand",slot=0,type="Line",delay=0.25,range=1100,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="BrandQMissile",killTime=0,displayname="Sear",mcollision=true},
	--["BrandW"]={charName="Brand",slot=1,type="Circle",delay=0.85,range=900,radius=240,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.275,displayname="Pillar of Flame"}, -- doesnt work
	["BraumQ"]={charName="Braum",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=1700,addHitbox=true,danger=3,dangerous=true,proj="BraumQMissile",killTime=0,displayname="Winter's Bite",mcollision=true},
	["BraumRWrapper"]={charName="Braum",slot=3,type="Line",delay=0.5,range=1200,radius=115,speed=1400,addHitbox=true,danger=4,dangerous=true,proj="braumrmissile",killTime=0,displayname="Glacial Fissure",mcollision=false},
	["CaitlynPiltoverPeacemaker"]={charName="Caitlyn",slot=0,type="Line",delay=0.3,range=1300,radius=90,speed=1800,addHitbox=true,danger=2,dangerous=false,proj="CaitlynPiltoverPeacemaker",killTime=0,displayname="Piltover Peacemaker",mcollision=false},
	["CaitlynEntrapment"]={charName="Caitlyn",slot=2,type="Line",delay=0.125,range=1000,radius=70,speed=1600,addHitbox=true,danger=1,dangerous=false,proj="CaitlynEntrapmentMissile",killTime=0,displayname="90 Caliber Net",mcollision=true},
	["CassiopeiaNoxiousBlast"]={charName="Cassiopeia",slot=0,type="Circle",delay=0.75,range=850,radius=150,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="CassiopeiaNoxiousBlast",killTime=0.2,displayname="Noxious Blast",mcollision=false},
	["CassiopeiaPetrifyingGaze"]={charName="Cassiopeia",slot=3,type="Cone",delay=0.6,range=825,radius=80,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="CassiopeiaPetrifyingGaze",killTime=0,displayname="Petrifying Gaze",mcollision=false},
	["Rupture"]={charName="Chogath",slot=0,type="Circle",delay=1.2,range=950,radius=250,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="Rupture",killTime=0.8,displayname="Rupture",mcollision=false},
	["PhosphorusBomb"]={charName="Corki",slot=0,type="Circle",delay=0.3,range=825,radius=250,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="PhosphorusBombMissile",killTime=0.35,displayname="Phosphorus Bomb",mcollision=false},
	["MissileBarrage"]={charName="Corki",slot=3,type="Line",delay=0.2,range=1300,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="MissileBarrageMissile",killTime=0,displayname="Missile Barrage",mcollision=true},
	["MissileBarrage2"]={charName="Corki",slot=3,type="Line",delay=0.2,range=1500,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="MissileBarrageMissile2",killTime=0,displayname="Missile Barrage big",mcollision=true},
	["DariusCleave"]={charName="Darius",slot=0,type="Circle",delay=0.75,range=0,radius=425 - 50,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="DariusCleave",killTime=0,displayname="Cleave",mcollision=false},
	["DariusAxeGrabCone"]={charName="Darius",slot=2,type="Cone",delay=0.25,range=550,radius=80,speed=math.huge,addHitbox=false,danger=3,dangerous=true,proj="DariusAxeGrabCone",killTime=0,displayname="Apprehend",mcollision=false},
	["DianaArc"]={charName="Diana",slot=0,type="Circle",delay=0.25,range=895,radius=195,speed=1400,addHitbox=true,danger=3,dangerous=true,proj="DianaArcArc",killTime=0,displayname="",mcollision=false},
	["DianaArcArc"]={charName="Diana",slot=0,type="Arc",delay=0.25,range=895,radius=195,speed=1400,addHitbox=true,danger=3,dangerous=true,proj="DianaArcArc",killTime=0,displayname="",mcollision=false},
	["InfectedCleaverMissileCast"]={charName="DrMundo",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=2000,addHitbox=true,danger=3,dangerous=false,proj="InfectedCleaverMissile",killTime=0,displayname="Infected Cleaver",mcollision=true},
	["DravenDoubleShot"]={charName="Draven",slot=2,type="Line",delay=0.25,range=1050,radius=130,speed=1400,addHitbox=true,danger=3,dangerous=true,proj="DravenDoubleShotMissile",killTime=0,displayname="Stand Aside",mcollision=false},
	["DravenRCast"]={charName="Draven",slot=3,type="Line",delay=0.5,range=25000,radius=160,speed=2000,addHitbox=true,danger=5,dangerous=true,proj="DravenR",killTime=0,displayname="Whirling Death",mcollision=false},
	["EkkoQ"]={charName="Ekko",slot=0,type="Line",delay=0.25,range=950,radius=60,speed=1650,addHitbox=true,danger=4,dangerous=true,proj="ekkoqmis",killTime=0,displayname="Timewinder",mcollision=false},
	["EkkoW"]={charName="Ekko",slot=1,type="Circle",delay=3.75,range=1600,radius=375,speed=1650,addHitbox=false,danger=3,dangerous=false,proj="EkkoW",killTime=1.2,displayname="Parallel Convergence",mcollision=false},
	["EkkoR"]={charName="Ekko",slot=3,type="Circle",delay=0.25,range=1600,radius=375,speed=1650,addHitbox=true,danger=3,dangerous=false,proj="EkkoR",killTime=0.2,displayname="Chronobreak",mcollision=false},
	["EliseHumanE"]={charName="Elise",slot=2,type="Line",delay=0.25,range=1100,radius=55,speed=1600,addHitbox=true,danger=4,dangerous=true,proj="EliseHumanE",killTime=0,displayname="Cocoon",mcollision=true},
	["EvelynnR"]={charName="Evelynn",slot=3,type="Circle",delay=0.25,range=650,radius=350,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="EvelynnR",killTime=0.2,displayname="Agony's Embrace"},
	["EzrealMysticShot"]={charName="Ezreal",slot=0,type="Line",delay=0.25,range=1200,radius=50,speed=1975,addHitbox=true,danger=2,dangerous=false,proj="EzrealMysticShotMissile",killTime=0,displayname="Mystic Shot",mcollision=true},
	["EzrealEssenceFlux"]={charName="Ezreal",slot=1,type="Line",delay=0.3,range=1050,radius=80,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="EzrealEssenceFluxMissile",killTime=0,displayname="Essence Flux",mcollision=true},
	["EzrealTrueshotBarrage"]={charName="Ezreal",slot=3,type="Line",delay=1,range=20000,radius=150,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="EzrealTrueshotBarrage",killTime=0,displayname="Trueshot Barrage",mcollision=false},
	["FioraW"]={charName="Fiora",slot=1,type="Line",delay=0.5,range=800,radius=70,speed=3200,addHitbox=true,danger=2,dangerous=false,proj="FioraWMissile",killTime=0,displayname="Riposte",mcollision=false},
	["FizzMarinerDoom"]={charName="Fizz",slot=3,type="Line",delay=0.25,range=1300,radius=120,speed=1350,addHitbox=true,danger=5,dangerous=true,proj="FizzMarinerDoomMissile",killTime=0,displayname="Chum the Waters",mcollision=false},
	["GalioResoluteSmite"]={charName="Galio",slot=0,type="Circle",delay=0.25,range=900,radius=200,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="GalioResoluteSmite",killTime=0.2,displayname="Resolute Smite",mcollision=false},
	["GalioRighteousGust"]={charName="Galio",slot=2,type="Line",delay=0.25,range=1200,radius=120,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="GalioRighteousGust",killTime=0,displayname="Righteous Ghost",mcollision=false},
	["GalioIdolOfDurand"]={charName="Galio",slot=3,type="Circle",delay=0.25,range=0,radius=550,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=1,displayname="Idol of Durand",mcollision=false},
	["GnarQ"]={charName="Gnar",slot=0,type="Line",delay=0.25,range=1125,radius=60,speed=2500,addHitbox=true,danger=2,dangerous=false,proj="gnarqmissile",killTime=0,displayname="Boomerang Throw",mcollision=false},
	["GnarQReturn"]={charName="Gnar",slot=0,type="Line",delay=0,range=2500,radius=75,speed=60,addHitbox=true,danger=2,dangerous=false,proj="GnarQMissileReturn",killTime=0,displayname="Boomerang Throw2",mcollision=false},
	["GnarBigQ"]={charName="Gnar",slot=0,type="Line",delay=0.5,range=1150,radius=90,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="GnarBigQMissile",killTime=0,displayname="Boulder Toss",mcollision=true},
	["GnarBigW"]={charName="Gnar",slot=1,type="Line",delay=0.6,range=600,radius=80,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="GnarBigW",killTime=0,displayname="Wallop",mcollision=false},
	["GnarE"]={charName="Gnar",slot=2,type="Circle",delay=0,range=473,radius=150,speed=903,addHitbox=true,danger=2,dangerous=false,proj="GnarE",killTime=0.2,displayname="GnarE",mcollision=false},
	["GnarBigE"]={charName="Gnar",slot=2,type="Circle",delay=0.25,range=475,radius=200,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="GnarBigE",killTime=0.2,displayname="GnarBigE",mcollision=false},
	["GnarR"]={charName="Gnar",slot=3,type="Circle",delay=0.25,range=0,radius=500,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=0.3,displayname="GnarUlt",mcollision=false},
	["GragasQ"]={charName="Gragas",slot=0,type="Circle",delay=0.25,range=1100,radius=275,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="GragasQMissile",killTime=2.5,displayname="Barrel Roll",mcollision=false},
	["GragasE"]={charName="Gragas",slot=2,type="Line",delay=0,range=950,radius=200,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="GragasE",killTime=0,displayname="Body Slam",mcollision=true},
	["GragasR"]={charName="Gragas",slot=3,type="Circle",delay=0.25,range=1050,radius=375,speed=1800,addHitbox=true,danger=5,dangerous=true,proj="GragasRBoom",killTime=0.3,displayname="Explosive Cask",mcollision=false},
	["GravesQLineSpell"]={charName="Graves",slot=0,type="Line",delay=0.25,range=808,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="GravesQLineMis",killTime=0,displayname="Buckshot",mcollision=false},
	["GravesChargeShot"]={charName="Graves",slot=3,type="Line",delay=0.25,range=1100,radius=100,speed=2100,addHitbox=true,danger=5,dangerous=true,proj="GravesChargeShotShot",killTime=0,displayname="Collateral Damage",mcollision=false},
	["Heimerdingerwm"]={charName="Heimerdinger",slot=1,type="Line",delay=0.25,range=1500,radius=70,speed=1800,addHitbox=true,danger=2,dangerous=false,proj="HeimerdingerWAttack2",killTime=0,displayname="HeimerdingerUltW",mcollision=true},
	["HeimerdingerE"]={charName="Heimerdinger",slot=2,type="Circle",delay=0.25,range=925,radius=100,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="heimerdingerespell",killTime=0.3,displayname="HeimerdingerE",mcollision=false},
	["IllaoiQ"]={charName="Illaoi",slot=0,type="Line",delay=0.75,range=850,radius=100,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="illaoiemis",killTime=0,displayname="",mcollision=false},
	["IllaoiE"]={charName="Illaoi",slot=2,type="Line",delay=0.25,range=950,radius=50,speed=1900,addHitbox=true,danger=3,dangerous=true,proj="illaoiemis",killTime=0,displayname="",mcollision=true},
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
	["JinxW"]={charName="Jinx",slot=1,type="Line",delay=0.6,range=1500,radius=60,speed=3300,addHitbox=true,danger=3,dangerous=true,proj="JinxWMissile",killTime=0,displayname="Zap",mcollision=true},
	["JinxR"]={charName="Jinx",slot=3,type="Line",delay=0.6,range=20000,radius=140,speed=1700,addHitbox=true,danger=5,dangerous=true,proj="JinxR",killTime=0,displayname="",mcollision=false},
	["KalistaMysticShot"]={charName="Kalista",slot=0,type="Line",delay=0.25,range=1200,radius=40,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="kalistamysticshotmis",killTime=0,displayname="MysticShot",mcollision=true},
	["KarmaQ"]={charName="Karma",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KarmaQMissile",killTime=0,displayname="",mcollision=true},
	["KarmaQMantra"]={charName="Karma",slot=0,type="Line",delay=0.25,range=950,radius=80,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KarmaQMissileMantra",killTime=0,displayname="",mcollision=true},
	["KarthusLayWasteA2"]={charName="Karthus",slot=0,type="Circle",delay=0.625,range=875,radius=160,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Lay Waste",mcollision=false},
	["RiftWalk"]={charName="Kassadin",slot=3,type="Circle",delay=0.25,range=450,radius=270,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="RiftWalk",killTime=0.3,displayname="",mcollision=false},
	["KennenShurikenHurlMissile1"]={charName="Kennen",slot=0,type="Line",delay=0.3,range=1050,radius=50,speed=1650,addHitbox=true,danger=2,dangerous=false,proj="KennenShurikenHurlMissile1",killTime=0,displayname="Thundering Shuriken",mcollision=true},
	["KhazixW"]={charName="Khazix",slot=1,type="Line",delay=0.25,range=1025,radius=73,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KhazixWMissile",killTime=0,displayname="",mcollision=true},
	["KhazixE"]={charName="Khazix",slot=2,type="Circle",delay=0.25,range=600,radius=300,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="KhazixE",killTime=0.2,displayname="",mcollision=false},
	["KogMawQ"]={charName="Kogmaw",slot=0,type="Line",delay=0.25,range=1200,radius=70,speed=1650,addHitbox=true,danger=2,dangerous=false,proj="KogMawQ",killTime=0,displayname="",mcollision=true},
	["KogMawVoidOoze"]={charName="Kogmaw",slot=2,type="Line",delay=0.25,range=1360,radius=120,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="KogMawVoidOozeMissile",killTime=0,displayname="Void Ooze",mcollision=false},
	["KogMawLivingArtillery"]={charName="Kogmaw",slot=3,type="Circle",delay=1.2,range=1800,radius=225,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="KogMawLivingArtillery",killTime=0.5,displayname="LivingArtillery",mcollision=false},
	["LeblancSlide"]={charName="Leblanc",slot=1,type="Circle",delay=0,range=600,radius=220,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LeblancSlide",killTime=0.2,displayname="Slide",mcollision=false},
	["LeblancSlideM"]={charName="Leblanc",slot=3,type="Circle",delay=0,range=600,radius=220,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LeblancSlideM",killTime=0.2,displayname="Slide R",mcollision=false},
	["LeblancSoulShackle"]={charName="Leblanc",slot=2,type="Line",delay=0.25,range=950,radius=70,speed=1750,addHitbox=true,danger=3,dangerous=true,proj="LeblancSoulShackle",killTime=0,displayname="Ethereal Chains R",mcollision=true},
	["LeblancSoulShackleM"]={charName="Leblanc",slot=3,type="Line",delay=0.25,range=950,radius=70,speed=1750,addHitbox=true,danger=3,dangerous=true,proj="LeblancSoulShackleM",killTime=0,displayname="Ethereal Chains",mcollision=true},
	["BlindMonkQOne"]={charName="LeeSin",slot=0,type="Line",delay=0.25,range=975,radius=65,speed=1800,addHitbox=true,danger=3,dangerous=true,proj="BlindMonkQOne",killTime=0,displayname="Sonic Wave",mcollision=true},
	["LeonaZenithBlade"]={charName="Leona",slot=2,type="Line",delay=0.25,range=905,radius=70,speed=1750,addHitbox=true,danger=3,dangerous=true,proj="LeonaZenithBladeMissile",killTime=0,displayname="Zenith Blade",mcollision=false},
	["LeonaSolarFlare"]={charName="Leona",slot=3,type="Circle",delay=1,range=1200,radius=300,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="LeonaSolarFlare",killTime=0.5,displayname="Solar Flare",mcollision=false},
	["LissandraQ"]={charName="Lissandra",slot=0,type="Line",delay=0.25,range=700,radius=75,speed=2200,addHitbox=true,danger=2,dangerous=false,proj="LissandraQMissile",killTime=0,displayname="Ice Shard",mcollision=false},
	--["LissandraQShards"]={charName="Lissandra",slot=0,type="Line",delay=0.25,range=700,radius=90,speed=2200,addHitbox=true,danger=2,dangerous=false,proj="lissandraqshards",killTime=0,displayname="Ice Shard2",mcollision=false},
	["LissandraE"]={charName="Lissandra",slot=2,type="Line",delay=0.25,range=1025,radius=125,speed=850,addHitbox=true,danger=2,dangerous=false,proj="LissandraEMissile",killTime=0,displayname="",mcollision=false},
	["LucianQ"]={charName="Lucian",slot=0,type="Line",delay=0.5,range=1300,radius=65,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="LucianQ",killTime=0,displayname="",mcollision=false},
	["LucianW"]={charName="Lucian",slot=1,type="Line",delay=0.25,range=1000,radius=55,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="lucianwmissile",killTime=0,displayname="",mcollision=true},
	["LucianRMis"]={charName="Lucian",slot=3,type="Line",delay=0.5,range=1400,radius=110,speed=2800,addHitbox=true,danger=2,dangerous=false,proj="lucianrmissileoffhand",killTime=0,displayname="LucianR",mcollision=true},
	["LuluQ"]={charName="Lulu",slot=0,type="Line",delay=0.25,range=950,radius=60,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LuluQMissile",killTime=0,displayname="",mcollision=false},
	["LuluQPix"]={charName="Lulu",slot=0,type="Line",delay=0.25,range=950,radius=60,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="LuluQMissileTwo",killTime=0,displayname="",mcollision=false},
	["LuxLightBinding"]={charName="Lux",slot=0,type="Line",delay=0.25,range=1300,radius=70,speed=1200,addHitbox=true,danger=3,dangerous=true,proj="LuxLightBindingMis",killTime=0,displayname="Light Binding",mcollision=true},
	["LuxLightStrikeKugel"]={charName="Lux",slot=2,type="Circle",delay=0.25,range=1100,radius=275,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="LuxLightStrikeKugel",killTime=5.25,displayname="LightStrikeKugel",mcollision=false},
	["LuxMaliceCannon"]={charName="Lux",slot=3,type="Line",delay=1,range=3500,radius=190,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="LuxMaliceCannon",killTime=0,displayname="Malice Cannon",mcollision=false},
	["UFSlash"]={charName="Malphite",slot=3,type="Circle",delay=0,range=1000,radius=270,speed=1500,addHitbox=true,danger=5,dangerous=true,proj="UFSlash",killTime=0.4,displayname="",mcollision=false},
	["MalzaharQ"]={charName="Malzahar",slot=0,type="Line",delay=0.75,range=900,radius=85,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="MalzaharQ",killTime=0,displayname="",mcollision=false},
	["DarkBindingMissile"]={charName="Morgana",slot=0,type="Line",delay=0.25,range=1000,radius=80,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="DarkBindingMissile",killTime=0,displayname="Dark Binding",mcollision=true},
	["NamiQ"]={charName="Nami",slot=0,type="Circle",delay=0.95,range=1625,radius=150,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="namiqmissile",killTime=0.35,displayname="",mcollision=false},
	["NamiR"]={charName="Nami",slot=3,type="Line",delay=0.5,range=2750,radius=260,speed=850,addHitbox=true,danger=2,dangerous=false,proj="NamiRMissile",killTime=0,displayname="",mcollision=false},
	["NautilusAnchorDrag"]={charName="Nautilus",slot=0,type="Line",delay=0.25,range=1250,radius=90,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="NautilusAnchorDragMissile",killTime=0,displayname="Anchor Drag",mcollision=true},
	["NocturneDuskbringer"]={charName="Nocturne",slot=0,type="Line",delay=0.25,range=1125,radius=60,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="NocturneDuskbringer",killTime=0,displayname="Duskbringer",mcollision=false},
	["JavelinToss"]={charName="Nidalee",slot=0,type="Line",delay=0.25,range=1500,radius=40,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="JavelinToss",killTime=0,displayname="JavelinToss",mcollision=true},
	["OlafAxeThrowCast"]={charName="Olaf",slot=0,type="Line",delay=0.25,range=1000,radius=105,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="olafaxethrow",killTime=0,displayname="Axe Throw",mcollision=false},
	["OriannasQ"]={charName="Orianna",slot=0,type="Line",delay=0,range=1500,radius=80,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="orianaizuna",killTime=0,displayname="",mcollision=false},
	["OriannaQend"]={charName="Orianna",slot=0,type="Circle",delay=0,range=1500,radius=90,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.1,displayname="",mcollision=false},
	["OrianaDissonanceCommand-"]={charName="Orianna",slot=1,type="Circle",delay=0.25,range=0,radius=255,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="OrianaDissonanceCommand-",killTime=0.3,displayname="",mcollision=false},
	["OriannasE"]={charName="Orianna",slot=2,type="Line",delay=0,range=1500,radius=85,speed=1850,addHitbox=true,danger=2,dangerous=false,proj="orianaredact",killTime=0,displayname="",mcollision=false},
	["OrianaDetonateCommand-"]={charName="Orianna",slot=3,type="Circle",delay=0.7,range=0,radius=410,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="OrianaDetonateCommand-",killTime=0.5,displayname="",mcollision=false},
	["QuinnQ"]={charName="Quinn",slot=0,type="Line",delay=0.313,range=1050,radius=60,speed=1550,addHitbox=true,danger=2,dangerous=false,proj="QuinnQ",killTime=0,displayname="",mcollision=true},
	["PoppyQ"]={charName="Poppy",slot=0,type="Line",delay=0.5,range=430,radius=100,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="PoppyQ",killTime=0,displayname="",mcollision=false},
	["PoppyRSpell"]={charName="Poppy",slot=3,type="Line",delay=0.3,range=1200,radius=100,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="PoppyRMissile",killTime=0,displayname="PoppyR",mcollision=false},
	["RengarE"]={charName="Rengar",slot=2,type="Line",delay=0.25,range=1000,radius=70,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="RengarEFinal",killTime=0,displayname="",mcollision=true},
	["reksaiqburrowed"]={charName="RekSai",slot=0,type="Line",delay=0.5,range=1625,radius=60,speed=1950,addHitbox=true,danger=3,dangerous=false,proj="RekSaiQBurrowedMis",killTime=0,displayname="RekSaiQ",mcollision=true},
	["RivenIzunaBlade"]={charName="Riven",slot=3,type="Line",delay=0.25,range=1100,radius=125,speed=1600,addHitbox=false,danger=5,dangerous=true,proj="RivenLightsaberMissile",killTime=0,displayname="WindSlash",mcollision=false},
	["RumbleGrenade"]={charName="Rumble",slot=2,type="Line",delay=0.25,range=950,radius=60,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="RumbleGrenade",killTime=0,displayname="Grenade",mcollision=true},
	--["RumbleCarpetBombM"]={charName="Rumble",slot=3,type="Line",delay=0.4,range=1200,radius=200,speed=1600,addHitbox=true,danger=4,dangerous=false,proj="RumbleCarpetBombMissile",killTime=0,displayname="Carpet Bomb",mcollision=false}, --doesnt work
	["RyzeQ"]={charName="Ryze",slot=0,type="Line",delay=0.25,range=900,radius=50,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="RyzeQ",killTime=0,displayname="",mcollision=true},
	["ryzerq"]={charName="Ryze",slot=0,type="Line",delay=0.25,range=900,radius=50,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ryzerq",killTime=0,displayname="RyzeQ R",mcollision=true},
	["SejuaniArcticAssault"]={charName="Sejuani",slot=0,type="Line",delay=0,range=900,radius=70,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0,displayname="ArcticAssault",mcollision=true},
	["SejuaniGlacialPrisonStart"]={charName="Sejuani",slot=3,type="Line",delay=0.25,range=1150,radius=110,speed=1350,addHitbox=true,danger=3,dangerous=true,proj="sejuaniglacialprison",killTime=0,displayname="GlacialPrisonStart",mcollision=false},
	["SionE"]={charName="Sion",slot=2,type="Line",delay=0.25,range=800,radius=80,speed=1800,addHitbox=true,danger=3,dangerous=true,proj="SionEMissile",killTime=0,displayname="",mcollision=false},
	["SionR"]={charName="Sion",slot=3,type="Line",delay=0.5,range=800,radius=120,speed=1000,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0,displayname="",mcollision=false},
	["SorakaQ"]={charName="Soraka",slot=0,type="Circle",delay=0.5,range=950,radius=300,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.275,displayname="",mcollision=false},
	["SorakaE"]={charName="Soraka",slot=2,type="Circle",delay=1.75,range=925,radius=275,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.8,displayname="",mcollision=false},
	["ShenE"]={charName="Shen",slot=2,type="Line",delay=0,range=650,radius=50,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="ShenE",killTime=0,displayname="Shadow Dash",mcollision=false},
	["ShyvanaFireball"]={charName="Shyvana",slot=2,type="Line",delay=0.25,range=950,radius=60,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ShyvanaFireballMissile",killTime=0,displayname="Fireball",mcollision=false},
	["ShyvanaTransformCast"]={charName="Shyvana",slot=3,type="Line",delay=0.25,range=1000,radius=150,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="ShyvanaTransformCast",killTime=0,displayname="Transform Cast",mcollision=false},
	["shyvanafireballdragon2"]={charName="Shyvana",slot=3,type="Line",delay=0.25,range=850,radius=70,speed=2000,addHitbox=true,danger=3,dangerous=false,proj="ShyvanaFireballDragonFxMissile",killTime=0,displayname="Fireball Dragon",mcollision=false},
	["SivirQReturn"]={charName="Sivir",slot=0,type="Line",delay=0,range=1250,radius=100,speed=1350,addHitbox=true,danger=2,dangerous=false,proj="SivirQMissileReturn",killTime=0,displayname="SivirQ2",mcollision=false},
	["SivirQ"]={charName="Sivir",slot=0,type="Line",delay=0.25,range=1250,radius=90,speed=1350,addHitbox=true,danger=2,dangerous=false,proj="SivirQMissile",killTime=0,displayname="SivirQ",mcollision=false},
	["SkarnerFracture"]={charName="Skarner",slot=2,type="Line",delay=0.25,range=1000,radius=70,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="SkarnerFractureMissile",killTime=0,displayname="Fracture",mcollision=false},
	["SonaR"]={charName="Sona",slot=3,type="Line",delay=0.25,range=1000,radius=140,speed=2400,addHitbox=true,danger=5,dangerous=true,proj="SonaR",killTime=0,displayname="Crescendo",mcollision=false},
	["SwainShadowGrasp"]={charName="Swain",slot=1,type="Circle",delay=1.1,range=900,radius=180,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="SwainShadowGrasp",killTime=0.5,displayname="Shadow Grasp",mcollision=false},
	["SyndraQ"]={charName="Syndra",slot=0,type="Circle",delay=0.6,range=800,radius=150,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="SyndraQ",killTime=0.2,displayname="",mcollision=false},
	["syndrawcast"]={charName="Syndra",slot=1,type="Circle",delay=0.25,range=950,radius=210,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="syndrawcast",killTime=0.2,displayname="SyndraW",mcollision=false},
	["syndrae5"]={charName="Syndra",slot=2,type="Line",delay=0,range=950,radius=100,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="syndrae5",killTime=0,displayname="SyndraE",mcollision=false},
	["SyndraE"]={charName="Syndra",slot=2,type="Line",delay=0,range=950,radius=100,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="SyndraE",killTime=0,displayname="SyndraE2",mcollision=false},
	["TalonRake"]={charName="Talon",slot=1,type="Line",delay=0.25,range=800,radius=80,speed=2300,addHitbox=true,danger=2,dangerous=true,proj="talonrakemissileone",killTime=0,displayname="Rake",mcollision=false},
	["TalonRakeReturn"]={charName="Talon",slot=1,type="Line",delay=0.25,range=800,radius=80,speed=1850,addHitbox=true,danger=2,dangerous=true,proj="talonrakemissiletwo",killTime=0,displayname="Rake2",mcollision=false},
	["TahmKenchQ"]={charName="TahmKench",slot=0,type="Line",delay=0.25,range=951,radius=90,speed=2800,addHitbox=true,danger=3,dangerous=true,proj="tahmkenchqmissile",killTime=0,displayname="Tongue Slash",mcollision=true},
	["TaricE"]={charName="Taric",slot=2,type="Line",delay=1,range=750,radius=100,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="TaricE",killTime=0,displayname="",mcollision=false},
	["ThreshQ"]={charName="Thresh",slot=0,type="Line",delay=0.5,range=1100,radius=70,speed=1900,addHitbox=true,danger=3,dangerous=true,proj="ThreshQMissile",killTime=0,displayname="",mcollision=true},
	["ThreshEFlay"]={charName="Thresh",slot=2,type="Line",delay=0.125,range=1075,radius=110,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="ThreshEMissile1",killTime=0,displayname="Flay",mcollision=false},
	["RocketJump"]={charName="Tristana",slot=1,type="Circle",delay=0.5,range=900,radius=270,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="RocketJump",killTime=0.3,displayname="",mcollision=false},
	["slashCast"]={charName="Tryndamere",slot=2,type="Line",delay=0,range=660,radius=93,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="slashCast",killTime=0,displayname="",mcollision=false},
	["WildCards"]={charName="TwistedFate",slot=0,type="Line",delay=0.25,range=1450,radius=40,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="SealFateMissile",killTime=0,displayname="",mcollision=false},
	["TwitchVenomCask"]={charName="Twitch",slot=1,type="Circle",delay=0.25,range=900,radius=275,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="TwitchVenomCaskMissile",killTime=0.3,displayname="Venom Cask",mcollision=false},
	["UrgotHeatseekingLineMissile"]={charName="Urgot",slot=0,type="Line",delay=0.125,range=1000,radius=60,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="UrgotHeatseekingLineMissile",killTime=0,displayname="Heatseeking Line",mcollision=true},
	["UrgotPlasmaGrenade"]={charName="Urgot",slot=2,type="Circle",delay=0.25,range=1100,radius=210,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="UrgotPlasmaGrenadeBoom",killTime=0.3,displayname="PlasmaGrenade",mcollision=false},
	["VarusQMissile"]={charName="Varus",slot=0,type="Line",delay=0.25,range=1800,radius=70,speed=1900,addHitbox=true,danger=2,dangerous=false,proj="VarusQMissile",killTime=0,displayname="VarusQ",mcollision=false},
	["VarusE"]={charName="Varus",slot=2,type="Circle",delay=1,range=925,radius=235,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="VarusE",killTime=1.5,displayname="",mcollision=false},
	["VarusR"]={charName="Varus",slot=3,type="Line",delay=0.25,range=1200,radius=120,speed=1950,addHitbox=true,danger=3,dangerous=true,proj="VarusRMissile",killTime=0,displayname="",mcollision=false},
	["VeigarBalefulStrike"]={charName="Veigar",slot=0,type="Line",delay=0.25,range=950,radius=70,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="VeigarBalefulStrikeMis",killTime=0,displayname="BalefulStrike",mcollision=false},
	["VeigarDarkMatter"]={charName="Veigar",slot=1,type="Circle",delay=1.35,range=900,radius=225,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.5,displayname="DarkMatter",mcollision=false},
	["VeigarEventHorizon"]={charName="Veigar",slot=2,type="Ring",delay=0.5,range=700,radius=80,speed=math.huge,addHitbox=false,danger=3,dangerous=true,proj="nil",killTime=3.5,displayname="EventHorizon",mcollision=false},
	["VelkozQ"]={charName="Velkoz",slot=0,type="Line",delay=0.25,range=1100,radius=50,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="VelkozQMissile",killTime=0,displayname="",mcollision=true},
	["VelkozQSplit"]={charName="Velkoz",slot=0,type="Line",delay=0.25,range=1100,radius=55,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="VelkozQMissileSplit",killTime=0,displayname="",mcollision=true},
	["VelkozW"]={charName="Velkoz",slot=1,type="Line",delay=0.25,range=1200,radius=88,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="VelkozWMissile",killTime=0,displayname="",mcollision=false},
	["VelkozE"]={charName="Velkoz",slot=2,type="Circle",delay=0.5,range=800,radius=225,speed=1500,addHitbox=false,danger=2,dangerous=false,proj="VelkozEMissile",killTime=0.5,displayname="",mcollision=false},
	["Vi-q"]={charName="Vi",slot=0,type="Line",delay=0.25,range=1000,radius=90,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="ViQMissile",killTime=0,displayname="Vi-Q",mcollision=false},
	["Laser"]={charName="Viktor",slot=2,type="Line",delay=0.25,range=1500,radius=80,speed=1050,addHitbox=true,danger=2,dangerous=false,proj="ViktorDeathRayMissile",killTime=0,displayname="",mcollision=false},
	["xeratharcanopulse2"]={charName="Xerath",slot=0,type="Line",delay=0.6,range=1600,radius=95,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="xeratharcanopulse2",killTime=0,displayname="Arcanopulse",mcollision=false},
	["XerathArcaneBarrage2"]={charName="Xerath",slot=1,type="Circle",delay=0.7,range=1000,radius=200,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="XerathArcaneBarrage2",killTime=0.3,displayname="ArcaneBarrage",mcollision=false},
	["XerathMageSpear"]={charName="Xerath",slot=2,type="Line",delay=0.2,range=1150,radius=60,speed=1400,addHitbox=true,danger=2,dangerous=true,proj="XerathMageSpearMissile",killTime=0,displayname="MageSpear",mcollision=true},
	["xerathrmissilewrapper"]={charName="Xerath",slot=3,type="Circle",delay=0.7,range=5600,radius=130,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="xerathrmissilewrapper",killTime=0.4,displayname="XerathLocusPulse",mcollision=false},
	["yasuoq"]={charName="Yasuo",slot=0,type="Line",delay=0.4,range=550,radius=20,speed=math.huge,addHitbox=true,danger=2,dangerous=true,proj="yasuoq",killTime=0,displayname="Steel Tempest 1",mcollision=false},
	["yasuoq2"]={charName="Yasuo",slot=0,type="Line",delay=0.4,range=550,radius=20,speed=math.huge,addHitbox=true,danger=2,dangerous=true,proj="yasuoq2",killTime=0,displayname="Steel Tempest 2",mcollision=false},
	["yasuoq3w"]={charName="Yasuo",slot=0,type="Line",delay=0.5,range=1150,radius=90,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="yasuoq3w",killTime=0,displayname="Steel Tempest 3",mcollision=false},
	["ZacQ"]={charName="Zac",slot=0,type="Line",delay=0.5,range=550,radius=120,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZacQ",killTime=0,displayname="",mcollision=false},
	["ZedQ"]={charName="Zed",slot=0,type="Line",delay=0.25,range=925,radius=50,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ZedQMissile",killTime=0,displayname="",mcollision=false},
	["ZiggsQ"]={charName="Ziggs",slot=0,type="Circle",delay=0.25,range=850,radius=140,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ZiggsQSpell",killTime=0.2,displayname="",mcollision=true},
	["ZiggsQBounce1"]={charName="Ziggs",slot=0,type="Circle",delay=0.25,range=850,radius=140,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ZiggsQSpell2",killTime=0.2,displayname="",mcollision=true},
	["ZiggsQBounce2"]={charName="Ziggs",slot=0,type="Circle",delay=0.25,range=850,radius=160,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ZiggsQSpell3",killTime=0.2,displayname="",mcollision=true},
	["ZiggsW"]={charName="Ziggs",slot=1,type="Circle",delay=0.25,range=1000,radius=275,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsW",killTime=2.25,displayname="",mcollision=false},
	["ZiggsE"]={charName="Ziggs",slot=2,type="Circle",delay=0.5,range=900,radius=235,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsE",killTime=2.5,displayname="",mcollision=false},
	["ZiggsR"]={charName="Ziggs",slot=3,type="Circle",delay=0,range=5300,radius=500,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZiggsR",killTime=1.25,displayname="",mcollision=false},
	["ZileanQ"]={charName="Zilean",slot=0,type="Circle",delay=0.3,range=900,radius=210,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="ZileanQMissile",killTime=1.5,displayname="",mcollision=false},
	["ZyraQ"]={charName="Zyra",slot=0,type="Rectangle",delay=0.25,range=800,radius=140,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZyraQ",killTime=0.3,displayname="",mcollision=false},
	["ZyraE"]={charName="Zyra",slot=2,type="Line",delay=0.25,range=1150,radius=70,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="ZyraE",killTime=0,displayname="Grasping Roots",mcollision=false},
	["ZyraRSplash"]={charName="Zyra",slot=3,type="Circle",delay=0.7,range=700,radius=550,speed=math.huge,addHitbox=true,danger=4,dangerous=false,proj="ZyraRSplash",killTime=1,displayname="Splash",mcollision=false},
}

self.EvadeSpells = {
	["Ahri"] = {
		[3] = {dl = 4,name = "AhriTumble",range = 500,spellDelay = 50,speed = 1575,spellKey = 3,evadeType = "DashP",castType = "Position",},
	},
	["Caitlyn"] = {
		[2] = {dl = 3,name = "CaitlynEntrapment",range = 490,spellDelay = 50,speed = 1000,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},	
	["Corki"] = {
		[1] = {dl = 3,name = "CarpetBomb",range = 790,spellDelay = 50,speed = 975,spellKey = 1,evadeType = "DashP",castType = "Position",},
	},	
	["Ekko"] = {
		[2] = {dl = 3,name = "PhaseDive",range = 350,spellDelay = 50,speed = 1150,spellKey = 2,evadeType = "DashP",castType = "Position",},
		[3] = {dl = 4,name = "Chronobreak",range = 20000,spellDelay = 50,spellKey = 3,evadeType = "DashS",castType = "Self",},
	},
	["Ezreal"] = {
		[2] = {dl = 2,name = "ArcaneShift",speed = math.huge,range = 450,spellDelay = 250,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},	
	["Gragas"] = {
		[2] = {dl = 2,name = "BodySlam",range = 600,spellDelay = 50,speed = 900,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},	
	["Gnar"] = {
		[2] = {dl = 3,name = "GnarE",range = 475,spellDelay = 50,speed = 900,spellKey = 2,evadeType = "DashP",castType = "Position",},
		[2] = {dl = 4,name = "GnarBigE",range = 475,spellDelay = 50,speed = 800,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},
	["Graves"] = { 
		[2] = {dl = 2,name = "QuickDraw",range = 425,spellDelay = 50,speed = 1250,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},	
	["Kassadin"] = { 
		[3] = {dl = 1,name = "RiftWalk",speed = math.huge,range = 450,spellDelay = 250,spellKey = 3,evadeType = "DashP",castType = "Position",},
	},	
	["Kayle"] = { 
		[3] = {dl = 4,name = "Intervention",speed = math.huge,range = 0,spellDelay = 250,spellKey = 3,evadeType = "SpellShieldT",castType = "Target",},
	},	
	["LeBlanc"] = { 
		[1] = {dl = 2,name = "Distortion",range = 600,spellDelay = 50,speed = 1600,spellKey = 1,evadeType = "DashP",castType = "Position",},
	},	
	["LeeSin"] = { 
		[1] = {dl = 3,name = "Safeguard",range = 700,speed = 1400,spellDelay = 50,spellKey = 1,evadeType = "DashT",castType = "Target",},
	},
	["Lucian"] = { 
		[2] = {dl = 1,name = "RelentlessPursuit",range = 425,spellDelay = 50,speed = 1350,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},	
	["Morgana"] = {
		[2] = {dl = 3,name = "BlackShield",speed = math.huge,range = 650,spellDelay = 50,spellKey = 2,evadeType = "SpellShieldT",castType = "Target",},
	},	
	["Nocturne"] = { 
		[1] = {dl = 3,name = "ShroudofDarkness",speed = math.huge,range = 0,spellDelay = 50,spellKey = 1,evadeType = "SpellShieldS",castType = "Self",},
	},	
	["Nidalee"] = { 
		[1] = {dl = 3,name = "Pounce",range = 375,spellDelay = 150,speed = 1750,spellKey = 1,evadeType = "DashP",castType = "Position",},
	},	
	["Fiora"] = {
		[0] = {dl = 3,name = "FioraQ",range = 340,speed = 1100,spellDelay = 50,spellKey = 0,evadeType = "DashP",castType = "Position",},
		[1] = {dl = 3,name = "FioraW",range = 750,spellDelay = 100,spellKey = 1,evadeType = "WindWallP",castType = "Position",},
	},
	["Fizz"] = { 
		[2] = {dl = 3,name = "FizzJump",range = 400,speed = 1400,spellDelay = 50,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},	
	["Riven"] = {
		[0] = {dl = 1,name = "BrokenWings",range = 260,spellDelay = 50,speed = 560,spellKey = 0,evadeType = "DashP",castType = "Position",},
		[2] = {dl = 2,name = "Valor",range = 325,spellDelay = 50,speed = 1200,spellKey = 2,evadeType = "DashP",castType = "Position",},
	},
	["Sivir"] = { 
		[2] = {dl = 2,name = "SivirE",spellDelay = 50,spellKey = 2,evadeType = "SpellShieldS",castType = "Self",BuffName = "SivirE"},
	},	
	["Shaco"] = {
		[0] = {dl = 3,name = "Deceive",range = 400,spellDelay = 250,spellKey = 0,evadeType = "DashP",castType = "Position",},
		[1] = {dl = 3,name = "JackInTheBox",range = 425,spellDelay = 250,spellKey = 1,evadeType = "WindWallP",castType = "Position",},
	},
	["Tristana"] = { 
		[1] = {dl = 3,name = "RocketJump",range = 900,spellDelay = 500,speed = 1100,spellKey = 1,evadeType = "DashP",castType = "Position",},       
	},
	["Tryndamere"] = { 
		[2] = {dl = 3,name = "SpinningSlash",range = 660,spellDelay = 50,speed = 900,spellKey = 2,evadeType = "DashP",castType = "Position",},   
	},	
	["Vayne"] = { 
		[0] = {dl = 2,name = "Tumble",range = 300,speed = 900,spellDelay = 50,spellKey = 0,evadeType = "DashP",castType = "Position",},
	},	
	["Yasuo"] = {
		[1] = {dl = 3,name = "WindWall",range = 400,spellDelay = 250,spellKey = 1,evadeType = "WindWallP",castType = "Position",},
		[2] = {dl = 2,name = "SweepingBlade",range = 475,speed = 1000,spellDelay = 50,spellKey = 2,evadeType = "DashT",castType = "Target",},
	 },
	["Vladimir"] = { 
		[1] = {dl = 4,name = "Sanguine Pool",range = 350,spellDelay = 50,spellKey = 1,evadeType = "SpellShieldS",castType = "Self",	},
	},	
	["MasterYi"] = { 
		[0] = {dl = 3,name = "AlphaStrike",range = 600,speed = math.huge,spellDelay = 100,spellKey = 0,evadeType = "DashT",castType = "Target",},
	},	
	["Katarina"] = { 
		[2] = {dl = 3,name = "KatarinaE",range = 700,speed = math.huge,spellKey = 2,evadeType = "DashT",castType = "Target",	},
	},	
	["Kindred"] = { 
		[0] = {dl = 1,name = "KindredQ",range = 300,speed = 733,spellDelay = 50,spellKey = 0,evadeType = "DashP",castType = "Position",},
	},	
	["Talon"] = { 
		[2] = {dl = 3,name = "Cutthroat",range = 700,speed = math.huge,spellDelay = 50,spellKey = 2,evadeType = "DashT",castType = "Target",},
	},
}

end

function SLEvade:Tickp()
if myHero.dead then return end
	for _,i in pairs(self.obj) do
		if not i.jp or not i.safe then
			self.asd = false
			DisableHoldPosition(false)
			BlockInput(false)
		end
		if i.o then
			i.p = {}
			i.p.startPos = Vector(i.o.startPos)
			i.p.endPos = Vector(i.o.endPos)
		end
		if i.p then
			if i.spell.type == "Line" then 
				self.Spells[_].range = GetDistance(i.p.startPos,i.p.endPos)
			end
			self.Spells[_].delay = i.p.windUpTime or self.Spells[_].delay
			self.Spells[_].speed = self.Spells[_].speed --calculation missing
			self.Spells[_].radius = EMenu.Spells[_]["radius".._]:Value()
			self:CleanObj() 
			self:Dodge()
			self:Others() 
			self:Pathfinding()
			-- print("range :"..self.Spells[_].range)
			-- print("delay :"..self.Spells[_].delay)
			-- print("speed :"..self.Spells[_].speed)
		end
		if i.spell.type == "Line" and i.spell.mcollision and i.p and EMenu.Advanced.EMC:Value() then
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
				i.ccoll = true
				i.p.endPos = vI 
				--print("Collision")
			end
		end
	end
end

function SLEvade:Drawp()
if myHero.dead then return end 
	for _,i in pairs(self.obj) do
		if i.o then
			i.p = {}
			i.p.startPos = Vector(i.o.startPos)
			i.p.endPos = Vector(i.o.endPos)
		end
		if i.p then
			self.Spells[_].range = GetDistance(i.p.startPos,i.p.endPos)
			self.Spells[_].delay = i.p.windUpTime or self.Spells[_].delay
			self.Spells[_].speed = self.Spells[_].speed --calculation missing
			self.Spells[_].radius = EMenu.Spells[_]["radius".._]:Value()
			if i.ccoll then
				self.endposs = Vector(i.p.endPos)
			else
				self.endposs = Vector(i.p.startPos)+Vector(Vector(i.p.endPos)-i.p.startPos):normalized()*(i.spell.range+i.spell.radius)
			end
			self.opos = self:sObjpos()
			self:Drawings()
			self:Drawings2()
		end
	end
end

function SLEvade:sObjpos()
	for _,i in pairs(self.obj) do
		if self.Spells[_].speed ~= math.huge then
			return Vector(i.p.endPos)-Vector(Vector(i.p.endPos)-i.p.startPos):normalized()*i.spell.range*(((i.startTime+i.spell.delay)+(i.spell.range/i.spell.speed)-os.clock())/(i.spell.range/i.spell.speed))--Vector(i.p.startPos)+Vector(Vector(self.endposs)-i.p.startPos):normalized()* (i.spell.speed*(GetGameTimer()+i.spell.delay-i.startTime)-i.spell.radius+EMenu.Advanced.ew:Value())
		else
			return Vector(i.p.startPos)
		end
	end
end

function SLEvade:Position()
return Vector(myHero) + Vector(Vector(self.mV) - myHero.pos):normalized() * myHero.ms/2
end

function SLEvade:ascad()
	for _,i in pairs(self.obj) do
		if i.jp then
			return i.jp 
		else
			return Vector(self.opos)
		end
	end
end

function SLEvade:prwp(unit, wp)
  if wp and unit == myHero and wp.index == 1 then
	self.mV = wp.position
  end
end

function SLEvade:CleanObj()
	for _,i in pairs(self.obj) do
		if i.o and not i.o.valid and _ ~= "LuxMaliceCannon" then
			self.obj[_] = nil
		end
	end
end

function SLEvade:Others()
	-- local mpads2 = Vector(myHero.pos) - Vector(Vector(myHero.pos)-GetMousePos()):normalized() * 170
	-- DrawCircle(mpads2,50,1,20,GoS.Green)
	-- print(mpads2)
	for item,c in pairs(self.SI) do
		if GetItemSlot(myHero,item)>0 then
			if not c.State and not EMenu.invulnerable[c.Name] then
				EMenu.invulnerable:Menu(c.Name,""..myHero.charName.." | Item - "..c.Name)
				EMenu.invulnerable[c.Name]:Boolean("Dodge"..c.Name, "Enable Dodge", true)
				EMenu.invulnerable[c.Name]:Slider("d"..c.Name,"Danger", 4, 1, 4, 1)
			end
			c.State = true
		else
			c.State = false
		end
	end
	for item,c in pairs(self.D) do
		if GetItemSlot(myHero,item)>0 then
			if not c.State and not EMenu.EvadeSpells[c.Name] then
				EMenu.EvadeSpells:Menu(c.Name,""..myHero.charName.." | Item - "..c.Name)
				EMenu.EvadeSpells[c.Name]:Boolean("Dodge"..c.Name, "Enable Dodge", true)
				EMenu.EvadeSpells[c.Name]:Slider("d"..c.Name,"Danger", 2, 1, 4, 1)
			end
			c.State = true
		else
			c.State = false
		end
	end
	if EMenu.Keys.DoD:Value() or EMenu.Keys.DoD2:Value() then
			self.DodgeOnlyDangerous = true
		else
			self.DodgeOnlyDangerous = false
	end
	for _,i in pairs(self.obj) do
		if i.spell.type == "Circle" then 
			if (GetDistance(self:Position(),i.p.endPos) < i.spell.radius + myHero.boundingRadius + 10) or (GetDistance(myHero,i.p.endPos) < i.spell.radius + myHero.boundingRadius + 10) and not i.safe then
				if not i.mpos and not self.mposs then
					i.mpos = Vector(myHero.pos) - Vector(Vector(myHero.pos)-GetMousePos()):normalized() * ((i.spell.radius+myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
					self.mposs = GetMousePos()
				end
			else
				self.mposs = nil
				i.mpos = nil
			end
		elseif i.spell.type == "Line" then
			if i.jp and (GetDistance(self:Position(),i.jp) < i.spell.radius + myHero.boundingRadius + 10) or (GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius + 10) and not i.safe then
				--if GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular(),jp) >= GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular2(),jp) then
					if not i.mpos and not self.mposs2 then
						i.mpos = Vector(myHero.pos) - Vector(Vector(myHero.pos)-GetMousePos()):normalized() * ((i.spell.radius+myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
						self.mposs2 = GetMousePos()
					end	
				--end
			else
				self.mposs2 = nil
				i.mpos = nil
			end
		end
		if i.safe and i.spell.type == "Line" and i.p then
			if GetDistance(self.opos)/i.spell.speed + i.spell.delay < GetDistance(i.safe)/myHero.ms then 
					i.uDodge = true 
				else
					i.uDodge = false
			end
		elseif i.safe and i.spell.type == "Circle" then
			if GetDistance(i.caster)/i.spell.speed + ((i.spell.killTime or 0)+i.spell.delay) < GetDistance(i.safe)/myHero.ms then
					i.uDodge = true 
				else
					i.uDodge = false
			end
		end
	end
end

function SLEvade:Pathfinding()
	for _,i in pairs(self.obj) do
		if i.spell.type == "Line" then
				i.p.startPos = Vector(i.p.startPos)
				i.p.endPos = Vector(i.p.endPos)
				S1 = GetOrigin(myHero)+(Vector(i.p.startPos)-Vector(i.p.endPos)):perpendicular()
				S2 = GetOrigin(myHero)
				jp = Vector(VectorIntersection(i.p.startPos,i.p.endPos,S1,S2).x,i.p.endPos.y,VectorIntersection(i.p.startPos,i.p.endPos,S1,S2).y)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius + 20 then
					i.jp = jp
				else
					i.jp = nil
				end
				if GetDistance(i.p.endPos) > i.spell.range + myHero.boundingRadius + 20 then
					i.jp = nil
				end
				if i.jp and (GetDistance(self:Position(),i.jp) < i.spell.radius + myHero.boundingRadius) or (GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius) and not i.safe and i.mpos then
					--if GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular(),jp) >= GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular2(),jp) then
						self.asd = true
						self.patha = jp + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
						self.patha2 = Vector(i.mpos) + Vector(Vector(i.mpos) - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
						if self.mposs2 and GetDistance(self.mposs2,self.patha) > GetDistance(self.mposs2,self.patha2) then
							if not MapPosition:inWall(self.patha2) then
									i.safe = Vector(i.mpos) + Vector(Vector(i.mpos) - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
								else 
									i.safe = jp + Vector(jp - self.patha2) + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
							end
						else
							if not MapPosition:inWall(self.patha) then
									i.safe = jp + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
								else 
									i.safe = jp + Vector(jp - self.patha) + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
							end
						end
					--end
					i.isEvading = true
				else
					self.asd = false
					self.patha = nil
					self.patha2 = nil
					i.safe = nil
					i.isEvading = false
					DisableHoldPosition(false)
					BlockInput(false)
				end
		elseif i.spell.type == "Circle" then
			if (GetDistance(self:Position(),i.p.endPos) < i.spell.radius + myHero.boundingRadius) or (GetDistance(myHero,i.p.endPos) < i.spell.radius + myHero.boundingRadius) and not i.safe and i.mpos then
				self.asd = true
				self.pathb = Vector(i.p.endPos) + (GetOrigin(myHero) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
				self.pathb2 = Vector(i.p.endPos) + (Vector(i.mpos) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
				if self.mposs and GetDistance(self.mposs,self.pathb) > GetDistance(self.mposs,self.pathb2) then
					if not MapPosition:inWall(self.pathb2) then
							i.safe = Vector(i.p.endPos) + (Vector(i.mpos) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
						else
							i.safe = i.p.endPos + Vector(self.pathb2-i.p.endPos):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
					end
				else
					if not MapPosition:inWall(self.pathb) then
							i.safe = Vector(i.p.endPos) + (GetOrigin(myHero) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
						else
							i.safe = i.p.endPos + Vector(self.pathb-i.p.endPos):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1+EMenu.Advanced.ew:Value())
					end
				end
				i.isEvading = true
			else
				self.asd = false
				self.pathb = nil
				self.pathb2 = nil
				i.safe = nil
				i.isEvading = false
				DisableHoldPosition(false)
				BlockInput(false)
			end
		end
	end
end

function SLEvade:Drawings()
	for _,i in pairs(self.obj) do
      if EMenu.Spells[_]["Draw".._]:Value() then
		if i.spell.type == "Line" and not EMenu.Keys.DDraws:Value() then	
			if EMenu.Draws.DSPos:Value() and self.opos then
				DrawCircle(self.opos, i.spell.radius, 1, 20, ARGB(145,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
			end	
			local endPos = Vector(self.endposs)
			local sPos = Vector(self.opos)
 			local ePos = Vector(endPos)
 			local dVec = Vector(ePos - sPos)
 			local sVec = dVec:normalized():perpendicular()*((i.spell.radius+myHero.boundingRadius)*.5)
			local sVec2 = dVec:normalized():perpendicular()*((i.spell.radius+myHero.boundingRadius)*.5+EMenu.Advanced.ew:Value())
 			local TopD1 = WorldToScreen(0,sPos+sVec)
 			local TopD2 = WorldToScreen(0,sPos-sVec)
 			local BotD1 = WorldToScreen(0,ePos+sVec)
 			local BotD2 = WorldToScreen(0,ePos-sVec)
 			local TopD3 = WorldToScreen(0,sPos+sVec2)
 			local TopD4 = WorldToScreen(0,sPos-sVec2)
 			local BotD3 = WorldToScreen(0,ePos+sVec2)
 			local BotD4 = WorldToScreen(0,ePos-sVec2)
			
			if EMenu.Draws.DSPath:Value() then
				if (GetDistance(self:Position(),self:ascad()) > i.spell.radius + myHero.boundingRadius) or (GetDistance(myHero,self:ascad()) > i.spell.radius + myHero.boundingRadius) then
					if EMenu.Spells[_]["d".._]:Value() == 1 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,0.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,0.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,0.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,0.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
					elseif EMenu.Spells[_]["d".._]:Value() == 2 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
					elseif EMenu.Spells[_]["d".._]:Value() == 3 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1.25,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1.25,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1.25,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1.25,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
					elseif EMenu.Spells[_]["d".._]:Value() == 4 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1.5,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1.5,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1.5,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1.5,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
					elseif EMenu.Spells[_]["d".._]:Value() == 5 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1.75,ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						end
					if EMenu.Draws.DSEW:Value() then
						if EMenu.Spells[_]["d".._]:Value() == 1 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,1.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,1.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,1.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,1.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						elseif EMenu.Spells[_]["d".._]:Value() == 2 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,2,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,2,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,2,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,2,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						elseif EMenu.Spells[_]["d".._]:Value() == 3 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,2.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,2.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,2.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,2.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						elseif EMenu.Spells[_]["d".._]:Value() == 4 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,3,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,3,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,3,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,3,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						elseif EMenu.Spells[_]["d".._]:Value() == 5 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,3.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,3.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,3.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,3.5,ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						end
					end
				else
					if EMenu.Spells[_]["d".._]:Value() == 1 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,0.75,GoS.Red)
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,0.75,GoS.Red)
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,0.75,GoS.Red)
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,0.75,GoS.Red)
					elseif EMenu.Spells[_]["d".._]:Value() == 2 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1,GoS.Red)
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1,GoS.Red)
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1,GoS.Red)
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1,GoS.Red)
					elseif EMenu.Spells[_]["d".._]:Value() == 3 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1.25,GoS.Red)
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1.25,GoS.Red)
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1.25,GoS.Red)
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1.25,GoS.Red)
					elseif EMenu.Spells[_]["d".._]:Value() == 4 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1.5,GoS.Red)
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1.5,GoS.Red)
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1.5,GoS.Red)
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1.5,GoS.Red)
					elseif EMenu.Spells[_]["d".._]:Value() == 5 then
						DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,1.75,GoS.Red)
						DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,1.75,GoS.Red)
						DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,1.75,GoS.Red)
						DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,1.75,GoS.Red)
					end
					if EMenu.Draws.DSEW:Value() then
						if EMenu.Spells[_]["d".._]:Value() == 1 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,1.5,GoS.Red)
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,1.5,GoS.Red)
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,1.5,GoS.Red)
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,1.5,GoS.Red)
						elseif EMenu.Spells[_]["d".._]:Value() == 2 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,2,GoS.Red)
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,2,GoS.Red)
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,2,GoS.Red)
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,2,GoS.Red)
						elseif EMenu.Spells[_]["d".._]:Value() == 3 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,2.5,GoS.Red)
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,2.5,GoS.Red)
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,2.5,GoS.Red)
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,2.5,GoS.Red)
						elseif EMenu.Spells[_]["d".._]:Value() == 4 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,3,GoS.Red)
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,3,GoS.Red)
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,3,GoS.Red)
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,3,GoS.Red)
						elseif EMenu.Spells[_]["d".._]:Value() == 5 then
							DrawLine(TopD3.x,TopD3.y,TopD4.x,TopD4.y,3.5,GoS.Red)
							DrawLine(TopD3.x,TopD3.y,BotD3.x,BotD3.y,3.5,GoS.Red)
							DrawLine(TopD4.x,TopD4.y,BotD4.x,BotD4.y,3.5,GoS.Red)
							DrawLine(BotD3.x,BotD3.y,BotD4.x,BotD4.y,3.5,GoS.Red)
						end
					end
				end
			end
			
		elseif i.spell.type == "Circle" and not EMenu.Keys.DDraws:Value() then
			if EMenu.Draws.DSPath:Value() then
				if (GetDistance(self:Position(),i.p.endPos) > i.spell.radius + myHero.boundingRadius) or (GetDistance(myHero,i.p.endPos) > i.spell.radius + myHero.boundingRadius) then
					if EMenu.Spells[_]["d".._]:Value() == 1 then
						DrawCircle(i.p.endPos,i.spell.radius,0.75,EMenu.Draws.SQ:Value(),ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))	
					elseif EMenu.Spells[_]["d".._]:Value() == 2 then
						DrawCircle(i.p.endPos,i.spell.radius,1,EMenu.Draws.SQ:Value(),ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
					elseif EMenu.Spells[_]["d".._]:Value() == 3 then
						DrawCircle(i.p.endPos,i.spell.radius,1.25,EMenu.Draws.SQ:Value(),ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
					elseif EMenu.Spells[_]["d".._]:Value() == 4 then
						DrawCircle(i.p.endPos,i.spell.radius,1.5,EMenu.Draws.SQ:Value(),ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
					elseif EMenu.Spells[_]["d".._]:Value() == 5 then
						DrawCircle(i.p.endPos,i.spell.radius,1.75,EMenu.Draws.SQ:Value(),ARGB(230,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						end
					if EMenu.Draws.DSEW:Value() then
						if EMenu.Spells[_]["d".._]:Value() == 1 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),1.5,EMenu.Draws.SQ:Value(),ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))	
						elseif EMenu.Spells[_]["d".._]:Value() == 2 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),2,EMenu.Draws.SQ:Value(),ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						elseif EMenu.Spells[_]["d".._]:Value() == 3 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),2.5,EMenu.Draws.SQ:Value(),ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						elseif EMenu.Spells[_]["d".._]:Value() == 4 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),3,EMenu.Draws.SQ:Value(),ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						elseif EMenu.Spells[_]["d".._]:Value() == 5 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),3.5,EMenu.Draws.SQ:Value(),ARGB(255,51*EMenu.Spells[_]["d".._]:Value(),51*EMenu.Spells[_]["d".._]:Value(),255))
						end
					end
				else
					if EMenu.Spells[_]["d".._]:Value() == 1 then
						DrawCircle(i.p.endPos,i.spell.radius,0.75,EMenu.Draws.SQ:Value(),GoS.Red)	
					elseif EMenu.Spells[_]["d".._]:Value() == 2 then
						DrawCircle(i.p.endPos,i.spell.radius,1,EMenu.Draws.SQ:Value(),GoS.Red)
					elseif EMenu.Spells[_]["d".._]:Value() == 3 then
						DrawCircle(i.p.endPos,i.spell.radius,1.25,EMenu.Draws.SQ:Value(),GoS.Red)
					elseif EMenu.Spells[_]["d".._]:Value() == 4 then
						DrawCircle(i.p.endPos,i.spell.radius,1.5,EMenu.Draws.SQ:Value(),GoS.Red)
					elseif EMenu.Spells[_]["d".._]:Value() == 5 then
						DrawCircle(i.p.endPos,i.spell.radius,1.75,EMenu.Draws.SQ:Value(),GoS.Red)
					end
					if EMenu.Draws.DSEW:Value() then
						if EMenu.Spells[_]["d".._]:Value() == 1 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),1.5,EMenu.Draws.SQ:Value(),GoS.Red)	
						elseif EMenu.Spells[_]["d".._]:Value() == 2 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),2,EMenu.Draws.SQ:Value(),GoS.Red)
						elseif EMenu.Spells[_]["d".._]:Value() == 3 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),2.5,EMenu.Draws.SQ:Value(),GoS.Red)
						elseif EMenu.Spells[_]["d".._]:Value() == 4 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),3,EMenu.Draws.SQ:Value(),GoS.Red)
						elseif EMenu.Spells[_]["d".._]:Value() == 5 then
							DrawCircle(i.p.endPos,i.spell.radius+EMenu.Advanced.ew:Value(),3.5,EMenu.Draws.SQ:Value(),GoS.Red)						
						end
					end				
				end
			end
		end
	  end
	end
end

function SLEvade:Drawings2()
	for _,i in pairs(self.obj) do
		if EMenu.Draws.DevOpt:Value() then 
			if i.jp then 
				DrawCircle(i.jp,50,1,20,GoS.Red) 
			end 
		end
		if EMenu.Draws.DEPos:Value() and not EMenu.Keys.DDraws:Value() and i.safe then	
			if i.uDodge then 
				dArrow(myHero.pos,i.safe,3,GoS.Red)
			else		
				dArrow(myHero.pos,i.safe,3,GoS.Blue)
			end
		end
		if EMenu.Draws.DevOpt:Value() then
			DrawCircle(self:Position(),50,1,20,GoS.Blue)
		end
	end
end

function SLEvade:Dodge()
	for _,i in pairs(self.obj) do
	 local oT = i.spell.delay + GetDistance(myHero,i.p.startPos) / i.spell.speed
	  local fT = .75
				--DashP = Dash - Position, DashS = Dash - Self, DashT = Dash - Targeted, SpellShieldS = SpellShield - Self, SpellShieldT = SpellShield - Targeted, WindWallP = WindWall - Position, 
		if EMenu.Keys.DD:Value() then return end
			if i.safe then
				if self.asd == true then 
					DisableHoldPosition(true)
					BlockInput(true) 
				else 
					DisableHoldPosition(false)
					BlockInput(false) 
				end
				MoveToXYZ(i.safe)
				if EMenu.Spells[_]["Dashes".._]:Value() then
					for op = 0,3 do
						if self.EvadeSpells[GetObjectName(myHero)] and self.EvadeSpells[GetObjectName(myHero)][op] and EMenu.EvadeSpells[self.EvadeSpells[GetObjectName(myHero)][op].name]["Dodge"..self.EvadeSpells[GetObjectName(myHero)][op].name]:Value() and self.EvadeSpells[GetObjectName(myHero)][op].evadeType and self.EvadeSpells[GetObjectName(myHero)][op].spellKey and EMenu.Spells[_]["d".._]:Value() >= EMenu.EvadeSpells[self.EvadeSpells[GetObjectName(myHero)][op].name]["d"..self.EvadeSpells[GetObjectName(myHero)][op].name]:Value() then 
							if i.uDodge == true and self.usp == false and self.ut == false then
								if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "DashP" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
										self.ues = true
										CastSkillShot(self.EvadeSpells[GetObjectName(myHero)][op].spellKey, i.safe)
									else
										self.ues = false
								end	
								if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "DashT" then
									for pp,ally in pairs(GetAllyHeroes()) do
										if ally ~= nil then
											if GetDistance(myHero,ally) < self.EvadeSpells[GetObjectName(myHero)][op].range and not ally.dead and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then	
													self.ues = true
													DelayAction(function()								
														CastTargetSpell(ally, self.EvadeSpells[GetObjectName(myHero)][op].spellKey)
													end,oT*fT*.001)
												else
													self.ues = false
											end
										end
									end
									for _,minion in pairs(minionManager.objects) do
										if GetTeam(minion) == MINION_ALLY then 
											if GetDistance(myHero,minion) < self.EvadeSpells[GetObjectName(myHero)][op].range and not minion.dead and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
													self.ues = true													
													DelayAction(function()										
														CastTargetSpell(minion, self.EvadeSpells[GetObjectName(myHero)][op].spellKey)
													end,oT*fT*.001)
												else
													self.ues = false
											end
										end
										if GetTeam(minion) == MINION_JUNGLE then 
											if GetDistance(myHero,minion) < self.EvadeSpells[GetObjectName(myHero)][op].range and not minion.dead and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
													self.ues = true
													DelayAction(function()
														CastTargetSpell(minion, self.EvadeSpells[GetObjectName(myHero)].spellKey)
													end,oT*fT*.001)
												else
													self.ues = false
											end
										end
									end
								end
								if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "WindWallP" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
										self.ues = true
										DelayAction(function()
											CastSkillShot(self.EvadeSpells[GetObjectName(myHero)].spellKey, i.p.endPos)
										end,oT*fT*.001)
									else
										self.ues = false
								end		
								if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "SpellShieldS" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == 0 then
										self.ues = true
										DelayAction(function()
											CastSpell(self.EvadeSpells[GetObjectName(myHero)][op].spellKey)
										end,oT*fT*.001)
									else
										self.ues = false
								end
								-- if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "SpellShieldT" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == 0 then
											-- self.ues = true
										-- else
											-- self.ues = false
								-- end
								if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "DashS" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == 0 then
										self.ues = true
										CastSpell(self.EvadeSpells[GetObjectName(myHero)][op].spellKey)
									else
										self.ues = false
								end
							end
						end
					end
				if self.Flash and Ready(self.Flash) and i.uDodge == true and EMenu.EvadeSpells.Flash.DodgeFlash:Value() and EMenu.Spells[_]["d".._]:Value() >= EMenu.EvadeSpells.Flash.dFlash:Value() and self.ues == false and self.ut == false then
					self.usp = true
					CastSkillShot(self.Flash, i.safe)
				else
					self.usp = false
				end		
				for item,c in pairs(self.SI) do
					if c.State and Ready(GetItemSlot(myHero,item)) and EMenu.invulnerable[c.Name]["Dodge"..c.Name]:Value() and i.uDodge == true and GetPercentHP(myHero) <= EMenu.invulnerable[c.Name]["hp"..c.Name]:Value() and EMenu.Spells[_]["d".._]:Value() >= EMenu.invulnerable[c.Name]["d"..c.Name]:Value() and self.ues == false and self.usp == false then
						self.ut = true
						CastSpell(GetItemSlot(myHero,item))
					else
						self.ut = false
					end
				end
				for item,c in pairs(self.D) do
					if c.State and Ready(GetItemSlot(myHero,item)) and EMenu.EvadeSpells[c.Name]["Dodge"..c.Name]:Value() and i.uDodge == true and GetPercentHP(myHero) <= EMenu.EvadeSpells[c.Name]["hp"..c.Name]:Value() and EMenu.Spells[_]["d".._]:Value() >= EMenu.EvadeSpells[c.Name]["d"..c.Name]:Value() and self.ues == false and self.usp == false then
						self.ut = true
						CastSkillShot(GetItemSlot(myHero,item), i.safe)
					else
						self.ut = false
					end
				end
			end
		else
			DisableHoldPosition(false)
			BlockInput(false)
		end
	end
end

function SLEvade:CreateObject(obj)
	if obj and obj.isSpell and obj.spellOwner.isHero and obj.spellOwner.team == MINION_ENEMY then
		for _,i in pairs(self.obj) do
			if self.Spells[_].proj == obj.spellName then
				obj.spellName = _
			end
		end
		if obj.spellName:lower():find("attack") then return end
		if self.Spells[obj.spellName] and EMenu.Spells[obj.spellName] and EMenu.Spells[obj.spellName]["Dodge"..obj.spellName]:Value() and ((not self.DodgeOnlyDangerous and EMenu.d:Value() <= EMenu.Spells[obj.spellName]["d"..obj.spellName]:Value()) or (self.DodgeOnlyDangerous and EMenu.Spells[obj.spellName]["IsD"..obj.spellName]:Value())) then
			if not self.obj[obj.spellName] then self.obj[obj.spellName] = {} end
			self.obj[obj.spellName].o = obj
			self.obj[obj.spellName].caster = GetObjectSpellOwner(obj)
			self.obj[obj.spellName].mpos = nil
			self.obj[obj.spellName].uDodge = nil
			self.obj[obj.spellName].startTime = os.clock()
			self.obj[obj.spellName].spell = self.Spells[obj.spellName]
			self.obj[obj.spellName].ccoll = false
		end
	end
end

function SLEvade:Detection(unit,spellProc)
	if EMenu.Draws.DevOpt:Value() then 
		if unit == myHero then print(spellProc.name) end
	end
	if unit and unit.isHero and unit.team == MINION_ENEMY then
		for _,i in pairs(self.obj) do
			if self.Spells[_].proj == spellProc.name then
				spellProc.name = _
			end
		end
		if self.Spells[spellProc.name] and ((not self.DodgeOnlyDangerous and EMenu.d:Value() <= EMenu.Spells[spellProc.name]["d"..spellProc.name]:Value()) or (self.DodgeOnlyDangerous and EMenu.Spells[spellProc.name]["IsD"..spellProc.name]:Value())) then
			if not self.obj[spellProc.name] then self.obj[spellProc.name] = {} end
			self.obj[spellProc.name].p = spellProc
			self.obj[spellProc.name].spell = self.Spells[spellProc.name]
			self.obj[spellProc.name].caster = unit
			self.obj[spellProc.name].mpos = nil
			self.obj[spellProc.name].uDodge = nil
			self.obj[spellProc.name].startTime = os.clock()
			self.obj[spellProc.name].ccoll = false
			if self.Spells[spellProc.name].killTime then
				DelayAction(function() self.obj[spellProc.name] = nil end, self.Spells[spellProc.name].killTime + GetDistance(unit,spellProc.endPos)/self.Spells[spellProc.name].speed + self.Spells[spellProc.name].delay)
			end
		end
	end
end

function SLEvade:DeleteObject(obj)
	DelayAction(function()
		if obj and obj.isSpell and self.obj[obj.spellName] then
			self.obj[obj.spellName] = nil
		end	
	end, .001)	
end


class 'SLEAutoUpdater'


function SLEAutoUpdater:__init()
	function SLEUpdater(data)
	  if not SLEAutoUpdate then return end
		if tonumber(data) > tonumber(SLEvadeVer) then
			PrintChat("<font color=\"#fd8b12\"><b>[SL-Evade] - <font color=\"#F2EE00\">New Version found ! "..data.."</b></font>")
			PrintChat("<font color=\"#fd8b12\"><b>[SL-Evade] - <font color=\"#F2EE00\">Downloading Update... Please wait</b></font>")
			DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Evade.lua", SCRIPT_PATH .. "SL-Evade.lua", function() PrintChat("<font color=\"#fd8b12\"><b>[SL-Evade] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return	end)
		else
			PrintChat("<font color=\"#fd8b12\"><b>[SL-Evade] - <font color=\"#F2EE00\">No Updates Found.</b></font>")
		end
	end
  GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Evade.version", SLEUpdater)
end
