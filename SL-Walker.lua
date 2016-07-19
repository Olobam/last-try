local SLWAutoUpdate = true
local Stage, SLWalkerVer = "Alpha", "0.01"
local SLWPatchnew = nil
_G.SLWalkerLoaded = true
if GetGameVersion():sub(3,4) >= "10" then
		SLWPatchnew = GetGameVersion():sub(1,4)
	else
		SLWPatchnew = GetGameVersion():sub(1,3)
end

local function AllyMinionsAround(pos, range)
	local c = 0
	if pos == nil then return 0 end
	for k,v in pairs(minionManager.objects) do 
		if v and v.alive and GetDistanceSqr(pos,v) < range*range and v.team == myHero.team then
			c = c + 1
		end
	end
	return c
end

Callback.Add("Load", function()	
	OMenu = Menu("SL-Walker", "["..SLWPatchnew.."][v.:"..SLWalkerVer.."] SL-Walker")
	LoadSLW()
	SLWAutoUpdater()
	require 'DamageLib'
	PrintChat("<font color=\"#fd8b12\"><b>["..SLWPatchnew.."] [SL-Walker] v.: ["..Stage.." - "..SLWalkerVer.."] - <font color=\"#F2EE00\"> Loaded! </b></font>")
end)

class 'SLWalker'

