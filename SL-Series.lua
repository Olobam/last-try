local SLSeries = 1.15
local SLPatchnew = nil
if GetGameVersion():sub(3,4) >= "10" then
		SLPatchnew = GetGameVersion():sub(1,4)
	else
		SLPatchnew = GetGameVersion():sub(1,3)
end
local AutoUpdater = true

require 'OpenPredict'

local SLSChamps = {	
	["Vayne"] = true,
	["Soraka"] = true,
	["Blitzcrank"] = true,
	["Kalista"] = true,
	["Velkoz"] = true,
	["Nasus"] = true,
	["Jinx"] = true,
	["Aatrox"] = true,
	["Kindred"] = true,
	["Nocturne"] = true,
	["Sivir"] = true,
	["Vladimir"] = true,
}

local Name = GetMyHero()
local ChampName = myHero.charName
local Dmg = {}
local Mode = nil
local SReady = {
	[0] = false,
	[1] = false,
	[2] = false,
	[3] = false,
}

local function GetADHP(unit)
	return GetCurrentHP(unit) + GetDmgShield(unit)
end

local function GetAPHP(unit)
	return GetCurrentHP(unit) + GetDmgShield(unit) + GetMagicShield(unit)
end

local function GetReady()
	for s = 0,3 do 
		if CanUseSpell(myHero,s) == READY then
			SReady[s] = true
		else 
			SReady[s] = false
		end
	end
end 

local t = {_G.MoveToXYZ, _G.AttackUnit, _G.CastSkillShot, _G.CastSkillShot2, _G.CastSkillShot3, _G.HoldPosition, _G.CastSpell, _G.CastTargetSpell}
function Stop(state)
	if state then 
		_G.MoveToXYZ, _G.AttackUnit, _G.CastSkillShot, _G.CastSkillShot2, _G.CastSkillShot3, _G.HoldPosition, _G.CastSpell, _G.CastTargetSpell = function() end, function() end,function() end,function() end,function() end,function() end,function() end,function() end
		BlockF7OrbWalk(true)
		BlockF7Dodge(true)
	else
		_G.MoveToXYZ, _G.AttackUnit, _G.CastSkillShot, _G.CastSkillShot2, _G.CastSkillShot3, _G.HoldPosition, _G.CastSpell, _G.CastTargetSpell = t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8]
		BlockF7OrbWalk(false)
		BlockF7Dodge(false)
	end
end

if SLSChamps[ChampName] then
LoadGOSScript(Base64Decode("ihu3XEtr9s+kW8atZj3RUzgMds4JXne6Kp7us/Gf2FzwnPL7gqmJXT0Ht85GvW5J36HbPqw9WD2GLZPROLOeSx7D4ObBGZDqN8+xA5kiWTyKCi3q8yVCieyoiE2R8jwUqKt1CiYzppSk0eC8qpkzfp3Zms8qu9iPNap+b7zv8lXaOBV2NPH/Gg757PdoBqlmTGTVlVGijNs4FHeGk2sxDHKSAtJP/AwnlerZ14Y3t8E0BWmyhjPnwMN2LmRtyBhnRQcI6TrKqj1lLIo615lB6FnMhuWMue1VEQE4TelM4Z/m0lw2riPOTc21LKMFU3jj1Do3dELv9NL4bkxPU6qOE5NP5L1sBFDBc7rXk83JNXdVaqRLugUMHu7AE/1akdNPIayGlOuWHFSDZnQYYEqxmanm38481CDhc0NdJz3amDuaKElej7DrP7whsghWTveWhd4O62jMgCQc7AQ2sU+5r2/KEa+Ru6PHDBNvhtq80HfK/HiX6XWFUOMAhZa0o2cvLXB3SbNNrSPk7EOoo5fbix2y4FTI5cAE6rsRZYwQ78H70AVD56Fc5h+AzSo4T4gR+dfXgtNTjyQCcuA6y96AG10kasMZLBzZccvanuEvX6fw8k8oLzt2/SFEks/ldPA1tXa/PBk4A7BtCME4hEEKZP7ZmJrTfj51mYIztKwQUhVxGrEBnSjGX9l5Y2dGMi/Zpqg3BKfhItv8IG76e++zyGETTdRf6HDFnPpWH0TD5VuEGOrjraB1DwptSL33wWK3yIdVP8vROiqpPFKgVTp3gqqG+IHcyjBBSwAz+BftHmfuQ9L6yd4mLl+UNiN4Ex1nci0+ZgZj7c4ppZzsUYBJYaIgB3fLxAd0i2RSEWgcOQRWXcwPC48qgkoHns3ygzu3SbwddBJde8WtN7kb14KcQev53YlGxpCFoqKUr21I/rbK2cEaFQbr9FSftMxRU2YbfSApiQok4fA17zuseTSVxMw6lf5nO0Y3SWr54lbZ6g3CEZtdv8x36opxZ9iRnfjxHkbUaLmhC4B3zw5ueys85J4A5wiEXAN43603zyL/kzJvrYXVQI9IHm7twO8a0qgbhWIrmXZ3ZeaEZZRpDrGOXG0qy3pZ6he94ebALnt9pqgOjCjnKLH4no/6P24hvcnp/FWyzMpz6L8eC1SiAlTUHWwVj20C7JtCxQ4K+jfKg7VDeLDFEaLPvILs9FmpnF2iUvmxLfYXvMPBITYdSu4VATu2Lrud8IxQz9k1bmzOxvq7q4y3q4wr3PLfu/Ycm1rCDadxTHCUOtNhbdY01LPGHafyjHCy8y5QGWRHwy2lJt/asNke3h09fKVlmPT/aMfSkBpK/RIOdqoFLX98RVqcCdwvhy6Ebpr+sjLRZieIJEkupCtj6gyawC7lrAlz7k1kKZ948UKExQ71mFrI7VTXBobXgUC+oSPmeUUVKrd+fNwaLqOQc4+0Y2v1qqPue/xL7HIS/2rQLJYgEz3lQ9j+gR7nUEckjecJcBmd6zPX6JxxUlEVepi7xnx0uITgo8xSeeuF0TYChuVIJEzalH0f01WXjwdAOPujvyoiKNlvLJ/upEnTsNBTY1XTp19tYhD/yh4SgFBfy6pVMOWLTOESw3l1wixl9OzM0HrojMquGb2+7QlEw7CBfObhTk1EzjMePmuwEQ9DL7iZRyvJ+4+QTcm2EKrILfl9ZpHdUzoKPuTuAq7cK8czICwENvbKg8R+XFgirvySEphHLT21BcKn5osCxaIrqEmhEoT/sAPYM/b/TEBZUPImFqjY3vpjNZcXBvADcDmDXhuzm9mS6jrpdbosaSCZqoBKgCp0M1ycL41IjnEDbYXIFmxdLWs3xboK/2LffkJeMEkawclVIkoZe+SlXhtt0zp+8zhSn2usCp8hRU40Opb1htPfC02bmntMsDD2JvTqRcqsC1If7f+uxsfDKqIzJweul7RfMJWgFQ1MtmjGScBz+yvkNEvLeiHsHPh4FA18AkRUHkeU7IsoVqkik5sor2xOqSP0/ROtLpM6+wGPVWAsM+5PZ070ztCe4oLn6aahlTj4UJVUtQiCCaE9tFsISdO92ImJ8DaZOTz35W6kRNQzpcaaxaV5c+/rI2fC4STHB6ejy6NaRvpjqeY3e2vMI8gIUzmwnlahN+pAp9bdOjCSSdBIpvyAPhQRGelWmzt2W4dVK7FsZuh6GL7ERlPLwyQayiDKKwbprLOh3tEADdpthiF7tEWrVDoW7Jy5Zww8mwOqpmDcw92HqH0qbcGOyT/L1pEzVVEum/ioIFdqJ3S+9y9a/W+HthN5rF2aDKzGCR5Yylq/IrA0IWSbQdZN+BO0rGfCQvTG7zkl3gOcbk8IIzVCZuU4iZ40cP4Pz2xIcQmA0ynmzveDw/J/sRPosHFK7Z/hbFmY1mq+kvo3leXSf6lkT/Q2JKe/KltYXx5yH6EN2f+Wr6SP87tsE4N1cHc2auV4wyrmLzT91rZ/VsfdJL9O6vO/GRjw5G1f67C0k99/P7tZrCW+ddwkC+KOEdWXPcNJnjgLW2eyjQlyjS2Sf6Lr5+hPhMlRyxBoFK1P2fSbW7/ODU4gNwkASNaPSO9FdTbQhqWfatxmTxLjzbcuJMXBiivTTqGXjtoRlqaOsFLwAPRqcmLECFHf8fR9FRUfRRHvJ13yBjWH2oGpjkpTV1VXxV7CMdxeM9/yoWZBnR10K3JQ+VzCSv0NT/TMDXBwl8SP737EBhIUiPU6ZjFerZeUiDZA2+BnDy7gOLL5h1B3a5sKBsGF63cifZRLiMr/+hzlXcjhlsDoIq6ZOBeAACLMR/7rSqwbXzk5C+uQu3aARVDQHoWEU4RvxElvReqHdFTfRI+TGa4Ky8B5F8+0uODpaEx78+UMokxejghE1hPsy4RyVaJ7FiBraX0DOhKMT4NpoNSOQ7F7+HPoTTnaoHV4he+rjMKELJOEKuYTeC98uZTPhWnpc3zEyncYFEMBJ5gf5Cra77CNXmITxfLnFrrnclEp8rz9kZgPSre1oawQSalsvBVGkuCgt7HSMzalPuKXgSyF+fgdFzItT3QXTYtGmIy9gyAHpTUfXjio9AyqHUbj4trnqg50TU4YAI+oz0egIBd4h2EZ45sLiJSV+WDhNAYmmyfe3kAjtTEEIUX9MxPlC+C8Q1wc9UNcXsjgB/UlrF3WmuA8lMuYyZKu/7INbEJEWeLIEDphE7gOCkyFULnqvMz/qJI5ZHrkqyh4gT3iAvnOMTOU8E7fTqUK0syA5rLZi/leV4tD2vZiuJjqyOyyIrAuR/Mzy0/tseXHNWnfFdiKaJejCSuN2ChTOq9lV1hp/RPXvwZdOnojpQ5/yBWYgysXBaVGqaYZeDrGHzSVrPdDWKrgzQPc/ElSuNDPQ8ZoByef1dPSalqmLehS8SUlak4RBQj0+Cxpc08/Gl2527n5v3KA6SS40k6sHVDNOJ0YpWezunPgbFvDo7jzpkNWHTd+aI/efttvCSFdCoUBspvaGFIqE34RjiizYGoEYR+mbpPp9RnfaU9irV2z2+7dcFzhHJrPBK+NPwYnkfBkUHdZu7p0dMSLHHJrHJi/viDVcFpieS5UkfW0Z0d4lLnHb3wxKMder8QJP8jgKI5MBS875EFSvvD6EmwhSj99mzgyHlVfgrbYjdIjZPPzsqK1WyrcGX7SgLhlmAzu+SH4eg/hZFKgCMEihuHOHIr9aeHtOp8Qs424zapDVVQnj0mwn+lg6aDqImX6f7cilqSG7he+0A5HyE4cFByKZy9PoFKbdmRoas51h9DVSznpDq93CllgWNErsGhCbL8dXQp2il6pLZMaCOC38/wIVQFlaN9HAFpJ4QWMj29fjP9nP08VtsYiXwX9xf9iZyhS3LqHM0tagAcOCixqcdZqumo1n55Ab8lACCdTJI8t8OifgGx2N0uHJ1Iq4qW6zJT+aWbFVQbqcq6s2V2mHQpWsMMM99O8h04uBxMNLLkmMv2+0zS8qGccsFw6xEJj4qa5yc6Hi5FMWhbiiI+IA4VlDiK3b++jpYnefqiQIguvTlekBCQBX8e87Otw1F8BwEole+lYDSE1gxntkPeW+2bwhTTnaoqCyDAvXW8gKjOQZ0hcwLwP9evrSa9oapZ5MHKQ9YffdulJmpF/meUglgkZJ73ZhEHniGN+cVwhtPmS1hYl2b9eV9yJeCfKCuJ1yotZ6N+DrUJJTQbR79UNYkCGOD3S8nfjbHeA85hcH5uptJKDTUzGrv401NZmCXJP+2ud2oDdFMRcYlSgWSRf5kyaFxDrhi1i4r09RYQJbP9ra8q+ZRNvsG1j3wz03wf6kyVF+TGQn0NXc5fyBaOPHP/LOwRVOLPzpqkw3w/LUx2sIXhnZKOVdic43n3NlAQsbQqw3AAfq72Sx/GddLdeLz5itx8JO/9DJLDdSWEhVC6bJcdqcLnCXw3NVCSYiP/GRainKQbHtK98Sa/IFGogL/+mo2GtZrpDSVbyliARg3qhM9aEqyM6wD6Um3ZUCjplC089j2gs2UGXHviizxmSP/71ez/+Hs0OHTPTzDOo+fyJLZCwGnca/rSxKR8nxZjHKHKOEouPekkiLCUEjQfZwL+iBdW+/A9a+Gw7HZa6Ac5fgLfuqmqluD9gaNOicpIlSjutA67WlGv4u44CX8p5W5DODkzzq0vL6PfLmL8ohuJDUEqH0nvuweWjuKamlwB6R4QKirD3oih3gsz4IrhCLGRkp5CO4XT0Ez95/09Isv86McNZ10xht0+FH4KTss3+2hULfujXVxMgyptSej+wyfcbBGR0nX/9rW/rYtLodrk6zcfbqm7jp06gHLLgRN1gLfaJprQu+PiQz0LYNgBWmGNLRLUADuLq3pRMSEIwgbdRFcVjRjf7C2LcqoZzCveSgCCOzw2uxCopbFodDKMlP1KRDspyRkYrYHMQ7sC/NmScA2V2cQtr3PBJOPJp8AaZ11ZcEvlUrSeXupNATQ3zpYjt31VcNht8jk8o3oatXPnNoK4qPWY0ZWzsgDp0q2eKPe9fEk9wpJ6u0Gs9TkEGQEW7pUngwAh19v2ubfJc/fnc7339Ew9cOYw704+tCQWxl3ISdu3Aa88PLZU3hm9Ql4ZuLfrhAEB57mfn2G5yEhRDG67/Z4dV73icHHKslmgGUfkRdGJyXhFvyxe+46T/pa1mTss/UjGHXqstj/QQ0AT36v2UfB8Kpxm6FHlH5f5jP0I6zKkLE6BCxKt2Zi8TW7W7X69KTRE5FWflcOX3yfPIXOrdxUrxxcOMXvDelggJBmcQ5saTICbQYm/+xmYb8yd4dynAPnf8j211DontKxcBroTlS2GwlLtqcFEmCmO0Kfrc9jFecYHGuqn+Hm7dVGII6TkOOAoHGod6IQjX3MYqwgajKSID5ojdn8NTj7/SDY4bzzpKv+JUiYQbw9R81nkiZ4/+Qg362W3TqG3OqS2A5EmoO1zWJw5bEvVC5LmeeblPDnY6NuZg/s2ZSibK6014TmcLcyC+SwSpbrjVy7VShWOxQqK/PzVbu68Y8T0DfIhy72uXIO/RPZAhv9Cy03D9tWrmsdBNwvVLOJ0zRabRpDKhqSwjnYmEQuqOX//DHlRb74Y1+M05BoNvn4yE4NMPnR2dI/3Z5FuEz6KYWiMMS9uDBZI6ZpqjAJz+h/29pGnC3EbzUchWK7Gzel4v5Pfzner+tOKlAnhdKWjtqj5k4DBQIx8dW2ZAVR3+rV9ApajE3l+ojIJMLH+kd+OezpDMWynqwY1OACoBA6z2xQeoW2NhPLZeEfrLxnla7LKfck1twCZWWJlx8/+pqaBA06gl1KQsTmSBtv3rmJkranHwL9cGR3k3np0PWQ=="))
end

Callback.Add("Load", function()	
	Update()
	Init()
	if SLSChamps[ChampName] and SLS.Loader.LC:Value() then
		_G[ChampName]() 
		if SLS.Loader.LDraw:Value() then
			Drawings()
		end
	end
	if SLSChamps[ChampName] then
		PrintChat("<font color=\"#fd8b12\"><b>["..SLPatchnew.."] [SL-Series] v.: "..SLSeries.." - <font color=\"#FFFFFF\">" ..ChampName.." <font color=\"#F2EE00\"> Loaded! </b></font>")
	else
		PrintChat("<font color=\"#fd8b12\"><b>["..SLPatchnew.."] [SL-Series] v.: "..SLSeries.." - <font color=\"#FFFFFF\">" ..ChampName.." <font color=\"#F2EE00\"> is not Supported </b></font>")
	end
	if SLS.Loader.LD:Value() then
		DmgDraw()
	end
	if SLS.Loader.LRS:Value() then
		Recommend()
	end
	SLOrb()
end)   
 
class 'Init'

function Init:__init()
	local AntiGapCloser = {}
	local GapCloser = {}
	local MapPositionGOS = {["Vayne"] = true, ["Poppy"] = true, ["Kalista"] = true, ["Kindred"] = true,}
	
	SLS = MenuConfig("SL-Series", "["..SLPatchnew.."][v.:"..SLSeries.."] SL-Series")
	SLS:Menu("Loader", "|SL| Loader")
	L = SLS["Loader"]
	L:Boolean("LC", "Load Champion", true)
	L:Info("0.1", "")
	L:Boolean("LD", "Load DmgDraw", true)
	L:Info("0.2", "")
	L:Boolean("LDraw", "Load Drawings", true)
	L:Info("0.6xc", "")
	L:Boolean("LRS", "Load Recommended Scripts",true)
	L:Info("xxx", "")
	L:Info("0.7.", "You will have to press 2f6")
	L:Info("0.8.", "to apply the changes")
	
	if L.LC:Value() and SLSChamps[ChampName] then
		SLS:Menu(ChampName, "|SL| "..ChampName) 
		BM = SLS[ChampName] 
		
		if AntiGapCloser[ChampName] == true then 
			BM.M:Menu("AGP", "AntiGapCloser") 
		end
		if GapCloser[ChampName] == true then 
			BM.M:Menu("GC", "GapCloser")
		end
	end
	
	if MapPositionGOS[ChampName] == true and FileExist(COMMON_PATH .. "MapPositionGOS.lua") then
		require 'MapPositionGOS'
	end
end

class 'Recommend'

function Recommend:__init()
	self.RecommendedUtility = {
	[1] = {Name = "Radar Hack", 	Link = "https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/RadarHack.lua",		        Author = "Noddy",	File = "RadarHack"},
	[2] = {Name = "Recall Tracker",	Link = "https://raw.githubusercontent.com/qqwer1/GoS-Lua/master/RecallTracker.lua",	        Author = "Noddy",	File = "RecallTracker"},
	[3] = {Name = "GoSEvade",       Link = "https://raw.githubusercontent.com/KeVuong/GoS/master/Evade.lua",                    Author = "MeoBeo",  File = "Evade"},
	}

	SLS:Menu("Re","|SL| Recommended Scripts")
	SLS.Re:Info("xx.x", "Load : ")
	for n,i in pairs(self.RecommendedUtility) do
		SLS.Re:Boolean("S"..n,"- "..i.Name.." ["..i.Author.."]", false)
	end
	SLS.Re:Info("xxx","2x F6 after download")
	
	for n,i in pairs(self.RecommendedUtility) do
		if SLS.Re["S"..n]:Value() and not pcall (require, i.File) then
			DownloadFileAsync(i.Link, SCRIPT_PATH .. i.File..".lua", function() 
				if pcall (require, i.File) then
					print("|SL| Downloaded "..i.Name.." from "..i.Author.." succesfully.") 
				else
					print("Error downloading, please install manually")
				end
			end)
		elseif SLS.Re["S"..n]:Value() and FileExist(SCRIPT_PATH .. i.File .. ".lua") then
			require(i.File)
			print("|SL| Loaded "..i.Name)
		end
	end
end

class 'SLOrb'

function SLOrb:__init()
	SLS:Menu("SO","|SL| OrbSettings")
	SLS.SO:KeyBinding("Combo", "Combo", string.byte(" "), false)
	SLS.SO:KeyBinding("Harass", "Harass", string.byte("C"), false)
	SLS.SO:KeyBinding("LaneClear", "LaneClear", string.byte("V"), false)
	SLS.SO:KeyBinding("LastHit", "LastHit", string.byte("X"), false)
	
	Callback.Add("Tick",function() 
		if 		SLS.SO.Combo:Value() then Mode = "Combo" 
		elseif 	SLS.SO.Harass:Value() then Mode = "Harass" 
		elseif 	SLS.SO.LaneClear:Value() then Mode = "LaneClear" 
		elseif 	SLS.SO.LastHit:Value() then Mode = "LastHit" 
		else Mode = nil 
		end
	end)
	
