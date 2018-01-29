local SLUtility = 0.13
local SLUPatchnew = nil
local Updater = true

require 'OpenPredict'

local charName = myHero.charName

Callback.Add("Load", function()	
	SLUtilityUpdater()
	Initi()
	
	PrintChat("<font color=\"#fd8b12\"><b>["..SLUPatchnew.."] [SL-Utility] v.: "..SLUtility.." - <font color=\"#F2EE00\"> Loaded </b></font>")
	
	if SLU.Load.LA:Value() then
		Activator()
	end
	if SLU.Load.LAL:Value() then
		AutoLevel()
	end
   SLOrbc()
end)


class 'Initi'

function Initi:__init()

	SLU:Menu("Load", "|SL| Loader")
	SLU.Load:Boolean("LA", "Load Activator", true)
	SLU.Load:Info("as^dasc", "")
	SLU.Load:Boolean("LAL", "Load AutoLevel", true)
	SLU.Load:Info("0.3", "")
	SLU.Load:Info("0.4.", "You will have to press 2f6")
	SLU.Load:Info("0.5.", "to apply the changes")
	
	SLU:Menu("Activator", "|SL| Activator")
	M = SLU["Activator"]
	
end


class 'SLOrbc'

function SLOrbc:__init()
	SLU:Menu("SLO","|SL| OrbSettings")
	SLU.SLO:KeyBinding("Combom", "Combo", string.byte(" "), false)
	SLU.SLO:KeyBinding("Harassm", "Harass", string.byte("C"), false)
	SLU.SLO:KeyBinding("LaneClearm", "LaneClear", string.byte("V"), false)
	SLU.SLO:KeyBinding("LastHitm", "LastHit", string.byte("X"), false)
	
	Callback.Add("Tick",function() 
		if 		SLU.SLO.Combom:Value() then Mode = "Combo" 
		elseif 	SLU.SLO.Harassm:Value() then Mode = "Harass" 
		elseif 	SLU.SLO.LaneClearm:Value() then Mode = "LaneClear" 
		elseif 	SLU.SLO.LastHitm:Value() then Mode = "LastHit" 
		else Mode = nil 
		end
	end)
	
end

class 'AutoLevel'

function AutoLevel:__init()
	SLU:SubMenu(charName.."AL", "|SL| Auto Level")
	SLU[charName.."AL"]:Boolean("aL", "Use AutoLvl", false)
	SLU[charName.."AL"]:DropDown("aLS", "AutoLvL", 1, {"Q-W-E","Q-E-W","W-Q-E","W-E-Q","E-Q-W","E-W-Q"})
	SLU[charName.."AL"]:Slider("sL", "Start AutoLvl with LvL x", 4, 1, 18, 1)
	SLU[charName.."AL"]:Boolean("hL", "Humanize LvLUP", true)
	SLU[charName.."AL"]:Slider("hT", "Humanize min delay", .5, 0, 1, .1)
	SLU[charName.."AL"]:Slider("hF", "Humanize time frame", .2, 0, .5, .1)
	
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
	if SLU[charName.."AL"].aL:Value() and GetLevelPoints(myHero) >= 1 and GetLevel(myHero) >= SLU[charName.."AL"].sL:Value() then
		if SLU[charName.."AL"].hL:Value() then
			DelayAction(function() LevelSpell(self.lTable[SLU[charName.."AL"].aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]or nil) end, math.random(SLU[charName.."AL"].hT:Value(),SLU[charName.."AL"].hT:Value()+SLU[charName.."AL"].hF:Value()))
		else
			LevelSpell(self.lTable[SLU[charName.."AL"].aLS:Value()][GetLevel(myHero)-GetLevelPoints(myHero)+1]or nil)
		end
	end
end



--Activator
class 'Activator'

