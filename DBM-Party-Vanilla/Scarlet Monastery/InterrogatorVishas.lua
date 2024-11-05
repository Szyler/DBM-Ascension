local mod	= DBM:NewMod("InterrogatorVishas", "DBM-Party-Vanilla", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3983)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningImmolate				= mod:NewTargetAnnounce(9034, 2)

local timerImmolateCD				= mod:NewCDTimer(180, 9034)

function mod:OnCombatStart(delay)
	timerImmolateCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(9034) then
		timerImmolateCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(9034) then
		warningImmolate:Show(args.destName)
	end
end
