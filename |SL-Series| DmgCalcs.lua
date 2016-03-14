
--Garen:
	self.Dmg = {
	[0] = function () return 25 * GetCastLevel(myHero,0) + 5 + GetBonusDmg(myHero) * .4 end,
	[3] = function (unit) return 174 * GetCastLevel(myHero,_R) + ((GetMaxHP(unit) - GetCurrentHP(unit)) * (0.219 + 0.067 * GetCastLevel(myHero, _R))) end,
	}
--DrMundo
	self.Dmg = {
	[0] = function (unit) return (2.5 * GetCastLevel(myHero,0) + 10) * (GetCurrentHP(unit)/25) end,
	}
--Leona
	self.Dmg = {
	[0] = function () return 30 * GetCastLevel(myHero,0) + 10 + GetBonusAP(myHero) * .3 end,
	[2] = function () return 40 * GetCastLevel(myHero,2) + 20 + GetBonusAP(myHero) * .4 end,
	[3] = function () return 100 * GetCastLevel(myHero,3) + 50 + GetBonusAP(myHero) * .8 end,
	}	
--Ezreal
	self.Dmg = {
	[0] = function () return 20 * GetCastLevel(myHero,0) + 15 + GetBonusDmg(myHero) * 1.1 + GetBonusAP(myHero) * .4 end,
	[1] = function () return 45 * GetCastLevel(myHero,1) + 25 + GetBonusDmg(myHero) * 1.1 + GetBonusAP(myHero) * .8 end,
	[2] = function () return 50 * GetCastLevel(myHero,2) + 25 + GetBonusDmg(myHero) * .5  + GetBonusAP(myHero) * .75 end,
	[3] = function () return 150 * GetCastLevel(myHero,3) + 200 + GetBonusDmg(myHero) + GetBonusAP(myHero) * .9 end,
	}
--Lux
	self.Dmg = {
	[-1] = function () return 10 + GetLevel(myHero) + GetBonusAP(myHero) * .2 end,
	[0] = function () return 50 * GetCastLevel(myHero,0) + 10 + GetBonusAP(myHero) * .7 end,
	[2] = function () return 50 * GetCastLevel(myHero,2) + 10 + GetBonusAP(myHero) * .6 end,
	[3] = function () return 100 * GetCastLevel(myHero,3) + 200 + GetBonusAP(myHero) * .75 end,
	}
--Rumble
	self.Dmg = {
	[0] = function () return 5 * GetCastLevel(myHero,0) + 1.25 + GetBonusAP(myHero) * 8.35 end, -- if GetPercentMP(myHero) > 50 then 7.5 * GetCastLevel(myHero,0) + 9.4 + GetBonusAP(myHero) * 12.5 end
	[2] = function () return 25 * GetCastLevel(myHero,2) + 20 + GetBonusAP(myHero) * .4 end, -- if GetPercentMP(myHero) > 50 then 37.5 * GetCastLevel(myHero,2) + 60 + GetBonusAP(myHero) * .6 end
	[3] = function () return 55 * GetCastLevel(myHero,3) + 75 + GetBonusAP(myHero) * .3 end,
	}	
--Swain
	self.Dmg = {
	[0] = function () return 15 * GetCastLevel(myHero,0) + 10 + GetBonusAP(myHero) * .3 end,
	[1] = function () return 40 * GetCastLevel(myHero,2) + 40 + GetBonusAP(myHero) * .7 end, 
	[2] = function () return 34.35 * GetCastLevel(myHero,2) + 12.30 + GetBonusAP(myHero) * (84 + 2.4 * GetCastLevel(myHero,2)) end
	[3] = function () return 20 * GetCastLevel(myHero,3) + 30 + GetBonusAP(myHero) * .2 end,
	}
--Thresh
	self.Dmg = {
	[0] = function () return 40 * GetCastLevel(myHero,0) + 40 + GetBonusAP(myHero) * .5 end,
	[2] = function () return 30 * GetCastLevel(myHero,2) + 35 + GetBonusAP(myHero) * .7 end, 
	[3] = function () return 150 * GetCastLevel(myHero,3) + 100 + GetBonusAP(myHero) end,
	}
--Poppy
	self.Dmg = {
	[0] = function () return 25 * GetCastLevel(myHero,0) + 15 + GetBonusDmg(myHero) * .8 end,
	[2] = function () return 20 * GetCastLevel(myHero,2) + 30 + GetBonusDmg(myHero) * .5 end, 
	[3] = function () return 100 * GetCastLevel(myHero,3) + 100 + GetBonusDmg(myHero) * .9 end,
	}
--Nami
	self.Dmg = {
	[0] = function () return 55 * GetCastLevel(myHero,0) + 20 + GetBonusAP(myHero) * .5 end,
	[2] = function () return 40 * GetCastLevel(myHero,2) + 30 + GetBonusAP(myHero) * .5 end, 
	[3] = function () return 100 * GetCastLevel(myHero,3) + 50 + GetBonusAP(myHero) * .6 end,
	}
--Corki
	self.Dmg = {
	[0] = function () return 45 * GetCastLevel(myHero,0) + 25 + GetBonusDmg(myHero) * .5 + GetBonusAP(myHero) * .5 end,
	[1] = function () return 15 * GetCastLevel(myHero,1) + 15 + GetBonusAP(myHero) * .2 end,
	[2] = function () return 6 * GetCastLevel(myHero,2) + 4 + GetBonusDmg(myHero) * .2 end, 
	[3] = function () return 30 * GetCastLevel(myHero,3) + 70 + GetBonusDmg(myHero) *  + GetBonusAP(myHero) * .3 end,
	}
--KogMaw
	self.Dmg = {
	[0] = function () return 50 * GetCastLevel(myHero,0) + 30 + GetBonusAP(myHero) * .5 end,
	[2] = function () return 50 * GetCastLevel(myHero,2) + 10 + GetBonusAP(myHero) * .7 end, 
	[3] = function () return 40 * GetCastLevel(myHero,3) + 30 + GetBonusDmg(myHero) * .65 + GetBonusAP(myHero) * .25 end, --if GetPercentHP(unit) < 50 then CalcDamage(myHero,unit,0,self.Dmg[3]()*2) elseif GetPercentHP(unit) < 25 then CalcDamage(myHero,unit,0,self.Dmg[3]()*3)
	}
--Nasus
	self.Dmg = {
	[0] = function () return 20*GetCastLevel(myHero,1) + 10 + GetBaseDamage(myHero) + GetBuffData(myHero,"nasusqstacks").Stacks + 15 end,
	[2] = function () return 40 * GetCastLevel(myHero,2) + 15 + GetBonusAP(myHero) * .6 end, 
	[3] = function (unit) return (1 * GetCastLevel(myHero,3) + 2 + GetBonusAP(myHero) * 0.01) * GetMaxHP(unit) end,
	}