function Activator:__init()

	self.ShopPos = nil
	self.badPot = false
	self.cc = {}
	Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
	Heal = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerheal") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerheal") and SUMMONER_2 or nil))
	Snowball = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonersnowball") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonersnowball") and SUMMONER_2 or nil))
	Barrier = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerbarrier") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerbarrier") and SUMMONER_2 or nil))
	
	Snowballd = { delay = 0.25, range = 1600, speed = 1200, width = 50 }
	
	self.CCType = { 
	[5] = "Stun", 
	[8] = "Taunt", 
	[11] = "Snare", 
	[21] = "Fear", 
	[22] = "Charm", 
	[24] = "Suppression",
	}
	
	
	self.PAC = {	--PointAndClick
	[3144] = {Name = "Cutlass", Range = 550},
	[3153] = {Name = "BotrK", Range = 550},
	[3146] = {Name = "Gunblade", Range = 700},	
	}
	
	self.RS = {		--RangeSelfcast
	[3142] = {Name = "Ghostblade", Range = 700},
	[3800] = {Name = "Righteous Glory", Range = 700},
	[3092] = {Name = "Frost Queen", Range = 700},
	[3143] = {Name = "Randuins", Range = 500},
	[3069] = {Name = "Talisman", Range = 700},
	}
	
	self.AA = {		--AAReset
	[3077] = {Name = "Tiamat"},
	[3074] = {Name = "Ravenous Hydra"},
	[3748] = {Name = "Titanic Hydra"},
	}
	
	self.CC = {		--QSS
	[3140] = {Name = "QSS"},
	[3137] = {Name = "Dervish Blade"},
	[3139] = {Name = "Mercurial Scimitar"},
	[3222] = {Name = "Crucible", Allies = true},
	}
	
	self.Da = { --dash
	[3152] = {Name = "Protobelt"}
	}
	
	self.Sks = { --skillshot
	[3030] = {Name = "Hextech GLP 800"}
	}
	
	self.SU = {		--Shield Units
	[3190] = {Name = "Locket", Range = 600},
	[3401] = {Name = "Face of the Mountain", Range = 600},
	}
	
	self.HP = {		--HealthPots
	[2003] = {Name = "Health Potion", Stack = false},
	[2031] = {Name = "Refillable Potion", Stack = true},
	[2032] = {Name = "Hunters Potion", Stack = true},
	[2033] = {Name = "Corruption Potion", Stack = true},
	}
	
	--self.CP 
	
	self.SI = {		--Stasis
	--[3157] = {Name = "Hourglass"},
	--[3090] = {Name = "Wooglets"},
	}
	
	M:Info("xxx","Items appear here as you buy")
	
	M:SubMenu("Sum", "Summoners")
	if Ignite then
	M.Sum:Menu("ign", "Ignite")
	M.Sum.ign:Boolean("enable","Enable Ignite", true)
	end
	if Heal then 
	M.Sum:Menu("Heal", "Heal")
	M.Sum.Heal:Boolean("healme","Heal myself", true)
	M.Sum.Heal:Boolean("healally", "Heal ally", true)
	M.Sum.Heal:Slider("allyHP", "Ally HP to heal him", 8, 1, 100, 2)
	M.Sum.Heal:Slider("myHP", "my HP to heal myself", 8, 1, 100, 2)
	end
	if Snowball then
	M.Sum:Menu("SB", "Snowball")
	M.Sum.SB:Boolean("enable", "Enable Snowball", false)
	M.Sum.SB:Slider("h", "HitChance", 45, 0, 100, 1)
	end
	if Barrier then
	M.Sum:Menu("Barrier", "Barrier")
	M.Sum.Barrier:Boolean("enable","Use Barrier", true)
	M.Sum.Barrier:Slider("myHP", "my HP to use Barrier", 8, 1, 100, 2)
	end
	
	
	Callback.Add("Tick", function() self:Tickpx() end)
	Callback.Add("UpdateBuff", function(unit, buff) self:UBuff(unit, buff) end)
	Callback.Add("RemoveBuff", function(unit, buff) self:RBuff(unit, buff) end)
	Callback.Add("CreateObj", function (Object) self:Shop(Object) end)
	Callback.Add("ProcessSpellComplete", function (unit, spellProc) self:SpellsComplete(unit, spellProc) end)
