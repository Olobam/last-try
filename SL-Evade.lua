local SLEAutoUpdate = true
local Stage, SLEvadeVer = "BETA", "0.19"
local SLEPatchnew = nil
if GetGameVersion():sub(3,4) >= "10" then
		SLEPatchnew = GetGameVersion():sub(1,4)
	else
		SLEPatchnew = GetGameVersion():sub(1,3)
end

local function dRectangleOutline(s, e, w, t, c, v)--start,end,width,thickness,color
	local z1 = s+Vector(Vector(e)-s):perpendicular():normalized()*w/2
	local z2 = s+Vector(Vector(e)-s):perpendicular2():normalized()*w/2
	local z3 = e+Vector(Vector(s)-e):perpendicular():normalized()*w/2
	local z4 = e+Vector(Vector(s)-e):perpendicular2():normalized()*w/2
	local z5 = s+Vector(Vector(e)-s):perpendicular():normalized()*w
	local z6 = s+Vector(Vector(e)-s):perpendicular2():normalized()*w
	local c1 = WorldToScreen(0,z1)
	local c2 = WorldToScreen(0,z2)
	local c3 = WorldToScreen(0,z3)
	local c4 = WorldToScreen(0,z4)
	local c5 = WorldToScreen(0,z5)
	local c6 = WorldToScreen(0,z6)
	if v then
		DrawLine(c5.x,c5.y,c6.x,c6.y,t,ARGB(255,15,250,42))
	else
		DrawLine(c5.x,c5.y,c6.x,c6.y,t,ARGB(255,255,0,0))
	end
	DrawLine(c2.x,c2.y,c3.x,c3.y,t,c)
	DrawLine(c3.x,c3.y,c4.x,c4.y,t,c)
	DrawLine(c1.x,c1.y,c4.x,c4.y,t,c)
end

local function dRectangleOutline2(s, e, w, t, c, v)--start,end,radius,thickness,color
	local z1 = s+Vector(Vector(e)-s):perpendicular():normalized()*w
	local z2 = s+Vector(Vector(e)-s):perpendicular2():normalized()*w
	local z3 = e+Vector(Vector(s)-e):perpendicular():normalized()*w
	local z4 = e+Vector(Vector(s)-e):perpendicular2():normalized()*w
	local c1 = WorldToScreen(0,z1)
	local c2 = WorldToScreen(0,z2)
	local c3 = WorldToScreen(0,z3)
	local c4 = WorldToScreen(0,z4)
	if v then
		DrawLine(c1.x,c1.y,c2.x,c2.y,t,ARGB(255,15,250,42))
	else
		DrawLine(c1.x,c1.y,c2.x,c2.y,t,ARGB(255,255,0,0))
	end
	DrawLine(c2.x,c2.y,c3.x,c3.y,t,c)
	DrawLine(c3.x,c3.y,c4.x,c4.y,t,c)
	DrawLine(c1.x,c1.y,c4.x,c4.y,t,c)
end


local function DrawRectangle(s,e,r,r2,t,c)
    local spos = Vector(e) - (Vector(e) - Vector(s)):normalized():perpendicular() * (r2 or 400)
    local epos = Vector(e) + (Vector(e) - Vector(s)):normalized():perpendicular() * (r2 or 400)
	local ePos = Vector(epos)
	local sPos = Vector(spos)
	local dVec = Vector(ePos - sPos)
	local sVec = dVec:normalized():perpendicular()*((r)*.5)
	local TopD1 = WorldToScreen(0,sPos-sVec)
	local TopD2 = WorldToScreen(0,sPos+sVec)
	local BotD1 = WorldToScreen(0,ePos-sVec)
	local BotD2 = WorldToScreen(0,ePos+sVec)
	DrawLine(TopD1.x,TopD1.y,TopD2.x,TopD2.y,t,c)
	DrawLine(TopD1.x,TopD1.y,BotD1.x,BotD1.y,t,c)
	DrawLine(TopD2.x,TopD2.y,BotD2.x,BotD2.y,t,c)
	DrawLine(BotD1.x,BotD1.y,BotD2.x,BotD2.y,t,c)
end

local function DrawCone(v1,v2,angle,width,color)
    angle = angle * math.pi / 180
    v1 = Vector(v1)
    v2 = Vector(v2)
    
    local a1 = Vector(Vector(v2)-Vector(v1)):rotated(0,-angle*.5,0)
    local a2 = nil
    DrawLine3D(v1.x,v1.y,v1.z,v1.x+a1.x,v1.y+a1.y,v1.z+a1.z,width,color)
    for i = -angle*.5,angle*.5,angle*.1 do
        a2 = Vector(v2-v1):rotated(0,i,0)
        DrawLine3D(v1.x+a2.x,v1.y+a2.y,v1.z+a2.z,v1.x+a1.x,v1.y+a1.y,v1.z+a1.z,width,color)
        a1 = a2
    end    
    DrawLine3D(v1.x,v1.y,v1.z,v1.x+a1.x,v1.y+a1.y,v1.z+a1.z,width,color)
end

local ta = {_G.HoldPosition, _G.AttackUnit}
local function DisableHoldPosition(boolean)
	if boolean then
		_G.HoldPosition, _G.AttackUnit = function() end, function() end
	else
		_G.HoldPosition, _G.AttackUnit = ta[1], ta[2]
	end
end

local function DisableAll(b)
	if b then
		if _G.IOW then
			IOW.movementEnabled = false
			IOW.attacksEnabled = false
		elseif _G.PW then
			PW.movementEnabled = false
			PW.attacksEnabled = false
		elseif _G.GoSWalkLoaded then
			_G.GoSWalk:EnableMovement(false)
			_G.GoSWalk:EnableAttack(false)
		elseif _G.DAC_Loaded then
			DAC:MovementEnabled(false)
			DAC:AttacksEnabled(false)
		elseif _G.AutoCarry_Loaded then
			DACR.movementEnabled = false
			DACR.attacksEnabled = false
		elseif _G.SLW then
			SLW.movementEnabled = false
			SLW.attacksEnabled = false
		end
		BlockF7OrbWalk(true)
		BlockF7Dodge(true)
		BlockInput(true)
	else
		if _G.IOW then
			IOW.movementEnabled = true
			IOW.attacksEnabled = true
		elseif _G.PW then
			PW.movementEnabled = true
			PW.attacksEnabled = true
		elseif _G.GoSWalkLoaded then
			_G.GoSWalk:EnableMovement(true)
			_G.GoSWalk:EnableAttack(true)
		elseif _G.DAC_Loaded then
			DAC:MovementEnabled(true)
			DAC:AttacksEnabled(true)
		elseif _G.AutoCarry_Loaded then
			DACR.movementEnabled = true
			DACR.attacksEnabled = true
		elseif _G.SLW then
			SLW.movementEnabled = true
			SLW.attacksEnabled = true
		end
		BlockF7OrbWalk(false)
		BlockF7Dodge(false)
		BlockInput(false)
	end
end

