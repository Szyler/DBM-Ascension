local mod	= DBM:NewMod("Gilnid", "DBM-Party-Vanilla", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(1763)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningMoltenMetal	= mod:NewTargetNoFilterAnnounce(5213, 2)

local timerMoltenMetalCD	= mod:NewAITimer(180, 5213, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerMoltenMetalCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(5213) then
		timerMoltenMetalCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(5213) then
		warningMoltenMetal:Show(args.destName)
	end
end