function SLWalker:__init()
	self.aarange = myHero.range+myHero.boundingRadius*2
	self.attacksEnabled = true
	self.movementEnabled = true
	self.str = {[0]="Q",[1]="W",[2]="E",[3]="R"}
	self.LastAttack = 0
	self.windUpTime = 0
	self.animationTime = 0
	self.AttackDoneAt = 0
	self.BaseWindUp = 1
	self.BaseAttackSpeed = 1
	self.LastMoveOrder = 0
	self.ActiveAttacks = {}
	self.dmg = 0
	minionTar = {}
	self.projectilespeeds = {["Velkoz"]= 2000,["TeemoMushroom"] = math.huge,["TestCubeRender"] = math.huge ,["Xerath"] = 2000.0000 ,["Kassadin"] = math.huge ,["Rengar"] = math.huge ,["Thresh"] = 1000.0000 ,["Ziggs"] = 1500.0000 ,["ZyraPassive"] = 1500.0000 ,["ZyraThornPlant"] = 1500.0000 ,["KogMaw"] = 1800.0000 ,["HeimerTBlue"] = 1599.3999 ,["EliseSpider"] = 500.0000 ,["Skarner"] = 500.0000 ,["ChaosNexus"] = 500.0000 ,["Katarina"] = 467.0000 ,["Riven"] = 347.79999 ,["SightWard"] = 347.79999 ,["HeimerTYellow"] = 1599.3999 ,["Ashe"] = 2000.0000 ,["VisionWard"] = 2000.0000 ,["TT_NGolem2"] = math.huge ,["ThreshLantern"] = math.huge ,["TT_Spiderboss"] = math.huge ,["OrderNexus"] = math.huge ,["Soraka"] = 1000.0000 ,["Jinx"] = 2750.0000 ,["TestCubeRenderwCollision"] = 2750.0000 ,["Red_Minion_Wizard"] = 650.0000 ,["JarvanIV"] = 20.0000 ,["Blue_Minion_Wizard"] = 650.0000 ,["TT_ChaosTurret2"] = 1200.0000 ,["TT_ChaosTurret3"] = 1200.0000 ,["TT_ChaosTurret1"] = 1200.0000 ,["ChaosTurretGiant"] = 1200.0000 ,["Dragon"] = 1200.0000 ,["LuluSnowman"] = 1200.0000 ,["Worm"] = 1200.0000 ,["ChaosTurretWorm"] = 1200.0000 ,["TT_ChaosInhibitor"] = 1200.0000 ,["ChaosTurretNormal"] = 1200.0000 ,["AncientGolem"] = 500.0000 ,["ZyraGraspingPlant"] = 500.0000 ,["HA_AP_OrderTurret3"] = 1200.0000 ,["HA_AP_OrderTurret2"] = 1200.0000 ,["Tryndamere"] = 347.79999 ,["OrderTurretNormal2"] = 1200.0000 ,["Singed"] = 700.0000 ,["OrderInhibitor"] = 700.0000 ,["Diana"] = 347.79999 ,["HA_FB_HealthRelic"] = 347.79999 ,["TT_OrderInhibitor"] = 347.79999 ,["GreatWraith"] = 750.0000 ,["Yasuo"] = 347.79999 ,["OrderTurretDragon"] = 1200.0000 ,["OrderTurretNormal"] = 1200.0000 ,["LizardElder"] = 500.0000 ,["HA_AP_ChaosTurret"] = 1200.0000 ,["Ahri"] = 1750.0000 ,["Lulu"] = 1450.0000 ,["ChaosInhibitor"] = 1450.0000 ,["HA_AP_ChaosTurret3"] = 1200.0000 ,["HA_AP_ChaosTurret2"] = 1200.0000 ,["ChaosTurretWorm2"] = 1200.0000 ,["TT_OrderTurret1"] = 1200.0000 ,["TT_OrderTurret2"] = 1200.0000 ,["TT_OrderTurret3"] = 1200.0000 ,["LuluFaerie"] = 1200.0000 ,["HA_AP_OrderTurret"] = 1200.0000 ,["OrderTurretAngel"] = 1200.0000 ,["YellowTrinketUpgrade"] = 1200.0000 ,["MasterYi"] = math.huge ,["Lissandra"] = 2000.0000 ,["ARAMOrderTurretNexus"] = 1200.0000 ,["Draven"] = 1700.0000 ,["FiddleSticks"] = 1750.0000 ,["SmallGolem"] = math.huge ,["ARAMOrderTurretFront"] = 1200.0000 ,["ChaosTurretTutorial"] = 1200.0000 ,["NasusUlt"] = 1200.0000 ,["Maokai"] = math.huge ,["Wraith"] = 750.0000 ,["Wolf"] = math.huge ,["Sivir"] = 1750.0000 ,["Corki"] = 2000.0000 ,["Janna"] = 1200.0000 ,["Nasus"] = math.huge ,["Golem"] = math.huge ,["ARAMChaosTurretFront"] = 1200.0000 ,["ARAMOrderTurretInhib"] = 1200.0000 ,["LeeSin"] = math.huge ,["HA_AP_ChaosTurretTutorial"] = 1200.0000 ,["GiantWolf"] = math.huge ,["HA_AP_OrderTurretTutorial"] = 1200.0000 ,["YoungLizard"] = 750.0000 ,["Jax"] = 400.0000 ,["LesserWraith"] = math.huge ,["Blitzcrank"] = math.huge ,["ARAMChaosTurretInhib"] = 1200.0000 ,["Shen"] = 400.0000 ,["Nocturne"] = math.huge ,["Sona"] = 1500.0000 ,["ARAMChaosTurretNexus"] = 1200.0000 ,["YellowTrinket"] = 1200.0000 ,["OrderTurretTutorial"] = 1200.0000 ,["Caitlyn"] = 2500.0000 ,["Trundle"] = 347.79999 ,["Malphite"] = 1000.0000 ,["Mordekaiser"] = math.huge ,["ZyraSeed"] = math.huge ,["Vi"] = 1000.0000 ,["Tutorial_Red_Minion_Wizard"] = 650.0000 ,["Renekton"] = math.huge ,["Anivia"] = 1400.0000 ,["Fizz"] = math.huge ,["Heimerdinger"] = 1500.0000 ,["Evelynn"] = 467.0000 ,["Rumble"] = 347.79999 ,["Leblanc"] = 1700.0000 ,["Darius"] = math.huge ,["OlafAxe"] = math.huge ,["Viktor"] = 2300.0000 ,["XinZhao"] = 20.0000 ,["Orianna"] = 1450.0000 ,["Vladimir"] = 1400.0000 ,["Nidalee"] = 1750.0000 ,["Tutorial_Red_Minion_Basic"] = math.huge ,["ZedShadow"] = 467.0000 ,["Syndra"] = 1800.0000 ,["Zac"] = 1000.0000 ,["Olaf"] = 347.79999 ,["Veigar"] = 1100.0000 ,["Twitch"] = 2500.0000 ,["Alistar"] = math.huge ,["Akali"] = 467.0000 ,["Urgot"] = 1300.0000 ,["Leona"] = 347.79999 ,["Talon"] = math.huge ,["Karma"] = 1500.0000 ,["Jayce"] = 347.79999 ,["Galio"] = 1000.0000 ,["Shaco"] = math.huge ,["Taric"] = math.huge ,["TwistedFate"] = 1500.0000 ,["Varus"] = 2000.0000 ,["Garen"] = 347.79999 ,["Swain"] = 1600.0000 ,["Vayne"] = 2000.0000 ,["Fiora"] = 467.0000 ,["Quinn"] = 2000.0000 ,["Kayle"] = math.huge ,["Blue_Minion_Basic"] = math.huge ,["Brand"] = 2000.0000 ,["Teemo"] = 1300.0000 ,["Amumu"] = 500.0000 ,["Annie"] = 1200.0000 ,["Odin_Blue_Minion_caster"] = 1200.0000 ,["Elise"] = 1600.0000 ,["Nami"] = 1500.0000 ,["Poppy"] = 500.0000 ,["AniviaEgg"] = 500.0000 ,["Tristana"] = 2250.0000 ,["Graves"] = 3000.0000 ,["Morgana"] = 1600.0000 ,["Gragas"] = math.huge ,["MissFortune"] = 2000.0000 ,["Warwick"] = math.huge ,["Cassiopeia"] = 1200.0000 ,["Tutorial_Blue_Minion_Wizard"] = 650.0000 ,["DrMundo"] = math.huge ,["Volibear"] = 467.0000 ,["Irelia"] = 467.0000 ,["Odin_Red_Minion_Caster"] = 650.0000 ,["Lucian"] = 2800.0000 ,["Yorick"] = math.huge ,["RammusPB"] = math.huge ,["Red_Minion_Basic"] = math.huge ,["Udyr"] = 467.0000 ,["MonkeyKing"] = 20.0000 ,["Tutorial_Blue_Minion_Basic"] = math.huge ,["Kennen"] = 1600.0000 ,["Nunu"] = 500.0000 ,["Ryze"] = 2400.0000 ,["Zed"] = 467.0000 ,["Nautilus"] = 1000.0000 ,["Gangplank"] = 1000.0000 ,["Lux"] = 1600.0000 ,["Sejuani"] = 500.0000 ,["Ezreal"] = 2000.0000 ,["OdinNeutralGuardian"] = 1800.0000 ,["Khazix"] = 500.0000 ,["Sion"] = math.huge ,["Aatrox"] = 347.79999 ,["Hecarim"] = 500.0000 ,["Pantheon"] = 20.0000 ,["Shyvana"] = 467.0000 ,["Zyra"] = 1700.0000 ,["Karthus"] = 1200.0000 ,["Rammus"] = math.huge ,["Zilean"] = 1200.0000 ,["Chogath"] = 500.0000 ,["Malzahar"] = 2000.0000 ,["YorickRavenousGhoul"] = 347.79999 ,["YorickSpectralGhoul"] = 347.79999 ,["JinxMine"] = 347.79999 ,["YorickDecayedGhoul"] = 347.79999 ,["XerathArcaneBarrageLauncher"] = 347.79999 ,["Odin_SOG_Order_Crystal"] = 347.79999 ,["TestCube"] = 347.79999 ,["ShyvanaDragon"] = math.huge ,["FizzBait"] = math.huge ,["Blue_Minion_MechMelee"] = math.huge ,["OdinQuestBuff"] = math.huge ,["TT_Buffplat_L"] = math.huge ,["TT_Buffplat_R"] = math.huge ,["KogMawDead"] = math.huge ,["TempMovableChar"] = math.huge ,["Lizard"] = 500.0000 ,["GolemOdin"] = math.huge ,["OdinOpeningBarrier"] = math.huge ,["TT_ChaosTurret4"] = 500.0000 ,["TT_Flytrap_A"] = 500.0000 ,["TT_NWolf"] = math.huge ,["OdinShieldRelic"] = math.huge ,["LuluSquill"] = math.huge ,["redDragon"] = math.huge ,["MonkeyKingClone"] = math.huge ,["Odin_skeleton"] = math.huge ,["OdinChaosTurretShrine"] = 500.0000 ,["Cassiopeia_Death"] = 500.0000 ,["OdinCenterRelic"] = 500.0000 ,["OdinRedSuperminion"] = math.huge ,["JarvanIVWall"] = math.huge ,["ARAMOrderNexus"] = math.huge ,["Red_Minion_MechCannon"] = 1200.0000 ,["OdinBlueSuperminion"] = math.huge ,["SyndraOrbs"] = math.huge ,["LuluKitty"] = math.huge ,["SwainNoBird"] = math.huge ,["LuluLadybug"] = math.huge ,["CaitlynTrap"] = math.huge ,["TT_Shroom_A"] = math.huge ,["ARAMChaosTurretShrine"] = 500.0000 ,["Odin_Windmill_Propellers"] = 500.0000 ,["TT_NWolf2"] = math.huge ,["OdinMinionGraveyardPortal"] = math.huge ,["SwainBeam"] = math.huge ,["Summoner_Rider_Order"] = math.huge ,["TT_Relic"] = math.huge ,["odin_lifts_crystal"] = math.huge ,["OdinOrderTurretShrine"] = 500.0000 ,["SpellBook1"] = 500.0000 ,["Blue_Minion_MechCannon"] = 1200.0000 ,["TT_ChaosInhibitor_D"] = 1200.0000 ,["Odin_SoG_Chaos"] = 1200.0000 ,["TrundleWall"] = 1200.0000 ,["HA_AP_HealthRelic"] = 1200.0000 ,["OrderTurretShrine"] = 500.0000 ,["OriannaBall"] = 500.0000 ,["ChaosTurretShrine"] = 500.0000 ,["LuluCupcake"] = 500.0000 ,["HA_AP_ChaosTurretShrine"] = 500.0000 ,["TT_NWraith2"] = 750.0000 ,["TT_Tree_A"] = 750.0000 ,["SummonerBeacon"] = 750.0000 ,["Odin_Drill"] = 750.0000 ,["TT_NGolem"] = math.huge ,["AramSpeedShrine"] = math.huge ,["OriannaNoBall"] = math.huge ,["Odin_Minecart"] = math.huge ,["Summoner_Rider_Chaos"] = math.huge ,["OdinSpeedShrine"] = math.huge ,["TT_SpeedShrine"] = math.huge ,["odin_lifts_buckets"] = math.huge ,["OdinRockSaw"] = math.huge ,["OdinMinionSpawnPortal"] = math.huge ,["SyndraSphere"] = math.huge ,["Red_Minion_MechMelee"] = math.huge ,["SwainRaven"] = math.huge ,["crystal_platform"] = math.huge ,["MaokaiSproutling"] = math.huge ,["Urf"] = math.huge ,["TestCubeRender10Vision"] = math.huge ,["MalzaharVoidling"] = 500.0000 ,["GhostWard"] = 500.0000 ,["MonkeyKingFlying"] = 500.0000 ,["LuluPig"] = 500.0000 ,["AniviaIceBlock"] = 500.0000 ,["TT_OrderInhibitor_D"] = 500.0000 ,["Odin_SoG_Order"] = 500.0000 ,["RammusDBC"] = 500.0000 ,["FizzShark"] = 500.0000 ,["LuluDragon"] = 500.0000 ,["OdinTestCubeRender"] = 500.0000 ,["TT_Tree1"] = 500.0000 ,["ARAMOrderTurretShrine"] = 500.0000 ,["Odin_Windmill_Gears"] = 500.0000 ,["ARAMChaosNexus"] = 500.0000 ,["TT_NWraith"] = 750.0000 ,["TT_OrderTurret4"] = 500.0000 ,["Odin_SOG_Chaos_Crystal"] = 500.0000 ,["OdinQuestIndicator"] = 500.0000 ,["JarvanIVStandard"] = 500.0000 ,["TT_DummyPusher"] = 500.0000 ,["OdinClaw"] = 500.0000 ,["EliseSpiderling"] = 2000.0000 ,["QuinnValor"] = math.huge ,["UdyrTigerUlt"] = math.huge ,["UdyrTurtleUlt"] = math.huge ,["UdyrUlt"] = math.huge ,["UdyrPhoenixUlt"] = math.huge ,["ShacoBox"] = 1500.0000 ,["HA_AP_Poro"] = 1500.0000 ,["AnnieTibbers"] = math.huge ,["UdyrPhoenix"] = math.huge ,["UdyrTurtle"] = math.huge ,["UdyrTiger"] = math.huge ,["HA_AP_OrderShrineTurret"] = 500.0000 ,["HA_AP_Chains_Long"] = 500.0000 ,["HA_AP_BridgeLaneStatue"] = 500.0000 ,["HA_AP_ChaosTurretRubble"] = 500.0000 ,["HA_AP_PoroSpawner"] = 500.0000 ,["HA_AP_Cutaway"] = 500.0000 ,["HA_AP_Chains"] = 500.0000 ,["ChaosInhibitor_D"] = 500.0000 ,["ZacRebirthBloblet"] = 500.0000 ,["OrderInhibitor_D"] = 500.0000 ,["Nidalee_Spear"] = 500.0000 ,["Nidalee_Cougar"] = 500.0000 ,["TT_Buffplat_Chain"] = 500.0000 ,["WriggleLantern"] = 500.0000 ,["TwistedLizardElder"] = 500.0000 ,["RabidWolf"] = math.huge ,["HeimerTGreen"] = 1599.3999 ,["HeimerTRed"] = 1599.3999 ,["ViktorFF"] = 1599.3999 ,["TwistedGolem"] = math.huge ,["TwistedSmallWolf"] = math.huge ,["TwistedGiantWolf"] = math.huge ,["TwistedTinyWraith"] = 750.0000 ,["TwistedBlueWraith"] = 750.0000 ,["TwistedYoungLizard"] = 750.0000 ,["Red_Minion_Melee"] = math.huge ,["Blue_Minion_Melee"] = math.huge ,["Blue_Minion_Healer"] = 1000.0000 ,["Ghast"] = 750.0000 ,["blueDragon"] = 800.0000 ,["Red_Minion_MechRange"] = 3000, ["SRU_OrderMinionRanged"] = 650, ["SRU_ChaosMinionRanged"] = 650, ["SRU_OrderMinionSiege"] = 1200, ["SRU_ChaosMinionSiege"] = 1200, ["SRUAP_Turret_Chaos1"]  = 1200, ["SRUAP_Turret_Chaos2"]  = 1200, ["SRUAP_Turret_Chaos3"] = 1200, ["SRUAP_Turret_Order1"]  = 1200, ["SRUAP_Turret_Order2"]  = 1200, ["SRUAP_Turret_Order3"] = 1200, ["SRUAP_Turret_Chaos4"] = 1200, ["SRUAP_Turret_Chaos5"] = 500, ["SRUAP_Turret_Order4"] = 1200, ["SRUAP_Turret_Order5"] = 500 }
	self.altAANames = {"caitlynheadshotmissile", "frostarrow", "garenslash2", "kennenmegaproc", "lucianpassiveattack", "masteryidoublestrike", "quinnwenhanced", "renektonexecute", "renektonsuperexecute", "rengarnewpassivebuffdash", "trundleq", "xenzhaothrust", "xenzhaothrust2", "xenzhaothrust3"}
	self.aaresets = {"dariusnoxiantacticsonh", "fiorae", "garenq", "hecarimrapidslash", "jaxempowertwo", "jaycehypercharge", "leonashieldofdaybreak", "luciane", "monkeykingdoubleattack", "mordekaisermaceofspades", "nasusq", "nautiluspiercinggaze", "netherblade", "parley", "poppydevastatingblow", "powerfist", "renektonpreexecute", "rengarq", "shyvanadoubleattack", "sivirw", "takedown", "talonnoxiandiplomacy", "trundletrollsmash", "vaynetumble", "vie", "volibearq", "xenzhaocombotarget", "yorickspectral", "reksaiq", "riventricleave", "kalistaexpunge", "itemtitanichydracleave", "itemtiamatcleave", "gravesmove", "masochism" }
 self.bonusDamageTable = {
	["Aatrox"]		= {buffname="aatroxwpower", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Ashe"]   		= {buffname="asheqattack", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Bard"]  	 	= {buffname="bardpspiritammocount", dmg = function(target) return 30+GetLevel(myHero)*15+0.3*GetBonusAP(myHero)end},
	["Blitzcrank"]	= {buffname="powerfist", dmg = function(target) return getdmg("E",target,myHero,1,GetCastLevel(myHero,2)) end},
	["Caitlyn"]		= {buffname="caitlynheadshot", dmg = function(target) return 1.5*(GetBaseDamage(myHero)+GetBonusDmg(myHero)) end},
	["Chogath"]		= {buffname="vorpalspikes", dmg = function(target) return getdmg("E",target,myHero,1,GetCastLevel(myHero,2)) end},
	["Corki"]		= {buffname="rapidreload", dmg = function(target) return GetBaseDamage(myHero)+GetBonusDmg(myHero)+.1*(GetBaseDamage(myHero)+GetBonusDmg(myHero)) end},
	["Darius"]		= {buffname="dariusnoxiantacticsonh", dmg = function(target) return getdmg("W",target,myHero,1,GetCastLevel(myHero,1)) end},
	["Draven"]		= {buffname="dravenspinning", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Ekko"]		= {buffname="ekkoeattackbuff", dmg = function(target) return getdmg("E",target,myHero,1,GetCastLevel(myHero,2)) end},
	["Fizz"]		= {buffname="fizzseastonepassive", dmg = function(target) return getdmg("W",target,myHero,1,GetCastLevel(myHero,W)) end},
	["Garen"]		= {buffname="garenq", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Gragas"]		= {buffname="gragaswattackbuff", dmg = function(target) return getdmg("W",target,myHero,1,GetCastLevel(myHero,1))end},
	["Irelia"]		= {buffname="ireliahitenstylecharged", dmg = function(target) return getdmg("W",target,myHero,1,GetCastLevel(myHero,1)) end},
	["Jax"]			= {buffname="jaxempowertwo", dmg = function(target) return getdmg("W",target,myHero,1,GetCastLevel(myHero,1)) end},
	["Jayce"]		= {buffname="jaycepassivemeleeatack", dmg = function(target) return 40*GetCastLevel(myHero, _R)-20+.4*GetBonusAP(myHero) end},
	["Jinx"]		= {buffname="jinxq", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Kassadin"]	= {buffname="netherbladebuff", dmg = function(target) return getdmg("W",target,myHero,1,GetCastLevel(myHero,1)) end},
	["Kayle"]		= {buffname="kaylerighteousfurybuff", dmg = function(target) return getdmg("E",target,myHero,1,GetCastLevel(myHero,2)) end},
	["MasterYi"]	= {buffname="doublestrike", dmg = function(target) return getdmg("E",target,myHero,1,GetCastLevel(myHero,2)) end},
	["RekSai"]		= {buffname="reksaiq", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Rengar"]		= {buffname="rengarqbase", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Shyvana"]		= {buffname="shyvanadoubleattack", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Talon"]		= {buffname="talonnoxiandiplomacybuff", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Teemo"]		= {buffname="ToxicShot", dmg = function(target) return getdmg("E",target,myHero,1,GetCastLevel(myHero,2)) end},
	["Trundle"]		= {buffname="trundletrollsmash", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Varus"]		= {buffname="varusw", dmg = function(target) return getdmg("W",target,myHero,1,GetCastLevel(myHero,1)) end},
	["Vayne"]		= {buffname="vaynetumblebonus", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
	["Vi"]			= {buffname="vie", dmg = function(target) return getdmg("E",target,myHero,1,GetCastLevel(myHero,2)) end},
	["Volibear"]	= {buffname="volibearq", dmg = function(target) return getdmg("Q",target,myHero,1,GetCastLevel(myHero,0)) end},
  }	
  
	OMenu:Menu("FS", "Farm Settings")
	OMenu.FS:Boolean("AJ", "Attack Jungle", true)
	
	OMenu:Menu("D", "Drawings")
	OMenu.D:Boolean("LHM", "Lasthit Marker", true)
	OMenu.D:Boolean("DMAR", "Draw My Attack Range", true)
	OMenu.D:Boolean("DEAR", "Draw Enemy Attack Range", true)
	OMenu.D:Boolean("DHR", "Draw Holposition radius", true)
	
	OMenu:Menu("K", "Keys")
	OMenu.K:KeyBinding("C", "Combo Key", string.byte(" "))
	OMenu.K:KeyBinding("H", "Harass Key", string.byte("C"))
	OMenu.K:KeyBinding("LC", "LaneClear Key", string.byte("V"))
	OMenu.K:KeyBinding("LH", "LastHit Key", string.byte("X"))
	
	OMenu:Menu("TS", "TargetSelector")
	self.ts = TargetSelector(self.aarange, TARGET_LESS_CAST, DAMAGE_PHYSICAL)
	OMenu.TS:TargetSelector("TS", "TargetSelector", self.ts)
	
	OMenu:Menu("Hum", "Humanizer")
	OMenu.Hum:Slider("lhit", "Max. Movements in Last Hit", 6, 1, 20, 1)
	OMenu.Hum:Slider("lclear", "Max. Movements in Lane Clear", 6, 1, 20, 1)
	OMenu.Hum:Slider("harass", "Max. Movements in Harass", 7, 1, 20, 1)
	OMenu.Hum:Slider("combo", "Max. Movements in Combo", 8, 1, 20, 1)
	OMenu.Hum:Slider("perm", "Persistant Max. Movements", 7, 1, 20, 1)
	
	Callback.Add("ProcessSpellAttack", function(unit,spellProc) self:PrAtt(unit,spellProc) end)
	Callback.Add("Animation", function(unit,animation) self:Animation(unit,animation) end)
	Callback.Add("ProcessSpell", function(unit,spellProc) self:PrSp(unit,spellProc) end)
	Callback.Add("Tick", function(unit,spellProc) self:T(unit,spellProc) end)
	Callback.Add("Draw", function(unit,spellProc) self:D(unit,spellProc) end)
	Callback.Add("IssueOrder", function(order) self:IssOrd(order) end)
end

function SLWalker:T()
if not SLW then return end
self.ts.range = self.aarange
self:Orb()
end

function SLWalker:D()
if not SLW then return end
	if OMenu.D.DMAR:Value() then
		DrawCircle(myHero.pos,self.aarange,1,20,GoS.Green)
	end
	for _,k in pairs(GetEnemyHeroes()) do
		if OMenu.D.DEAR:Value() then
			DrawCircle(k.pos,k.range+k.boundingRadius*2,1,20,GoS.Red)
		end		
	end
	if OMenu.D.DHR:Value() then
		DrawCircle(myHero.pos,myHero.boundingRadius,1,20,GoS.Blue)
	end
	if OMenu.D.LHM:Value() then
		for _,i in pairs(minionManager.objects) do
			if self:Mode() == "LaneClear" then
				if i.distance < self.aarange and i.alive and i.team ~= MINION_ALLY and self:PredictHP(i,(1000/(myHero.attackSpeed*self.BaseAttackSpeed)*GetDistance(i)/self:aaprojectilespeed())) < CalcPhysicalDamage(myHero, i, self:Dmg(i)*2) and AllyMinionsAround(myHero.pos, self.aarange) >= 3 then
					DrawCircle(i.pos,i.boundingRadius*1.2,1,20,ARGB(255,255,128,0))
				end
			end
			if self:Mode() == "LaneClear" or self:Mode() == "LastHit" then
				if i.distance < self.aarange and i.alive and i.team ~= MINION_ALLY and self:PredictHP(i,(1000/(myHero.attackSpeed*self.BaseAttackSpeed)*GetDistance(i)/self:aaprojectilespeed())) < CalcPhysicalDamage(myHero, i, self:Dmg(i)) and AllyMinionsAround(myHero.pos, self.aarange) >= 3 then
					DrawCircle(i.pos,i.boundingRadius*1.2,1,20,GoS.Green)
				end
			end
		end
	end	
end

function SLWalker:PredictHP(unit,time)
	return self:GetPredictedHealth(unit,time)
end

function SLWalker:Dmg(unit)
	if self.bonusDamageTable[myHero.charName] then
		if GotBuff(myHero,self.bonusDamageTable[myHero.charName].buffname)>0 then
			return self.bonusDamageTable[myHero.charName].dmg(unit)
		else
			return GetBonusDmg(myHero)+GetBaseDamage(myHero)
		end
	else
		return GetBonusDmg(myHero)+GetBaseDamage(myHero)
	end		
	if self.bonusDamageTable[unit.charName] then
		if GotBuff(unit,self.bonusDamageTable[unit.charName].buffname)>0 then
			return self.bonusDamageTable[unit.charName].dmg(unit)
		else
			return GetBonusDmg(unit)+GetBaseDamage(unit)
		end
	else
		return GetBonusDmg(unit)+GetBaseDamage(unit)
	end	
end

function SLWalker:moveEvery()
	if self:Mode() == "Combo" then
		return 1 / OMenu.Hum.combo:Value()
	elseif self:Mode() == "LastHit" then
		return 1 / OMenu.Hum.lhit:Value()
	elseif self:Mode() == "Harass" then
		return 1 / OMenu.Hum.harass:Value()
	elseif self:Mode() == "LaneClear" then
		return 1 / OMenu.Hum.lclear:Value()
	else
		return 1 / OMenu.Hum.perm:Value()
	end
end

function SLWalker:IssOrd(order)
if not SLW then return end
	if order.flag == 2 then
		if os.clock() - self.LastMoveOrder < self:moveEvery() then
		  BlockOrder()
		else
		  self.LastMoveOrder = os.clock()
		end
	end
end

function SLWalker:GetLowestMinion(i)
  local t, p = nil, math.huge
	if i and i.team ~= myHero.team then
		if ValidTarget(i, self.aarange) and i.health < p then
			t = i
			p = i.health
		end
	end
  return t
end

function SLWalker:GetHighestMinion(i)
  local t = nil
	if i and i.team ~= myHero.team then
		if ValidTarget(i, self.aarange) and not t or GetMaxHP(i) > GetMaxHP(t) then
			t = i
		end
	end
  return t
end

function SLWalker:PrAtt(unit, spellProc)
if not SLW then return end
	if unit.isMe and spellProc then
		if self:Attack(spellProc) then
			self.LastAttack = self:Time()-GetLatency()/2
			self.windUpTime = spellProc.windUpTime * 1000
			self.animationTime = spellProc.animationTime * 1000
			self.AttackDoneAt = self.windUpTime + self.LastAttack

			self.BaseWindUp = 1 / (spellProc.windUpTime * GetAttackSpeed(myHero))
			self.BaseAttackSpeed = 1 / (spellProc.animationTime * GetAttackSpeed(myHero))
			
		elseif self:AAReset(spellProc) then
			self:ResetAA()
		end
	end
end

function SLWalker:GetAggro(unit)
    if unit.spellProc and unit.spellProc.target then
        return unit.spellProc.target
    else
        return minionTar[unit.networkID] and minionTar[unit.networkID] or nil
    end
end

function SLWalker:ResetAA()
	self.LastAttack = 0
end

function SLWalker:Attack(spellProc)
	if spellProc.name:lower():find("attack") then return true end
	for _,v in pairs(self.altAANames) do
		if v == spellProc.name:lower() then 
			return true 
		end
	end
	return false
end

function SLWalker:AAReset(spellProc)
	for _, v in pairs(self.aaresets) do
		if v == spellProc.name:lower() then 
			return true 
		end
	end
	return false
end

function SLWalker:Time()
	return os.clock()*1000
end

function SLWalker:CanMove()
	if not self.movementEnabled then 
		return 
	end
	return self:Time() + GetLatency()*.5 - self.LastAttack >= (1000/(GetAttackSpeed(myHero)*self.BaseWindUp))
end

function SLWalker:CanAttack()
	if not self.attacksEnabled then 
		return 
	end
	return self:Time() + GetLatency()*.5 - self.LastAttack >= (1000/(GetAttackSpeed(myHero)*self.BaseAttackSpeed))
end

function SLWalker:IsOrbwalking()
	if (OMenu.K.C:Value() or OMenu.K.H:Value() or OMenu.K.LH:Value() or OMenu.K.LC:Value()) then 
		return true 
	end
end

function SLWalker:CanOrb(t)
	if not t and not t.visible and not t.targetable and not t.alive then
		return false
	end
	return true 
end


function SLWalker:Mode()
	if OMenu.K.C:Value() then 
		return "Combo" 
	end
	if OMenu.K.H:Value() then 
		return "Harass" 
	end
	if OMenu.K.LH:Value() then 
		return "LastHit" 
	end
	if OMenu.K.LC:Value() then 
		return "LaneClear" 
	end
end

function SLWalker:JungleClear()
	for _,o in pairs(minionManager.objects) do
		if OMenu.FS.AJ:Value() and o.team == MINION_JUNGLE and ValidTarget(o,self.aarange) and self:CanOrb(o) then
			if self:PredictHP(o,(1000/(myHero.attackSpeed*self.BaseAttackSpeed)*GetDistance(o)/self:aaprojectilespeed())) < CalcPhysicalDamage(myHero, o, self:Dmg(o)) then
				return nil
			else
				return self:GetHighestMinion(o)
			end
		end
	end
end

function SLWalker:LaneClear()
	for _,o in pairs(minionManager.objects) do
		if o.team == MINION_ENEMY and ValidTarget(o,self.aarange) and self:CanOrb(o) and AllyMinionsAround(myHero.pos, self.aarange) >= 3 then
			if self:PredictHP(o,(1000/(myHero.attackSpeed*self.BaseAttackSpeed)*GetDistance(o)/self:aaprojectilespeed())) < CalcPhysicalDamage(myHero, o, self:Dmg(o)*2) then
				return nil
			else
				return self:GetLowestMinion(o)
			end
		elseif o.team == MINION_ENEMY and ValidTarget(o,self.aarange) and self:CanOrb(o) and AllyMinionsAround(myHero.pos, self.aarange) <= 3 then
			if self:PredictHP(o,(1000/(myHero.attackSpeed*self.BaseAttackSpeed)*GetDistance(o)/self:aaprojectilespeed())) < CalcPhysicalDamage(myHero, o, self:Dmg(o)) then
				return nil
			else
				return self:GetLowestMinion(o)
			end
		end
	end
end

function SLWalker:LastHit()
	for _,o in pairs(minionManager.objects) do
		if o.team ~= MINION_ALLY and ValidTarget(o,self.aarange) and self:CanOrb(o) then
			if self:PredictHP(o,(1000/(myHero.attackSpeed*self.BaseAttackSpeed)*GetDistance(o)/self:aaprojectilespeed())) < CalcPhysicalDamage(myHero, o, self:Dmg(o)) then
				 return self:GetLowestMinion(o)
			end
		end
	end
end

function SLWalker:Combo()
	if self.ts:GetTarget() then
		if self:CanOrb(self.ts:GetTarget()) and ValidTarget(self.ts:GetTarget(),self.aarange) then
			return self.ts:GetTarget() 
		end
	end
end

function SLWalker:Harass()
	for _,o in pairs(minionManager.objects) do
		if self.ts:GetTarget() then
			if self:CanOrb(self.ts:GetTarget()) and ValidTarget(self.ts:GetTarget(),self.aarange)then
				if self.ts:GetTarget().health < CalcPhysicalDamage(myHero, self.ts:GetTarget(), self:Dmg(o)) then
					return nil
				else			
					return self.ts:GetTarget()
				end
			end
		end
		if o and o.team == MINION_ENEMY then
			if self:CanOrb(o) and ValidTarget(o,self.aarange)then
				if self:PredictHP(o,(1000/(myHero.attackSpeed*self.BaseAttackSpeed)*GetDistance(o)/self:aaprojectilespeed())) < CalcPhysicalDamage(myHero, o, self:Dmg(o)) then
					return self:GetLowestMinion(o)
				end
			end
		end
	end
end

function SLWalker:GetTarget()
	if self:Mode() == "Combo" then
	  return self:Combo()
	elseif self:Mode() == "Harass" then
	  return self:LastHit() or self:Harass() 
	elseif self:Mode() == "LastHit" then
	  return self:LastHit()
	elseif self:Mode() == "LaneClear" then
	  return self:LastHit() or self:LaneClear() or self:JungleClear()
	else
	  return nil
	end
end

function SLWalker:Orb()
	if not self:IsOrbwalking() then return end
	if self:CanMove() or self:CanAttack() then
		if self:CanAttack() then
			if self:GetTarget() then
				AttackUnit(self:GetTarget())
			elseif self:CanMove() and GetDistance(myHero, GetMousePos()) > myHero.boundingRadius then
					MoveToXYZ(GetMousePos())
			end
		elseif self:CanMove() and GetDistance(myHero, GetMousePos()) > myHero.boundingRadius then
				MoveToXYZ(GetMousePos())
		end
		if GetDistance(myHero, GetMousePos()) < myHero.boundingRadius then
			self.movementEnabled = false
		else
			self.movementEnabled = true
		end
	end
end

function SLWalker:aaprojectilespeed()
	return (self.projectilespeeds[myHero.charName] and self.projectilespeeds[myHero.charName] or math.huge) or math.huge
end

function SLWalker:Animation(unit, animation)
if not SLW then return end
    if unit and unit.valid and unit ~= myHero and unit.team == myHero.team and animation:lower():find("atta") and not self.projectilespeeds[unit.charName] then
        local time = os.clock() + 0.393 - GetLatency()/2000
        local tar = self:GetAggro(unit)
        if tar then
            table.insert(self.ActiveAttacks, {Attacker = unit, pos = Vector(unit), Target = tar, animationTime = math.huge, damage = self:Dmg(unit), hittime=time, starttime = self:GetTime() - GetLatency()/2000, windUpTime = 0.393, projectilespeed = math.huge})
        end
    end
end

function SLWalker:PrSp(unit, spellProc)
if not SLW then return end
    if unit and unit.valid and spellProc.target and unit.type ~= myHero.type and spellProc.target.type == 'obj_AI_Minion' and unit.team == myHero.team and spellProc and spellProc.name and (spellProc.name:lower():find("attack") or (spellProc.name == "frostarrow")) and spellProc.windUpTime and spellProc.target then
        if GetDistanceSqr(unit) < 4000000 then
            if self.projectilespeeds[unit.charName] then
                local time = self:GetTime() + GetDistance(spellProc.target, unit) / self.projectilespeeds[unit.charName] - GetLatency()/2000
                local i = 1
                while i <= #self.ActiveAttacks do
                    if (self.ActiveAttacks[i].Attacker and self.ActiveAttacks[i].Attacker.valid and self.ActiveAttacks[i].Attacker.networkID == unit.networkID) or ((self.ActiveAttacks[i].hittime + 3) < self:GetTime()) then
                        table.remove(self.ActiveAttacks, i)
                    else
                        i = i + 1
                    end
                end
                table.insert(self.ActiveAttacks, {Attacker = unit, pos = Vector(unit), Target = spellProc.target, animationTime = spellProc.animationTime, damage = CalcPhysicalDamage(unit, spellProc.target, self:Dmg(unit)), hittime=time, starttime = self:GetTime() - GetLatency()/2000, windUpTime = spellProc.windUpTime, projectilespeed = self.projectilespeeds[unit.charName]})
            else
                minionTar[unit.networkID] = spellProc.target
            end
        end
    end
end

function SLWalker:GetTime()
	return os.clock()
end

function SLWalker:GetPredictedHealth(unit, time)
    local IncDamage = 0
    local i = 1
    local MaxDamage = 0
    local count = 0

    while i <= #self.ActiveAttacks do
        if self.ActiveAttacks[i].Attacker and not self.ActiveAttacks[i].Attacker.dead and self.ActiveAttacks[i].Target and self.ActiveAttacks[i].Target.networkID == unit.networkID then
            local hittime = (self.ActiveAttacks[i].windUpTime + self.ActiveAttacks[i].animationTime + GetLatency()) - self.ActiveAttacks[i].starttime + GetDistance(self.ActiveAttacks[i].Attacker,self.ActiveAttacks[i].Target) / self.ActiveAttacks[i].projectilespeed
            if self:GetTime() < hittime and hittime < self:GetTime() + time  then
                IncDamage = IncDamage + self.ActiveAttacks[i].damage
                count = count + 1
                if self.ActiveAttacks[i].damage > MaxDamage then
                    MaxDamage = self.ActiveAttacks[i].damage
                end
            end
        end
        i = i + 1
    end
    return unit.health - IncDamage, MaxDamage, count
end

class 'SLWAutoUpdater'

function SLWAutoUpdater:__init()
if not SLW then return end
	function SLWUpdater(data)
	  if not SLWAutoUpdate then return end
		if tonumber(data) > tonumber(SLWalkerVer) then
			PrintChat("<font color=\"#fd8b12\"><b>[SL-Walker] - <font color=\"#F2EE00\">New Version found ! "..data.."</b></font>")
			PrintChat("<font color=\"#fd8b12\"><b>[SL-Walker] - <font color=\"#F2EE00\">Downloading Update... Please wait</b></font>")
			DownloadFileAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Walker.lua", SCRIPT_PATH .. "SL-Walker.lua", function() PrintChat("<font color=\"#fd8b12\"><b>[SL-Walker] - <font color=\"#F2EE00\">Reload the Script with 2x F6</b></font>") return	end)
		end
	end
  GetWebResultAsync("https://raw.githubusercontent.com/xSxcSx/SL-Series/master/SL-Walker.version", SLWUpdater)
end

function LoadSLW()
if not _G.SLW then _G.SLW = SLWalker() end
return SLW
end