end

function Activator:Tickpx()
	self:Check()
	if myHero.dead then return end
	self:Use(GetCurrentTarget())
	if Ignite then 
		self:Ignite() 
	end
	if Heal then 
		self:Heal() 
	end
	if Snowball then 
		self:Snowball() 
	end
	if Barrier then 
		self:Barrier() 
	end
end	

function Activator:Shop(Object)
	if GetObjectBaseName(Object):lower():find("shop") and GetDistance(Object,myHero)<2000 then
		self.ShopPos = GetOrigin(Object)
	end
end

function Activator:Check()
	--print(self.badPot)
	if (not self.ShopPos or GetDistance(myHero,self.ShopPos) <= 1500) or myHero.dead then
		for i,c in pairs(self.PAC) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u","Use "..c.Name,true)
					M[c.Name]:Slider("hp","%EnemyHp to use", 100, 10, 100, 5)
				end
				c.State = true
			else
				c.State = false
			end
		end
		
		for i,c in pairs(self.RS) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u","Use "..c.Name,true)
					M[c.Name]:Slider("r","Range to use", c.Range, 200, 1500, 50)
					M[c.Name]:Slider("hp","%EnemyHp to use", 100, 10, 100, 5)
				end
				c.State = true
			else
				c.State = false
			end
		end
		
		for i,c in pairs(self.CC) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u","Use "..c.Name,true)
					for n,m in pairs(self.CCType) do
						M[c.Name]:Boolean("i"..n,"Cleanse "..m, true)
					end
					if c.Allies then
						for _,l in pairs(GetAllyHeroes()) do
							M[c.Name]:Boolean(GetObjectName(l),"Cleanse for "..GetObjectName(l), true)
						end
					end
				end
				c.State = true
			else
				c.State = false
			end
		end
		
		for i,c in pairs(self.AA) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u","Use "..c.Name,true)
					M[c.Name]:Slider("hp","%EnemyHp to use", 100, 10, 100, 5)
				end
				c.State = true
			else
				c.State = false
			end
		end
		
		for i,c in pairs(self.Da) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u","Use "..c.Name,true)
					M[c.Name]:Slider("hp","%EnemyHp to use", 100, 10, 100, 5)
					M[c.Name]:DropDown("m", "Mode", 2, {"Mousepos","Sideways","Target"})
				end
				c.State = true
			else
				c.State = false
			end
		end
		
		for i,c in pairs(self.Sks) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u","Use "..c.Name,true)
					M[c.Name]:Slider("hp","%EnemyHp to use", 100, 10, 100, 5)
				end
				c.State = true
			else
				c.State = false
			end
		end
		
		for i,c in pairs(self.SU) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u","Use "..c.Name,true)
					M[c.Name]:Slider("hp","Use at % HP", 10, 2, 80, 2)
					M[c.Name]:Boolean("self","Shield self" ,true)
					DelayAction(function()
						for _,l in pairs(GetAllyHeroes()) do
							M[c.Name]:Boolean(GetObjectName(l),"Shield "..GetObjectName(l), true)
						end
					end,.001)
				end
				c.State = true
			else
				c.State = false
			end
		end
		
		for i,c in pairs(self.HP) do
			if GetItemSlot(myHero,i)>0 then
				if not c.State and not M[c.Name] then
					M:Menu(c.Name,c.Name)
					M[c.Name]:Boolean("u", "Use "..c.Name,true)
					M[c.Name]:Slider("hp","Use at % HP", 10, 2, 80, 2)
				end
				c.State = true
			else
				c.State = false
			end
		end
	end
end

