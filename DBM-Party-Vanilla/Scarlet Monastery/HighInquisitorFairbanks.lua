local mod	= DBM:NewMod("Fairbanks", "DBM-Party-Vanilla", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4542)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

local warningCurseofBlood			= mod:NewTargetAnnounce(8282, 2, nil, "RemoveCurse")

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(8282) then
		warningCurseofBlood:Show(args.destName)
	end
end
