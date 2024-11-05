local mod	= DBM:NewMod(489, "DBM-Party-Vanilla", 20, 241)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7267)--7797/ruuzlu

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

--TODO, Add cleave timer?
local warningEnrage			= mod:NewTargetAnnounce(8269, 2)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(8269) then
		warningEnrage:Show(args.destName)
	end
end