function Activator:Use(target)
	if Mode == "Combo" then
		for i,c in pairs(self.PAC) do
			if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and ValidTarget(target,c.Range) and GetPercentHP(target) <= M[c.Name].hp:Value() then
				CastTargetSpell(target,GetItemSlot(myHero,i))
			end
		end
		for i,c in pairs(self.RS) do
			if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and ValidTarget(target,M[c.Name].r:Value()) and GetPercentHP(target) <= M[c.Name].hp:Value() then
				CastSpell(GetItemSlot(myHero,i))
			end
		end
	end
	for i,c in pairs(self.SU) do
		if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() then
			if M[c.Name].self:Value() and GetPercentHP(myHero) <= M[c.Name].hp:Value() and EnemiesAround(myHero,700)>=1 then
				CastSpell(GetItemSlot(myHero,i))
			else
				for _,n in pairs(GetAllyHeroes()) do
					if M[c.Name][GetObjectName(n)] and M[c.Name][GetObjectName(n)]:Value() and GetPercentHP(n) <= M[c.Name].hp:Value() and EnemiesAround(n,700)>=1 and GetDistance(myHero,n)<600 then
						CastTargetSpell(n,(GetItemSlot(myHero,i)))
					end
				end
			end
		end
	end
	for i,c in pairs(self.Sks) do
		if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and ValidTarget(target,c.Range) and GetPercentHP(target) <= M[c.Name].hp:Value() then
			CastSkillShot(GetItemSlot(myHero,i),GetOrigin(target))
		end
	end
	for i,c in pairs(self.Da) do
		if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and ValidTarget(target,c.Range) and GetPercentHP(target) <= M[c.Name].hp:Value() and M[c.Name].m:Value() == 1 then
			CastSkillShot(GetItemSlot(myHero,i),GetMousePos())
		elseif c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and ValidTarget(target,c.Range) and GetPercentHP(target) <= M[c.Name].hp:Value() and M[c.Name].m:Value() == 2 then
			local position = Vector(target) - (Vector(target) - Vector(myHero)):perpendicular():normalized() * ( GetDistance(myHero,target) * 1.2 )
			CastSkillShot(GetItemSlot(myHero,i),position)
		elseif c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and ValidTarget(target,c.Range) and GetPercentHP(target) <= M[c.Name].hp:Value() and M[c.Name].m:Value() == 3 then
			CastSkillShot(GetItemSlot(myHero,i),GetOrigin(target))
		end
	end
	for i,c in pairs(self.HP) do
		if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and GetPercentHP(myHero) <= M[c.Name].hp:Value() and (not c.Stack or GetItemAmmo(myHero,GetItemSlot(myHero,i))>=1) and not self.badPot then
			CastSpell(GetItemSlot(myHero,i))
		end
	end
	for i,c in pairs(self.CC) do
		if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() then
			if c.Allies then 
				for _,n in pairs(GetAllyHeroes()) do
					if self.cc[GetObjectName(n)] and GetDistance(myHero,n)<600 and M[c.Name][GetObjectName(n)]:Value() then
						CastTargetSpell(n,GetItemSlot(myHero,i))
					end
				end
			elseif self.cc[GetObjectName(myHero)] then
				CastSpell(GetItemSlot(myHero,i))
			end				
		end
	end
end

function Activator:Ignite()
  for _,k in pairs(GetEnemyHeroes()) do
	if M.Sum.ign.enable:Value() and IsReady(Ignite) and not k.dead then
  		if 20*GetLevel(myHero)+50 > GetCurrentHP(k)+GetHPRegen(k)*3 and ValidTarget(k, 600) then
			CastTargetSpell(k, Ignite)
		end
	end
  end
end

function Activator:Heal()
		if IsReady(Heal) and M.Sum.Heal.healme:Value() and GetPercentHP(myHero) <= M.Sum.Heal.myHP:Value() and EnemiesAround(GetOrigin(myHero), 675) >= 1 and not myHero.dead then
			CastSpell(Heal)
		end
	for _,a in pairs(GetAllyHeroes()) do
		if a and IsReady(Heal) and M.Sum.Heal.healally:Value() and GetPercentHP(a) <= M.Sum.Heal.allyHP:Value() and EnemiesAround(GetOrigin(myHero), 675) >= 1 and GetDistance(myHero,a) < 675 and not a.dead then
			CastSpell(Heal)
		end
	end
