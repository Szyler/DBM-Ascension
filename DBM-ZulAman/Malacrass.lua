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
local warnSiphon				= mod:NewTargetAnnounce(43501, 3)
local warnBoltSoon				= mod:NewPreWarnAnnounce(43383, 5, 3)
local warnHeal1					= mod:NewCastAnnounce(43548, 3)
local warnHeal2					= mod:NewCastAnnounce(43451, 3)
local warnHeal3					= mod:NewCastAnnounce(43431, 3)
local warnHeal4					= mod:NewTargetAnnounce(43421, 3)
local warnPatch					= mod:NewSpellAnnounce(43429, 3)

local specWarnBolt				= mod:NewSpecialWarningSpell(43383)
local specWarnHeal				= mod:NewSpecialWarning("Interrupt Heal!")--#NewInterruptAnnounce(43548)
-- local specWarnHeal2				= mod:NewSpecialWarning("Interrupt Heal!")--mod:NewInterruptAnnounce(43451)
-- local specWarnHeal3				= mod:NewSpecialWarning("Interrupt Heal!")--mod:NewInterruptAnnounce(43431)
-- local specWarnHeal4				= mod:NewSpecialWarning("Dispel!")--mod:NewSpecialWarningDispel(43421)
-- local specWarnTotem				= mod:NewSpecialWarning("Switch targets!")--mod:NewSpecialWarningSwitch(43436)

local timerSiphon				= mod:NewTargetTimer(30, 43501)
local timerNextBolt				= mod:NewNextTimer(50, 43383)
local timerBolt					= mod:NewCastTimer(10, 43383)
local timerPatch				= mod:NewCastTimer(20, 43429)

local timerNextDrain			= mod:NewNextTimer(50, 43383)

local warnDruidSoul				= mod:NewSpecialWarning("Druid Soul Absorbed")
local timerNextTranquility		= mod:NewNextTimer(5, 2136126) 
local timerCastTranquility		= mod:NewCastTimer(10, 2136126)

local warnHunterSoul			= mod:NewSpecialWarning("Hunter Soul Absorbed")
local timerNextMultiShot		= mod:NewNextTimer(5, 2136127)
local timerNextFeign			= mod:NewNextTimer(15, 2136128)
local timerNextExplosiveTrap	= mod:NewNextTimer(20, 2136131) --2136129, 2136130, 2136131, 2136132, 2136133, 2136134


local warnMageSoul				= mod:NewSpecialWarning("Mage Soul Absorbed")

local warnPaladinSoul			= mod:NewSpecialWarning("Paladin Soul Absorbed")
local timerNextBlindingLight	= mod:NewNextTimer(5, 2136155)
local timerNextConsecration		= mod:NewNextTimer(15, 2136151) --2136151, #2136152, #2136153, #2136154
local timerNextDivineShield		= mod:NewNextTimer(25, 2136149)
local timerCastHearthstone		= mod:NewCastTimer(6, 2136150)

local warnPriestSoul			= mod:NewSpecialWarning("Priest Soul Absorbed")
local timerNextDivinePrayer		= mod:NewNextTimer(5, 2136156) 
local timerCastDivinePrayer		= mod:NewCastTimer(4, 2136156)
local timerNextDomination		= mod:NewNextTimer(15, 2136157) --2136157, 2136158
local timerNextManaBurn			= mod:NewNextTimer(25, 2136159)--2136159, 2136160, 2136161, 2136162

local warnRogueSoul				= mod:NewSpecialWarning("Rogue Soul Absorbed")
local timerNextFanofKnives		= mod:NewNextTimer(5, 2136164) --2136163, 2136164
local timerNextSmokeBomb		= mod:NewNextTimer(15, 2136165) --2136165, 2136166
local timerNextDismantle		= mod:NewNextTimer(25, 2136167)

local warnShamanSoul			= mod:NewSpecialWarning("Shaman Soul Absorbed")

local warnWarlockSoul			= mod:NewSpecialWarning("Warlock Soul Absorbed")

local warnWarriorSoul			= mod:NewSpecialWarning("Warrior Soul Absorbed")

function mod:OnCombatStart(delay)
	timerNextBolt:Start(8)
	warnBoltSoon:Schedule(5)
	timerNextDrain:Start(18)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43501) then
		warnSiphon:Show(args.destName)
		timerSiphon:Show(args.destName)
	elseif args:IsSpellID(43421) and not args:IsDestTypePlayer() then
		warnHeal4:Show(args.destName)
		
	elseif args:IsSpellID(2136114) then
		warnDruidSoul:Show()
		timerNextTranquility:Start()
	elseif args:IsSpellID(2136115) then
		warnHunterSoul:Show()
		timerNextMultiShot:Start()
		timerNextFeign:Start()
		timerNextExplosiveTrap:Start()
	elseif args:IsSpellID(2136116) then
		warnMageSoul:Show()
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
	elseif args:IsSpellID(2136119) then
		warnRogueSoul:Show()
		timerNextFanofKnives:Start()
		timerNextSmokeBomb:Start()
		timerNextDismantle:Start()
	elseif args:IsSpellID(2136120) then
		warnShamanSoul:Show()
	elseif args:IsSpellID(2136121) then
		warnWarlockSoul:Show()
	elseif args:IsSpellID(2136122) then
		warnWarriorSoul:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2136150) then
		timerCastHearthstone:Start()
		warnHeal:Show()
	elseif args:IsSpellID(2136156) then
		timerCastDivinePrayer:Start()
		warnHeal:Show()
	elseif args:IsSpellID(2136126) then
		timerCastTranquility:Start()
		warnHeal:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43383) then
		specWarnBolt:Show()
		warnBoltSoon:Schedule(35)
		timerBolt:Start()
		timerNextBolt:Start()
	elseif args:IsSpellID(43329) then
		warnPatch:Show()
		timerPatch:Start()
	end
end

-- function mod:SPELL_SUMMON(args)
-- 	if args:IsSpellID(43436) then
-- 		specWarnTotem:Show()
-- 	end
-- end