local function dArrow(s, e, w, c)--startpos,endpos,width,color
	local s2 = e-((s-e):normalized()*75):perpendicular()+(s-e):normalized()*75
	local s3 = e-((s-e):normalized()*75):perpendicular2()+(s-e):normalized()*75
	DrawLine3D(s.x,s.y,s.z,e.x,e.y,e.z,w,c)
	DrawLine3D(s2.x,s2.y,s2.z,e.x,e.y,e.z,w,c)
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

	self.supportedtypes = {["Line"]={supported=true},["Circle"]={supported=true},["Cone"]={supported=true},["Rectangle"]={supported=true},["Arc"]={supported=false},["Ring"]={supported=true},["Threeway"]={supported=false},["follow"]={supported=true},["Return"]={supported=true}}
	self.globalults = {["EzrealTrueshotBarrage"]={s=true},["EnchantedCrystalArrow"]={s=true},["DravenRCast"]={s=true},["JinxR"]={s=true}}
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
	self.ues = false -- self.usingevadespells
	self.ut = false -- self.usingitems
	self.usp = false -- self.usingsummonerspells
	self.mposs2 = nil -- self.mousepos line
	self.opos = nil -- simulated obj pos
	self.cpos = nil --c pos
	self.endposs = nil -- endpos
	self.mV = nil -- wp
	self.YasuoWall = {} --yasuowall
	self.pathc = nil-- rectangle wall check
	self.pathc2 = nil-- rectangle wall check2
	self.mposs3 = nil --mpos rect
	self.mposs4 = nil --mpos cone
	self.pathd = nil --cone wall check
	self.pathd2 = nil --cone wall check2
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
	EMenu:Slider("d","Danger",2,1,5,1)
	EMenu:SubMenu("Spells", "Spell Settings")
	EMenu:SubMenu("EvadeSpells", "EvadeSpell Settings")
	EMenu:SubMenu("invulnerable", "Invulnerable Settings")
	EMenu:SubMenu("Draws", "Drawing Settings")
	EMenu:SubMenu("Advanced", "Advanced Settings")
	EMenu.Advanced:Boolean("LDR", "Limit detection range", true)
	EMenu.Advanced:Boolean("EMC", "Enable Minion Collision", true)
	EMenu.Advanced:Boolean("EHC", "Enable Hero Collision", true)
	EMenu.Advanced:Boolean("EWC", "Enable Wall Collision", true)
	EMenu.Draws:Boolean("DSPath", "Draw SkillShot Path", true)
	EMenu.Draws:Boolean("DSEW", "Draw SkillShot Extra Width", true)
	EMenu.Draws:Boolean("DEPos", "Draw Evade Position", false)
	EMenu.Draws:Boolean("DES", "Draw Evade Status", true)
	EMenu.Draws:Menu("SD", "Spell Drawing")
	EMenu.Draws.SD:ColorPick("c", " Spell Color", {255,255,255,255})
	EMenu.Draws.SD:Slider("t", "Line width", 0.5, 0, 5, 0.5)
	EMenu.Draws:Boolean("DevOpt", "Draw for Devs", false)
	EMenu:SubMenu("Keys", "Key Settings")
	EMenu.Keys:KeyBinding("DD", "Disable Dodging", string.byte("K"), true)
	EMenu.Keys:KeyBinding("DDraws", "Disable Drawings", string.byte("J"), true)
	EMenu.Keys:KeyBinding("DoD", "Dodge only Dangerous", string.byte(" "))
	EMenu.Keys:KeyBinding("DoD2", "Dodge only Dangerous 2", string.byte("V"))
	EMenu:Boolean("D","DEBUG",false)
	
	DelayAction(function()
		for _,i in pairs(self.Spells) do
			for l,k in pairs(GetEnemyHeroes()) do
			-- k = myHero
				if not self.Spells[_] then return end
				if i.charName == k.charName and self.supportedtypes[i.type].supported then
					if i.displayname == "" then i.displayname = _ end
					if i.danger == 0 then i.danger = 1 end
					if not EMenu.Spells[_] then EMenu.Spells:Menu(_,""..i.charName.." | "..(self.str[i.slot] or "?").." - "..i.displayname) end
						EMenu.Spells[_]:Boolean("Dodge".._, "Enable Dodge", true)
						EMenu.Spells[_]:Boolean("Draw".._, "Enable Draw", true)
						EMenu.Spells[_]:Boolean("Dashes".._, "Enable Evade Spells", true)
						EMenu.Spells[_]:Info("Empty12".._, "")			
						EMenu.Spells[_]:Slider("radius".._,"Radius",(i.radius or 150), ((i.radius-50) or 50),((i.radius+100) or 250), 5)
						if i.dangerous then EMenu.Spells[_]:Slider("hp".._, "HP to Dodge", 100, 1, 100, 5)
						else EMenu.Spells[_]:Slider("hp".._, "HP to Dodge", 85, 1, 100, 5)
						end
						EMenu.Spells[_]:Slider("d".._,"Danger",(i.danger or 1), 1, 5, 1)
						EMenu.Spells[_]:Info("Empty123".._, "")
						EMenu.Spells[_]:Boolean("IsD".._,"Dangerous", i.dangerous or false)
						EMenu.Spells[_]:Boolean("ffe".._,"Fast Evade", i.ffe or false)
						EMenu.Spells[_]:Boolean("H".._, "Humanizer", not i.dangerous)
						if i.mcollision then
							EMenu.Spells[_]:Boolean("Coll".._, "Collision", true)
						else
							EMenu.Spells[_]:Info("nohColl".._, "No Collision available")
						end	
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
	Callback.Add("WndMsg", function(s1,s2) self:WndMsg(s1,s2) end)
	Callback.Add("IssueOrder", function(order) self:BlockMov(order) end)

self.Spells = {
	["AatroxQ"]={charName="Aatrox",slot=0,type="Circle",delay=0.6,range=650,radius=250,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0.225,displayname="Dark Flight",mcollision=false},
	["AatroxE"]={charName="Aatrox",slot=2,type="Line",delay=0.25,range=1075,radius=35,speed=1250,addHitbox=true,danger=3,dangerous=false,proj="AatroxEConeMissile",killTime=0,displayname="Blade of Torment",mcollision=false},
	["AhriOrbofDeception"]={charName="Ahri",slot=0,type="Line",delay=0.25,range=1000,radius=100,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="AhriOrbMissile",killTime=0,displayname="Orb of Deception",mcollision=false},
	["AhriOrbReturn"]={charName="Ahri",slot=0,type="Return",delay=0,range=1000,radius=100,speed=915,addHitbox=true,danger=2,dangerous=false,proj="AhriOrbReturn",killTime=0,displayname="Orb of Deception2",mcollision=false},
	["AhriSeduce"]={charName="Ahri",slot=2,type="Line",delay=0.25,range=1000,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="AhriSeduceMissile",killTime=0,displayname="Charm",mcollision=true},
	["Pulverize"]={charName="Alistar",slot=0,type="Circle",delay=0.25,range=1000,radius=200,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="nil",killTime=0.25,displayname="Pulverize",mcollision=false},
	["BandageToss"]={charName="Amumu",slot=0,type="Line",delay=0.25,range=1000,radius=90,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="SadMummyBandageToss",killTime=0,displayname="Bandage Toss",mcollision=true},
	["CurseoftheSadMummy"]={charName="Amumu",slot=3,type="Circle",delay=0.25,range=0,radius=550,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=1.25,displayname="Curse of the Sad Mummy",mcollision=false},
	["FlashFrost"]={charName="Anivia",slot=0,type="Line",delay=0.25,range=1200,radius=110,speed=850,addHitbox=true,danger=3,dangerous=true,proj="FlashFrostSpell",killTime=0,displayname="Flash Frost",mcollision=false},
	["Incinerate"]={charName="Annie",slot=1,type="Cone",delay=0.25,range=825,radius=80,speed=math.huge,angle=50,addHitbox=false,danger=2,dangerous=false,proj="nil",killTime=0,displayname="",mcollision=false},
	["InfernalGuardian"]={charName="Annie",slot=3,type="Circle",delay=0.25,range=600,radius=251,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="nil",killTime=0.3,displayname="",mcollision=false},
	-- ["Volley"]={charName="Ashe",slot=1,type="Line",delay=0.25,range=1200,radius=60,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="VolleyAttack",killTime=0,displayname="",mcollision=false},
	["EnchantedCrystalArrow"]={charName="Ashe",slot=3,type="Line",delay=0.2,range=20000,radius=130,speed=1600,addHitbox=true,danger=5,dangerous=true,proj="EnchantedCrystalArrow",killTime=0,displayname="Enchanted Arrow",mcollision=false},
	["AurelionSolQ"]={charName="AurelionSol",slot=0,type="Line",delay=0.25,range=1500,radius=180,speed=850,addHitbox=true,danger=2,dangerous=false,proj="AurelionSolQMissile",killTime=0,displayname="AurelionSolQ",mcollision=false},
	["AurelionSolR"]={charName="AurelionSol",slot=3,type="Line",delay=0.3,range=1420,radius=120,speed=4500,addHitbox=true,danger=3,dangerous=true,proj="AurelionSolRBeamMissile",killTime=0,displayname="AurelionSolR",mcollision=false},
	["BardQ"]={charName="Bard",slot=0,type="Line",delay=0.25,range=850,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="BardQMissile",killTime=0,displayname="BardQ",mcollision=true},
	["BardR"]={charName="Bard",slot=3,type="Circle",delay=0.5,range=3400,radius=350,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="BardR",killTime=1,displayname="BardR",mcollision=false},
	["RocketGrab"]={charName="Blitzcrank",slot=0,type="Line",delay=0.2,range=1050,radius=70,speed=1800,addHitbox=true,danger=4,dangerous=true,proj="RocketGrabMissile",killTime=0,displayname="Rocket Grab",mcollision=true},
	["StaticField"]={charName="Blitzcrank",slot=3,type="Circle",delay=0.25,range=0,radius=600,speed=math.huge,addHitbox=false,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Static Field",mcollision=false},
	["BrandQ"]={charName="Brand",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="BrandQMissile",killTime=0,displayname="Sear",mcollision=true},
	["BrandW"]={charName="Brand",slot=1,type="Circle",delay=0.85,range=900,radius=240,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.275,displayname="Pillar of Flame"}, -- doesnt work
	["BraumQ"]={charName="Braum",slot=0,type="Line",delay=0.25,range=1000,radius=60,speed=1700,addHitbox=true,danger=3,dangerous=true,proj="BraumQMissile",killTime=0,displayname="Winter's Bite",mcollision=true},
	["BraumRWrapper"]={charName="Braum",slot=3,type="Line",delay=0.5,range=1250,radius=115,speed=1400,addHitbox=true,danger=4,dangerous=true,proj="braumrmissile",killTime=0,displayname="Glacial Fissure",mcollision=false},
	["CaitlynPiltoverPeacemaker"]={charName="Caitlyn",slot=0,type="Line",delay=0.6,range=1300,radius=90,speed=1800,addHitbox=true,danger=2,dangerous=false,proj="CaitlynPiltoverPeacemaker",killTime=0,displayname="Piltover Peacemaker",mcollision=false},
	["CaitlynEntrapment"]={charName="Caitlyn",slot=2,type="Line",delay=0.4,range=1000,radius=70,speed=1600,addHitbox=true,danger=1,dangerous=false,proj="CaitlynEntrapmentMissile",killTime=0,displayname="90 Caliber Net",mcollision=true},
	["CassiopeiaQ"]={charName="Cassiopeia",slot=0,type="Circle",delay=0.75,range=850,radius=150,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="CassiopeiaNoxiousBlast",killTime=0.2,displayname="Noxious Blast",mcollision=false},
	["CassiopeiaR"]={charName="Cassiopeia",slot=3,type="Cone",delay=0.6,range=825,radius=80,speed=math.huge,angle=80,addHitbox=false,danger=5,dangerous=true,proj="CassiopeiaPetrifyingGaze",killTime=0,displayname="Petrifying Gaze",mcollision=false},
	["Rupture"]={charName="Chogath",slot=0,type="Circle",delay=1.2,range=950,radius=250,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="Rupture",killTime=0.8,displayname="Rupture",mcollision=false},
	["PhosphorusBomb"]={charName="Corki",slot=0,type="Circle",delay=0.3,range=825,radius=250,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="PhosphorusBombMissile",killTime=0.35,displayname="Phosphorus Bomb",mcollision=false},
	["CarpetBombMega"]={charName="Corki",slot=2,type="Line",delay=0.2,range=1900,radius=140,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="CarpetBombMega",killTime=0,displayname="Special Delivery",mcollision=false},
	["MissileBarrage"]={charName="Corki",slot=3,type="Line",delay=0.2,range=1300,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="MissileBarrageMissile",killTime=0,displayname="Missile Barrage",mcollision=true},
	["MissileBarrage2"]={charName="Corki",slot=3,type="Line",delay=0.2,range=1500,radius=40,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="MissileBarrageMissile2",killTime=0,displayname="Missile Barrage big",mcollision=true},
	["DariusCleave"]={charName="Darius",slot=0,type="Circle",delay=0.75,range=0,radius=425 - 50,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="DariusCleave",killTime=0,displayname="Cleave",mcollision=false},
	["DariusAxeGrabCone"]={charName="Darius",slot=2,type="Cone",delay=0.25,range=550,radius=80,speed=math.huge,angle=30,addHitbox=false,danger=3,dangerous=true,proj="DariusAxeGrabCone",killTime=0,displayname="Apprehend",mcollision=false},
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
	["EzrealMysticShot"]={charName="Ezreal",slot=0,type="Line",delay=0.25,range=1300,radius=50,speed=1975,addHitbox=true,danger=2,dangerous=false,proj="EzrealMysticShotMissile",killTime=0,displayname="Mystic Shot",mcollision=true},
	["EzrealEssenceFlux"]={charName="Ezreal",slot=1,type="Line",delay=0.25,range=1000,radius=80,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="EzrealEssenceFluxMissile",killTime=0,displayname="Essence Flux",mcollision=false},
	["EzrealTrueshotBarrage"]={charName="Ezreal",slot=3,type="Line",delay=1,range=20000,radius=150,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="EzrealTrueshotBarrage",killTime=0,displayname="Trueshot Barrage",mcollision=false},
	["FioraW"]={charName="Fiora",slot=1,type="Line",delay=0.5,range=800,radius=70,speed=3200,addHitbox=true,danger=2,dangerous=false,proj="FioraWMissile",killTime=0,displayname="Riposte",mcollision=false},
	["FizzMarinerDoom"]={charName="Fizz",slot=3,type="Line",delay=0.25,range=1150,radius=120,speed=1350,addHitbox=true,danger=5,dangerous=true,proj="FizzMarinerDoomMissile",killTime=0,displayname="Chum the Waters",mcollision=false},
	["FizzMarinerDoomMissile"]={charName="Fizz",slot=3,type="Circle",delay=0.25,range=800,radius=300,speed=1350,addHitbox=true,danger=5,dangerous=true,proj="FizzMarinerDoomMissile",killTime=0,displayname="Chum the Waters End",mcollision=false},
	["GalioResoluteSmite"]={charName="Galio",slot=0,type="Circle",delay=0.25,range=900,radius=200,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="GalioResoluteSmite",killTime=0.2,displayname="Resolute Smite",mcollision=false},
	["GalioRighteousGust"]={charName="Galio",slot=2,type="Line",delay=0.25,range=1100,radius=120,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="GalioRighteousGust",killTime=0,displayname="Righteous Ghost",mcollision=false},
	["GalioIdolOfDurand"]={charName="Galio",slot=3,type="Circle",delay=0.25,range=0,radius=550,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=1,displayname="Idol of Durand",mcollision=false},
	["GnarQ"]={charName="Gnar",slot=0,type="Line",delay=0.25,range=1200,radius=60,speed=1225,addHitbox=true,danger=2,dangerous=false,proj="gnarqmissile",killTime=0,displayname="Boomerang Throw",mcollision=false},
	["GnarQReturn"]={charName="Gnar",slot=0,type="Line",delay=0,range=1200,radius=75,speed=1225,addHitbox=true,danger=2,dangerous=false,proj="GnarQMissileReturn",killTime=0,displayname="Boomerang Throw2",mcollision=false},
	["GnarBigQ"]={charName="Gnar",slot=0,type="Line",delay=0.5,range=1150,radius=90,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="GnarBigQMissile",killTime=0,displayname="Boulder Toss",mcollision=true},
	["GnarBigW"]={charName="Gnar",slot=1,type="Line",delay=0.6,range=600,radius=80,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="GnarBigW",killTime=0,displayname="Wallop",mcollision=false},
	["GnarE"]={charName="Gnar",slot=2,type="Circle",delay=0,range=473,radius=150,speed=903,addHitbox=true,danger=2,dangerous=false,proj="GnarE",killTime=0.2,displayname="GnarE",mcollision=false},
	["GnarBigE"]={charName="Gnar",slot=2,type="Circle",delay=0.25,range=475,radius=200,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="GnarBigE",killTime=0.2,displayname="GnarBigE",mcollision=false},
	["GnarR"]={charName="Gnar",slot=3,type="Circle",delay=0.25,range=0,radius=500,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=0.3,displayname="GnarUlt",mcollision=false},
	["GragasQ"]={charName="Gragas",slot=0,type="Circle",delay=0.25,range=1100,radius=275,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="GragasQMissile",killTime=4.25,displayname="Barrel Roll",mcollision=false,killName="GragasQToggle"},
	["GragasE"]={charName="Gragas",slot=2,type="Line",delay=0,range=800,radius=200,speed=800,addHitbox=true,danger=2,dangerous=false,proj="GragasE",killTime=0.5,displayname="Body Slam",mcollision=true},
	["GragasR"]={charName="Gragas",slot=3,type="Circle",delay=0.25,range=1050,radius=375,speed=1800,addHitbox=true,danger=5,dangerous=true,proj="GragasRBoom",killTime=0.3,displayname="Explosive Cask",mcollision=false},
	["GravesQLineMis"]={charName="Graves",slot=0,type="Rectangle",delay=0.2,range=750,radius=140,radius2=300,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="GravesQLineMis",killTime=1,displayname="Buckshot Rectangle",mcollision=false},
	["GravesClusterShotSoundMissile"]={charName="Graves",slot=0,type="Line",delay=0.2,range=750,radius=60,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0,displayname="Buckshot",mcollision=false},
	["GravesQReturn"]={charName="Graves",slot=0,type="Line",delay=0,range=750,radius=60,speed=1150,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0,displayname="Buckshot return",mcollision=false},
	["GravesSmokeGrenade"]={charName="Graves",slot=1,type="Circle",delay=0.25,range=925,radius=275,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="GravesSmokeGrenadeBoom",killTime=4.5,displayname="SmokeScreen",mcollision=false},
	["GravesChargeShot"]={charName="Graves",slot=3,type="Line",delay=0.2,range=1000,radius=100,speed=2100,addHitbox=true,danger=5,dangerous=true,proj="GravesChargeShotShot",killTime=0,displayname="CollateralDmg",mcollision=false},
	["GravesChargeShotFxMissile2"]={charName="Graves",slot=3,type="Cone",delay=0,range=1000,radius=100,speed=2100,angle=60,addHitbox=true,danger=5,dangerous=true,proj="nil",killTime=0,displayname="CollateralDmg end",mcollision=false},
	["HecarimUlt"]={charName="Hecarim",slot=3,type="Line",delay=0.2,range=1100,radius=300,speed=1200,addHitbox=true,danger=5,dangerous=true,proj="HecarimUltMissile",killTime=0.55,displayname="HecarimR",mcollision=false},
	["HeimerdingerTurretEnergyBlast"]={charName="Heimerdinger",slot=0,type="Line",delay=0.4,range=1000,radius=70,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="HeimerdingerTurretEnergyBlast",killTime=0,displayname="Turret",mcollision=false},
	["HeimerdingerW"]={charName="Heimerdinger",slot=1,type="Cone",delay=0.25,range=800,radius=70,speed=1800,angle=10,addHitbox=true,danger=2,dangerous=false,proj="HeimerdingerWAttack2",killTime=0,displayname="HeimerUltW",mcollision=true},
	["HeimerdingerE"]={charName="Heimerdinger",slot=2,type="Circle",delay=0.25,range=925,radius=100,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="heimerdingerespell",killTime=0.3,displayname="HeimerdingerE",mcollision=false},
	["IllaoiQ"]={charName="Illaoi",slot=0,type="Line",delay=0.75,range=750,radius=160,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="illaoiemis",killTime=0,displayname="",mcollision=false},
	["IllaoiE"]={charName="Illaoi",slot=2,type="Line",delay=0.25,range=1100,radius=50,speed=1900,addHitbox=true,danger=3,dangerous=true,proj="illaoiemis",killTime=0,displayname="",mcollision=true},
	["IllaoiR"]={charName="Illaoi",slot=3,type="Circle",delay=0.5,range=0,radius=450,speed=math.huge,addHitbox=false,danger=3,dangerous=true,proj="nil",killTime=0.2,displayname="",mcollision=false},
	["IreliaTranscendentBlades"]={charName="Irelia",slot=3,type="Line",delay=0,range=1200,radius=65,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="IreliaTranscendentBlades",killTime=0,displayname="Transcendent Blades",mcollision=false},
	["HowlingGaleSpell"]={charName="Janna",slot=0,type="Line",delay=0.25,range=1700,radius=120,speed=800,addHitbox=true,danger=2,dangerous=false,proj="HowlingGaleSpell",killTime=0,displayname="HowlingGale",mcollision=false},
	["JarvanIVDragonStrike"]={charName="JarvanIV",slot=0,type="Line",delay=0.6,range=770,radius=70,speed=math.huge,addHitbox=true,danger=3,dangerous=false,proj="nil",killTime=0,displayname="DragonStrike",mcollision=false},
	["JarvanIVEQ"]={charName="JarvanIV",slot=0,type="Line",delay=0.25,range=880,radius=70,speed=1450,addHitbox=true,danger=3,dangerous=true,proj="nil",killTime=0,displayname="DragonStrike2",mcollision=false},
	["JarvanIVDemacianStandard"]={charName="JarvanIV",slot=2,type="Circle",delay=0.5,range=860,radius=175,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="JarvanIVDemacianStandard",killTime=1.5,displayname="Demacian Standard",mcollision=false},
	["JayceShockBlast"]={charName="Jayce",slot=0,type="Line",delay=0.25,range=1300,radius=70,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="JayceShockBlastMis",killTime=0,displayname="ShockBlast",mcollision=true},
	["JayceShockBlastWallMis"]={charName="Jayce",slot=0,type="Line",delay=0.25,range=1300,radius=70,speed=2350,addHitbox=true,danger=2,dangerous=false,proj="JayceShockBlastWallMis",killTime=0,displayname="ShockBlastCharged",mcollision=true},
	["JhinW"]={charName="Jhin",slot=1,type="Line",delay=0.75,range=2550,radius=40,speed=5000,addHitbox=true,danger=3,dangerous=true,proj="JhinWMissile",killTime=0,displayname="",mcollision=false},
	["JhinRShot"]={charName="Jhin",slot=3,type="Line",delay=0.25,range=3500,radius=80,speed=5000,addHitbox=true,danger=3,dangerous=true,proj="JhinRShotMis",killTime=0,displayname="JhinR",mcollision=false},
	["JinxW"]={charName="Jinx",slot=1,type="Line",delay=0.4,range=1600,radius=60,speed=2500,addHitbox=true,danger=3,dangerous=true,proj="JinxWMissile",killTime=0,displayname="Zap",mcollision=true},
	["JinxR"]={charName="Jinx",slot=3,type="Line",delay=0.6,range=20000,radius=140,speed=1700,addHitbox=true,danger=5,dangerous=true,proj="JinxR",killTime=0,displayname="Death Rocket",mcollision=false},
	["KalistaMysticShot"]={charName="Kalista",slot=0,type="Line",delay=0.25,range=1200,radius=40,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="kalistamysticshotmis",killTime=0,displayname="MysticShot",mcollision=true},
	["KarmaQ"]={charName="Karma",slot=0,type="Line",delay=0.25,range=1050,radius=60,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KarmaQMissile",killTime=0,displayname="",mcollision=true},
	["KarmaQMantra"]={charName="Karma",slot=0,type="Line",delay=0.25,range=950,radius=80,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="KarmaQMissileMantra",killTime=0,displayname="",mcollision=true},
	["KarthusLayWasteA1"]={charName="Karthus",slot=0,type="Circle",delay=0.625,range=875,radius=200,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Lay Waste 1",mcollision=false},
	["KarthusLayWasteA2"]={charName="Karthus",slot=0,type="Circle",delay=0.625,range=875,radius=200,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Lay Waste 2",mcollision=false},
	["KarthusLayWasteA3"]={charName="Karthus",slot=0,type="Circle",delay=0.625,range=875,radius=200,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.2,displayname="Lay Waste 3",mcollision=false},
	["KarthusWallOfPain"]={charName="Karthus",slot=2,type="Rectangle",delay=0.25,range=600,radius=160,radius2=500,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=5,displayname="Wall of Pain",mcollision=false},
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
	["BlindMonkQOne"]={charName="LeeSin",slot=0,type="Line",delay=0.25,range=1000,radius=80,speed=1800,addHitbox=true,danger=3,dangerous=true,proj="BlindMonkQOne",killTime=0,displayname="Sonic Wave",mcollision=true},
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
	["LuxLightBinding"]={charName="Lux",slot=0,type="Line",delay=0.3,range=1300,radius=70,speed=1200,addHitbox=true,danger=3,dangerous=true,proj="LuxLightBindingMis",killTime=0,displayname="Light Binding",mcollision=true},
	["LuxLightStrikeKugel"]={charName="Lux",slot=2,type="Circle",delay=0.25,range=1100,radius=350,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="LuxLightStrikeKugel",killTime=5.25,displayname="LightStrikeKugel",mcollision=false,killName="LuxLightstrikeToggle"},
	["LuxMaliceCannon"]={charName="Lux",slot=3,type="Line",delay=1,range=3500,radius=190,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="LuxMaliceCannon",killTime=0,displayname="Malice Cannon",mcollision=false},
	["UFSlash"]={charName="Malphite",slot=3,type="Circle",delay=0,range=1000,radius=270,speed=1500,addHitbox=true,danger=5,dangerous=true,proj="UFSlash",killTime=0.4,displayname="",mcollision=false},
	["MalzaharQ"]={charName="Malzahar",slot=0,type="Rectangle",delay=0.75,range=900,radius2=475,radius=130,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="MalzaharQMissile",killTime=0.5,displayname="",mcollision=false},
	["DarkBindingMissile"]={charName="Morgana",slot=0,type="Line",delay=0.2,range=1300,radius=80,speed=1200,addHitbox=true,danger=3,dangerous=true,proj="DarkBindingMissile",killTime=0,displayname="Dark Binding",mcollision=true},
	["NamiQ"]={charName="Nami",slot=0,type="Circle",delay=0.95,range=1625,radius=200,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="NamiQMissile",killTime=0.35,displayname="",mcollision=false},
	["NamiR"]={charName="Nami",slot=3,type="Line",delay=1,range=2750,radius=260,speed=850,addHitbox=true,danger=2,dangerous=false,proj="NamiRMissile",killTime=0,displayname="",mcollision=false},
	["NautilusAnchorDrag"]={charName="Nautilus",slot=0,type="Line",delay=0.25,range=1080,radius=90,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="NautilusAnchorDragMissile",killTime=0,displayname="Anchor Drag",mcollision=true},
	["AbsoluteZero"]={charName="Nunu",slot=3,type="Circle",delay=0.25,range=0,radius=750,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=4,displayname="",mcollision=false},
	["NocturneDuskbringer"]={charName="Nocturne",slot=0,type="Line",delay=0.25,range=1125,radius=60,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="NocturneDuskbringer",killTime=0,displayname="Duskbringer",mcollision=false},
	["JavelinToss"]={charName="Nidalee",slot=0,type="Line",delay=0.25,range=1500,radius=40,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="JavelinToss",killTime=0,displayname="JavelinToss",mcollision=true},
	["OlafAxeThrowCast"]={charName="Olaf",slot=0,type="Line",delay=0.25,range=1000,radius=105,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="olafaxethrow",killTime=0,displayname="Axe Throw",mcollision=false},
	["OriannaIzunaCommand"]={charName="Orianna",slot=0,type="Line",delay=0,range=1500,radius=80,speed=1200,addHitbox=true,danger=2,dangerous=false,proj="orianaizuna",killTime=0,displayname="",mcollision=false},
	["OrianaDissonanceCommand-"]={charName="Orianna",slot=1,type="Circle",delay=0.25,range=0,radius=255,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="OrianaDissonanceCommand-",killTime=0.3,displayname="",mcollision=false},
	["OriannasE"]={charName="Orianna",slot=2,type="Line",delay=0,range=1500,radius=85,speed=1850,addHitbox=true,danger=2,dangerous=false,proj="orianaredact",killTime=0,displayname="",mcollision=false},
	["OrianaDetonateCommand-"]={charName="Orianna",slot=3,type="Circle",delay=0.7,range=0,radius=410,speed=math.huge,addHitbox=true,danger=5,dangerous=true,proj="OrianaDetonateCommand-",killTime=0.5,displayname="",mcollision=false},
	["QuinnQ"]={charName="Quinn",slot=0,type="Line",delay=0,range=1050,radius=60,speed=1550,addHitbox=true,danger=2,dangerous=false,proj="QuinnQ",killTime=0,displayname="",mcollision=true},
	["PoppyQ"]={charName="Poppy",slot=0,type="Line",delay=0.5,range=430,radius=120,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="PoppyQ",killTime=1,displayname="",mcollision=false},
	["PoppyRSpell"]={charName="Poppy",slot=3,type="Line",delay=0.3,range=1200,radius=100,speed=1600,addHitbox=true,danger=3,dangerous=true,proj="PoppyRMissile",killTime=0,displayname="PoppyR",mcollision=false},
	["RengarE"]={charName="Rengar",slot=2,type="Line",delay=0.25,range=1000,radius=70,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="RengarEFinal",killTime=0,displayname="",mcollision=true},
	["reksaiqburrowed"]={charName="RekSai",slot=0,type="Line",delay=0.5,range=1050,radius=60,speed=1550,addHitbox=true,danger=3,dangerous=false,proj="RekSaiQBurrowedMis",killTime=0,displayname="RekSaiQ",mcollision=true},
	["RivenWindslashMissileRight"]={charName="Riven",slot=3,type="Line",delay=0.25,range=1100,radius=125,speed=1600,addHitbox=false,danger=5,dangerous=true,proj="RivenLightsaberMissile",killTime=0,displayname="WindSlash Right",mcollision=false},
	["RivenWindslashMissileCenter"]={charName="Riven",slot=3,type="Line",delay=0.25,range=1100,radius=125,speed=1600,addHitbox=false,danger=5,dangerous=true,proj="RivenLightsaberMissile",killTime=0,displayname="WindSlash Center",mcollision=false},
	["RivenWindslashMissileLeft"]={charName="Riven",slot=3,type="Line",delay=0.25,range=1100,radius=125,speed=1600,addHitbox=false,danger=5,dangerous=true,proj="RivenLightsaberMissile",killTime=0,displayname="WindSlash Left",mcollision=false},
	["RivenMartyr"]={charName="Riven",slot=1,type="Circle",delay=0.25,range=0,radius=300,speed=math.huge,addHitbox=false,danger=5,dangerous=true,proj="nil",killTime=0.2,displayname="RivenW",mcollision=false},
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
	["SivirQMissileReturn"]={charName="Sivir",slot=0,type="Return",delay=0,range=1075,radius=100,speed=1350,addHitbox=true,danger=2,dangerous=false,proj="SivirQMissileReturn",killTime=0,displayname="SivirQ2",mcollision=false},
	["SivirQ"]={charName="Sivir",slot=0,type="Line",delay=0.25,range=1075,radius=90,speed=1350,addHitbox=true,danger=2,dangerous=false,proj="SivirQMissile",killTime=0,displayname="SivirQ",mcollision=false},
	["SkarnerFracture"]={charName="Skarner",slot=2,type="Line",delay=0.35,range=350,radius=70,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="SkarnerFractureMissile",killTime=0,displayname="Fracture",mcollision=false},
	["SonaR"]={charName="Sona",slot=3,type="Line",delay=0.25,range=900,radius=140,speed=2400,addHitbox=true,danger=5,dangerous=true,proj="SonaR",killTime=0,displayname="Crescendo",mcollision=false},
	["SwainShadowGrasp"]={charName="Swain",slot=1,type="Circle",delay=1.1,range=900,radius=180,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="SwainShadowGrasp",killTime=0.5,displayname="Shadow Grasp",mcollision=false},
	["SyndraQ"]={charName="Syndra",slot=0,type="Circle",delay=0.6,range=800,radius=150,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="SyndraQSpell",killTime=0.2,displayname="",mcollision=false},
	["SyndraWCast"]={charName="Syndra",slot=1,type="Circle",delay=0.25,range=950,radius=210,speed=1450,addHitbox=true,danger=2,dangerous=false,proj="syndrawcast",killTime=0.2,displayname="SyndraW",mcollision=false},
	["SyndraE"]={charName="Syndra",slot=2,type="Cone",delay=0,range=950,radius=100,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="SyndraE",killTime=0,displayname="SyndraE2",mcollision=false},
	["TalonRake"]={charName="Talon",slot=1,type="Cone",delay=0.25,range=800,radius=80,speed=2300,angle=45,addHitbox=true,danger=2,dangerous=true,proj="talonrakemissileone",killTime=0,displayname="Rake",mcollision=false},
	["TalonRakeMissileTwo"]={charName="Talon",slot=1,type="Cone",delay=0.25,range=800,radius=80,speed=1850,angle=45,addHitbox=true,danger=2,dangerous=true,proj="talonrakemissiletwo",killTime=0,displayname="Rake2",mcollision=false},
	["TahmKenchQ"]={charName="TahmKench",slot=0,type="Line",delay=0.25,range=951,radius=90,speed=2800,addHitbox=true,danger=3,dangerous=true,proj="tahmkenchqmissile",killTime=0,displayname="Tongue Slash",mcollision=true},
	["TaricE"]={charName="Taric",slot=2,type="follow",delay=1,range=750,radius=100,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="TaricE",killTime=0.5,displayname="",mcollision=false},
	["ThreshQ"]={charName="Thresh",slot=0,type="Line",delay=0.5,range=1050,radius=70,speed=1900,addHitbox=true,danger=3,dangerous=true,proj="ThreshQMissile",killTime=0,displayname="",mcollision=true},
	["ThreshEFlay"]={charName="Thresh",slot=2,type="Line",delay=0.125,range=500,radius=110,speed=2000,addHitbox=true,danger=3,dangerous=true,proj="ThreshEMissile1",killTime=0,displayname="Flay",mcollision=false},
	["RocketJump"]={charName="Tristana",slot=1,type="Circle",delay=0.5,range=900,radius=270,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="RocketJump",killTime=0.3,displayname="",mcollision=false},
	["TryndamereE"]={charName="Tryndamere",slot=2,type="Line",delay=0,range=700,radius=93,speed=1000,addHitbox=true,danger=2,dangerous=false,proj="Slash",killTime=0.5,displayname="",mcollision=false},
	["WildCards"]={charName="TwistedFate",slot=0,type="Line",delay=0.25,range=1450,radius=40,speed=1000,angle=28,addHitbox=true,danger=2,dangerous=false,proj="SealFateMissile",killTime=0,displayname="",mcollision=false},
	["TwitchVenomCask"]={charName="Twitch",slot=1,type="Circle",delay=0.25,range=900,radius=275,speed=1400,addHitbox=true,danger=2,dangerous=false,proj="TwitchVenomCaskMissile",killTime=0.3,displayname="Venom Cask",mcollision=false},
	["TwitchSprayAndPrayAttack"]={charName="Twitch",slot=3,type="Line",delay=0.1,range=1200,radius=100,speed=1800,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.5,displayname="Venom Cask",mcollision=false},
	["UrgotHeatseekingLineMissile"]={charName="Urgot",slot=0,type="Line",delay=0.125,range=1000,radius=60,speed=1600,addHitbox=true,danger=2,dangerous=false,proj="UrgotHeatseekingLineMissile",killTime=0,displayname="Heatseeking Line",mcollision=true},
	["UrgotPlasmaGrenade"]={charName="Urgot",slot=2,type="Circle",delay=0.25,range=1100,radius=210,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="UrgotPlasmaGrenadeBoom",killTime=0.3,displayname="PlasmaGrenade",mcollision=false},
	["VarusQMissile"]={charName="Varus",slot=0,type="Line",delay=0.25,range=1475,radius=70,speed=1900,addHitbox=true,danger=2,dangerous=false,proj="VarusQMissile",killTime=0,displayname="VarusQ",mcollision=false},
	["VarusE"]={charName="Varus",slot=2,type="Circle",delay=1,range=925,radius=235,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="VarusE",killTime=1.5,displayname="",mcollision=false},
	["VarusR"]={charName="Varus",slot=3,type="Line",delay=0.25,range=800,radius=120,speed=1950,addHitbox=true,danger=3,dangerous=true,proj="VarusRMissile",killTime=0,displayname="",mcollision=false},
	["VeigarBalefulStrike"]={charName="Veigar",slot=0,type="Line",delay=0.1,range=900,radius=70,speed=1500,addHitbox=true,danger=2,dangerous=false,proj="VeigarBalefulStrikeMis",killTime=0,displayname="BalefulStrike",mcollision=false},
	["VeigarDarkMatter"]={charName="Veigar",slot=1,type="Circle",delay=1.35,range=900,radius=225,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="nil",killTime=0.5,displayname="DarkMatter",mcollision=false},
	["VeigarEventHorizon"]={charName="Veigar",slot=2,type="Ring",delay=0.5,range=700,radius=400,speed=math.huge,addHitbox=false,danger=3,dangerous=true,proj="nil",killTime=3.5,displayname="EventHorizon",mcollision=false},
	["VelkozQ"]={charName="Velkoz",slot=0,type="Line",delay=0.25,range=1100,radius=50,speed=1300,addHitbox=true,danger=2,dangerous=false,proj="VelkozQMissile",killTime=0,displayname="",mcollision=true},
	["VelkozQMissileSplit"]={charName="Velkoz",slot=0,type="Line",delay=0.25,range=1100,radius=55,speed=2100,addHitbox=true,danger=2,dangerous=false,proj="VelkozQMissileSplit",killTime=0,displayname="",mcollision=true},
	["VelkozW"]={charName="Velkoz",slot=1,type="Line",delay=0.25,range=1050,radius=88,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="VelkozWMissile",killTime=0,displayname="",mcollision=false},
	["VelkozE"]={charName="Velkoz",slot=2,type="Circle",delay=0.5,range=800,radius=225,speed=1500,addHitbox=false,danger=2,dangerous=false,proj="VelkozEMissile",killTime=0.5,displayname="",mcollision=false},
	["Vi-q"]={charName="Vi",slot=0,type="Line",delay=0.25,range=715,radius=90,speed=1500,addHitbox=true,danger=3,dangerous=true,proj="ViQMissile",killTime=0,displayname="Vi-Q",mcollision=false},
	["VladimirR"] = {charName = "Vladimir",slot=3,type="Circle",delay=0.25,range=700,radius=175,speed=math.huge,addHitbox=true,danger=4,dangerous=true,proj="nil",killTime=0,displayname = "Hemoplague",mcollision=false},
	["Laser"]={charName="Viktor",slot=2,type="Line",delay=0.25,range=1200,radius=80,speed=1050,addHitbox=true,danger=2,dangerous=false,proj="ViktorDeathRayMissile",killTime=0,displayname="",mcollision=false},
	["XerathArcanopulse2"]={charName="Xerath",slot=0,type="Line",delay=0.6,range=1600,radius=95,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="xeratharcanopulse2",killTime=0.5,displayname="Arcanopulse",mcollision=false},
	["XerathArcaneBarrage2"]={charName="Xerath",slot=1,type="Circle",delay=0.7,range=1000,radius=275,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="XerathArcaneBarrage2",killTime=0.3,displayname="ArcaneBarrage",mcollision=false},
	["XerathMageSpear"]={charName="Xerath",slot=2,type="Line",delay=0.2,range=1300,radius=60,speed=1400,addHitbox=true,danger=2,dangerous=true,proj="XerathMageSpearMissile",killTime=0,displayname="MageSpear",mcollision=true},
	["XerathLocusPulse"]={charName="Xerath",slot=3,type="Circle",delay=0.7,range=5600,radius=225,speed=math.huge,addHitbox=true,danger=3,dangerous=true,proj="XerathRMissileWrapper",killTime=0.4,displayname="",mcollision=false},
	["YasuoQ3W"]={charName="Yasuo",slot=0,type="Line",delay=0.4,range=1200,radius=90,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="YasuoQ3",killTime=0,displayname="Steel Tempest ",mcollision=false},
	["ZacQ"]={charName="Zac",slot=0,type="Line",delay=0.5,range=550,radius=120,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZacQ",killTime=0,displayname="",mcollision=false},
	["ZedQ"]={charName="Zed",slot=0,type="Line",delay=0.25,range=925,radius=50,speed=1700,addHitbox=true,danger=2,dangerous=false,proj="ZedQMissile",killTime=0,displayname="",mcollision=false},
	["ZiggsQSpell"]={charName="Ziggs",slot=0,type="Circle",delay=0.5,range=1100,radius=200,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsQSpell",killTime=0.2,displayname="",mcollision=false},
	["ZiggsQSpell2"]={charName="Ziggs",slot=0,type="Circle",delay=0.47,range=1100,radius=200,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsQSpell2",killTime=-0.23,displayname="",mcollision=true},
	["ZiggsQSpell3"]={charName="Ziggs",slot=0,type="Circle",delay=0.44,range=1100,radius=200,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsQSpell3",killTime=-0.26,displayname="",mcollision=true},
	["ZiggsW"]={charName="Ziggs",slot=1,type="Circle",delay=0.25,range=1000,radius=275,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsW",killTime=4.1,displayname="",mcollision=false,killName="ZiggsWToggle"},
	["ZiggsE"]={charName="Ziggs",slot=2,type="Circle",delay=0.5,range=900,radius=250,speed=1750,addHitbox=true,danger=2,dangerous=false,proj="ZiggsE",killTime=10,displayname="",mcollision=false},
	["ZiggsR"]={charName="Ziggs",slot=3,type="Circle",delay=0,range=5300,radius=500,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZiggsR",killTime=1.25,displayname="",mcollision=false},
	["ZileanQ"]={charName="Zilean",slot=0,type="Circle",delay=0.3,range=900,radius=210,speed=2000,addHitbox=true,danger=2,dangerous=false,proj="ZileanQMissile",killTime=1.5,displayname="",mcollision=false},
	["ZyraQ"]={charName="Zyra",slot=0,type="Rectangle",delay=0.4,range=800,radius2=400,radius=140,speed=math.huge,addHitbox=true,danger=2,dangerous=false,proj="ZyraQ",killTime=0.35,displayname="",mcollision=false},
	["ZyraE"]={charName="Zyra",slot=2,type="Line",delay=0.25,range=1100,radius=70,speed=1300,addHitbox=true,danger=3,dangerous=true,proj="ZyraE",killTime=0,displayname="Grasping Roots",mcollision=false},
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
	["Heimerdinger"] = {
		[0] = {dl = 3,name = "Turret",range = 425,spellDelay = 50,speed = 1250,spellKey = 0,evadeType = "WindWallP",castType = "Position",}
	},
	["Kassadin"] = { 
		[3] = {dl = 1,name = "RiftWalk",speed = math.huge,range = 450,spellDelay = 250,spellKey = 3,evadeType = "DashP",castType = "Position",},
	},	
	-- ["Kayle"] = { 
		-- [3] = {dl = 4,name = "Intervention",speed = math.huge,range = 0,spellDelay = 250,spellKey = 3,evadeType = "SpellShieldT",castType = "Target",},
	-- },	
	["LeBlanc"] = { 
		[1] = {dl = 2,name = "Distortion",range = 600,spellDelay = 50,speed = 1600,spellKey = 1,evadeType = "DashP",castType = "Position",},
	},	
	-- ["LeeSin"] = { 
		-- [1] = {dl = 3,name = "Safeguard",range = 700,speed = 1400,spellDelay = 50,spellKey = 1,evadeType = "DashT",castType = "Target",},
	-- },
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
		--[1] = {dl = 3,name = "FioraW",range = 750,spellDelay = 100,spellKey = 1,evadeType = "WindWallP",castType = "Position",},
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
	["Shen"] = { 
		[2] = {dl = 4,name = "Shadow Dash",spellDelay = 0,spellKey = 2,evadeType = "DashP",castType = "Position"},
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
		--[2] = {dl = 2,name = "SweepingBlade",range = 475,speed = 1000,spellDelay = 50,spellKey = 2,evadeType = "DashT",castType = "Target",},
	},
	["Vladimir"] = { 
		[1] = {dl = 4,name = "Sanguine Pool",range = 350,spellDelay = 50,spellKey = 1,evadeType = "SpellShieldS",castType = "Self",	},
	},	
	-- ["MasterYi"] = { 
		-- [0] = {dl = 3,name = "AlphaStrike",range = 600,speed = math.huge,spellDelay = 100,spellKey = 0,evadeType = "DashT",castType = "Target",},
	-- },	
	-- ["Katarina"] = { 
		-- [2] = {dl = 3,name = "KatarinaE",range = 700,speed = math.huge,spellKey = 2,evadeType = "DashT",castType = "Target",	},
	-- },	
	["Kindred"] = { 
		[0] = {dl = 1,name = "KindredQ",range = 300,speed = 733,spellDelay = 50,spellKey = 0,evadeType = "DashP",castType = "Position",},
	},	
	-- ["Talon"] = { 
		-- [2] = {dl = 3,name = "Cutthroat",range = 700,speed = math.huge,spellDelay = 50,spellKey = 2,evadeType = "DashT",castType = "Target",},
	-- },
}
DelayAction(function()
	for _,i in pairs(self.Spells) do
		for kk,k in pairs(GetEnemyHeroes()) do
			if i.displayname == "" then i.displayname = _ end
			if i.charName == k.charName then
				if self.supportedtypes[i.type].supported == false then
					print("<font color=\"#FFFFF\"><b>"..i.charName.." - spell : "..self.str[i.slot].." | "..i.displayname.. "<font color=\"#FFFFFF\"> is not supported </b></font>")
				end
			end
		end
	end
end,001.25)

offer = 0

end

function SLEvade:WndMsg(s1,s2)
	if s2 == string.byte("Y") and s1 == 257 and EMenu.D:Value() then
		self:Skillshot()
		offer = offer+1
	end
end

function SLEvade:Skillshot()
		local s = {}
		s.spell = {}
		s.p = {}
		s.p.startPos = Vector(2874,95,2842)--GetMousePos()
		s.spell.name = "DarkBindingMissile"..offer
		s.spell.charName = myHero.charName
		s.spell.proj = nil
		s.spell.danger = 2
		s.spell.displayname = "DarkBinding"
        s.spell.killTime = 0.25
        s.spell.mcollision = true
        s.spell.dangerous = false
        s.spell.radius = 120
        s.spell.speed = 250
        s.spell.delay = 0.25
		s.spell.range = 1200
        s.p.endPos = Vector(2104,95,3196)--Vector(GetMousePos()) + Vector(Vector(myHero) - GetMousePos()):normalized() * (s.spell.range + myHero.boundingRadius)																			
        s.spell.type = "Line"
        s.uDodge = false 
        s.caster = myHero
        s.mpos = nil
		s.debug = true
        s.startTime = os.clock()
        self.obj[s.spell.name] = s
		DelayAction(function() self.obj[s.spell.name] = nil end,s.spell.range/s.spell.speed - s.spell.delay)
end

function SLEvade:Tickp()
	heroes[myHero.networkID] = nil
	for _,i in pairs(self.obj) do
		if i.o and EMenu.Advanced.LDR:Value() and i.spell.type == "Line" and GetDistance(myHero,i.o) >= 3000 and not self.globalults[_] then return end
		if i.o and EMenu.Advanced.LDR:Value() and i.spell.type == "Return" and GetDistance(myHero,i.o) >= 3000 and not self.globalults[_] then return end
		if i.p and EMenu.Advanced.LDR:Value() and (i.spell.type == "Circle" or i.spell.type =="follow") and GetDistance(myHero,i.p.endPos) >= 3000 and not self.globalults[_] then return end
		if i.p and EMenu.Advanced.LDR:Value() and i.spell.type == "Rectangle" and GetDistance(myHero,i.p.endPos) >= 3000 and not self.globalults[_] then return end
		if i.p and EMenu.Advanced.LDR:Value() and i.spell.type == "Cone" and GetDistance(myHero,i.p.endPos) >= 3000 and not self.globalults[_] then return end
		if not i.jp or not i.safe then
			self.asd = false
			DisableHoldPosition(false)
			DisableAll(false)
		end
		if i.o then
			i.p = {}
			i.p.startPos = Vector(i.o.startPos)
			i.p.endPos = Vector(i.o.endPos)
		end
		if i.p then
			self:CleanObj(_,i) 
			self:Dodge(_,i) 
			self:Pathfinding(_,i)
			self:UDodge(_,i)
			self:Mpos(_,i)
		end
	end
	self:ItemMenu()
end

function SLEvade:Drawp()
	for _,i in pairs(self.obj) do
		if i.o and EMenu.Advanced.LDR:Value() and i.spell.type == "Line" and GetDistance(myHero,i.o) >= 3000 and not self.globalults[_] then return end
		if i.o and EMenu.Advanced.LDR:Value() and i.spell.type == "Return" and GetDistance(myHero,i.o) >= 3000 and not self.globalults[_] then return end
		if i.p and EMenu.Advanced.LDR:Value() and (i.spell.type == "Circle" or i.spell.type =="follow") and GetDistance(myHero,i.p.endPos) >= 3000 and not self.globalults[_] then return end
		if i.p and EMenu.Advanced.LDR:Value() and i.spell.type == "Rectangle" and GetDistance(myHero,i.p.endPos) >= 3000 and not self.globalults[_] then return end
		if i.p and EMenu.Advanced.LDR:Value() and i.spell.type == "Cone" and GetDistance(myHero,i.p.endPos) >= 3000 and not self.globalults[_] then return end
		if i.o then
			i.p = {}
			i.p.startPos = Vector(i.o.startPos)
			i.p.endPos = Vector(i.o.endPos)
		end
		if i.p then
			if i.spell.type ~= ("Circle" or "Ring") then self.endposs = Vector(i.p.startPos)+Vector(Vector(i.p.endPos)-i.p.startPos):normalized()*i.spell.range end
			self.opos = self:sObjpos(_,i)
			-- self.cpos = self:sCircPos(_,i)
			self:Drawings(_,i)
			self:Drawings2(_,i)
		end
	self:HeroCollsion(_,i)
	self:MinionCollision(_,i)
	self:WallCollision(_,i)
	end
	if EMenu.Draws.DevOpt:Value() then
		DrawText(myHero.pos,20,20,20,GoS.Green)
	end
	if EMenu.Draws.DES:Value() then
		self:Status()
	end
end

function SLEvade:MinionCollision(_,i)
	if i.spell.type == "Line" and i.spell.mcollision and i.p and EMenu.Advanced.EMC:Value() and (i.debug or EMenu.Spells[_]["Coll".._]:Value()) and not i.hcoll and not i.wcoll then
		if i.debug then i.spell.range2 = 1200 else i.spell.range2 = self.Spells[_].range end
		for m,p in pairs(minionManager.objects) do
			if p and p.alive and p.team == MINION_ALLY and GetDistance(p.pos,i.p.startPos) < i.spell.range2 then
				local vP = VectorPointProjectionOnLineSegment(Vector(self.opos),i.p.endPos,Vector(p))
				if vP and GetDistance(vP,p.pos) < (i.spell.radius+p.boundingRadius) then
					i.spell.range = GetDistance(i.p.startPos,vP)
					i.mcoll = true
				else
					i.spell.range = i.spell.range2
				end
			end
		end
	end
end

function SLEvade:HeroCollsion(_,i)
	if i.spell.type == "Line" and i.spell.mcollision and i.p and EMenu.Advanced.EMC:Value() and (i.debug or EMenu.Spells[_]["Coll".._]:Value()) and not i.mcoll and not i.wcoll then
		if i.debug then i.spell.range2 = 1200 else i.spell.range2 = self.Spells[_].range end
		for m,p in pairs(heroes) do
			if p and p.alive and p.team == MINION_ALLY and GetDistance(p.pos,i.p.startPos) < i.spell.range2 then
				local vP = VectorPointProjectionOnLineSegment(Vector(self.opos),i.p.endPos,Vector(p))
				if vP and GetDistance(vP,p.pos) < (i.spell.radius+p.boundingRadius) then
					i.spell.range = GetDistance(i.p.startPos,vP)
					i.hcoll = true
				else
					i.spell.range = i.spell.range2
				end
			end
		end
	end
end

function SLEvade:WallCollision(_,i)
	if i.spell.type == "Line" and i.spell.mcollision and i.p and EMenu.Advanced.EMC:Value() and (i.debug or EMenu.Spells[_]["Coll".._]:Value()) and not i.mcoll and not i.hcoll then
		if i.debug then i.spell.range2 = 1200 else i.spell.range2 = self.Spells[_].range end
		for m,p in pairs(self.YasuoWall) do
			if p.obj and p.obj.valid and p.obj.spellOwner.team == MINION_ALLY and GetDistance(p.obj.pos,i.p.startPos) < i.spell.range2 then
				local vP = VectorPointProjectionOnLineSegment(Vector(self.opos),i.p.endPos,Vector(p.obj))
				if vP and GetDistance(vP,p.obj.pos) < (i.spell.radius+p.obj.boundingRadius) then
					i.spell.range = GetDistance(i.p.startPos,vP)
					i.wcoll = true
				else
					i.spell.range = i.spell.range2
				end
			end
		end
	end
end

function SLEvade:sObjpos(_,i)
	if i.spell.speed ~= math.huge and i.p then
		return i.p.startPos+Vector(Vector(self.endposs)-i.p.startPos):normalized()*(i.spell.speed*(os.clock()-i.startTime) + (i.spell.radius+myHero.boundingRadius)/2)
	else
		return Vector(i.p.startPos)
	end
end

function SLEvade:sCircPos(_,i)
	if i.p then
		return (i.spell.radius*(os.clock()-(i.spell.killTime + GetDistance(i.caster,i.p.endPos)/i.spell.speed + i.spell.delay)-i.startTime) + i.spell.radius)
	end
end

function SLEvade:Status()
	if not EMenu.Keys.DD:Value() and not (EMenu.Keys.DoD:Value() or EMenu.Keys.DoD2:Value()) then
		DrawText("Evade : ON", 400, myHero.pos2D.x-50,  myHero.pos2D.y, ARGB(255,255,255,255))
	end
	if EMenu.Keys.DD:Value() then
		DrawText("Evade : OFF", 400, myHero.pos2D.x-50,  myHero.pos2D.y, ARGB(255,255,255,255))
	end
	if (EMenu.Keys.DoD:Value() or EMenu.Keys.DoD2:Value()) and not EMenu.Keys.DD:Value() then 
		DrawText("Evade : ON", 400, myHero.pos2D.x-50,  myHero.pos2D.y, GoS.Yellow)
	end
end

function SLEvade:Humanizer(_,i)
	if not i.status then
		if (i.debug or EMenu.Spells[_]["H".._]:Value()) and i.caster and i.caster.visible then
			return (i.spell.delay + GetDistance(myHero,i.p.startPos) / i.spell.speed)/(myHero.ms/100)
		else
			return 0 
		end
		i.status = true
	end
end

function SLEvade:Position()
return Vector(myHero) + Vector(Vector(self.mV) - myHero.pos):normalized() * myHero.ms/2
end

function SLEvade:prwp(unit, wp)
  if wp and unit == myHero and wp.index == 1 then
	self.mV = wp.position
  end
end

function SLEvade:CleanObj(_,i)
	if i.o and not i.o.valid and i.spell.type ~= "Circle" then
		self.obj[_] = nil
	elseif i.spell.type == "Circle" and i.spell.killTime then
		DelayAction(function() self.obj[_] = nil end, i.spell.killTime + GetDistance(i.caster,i.p.endPos))
	end
end

function SLEvade:ItemMenu()
	for item,c in pairs(self.SI) do
		if GetItemSlot(myHero,item)>0 then
			if not c.State and not EMenu.invulnerable[c.Name] then
				EMenu.invulnerable:Menu(c.Name,""..myHero.charName.." | Item - "..c.Name)
				EMenu.invulnerable[c.Name]:Boolean("Dodge"..c.Name, "Enable Dodge", true)
				EMenu.invulnerable[c.Name]:Slider("d"..c.Name,"Danger", 5, 1, 5, 1)
				EMenu.invulnerable[c.Name]:Slider("hp"..c.Name,"HP", 100, 1, 100, 5)
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
				EMenu.EvadeSpells[c.Name]:Slider("d"..c.Name,"Danger", 3, 1, 5, 1)
				EMenu.EvadeSpells[c.Name]:Slider("hp"..c.Name,"HP", 100, 1, 100, 5)
			end
			c.State = true
		else
			c.State = false
		end
	end
end

function SLEvade:Mpos(_,i)
	if i.spell.type == "Circle" then 
		if i.p and GetDistance(myHero,i.p.endPos) < i.spell.radius + myHero.boundingRadius and not i.safe then
			if not i.mpos and not self.mposs then
				i.mpos = Vector(myHero) + Vector(Vector(GetMousePos()) - myHero.pos):normalized() * (i.spell.radius+myHero.boundingRadius)
				self.mposs = GetMousePos()
			end
		else
			self.mposs = nil
			i.mpos = nil
		end
	elseif i.spell.type == "Line" then
		if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
			if not i.mpos and not self.mposs2 then
				i.mpos = Vector(myHero) + Vector(Vector(GetMousePos()) - myHero.pos):normalized() * (i.spell.radius+myHero.boundingRadius)
				self.mposs2 = GetMousePos()
			end	
		else
			self.mposs2 = nil
			i.mpos = nil
		end
	elseif i.spell.type == "Rectangle" then
		if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
			if not i.mpos and not self.mposs3 then
				i.mpos = Vector(myHero) + Vector(Vector(GetMousePos()) - myHero.pos):normalized() * (i.spell.radius+myHero.boundingRadius)
				self.mposs3 = GetMousePos()
			end	
		else
			self.mposs3 = nil
			i.mpos = nil
		end
	elseif i.spell.type == "Cone" then
		if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
			if not i.mpos and not self.mposs4 then
				i.mpos = Vector(myHero) + Vector(Vector(GetMousePos()) - myHero.pos):normalized() * (i.spell.radius+myHero.boundingRadius)
				self.mposs4 = GetMousePos()
			end	
		else
			self.mposs4 = nil
			i.mpos = nil
		end
	elseif i.spell.type == "Return" then
		if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
			if not i.mpos and not self.mposs2 then
				i.mpos = Vector(myHero) + Vector(Vector(GetMousePos()) - myHero.pos):normalized() * (i.spell.radius+myHero.boundingRadius)
				self.mposs2 = GetMousePos()
			end	
		else
			self.mposs2 = nil
			i.mpos = nil
		end
	elseif i.spell.type == "follow" then
		if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
			if not i.mpos and not self.mposs2 then
				i.mpos = Vector(myHero) + Vector(Vector(GetMousePos()) - myHero.pos):normalized() * (i.spell.radius+myHero.boundingRadius)
				self.mposs2 = GetMousePos()
			end	
		else
			self.mposs2 = nil
			i.mpos = nil
		end
	end
end

function SLEvade:UDodge(_,i)
	if EMenu.Keys.DoD:Value() or EMenu.Keys.DoD2:Value() then
			self.DodgeOnlyDangerous = true
		else
			self.DodgeOnlyDangerous = false
	end
	if not i.uDodge then
		if i.safe and i.spell.type == "Line" then
			if GetDistance(self.opos)/i.spell.speed + i.spell.delay < GetDistance(i.safe)/myHero.ms then 
				i.uDodge = true 
			end
		elseif i.safe and i.spell.type == "Circle" and i.p then
			if GetDistance(i.p.endPos)/i.spell.speed + i.spell.delay < GetDistance(i.safe)/myHero.ms then
				i.uDodge = true 
			end
		elseif i.safe and i.spell.type == "Rectangle" and i.p then
			if GetDistance(i.p.endPos)/i.spell.speed + i.spell.delay < GetDistance(i.safe)/myHero.ms then
				i.uDodge = true 
			end
		elseif i.safe and i.spell.type == "Cone" and i.p then
			if GetDistance(i.p.endPos)/i.spell.speed + i.spell.delay < GetDistance(i.safe)/myHero.ms then
				i.uDodge = true 
			end
		elseif i.safe and i.spell.type == "Return" and i.o then
			if GetDistance(i.o.pos)/i.spell.speed  < GetDistance(i.safe)/myHero.ms then 
				i.uDodge = true 
			end
		elseif i.safe and i.spell.type == "follow" then
			if GetDistance(i.caster.pos)/i.spell.speed + i.spell.delay < GetDistance(i.safe)/myHero.ms then 
				i.uDodge = true 
			end
		end
	end
end

function SLEvade:Pathfinding(_,i)
	if i.debug or EMenu.Spells[_]["ffe".._]:Value() then
		DelayAction(function()
			if i.spell.type == "Line" and i.p then
					i.p.startPos = Vector(i.p.startPos)
					i.p.endPos = Vector(self.endposs)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(Vector(self.opos),i.p.endPos,v3)
					local jp2 = Vector(VectorIntersection(i.p.startPos,i.p.endPos,myHero.pos+(Vector(i.p.startPos)-Vector(i.p.endPos)):perpendicular(),myHero.pos).x,i.p.endPos.y,VectorIntersection(i.p.startPos,i.p.endPos,myHero.pos+(Vector(i.p.startPos)-Vector(i.p.endPos)):perpendicular(),myHero.pos).y)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
						if GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular(),jp2) >= GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular2(),jp2) then
							self.asd = true
							self.patha = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							if not MapPosition:inWall(self.patha) then
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
							i.isEvading = true
						else
							self.asd = true
							self.patha = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							if not MapPosition:inWall(self.patha) then
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
							i.isEvading = true
						end
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end
			elseif i.spell.type == "Circle" then
				if _ == "AbsoluteZero" then
					i.p.endPos = Vector(i.caster.pos)
				else
					i.p.endPos = Vector(i.p.endPos)
				end
				if GetDistance(myHero,i.p.endPos) < i.spell.radius + myHero.boundingRadius and not i.safe then
					self.asd = true
					self.pathb = Vector(i.p.endPos) + (GetOrigin(myHero) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
					if not MapPosition:inWall(self.pathb) then
							i.safe = Vector(i.p.endPos) + (GetOrigin(myHero) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						else
							i.safe = i.p.endPos + Vector(self.pathb-i.p.endPos):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
					end
					i.isEvading = true
				else
					self.asd = false
					self.pathb = nil
					self.pathb2 = nil
					i.isEvading = false
					DisableHoldPosition(false)
					DisableAll(false)
				end
			elseif i.spell.type == "Rectangle" then
				local startp = Vector(i.p.endPos) - (Vector(i.p.endPos) - Vector(i.p.startPos)):normalized():perpendicular() * (i.spell.radius2 or 400)
				local endp = Vector(i.p.endPos) + (Vector(i.p.endPos) - Vector(i.p.startPos)):normalized():perpendicular() * (i.spell.radius2 or 400)
				if GetDistance(startp) < i.spell.range + myHero.boundingRadius and GetDistance(endp) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(startp,endp,v3)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos then
						self.asd = true
						self.pathc = Vector(i.mpos)+Vector(startp-endp):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						if not MapPosition:inWall(self.pathc) then
								i.safe = Vector(myHero)+Vector(startp-endp):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else
								i.safe =  Vector(myHero)+Vector(startp-endp):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						end
						i.isEvading = true
					end
				else
					self.asd = false
					self.pathc = nil
					i.isEvading = false
					DisableHoldPosition(false)
					DisableAll(false)
				end
			elseif i.spell.type == "Cone" then
					i.p.startPos = Vector(i.p.startPos)
					i.p.endPos = Vector(self.endposs)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(i.p.startPos,i.p.endPos,v3)
					local jp2 = Vector(VectorIntersection(i.p.startPos,i.p.endPos,myHero.pos+(Vector(i.p.startPos)-Vector(i.p.endPos)):perpendicular(),myHero.pos).x,i.p.endPos.y,VectorIntersection(i.p.startPos,i.p.endPos,myHero.pos+(Vector(i.p.startPos)-Vector(i.p.endPos)):perpendicular(),myHero.pos).y)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
						if GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular(),jp2) >= GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular2(),jp2) then
							self.asd = true
							self.patha = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							if not MapPosition:inWall(self.patha) then
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
							i.isEvading = true
						else
							self.asd = true
							self.patha = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							if not MapPosition:inWall(self.patha) then
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
							i.isEvading = true
						end
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end
			elseif i.spell.type == "Return" and i.o then
					i.p.startPos = Vector(i.p.startPos)
					i.p.endPos = Vector(i.caster.pos)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(Vector(i.o.pos),i.p.endPos,v3)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe then
						self.asd = true
						self.patha = Vector(myHero)+Vector(Vector(myHero)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						if not MapPosition:inWall(self.patha) then
								i.safe = Vector(myHero)+Vector(Vector(myHero)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else 
								i.safe = Vector(myHero)+Vector(Vector(myHero)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						end
						i.isEvading = true
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end
			elseif i.spell.type == "follow" then
					i.p.startPos = Vector(i.caster.pos)
					i.p.endPos = Vector(i.p.endPos)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local v4 = Vector(i.caster.pos) + i.TarE
					local jp = VectorPointProjectionOnLineSegment(i.p.startPos,v4,v3)
					local jp2 = Vector(VectorIntersection(i.p.startPos,v4,myHero.pos+(Vector(i.p.startPos)-Vector(v4)):perpendicular(),myHero.pos).x,v4.y,VectorIntersection(i.p.startPos,v4,myHero.pos+(Vector(i.p.startPos)-Vector(v4)):perpendicular(),myHero.pos).y)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos and not i.coll and jp2 then
						if GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular(),jp2) >= GetDistance(GetOrigin(myHero) + Vector(i.p.startPos-i.p.endPos):perpendicular2(),jp2) then
						self.asd = true
						self.patha = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							if not MapPosition:inWall(self.patha) then
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						else
							self.asd = true
							self.patha = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							if not MapPosition:inWall(self.patha) then
								i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular2():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else 
								i.safe = jp2 + Vector(i.p.startPos - i.p.endPos):perpendicular():normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						end
						i.isEvading = true
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end	
			end
		end,self:Humanizer(_,i))
	else
		DelayAction(function()
			if i.spell.type == "Line" and i.p then
					i.p.startPos = Vector(i.p.startPos)
					i.p.endPos = Vector(self.endposs)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(Vector(self.opos),i.p.endPos,v3)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos and not i.coll then
						self.asd = true
						self.patha = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						self.patha2 = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						if GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2(),i.jp) > GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular(),i.jp) then
							if not MapPosition:inWall(self.patha2) then
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						else
							if not MapPosition:inWall(self.patha) then
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else 
								i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						end
						i.isEvading = true
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end
			elseif i.spell.type == "Circle" then
				if _ == "AbsoluteZero" then
					i.p.endPos = Vector(i.caster.pos)
				else
					i.p.endPos = Vector(i.p.endPos)
				end
				if GetDistance(myHero,i.p.endPos) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos then
					self.asd = true
					self.pathb = Vector(i.p.endPos) + (GetOrigin(myHero) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
					self.pathb2 = Vector(i.p.endPos) + (Vector(i.mpos) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
					if self.mposs and GetDistance(self.mposs,self.pathb) > GetDistance(self.mposs,self.pathb2) then
						if not MapPosition:inWall(self.pathb2) then
								i.safe = Vector(i.p.endPos) + (Vector(i.mpos) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else
								i.safe = i.p.endPos + Vector(self.pathb2-i.p.endPos):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						end
					else
						if not MapPosition:inWall(self.pathb) then
								i.safe = Vector(i.p.endPos) + (GetOrigin(myHero) - Vector(i.p.endPos)):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else
								i.safe = i.p.endPos + Vector(self.pathb-i.p.endPos):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						end
					end
					i.isEvading = true
				else
					self.asd = false
					self.pathb = nil
					self.pathb2 = nil
					i.isEvading = false
					DisableHoldPosition(false)
					DisableAll(false)
				end
			elseif i.spell.type == "Rectangle" then
				local startp = Vector(i.p.endPos) - (Vector(i.p.endPos) - Vector(i.p.startPos)):normalized():perpendicular() * (i.spell.radius2 or 400)
				local endp = Vector(i.p.endPos) + (Vector(i.p.endPos) - Vector(i.p.startPos)):normalized():perpendicular() * (i.spell.radius2 or 400)
				if GetDistance(startp) < i.spell.range + myHero.boundingRadius and GetDistance(endp) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(startp,endp,v3)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos then
						self.asd = true
						self.pathc = Vector(i.mpos)+Vector(startp-endp):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						self.pathc2 = Vector(i.mpos)+Vector(startp-endp):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						if GetDistance(Vector(i.mpos)+Vector(startp-endp):normalized():perpendicular2(),i.jp) > GetDistance(Vector(i.mpos)+Vector(startp-endp):normalized():perpendicular(),i.jp) then
							if not MapPosition:inWall(self.pathc2) then
									i.safe = Vector(i.mpos)+Vector(startp-endp):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else
									i.safe = i.p.endPos + Vector(self.pathc-i.p.endPos):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						else
							if not MapPosition:inWall(self.pathc) then
									i.safe = Vector(i.mpos)+Vector(startp-endp):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else
									i.safe = i.p.endPos + Vector(self.pathc-i.p.endPos):normalized() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end					
						end
						i.isEvading = true
					end
				else
					self.asd = false
					self.pathc = nil
					i.isEvading = false
					DisableHoldPosition(false)
					DisableAll(false)
				end
			elseif i.spell.type == "Cone" then
					i.p.startPos = Vector(i.p.startPos)
					i.p.endPos = Vector(self.endposs)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(i.p.startPos,i.p.endPos,v3)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos and not i.coll then
						self.asd = true
						self.patha = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						self.patha2 = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						if GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2(),i.jp) > GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular(),i.jp) then
							if not MapPosition:inWall(self.patha2) then
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						else
							if not MapPosition:inWall(self.patha) then
								i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else 
								i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						end
						i.isEvading = true
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end
			elseif i.spell.type == "Return" and i.o then
					i.p.startPos = Vector(i.p.startPos)
					i.p.endPos = Vector(i.caster.pos)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local jp = VectorPointProjectionOnLineSegment(Vector(i.o.pos),i.p.endPos,v3)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos and not i.coll then
						self.asd = true
						self.patha = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						self.patha2 = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						if GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2(),i.jp) > GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular(),i.jp) then
							if not MapPosition:inWall(self.patha2) then
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						else
							if not MapPosition:inWall(self.patha) then
								i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else 
								i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-i.p.endPos):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						end
						i.isEvading = true
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end
			elseif i.spell.type == "follow" then
					i.p.startPos = Vector(i.caster.pos)
					i.p.endPos = Vector(i.p.endPos)
				if GetDistance(i.p.startPos) < i.spell.range + myHero.boundingRadius and GetDistance(self.endposs) < i.spell.range + myHero.boundingRadius then
					local v3 = Vector(myHero)
					local v4 = Vector(i.caster.pos) + i.TarE
					local jp = VectorPointProjectionOnLineSegment(i.p.startPos,v4,v3)
					i.jp = jp
					if i.jp and GetDistance(myHero,i.jp) < i.spell.radius + myHero.boundingRadius and not i.safe and i.mpos and not i.coll then
						self.asd = true
						self.patha = Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						self.patha2 = Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
						if GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular2(),i.jp) > GetDistance(Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular(),i.jp) then
							if not MapPosition:inWall(self.patha2) then
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
								else 
									i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						else
							if not MapPosition:inWall(self.patha) then
								i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							else 
								i.safe = Vector(i.mpos)+Vector(Vector(i.mpos)-v4):normalized():perpendicular2() * ((i.spell.radius + myHero.boundingRadius)*1.1)
							end
						end
						i.isEvading = true
					else
						self.asd = false
						self.patha = nil
						self.patha2 = nil
						i.isEvading = false
						DisableHoldPosition(false)
						DisableAll(false)
					end
				end	
			end
		end,self:Humanizer(_,i))
	end
end

function SLEvade:Drawings(_,i)
	if i.debug or EMenu.Spells[_]["Draw".._]:Value() then
		if i.spell.type == "Line" and not EMenu.Keys.DDraws:Value() then
			local sPos = Vector(self.opos)
			local ePos = Vector(self.endposs)
			if EMenu.Draws.DSPath:Value() then
				dRectangleOutline(sPos, ePos, i.spell.radius+myHero.boundingRadius*2, EMenu.Draws.SD.t:Value(), EMenu.Draws.SD.c:Value(), i.debug or EMenu.Spells[_]["Dodge".._]:Value())
				if EMenu.Draws.DSEW:Value() then
					dRectangleOutline2(sPos, ePos, i.spell.radius+myHero.boundingRadius, EMenu.Draws.SD.t:Value()+0.5, EMenu.Draws.SD.c:Value(), i.debug or EMenu.Spells[_]["Dodge".._]:Value())
				end
			end		
		end
		if i.spell.type == "Circle" and not EMenu.Keys.DDraws:Value() then
			if _ == "AbsoluteZero" then
				i.p.endPos = Vector(i.caster.pos)
			else
				i.p.endPos = Vector(i.p.endPos)
			end
			if EMenu.Draws.DSPath:Value() then
				DrawCircle(i.p.endPos,i.spell.radius,EMenu.Draws.SD.t:Value()+0.5,75,EMenu.Draws.SD.c:Value())	
				-- DrawCircle(i.p.endPos,self.cpos,EMenu.Draws.SD.t:Value()+0.5,20,GoS.Yellow)
			end
		end
		if i.spell.type == "Rectangle" and not EMenu.Keys.DDraws:Value() then
			DrawRectangle(i.p.startPos,i.p.endPos,i.spell.radius+myHero.boundingRadius,i.spell.radius2,EMenu.Draws.SD.t:Value()+0.5,EMenu.Draws.SD.c:Value())
		end
		if i.spell.type == "Cone" and not EMenu.Keys.DDraws:Value() then
			DrawCone(i.p.startPos,Vector(self.endposs),i.spell.angle or 40,EMenu.Draws.SD.t:Value()+0.5,EMenu.Draws.SD.c:Value())
		end
		if i.spell.type == "Return" and not EMenu.Keys.DDraws:Value() and i.o then
			local sPos = Vector(i.o.pos)
			local ePos = Vector(i.caster.pos)
			if EMenu.Draws.DSPath:Value() then
				dRectangleOutline(sPos, ePos, i.spell.radius+myHero.boundingRadius*2, EMenu.Draws.SD.t:Value(), EMenu.Draws.SD.c:Value(), i.debug or EMenu.Spells[_]["Dodge".._]:Value())
				if EMenu.Draws.DSEW:Value() then
					dRectangleOutline2(sPos, ePos, i.spell.radius+myHero.boundingRadius, EMenu.Draws.SD.t:Value()+0.5, EMenu.Draws.SD.c:Value(), i.debug or EMenu.Spells[_]["Dodge".._]:Value())
				end
			end
		end
		if i.spell.type == "follow" and not EMenu.Keys.DDraws:Value() then
			local sPos = Vector(i.caster.pos)
			local ePos = Vector(i.caster.pos) + i.TarE
			if EMenu.Draws.DSPath:Value() then
				dRectangleOutline(sPos, ePos, i.spell.radius+myHero.boundingRadius*2, EMenu.Draws.SD.t:Value(), EMenu.Draws.SD.c:Value(), i.debug or EMenu.Spells[_]["Dodge".._]:Value())
				if EMenu.Draws.DSEW:Value() then
					dRectangleOutline2(sPos, ePos, i.spell.radius+myHero.boundingRadius, EMenu.Draws.SD.t:Value()+0.5, EMenu.Draws.SD.c:Value(), i.debug or EMenu.Spells[_]["Dodge".._]:Value())
				end
			end
		end
		if i.spell.type == "Ring" and not EMenu.Keys.DDraws:Value() then
			DrawCircle(i.p.endPos.x,i.p.endPos.y,i.p.endPos.z,i.spell.radius,EMenu.Draws.SD.t:Value()+0.5,75,EMenu.Draws.SD.c:Value())
			DrawCircle(i.p.endPos.x,i.p.endPos.y,i.p.endPos.z,i.spell.radius/1.5,EMenu.Draws.SD.t:Value()+0.5,75,EMenu.Draws.SD.c:Value())
		end
		if i.jp and (GetDistance(myHero,i.jp) > i.spell.radius + myHero.boundingRadius) and i.safe and i.spell.type == "Line" then
			i.safe = nil
		elseif i.p and (GetDistance(myHero,i.p.endPos) > i.spell.radius + myHero.boundingRadius) and i.safe and i.spell.type == "Circle" then
			i.safe = nil
		elseif i.jp and (GetDistance(myHero,i.jp) > i.spell.radius + myHero.boundingRadius) and i.safe and i.spell.type == "Rectangle" then
			i.safe = nil
		elseif i.jp and (GetDistance(myHero,i.jp) > i.spell.radius + myHero.boundingRadius) and i.safe and i.spell.type == "Cone" then
			i.safe = nil
		end
	end
end

function SLEvade:Drawings2(_,i)
		if EMenu.Draws.DevOpt:Value() then 
			if i.jp then 
				DrawCircle(i.jp,50,1,20,GoS.Red) 
			end 
		end
		if EMenu.Draws.DEPos:Value() and i.safe and (i.debug or ((not self.DodgeOnlyDangerous and EMenu.d:Value() <= EMenu.Spells[_]["d".._]:Value()) or (self.DodgeOnlyDangerous and EMenu.Spells[_]["IsD".._]:Value())) and EMenu.Spells[_]["Dodge".._]:Value() and EMenu.Spells[_]["Draw".._]:Value()) then			
				dArrow(myHero.pos,i.safe,3,ARGB(255,0,255,0))
		end
		if EMenu.Draws.DevOpt:Value() then
			DrawCircle(self:Position(),50,1,20,GoS.Blue)
		end
end

function SLEvade:Dodge(_,i)
				--DashP = Dash - Position, DashS = Dash - Self, DashT = Dash - Targeted, SpellShieldS = SpellShield - Self, SpellShieldT = SpellShield - Targeted, WindWallP = WindWall - Position, 
	if EMenu.Keys.DD:Value() then return end
	if myHero.isSpellShielded then return end
	if (i.safe and ((not self.DodgeOnlyDangerous and (i.debug or EMenu.d:Value() <= EMenu.Spells[_]["d".._]:Value())) or (self.DodgeOnlyDangerous and (i.debug or EMenu.Spells[_]["IsD".._]:Value()))) and (i.debug or EMenu.Spells[_]["Dodge".._]:Value()) and (i.debug or GetPercentHP(myHero) <= EMenu.Spells[_]["hp".._]:Value())) then
		if self.asd == true then 
			DisableHoldPosition(true)
			DisableAll(true) 
		else 
			DisableHoldPosition(false)
			DisableAll(false) 
		end
		MoveToXYZ(i.safe)
			if (i.debug or EMenu.Spells[_]["Dashes".._]:Value()) then
				for op = 0,3 do
					if self.EvadeSpells[GetObjectName(myHero)] and self.EvadeSpells[GetObjectName(myHero)][op] and EMenu.EvadeSpells[self.EvadeSpells[GetObjectName(myHero)][op].name]["Dodge"..self.EvadeSpells[GetObjectName(myHero)][op].name]:Value() and self.EvadeSpells[GetObjectName(myHero)][op].evadeType and self.EvadeSpells[GetObjectName(myHero)][op].spellKey and (i.debug or EMenu.Spells[_]["d".._]:Value() >= EMenu.EvadeSpells[self.EvadeSpells[GetObjectName(myHero)][op].name]["d"..self.EvadeSpells[GetObjectName(myHero)][op].name]:Value()) then 
						if i.uDodge == true and self.usp == false and self.ut == false then
							if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "DashP" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
									self.ues = true
									CastSkillShot(self.EvadeSpells[GetObjectName(myHero)][op].spellKey, i.safe)
								else
									self.ues = false
							end	
							-- if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "DashT" then--logic needed
							-- end
							if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "WindWallP" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
									self.ues = true
									CastSkillShot(self.EvadeSpells[GetObjectName(myHero)][op].spellKey, myHero.pos + (i.p.startPos - myHero.pos)*50)
								else
									self.ues = false
							end		
							if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "SpellShieldS" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
									self.ues = true
									DelayAction(function()
										CastSpell(self.EvadeSpells[GetObjectName(myHero)][op].spellKey)
									end,i.spell.delay + GetDistance(myHero,i.p.startPos) / i.spell.speed*.75*.001)
								else
									self.ues = false
							end
							if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "SpellShieldT" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then --logic needed
									self.ues = true
									DelayAction(function()
										CastTargetSpell(myHero,self.EvadeSpells[GetObjectName(myHero)][op].spellKey)
									end,i.spell.delay + GetDistance(myHero,i.p.startPos) / i.spell.speed*.75*.001)
								else
										self.ues = false
							end
							if self.EvadeSpells[GetObjectName(myHero)][op].evadeType == "DashS" and CanUseSpell(myHero, self.EvadeSpells[GetObjectName(myHero)][op].spellKey) == READY then
									self.ues = true
									CastSpell(self.EvadeSpells[GetObjectName(myHero)][op].spellKey)
								else
									self.ues = false
							end
						end
					end
				if self.Flash and Ready(self.Flash) and i.uDodge == true and EMenu.EvadeSpells.Flash.DodgeFlash:Value() and (i.debug or EMenu.Spells[_]["d".._]:Value() >= EMenu.EvadeSpells.Flash.dFlash:Value()) and self.ues == false and self.ut == false then
					self.usp = true
					CastSkillShot(self.Flash, i.safe)
				else
					self.usp = false
				end		
				for item,c in pairs(self.SI) do
					if c.State and Ready(GetItemSlot(myHero,item)) and EMenu.invulnerable[c.Name]["Dodge"..c.Name]:Value() and i.uDodge == false and GetPercentHP(myHero) <= EMenu.invulnerable[c.Name]["hp"..c.Name]:Value() and (i.debug or EMenu.Spells[_]["d".._]:Value() >= EMenu.invulnerable[c.Name]["d"..c.Name]:Value()) and self.ues == false and self.usp == false then
						self.ut = true
						DelayAction(function()
							CastSpell(GetItemSlot(myHero,item))
						end,i.spell.delay + GetDistance(myHero,i.p.startPos) / i.spell.speed*.75*.001)
					else
						self.ut = false
					end
				end
				for item,c in pairs(self.D) do
					if c.State and Ready(GetItemSlot(myHero,item)) and EMenu.EvadeSpells[c.Name]["Dodge"..c.Name]:Value() and i.uDodge == true and GetPercentHP(myHero) <= EMenu.EvadeSpells[c.Name]["hp"..c.Name]:Value() and (i.debug or EMenu.Spells[_]["d".._]:Value() >= EMenu.EvadeSpells[c.Name]["d"..c.Name]:Value()) and self.ues == false and self.usp == false then
						self.ut = true
						CastSkillShot(GetItemSlot(myHero,item), i.safe)
					else
						self.ut = false
					end
				end
			end
		end
	else
		DisableHoldPosition(false)
		DisableAll(false)
	end
end

function SLEvade:BlockMov(order)
	for _,i in pairs(self.obj) do
		if order.flag ~= 3 and order.position then
			if i.jp and i.spell.type == "Line" then
				if (GetDistance(order.position,i.jp) < ((i.spell.radius + myHero.boundingRadius)*1.1)) and not i.safe then
					BlockOrder()
				end
			elseif i.p and i.spell.type == "Circle" then
				if (GetDistance(order.position,i.p.endPos) < ((i.spell.radius + myHero.boundingRadius)*1.1)) and not i.safe then
					BlockOrder()
				end
			elseif i.jp and i.spell.type == "Rectangle" then
				if (GetDistance(order.position,i.jp) < ((i.spell.radius + myHero.boundingRadius)*1.1)) and not i.safe then
					BlockOrder()
				end
			elseif i.jp and i.spell.type == "Cone" then
				if (GetDistance(order.position,i.jp) < ((i.spell.radius + myHero.boundingRadius)*1.1)) and not i.safe then
					BlockOrder()
				end
			elseif i.jp and i.spell.type == "Return" then
				if (GetDistance(order.position,i.jp) < ((i.spell.radius + myHero.boundingRadius)*1.1)) and not i.safe then
					BlockOrder()
				end
			elseif i.jp and i.spell.type == "follow" then
				if (GetDistance(order.position,i.jp) < ((i.spell.radius + myHero.boundingRadius)*1.1)) and not i.safe then
					BlockOrder()
				end
			end
		end
	end
end

function SLEvade:CreateObject(obj)
	-- if obj and obj.isSpell and obj.spellOwner.isMe and obj.spellOwner.team == MINION_ALLY then
	if obj and obj.isSpell and obj.spellOwner.isHero and obj.spellOwner.team == MINION_ENEMY then
		if EMenu.Draws.DevOpt:Value() then
			print(obj.spellName)
		end
		for _,l in pairs(self.Spells) do
			if not self.obj[obj.spellName] and self.Spells[obj.spellName] and EMenu.Spells[obj.spellName] and EMenu.d:Value() <= EMenu.Spells[obj.spellName]["d"..obj.spellName]:Value() and (l.proj == obj.spellName or _ == obj.spellName or obj.spellName:lower():find(_:lower()) or obj.spellName:lower():find(l.proj:lower())) then
				if not self.obj[obj.spellName] then self.obj[obj.spellName] = {} end
				self.obj[obj.spellName].o = obj
				self.obj[obj.spellName].caster = obj.spellOwner
				self.obj[obj.spellName].mpos = nil
				self.obj[obj.spellName].uDodge = nil
				self.obj[obj.spellName].startTime = os.clock()
				self.obj[obj.spellName].spell = l
			end
		end
	end
	if (obj.spellName == "YasuoWMovingWallR" or obj.spellName == "YasuoWMovingWallL" or obj.spellName == "YasuoWMovingWallMisVis") and obj and obj.isSpell and obj.spellOwner.isHero and obj.spellOwner.team == myHero.team then
		if not self.YasuoWall[obj.spellName] then self.YasuoWall[obj.spellName] = {} end
		self.YasuoWall[obj.spellName].obj = obj
	end
end

function SLEvade:Detection(unit,spellProc)
	-- if unit and unit.isMe and unit.team == MINION_ALLY then
	if unit and unit.isHero and unit.team == MINION_ENEMY then
		if EMenu.Draws.DevOpt:Value() then
			print(spellProc.name)
		end
		for _,l in pairs(self.Spells) do
			if not self.obj[spellProc.name] and self.Spells[spellProc.name] and EMenu.Spells[spellProc.name] and EMenu.d:Value() <= EMenu.Spells[spellProc.name]["d"..spellProc.name]:Value() and _ == spellProc.name then
				if not self.obj[spellProc.name] then self.obj[spellProc.name] = {} end
				self.obj[spellProc.name].p = spellProc
				self.obj[spellProc.name].spell = l
				self.obj[spellProc.name].caster = unit
				self.obj[spellProc.name].mpos = nil
				self.obj[spellProc.name].uDodge = nil
				self.obj[spellProc.name].startTime = os.clock()+l.delay
				self.obj[spellProc.name].TarE = (Vector(spellProc.endPos) - Vector(unit.pos)):normalized()*l.range
				if l.killTime and l.type == "Circle" then
					DelayAction(function() self.obj[spellProc.name] = nil end, l.killTime + GetDistance(unit,spellProc.endPos)/l.speed + l.delay)
				elseif l.killTime > 0 and l.type ~= "Circle" then
					DelayAction(function() self.obj[spellProc.name] = nil end, l.killTime + 1.3*GetDistance(myHero.pos,spellProc.startPos)/l.speed+l.delay)
				else
					DelayAction(function() self.obj[spellProc.name] = nil end, l.range/l.speed + l.delay/2)
				end
			elseif l.killName == spellProc.name then
				self.obj[_] = nil				
			end
		end
	end
end

function SLEvade:DeleteObject(obj)
	if obj and obj.isSpell and self.obj[obj.spellName] and self.Spells[obj.spellName].type ~= "Circle" then
			self.obj[obj.spellName] = nil
	end	
	if (obj.spellName == "YasuoWMovingWallR" or obj.spellName == "YasuoWMovingWallL" or obj.spellName == "YasuoWMovingWallMisVis") and obj and obj.isSpell and obj.spellOwner.isHero and obj.spellOwner.team == myHero.team then
		self.YasuoWall[obj.spellName] = nil
	end
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
