local mod	= DBM:NewMod("Malacrass", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(24239)
mod:RegisterCombat("combat_yell", L.YellPull)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
	-- ,"SPELL_SUMMON"
)

--TODO, GTFO for standing in shit
local warnSiphon				= mod:NewTargetAnnounce(2136107, 3) --2136107, 
local warnBoltSoon				= mod:NewPreWarnAnnounce(2136100, 5, 3) --2136100, 2136101, 2136102, 2136103, 2136104
local warnHeal1					= mod:NewCastAnnounce(2136150, 3)
local warnHeal2					= mod:NewCastAnnounce(2136156, 3)
local warnHeal3					= mod:NewCastAnnounce(43431, 3)
local warnHeal4					= mod:NewTargetAnnounce(43421, 3)
local warnPatch					= mod:NewSpellAnnounce(43429, 3)

local specWarnBolt				= mod:NewSpecialWarningSpell(2136100)
local specWarnHeal				= mod:NewSpecialWarning("Interrupt Heal!")--#NewInterruptAnnounce(43548)
local specWarnBlindingLight		= mod:NewSpecialWarning("Look Away!")
-- local specWarnHeal2				= mod:NewSpecialWarning("Interrupt Heal!")--mod:NewInterruptAnnounce(43451)
-- local specWarnHeal3				= mod:NewSpecialWarning("Interrupt Heal!")--mod:NewInterruptAnnounce(43431)
-- local specWarnHeal4				= mod:NewSpecialWarning("Dispel!")--mod:NewSpecialWarningDispel(43421)
-- local specWarnTotem				= mod:NewSpecialWarning("Switch targets!")--mod:NewSpecialWarningSwitch(43436)

local timerSiphon				= mod:NewTargetTimer(30, 2136107)
local timerNextBolt				= mod:NewNextTimer(50, 2136100)
local timerBolt					= mod:NewCastTimer(10, 2136100)
local timerPatch				= mod:NewCastTimer(20, 43429)

local timerNextDrain			= mod:NewNextTimer(60, 2136100)

local warnDruidSoul				= mod:NewSpecialWarning("Druid Soul Absorbed")
local timerNextTranquility		= mod:NewNextTimer(5, 2136126) 
local timerCastTranquility		= mod:NewCastTimer(10, 2136126)

local warnHunterSoul			= mod:NewSpecialWarning("Hunter Soul Absorbed")
local timerNextMultiShot		= mod:NewNextTimer(5, 2136127)
local timerNextFeign			= mod:NewNextTimer(15, 2136128)
local timerNextExplosiveTrap	= mod:NewNextTimer(20, 2136131) --2136129, 2136130, 2136131, 2136132, 2136133, 2136134
local timerNextBestialWrath		= mod:NewNextTimer(25, 2136135) --2136135
local timerBestialWrath			= mod:NewTargetTimer(10, 2136135)


local warnMageSoul				= mod:NewSpecialWarning("Mage Soul Absorbed")
local timerNextRuneOfPower		= mod:NewNextTimer(5, 2136136) --2136136
local timerRuneOfPower			= mod:NewTargetTimer(6, 2136136) --2136136
local timerRuneOfPowerduration	= mod:NewTimer(10, "Rune of Power duration", 2136136)
local timerNextBlizzard			= mod:NewNextTimer(15, 2136137) --2136137, 2136138, 2136139, 2136140
local timerNextLivingBomb		= mod:NewNextTimer(25, 2136141) --Dot: 2136141, 2136142, 2136143, 2136144,       Explosion damage: 2136145, 2136146, 2136147, 2136148
local timerLivingBomb			= mod:NewTargetTimer(12, 2136141) --2136141

local warnPaladinSoul			= mod:NewSpecialWarning("Paladin Soul Absorbed")
local timerNextBlindingLight	= mod:NewNextTimer(5, 2136155)
local timerCastBlindingLight	= mod:NewCastTimer(2, 2136155)
local timerNextConsecration		= mod:NewNextTimer(15, 2136151) --2136151, #2136152, #2136153, #2136154
local timerNextDivineShield		= mod:NewNextTimer(25, 2136149)
local timerCastHearthstone		= mod:NewCastTimer(6, 2136150)

local warnPriestSoul			= mod:NewSpecialWarning("Priest Soul Absorbed")
local timerNextDivinePrayer		= mod:NewNextTimer(5, 2136156) 
local timerCastDivinePrayer		= mod:NewCastTimer(4, 2136156)
local timerNextDomination		= mod:NewNextTimer(15, 2136157) --2136157, 2136158
local timerNextManaBurn			= mod:NewNextTimer(25, 2136159) --2136159, 2136160, 2136161, 2136162
local timerDomination			= mod:NewTargetTimer(10, 2136157)

local warnRogueSoul				= mod:NewSpecialWarning("Rogue Soul Absorbed")
local timerNextFanofKnives		= mod:NewNextTimer(5, 2136164) --2136163, 2136164
local timerNextSmokeBomb		= mod:NewNextTimer(15, 2136165) --2136165, 2136166
local timerNextDismantle		= mod:NewNextTimer(25, 2136167)
local timerDismantle			= mod:NewTargetTimer(6, 2136167)

local warnShamanSoul			= mod:NewSpecialWarning("Shaman Soul Absorbed")
local timerNextEarthQuake		= mod:NewNextTimer(5, 2136168) --2136168, 2136169, 2136170, 2136171
local timerNextThunderStorm		= mod:NewNextTimer(15, 2136172) --2136172, 2136173, 2136174, 2136175
local timerNextChainHeal		= mod:NewNextTimer(25, 2136176) --2136176
local timerCastChainHeal		= mod:NewCastTimer(3, 2136176)

