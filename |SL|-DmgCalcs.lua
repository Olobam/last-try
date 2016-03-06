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