end

function Activator:Snowball()
	for _,unit in pairs(GetEnemyHeroes()) do
		local Pred = GetPrediction(unit, Snowballd)
		if IsReady(Snowball) and M.Sum.SB.enable:Value() and Pred and Pred.hitChance >= M.Sum.SB.h:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < Snowballd.range and not unit.dead then
			CastSkillShot(Snowball,Pred.castPos)
		end
	end
end

function Activator:Barrier()
	if IsReady(Barrier) and M.Sum.Barrier.enable:Value() and GetPercentHP(myHero) <= M.Sum.Barrier.myHP:Value() and EnemiesAround(GetOrigin(myHero), 675) >= 1 and not myHero.dead then
		CastSpell(Barrier)
	end
end

function Activator:SpellsComplete(unit, spellProc)
	if unit == myHero and spellProc.name:lower():find("attack") and Mode == "Combo" then
		for i,c in pairs(self.AA) do 
			if c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and GetPercentHP(spellProc.target) <= M[c.Name].hp:Value() then
				CastSpell(GetItemSlot(myHero,i))
				AttackUnit(spellProc.target)
			end
		end
	elseif unit == myHero and spellProc.name:lower():find("recall") then
		self.badPot = true
		DelayAction(function () self.badPot = false end, 15)
	end
end

function Activator:UBuff(unit,buffProc)
	if unit == myHero and buffProc.Name:lower():find("recall") then 
		self.badPot = true
	elseif GetTeam(unit) == MINION_ALLY then
		for i,c in pairs(self.CC) do
			if M[c.Name] and c.State and CanUseSpell(myHero,GetItemSlot(myHero,i)) and M[c.Name].u:Value() and M[c.Name]["i"..buffProc.Type] and M[c.Name]["i"..buffProc.Type]:Value() then
				self.cc[GetObjectName(unit)] = true
			end
		end
	end
	if unit == myHero and buffProc.Name:lower():find("potion") or buffProc.Name:lower():find("crystalflask") then
		self.badPot = true 
		DelayAction(function() self.badPot = false end,
		buffProc.ExpireTime-GetGameTimer())
	end
end

function Activator:RBuff(unit,buffProc)
	if unit == myHero and buffProc.Name:lower():find("recall") and GetDistance(GetOrigin(myHero),self.ShopPos)>1000 then 
		self.badPot = false
	elseif GetTeam(unit) == MINION_ALLY then
		for i,c in pairs(self.CC) do
			if M[c.Name] and M[c.Name].u:Value() and M[c.Name]["i"..buffProc.Type] and M[c.Name]["i"..buffProc.Type]:Value() then
				self.cc[GetObjectName(unit)] = false
			end
		end
	end
end

class 'SLUtilityUpdater'

function SLUtilityUpdater:__init()
	function SLUtilityUpdate(data)
		if not Updater then return end
			if tonumber(data) > SLUtility then
				PrintChat("<font color=\"#fd8b12\"><b>[SL-Utility] - <font color=\"#F2EE00\">New Version found ! "..data.."</b></font>")
				PrintChat("<font color=\"#fd8b12\"><b>[SL-Utility] - <font color=\"#F2EE00\">Downloading Update... Please wait</b></font>")
				DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Utility.lua", SCRIPT_PATH .. "SL-Utility.lua", function() PrintChat("<font color=\"#fd8b12\"><b>[SL-Utility] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return	end)
			else
				PrintChat("<font color=\"#fd8b12\"><b>[SL-Utility] - <font color=\"#F2EE00\">No Updates Found.</b></font>")
			end
	end
 GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Utility.version", SLUtilityUpdate)
end