end
	
---------------------------------------------------------------------------------------------
-------------------------------------CHAMPS--------------------------------------------------
---------------------------------------------------------------------------------------------


--[[
 __      __                    
 \ \    / /                    
  \ \  / /_ _ _   _ _ __   ___ 
   \ \/ / _` | | | | '_ \ / _ \
    \  / (_| | |_| | | | |  __/
     \/ \__,_|\__, |_| |_|\___|
               __/ |           
              |___/                       
--]]

class 'Vayne'

function Vayne:__init()

	Vayne.Spell = {
	[0] = { range = 300 },
	[1] = { range = 0 },
	[2] = { delay = 0.25, speed = 2000, width = 1, range = 550 },
	[3] = { range = 0 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 5 * GetCastLevel(myHero,0) + 25 + ((GetBaseDamage(myHero) + GetBonusDmg(myHero)) * .5), 0) end,
	[1] = function (unit) return CalcDamage(myHero, unit, (1.5 * GetCastLevel(myHero,1) + 4.5) * (GetMaxHP(unit)/100) , 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 35 * GetCastLevel(myHero,2) + 15 + GetBonusDmg(myHero) * .5, 0) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 20 * GetCastLevel(myHero,3) + 10, 0) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Slider("a", "accuracy", 30, 1, 50, 5)
	BM.C:Slider("pd", "Push distance", 480, 1, 550, 5)	
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	BM.C:Slider("RHP", "myHeroHP ", 75, 1, 100, 5)
	BM.C:Slider("REHP", "EnemyHP ", 65, 1, 100, 5)
	
	BM:Menu("H", "Harass")
	BM.H:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", false)

	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("ProcessSpellComplete", function(unit, spell) self:AAReset(unit, spell) end)
	AntiChannel()
	DelayAction( function ()
	if BM["AC"] then BM.AC:Boolean("E","Use E", true) end
	end,.001)
	
end

function Vayne:AntiChannel(unit,range)
	if BM.AC.E:Value() and range < Vayne.Spell[2].range and SReady[2] then
		CastTargetSpell(unit,2)
	end
end

function Vayne:Tick()
	if myHero.dead then return end
			
	GetReady()
	
	self:KS()
		
	local target = GetCurrentTarget()
	   if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:JungleClear()
		self:LaneClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Vayne:CastE(unit)
	local e = GetPrediction(unit, self.Spell[2])
	local ePos = Vector(e.castPos)
	local c = math.ceil(BM.C.a:Value())
	local cd = math.ceil(BM.C.pd:Value()/c)
	for step = 1, c, 5 do
		local PP = Vector(ePos) + Vector(Vector(ePos) - Vector(myHero)):normalized()*(cd*step)
			
		if MapPosition:inWall(PP) == true then
			CastTargetSpell(unit, 2)
		end		
	end
end

function Vayne:AAReset(unit, spell)
	local ta = spell.target
	if unit == myHero and ta ~= nil and spell.name:lower():find("attack") and SReady[0] then
	  local QPos = Vector(ta) - (Vector(ta) - Vector(myHero)):perpendicular():normalized() * ( GetDistance(myHero,ta) * 1.2 )
	  local QPos2 = Vector(Vector(myHero) - Vector(ta)) + Vector(myHero):normalized() * 75
	  local QPos3 = Vector(ta) + Vector(ta):normalized()
		if Mode == "Combo" and BM.C.Q:Value() and ValidTarget(ta, 825) then
			if BM.C.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.C.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.C.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.C.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif Mode == "Harass" and BM.H.Q:Value() and ValidTarget(ta, 825) then
			if BM.H.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.H.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.H.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.H.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif Mode == "LaneClear" and BM.JC.Q:Value() and GetTeam(ta) == MINION_JUNGLE then
			if BM.JC.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.JC.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.JC.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.JC.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		elseif Mode == "LaneClear" and BM.LC.Q:Value() and GetTeam(ta) == MINION_ENEMY then
			if BM.LC.QL:Value() == 1 and GetDistance(myHero,ta) > 275 then
				CastSkillShot(0, QPos)
			elseif BM.LC.QL:Value() == 1 and GetDistance(myHero,ta) < 275 then
				CastSkillShot(0, QPos2)
			elseif BM.LC.QL:Value() == 1 and GetDistance(myHero,ta) > 650 then
				CastSkillShot(0, QPos3)
			elseif BM.LC.QL:Value() == 2 then
				CastSkillShot(0, GetMousePos())
			end
		end
	end
end

function Vayne:Combo(target)
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		self:CastE(target)
	end
	if SReady[3] and ValidTarget(target, 800) and BM.C.R:Value() and EnemiesAround(myHero,800) >= BM.C.RE:Value() and GetPercentHP(myHero) < BM.C.RHP:Value() and GetPercentHP(target) < BM.C.REHP:Value() then
		CastSpell(3)
	end
end

function Vayne:Harass(target)
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
		self:CastE(target)
	end
end

function Vayne:JungleClear()
 for _,mob in pairs(minionManager.objects) do
	if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() and GetTeam(mob) == MINION_JUNGLE then
		self:CastE(mob)
	end
 end
end

function Vayne:LaneClear()
 for _,minion in pairs(minionManager.objects) do
	if SReady[2] and ValidTarget(minion, self.Spell[2].range) and BM.LC.E:Value() and GetTeam(minion) == MINION_ENEMY then
		self:CastE(minion)
	end
 end
end

function Vayne:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[2] and GetADHP(target) < Dmg[2](target) and ValidTarget(target, self.Spell[2].range) then
			CastTargetSpell(target, 2)
		end
	end
end


--[[
  ____  _ _ _                           _    
 | __ )| (_) |_ _______ _ __ __ _ _ __ | | __
 |  _ \| | | __|_  / __| '__/ _` | '_ \| |/ /
 | |_) | | | |_ / / (__| | | (_| | | | |   < 
 |____/|_|_|\__/___\___|_|  \__,_|_| |_|_|\_\
                                             
--]]

class 'Blitzcrank'

function Blitzcrank:__init()

	Blitzcrank.Spell = {
	[0] = { delay = 0.25, speed = 1800, width = 70, range = 900 },
	[1] = { range = 0 },
	[2] = { range = 0 },
	[3] = { range = 650 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 0, 55 * GetCastLevel(myHero,0) + 25 + GetBonusAP(myHero)) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, (GetBaseDamage(myHero) + GetBonusDmg(myHero)) * 2, 0) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 0, 125 * GetCastLevel(myHero,3) + 125 + GetBonusAP(myHero)) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("EAR", "R hit enemies >= x ", 2, 1, 5, 1)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)
	BM.LC:Boolean("R", "Use R", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	BM.JC:Boolean("R", "Use R", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable","Enable KS", true)
	BM.KS:Boolean("Q", "Use Q", true)
	BM.KS:Boolean("R", "Use R", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	AntiChannel()
	DelayAction( function ()
	if BM["AC"] then
	BM.AC:Boolean("Q","Use Q", true)
	BM.AC:Boolean("R","Use R", true)
	end
	end,.001)
end

function Blitzcrank:Tick()
	if myHero.dead then return end
	
	local target = GetCurrentTarget()
	
	   if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Blitzcrank:AntiChannel(unit,range)
	if BM.AC.Q:Value() and range < 600 and SReady[3] then
		CastSpell(3)
	elseif BM.AC.R:Value() and SReady[0] and range < Blitzcrank.Spell[0].range then
		local Pred = GetPrediction(unit, Blitzcrank.Spell[0])
		if not Pred:mCollision(1) then
			CastSkillShot(0,Pred.castPos)
		end
	end
end

function Blitzcrank:Combo(target)
		if SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.C.Q:Value() then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and not Pred:mCollision(1) and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[1] and ValidTarget(target, 1000) and BM.C.W:Value() and GetDistance(myHero,target) <= 850 and SReady[0] then
			CastSpell(1)
		end
		if SReady[2] and ValidTarget(target, 250) and BM.C.E:Value() then
			CastSpell(2)
		end
		if SReady[3] and ValidTarget(target, GetCastRange(myHero,3)) and EnemiesAround(GetOrigin(myHero), GetCastRange(myHero,3)) >= BM.C.EAR:Value() and BM.C.R:Value() then
			CastSpell(3)
		end
end

function Blitzcrank:Harass(target)
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.H.Q:Value() then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and not Pred:mCollision(1) and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[2] and ValidTarget(target, 300) and BM.H.E:Value() then
			CastSpell(2)
		end 
end

function Blitzcrank:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range) and BM.LC.Q:Value() then
			local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(minion, 300) and BM.LC.E:Value() then
				CastSpell(2)
			end 
			if SReady[3] and ValidTarget(minion, 600) and BM.LC.R:Value() then
				CastSpell(3)
			end
		end
	end
end

function Blitzcrank:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_ENEMY then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
			local Pred = GetPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(mob, 300) and BM.JC.E:Value() then
				CastSpell(2)
			end 
			if SReady[3] and ValidTarget(mob, 600) and BM.JC.R:Value() then
				CastSpell(3)
			end
		end
	end
end

function Blitzcrank:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetAPHP(unit) < Dmg[0](unit) and SReady[0] and ValidTarget(unit, self.Spell[0].range) and BM.KS.Q:Value() then
			local Pred = GetPrediction(unit, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and not Pred:mCollision(1) and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if GetADHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, 300) and BM.KS.E:Value() then
			CastSpell(2)
		end
		if GetAPHP(unit) < Dmg[3](unit) and SReady[3] and ValidTarget(unit, 600) and BM.KS.R:Value() then
			CastSpell(3)
		end
	end
end


--[[
   _____                 _         
  / ____|               | |        
 | (___   ___  _ __ __ _| | ____ _ 
  \___ \ / _ \| '__/ _` | |/ / _` |
  ____) | (_) | | | (_| |   < (_| |
 |_____/ \___/|_|  \__,_|_|\_\__,_|
                                   
--]]


class 'Soraka'

function Soraka:__init()

	Soraka.Spell = {
	[0] = { delay = 0.250, speed = math.huge, width = 235, range = 800 },
	[1] = { range = 550 },
	[2] = { delay = 1.75, speed = math.huge, width = 310, range = 900 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 0, 40 * GetCastLevel(myHero,0) + 30 + GetBonusAP(myHero) * .35 ) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 40 * GetCastLevel(myHero,2) + 30 + GetBonusAP(myHero) * .4 ) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)

	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)

	BM:Menu("AW", "Auto W")
	BM.AW:Boolean("Enable", "Enable Auto W", true)
	BM.AW:Info("5620-", "(myHeroHP) To Heal ally")
	BM.AW:Slider("myHeroHP", "myHeroHP >= X", 5, 1, 100, 10)
	BM.AW:Slider("allyHP", "AllyHP <= X", 85, 1, 100, 10)
	BM.AW:Slider("ATRR", "Ally To Enemy Range", 1500, 500, 3000, 10)	
	
	DelayAction(function()
		for _,i in pairs(GetAllyHeroes()) do
			BM.AW:Boolean("h"..GetObjectName(i), "Heal "..GetObjectName(i))
		end
	end, .001)

	BM:Menu("AR", "Auto R")
	BM.AR:Boolean("Enable", "Enable Auto R", true)
	BM.AR:Info("HealInfo", "(myHeroHP) to Heal me with ult")
	BM.AR:Slider("myHeroHP", "myHeroHP <= X", 8, 1, 100, 10)
	BM.AR:Slider("allyHP", "AllyHP <= X", 8, 1, 100, 10)
    	BM.AR:Slider("ATRR", "Ally To Enemy Range", 1500, 500, 3000, 10)

	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("Q", "Use Q", false)
	BM.KS:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)
	BM.p:Slider("aE", "Adjust E Delay", 1.5, .5, 2, .1)
	
	Callback.Add("Tick", function() self:Tick() end)
	AntiChannel()
	DelayAction( function ()
	if BM["AC"] then BM.AC:Boolean("E","Use E", true) end
	end,.001)
end

function Soraka:AntiChannel(unit,range)
	if SReady[2] and BM.AC.E:Value() and ValidTarget(unit,Soraka.Spell[2].range) then
		CastSkillShot(2,GetOrigin(unit))
	end
end

function Soraka:Tick()
	if myHero.dead then return end
	self.Spell[0].delay = BM.p.aE:Value()
		
	GetReady()
		
	self:KS()
	
	self:AutoW()
		
	self:AutoR()
	
	local Target = GetCurrentTarget()

	if Mode == "Combo" then
		self:Combo(Target)
	elseif Mode == "LaneClear" then
		self:JungleClear()
		self:LaneClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Soraka:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		self.Spell[0].delay = .25 + (GetDistance(myHero,target) / self.Spell[0].range)*.75
		local Pred = GetCircularAOEPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
end

function Soraka:Harass(target)
		if SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.H.Q:Value() then
			self.Spell[0].delay = .25 + (GetDistance(myHero,target) / self.Spell[0].range)*.55
			local Pred = GetCircularAOEPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
		end
		if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
			local Pred = GetCircularAOEPrediction(target, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
	end
end

function Soraka:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetAPHP(unit) < Dmg[0](unit) and SReady[0] and ValidTarget(unit, self.Spell[0].range) and BM.KS.Q:Value() then
			self.Spell[0].delay = .25 + (GetDistance(myHero,target) / self.Spell[0].range)*.55
			local Pred = GetCircularAOEPrediction(unit, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if GetAPHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, self.Spell[2].range) and BM.KS.E:Value() then
			local Pred = GetCircularAOEPrediction(unit, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
	end
end

function Soraka:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range*1.1) and BM.LC.Q:Value() then
				self.Spell[0].delay = .25 + (GetDistance(myHero,minion) / self.Spell[0].range)*.55
				local Pred = GetCircularAOEPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(minion, self.Spell[2].range) and BM.LC.E:Value() then
				local Pred = GetCircularAOEPrediction(minion, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end
end

function Soraka:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range*1.1) and BM.JC.Q:Value() then
				self.Spell[0].delay = .25 + (GetDistance(myHero,mob) / self.Spell[0].range)*.55
				local Pred = GetCircularAOEPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() then
				local Pred = GetCircularAOEPrediction(mob, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end
end

function Soraka:AutoW()
    for _,ally in pairs(GetAllyHeroes()) do
	    if GetDistance(myHero,ally)<GetCastRange(myHero,1) and SReady[1] and GetPercentHP(myHero) >= BM.AW.myHeroHP:Value() and GetPercentHP(ally) <= BM.AW.allyHP:Value() and BM.AW.Enable:Value() and EnemiesAround(GetOrigin(ally), BM.AW.ATRR:Value()) >= 1 and BM.AW["h"..GetObjectName(ally)]:Value() then
		    CastTargetSpell(ally, 1)
		end
	end
end

function Soraka:AutoR()
    for _,ally in pairs(GetAllyHeroes()) do
	    if SReady[3] and not ally.dead and GetPercentHP(ally) <= BM.AR.allyHP:Value() and BM.AR.Enable:Value() and EnemiesAround(GetOrigin(ally), BM.AR.ATRR:Value()) >= 1 then
		    CastSpell(3)
	    elseif SReady[3] and not myHero.dead and GetPercentHP(myHero) <= BM.AR.myHeroHP:Value() and BM.AR.Enable:Value() and EnemiesAround(GetOrigin(myHero), BM.AR.ATRR:Value()) >= 1 then
		    CastSpell(3)
		end
	end
end


class 'Sivir'

function Sivir:__init()
	
	Sivir.Spell = { 
	[0] = { delay = 0.250, speed = 1350, width = 85, range = 1075 },
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 20 * GetCastLevel(myHero,0) + 5 + (.1 * GetCastLevel(myHero,0) + .6) * (GetBonusDmg(myHero) + GetBaseDamage(myHero)), .5*GetBonusAP(myHero)) end,
	[1] = function (unit) return CalcDamage(myHero, unit, ((5 * GetCastLevel(myHero,2) + 45)/100) * GetBonusDmg(myHero), 0) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	BM.C:Slider("RHP", "myHeroHP ", 75, 1, 100, 5)
	BM.C:Slider("REHP", "EnemyHP ", 65, 1, 100, 5)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("W", "Use W", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("W", "Use W", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("ProcessSpellComplete", function(unit,spell) self:AAReset(unit,spell) end)
	HitMe()
end

function Sivir:Tick()
	if myHero.dead then return end
		
	GetReady()
		
	self:KS()
		
	local Target = GetCurrentTarget()
	
	if Mode == "Combo" then
		self:Combo(Target)
	elseif Mode == "LaneClear" then
		self:JungleClear()
		self:LaneClear()
	else
		return
	end
end

function Sivir:AAReset(unit, spell)
	local ta = spell.target
	if unit == myHero and ta ~= nil and spell.name:lower():find("attack") and SReady[1] then
		if Mode == "Combo" and BM.C.W:Value() then
			if ValidTarget(ta, GetRange(myHero)+GetHitBox(myHero)) then
				CastSpell(1)
			end
		elseif Mode == "LaneClear" and BM.LC.W:Value() and GetTeam(ta) == MINION_ENEMY then
			if ValidTarget(ta, GetRange(myHero)+GetHitBox(myHero)) then
				CastSpell(1)
			end
		elseif Mode == "LaneClear" and BM.JC.W:Value() and GetTeam(ta) == MINION_JUNGLE then
			if ValidTarget(ta, GetRange(myHero)+GetHitBox(myHero)) then
				CastSpell(1)
			end
		end
	end
end
				

function Sivir:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		local Pred = GetPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[3] and ValidTarget(target, 800) and BM.C.R:Value() and EnemiesAround(myHero,800) >= BM.C.RE:Value() and GetPercentHP(myHero) < BM.C.RHP:Value() and GetPercentHP(target) < BM.C.REHP:Value() then
		CastSpell(3)
	end
end

function Sivir:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range) and BM.LC.Q:Value() then
				local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
		end
	end
end

function Sivir:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
				local Pred = GetPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
		end
	end
end

function Sivir:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetAPHP(target) < Dmg[0](target) then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
	end
end

function Sivir:HitMe(unit,pos,dt,ty)
 DelayAction( function() 
  CastSpell(2)
 end,dt)
end

class 'Nocturne'

function Nocturne:__init()
	Nocturne.Spell = {
	[0] = { delay = 0.250, speed = 1400, width = 120, range = 1125 },
	[2] = { range = 425},
	[3] = { range = function() return 1750 + GetCastLevel(myHero,3)*750 end},
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 45 * GetCastLevel(myHero,0) + 15 + GetBonusDmg(myHero)* .75, 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 45 * GetCastLevel(myHero,2) + 35 + myHero.ap) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 0, 45 * GetCastLevel(myHero,2) + 35 + myHero.ap) end,
	}
	
	self.marker = nil
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:DropDown("RM", "R Mode", 2, {"Off","Keypress","Auto"})
	BM.C:KeyBinding("RK", "R Keypress", string.byte("T"))
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
	
	HitMe()
end

function Nocturne:Tick()
	if myHero.dead then return end
		
	GetReady()
		
	self:KS()
		
	local Target = GetCurrentTarget()
	
	if Mode == "Combo" then
		self:Combo(Target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
	else
		return
	end
end

function Nocturne:KS()
	self.marker = false
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetADHP(target) < Dmg[0](target) then
		local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[3] and ValidTarget(target, self.Spell[3].range()) and GetADHP(target) < Dmg[0](target) + Dmg[3](target) + Dmg[2](target) + myHero.totalDamage*2 then
			self.marker = target
			if BM.C.RM:Value() == 3 or (BM.C.RM:Value() == 2 and BM.C.RK:Value()) then
				CastSpell(3)
				DelayAction(function() CastTargetSpell(target,3) end, .2)			
			end
		end
	end
end

function Nocturne:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		local Pred = GetPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		CastTargetSpell(target,2)
	end
end

function Nocturne:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if SReady[0] and ValidTarget(minion, self.Spell[0].range) then
			if GetTeam(minion) == MINION_ENEMY and BM.LC.Q:Value() then
				local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			elseif GetTeam(minion) == 300 and BM.JC.Q:Value() then
				local Pred = GetPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()*.01 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
		end
	end
end

function Nocturne:Draw()
	if self.marker and BM.C.RM:Value() == 2 then
		DrawText(self.marker.charName .. " killable press " .. string.char(BM.C.RK:Key()),40,50,50,GoS.Red)
	end
end

function Nocturne:HitMe(unit,pos,dt,ty)
	DelayAction( function() 
		CastSpell(1)
	end,dt)
end

--[[
                _                 
     /\        | |                
    /  \   __ _| |_ _ __ _____  __
   / /\ \ / _` | __| '__/ _ \ \/ /
  / ____ \ (_| | |_| | | (_) >  < 
 /_/    \_\__,_|\__|_|  \___/_/\_\
                                  
--]]

class "Aatrox"

function Aatrox:__init()
	
	Aatrox.Spell = { 
	[0] = { delay = 0.2, range = 650, speed = 1500, radius = 113 },
	[1] = { range = 0 },
	[2] = { delay = 0.1, range = 1000, speed = 1000, width = 150 },
	[3] = { range = 550 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 35 + GetCastLevel(myHero,0)*45 + GetBonusDmg(myHero)*.6, 0) end,
	[1] = function (unit) return CalcDamage(myHero, unit, 25 + GetCastLevel(myHero,1)*35 + GetBonusDmg(myHero), 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 40 + GetCastLevel(myHero,2)*35 + GetBonusDmg(myHero)*.6 + GetBonusAP(myHero)*.6) end,
	[3] = function (unit) return CalcDamage(myHero, unit, 0, 100 + GetCastLevel(myHero,3)*100 + GetBonusAP(myHero)) end,
	}

	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("WE", "Only Toggle if enemy nearby", true)
	BM.C:Slider("WT", "Toggle W at % HP", 45, 5, 90, 5)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Slider("RE", "Use R if x enemies", 2, 1, 5, 1)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear", true)
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)	
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("Q", "Use Q", false)
	BM.KS:Boolean("E", "Use E", true)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)

	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:Stat(unit,buff) end)
	
	if GotBuff(myHero, "aatroxwpower") == 1 then
		self.W = "dmg"
	else
		self.W = "heal"
	end
end  

function Aatrox:Tick()
	if myHero.dead then return end
	
	GetReady()
		
	self:KS()
		
	local target = GetCurrentTarget()
		
	self:Toggle(target)
		
	if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "LastHit" then
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Aatrox:Toggle(target)
	if SReady[1] and BM.C.W:Value() and (not BM.C.WE:Value() or ValidTarget(target,750)) then
		if GetPercentHP(myHero) < BM.C.WT:Value()+1 and self.W == "dmg" then
			CastSpell(1)
		elseif GetPercentHP(myHero) > BM.C.WT:Value() and self.W == "heal" then
			CastSpell(1)
		end
	end
end

function Aatrox:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range*1.1) and BM.C.Q:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[0])
		if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
			CastSkillShot(0,Pred.castPos)
		end
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range*1.1) and BM.C.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	if SReady[3] and ValidTarget(target, 550) and BM.C.R:Value() and EnemiesAround(myHero,550) >= BM.C.RE:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
end

function Aatrox:Harass(target)
	if SReady[2] and ValidTarget(target, self.Spell[2].range*1.1) and BM.H.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
end

function Aatrox:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range*1.1) and BM.LC.Q:Value() then
			local Pred = GetCircularAOEPrediction(minion, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[2] and ValidTarget(minion, self.Spell[2].range*1.1) and BM.LC.E:Value() then
			local Pred = GetPrediction(minion, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end		
end

function Aatrox:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
			local Pred = GetCircularAOEPrediction(mob, self.Spell[0])
				if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
					CastSkillShot(0,Pred.castPos)
				end
			end
			if SReady[1] and BM.C.W:Value() and ValidTarget(mob,750) then
				if GetPercentHP(myHero) < BM.C.WT:Value()+1 and self.W == "dmg" then
					CastSpell(1)
				elseif GetPercentHP(myHero) > BM.C.WT:Value() and self.W == "heal" then
					CastSpell(1)
				end
			end
			if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() then
			local Pred = GetPrediction(mob, self.Spell[2])
				if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
					CastSkillShot(2,Pred.castPos)
				end
			end
		end
	end		
end

function Aatrox:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetADHP(unit) < Dmg[0](unit) and SReady[0] and ValidTarget(unit, self.Spell[0].range*1.1) and BM.KS.Q:Value() then
			local Pred = GetCircularAOEPrediction(unit, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if GetAPHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, self.Spell[2].range*1.1) and BM.KS.E:Value() then
			local Pred = GetPrediction(unit, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
	end
end

function Aatrox:Stat(unit, buff)
	if unit == myHero and buff.Name:lower() == "aatroxwlife" then
		self.W = "heal"
	elseif unit == myHero and buff.Name:lower() == "aatroxwpower" then
		self.W = "dmg"
	end
end

-- __     __   _ _   _            
-- \ \   / /__| ( ) | | _____ ____
--  \ \ / / _ \ |/  | |/ / _ \_  /
--   \ V /  __/ |   |   < (_) / / 
--    \_/ \___|_|   |_|\_\___/___|

class 'Velkoz'

function Velkoz:__init()
	BM:SubMenu("c", "Combo")
	BM.c:Boolean("Q","Use Q",true)
	BM.c:Boolean("FQ","Force Q Split",true)
	BM.c:Boolean("W","Use W",true)
	BM.c:Boolean("E","Use E",true)
	BM.c:Boolean("R","Use R",true)

	BM:SubMenu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)
	BM.p:Slider("hR", "HitChance R", 20, 0, 100, 1)

	BM:SubMenu("a", "Advanced")
	BM.a:Slider("eQ", "Extra Q", 20 , 10, 50, 2)
	BM.a:Slider("v", "QChecks", 4, 1, 8, 1)
	BM.a:Boolean("D","Developer Debug", false)

	self.ccTrack = {}
  	DelayAction(function ()
  		for _,i in pairs(GetEnemyHeroes()) do 
 			self.ccTrack[GetObjectName(i)] = false
  		end
 	end, .001)
	
	self.DegreeTable={22.5,-22.5,45,-45, 15, -15, 30, -30}
	self.rCast = false
	self.QStart = nil
	self.rTime = 0
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 40 * GetCastLevel(myHero,0) + 40 + GetBonusAP(myHero), 0)*.6 end, 
	[1] = function (unit) return CalcDamage(myHero, unit, 20 * GetCastLevel(myHero,1) + 10 + GetBonusDmg(myHero), 1)*.15 end, 
	[2] = function (unit) return CalcDamage(myHero, unit, 30 * GetCastLevel(myHero,2) - 10 + GetBonusDmg(myHero), 2)*.3 end, 
	[3] = function (unit) return Velkoz:RDmg(unit) end,
	}
	
	self.Spell = {
	[0] = { delay = 0.1, speed = 1300, width = 100, range = 750},
	[-1] ={ delay = 0.1, speed = 1300, width = 100, range = 1000},
	[1] = { delay = 0.1, speed = 1700, width = 100, range = 1050},
	[2] = { delay = 0.1, speed = 1700, range = 850, radius = 200 },
	}
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("ProcessSpellComplete", function(unit,spellProc) self:ProcessSpellComplete(unit,spellProc) end)
	Callback.Add("CreateObj", function(object) self:CreateObj(object) end)
	Callback.Add("UpdateBuff", function(unit,buffProc) self:UpdateBuff(unit,buffProc) end)
	Callback.Add("RemoveBuff", function(unit,buffProc) self:RemoveBuff(unit,buffProc) end)
	Callback.Add("Draw", function() self:Split() end)
end


function Velkoz:Tick()
	if myHero.dead or self.rCast then return end
	
	GetReady()
	
	GetReady()
	--self:Split()
		
	local target = GetCurrentTarget()
	
	if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
	--	self:LaneClear()
	--	self:JungleClear()
	elseif Mode == "LastHit" then
	--	self:LastHit()
	elseif Mode == "Harass" then
	--	self:Harass(target)
	else
		return
	end
end


function Velkoz:Combo(unit)
	for _,i in pairs(GetEnemyHeroes()) do
		if SReady[0] and BM.c.Q:Value() and GetCastName(myHero,0)=="VelkozQ" and ValidTarget(i,1400) then
			local direct=GetPrediction(i,self.Spell[0])
			if direct and direct.hitChance>=BM.p.hQ:Value()/100 and not direct:mCollision(1) then
				self.QStart=GetOrigin(myHero)
				CastSkillShot(0,direct.castPos)
			end
			local BVec = Vector(GetOrigin(i)) - Vector(GetOrigin(myHero))
			local dist = math.sqrt(GetDistance(GetOrigin(myHero),GetOrigin(i))^2/2)
			for l=1,BM.a.v:Value() do
				local sideVec=Velkoz:getVec(BVec,self.DegreeTable[l]):normalized()*dist
				local circlespot = sideVec+GetOrigin(myHero)
				local QPred = GetPrediction(i, self.Spell[0], circlespot)
				local QPred2 = GetPrediction(myHero, self.Spell[0], circlespot)
				if not QPred:mCollision(1) and not QPred2:mCollision(1) then
					CastSkillShot(0,circlespot)
					self.QStart=GetOrigin(myHero)
				end
			end
		end	
	end
	
	if BM.c.W:Value() and SReady[1] and ValidTarget(unit,1050) then
		local WPred = GetPrediction(unit, self.Spell[1])
		CastSkillShot(_W,WPred.castPos)
	end
		
	if BM.c.E:Value() and SReady[2]  and ValidTarget(unit,850) then
		local EPred = GetCircularAOEPrediction(unit, self.Spell[2])
		CastSkillShot(_E,EPred.castPos)
	end
	
	if BM.c.R:Value() and ValidTarget(unit,1550*.8) and SReady[3] and EnemiesAround(GetOrigin(myHero),400) == 0 and GetDistance(GetOrigin(myHero),GetOrigin(unit)) then
		if GetADHP(unit) < Velkoz:RDmg(unit) then
			CastSkillShot(3, GetOrigin(unit))
		end
	end
end

function Velkoz:RDmg(unit)
	local RTick = 27.5 + 22.5 * GetCastLevel(myHero,3) + GetBonusAP(myHero) * .1
	local Passive = 25 + 8 * GetLevel(myHero) + myHero.ap * .4
	local ticks = (1550 - GetDistance(GetOrigin(unit),GetOrigin(myHero))) / (GetMoveSpeed(unit)*.8)
	if self.ccTrack and self.ccTrack[GetObjectName(unit)] and self.rTime > GetGameTimer() then ticks = ticks + (self.rTime - GetGameTimer())*4 end
	ticks = math.max(ticks,10)
	return CalcDamage(myHero, unit, 0, RTick * ticks * 4) + Passive * 0.6
end

function Velkoz:Split()
	if SReady[0] and GetCastName(myHero,0)~="VelkozQ" and self.QBall and self.QStart then
		for _,i in pairs(GetEnemyHeroes()) do
			local split=GetPrediction(i, self.Spell[-1], GetOrigin(self.QBall))
			local BVector = Vector((GetOrigin(self.QBall))-Vector(self.QStart))
			local HVector = Vector((GetOrigin(self.QBall))-Vector(split.castPos))
			if BM.a.D:Value() then 
				DrawLine(WorldToScreen(0, self.QStart).x, WorldToScreen(0, self.QStart).y, WorldToScreen(0, self.QBall).x, WorldToScreen(0, self.QBall).y, 3, GoS.White)
				DrawLine(WorldToScreen(0, self.QBall).x, WorldToScreen(0, self.QBall).y, WorldToScreen(0, split.castPos).x, WorldToScreen(0, split.castPos).y, 3, GoS.White)
				DrawText(Velkoz:ScalarProduct(BVector,HVector)^2,30,500,20,GoS.White)
			end
			if ValidTarget(i,1600) and Velkoz:ScalarProduct(BVector,HVector)^2 < BM.a.eQ:Value()*.001 then
				CastSpell(0)
			end
		end
	end
end

function Velkoz:ProcessSpellComplete(unit,spellProc)
	if unit == myHero and spellProc.name:lower() == "velkozq" then
		self.QStart= Vector(spellProc.startPos)+Vector(Vector(spellProc.endPos)-spellProc.startPos):normalized()*5
	end
end

function Velkoz:CreateObj(object)
	if GetObjectBaseName(object)=="Velkoz_Base_Q_mis.troy" and GetDistance(myHero)<10 then
		self.QBall=object
		DelayAction(function() self.QBall=nil end,2)
	end
end

function Velkoz:getVec(base, degr)
	local x,y,z=base:unpack()
	x=x*math.cos(Velkoz:degrad(degr))-z*math.sin(Velkoz:degrad(degr))
	z=z*math.cos(Velkoz:degrad(degr))+x*math.sin(Velkoz:degrad(degr))
	return Vector(x,y,z)
end

function Velkoz:ScalarProduct(v1,v2)
	return (v1.x*v2.x+v1.y*v2.y+v1.z*v2.z)/(v1:len()*v2:len())
end

function Velkoz:degrad(degr)
	degr=(degr/180)*math.pi
	return degr
end

function Velkoz:UpdateBuff(unit,buffProc)
	if unit ~= myHero and (buffProc.Type == 29 or buffProc.Type == 11 or buffProc.Type == 24 or buffProc.Type == 30) then 
		self.ccTrack[GetObjectName(unit)] = true
		self.rTime = buffProc.ExpireTime
	elseif unit == myHero and buffProc.Name:lower() == "velkozr" then
		Stop(true)
		self.rCast = true
	end
end

function Velkoz:RemoveBuff(unit,buffProc)
	if unit ~= myHero and (buffProc.Type == 29 or buffProc.Type == 11 or buffProc.Type == 24 or buffProc.Type == 30) then 
		self.ccTrack[GetObjectName(unit)] = false
	elseif unit == myHero and buffProc.Name:lower() == "velkozr" then
		Stop(false)
		self.rCast = false
	end
end

--      _ _            
--     | (_)_ __ __  __
--  _  | | | '_ \\ \/ /
-- | |_| | | | | |>  < 
--  \___/|_|_| |_/_/\_\
                     

class 'Jinx'

function Jinx:__init()


	self.Spell = {
	[1] = { delay = 0.6, speed = 3000, width = 85, range = 1500},
	[2] = { delay = 1, speed = 887, width = 120, range = 900},
	[3] = { delay = 0.6, speed = 1700, width = 140, range = math.huge}
	}
	
	
	Dmg = {
	[1] = function (unit) return CalcDamage(myHero, unit, 50 * GetCastLevel(myHero,0) - 40 + (GetBonusDmg(myHero)+GetBaseDamage(myHero)) * 1.4, 0) end,
	[2] = function (unit) return CalcDamage(myHero, unit, 0, 55 * GetCastLevel(myHero,2) + 25 + GetBonusAP(myHero)) end, 
	[3] = function (unit) 
	local dmg = 150 + GetCastLevel(myHero,3)*GetBonusDmg(myHero)+(GetMaxHP(unit)-GetCurrentHP(unit))*(.20+GetCastLevel(myHero,3)*.5)
	return CalcDamage(myHero,unit, math.min(math.max(dmg*.1,dmg*GetDistance(GetOrigin(myHero),GetOrigin(unit))/1650),dmg), 0) end
	}
	
	BM:Menu("C", "Combo")
	BM.C:Menu("Q", "Q")
	BM.C.Q:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.C.Q:Boolean("enable", "Enable Q Combo", true)
	BM.C:Boolean("W", "Use W", true)
	BM.C:Boolean("E", "Use E", true)
	
	BM:Menu("H", "Harass")
	BM.H:Menu("Q", "Q")
	BM.H.Q:DropDown("QL", "Q-Logic", 1, {"Advanced", "Simple"})
	BM.H.Q:Boolean("enable", "Enable Q Harass", true)
	BM.H:Boolean("W", "Use W", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Menu("Q", "Q")
	BM.LC.Q:DropDown("QL", "Q-Logic", 1, {"Only Minigun", "Only Rockets"})
	BM.LC.Q:Boolean("enable", "Enable Q Laneclear", true)
	BM.LC:Boolean("W", "Use W", false)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Menu("Q", "Q")
	BM.JC.Q:DropDown("QL", "Q-Logic", 1, {"Only Minigun", "Only Rockets"})
	BM.JC.Q:Boolean("enable", "Enable Q Jungleclear", true)
	BM.JC:Boolean("W", "Use W", false)
	
	BM:Menu("LH", "LastHit")
	BM.LH:Boolean("UMinig", "Use only Minigun", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Enable", "Enable Killsteal", true)
	BM.KS:Boolean("W", "Use W", true)
	BM.KS:Boolean("E", "Use E", true)
	BM.KS:Boolean("R", "Enable R KS", true)
	BM.KS:Slider("mDTT", "R - max Distance to target", 3000, 675, 20000, 10)
	BM.KS:Slider("DTT", "R - min Distance to target", 1000, 675, 20000, 10)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hW", "HitChance W", 20, 0, 100, 1)
	BM.p:Slider("hE", "HitChance E", 20, 0, 100, 1)
	BM.p:Slider("hR", "HitChance R", 50, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
	Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
	
end

function Jinx:UpdateBuff(unit, buff)
	if unit == myHero and buff.Name == "jinxqicon" then
		minigun = true
	end
end

function Jinx:RemoveBuff(unit, buff)
	if unit == myHero and buff.Name == "jinxqicon" then
		minigun = false
	end
end

function Jinx:Tick()
	if myHero.dead then return end
	
	self.RocketRange = 25 * GetCastLevel(myHero,_Q) + 600
	
	
	GetReady()
		
	self:KS()
		
	local target = GetCurrentTarget()
		
	if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "LastHit" then
		self:LastHit()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Jinx:Combo(target)
	
	if BM.C.Q.QL:Value() == 1 and BM.C.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and EnemiesAround(target, 150) > 2 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end
		
	elseif BM.C.Q.QL:Value() == 2 and BM.C.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end		
	end
	
	if SReady[1] and ValidTarget(target, self.Spell[1].range) and BM.C.W:Value() and GetDistance(myHero,target)>100 then
		local Pred = GetPrediction(target, self.Spell[1])
		if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
			CastSkillShot(1,Pred.castPos)
		end
	end
	
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	
end

function Jinx:Harass(target)
	
	if BM.H.Q.QL:Value() == 1 and BM.H.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and EnemiesAround(target, 150) > 2 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end
		
	elseif BM.C.Q.QL:Value() == 2 and BM.H.Q.enable:Value() then
	
		if SReady[0] and ValidTarget(target, self.RocketRange) and minigun and GetDistance(target) > 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetDistance(target) < 550 and GetPercentMP(myHero) > 10 then
			CastSpell(0)
		elseif SReady[0] and ValidTarget(target, self.RocketRange) and not minigun and GetPercentMP(myHero) < 10 then
			CastSpell(0)
		end		
	end
	
	if SReady[1] and ValidTarget(target, self.Spell[1].range) and BM.H.W:Value() and GetDistance(myHero,target)>100 then
		local Pred = GetPrediction(target, self.Spell[1])
		if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
			CastSkillShot(1,Pred.castPos)
		end
	end
	
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
		local Pred = GetPrediction(target, self.Spell[2])
		if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
			CastSkillShot(2,Pred.castPos)
		end
	end
	
end

function Jinx:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			
			if BM.LC.Q.QL:Value() == 1 and BM.LC.Q.enable:Value() then	
			
				if SReady[0] and ValidTarget(minion, self.RocketRange) and not minigun then
					CastSpell(0)
				end
		
			elseif BM.LC.Q.QL:Value() == 2 and BM.LC.Q.enable:Value() then
	
				if SReady[0] and ValidTarget(minion, self.RocketRange) and minigun then
					CastSpell(0)
				end	
			end
			
			if SReady[1] and ValidTarget(minion, self.Spell[1].range) and BM.LC.W:Value() then
				local Pred = GetPrediction(minion, self.Spell[1])
				if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
					CastSkillShot(1,Pred.castPos)
				end
			end
		end
	end
end

function Jinx:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			
			if BM.JC.Q.QL:Value() == 1 and BM.JC.Q.enable:Value() then	
			
				if SReady[0] and ValidTarget(mob, self.RocketRange) and not minigun then
					CastSpell(0)
				end
		
			elseif BM.JC.Q.QL:Value() == 2 and BM.JC.Q.enable:Value() then
	
				if SReady[0] and ValidTarget(mob, self.RocketRange) and minigun then
					CastSpell(0)
				end	
			end
			
			if SReady[1] and ValidTarget(mob, self.Spell[1].range) and BM.LC.W:Value() then
				local Pred = GetPrediction(mob, self.Spell[1])
				if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
					CastSkillShot(1,Pred.castPos)
				end
			end
		end
	end
end

function Jinx:LastHit()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if BM.LH.UMinig:Value() and ValidTarget(minion, self.RocketRange) and not minigun and SReady[0] then
				CastSpell(0)
			end
		end
	end
end

function Jinx:KS()
	if not BM.KS.Enable:Value() then return end
	for _,unit in pairs(GetEnemyHeroes()) do
		if GetADHP(unit) < Dmg[1](unit) and SReady[1] and ValidTarget(unit, self.Spell[1].range) and BM.KS.W:Value() then
			local Pred = GetPrediction(unit, self.Spell[1])
			if Pred.hitChance >= BM.p.hW:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[1].range and not Pred:mCollision(1) then
				CastSkillShot(1,Pred.castPos)
			end
		end
		if GetAPHP(unit) < Dmg[2](unit) and SReady[2] and ValidTarget(unit, self.Spell[2].range) and BM.KS.E:Value() then
			local Pred = GetPrediction(unit, self.Spell[2])
			if Pred.hitChance >= BM.p.hE:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[2].range then
				CastSkillShot(2,Pred.castPos)
			end
		end
		if GetADHP(unit) < Dmg[3](unit) and SReady[3] and ValidTarget(unit, BM.KS.mDTT:Value()) and BM.KS.R:Value() and GetDistance(unit) >= BM.KS.DTT:Value() then
			local Pred = GetPrediction(unit, self.Spell[3])
			if Pred.hitChance >= BM.p.hR:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[3].range and not Pred:hCollision(1) then
				CastSkillShot(3,Pred.castPos)
			end
		end
	end
end

 -- _  __     _ _     _        
 --| |/ /__ _| (_)___| |_ __ _ 
 --| ' // _` | | / __| __/ _` |
 --| . \ (_| | | \__ \ || (_| |
 --|_|\_\__,_|_|_|___/\__\__,_|
                             

class 'Kalista'

function Kalista:__init()


	self.eTrack = {}
	self.soul = nil
	
	for _,i in pairs(GetAllyHeroes()) do
		if GotBuff(i, "kalistacoopstrikeally") == 1 then
			soul = i
		end
	end

	
	Kalista.Spell = {
	[-1] = { delay = .3, speed = math.huge, width = 1, range = 1500},
	[0] = { delay = 0.25, speed = 2000, width = 50, range = 1150},
	[1] = { range = 5000 },
	[2] = { range = 1000 },
	[3] = { range = 1500 }
	}
	
	Dmg = {
	[0] = function (unit) return CalcDamage(myHero, unit, 60 * GetCastLevel(myHero,0) - 50 + GetBonusDmg(myHero), 0) end, 
	[2] = function (unit) if not unit then return end return CalcDamage(myHero, unit, (10 * GetCastLevel(myHero,2) + 10 + (GetBonusDmg(myHero)+GetBaseDamage(myHero)) * .6) + ((self.eTrack[GetNetworkID(unit)] or 0)-1) * (({10,14,19,25,32})[GetCastLevel(myHero,2)] + (GetBaseDamage(myHero)+GetBaseDamage(myHero))*({0.2,0.225,0.25,0.275,0.3})[GetCastLevel(myHero,2)]), 0) end,
	}
	
	self.EpicJgl = {["SRU_Baron"]=true, ["SRU_Dragon"]=true, ["TT_Spiderboss"]=true}
	self.BigJgl = {["SRU_Baron"]=true, ["SRU_Dragon"]=true, ["SRU_Red"]=true, ["SRU_Blue"]=true, ["SRU_Krug"]=true, ["SRU_Murkwolf"]=true, ["SRU_Razorbeak"]=true, ["SRU_Gromp"]=true, ["Sru_Crab"]=true, ["TT_Spiderboss"]=true}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", false)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", false)
	
	BM:Menu("AE", "Auto E")
	BM.AE:Menu("MobOpt", "Mob Option")
	BM.AE.MobOpt:Boolean("UseB", "Use on Big Mobs", true)
	BM.AE.MobOpt:Boolean("UseE", "Use on Epic Mobs", true)
	BM.AE.MobOpt:Boolean("UseM", "Use on Minions", true)
	BM.AE.MobOpt:Boolean("UseMode", "Use only in Laneclear mode",false)
	BM.AE:Slider("xM", "Kill X Minions", 2, 1, 7, 1)	
	BM.AE:Boolean("UseC", "Use on Champs", true)
	BM.AE:Boolean("UseBD", "Use before death", true)
	BM.AE:Boolean("UseL", "Use if leaves range", false)
	BM.AE:Slider("OK", "Over kill", 10, 0, 50, 5)
	BM.AE:Slider("D", "Delay to use E", 10, 0, 50, 5)	
	
	BM:Menu("AR", "Auto R")
	BM.AR:Boolean("enable", "Enable Auto R")
	BM.AR:Slider("allyHP", "allyHP <= X", 5, 1, 100, 5)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	
	BM:Menu("WJ", "WallJump")
	BM.WJ:KeyBinding("J", "Wall Jump", string.byte("G"))
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hQ", "HitChance Q", 20, 0, 100, 1)

	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("UpdateBuff", function(unit, buff) self:UpdateBuff(unit, buff) end)
	Callback.Add("RemoveBuff", function(unit, buff) self:RemoveBuff(unit, buff) end)
	Callback.Add("ProcessSpellComplete", function(unit, spell) self:AAReset(unit, spell) end)

end

function Kalista:UpdateBuff(unit, buff) 
	if unit ~= myHero and buff.Name:lower() == "kalistaexpungemarker" and (unit.type==Obj_AI_Hero or unit.type==Obj_AI_Minion or unit.type==Obj_AI_Camp) then
		self.eTrack[GetNetworkID(unit)]=buff.Count 
	elseif buff.Name:lower() == "kalistacoopstrikeally" and GetTeam(unit) == MINION_ALLY then
		soul = unit
	end
end

function Kalista:RemoveBuff(unit, buff) 
	if unit ~= myHero and buff.Name:lower() == "kalistaexpungemarker" and (unit.type==Obj_AI_Hero or unit.type==Obj_AI_Minion or unit.type==Obj_AI_Camp) then
		self.eTrack[GetObjectName(unit)]=0 
	elseif buff.Name:lower() == "kalistacoopstrikeally" and GetTeam(unit) == MINION_ALLY then
		soul = nil
	end
end

function Kalista:Tick()
	if myHero.dead then return end
	
	GetReady()
	self:KS()
	self:AutoR()
	self:WallJump()
		
	local target = GetCurrentTarget()
	
	if Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	else
		return
	end
end

function Kalista:AutoR()
	if soul and BM.AR.enable:Value() and GetPercentHP(soul) <= BM.AR.allyHP:Value() and EnemiesAround(GetOrigin(soul), 1000) >= 1 then
		CastSpell(3)
	end
end

function Kalista:AAReset(unit, spell)
	local ta = spell.target
	if unit == myHero and ta ~= nil and spell.name:lower():find("attack") and SReady[0] and ValidTarget(ta, self.Spell[0].range) then
		if ((Mode == "Combo" and BM.C.Q:Value()) or (Mode == "Harass" and BM.H.Q:Value()) and GetObjectType(ta) == Obj_AI_Hero) or (Mode == "LaneClear" and ((BM.JC.Q:Value() and (GetObjectType(ta)==Obj_AI_Camp or GetObjectType(ta)==Obj_AI_Minion)) or (BM.LC.Q:Value() and GetObjectType(ta)==Obj_AI_Minion))) then
			local Pred = GetPrediction(ta, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
	end
end

function Kalista:JungleClear()

end

function Kalista:LaneClear()

end

function Kalista:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetADHP(target) < Dmg[0](target) then
			local Pred = GetPrediction(target, self.Spell[0])
			if Pred.hitChance >= BM.p.hQ:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[0].range then
				CastSkillShot(0,Pred.castPos)
			end
		end
		if SReady[2] and ValidTarget(target, 1000) and BM.AE.UseC:Value() and (GetADHP(target) + BM.AE.OK:Value()) < Dmg[2](target) and self.eTrack[GetNetworkID(target)] > 0 then
			DelayAction(function()
				CastSpell(2)
			end, BM.AE.D:Value()*.01)
		end
		if SReady[2] and ValidTarget(target, 1100) and BM.AE.UseL:Value() and self.eTrack[GetNetworkID(target)] then
			local Pred = GetPrediction(target,self.Spell[-1])
			if GetDistance(Pred.castPos,GetOrigin(myHero))>999 then
				CastSpell(2)
			end
		end
	end
	
	if not BM.AE.MobOpt.UseMode:Value() or Mode == "LaneClear" then
		for _,mob in pairs(minionManager.objects) do
			if GetTeam(mob) == MINION_JUNGLE then
				if SReady[2] and ValidTarget(mob, 750) and Dmg[2](mob) > GetCurrentHP(mob) then
					if BM.AE.MobOpt.UseE:Value() and self.EpicJgl[GetObjectName(mob)] then
						CastSpell(2)
					elseif BM.AE.MobOpt.UseB:Value() and self.BigJgl[GetObjectName(mob)] then
						CastSpell(2)
					end
				end
			end
		end
		
		self.km = 0
		for _,minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if Dmg[2](minion) > GetCurrentHP(minion) and ValidTarget(minion, 1000) and BM.AE.MobOpt.UseM:Value() then
					self.km = self.km + 1
				end
			end
		end
		if self.km >= BM.AE.xM:Value() then
			CastSpell(2)
		end
	end
	if BM.AE.UseBD:Value() and GetPercentHP(myHero)<=2 and SReady[2] then
		CastSpell(2)
	end
end

function Kalista:WallJump()
	if SReady[0] and BM.WJ.J:Value() and GetDistance(GetMousePos(),GetOrigin(myHero))<1500 then
		local mou = GetMousePos()
		local wallEnd = nil
		local wallStart = nil
		if not MapPosition:inWall(mou) then
			--DrawLine(WorldToScreen(0, GetOrigin(myHero)).x, WorldToScreen(0, GetOrigin(myHero)).y, WorldToScreen(0, mou).x, WorldToScreen(0, mou).y, 3, GoS.White)
			local dV = Vector(GetOrigin(myHero))-Vector(mou)
			for i = 1, dV:len(), 5 do
				if MapPosition:inWall(mou+dV:normalized()*i) and not wallEnd then
					wallEnd = Vector(mou+dV:normalized()*i)
				elseif wallEnd and not MapPosition:inWall(Vector(mou+dV:normalized()*i)) then
					wallStart = Vector(mou+dV:normalized()*i)
					DrawCircle(wallStart,50,0,3,GoS.White)
					break
				end
			end
			if wallEnd and wallStart then
				local WS = WorldToScreen(0,wallStart)
				local WE = WorldToScreen(0,wallEnd)
				if Vector(wallEnd-wallStart):len() < 290 then
					DrawLine(WS.x,WS.y,WE.x,WE.y,3,GoS.Green)
					MoveToXYZ(wallStart)
				else
					DrawLine(WS.x,WS.y,WE.x,WE.y,3,GoS.Red)
					DrawCircle(wallEnd,50,0,3,GoS.White)
					DrawCircle(wallStart,50,0,3,GoS.White)
				end
				if GetDistance(GetOrigin(myHero),wallEnd) < 290 then
					CastSkillShot(0,wallEnd)
					DelayAction(function()
						MoveToXYZ(mou)
					end, .001)
				end
			end
		end
	end
end

--  _   _                     
-- | \ | | __ _ ___ _   _ ___ 
-- |  \| |/ _` / __| | | / __|
-- | |\  | (_| \__ \ |_| \__ \
-- |_| \_|\__,_|___/\__,_|___/
--                            


class 'Nasus'

function Nasus:__init()
	
	Dmg = {
		[0] = function (unit) return CalcDamage(myHero, unit, self.qDmg, 0) end,
		[2] = function (unit) return CalcDamage(myHero, unit, 0, 40 * GetCastLevel(myHero,2) + 15 + GetBonusAP(myHero) * .6) end,
		[3] = function (unit) return CalcDamage(myHero, unit, 0, math.min((.02 * GetCastLevel(myHero,3) + .01) * GetMaxHP(unit)),240) end,
	}


	Nasus.Spell = {
		[0] = { delay = 0.3, range = 250},
		[1] = { delay = .2, range = 600 },
		[2] = { delay = .1, speed = math.huge, range = 650, radius = 395},
		[3] = { range = 200 }
	}
	
	BM:SubMenu("c", "Combo")
	BM.c:Boolean("Q", "Use Q", true)
	BM.c:Boolean("QP", "Use HP Pred for Q", true)
	BM.c:Slider("QDM", "Q DMG mod", 0, -10, 10, 1)
	BM.c:Boolean("W", "Use W", true)
	BM.c:Slider("WHP", "Use W at %HP", 20, 1, 100, 1)
	BM.c:Boolean("E", "Use E", true)
	BM.c:Boolean("R", "Use R", true)
	BM.c:Slider("RHP", "Use R at %HP", 20, 1, 100, 1)

	BM:SubMenu("f", "Farm")
	BM.f:DropDown("QM", "Auto Q in" ,1 , {"Always" , "Laneclear", "LastHit"})
	BM.f:Boolean("dQ", "Draw Q on creeps", true)
	
	BM:SubMenu("ks", "Killsteal")
	BM.ks:Boolean("KSQ","Killsteal with Q", true)
	BM.ks:Boolean("KSE","Killsteal with E", true)


--Var
	self.qDmg = 0
	self.Stacks = GetBuffData(myHero, "NasusQStacks").Stacks
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

-- Start
function Nasus:Tick()
	if myHero.dead then return end
	
		
	GetReady()
	self.qDmg = self:getQdmg()
	self:KS()
	self:Farm()
	local target = GetCurrentTarget()


    if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
	--	self:LaneClear()
	--	self:JungleClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Nasus:Draw()
	if myHero.dead or not BM.f.dQ:Value() then return end
	for _, creep in pairs(minionManager.objects) do
		--if Nasus:ValidCreep(creep,1000) then DrawText(math.floor(CalcDamage(myHero,creep,self.qDmg,0)),10,WorldToScreen(0,GetOrigin(creep)).x,WorldToScreen(0,GetOrigin(creep)).y,GoS.White) end
		if Nasus:ValidCreep(creep,1000) and GetCurrentHP(creep)<CalcDamage(myHero,creep,self.qDmg,0) then
			DrawCircle(GetOrigin(creep),50,0,3,GoS.Red)
		end
	end
end



function Nasus:Combo(unit)
	if BM.c.Q:Value() and SReady[0] and ValidTarget(unit, self.Spell[0].range) then
		CastSpell(0)
		AttackUnit(unit)
	end
	if SReady[1] and BM.c.W:Value() and ValidTarget(unit, self.Spell[1].range) and GetPercentHP(unit) < BM.c.WHP:Value() then
		CastTargetSpell(unit,1)
	end		
	if SReady[2] and BM.c.E:Value() and ValidTarget(unit, self.Spell[2].range) then
		local EPred=GetCircularAOEPrediction(unit, self.Spell[2])
		if EPred and EPred.hitChance >= 0.2 then
			CastSkillShot(2,EPred.castPos)
		end
	end				
end

function Nasus:Farm()
	local mod = BM.f.QM:Value()
	if (SReady[0] or CanUseSpell(myHero,0) == 8) and ((mod == 2 and Mode == "LaneClear") or (mod == 3 and Mode == "LastHit") or (mod == 1 and Mode ~= "Combo")) then
		for _, creep in pairs(minionManager.objects) do
			if Nasus:ValidCreep(creep, self.Spell[0].range) and GetCurrentHP(creep)<self.qDmg*2 and ((GetHealthPrediction(creep, GetWindUp(myHero))<CalcDamage(myHero, creep, self.qDmg, 0) and BM.c.QP:Value()) or (GetCurrentHP(creep)<CalcDamage(myHero, creep, self.qDmg, 0) and not BM.c.QP:Value())) then
				CastSpell(0)
				AttackUnit(creep)
				break
			end
		end
	end
end

function Nasus:KS()
	if SReady[3] and BM.c.R:Value() and ValidTarget(unit, 1075) and GetPercentHP(myHero) < BM.c.RHP:Value() then
		CastSpell(3)
	end
	for i,unit in pairs(GetEnemyHeroes()) do
		if BM.ks.KSQ:Value() and Ready(0) and ValidTarget(unit, self.Spell[0].range) and GetCurrentHP(unit)+GetDmgShield(unit)+GetMagicShield(unit) < CalcDamage(myHero, unit, self.qDmg, 0) then
			CastSpell(0)
			AttackUnit(unit)
		end
		if BM.ks.KSE:Value() and Ready(_E) and ValidTarget(unit,self.Spell[2].range) and GetCurrentHP(unit)+GetDmgShield(unit)+GetMagicShield(unit) <  CalcDamage(myHero, unit, 0, 15+40*GetCastLevel(myHero,_E)+GetBonusAP(myHero)*6) then 
			local NasusE=GetCircularAOEPrediction(unit, self.Spell[2])
			if EPred and EPred.hitChance >= .2 then
				CastSkillShot(_E,EPred.castPos)
			end
		end
	end
end

function Nasus:getQdmg()
	local base = 10 + 20*GetCastLevel(myHero,0) + GetBaseDamage(myHero) + GetBuffData(myHero, "NasusQStacks").Stacks + BM.c.QDM:Value()
	if 		(Ready(GetItemSlot(myHero,3078))) and GetItemSlot(myHero,3078)>0 then base = base + GetBaseDamage(myHero)*2 
	elseif 	(Ready(GetItemSlot(myHero,3057))) and GetItemSlot(myHero,3057)>0 then base = base + GetBaseDamage(myHero)
	elseif 	(Ready(GetItemSlot(myHero,3057))) and GetItemSlot(myHero,3025)>0 then base = base + GetBaseDamage(myHero)*1.25 
	end
	return base
end


function Nasus:ValidCreep(creep, range)
	if creep and not IsDead(creep) and GetTeam(creep) ~= MINION_ALLY and IsTargetable(creep) and GetDistance(GetOrigin(myHero), GetOrigin(creep)) < range then
		return true
	else 
		return false
	end
end



-- _  ___           _              _ 
--| |/ (_)_ __   __| |_ __ ___  __| |
--| ' /| | '_ \ / _` | '__/ _ \/ _` |
--| . \| | | | | (_| | | |  __/ (_| |
--|_|\_\_|_| |_|\__,_|_|  \___|\__,_|
--  

class "Kindred"

function Kindred:__init()
	self.Spells = {
	[0] = {range = 500, dash = 340, mana = 35},
	[1] = {range = 800, duration = 8, mana = 40},
	[2] = {range = 500, mana = 70, mana = 70},
	[3] = {range = 400, range2 = 500, mana = 100},
	}
	Dmg = 
	{
	[0] = function(Unit) return CalcDamage(myHero, Unit, 30+30*GetCastLevel(myHero, 0)+(GetBaseDamage(myHero) + GetBonusDmg(myHero))*0.20) end,
	[1] = function(Unit) return CalcDamage(myHero, Unit, 20+5*GetCastLevel(myHero, 1)+0.40*(GetBaseDamage(myHero) + GetBonusDmg(myHero))+0.40*self:PassiveDmg(Unit)) end,
	[2] = function(Unit) 	if GetTeam(Unit) == MINION_JUNGLE then
					return CalcDamage(myHero, Unit, math.max(300,30+30*GetCastLevel(myHero, 2)+(GetBaseDamage(myHero) + GetBonusDmg(myHero))*0.20+GetMaxHP(Unit)*0.05))
				else 
					return CalcDamage(myHero, Unit, 30+30*GetCastLevel(myHero, 2)+(GetBaseDamage(myHero) + GetBonusDmg(myHero))*0.20+GetMaxHP(Unit)*0.05)
				end
		  end,
	}
	self.BaseAS = GetBaseAttackSpeed(myHero)
	self.AAPS = self.BaseAS*GetAttackSpeed(myHero)
	self.WolfAA = self.Spells[1].duration*self.AAPS
	basePos = Vector(0,0,0)
	if GetTeam(myHero) == 100 then
		basePos = Vector(415,182,415)
	else
		basePos = Vector(14302,172,14387.8)
	end
	self.Recalling = false
	self.Farsight = false
	self.Passive = 0
	OnTick(function(myHero) self:Tick() end)
	OnProcessSpellComplete(function(unit, spell) self:OnProcComplete(unit, spell) end)
	OnProcessSpell(function(unit, spell) self:OnProc(unit, spell) end)
	Flash = (GetCastName(myHero, SUMMONER_1):lower():find("summonerflash") and SUMMONER_1 or (GetCastName(myHero, SUMMONER_2):lower():find("summonerflash") and SUMMONER_2 or nil)) -- Ty Platy
	self.target = nil

	BM:Menu("Combo", "Combo")
	BM.Combo:Boolean("Q", "Use Q", true)
	BM.Combo:Boolean("W", "Use W", true)
	BM.Combo:Boolean("E", "Use E", true)
	BM.Combo:Boolean("QE", "Gapcloser", true)

	BM:Menu("JunglerClear", "JunglerClear")
	BM.JunglerClear:Boolean("Q", "Use Q", true)
	BM.JunglerClear:Boolean("W", "Use W", true)
	BM.JunglerClear:Boolean("E", "Use E", true)
	BM.JunglerClear:Slider("MM", "Mana manager", 50, 1, 100)

	BM:Menu("LaneClear", "LaneClear")
	BM.LaneClear:Boolean("Q", "Use Q", true)
	BM.LaneClear:Boolean("W", "Use W", true)
	BM.LaneClear:Boolean("E", "Use E", true)
	BM.LaneClear:Slider("MM", "Mana manager", 50, 1, 100)

	BM:Menu("Misc", "Misc")
	BM.Misc:Boolean("B", "Buy Farsight", true)
	BM.Misc:KeyBinding("FQ", "Flash-Q", string.byte("T"))
	BM.Misc:Key("WP", "Jumps", string.byte("G"))

	BM:Menu("ROptions", "R Options")
	BM.ROptions:Boolean("R", "Use R?", true)
	BM.ROptions:Slider("EA", "Enemies around", 3, 1, 5)
	BM.ROptions:Boolean("RU", "Use R on urself", true)

	BM:Menu("QOptions", "Q Options")
	BM.QOptions:Boolean("QC", "AA reset Combo", true)
	BM.QOptions:Boolean("QL", "AA reset LaneClear", true)
	BM.QOptions:Boolean("QJ", "AA reset JunglerClear", true)
	BM.QOptions:Boolean("C", "Cancel animation?", false)

	DelayAction(function()
		for i, allies in pairs(GetAllyHeroes()) do
			BM.ROptions:Boolean("Pleb"..GetObjectName(allies), "Use R on "..GetObjectName(allies), true)
		end
	end, 0.001)
end

function Kindred:Tick()
	if not IsDead(myHero) then
	
		GetReady()
		self.target = GetCurrentTarget()

		if Mode == "Combo" then
			self:Combo(self.target)
		elseif Mode == "LaneClear" then
			self:LaneClear()
		end

		self:AutoR()
		if BM.Misc.FQ:Value() then
			if SReady[0] and Ready(Flash) and BM.Combo.Q:Value() then  
				CastSkillShot(Flash, GetMousePos()) 
					DelayAction(function() CastSkillShot(0, GetMousePos()) end, 1)					  
			end
		end
		if BM.Misc.WP:Value() then
			if self:WallBetween(GetOrigin(myHero), GetMousePos(),  self.Spells[0].dash) and SReady[0] then
				CastSkillShot(0, GetMousePos())
			end
		end
		self.Passive = GetBuffData(myHero,"kindredmarkofthekindredstackcounter").Stacks
		if BM.Misc.B:Value() then
			if not self.Farsight and GetLevel(myHero) >= 9 and GetDistance(myHero,basePos) < 550 then
				BuyItem(3363)
				self.Farsight = true
			end
		end
	end
end

function Kindred:Combo(Unit)
local AfterQ = GetOrigin(myHero) +(Vector(GetMousePos()) - GetOrigin(myHero)):normalized()*self.Spells[0].dash

	if SReady[2] and SReady[0] and BM.Combo.QE:Value() and GetDistance(Unit) > self.Spells[0].range and GetDistance(AfterQ, Unit) <= 450 then
		CastSkillShot(0, GetMousePos())
			DelayAction(function() CastTargetSpell(Unit, 2) end, 1)
	end
	if SReady[0] and BM.Combo.Q:Value() and ValidTarget(Unit, self.Spells[0].range) and BM.QOptions.QC:Value() == false or (GetDistance(Unit) > self.Spells[0].range and GetDistance(AfterQ, Unit) <= 450)  then
    	CastSkillShot(0, GetMousePos()) 
	end
	if SReady[1] and BM.Combo.W:Value() and ValidTarget(Unit, self.Spells[1].range) then 
		CastSpell(1)
	end
	if SReady[2] and BM.Combo.E:Value() and ValidTarget(Unit, self.Spells[2].range) then 
		CastTargetSpell(Unit, 2)
	end
end

function Kindred:LaneClear()
	local QMana = (self.Spells[0].mana*100)/GetMaxMana(myHero)
	local WMana = (self.Spells[1].mana*100)/GetMaxMana(myHero)
	local EMana = (self.Spells[2].mana*100)/GetMaxMana(myHero)
	for _, mob in pairs(minionManager.objects) do	
		if GetTeam(mob) == MINION_JUNGLE then
			if BM.QOptions.QJ:Value() == false and SReady[0] and BM.JunglerClear.Q:Value() and ValidTarget(mob, self.Spells[0].range) and GetCurrentHP(mob) >= Dmg[0](mob) --[[and (GetPercentMP(myHero)- QMana) >= BM.JunglerClear.MM:Value()]] then 
				CastSkillShot(0, GetMousePos())
			end
			if SReady[1] and ValidTarget(mob, self.Spells[1].range) and IsTargetable(mob) and BM.JunglerClear.W:Value() and (GetPercentMP(myHero)- WMana) >= BM.JunglerClear.MM:Value() and self:TotalHp(self.Spells[1].range, myHero) >= Dmg[1](mob) + ((8/self.AAPS)*CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero)+self:PassiveDmg(mob))) then
   				CastSpell(1)
    		end
    		if SReady[2] and ValidTarget(mob, self.Spells[2].range) and BM.JunglerClear.E:Value() and (GetPercentMP(myHero)- EMana) >= BM.JunglerClear.MM:Value() and GetCurrentHP(mob) >= Dmg[2](mob) + (CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero))*3) then 
   				CastTargetSpell(mob, 2)
   			end
  	 	end
		if GetTeam(mob) == MINION_ENEMY then
			if BM.QOptions.QL:Value() == false and SReady[0] and BM.LaneClear.Q:Value() and (GetPercentMP(myHero)- QMana) >= BM.LaneClear.MM:Value() and ValidTarget(mob, self.Spells[0].range) and GetCurrentHP(mob) >= Dmg[0](mob) then 
				CastSkillShot(0, GetMousePos())
			end
			if SReady[1] and ValidTarget(mob, self.Spells[1].range) and BM.LaneClear.W:Value() and (GetPercentMP(myHero)- WMana) >= BM.LaneClear.MM:Value() and self:TotalHp(self.Spells[1].range, myHero) >= Dmg[1](mob) + ((8/self.AAPS)*CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero)+self:PassiveDmg(mob))) then 
				CastSpell(1)
			end
			if SReady[2] and ValidTarget(mob, self.Spells[2].range) and BM.LaneClear.E:Value() and (GetPercentMP(myHero)- EMana) >= BM.LaneClear.MM:Value() and GetCurrentHP(mob) >= Dmg[2](mob) + (CalcDamage(myHero, mob, GetBaseDamage(myHero) + GetBonusDmg(myHero))*3) then 
				CastTargetSpell(mob, 2)
			end
		end
	end
end

function Kindred:AutoR()
	if BM.ROptions.R:Value() and not self.Recalling and not IsDead(myHero) and SReady[3] then
		for i, allies in pairs(GetAllyHeroes()) do
			if GetPercentHP(allies) <= 20 and BM.ROptions["Pleb"..GetObjectName(allies)] and not IsDead(allies) and GetDistance(allies) <= self.Spells[3].range2 and EnemiesAround(allies, 1500) >= BM.ROptions.EA:Value() then
				CastTargetSpell(myHero, 3)
			end
		end
		if GetPercentHP(myHero) <= 20 and BM.ROptions.RU:Value() and EnemiesAround(myHero, 1500) >= BM.ROptions.EA:Value() then
			CastTargetSpell(myHero, 3)
		end
	end
end

function Kindred:OnProcComplete(unit, spell)
	local QMana = (self.Spells[0].mana*100)/GetMaxMana(myHero)
	if unit == myHero then
		if spell.name:lower():find("attack") then
			if Mode == "LaneClear" then 
				for _, mob in pairs(minionManager.objects) do	
					if BM.QOptions.QL:Value() and ValidTarget(mob, 500) and GetTeam(mob) == MINION_ENEMY and BM.LaneClear.Q:Value() and (GetPercentMP(myHero)- QMana) >= BM.LaneClear.MM:Value() and SReady[0] then
						CastSkillShot(0, GetMousePos())
					end
					if BM.QOptions.QJ:Value() and ValidTarget(mob, 500) and GetTeam(mob) == MINION_JUNGLE and BM.JunglerClear.Q:Value() and (GetPercentMP(myHero)- QMana) >= BM.JunglerClear.MM:Value() and SReady[0] then
						CastSkillShot(0, GetMousePos()) 
					end
				end
			elseif Mode == "Combo" then
				if BM.QOptions.QC:Value() and SReady[0] and BM.Combo.Q:Value() and ValidTarget(self.target, 500) then
    				CastSkillShot(0, GetMousePos()) 
				end
			end
		end
	end
end

function Kindred:OnProc(unit, spell)
	if unit == myHero and spell.name == "KindredQ" and BM.QOptions.C:Value() then
		DelayAction(function() CastEmote(EMOTE_DANCE) end, .001)
	end
end

function Kindred:OnUpdate(unit, buff)
	if unit == myHero then
		if buff.Name == "recall" or buff.Name == "OdinRecall" then
			self.Recalling = true
		end
		--[[if buff.Name == "kindredmarkofthekindredstackcounter" then
			self.Passive = self.Passive + buff.Stacks
		end]]
	end
end

function Kindred:OnRemove(unit, buff)
	if unit == myHero and buff.Name == "recall" or buff.Name == "OdinRecall" then
		self.Recalling = false
	end
end

function Kindred:PassiveDmg(unit)
	if self.Passive ~= 0 then
		local PassiveDmg = self.Passive * 1.25
		if GetTeam(unit) == MINION_JUNGLE then
			return CalcDamage(myHero, unit, math.max(75+10*self.Passive, GetCurrentHP(unit)*(PassiveDmg/100)))
		else
			return CalcDamage(myHero, unit, GetCurrentHP(unit)*(PassiveDmg/100))
		end
	else return 0
	end
end

function Kindred:TotalHp(range, pos)
	local hp = 0
	for _, mob in pairs(minionManager.objects) do
		if not IsDead(mob) and IsTargetable(mob) and (GetTeam(mob) == MINION_JUNGLE or GetTeam(mob) == MINION_ENEMY) and GetDistance(mob, pos) <= range then
			hp = hp + GetCurrentHP(mob)
		end
	end
	return hp
end

function Kindred:WallBetween(p1, p2, distance) --p1 and p2 are Vectors3d

	local Check = p1 + (Vector(p2) - p1):normalized()*distance/2
	local Checkdistance = p1 +(Vector(p2) - p1):normalized()*distance
	
	if MapPosition:inWall(Check) and not MapPosition:inWall(Checkdistance) then
		return true
	end
end


class 'Vladimir'

function Vladimir:__init()
	
	Vladimir.Spell = {
	[0] = { range = 600 },
	[1] = { range = 350 },
	[2] = { range = 610 },
	[3] = { delay = 0.25, speed = math.huge, range = 700, radius = 175},
	}
	
	Dmg = {
	[0] = function(unit) return CalcDamage(myHero, unit, 0, 35 * GetCastLevel(myHero,0) + 55 + GetBonusAP(myHero) * .6) end,
	[2] = function(unit) return CalcDamage(myHero, unit, 0, 25 * GetCastLevel(myHero,2) + 35 + GetBonusAP(source) * 0.45)  end,
	[3] = function(unit) return CalcDamage(myHero, unit, 0, 100 * GetCastLevel(myHero,3) + 50 + GetBonusAP(myHero) * .7) end,
	}
	
	BM:Menu("C", "Combo")
	BM.C:Boolean("Q", "Use Q", true)
	BM.C:Boolean("E", "Use E", true)
	BM.C:Boolean("R", "Use R", true)
	BM.C:Boolean("REA", "Use if R will hit > x enemies", 2, 1, 5, 1)
	
	BM:Menu("H", "Harass")
	BM.H:Boolean("Q", "Use Q", true)
	BM.H:Boolean("E", "Use E", true)
	
	BM:Menu("LC", "LaneClear")
	BM.LC:Boolean("Q", "Use Q", true)
	BM.LC:Boolean("E", "Use E", true)
	
	BM:Menu("JC", "JungleClear")
	BM.JC:Boolean("Q", "Use Q", true)
	BM.JC:Boolean("E", "Use E", true)
	
	BM:Menu("KS", "Killsteal")
	BM.KS:Boolean("Q", "Use Q", true)
	BM.KS:Boolean("E", "Use E", true)
	BM.KS:Boolean("R", "Use R", false)
	
	BM:Menu("p", "Prediction")
	BM.p:Slider("hR", "HitChance R", 40, 0, 100, 1)
	
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("UpdateBuff", function(unit,buff) self:UpdateBuff(unit,buff) end)
	Callback.Add("RemoveBuff", function(unit,buff) self:RemoveBuff(unit,buff) end)
	HitMe()
	
	self.EStacks = 0
	self.ETime = 0

end

function Vladimir:HitMe(unit,pos,dt,ty)
 DelayAction( function() 
  CastSpell(1)
 end,dt)
end

function Vladimir:Tick()
	if myHero.dead then return end
	
		
	GetReady()
	
	self:KS()
	
	local target = GetCurrentTarget()


    if Mode == "Combo" then
		self:Combo(target)
	elseif Mode == "LaneClear" then
		self:LaneClear()
		self:JungleClear()
	elseif Mode == "Harass" then
		self:Harass(target)
	else
		return
	end
end

function Vladimir:Combo(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.C.Q:Value() then
		CastTargetSpell(target,0)
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.C.E:Value() then
		CastSpell(2)
	end
	if SReady[3] and ValidTarget(target, self.Spell[3].range) and BM.C.R:Value() and EnemiesAround(GetOrigin(target), self.Spell[3].radius) >= BM.C.REA:Value() then
		local Pred = GetCircularAOEPrediction(target, self.Spell[3])
		if Pred.hitChance >= BM.p.hR:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[3].range then
			CastSkillShot(3,Pred.castPos)
		end
	end
end

function Vladimir:Harass(target)
	if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.H.Q:Value() then
		CastTargetSpell(target,0)
	end
	if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.H.E:Value() then
		CastSpell(2)
	end
end

function Vladimir:LaneClear()
	for _,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if SReady[0] and ValidTarget(minion, self.Spell[0].range) and BM.LC.Q:Value() then
				CastTargetSpell(minion,0)
			end
			if SReady[2] and ValidTarget(minion, self.Spell[2].range) and BM.LC.E:Value() then
				CastSpell(2)
			end
		end
	end
end

function Vladimir:JungleClear()
	for _,mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			if SReady[0] and ValidTarget(mob, self.Spell[0].range) and BM.JC.Q:Value() then
				CastTargetSpell(mob,0)
			end
			if SReady[2] and ValidTarget(mob, self.Spell[2].range) and BM.JC.E:Value() then
				CastSpell(2)
			end
		end
	end
end

function Vladimir:KS()
	for _,target in pairs(GetEnemyHeroes()) do
		if SReady[0] and ValidTarget(target, self.Spell[0].range) and BM.KS.Q:Value() and GetAPHP(target) < Dmg[0](target) then
			CastTargetSpell(target,0)
		end
		if SReady[2] and ValidTarget(target, self.Spell[2].range) and BM.KS.E:Value() and GetAPHP(target) < Dmg[2](target) then
			CastSpell(2)
		end
		if SReady[3] and ValidTarget(target, self.Spell[3].range) and BM.KS.R:Value() and GetAPHP(target) < Dmg[3](target) then
			local Pred = GetCircularAOEPrediction(target, self.Spell[3])
			if Pred.hitChance >= BM.p.hR:Value()/100 and GetDistance(Pred.castPos,GetOrigin(myHero)) < self.Spell[3].range then
				CastSkillShot(3,Pred.castPos)
			end
		end
	end
end

function Vladimir:UpdateBuff(unit,buff)
	if unit == myHero and buff.Name == "vladimirtidesofbloodcost" then
		self.EStacks = buff.Count
		self.ETime = buff.ExpireTime
	end
end

function Vladimir:RemoveBuff(unit,buff)
	if unit == myHero and buff.Name == "vladimirtidesofbloodcost" then
		self.EStacks = 0
	end
end

---------------------------------------------------------------------------------------------
-------------------------------------UTILITY-------------------------------------------------
---------------------------------------------------------------------------------------------

--DamageDraw (Paint.lua)
class 'DmgDraw'

function DmgDraw:__init()

	self.dmgSpell = {}
	self.spellName= {"Q","W","E","R"} 
	self.dC = { {200,255,255,0}, {200,0,255,0}, {200,255,0,0}, {200,0,0,255} }
	self.aa = {}
	self.dCheck = {}
	self.dX = {}
	self.Own = nil

	SLS:SubMenu("D","|SL| Draw Damage")
	SLS.D:Boolean("dAA","Count AA to kill", true)
	SLS.D:Boolean("dAAc","Consider Crit", true)
	SLS.D:Slider("dR","Draw Range", 1500, 500, 3000, 100)
	
	if SLSChamps[ChampName] then
		self.Own = true
		for i=1,4,1 do
			if Dmg[i-1] then
				SLS.D:Boolean(self.spellName[i], "Draw "..self.spellName[i], true)
				SLS.D:ColorPick(self.spellName[i].."c", "Color for "..self.spellName[i], self.dC[i])
			end
		end
	else
		self.Own = false
		require('DamageLib')
		PrintChat("<font color=\"#fd8b12\"><b>[SL-Series] - <font color=\"#F2EE00\">DamageLib loaded</b></font>")
		for i=1,4,1 do
			if getdmg(self.spellName[i],myHero,myHero,1,3)~=0 then
				SLS.D:Boolean(self.spellName[i], "Draw "..self.spellName[i], true)
				SLS.D:ColorPick(self.spellName[i].."c", "Color for "..self.spellName[i], self.dC[i])
			end
		end
	end

	DelayAction( function()
		for _,champ in pairs(GetEnemyHeroes()) do
			self.dmgSpell[GetObjectName(champ)]={0, 0, 0, 0}
			self.dX[GetObjectName(champ)] = {{0,0}, {0,0}, {0,0}, {0,0}}
		end
		Callback.Add("Tick", function() self:Set() end)
		Callback.Add("Draw", function() self:Draw() end)
	end, .001)
end

function DmgDraw:Set()
	for _,champ in pairs(GetEnemyHeroes()) do
		self.dCheck[GetObjectName(champ)]={false,false,false,false}
		local last = GetPercentHP(champ)*1.04
		local lock = false
			GetReady()
		for i=1,4,1 do
			if SLS.D[self.spellName[i]] and SLS.D[self.spellName[i]]:Value() and (SReady[i-1] or CanUseSpell(myHero,i-1) == 8) and GetDistance(GetOrigin(myHero),GetOrigin(champ)) < SLS.D.dR:Value() then
				if self.Own then
					self.dmgSpell[GetObjectName(champ)][i] = Dmg[i-1](champ)
				else
					self.dmgSpell[GetObjectName(champ)][i] = getdmg(self.spellName[i],champ,myHero,GetCastLevel(myHero,i-1))
				end
				self.dCheck[GetObjectName(champ)][i]=true
			else 
				self.dmgSpell[GetObjectName(champ)][i] = 0
				self.dCheck[GetObjectName(champ)][i]=false
			end
			self.dX[GetObjectName(champ)][i][2] = self.dmgSpell[GetObjectName(champ)][i]/(GetMaxHP(champ)+GetDmgShield(champ))*104
			self.dX[GetObjectName(champ)][i][1] = last - self.dX[GetObjectName(champ)][i][2]
			last = last - self.dX[GetObjectName(champ)][i][2]
			if lock then
				self.dX[GetObjectName(champ)][i][1] = 0 
				self.dX[GetObjectName(champ)][i][2] = 0
			end
			if self.dX[GetObjectName(champ)][i][1]<=0 and not lock then
				self.dX[GetObjectName(champ)][i][1] = 0 
				self.dX[GetObjectName(champ)][i][2] = last + self.dX[GetObjectName(champ)][i][2]
				lock = true
			end
		end
		if SLS.D.dAA:Value() and SLS.D.dAAc:Value() then 
			self.aa[GetObjectName(champ)] = math.ceil(GetCurrentHP(champ)/(CalcDamage(myHero, champ, GetBaseDamage(myHero)+GetBonusDmg(myHero),0)*(GetCritChance(myHero)+1)))
		elseif SLS.D.dAA:Value() and not SLS.D.dAAc:Value() then 
			self.aa[GetObjectName(champ)] = math.ceil(GetCurrentHP(champ)/(CalcDamage(myHero, champ, GetBaseDamage(myHero)+GetBonusDmg(myHero),0)))
		end
	end
end

function DmgDraw:Draw()
	for _,champ in pairs(GetEnemyHeroes()) do
		
		local bar = GetHPBarPos(champ)
		if bar.x ~= 0 and bar.y ~= 0 then
			for i=4,1,-1 do
				if self.dCheck[GetObjectName(champ)] and self.dCheck[GetObjectName(champ)][i] then
					FillRect(bar.x+self.dX[GetObjectName(champ)][i][1],bar.y,self.dX[GetObjectName(champ)][i][2],9,SLS.D[self.spellName[i].."c"]:Value())
					FillRect(bar.x+self.dX[GetObjectName(champ)][i][1],bar.y-1,2,11,GoS.Black)
				end
			end
			if SLS.D.dAA:Value() and bar.x ~= 0 and bar.y ~= 0 and self.aa[GetObjectName(champ)] then 
				DrawText(self.aa[GetObjectName(champ)].." AA", 15, bar.x + 75, bar.y + 25, GoS.White)
			end
		end
	end
end

class 'Drawings'

function Drawings:__init()
	if not SLSChamps[ChampName] then return end
	self.SNames={"Q","W","E","R"}
	self.Check={false,false,false,false}
	SLS:SubMenu("Dr", "|SL| Drawings")
	SLS.Dr:Boolean("UD", "Use Drawings", false)
	SLS.Dr:ColorPick("CP", "Circle color", {255,102,102,102})
	SLS.Dr:DropDown("DQM", "Draw Quality", 1, {"High", "Medium", "Low"})
	SLS.Dr:Slider("DWi", "Circle witdth", 1, 1, 5, 1)
	for i=0,3 do
		if _G[ChampName].Spell and _G[ChampName].Spell[i] and _G[ChampName].Spell[i].range then
			local range = _G[ChampName].Spell[i].range
		else
			local range = nil
		end
		if range and range < 3000 and range > 200 then
			SLS.Dr:Boolean("D"..self.SNames[i+1], "Draw "..self.SNames[i+1], true)
		end
	end
	Callback.Add("Tick", function() self:CheckS() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Drawings:CheckS()
	for l=0,3 do 
		if SLS.Dr.UD:Value() and _G[ChampName].Spell and _G[ChampName].Spell[l] and SReady[l] and SLS.Dr["D"..self.SNames[l+1]]:Value() then 
			self.Check[l+1] = true
		else 
			self.Check[l+1] = false
		end
	end
end

function Drawings:Draw()
	local org = GetOrigin(myHero)
	for l=0,3 do
		if self.Check[l+1] then
			DrawCircle(org, _G[ChampName].Spell[l].range, SLS.Dr.DWi:Value(), SLS.Dr.DQM:Value(), SLS.Dr.CP:Value())
		end
	end
end


--Updater
class 'Update'

function Update:__init()
	if not AutoUpdater then return end
	self.webV = "Error"
	self.Stat = "Error"
	self.Do = true

	function AutoUpdate(data)
		if tonumber(data) > SLSeries then
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
		DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Series.lua", SCRIPT_PATH .. "SL-Series.lua", function() self.State = "Update Complete" PrintChat("<font color=\"#fd8b12\"><b>[SL-Series] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return	end)
	elseif key == 513 and cur.x > 370 and cur.x < 400 and cur.y > 7 and cur.y < 60 then
		Callback.Del("Draw", function() self:Box() end)
		self.Do = false
	end
end


class 'HitMe'

function HitMe:__init()
 
     self.str = {[-4] = "R2", [-3] = "P", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
 
    SLS:SubMenu("SB","|SL| Spellblock")
   
    if Name == "Sivir" or "Morgana" then
        SLS.SB:Boolean("uS","Use Spellshield",true)
        SLS.SB:Slider("dV","Danger Value",2,1,5,1)
    elseif Name == "Nocturne" or "Vladimir" then
        SLS:Boolean("uS","Use Hourglass",true)
        SLS:Slider("dV","Danger Value",5,1,5,1)
    elseif GetItemSlot(myHero,3157)>0 or GetItemSlot(myHero,3090)>0 then
        self.Slot = function() return (GetItemSlot(myHero,3157)>0 or GetItemSlot(myHero,3090)>0) end
    end
  
	
self.s = {
	
		["Aatrox"] = {
			[_Q] = { displayname = "Dark Flight", name = "AatroxQ", speed = 450, delay = 0.25, range = 650, width = 285, collision = false, aoe = true, type = "circular" , danger = 3, type2 = "gc"},
			[_E] = { displayname = "Blades of Torment", name = "AatroxE", objname = "AatroxEConeMissile", speed = 1250, delay = 0.25, range = 1075, width = 35, collision = false, aoe = false, type = "linear", danger = 1}
		},
		["Ahri"] = {
			[_Q] = { displayname = "Orb of Deception", name = "AhriOrbofDeception", objname = "AhriOrbMissile", speed = 2500, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Orb Return", name = "AhriOrbReturn", objname = "AhriOrbReturn", speed = 1900, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Charm", name = "AhriSeduce", objname = "AhriSeduceMissile", speed = 1550, delay = 0.25, range = 1000, width = 60, collision = true, aoe = false, type = "linear", danger = 4, type2 = "cc"},
		},
		["Akali"] = {
			[_E] = { displayname = "Crescent Slash", name = "CrescentSlash", speed = math.huge, delay = 0.125, range = 0, width = 325, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Alistar"] = {
			[_Q] = { displayname = "Pulverize", name = "Pulverize", speed = math.huge, delay = 0.25, range = 0, width = 365, collision = false, aoe = true, type = "circular", danger = 4, type2 = "cc"}
		},
		["Amumu"] = {
			[_Q] = { displayname = "Bandage Toss", name = "BandageToss", objname = "SadMummyBandageToss", speed = 725, delay = 0.25, range = 1000, width = 100, collision = true, aoe = false, type = "linear", danger = 4, type2 = "cc"}
		},
		["Anivia"] = {
			[_Q] = { displayname = "Flash Frost", name = "FlashFrostSpell", objname = "FlashFrostSpell", speed = 850, delay = 0.250, range = 1200, width = 110, collision = false, aoe = false, type = "linear", danger = 3, type2 = "cc"},
			[_R] = { displayname = "Glacial Storm", name = "GlacialStorm", speed = math.huge, delay = math.huge, range = 615, width = 350, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Annie"] = {
			[_Q] = { name = "Disintegrate", danger = 2},
			[_W] = { displayname = "Incinerate", name = "Incinerate", speed = math.huge, delay = 0.25, range = 625, width = 250, collision = false, aoe = true, type = "cone", danger = 3},
			[_R] = { displayname = "Tibbers", name = "InfernalGuardian", speed = math.huge, delay = 0.25, range = 600, width = 300, collision = false, aoe = true, type = "circular", ranger = 5, type2 = "cc"}
		},
		["Ashe"] = {
			[_W] = { displayname = "Volley", name = "Volley", objname = "VolleyAttack", speed = 902, delay = 0.25, range = 1200, width = 100, collision = true, aoe = false, type = "cone", danger = 2},
			[_R] = { displayname = "Enchanted Crystal Arrow", name = "EnchantedCrystalArrow", objname = "EnchantedCrystalArrow", speed = 1600, delay = 0.5, range = 25000, width = 100, collision = true, aoe = false, type = "linear", danger = 5, type2 = "cc"}
		},
		["AurelionSol"] = {
			[_Q] = { displayname = "Starsurge", name = "AurelionSolQ", objname = "AurelionSolQMissile", speed = 850, delay = 0.25, range = 1500, width = 150, collision = false, aoe = true, type = "linear", danger = 3, type2 = "cc"},
			[_R] = { displayname = "Voice of Light", name = "AurelionSolR", objname = "AurelionSolRBeamMissile", speed = 4600, delay = 0.3, range = 1420, width = 120, collision = false, aoe = true, type = "linear", danger = 4},
		},
		["Azir"] = {
			[_Q] = { displayname = "Conquering Sands", name = "AzirQ", speed = 2500, delay = 0.250, range = 880, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "Shifting Sands", name = "AzirE", range = 1100, delay = 0.25, speed = 1200, width = 60, collision = true, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "Emperor's Divide", name = "AzirR", speed = 1300, delay = 0.2, range = 520, width = 600, collision = false, aoe = true, type = "linear", danger = 4, type2 = "cc"}
		},
		["Bard"] = {
			[_Q] = { displayname = "Cosmic Binding", name = "BardQ", objname = "BardQMissile", speed = 1100, delay = 0.25, range = 850, width = 108, collision = true, aoe = false, type = "linear", danger = 3, type2 = "cc"},
			[_R] = { displayname = "Tempered Fate", name = "BardR", objname = "BardR", speed = 2100, delay = 0.5, range = 3400, width = 350, collision = false, aoe = false, type = "circular", danger = 4, type2 = "cc"}
		},
		["Blitzcrank"] = {
			[_Q] = { displayname = "Rocket Grab", name = "RocketGrab", objname = "RocketGrabMissile", speed = 1800, delay = 0.250, range = 900, width = 70, collision = true, type = "linear", danger = 4, type2 = "cc"},
			[_R] = { displayname = "Static Field", name = "StaticField", speed = math.huge, delay = 0.25, range = 0, width = 500, collision = false, aoe = false, type = "circular", danger = 3}
		},
		["Brand"] = {
			[_Q] = { displayname = "Sear", name = "BrandBlaze", objname = "BrandBlazeMissile", speed = 1200, delay = 0.25, range = 1050, width = 80, collision = false, aoe = false, type = "linear", danger = 3, type2 = "cc"},
			[_W] = { displayname = "Pillar of Flame", name = "BrandFissure", speed = math.huge, delay = 0.625, range = 1050, width = 275, collision = false, aoe = false, type = "circular", danger = 2},
			[_E] = { displayname = "Conflagration", name = "Conflagration", range = 625, danger = 1},
			[_R] = { displayname = "Pyroclasm", name = "BrandWildfire", range = 750, danger = 4, type2 = "nuke"}
		},
		["Braum"] = {
			[_Q] = { displayname = "Winter's Bite", name = "BraumQ", objname = "BraumQMissile", speed = 1600, delay = 0.25, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_R] = { displayname = "Glacial Fissure", name = "BraumR", objname = "braumrmissile", speed = 1250, delay = 0.5, range = 1250, width = 0, collision = false, aoe = false, type = "linear", danger = 5, type2 = "cc"}
		},
		["Caitlyn"] = {
			[_Q] = { displayname = "Piltover Peacemaker", name = "CaitlynPiltoverPeacemaker", objname = "CaitlynPiltoverPeacemaker", speed = 2200, delay = 0.625, range = 1300, width = 0, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "90 Caliber Net", name = "CaitlynEntrapment", objname = "CaitlynEntrapmentMissile",speed = 2000, delay = 0.400, range = 1000, width = 80, collision = false, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "Ace in the Hole", name = "CaitlynAceintheHole", danger = 4, type2 = "nuke"}
		},
		["Cassiopeia"] = {
			[_Q] = { displayname = "Noxious Blast", name = "CassiopeiaNoxiousBlast", objname = "CassiopeiaNoxiousBlast", speed = math.huge, delay = 0.75, range = 850, width = 100, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { displayname = "Miasma", name = "CassiopeiaMiasma", speed = 2500, delay = 0.5, range = 925, width = 90, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { displayname = "Twin Fang", name = "CassiopeiaTwinFang", range = 700, danger = 2},
			[_R] = { displayname = "Petrifying Gaze", name = "CassiopeiaPetrifyingGaze", objname = "CassiopeiaPetrifyingGaze", speed = math.huge, delay = 0.5, range = 825, width = 410, collision = false, aoe = true, type = "cone", danger = 5, type2 = "cc"}
		},
		["Chogath"] = {
			[_Q] = { displayname = "Rupture", name = "Rupture", objname = "Rupture", speed = math.huge, delay = 0.25, range = 950, width = 300, collision = false, aoe = true, type = "circular", danger = 3, type2 = "cc"},
			[_W] = { displayname = "Feral Scream", name = "FeralScream", speed = math.huge, delay = 0.5, range = 650, width = 275, collision = false, aoe = false, type = "linear", danger = 2},
			[_R] = { name = "", danger = 4, type2 = "nuke"}
		},
		["Corki"] = {
			[_Q] = { displayname = "Phosphorus Bomb", name = "PhosphorusBomb", objname = "PhosphorusBombMissile", speed = 700, delay = 0.4, range = 825, width = 250, collision = false, aoe = false, type = "circular", danger = 2},
			[_R] = { displayname = "Missile Barrage", name = "MissileBarrage", objname = "MissileBarrageMissile", speed = 2000, delay = 0.200, range = 1300, width = 60, collision = false, aoe = false, type = "linear",danger = 2},
			[-4]  = {displayname = "Missile Barrage Big", name = "MissileBarrageBig", objname = "MissileBarrageMissile2", speed = 2000, delay = 0.200, range = 1500, width = 80, collision = false, aoe = false, type = "linear", danger = 3},
		},
		["Darius"] = {
			[_Q] = { displayname = "Decimate", name = "DariusCleave", objname = "DariusCleave", speed = math.huge, delay = 0.75, range = 450, width = 450, type = "circular", danger = 3},
			[_W] = { displayname = "Crippling Strike", name = "DariusNoxianTacticsONH", range = 275, danger = 2},
			[_E] = { displayname = "Apprehend", name = "DariusAxeGrabCone", objname = "DariusAxeGrabCone", speed = math.huge, delay = 0.32, range = 570, width = 125, danger = 4, type = "cone"},
			[_R] = { displayname = "Noxian Guillotine", name = "DariusExecute", range = 460, danger = 4, type2 = "nuke"}
		},
		["Diana"] = {
			[_Q] = { displayname = "Crescent Strike", name = "DianaArc", objname = "DianaArcArc", speed = 1600, delay = 0.250, range = 835, width = 130, collision = false, aoe = false, type = "circular", danger = 3},
			[_W] = { displayname = "Pale Cascade", name = "PaleCascade", range = 250, danger = 1},
			[_E] = { displayname = "Moonfall", name = "DianaVortex", speed = math.huge, delay = 0.33, range = 0, width = 395, collision = false, aoe = false, type = "circular", danger = 3, type2 = "cc"},
			[_R] = { displayname = "Lunar Rush", name = "LunarRush", range = 825, danger = 4, type2 = "gc"}
		},
		["DrMundo"] = {
			[_Q] = { displayname = "Infected Cleaver", name = "InfectedCleaverMissile", objname = "InfectedCleaverMissile", speed = 2000, delay = 0.250, range = 1050, width = 75, collision = true, aoe = false, type = "linear", danger = 2}
		},
		["Draven"] = {
			[_E] = { displayname = "Stand Aside", name = "DravenDoubleShot", objname = "DravenDoubleShotMissile", speed = 1600, delay = 0.250, range = 1100, width = 130, collision = false, aoe = false, type = "linear", danger = 2, type2 = "cc"},
			[_R] = { displayname = "Whirling Death", name = "DravenRCast", objname = "DravenR", speed = 2000, delay = 0.5, range = 25000, width = 160, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Ekko"] = {
			[_Q] = { displayname = "Timewinder", name = "EkkoQ", objname = "ekkoqmis", speed = 1050, delay = 0.25, range = 925, width = 140, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Parallel Convergence", name = "EkkoW", objname = "EkkoW", speed = math.huge, delay = 3.25, range = 1600, width = 450, collision = false, aoe = true, type = "circular", danger = 3},
			[_E] = { displayname = "Phase Dive", name = "EkkoE", delay = 0.50, range = 350, danger = 1},
			[_R] = { displayname = "Chronobreak", name = "EkkoR", objname = "EkkoR", speed = math.huge, delay = 0.5, range = 0, width = 400, collision = false, aoe = true, type = "circular", danger = 4}
		},
		["Elise"] = {
			[_E] = { displayname = "Cocoon", name = "EliseHumanE", objname = "EliseHumanE", speed = 1450, delay = 0.250, range = 975, width = 70, collision = true, aoe = false, type = "linear", danger = 3, type2 = "cc"}
		},
		["Evelynn"] = {
			[_R] = { displayname = "Agony's Embrace", name = "EvelynnR", objname = "EvelynnR", speed = 1300, delay = 0.250, range = 650, width = 350, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Ezreal"] = {
			[_Q] = { displayname = "Mystic Shot", name = "EzrealMysticShot", objname = "EzrealMysticShotMissile", speed = 2000, delay = 0.25, range = 1200, width = 65, collision = true, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Essence Flux", name = "EzrealEssenceFlux", objname = "EzrealEssenceFluxMissile", speed = 1200, delay = 0.25, range = 900, width = 90, collision = false, aoe = false, type = "linear", danger = 1},
			--[_E] = { displayname = "Arcane Shift", name = "EzrealArcaneShift", range = 450},
			[_R] = { displayname = "Trueshot Barrage", name = "EzrealTrueshotBarrage", objname = "EzrealTrueshotBarrage", speed = 2000, delay = 1, range = 25000, width = 180, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Fiddlesticks"] = {
			[_Q] = { displayname = "Terrify", name = "Terrify", speed = math.huge, delay = 0.1, range = 575 , width = 65, collision = false, aoe = false, danger = 2, type2 = "cc"},
		},
		["Fiora"] = {
		},
		["Fizz"] = {
			[_R] = { displayname = "Chum the Waters", name = "FizzMarinerDoom", objname = "FizzMarinerDoomMissile", speed = 1350, delay = 0.250, range = 1150, width = 100, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Galio"] = {
			[_Q] = { displayname = "Resolute Smite", name = "GalioResoluteSmite", objname = "GalioResoluteSmite", speed = 1300, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular", danger = 3},
			[_E] = { displayname = "Righteous Gust", name = "GalioRighteousGust", speed = 1200, delay = 0.25, range = 1000, width = 200, collision = false, aoe = false, type = "linear", danger = 1}
		},
		["Gangplank"] = {
			[_Q] = { displayname = "Parrrley", name = "GangplankQWrapper", range = 900, danger = 2},
			--[_E] = { displayname = "Powder Keg", name = "GangplankE", speed = math.huge, delay = 0.25, range = 900, width = 250, collision = false, aoe = true, type = "circular", danger = },
			[_R] = { displayname = "Cannon Barrage", name = "GangplankR", speed = math.huge, delay = 0.25, range = 25000, width = 575, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Garen"] = {
			[_R] = { displayname = "Demacian Justice", name = "GarenR", range = 400, danger = 4, type2 = "nuke"},
		},
		["Gnar"] = {
			[_Q] = { displayname = "Boomerang Throw", name = "GnarQ", objname = "gnarqmissile", speed = 1225, delay = 0.125, range = 1200, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Boomerang Throw Return", name = "GnarQReturn", objname = "GnarQMissileReturn", speed = 1225, delay = 0, range = 2500, width = 75, collision = false, aoe = false, type = "linear", danger = 2},
			[-2] = { displayname = "Boulder Toss", name = "GnarBigQ", speed = 2100, delay = 0,5, range = 2500, width = 90, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Wallop", name = "GnarBigW", objname = "GnarBigW", speed = math.huge, delay = 0.6, range = 600, width = 80, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Hop", name = "GnarE", objname = "GnarE", speed = 900, delay = 0, range = 475, width = 150, collision = false, aoe = false, type = "circular", danger = 2, type2 = "gc"},
			[-5] = { displayname = "Crunch", name = "gnarbige", speed = 800, delay = 0, range = 475, width = 100, collision = false, aoe = false, type = "circular", danger = 2, type2 = "cc"},
			[_R] = { displayname = "GNAR!", name = "GnarR", speed = math.huge, delay = 250, range = 500, width = 500, collision = false, aoe = false, type = "circular", danger = 5, type2 = "cc"}
		},
		["Gragas"] = {
			[_Q] = { displayname = "Barrel Roll", name = "GragasQ", objname = "GragasQMissile", speed = 1000, delay = 0.250, range = 1000, width = 300, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { displayname = "Body Slam", name = "GragasE", objname = "GragasE", speed = math.huge, delay = 0.250, range = 600, width = 50, collision = true, aoe = true, type = "circular", danger = 3, type2 = "gc"},
			[_R] = { displayname = "Explosive Cask", name = "GragasR", objname = "GragasRBoom", speed = 1000, delay = 0.250, range = 1050, width = 400, collision = false, aoe = true, type = "circular", danger = 4, type2 = "cc"}
		},
		["Graves"] = {
			[_Q] = { displayname = "End of the Line", name = "GravesQLineSpell", objname = "GravesQLineMis", speed = 1950, delay = 0.265, range = 750, width = 85, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Smoke Screen", name = "GravesSmokeGrenade", speed = 1650, delay = 0.300, range = 700, width = 250, collision = false, aoe = true, type = "circular", danger = 1},
			[_R] = { displayname = "Collateral Damage", name = "GravesChargeShot", objname = "GravesChargeShotShot", speed = 2100, delay = 0.219, range = 1000, width = 100, collision = false, aoe = false, type = "linear", danger = 4}
		},
		["Hecarim"] = {
			[_Q] = { displayname = "Rampage", name = "HecarimRapidSlash", speed = math.huge, delay = 0.250, range = 0, width = 350, collision = false, aoe = true, type = "circular", danger = 2},
			[_R] = { displayname = "Onslaught of Shadows", name = "HecarimUlt", speed = 1900, delay = 0.219, range = 1000, width = 200, collision = false, aoe = false, type = "linear", danger = 4, type2 = "gc"}
		},
		["Heimerdinger"] = {
		--	[_Q] = { displayname = "H-28G Evolution Turret", name = "HeimerdingerTurretEnergyBlast", speed = 1650, delay = 0.25, range = 1000, width = 50, collision = false, aoe = false, type = "linear", danger = 0},
		--	[-1] = { displayname = "H-28Q Apex Turret", name = "HeimerdingerTurretBigEnergyBlast", speed = 1650, delay = 0.25, range = 1000, width = 75, collision = false, aoe = false, type = "linear"},
			[_W] = { displayname = "Hextech Micro-Rockets", name = "Heimerdingerwm", objname = "HeimerdingerWAttack2", speed = 1800, delay = 0.25, range = 1500, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "CH-2 Electron Storm Grenade", name = "HeimerdingerE", objname = "HeimerdingerESpell", speed = 1200, delay = 0.25, range = 925, width = 100, collision = false, aoe = true, type = "circular", danger = 3, type2 = "cc"}
		},
		["Illaoi"] = {
			[_Q] = { displayname = "Tentacle Smash", name = "IllaoiQ", objname = "", speed = math.huge, delay = 0.75, range = 850, width = 100, collision = false, aoe = true, type = "linear", danger = 2},
			[_E] = { displayname = "Test of Spirit", name = "IllaoiE", objname = "Illaoiemis", speed = 1900, delay = 0.25, range = 950, width = 50, collision = true, aoe = false, type = "linear", danger = 4},
			[_R] = { displayname = "Leap of Faith", name = "IllaoiR", objname = "", speed = math.huge, delay = 0.5, range = 0, width = 450, collision = false, aoe = true, type = "circular", danger = 5},
		},
		["Irelia"] = {
			[_E] = { displayname = "Irelia E", name = "IreliaEquilibriumStrike", danger = 3, type2 = "cc"},
			[_R] = { displayname = "Transcendent Blades", name = "IreliaTranscendentBlades", objname = "IreliaTranscendentBlades", speed = 1700, delay = 0.250, range = 1200, width = 25, collision = false, aoe = false, type = "linear", danger = 1}
		},
		["Janna"] = {
			[_Q] = { displayname = "Howling Gale", name = "HowlingGale", objname = "HowlingGaleSpell", speed = 1500, delay = 0.250, range = 1700, width = 150, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["JarvanIV"] = {
			[_Q] = { displayname = "Dragon Strike", name = "JarvanIVDragonStrike", speed = 1400, delay = 0.25, range = 770, width = 70, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Demacian Standard", name = "JarvanIVDemacianStandard", objname = "JarvanIVDemacianStandard", speed = 1450, delay = 0.25, range = 850, width = 175, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Jax"] = {
			[_E] = { displayname = "Counter Strike", name = "", speed = math.huge, delay = 1.05, range = 0, width = 375, collision = false, aoe = true, type = "circular", danger = 3, type2 = "cc"}
		},
		["Jayce"] = {
			[_Q] = { displayname = "Shock Blast", name = "jayceshockblast", objname = "JayceShockBlastMis", speed = 1450, delay = 0.15, range = 1750, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Shock Blast Acceleration", name = "JayceQAccel", objname = "JayceShockBlastWallMis", speed = 2350, delay = 0.15, range = 1300, width = 70, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["Jhin"] = {
			[_W] = { displayname = "Deadly Flourish", name = "JhinW", objname = "JhinWMissile", speed = 5000, delay = 0.75, range = 2500, width = 40, collision = true, aoe = false, type = "linear", danger = 2, type2 = "cc"},
			[_R] = { displayname = "Curtain Call", name = "JhinR", objname = "JhinRShotMis", speed = 5000, delay = 0.25, range = 3000, width = 80, collision = true, aoe = false, type = "linear", danger = 3},
		},
		["Jinx"] = {
			[_W] = { displayname = "Zap!", name = "JinxW", objname = "JinxWMissile", speed = 3000, delay = 0.600, range = 1400, width = 60, collision = true, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Flame Chompers!", name = "JinxE", speed = 887, delay = 0.500, range = 830, width = 0, collision = false, aoe = true, type = "circular", danger = 3},
			[_R] = { displayname = "Super Mega Death Rocket!", name = "JinxR", objname = "JinxR", speed = 1700, delay = 0.600, range = 20000, width = 140, collision = false, aoe = true, type = "linear", danger = 4, type2 = "nuke"}
		},
		["Kalista"] = {
			[_Q] = { displayname = "Pierce", name = "KalistaMysticShot", objname = "kalistamysticshotmis", speed = 1700, delay = 0.25, range = 1150, width = 40, collision = true, aoe = false, type = "linear", danger = 2},
		},
		["Karma"] = {
			[_Q] = { displayname = "Inner Flame", name = "KarmaQ", objname = "KarmaQMissile", speed = 1700, delay = 0.25, range = 1050, width = 60, collision = true, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Soulflare", name = "KarmaQMantra", objname = "KarmaQMissileMantra", speed = 1700, delay = 0.25, range = 950, width = 80, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["Karthus"] = {
			[_Q] = { displayname = "Lay Waste", name = "KarthusLayWaste", speed = math.huge, delay = 0.775, range = 875, width = 160, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { displayname = "Wall of Pain", name = "KarthusWallOfPain", speed = math.huge, delay = 0.25, range = 1000, width = 160, collision = false, aoe = true, type = "circular", danger = 1},
			[_R] = { displayname = "Requiem", name = "KarthusFallenOne", range = math.huge, delay = 3, danger = 5, type2 = "nuke"}
		},
		["Kassadin"] = {
			[_E] = { displayname = "ForcePulse", name = "ForcePulse", speed = 2200, delay = 0.25, range = 650, width = 80, collision = false, aoe = false, type = "cone", danger = 3},
			[_R] = { displayname = "Riftwalk", name = "RiftWalk", objname = "RiftWalk", speed = math.huge, delay = 0.5, range = 500, width = 150, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Katarina"] = {
			[_Q] = { name ="", danger = 2},
		},
		["Kayle"] = {
			[_Q] = { name ="", danger = 3},
		},
		["Kennen"] = {
			[_Q] = { displayname = "Thundering Shuriken", name = "KennenShurikenHurlMissile1", speed = 1700, delay = 0.180, range = 1050, width = 70, collision = true, aoe = false, type = "linear", danger = 3}
		},
		["KhaZix"] = {
			[_W] = { displayname = "Void Spike", name = "KhazixW", objname = "KhazixWMissile", speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[-7] = { displayname = "Evolved Void Spike", name = "khazixwlong", objname = "KhazixWMissile", speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "Leap", name = "KhazixE", objname = "KhazixE", speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular", danger = 2, type2 = "gc"},
			[-5] = { displayname = "Evolved Leap", name = "KhazixE", objname = "KhazixE", speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular", danger = 2, type2 = "cc"}
		},
		["KogMaw"] = {
			[_Q] = { displayname = "Caustic Spittle", name = "KogMawQ", objname = "KogMawQ", speed = 1600, delay = 0.25, range = 975, width = 80, type = "linear", danger = 2},
			[_E] = { displayname = "Void Ooze", name = "KogMawVoidOoze", objname = "KogMawVoidOozeMissile", speed = 1200, delay = 0.25, range = 1200, width = 120, collision = false, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "Living Artillery", name = "KogMawLivingArtillery", objname = "KogMawLivingArtillery", speed = math.huge, delay = 1.1, range = 2200, width = 250, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["LeBlanc"] = {
			[_Q] = { displayname = "Sigil of Malice", range = 700, danger = 3},
			[_W] = { displayname = "Distortion", name = "LeblancSlide", objname = "LeblancSlide", speed = 1300, delay = 0.250, range = 600, width = 250, collision = false, aoe = false, type = "circular", danger = 2, type2 = "gc"},
			[_E] = { displayname = "Ethereal Chains", name = "LeblancSoulShackle", objname = "LeblancSoulShackle", speed = 1300, delay = 0.250, range = 950, width = 55, collision = true, aoe = false, type = "linear", danger = 3},
			[_R] = { displayname = "Mimic", range = 700, danger = 3}
		},
		["LeeSin"] = {
			[_Q] = { displayname = "Sonic Wave", name = "BlindMonkQOne", objname = "BlindMonkQOne", speed = 1750, delay = 0.25, range = 1000, width = 70, collision = true, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Tempest", name = "BlindMonkEOne", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = false, type = "circular", danger = 2},
			[_R] = { displayname = "Intervention", name = "Dragon's Rage", speed = 2000, delay = 0.25, range = 375, width = 150, collision = false, aoe = false, type = "linear", danger = 4, type2 = "nuke"}
		},
		["Leona"] = {
			[_E] = { displayname = "Zenith Blade", name = "LeonaZenithBlade", objname = "LeonaZenithBladeMissile", speed = 2000, delay = 0.250, range = 875, width = 80, collision = false, aoe = false, type = "linear", danger = 3},
			[_R] = { displayname = "Solar Flare", name = "LeonaSolarFlare", objname = "LeonaSolarFlare", speed = 2000, delay = 0.250, range = 1200, width = 300, collision = false, aoe = true, type = "circular", danger = 4, type2 = "cc"}
		},
		["Lissandra"] = {
			[_Q] = { displayname = "Ice Shard", name = "LissandraQ", objname = "LissandraQMissile", speed = 2200, delay = 0.25, range = 700, width = 75, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Ice Shard Shattered", name = "LissandraQShards", objname = "lissandraqshards", speed = 2200, delay = 0.25, range = 700, width = 90, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "Glacial Path", name = "LissandraE", objname = "LissandraEMissile", speed = 850, delay = 0.25, range = 1025, width = 125, collision = false, aoe = false, type = "linear", danger = 2},
		},
		["Lucian"] = {
			[_Q] = { displayname = "Piercing Light", name = "LucianQ", objname = "LucianQ", speed = math.huge, delay = 0.5, range = 1300, width = 65, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { displayname = "Ardent Blaze", name = "LucianW", objname = "lucianwmissile", speed = 800, delay = 0.3, range = 1000, width = 80, collision = true, aoe = false, type = "linear", danger = 1},
			[_R] = { displayname = "The Culling", name = "LucianRMis", objname = "lucianrmissileoffhand", speed = 2800, delay = 0.5, range = 1400, width = 110, collision = true, aoe = false, type = "linear", danger = 2},
			[-6] = { displayname = "The Culling 2", name = "LucianRMis", objname = "lucianrmissile", speed = 2800, delay = 0.5, range = 1400, width = 110, collision = true, aoe = false, type = "linear", danger = 2}
		},
		["Lulu"] = {
			[_Q] = { displayname = "Glitterlance", name = "LuluQ", objname = "LuluQMissile", speed = 1500, delay = 0.25, range = 950, width = 60, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { displayname = "Glitterlance (Pix)", name = "LuluQPix", objname = "LuluQMissileTwo", speed = 1450, delay = 0.25, range = 950, width = 60, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Lux"] = {
			[_Q] = { displayname = "Light Binding", name = "LuxLightBinding", objname = "LuxLightBindingMis", speed = 1200, delay = 0.25, range = 1300, width = 130, collision = true, type = "linear", danger = 3, type2 = "cc"},
			[_E] = { displayname = "Lucent Singularity", name = "LuxLightStrikeKugel", objname = "LuxLightStrikeKugel", speed = 1300, delay = 0.25, range = 1100, width = 345, collision = false, type = "circular", danger = 4},
			[_R] = { displayname = "Final Spark", name = "LuxMaliceCannon", objname = "LuxMaliceCannon", speed = math.huge, delay = 1, range = 3340, width = 250, collision = false, type = "linear", danger = 4, type2 = "nuke"}
		},
		["Malphite"] = {
			[_R] = { displayname = "Unstoppable Force", name = "UFSlash", objname = "UFSlash", speed = 1600, delay = 0.5, range = 900, width = 500, collision = false, aoe = true, type = "circular", danger = 5, type2 = "cc"}
		},
		["Malzahar"] = {
			[_Q] = { displayname = "Call of the Void", name = "AlZaharCalloftheVoid", objname = "AlZaharCalloftheVoid", speed = math.huge, delay = 1, range = 900, width = 100, collision = false, aoe = false, type = "linear", danger = 3},
			--[_W] = { displayname = "Null Zone", name = "AlZaharNullZone", speed = math.huge, delay = 0.5, range = 800, width = 250, collision = false, aoe = false, type = "circular", danger = 1},
			[_R] = { displayname = "Nether Grasp", name = "AlZaharNetherGrasp", speed = math.huge, delay = 0, range = 700, danger = 5},

		},
		["Maokai"] = {
			[_W] = { name = "", speed = 2000, delay = .1, danger = 3, type2 = "5"},
			[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 600, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { displayname = "Sapling Toss", name = "", speed = 1500, delay = 0.25, range = 1100, width = 175, collision = false, aoe = false, type = "circular", danger = 2},
		},
		["MissFortune"] = {
			[_E] = { name = "MissFortuneScattershot", speed = math.huge, delay = 3.25, range = 800, width = 400, collision = false, aoe = true, type = "circular", danger = 1},
			[_R] = { displayname = "Bullet Time", name = "MissFortuneBulletTime", speed = math.huge, delay = 0.25, range = 1400, width = 700, collision = false, aoe = true, type = "cone", danger = 2}
		},
		["Mordekaiser"] = {
			[_E] = { name = "", speed = math.huge, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "cone", danger = 3}
		},
		["Morgana"] = {
			[_Q] = { displayname = "Dark Binding", name = "DarkBindingMissile", objname = "DarkBindingMissile", speed = 1200, delay = 0.250, range = 1300, width = 80, collision = true, aoe = false, type = "linear", danger = 3, type2 = "cc"}
		},
		["Nami"] = {
			[_Q] = { displayname = "Aqua Prison", name = "NamiQ", objname = "namiqmissile", speed = math.huge, delay = 0.95, range = 1625, width = 150, collision = false, aoe = true, type = "circular", danger = 3, type2 = "cc"},
			[_R] = { name = "NamiR", objname = "NamiRMissile", speed = 850, delay = 0.5, range = 2750, width = 260, collision = false, aoe = true, type = "linear", danger = 4, type2 = "cc"}
		},
		["Nasus"] = {
			[_W] = { displayname = "Wither", name = "", delay = 0.2, danger = 3, type2 = "cc"},
			[_E] = { name = "", speed = math.huge, delay = 0.25, range = 450, width = 250, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Nautilus"] = {
			[_Q] = { name = "NautilusAnchorDrag", objname = "NautilusAnchorDragMissile", speed = 2000, delay = 0.250, range = 1080, width = 80, collision = true, aoe = false, type = "linear", danger = 3, type2 = "cc"},
			[_R] = { name = "", speed = 1500, delay = .2, danger = 4, type2 = "cc"},
		},
		["Nidalee"] = {
			[_Q] = { displayname = "Javelin Toss", name = "JavelinToss", objname = "JavelinToss", speed = 1300, delay = 0.25, range = 1500, width = 40, collision = true, type = "linear", danger = 3}
		},
		["Nocturne"] = {
			[_Q] = { displayname = "Duskbringer", name = "NocturneDuskbringer", objname = "NocturneDuskbringer", speed = 1400, delay = 0.250, range = 1125, width = 80, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Olaf"] = {
			[_Q] = { name = "OlafAxeThrowCast", objname = "olafaxethrow", speed = 1600, delay = 0.25, range = 1000, width = 90, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { name = "", delay = .1, danger = 2},
		},
		["Orianna"] = {
			[_Q] = { name = "OriannasQ", objname = "orianaizuna", speed = 1200, delay = 0, range = 1500, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "OriannaQend", speed = 1200, delay = 0, range = 1500, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { name = "OrianaDissonanceCommand", objname = "OrianaDissonanceCommand", speed = math.huge, delay = 0.25, range = 0, width = 255, collision = false, aoe = true, type = "circular", danger = 2},
			[_R] = { name = "OrianaDetonateCommand", objname = "OrianaDetonateCommand", speed = math.huge, delay = 0.250, range = 0, width = 410, collision = false, aoe = true, type = "circular", danger = 5, type2 = "cc"}
		},
		["Pantheon"] = {
			[_Q] = { name = "", speed = 1500, delay = .15, danger = 2},
			[_E] = { name = "", speed = math.huge, delay = 0.250, range = 400, width = 100, collision = false, aoe = true, type = "cone", danger = 2},
		},
		["Quinn"] = {
			[_Q] = { name = "QuinnQ", objname = "QuinnQ", speed = 1550, delay = 0.25, range = 1050, width = 80, collision = true, aoe = true, type = "linear", danger = 3}
		},
		["RekSai"] = {
			[_Q] = { name = "reksaiqburrowed", objname = "RekSaiQBurrowedMis", speed = 1550, delay = 0.25, range = 1050, width = 180, collision = true, aoe = false, type = "linear", danger = 1}
		},
		["Renekton"] = {
			[_Q] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 450, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "", speed = 1225, delay = 0.25, range = 450, width = 150, collision = false, aoe = false, type = "linear", danger = 2, type2 = "gc"}
		},
		["Rengar"] = {
			[_W] = { name = "RengarW", speed = math.huge, delay = 0.25, range = 0, width = 490, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { name = "RengarE", objname = "RengarEFinal", speed = 1225, delay = 0.25, range = 1000, width = 80, collision = true, aoe = false, type = "linear", danger = 3},
		},
		["Riven"] = {
			[_Q] = { name = "RivenTriCleave", speed = math.huge, delay = 0.250, range = 310, width = 225, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { name = "RivenMartyr", speed = math.huge, delay = 0.250, range = 0, width = 265, collision = false, aoe = true, type = "circular", danger = 3},
			[_R] = { name = "rivenizunablade", objname = "RivenLightsaberMissile", speed = 2200, delay = 0.5, range = 1100, width = 200, collision = false, aoe = false, type = "cone", ranger = 5, type2 = "nuke"}
		},
		["Rumble"] = {
			[_Q] = { name = "RumbleFlameThrower", speed = math.huge, delay = 0.250, range = 600, width = 500, collision = false, aoe = false, type = "cone", danger = 1},
			[_E] = { name = "RumbleGrenade", objname = "RumbleGrenade", speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear", danger = 2},
			[_R] = { name = "RumbleCarpetBombM", objname = "RumbleCarpetBombMissile", speed = 1200, delay = 0.250, range = 1700, width = 90, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Ryze"] = {
			[_Q] = { name = "RyzeQ", objname = "RyzeQ", speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "ryzerq", objname = "ryzerq", speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear", danger = 2}
		},
		["Sejuani"] = {
			[_Q] = { name = "SejuaniArcticAssault", speed = 1600, delay = 0, range = 900, width = 70, collision = true, aoe = false, type = "linear", danger = 3, type2 = "gc"},
			[_R] = { name = "SejuaniGlacialPrisonStart", objname = "sejuaniglacialprison", speed = 1600, delay = 0.25, range = 1200, width = 110, collision = false, aoe = false, type = "linear", danger = 5}
		},
		["Shen"] = {
			[_E] = { name = "ShenShadowDash", objname = "ShenShadowDash", speed = 1200, delay = 0.25, range = 600, width = 40, collision = false, aoe = false, type = "linear", danger = 4, type2 = "gc"}
		},
		["Shyvana"] = {
			[_E] = { name = "ShyvanaFireball", objname = "ShyvanaFireballMissile", speed = 1500, delay = 0.250, range = 925, width = 60, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Sivir"] = {
			[_Q] = { name = "SivirQ", objname = "SivirQMissile", speed = 1330, delay = 0.250, range = 1075, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "SivirQReturn", objname = "SivirQMissileReturn", speed = 1330, delay = 0.250, range = 1075, width = 0, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Skarner"] = {
			[_E] = { name = "SkarnerFracture", objname = "SkarnerFractureMissile", speed = 1200, delay = 0.600, range = 350, width = 60, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Sona"] = {
			[_R] = { displayname = "Cresendo", name = "SonaR", objname = "SonaR", speed = 2400, delay = 0.5, range = 900, width = 160, collision = false, aoe = false, type = "linear", danger = 5, type2 = "cc"}
		},
		["Soraka"] = {
			[_Q] = { displayname = "Starcall", name = "SorakaQ", speed = 1000, delay = 0.25, range = 900, width = 260, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "SorakaE", speed = math.huge, delay = 1.75, range = 900, width = 310, collision = false, aoe = true, type = "circular", danger = 1}
		},
		["Swain"] = {
			[_W] = { name = "SwainShadowGrasp", objname = "SwainShadowGrasp", speed = math.huge, delay = 0.850, range = 900, width = 125, collision = false, aoe = true, type = "circular", danger = 3, type2 = "cc"}
		},
		["Syndra"] = {
			[_Q] = { name = "SyndraQ", objname = "SyndraQ", speed = math.huge, delay = 0.67, range = 790, width = 125, collision = false, aoe = true, type = "circular", danger = 2},
			[_W] = { name = "syndrawcast", objname = "syndrawcast" ,speed = math.huge, delay = 0.8, range = 925, width = 190, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "SyndraE", objname = "SyndraE", speed = 2500, delay = 0.25, range = 730, width = 45, collision = false, aoe = true, type = "cone", danger = 3, type2 = "cc"},
			[_R] = { danger = 5, type2 = "nuke"},
		},
		["Talon"] = {
			[_W] = { name = "TalonRake", objname = "talonrakemissileone", speed = 900, delay = 0.25, range = 600, width = 200, collision = false, aoe = false, type = "cone", danger = 3},
			[_R] = { name = "", speed = math.huge, delay = 0.25, range = 0, width = 650, collision = false, aoe = false, type = "circular", danger = 4, type2 = "nuke"}
		},
		["Taric"] = {
			[_E] = { name = "TaricE", speed = math.huge, delay = 1, range = 650, width = 300, collision = false, aoe = false, type = "circular", danger = 3}
		},
		["Teemo"] = {
			[_Q] = { name = "", danger = 3}
		},
		["Thresh"] = {
			[_Q] = { displayname = "Death Sentence", name = "ThreshQ", objname = "ThreshQMissile", speed = 1825, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear", danger = 3},
			[_E] = { displayname = "Flay", name = "ThreshE", objname = "ThreshEMissile1", speed = 2000, delay = 0.25, range = 450, width = 110, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["TahmKench"] = {
			[_Q] = { displayname = "Tongue Lash", name = "TahmKenchQ", objname = "TahmkenchQMissile", speed = 2000, delay = 0.25, range = 951, width = 70, collision = true, aoe = false, type = "linear", danger = 3},
		},
		["Tristana"] = {
			[_W] = { displayname = "Rocket Jump", name = "RocketJump", objname = "RocketJump", speed = 2100, delay = 0.25, range = 900, width = 125, collision = false, aoe = false, type = "circular", danger = 2}
		},
		["Trundle"] = {
			[_R] = { name = "", danger = 3},
		},
		["Tryndamere"] = {
			[_E] = { name = "slashCast", objname = "slashCast", speed = 1500, delay = 0.250, range = 650, width = 160, collision = false, aoe = false, type = "linear", danger = 2, type2 = "gc"}
		},
		["TwistedFate"] = {
			[_Q] = { displayname = "WildCards", name = "WildCards", objname = "SealFateMissile", speed = 1500, delay = 0.250, range = 1200, width = 80, collision = false, aoe = false, type = "linear"},
			[_W] = { displayname = "Gold Card", name = "goldcardpreattack", danger = 3, type2 = "cc"}
		},
		["Twitch"] = {
			[_W] = { name = "TwitchVenomCask", objname = "TwitchVenomCaskMissile", speed = 1750, delay = 0.250, range = 950, width = 275, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Urgot"] = {
			[_Q] = { name = "UrgotHeatseekingLineMissile", objname = "UrgotHeatseekingLineMissile", speed = 1575, delay = 0.175, range = 1000, width = 80, collision = true, aoe = false, type = "linear", danger = 2},
			[_E] = { name = "UrgotPlasmaGrenade", objname = "UrgotPlasmaGrenadeBoom", speed = 1750, delay = 0.25, range = 890, width = 200, collision = false, aoe = true, type = "circular", danger = 3},
			[-9] = { name = "UrgotHeatseekingHomeMissile", speed = 1575, delay = 0.175, range = 1200, width = 80, collision = false, aoe = false, danger = 2},
		},
		["Varus"] = {
			[_Q] = { displayname = "Piercing Arrow", name = "VarusQMissilee", objname = "VarusQMissile", speed = 1500, delay = 0.5, range = 1475, width = 100, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { name = "VarusE", objname = "VarusE", speed = 1750, delay = 0.25, range = 925, width = 235, collision = false, aoe = true, type = "circular", danger = 2},
			[_R] = { displayname = "Chains of Corruption" ,name = "VarusR", objname = "VarusRMissile", speed = 1200, delay = 0.5, range = 800, width = 100, collision = false, aoe = false, type = "linear", danger = 4, type2 = "cc"}
		},
		["Vayne"] = {
		},
		["Veigar"] = {
			[_Q] = { displayname = "Baleful Strike", name = "VeigarBalefulStrike", objname = "VeigarBalefulStrikeMis", speed = 1200, delay = 0.25, range = 900, width = 70, collision = true, aoe = false, type = "linear"},
			[_W] = { displayname = "Dark Matter",name = "VeigarDarkMatter", speed = math.huge, delay = 1.2, range = 900, width = 225, collision = false, aoe = false, type = "circular"},
			[_E] = { displayname = "Event Horizon",name = "VeigarEvenHorizon", speed = math.huge, delay = 0.75, range = 725, width = 275, collision = false, aoe = false, type = "circular"},
			[_R] = { displayname = "Primordial Burst",name = "", danger = 5, type2 = "nuke"}
		},
		["Velkoz"] = {
			[_Q] = { name = "VelKozQ", objname = "VelkozQMissile", speed = 1300, delay = 0.25, range = 1100, width = 50, collision = true, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "VelkozQSplit", objname = "VelkozQMissileSplit", speed = 2100, delay = 0.25, range = 1100, width = 55, collision = true, aoe = false, type = "linear", danger = 2},
			[_W] = { name = "VelKozW", objname = "VelkozWMissile", speed = 1700, delay = 0.064, range = 1050, width = 80, collision = false, aoe = false, type = "linear", danger = 2},
			[_E] = { name = "VelKozE", objname = "VelkozEMissile", speed = 1500, delay = 0.333, range = 850, width = 225, collision = false, aoe = true, type = "circular", danger = 3, type2 = "cc"},
			[_R] = { name = "VelKozR", speed = math.huge, delay = 0.333, range = 1550, width = 50, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Vi"] = {
			[_Q] = { name = "Vi-q", objname = "ViQMissile", speed = 1500, delay = 0.25, range = 715, width = 55, collision = false, aoe = false, type = "linear", danger = 3}
		},
		["Viktor"] = {
			[_W] = { name = "ViktorGravitonField", speed = 750, delay = 0.6, range = 700, width = 125, collision = false, aoe = true, type = "circular", danger = 1},
			[_E] = { name = "Laser", objname = "ViktorDeathRayMissile", speed = 1200, delay = 0.25, range = 1200, width = 0, collision = false, aoe = false, type = "linear", danger = 2},
			[_R] = { name = "ViktorChaosStorm", speed = 1000, delay = 0.25, range = 700, width = 0, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Vladimir"] = {
			[_R] = { displayname = "Hemoplague" ,name = "VladimirR", speed = math.huge, delay = 0.25, range = 700, width = 175, collision = false, aoe = true, type = "circular", danger = 4}
		},
		["Xerath"] = {
			[_Q] = { name = "xeratharcanopulse2", objname = "xeratharcanopulse2", speed = math.huge, delay = 1.75, range = 750, width = 100, collision = false, aoe = false, type = "linear", danger = 2},
			[_W] = { name = "XerathArcaneBarrage2", objname = "XerathArcaneBarrage2", speed = math.huge, delay = 0.25, range = 1100, width = 100, collision = false, aoe = true, type = "circular", danger = 3},
			[_E] = { name = "XerathMageSpear", objname = "XerathMageSpearMissile", speed = 1600, delay = 0.25, range = 1050, width = 70, collision = true, aoe = false, type = "linear", danger = 4, type2 = "cc"},
			[_R] = { name = "xerathrmissilewrapper", objname = "xerathrmissilewrapper", speed = math.huge, delay = 0.75, range = 3200, width = 245, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["XinZhao"] = {
			[_R] = { name = "XenZhaoParry", speed = math.huge, delay = 0.25, range = 275, width = 375, collision = false, aoe = true, type = "circular", danger = 3, type2 = "cc"}
		},
		["Yasuo"] = {
			[_Q] = { name = "yasuoq", objname = "yasuoq", speed = math.huge, delay = 0.25, range = 475, width = 40, collision = false, aoe = false, type = "linear", danger = 2},
			[-1] = { name = "yasuoq2", objname = "yasuoq2", speed = math.huge, delay = 0.25, range = 475, width = 40, collision = false, aoe = false, type = "linear", danger = 2},
			[-2] = { name = "yasuoq3w", objname = "yasuoq3w", range = 1200, speed = 1200, delay = 0.125, width = 65, collision = false, aoe = false, type = "linear", danger = 3, type2 = "cc"}
		},
		["Yorick"] = {
			[_W] = { name = "YorickDecayed", speed = math.huge, delay = 0.25, range = 600, width = 175, collision = false, aoe = true, type = "circular", danger = 2},
		},
		["Zac"] = {
			[_Q] = { name = "ZacQ", objname = "ZacQ", speed = 2500, delay = 0.110, range = 500, width = 110, collision = false, aoe = false, type = "linear", danger = 2}
		},
		["Zed"] = {
			[_Q] = { name = "ZedQ", objname = "ZedQMissile", speed = 1700, delay = 0.25, range = 900, width = 50, collision = false, aoe = false, type = "linear", danger = 3},
			[_E] = { name = "ZedE", speed = math.huge, delay = 0.25, range = 0, width = 300, collision = false, aoe = true, type = "circular", danger = 2}
		},
		["Ziggs"] = {
			[_Q] = { name = "ZiggsQ", objname = "ZiggsQSpell", speed = 1750, delay = 0.25, range = 1400, width = 155, collision = true, aoe = false, type = "linear", danger = 3},
			[_W] = { name = "ZiggsW", objname = "ZiggsW", speed = 1800, delay = 0.25, range = 970, width = 275, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "ZiggsE", objname = "ZiggsE", speed = 1750, delay = 0.12, range = 900, width = 350, collision = false, aoe = true, type = "circular", danger = 1},
			[_R] = { name = "ZiggsR", objname = "ZiggsR", speed = 1750, delay = 0.14, range = 5300, width = 525, collision = false, aoe = true, type = "circular", danger = 4, type2 = "nuke"}
		},
		["Zilean"] = {
			[_Q] = { displayname = "Time Bomb", name = "ZileanQ", objname = "ZileanQMissile", speed = math.huge, delay = 0.5, range = 900, width = 150, collision = false, aoe = true, type = "circular", danger = 3}
		},
		["Zyra"] = {
			--[-8] = { name = "zyrapassivedeathmanager", objname = "zyrapassivedeathmanager", speed = 1900, delay = 0.5, range = 1475, width = 70, collision = false, aoe = false, type = "linear", danger = 3},
			[_Q] = { name = "ZyraQFissure", objname = "ZyraQFissure", speed = math.huge, delay = 0.7, range = 800, width = 85, collision = false, aoe = true, type = "circular", danger = 2},
			[_E] = { name = "ZyraGraspingRoots", objname = "ZyraGraspingRoots", speed = 1150, delay = 0.25, range = 1100, width = 200, collision = false, aoe = true, type = "linear", danger = 3, type2 = "cc"},
			[_R] = { name = "ZyraBrambleZone", speed = math.huge, delay = 1, range = 1100, width = 500, collision=false, aoe = true, type = "circular", danger = 4, type2 = "nuke"}
		}
	}
	--Table End
	
	SLS.SB:Menu("Spells", "Spells")
    SLS.SB:Slider("hV","Humanize Value",50,0,100,1)
    SLS.SB:Slider("wM","Width Mulitplicator",1.5,1,5,.1)
   
    DelayAction(function()
        for _,k in pairs(GetEnemyHeroes()) do
		 if self.s[GetObjectName(k)] then
          for m,p in pairs(self.s[GetObjectName(k)]) do
			if p.name == "" and GetCastName(k,m) then p.name = GetCastName(k,m) end
			if not p.type then p.type = "target" end
            if p and p.name ~= "" and p.type then
			  if not SLS.SB.Spells[GetObjectName(k)] then SLS.SB.Spells:Menu(GetObjectName(k), GetObjectName(k)) end
              SLS.SB.Spells[GetObjectName(k)]:Boolean(m, (self.str[m] or "?").. " - "..(p.displayname or p.name or "?"), true)
			  SLS.SB.Spells[GetObjectName(k)]:Slider("d"..m, (self.str[m] or "?").. " - Danger", (p.danger or 1), 1, 5, 1)
            end
		   end
          end
        end
	Callback.Add("ProcessSpell", function(unit, spellProc) self:Detect(unit, spellProc) end)
    end, .001)
 
    self.multi = 2
    self.fT = .75
    CollP = Vector(0,0,0)
   
	
end

function HitMe:Detect(unit, spellProc)
	if self.s[GetObjectName(unit)] and SLS.SB.uS:Value() and GetTeam(unit) == MINION_ENEMY then
		for d,i in pairs(self.s[GetObjectName(unit)]) do
			if SLS.SB.Spells[GetObjectName(unit)] and SLS.SB.Spells[GetObjectName(unit)][d] and SLS.SB.Spells[GetObjectName(unit)][d]:Value() and ((i.name and i.name:lower() == spellProc.name:lower()) or (i.name == "" and d >= 0 and GetCastName(unit,d) == spellProc.name)) and SLS.SB.Spells[GetObjectName(unit)]["d"..d] and SLS.SB.Spells[GetObjectName(unit)]["d"..d]:Value() >= SLS.SB.dV:Value() then
				i.speed = i.speed or math.huge
				i.range = i.range or math.huge
				i.delay = i.delay or 0
				i.width = i.width or 100
				i.radius = i.radius or i.width or math.huge	
				i.collision = i.collision or false
				i.danger = i.danger or 2
				i.type2 = i.type2 or nil
				
				self.fT = SLS.SB.hV:Value()
				self.multi = SLS.SB.wM:Value()
				
				if i.range*2 < GetDistance(myHero,spellProc.startPos) then return end
				
				--Simple Kappa Linear
				if i.type == "linear" or i.type == "cone" then
					local cPred = GetPrediction(myHero,i)
					local dT = i.delay + GetDistance(spellProc.startPos, cPred.castPos) / i.speed
					--print("Delay "..i.delay)
					--print("TravelTime "..GetDistance(spellProc.startPos, cPred.castPos) / i.speed)
					
					--Line-Line junction check
					local S1 = Vector(spellProc.startPos)
					local R1 = Vector(spellProc.endPos)
					
					local S2 = Vector(cPred.castPos + ((Vector(spellProc.endPos) - Vector(spellProc.startPos))*.5):perpendicular())
					local R2 = GetOrigin(myHero)
					
					CollP = Vector(VectorIntersection(S1,R1,S2,R2).x,spellProc.startPos.y, VectorIntersection(S1,R1,S2,R2).y)
					local d = GetDistance(Vector(CollP),cPred.castPos)
					--print("Distance "..math.floor(d).." ".. spellProc.name)
					--print("Time "..dT*self.fT)
					if (d<i.width*self.multi or GetDistance(myHero,CollP)<i.width*self.multi) --[[and (i.collision or not pI:mCollision(1))]] then
						_G[ChampName]:HitMe(unit,spellProc,dT*self.fT*.001,i.type2)
					end
				
				--Circular
				elseif i.type == "circular" then
					local cPred = GetCircularAOEPrediction(myHero, i)
					local dT = i.delay + GetDistance(myHero, cPred.castPos) / i.speed
					local R1 = Vector(spellProc.endPos)
					
					DelayAction( function()
						local d = GetDistance(Vector(R1),cPred.castPos)
						--print("Distance "..math.floor(d).." ".. spellProc.name)
						if d<i.radius*self.multi or GetDistance(myHero,spellProc.endPos)<i.radius*self.multi then
							_G[ChampName]:HitMe(unit,spellProc,dT*self.fT*.001,i.type2)
						end
					end, dT*self.fT*.001)
				
				--Targeted and Trash
				elseif spellProc.target and spellProc.target == myHero then
					local dT = i.delay + GetDistance(myHero, spellProc.startPos) / i.speed
					DelayAction( function()
						--print(spellProc.name.." Targeted")
						_G[ChampName]:HitMe(unit,spellProc,dT*self.fT*.001,i.type2)
					end, dT*self.fT*.001)
				else
					--print(spellProc.name.." Error")
				end
			end
		end
	end
end

class 'AntiChannel'

function AntiChannel:__init()
	self.CSpell = {
    ["CaitlynAceintheHole"]         = {charName = "Caitlyn"		},
    ["Crowstorm"]                   = {charName = "FiddleSticks"},
    ["Drain"]                       = {charName = "FiddleSticks"},
    ["GalioIdolOfDurand"]           = {charName = "Galio"		},
    ["ReapTheWhirlwind"]            = {charName = "Janna"		},
	["JhinR"]						= {charName = "Jhin"		},
    ["KarthusFallenOne"]            = {charName = "Karthus"     },
    ["KatarinaR"]                   = {charName = "Katarina"    },
    ["LucianR"]                     = {charName = "Lucian"		},
    ["AlZaharNetherGrasp"]          = {charName = "Malzahar"	},
    ["MissFortuneBulletTime"]       = {charName = "MissFortune"	},
    ["AbsoluteZero"]                = {charName = "Nunu"		},                       
    ["PantheonRJump"]               = {charName = "Pantheon"	},
    ["ShenStandUnited"]             = {charName = "Shen"		},
    ["Destiny"]                     = {charName = "TwistedFate"	},
    ["UrgotSwap2"]                  = {charName = "Urgot"		},
    ["VarusQ"]                      = {charName = "Varus"		},
    ["VelkozR"]                     = {charName = "Velkoz"		},
    ["InfiniteDuress"]              = {charName = "Warwick"		},
    ["XerathLocusOfPower2"]         = {charName = "Xerath"		},
	}
	
	DelayAction(function ()
		for _,i in pairs(GetEnemyHeroes()) do
			for _,n in pairs(self.CSpell) do
				if GetObjectName(i) == n.charName then
					if not BM["AC"] then
						BM:Menu("AC","AntiChannel")
						Callback.Add("ProcessSpell", function(unit,spellProc) self:Check(unit,spellProc) end)
					end
					if not BM.AC[GetObjectName(i)] then
						BM.AC:Boolean(GetObjectName(i),"Stop "..GetObjectName(i).." Channels", true)
					end
				end
			end
		end
	end, .001)
end

function AntiChannel:Check(unit,spellProc)
	if GetTeam(unit) == MINION_ENEMY and self.CSpell[spellProc.name] and BM.AC[GetObjectName(unit)]:Value() then
		_G[ChampName]:AntiChannel(unit,GetDistance(myHero,unit))
	end
end