local warnWarlockSoul			= mod:NewSpecialWarning("Warlock Soul Absorbed")
local timerNextCurseOfDoom		= mod:NewNextTimer(5, 2136177) --2136177, 2136178, 2136179, 2136180
local timerCurseOfDoom			= mod:NewTargetTimer(15, 2136177)
local timerNextRainofFire		= mod:NewNextTimer(15, 2136186) --2136186, 2136187, 2136188, 2136189
local timerNextHellfire			= mod:NewNextTimer(25, 2136181) --2136181, 2136182, 2136183, 2136184, 2136185
local specWarnRainofFire		= mod:NewSpecialWarningRun(2136182)
local specWarnHellfire			= mod:NewSpecialWarningRun(2136186)

local warnWarriorSoul			= mod:NewSpecialWarning("Warrior Soul Absorbed")
local timerNextSpellReflect		= mod:NewNextTimer(5, 2136190) --2136190
local timerNextHeroicLeap		= mod:NewNextTimer(15, 2136191) --2136191, 2136192
local timerNextColossusSmash	= mod:NewNextTimer(25, 2136193) --2136193
local timerColossusSmash		= mod:NewTargetTimer(6, 2136193) --2136193
local timerSpellReflect			= mod:NewTargetTimer(6, 2136190) --2136190

function mod:OnCombatStart(delay)
	timerNextBolt:Start(10)
	warnBoltSoon:Schedule(5)
	timerNextDrain:Start(20)
end

function mod:SPELL_AURA_APPLIED(args)
	-- if args:IsSpellID(2136107) then -- This spams everyone, don't add
	-- 	warnSiphon:Show(args.destName) 
	-- 	timerSiphon:Show(args.destName)
	if args:IsSpellID(2136114) then
		warnDruidSoul:Show()
		timerNextTranquility:Start()
	elseif args:IsSpellID(2136115) then
		warnHunterSoul:Show()
		timerNextMultiShot:Start()
		timerNextFeign:Start()
		timerNextExplosiveTrap:Start()
		timerNextBestialWrath:Start()
	elseif args:IsSpellID(2136135) then
		timerBestialWrath:Show(args.destName)
	elseif args:IsSpellID(2136116) then
		warnMageSoul:Show()
		timerNextRuneOfPower:Start()
		timerNextBlizzard:Start()
		timerNextLivingBomb:Start()
	elseif args:IsSpellID(2136136) and args.destName == "Malacrass" then
		timerRuneOfPower:Show(args.destName)
		timerRuneOfPowerduration:Start()
	elseif args:IsSpellID(2136141) then
		timerLivingBomb:Show(args.destName)
	elseif args:IsSpellID(2136137, 2136138, 2136139, 2136140) then
		specWarnRainofFire:Show()
	elseif args:IsSpellID(2136117) then
		warnPaladinSoul:Show()
		timerNextBlindingLight:Start()
		timerNextConsecration:Start()
		timerNextDivineShield:Start()
	elseif args:IsSpellID(2136118) then
		warnPriestSoul:Show()
		timerNextDivinePrayer:Start()
		timerNextDomination:Start()
		timerNextManaBurn:Start()
	elseif args:IsSpellID(2136157) then
		timerDomination:Show()
	elseif args:IsSpellID(2136119) then
		warnRogueSoul:Show()
		timerNextFanofKnives:Start()
		timerNextSmokeBomb:Start()
		timerNextDismantle:Start()
	elseif args:IsSpellID(2136167) then
		timerDismantle:Show(args.destName)
	elseif args:IsSpellID(2136120) then
		warnShamanSoul:Show()
		timerNextEarthQuake:Start()
		timerNextThunderStorm:Start()
		timerNextChainHeal:Start()
	elseif args:IsSpellID(2136121) then
		warnWarlockSoul:Show()
		timerNextCurseOfDoom:Start()
		timerNextHellfire:Start()
		timerNextRainofFire:Start()
	elseif args:IsSpellID(2136177, 2136178, 2136179, 2136180) then
		timerCurseOfDoom:Show(args.destName)
	elseif args:IsSpellID(2136186, 2136187, 2136188, 2136189) then
		specWarnRainofFire:Show()
	elseif args:IsSpellID(2136182, 2136183, 2136184, 2136185) then
		specWarnHellfire:Show()
	elseif args:IsSpellID(2136122) then
		warnWarriorSoul:Show()
		timerNextSpellReflect:Start()
		timerNextHeroicLeap:Start()
		timerNextColossusSmash:Start()
	elseif args:IsSpellID(2136190) then
		timerSpellReflect:Show(args.destName)
	elseif args:IsSpellID(2136193) then
		timerColossusSmash:Show(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2136150) then
		timerCastHearthstone:Start()
		specWarnHeal:Show()
	elseif args:IsSpellID(2136156) then
		timerCastDivinePrayer:Start()
		specWarnHeal:Show()
	elseif args:IsSpellID(2136126) then
		timerCastTranquility:Start()
		specWarnHeal:Show()
	elseif args:IsSpellID(2136176) then
		timerCastChainHeal:Start()
		specWarnHeal:Show()
	elseif args:IsSpellID(2136155) then
		timerCastBlindingLight:Start()
		specWarnBlindingLight:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2136100) then --2136101, 2136102, 2136103, 2136104
		specWarnBolt:Show()
		warnBoltSoon:Schedule(35)
		timerBolt:Start()
		timerNextBolt:Start()
		timerNextDrain:Schedule(10)
	end
end

-- function mod:SPELL_SUMMON(args)
-- 	if args:IsSpellID(43436) then
-- 		specWarnTotem:Show()
-- 	end
-- end
