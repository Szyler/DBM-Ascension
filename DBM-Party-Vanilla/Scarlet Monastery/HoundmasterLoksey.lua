local mod	= DBM:NewMod("HoundmasterLoksey", "DBM-Party-Vanilla", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3974)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED"
)

local warningBloodLust		= mod:NewTargetNoFilterAnnounce(6742, 2)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(6742) then
		warningBloodLust:Show(args.destName)
	end
end
