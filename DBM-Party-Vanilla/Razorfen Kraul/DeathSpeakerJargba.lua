local mod	= DBM:NewMod("DeathSpeakerJargba", "DBM-Party-Vanilla", 11)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4428)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningMCCast			= mod:NewCastAnnounce(14515, 3)
local warningMC				= mod:NewTargetAnnounce(14515, 4, nil, false, 2)--Don't want to announce the MC cast AND the target, 2 second apart warnings for same thing is not agreeable in classic (by default)

local timerMCCD				= mod:NewCDTimer(180, 14515)

function mod:OnCombatStart(delay)
--	timerMCCD:Start(6-delay)--Cast Start
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(14515) then
		warningMCCast:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(14515) then
		timerMCCD:Start()--From Success to start when final, but while AI, success to success :\
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(14515) then
		warningMC:Show(args.destName)
	end
end
